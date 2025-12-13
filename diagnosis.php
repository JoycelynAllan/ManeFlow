
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once 'config/db.php';


// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$isViewingChild = false;
$childInfo = null;
$error = null;
$profile = null;
$allSymptoms = [];
$pastDiagnoses = [];

try {
    $conn = getDBConnection();

    if (isset($_GET['child_id'])) {
        $childId = (int)$_GET['child_id'];
        
        // Verify this child belongs to the current user (parent) using direct query
        // Replacing stored procedure to avoid issues on servers without routine permissions
        $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
        $verifyStmt->bind_param("ii", $childId, $userId);
        $verifyStmt->execute();
        $verifyResult = $verifyStmt->get_result();
        $isValid = $verifyResult->num_rows > 0;
        $verifyStmt->close();
        
        if ($isValid) {
            $userId = $childId; // Switch context to child
            $isViewingChild = true;
            
            // Get child name and DOB
            $childNameStmt = $conn->prepare("SELECT first_name, date_of_birth FROM users WHERE user_id = ?");
            $childNameStmt->bind_param("i", $childId);
            $childNameStmt->execute();
            $childInfo = $childNameStmt->get_result()->fetch_assoc();
            $childNameStmt->close();
        } else {
            header('Location: children.php?error=unauthorized');
            exit;
        }
    }
    
    // Determine User/Child DOB and Age Group
    $userDob = null;
    if ($isViewingChild && $childInfo) {
        $userDob = $childInfo['date_of_birth'];
    } else {
         // Get user DOB
         $userStmt = $conn->prepare("SELECT date_of_birth FROM users WHERE user_id = ?");
         $userStmt->bind_param("i", $_SESSION['user_id']); // Use session user_id for parent's DOB
         $userStmt->execute();
         $userResult = $userStmt->get_result()->fetch_assoc();
         $userDob = $userResult['date_of_birth'] ?? null;
         $userStmt->close();
    }

    $ageGroup = 'adult'; // Default
    if ($userDob) {
        $age = (new DateTime())->diff(new DateTime($userDob))->y;
        if ($age < 13) $ageGroup = 'child';
        elseif ($age < 20) $ageGroup = 'teen';
        elseif ($age < 36) $ageGroup = 'young_adult';
        elseif ($age < 51) $ageGroup = 'adult';
        elseif ($age < 66) $ageGroup = 'middle_aged';
        else $ageGroup = 'senior';
    }

    // Get user's profile
    $profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
    if (!$profileStmt) {
        throw new Exception("Profile query failed: " . $conn->error);
    }
    $profileStmt->bind_param("i", $userId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();
    

    // Get age-specific concerns
    $ageSymptoms = [];
    $symptomsStmt = $conn->prepare("SELECT age_concern_id as symptom_id, concern_name as symptom_name, description, 'Age Related' as category FROM age_specific_concerns WHERE age_group = ?");
    if ($symptomsStmt) {
        $symptomsStmt->bind_param("s", $ageGroup);
        $symptomsStmt->execute();
        $res = $symptomsStmt->get_result();
        while ($row = $res->fetch_assoc()) {
            $row['id_prefix'] = 'age_'; // Add prefix for API distinction
            $ageSymptoms[] = $row;
        }
        $symptomsStmt->close();
    }
    
    // Get generic symptoms
    $genericSymptoms = [];
    $symptomsStmt = $conn->prepare("SELECT symptom_id, symptom_name, description, category FROM hair_symptoms ORDER BY category, symptom_name");
    if ($symptomsStmt) {
        $symptomsStmt->execute();
        $res = $symptomsStmt->get_result();
        while ($row = $res->fetch_assoc()) {
            $row['id_prefix'] = 'gen_'; // Add prefix for API distinction
            $genericSymptoms[] = $row;
        }
        $symptomsStmt->close();
    }

    // Merge: Age symptoms first, then generic
    $allSymptoms = array_merge($ageSymptoms, $genericSymptoms);
    
    // Get user's past diagnoses
    if ($profile) {
        $diagnosesStmt = $conn->prepare("
            SELECT * FROM user_diagnoses 
            WHERE profile_id = ? 
            ORDER BY diagnosis_date DESC
            LIMIT 10
        ");
        if ($diagnosesStmt) {
            $diagnosesStmt->bind_param("i", $profile['profile_id']);
            $diagnosesStmt->execute();
            $pastDiagnoses = $diagnosesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $diagnosesStmt->close();
        }
    }
    
    $conn->close();
} catch (Exception $e) {
    $error = $e->getMessage();
    error_log("Diagnosis page error: " . $error);
    if (isset($conn) && $conn instanceof mysqli) {
        $conn->close();
    }
}

$pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Diagnosis") : 'Hair Problem Diagnosis';
include 'includes/header.php';
?>

<div class="container">
    <div class="page-header">
        <?php if ($isViewingChild): ?>
             <div style="margin-bottom: 1rem;">
                <a href="children.php" class="btn btn-secondary" style="margin-bottom: 1rem;">
                    <i class="fas fa-arrow-left"></i> Back to My Children
                </a>
            </div>
            <h1><i class="fas fa-stethoscope"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Hair Diagnosis</h1>
            <p>Select <?php echo htmlspecialchars($childInfo['first_name']); ?>'s concerns to identify possible causes and get effective solutions</p>
        <?php else: ?>
            <h1><i class="fas fa-stethoscope"></i> Hair Problem Diagnosis</h1>
            <p>Select your concerns to identify possible causes and get effective solutions</p>
        <?php endif; ?>
    </div>
    
    <?php if ($error): ?>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Error loading diagnosis page:</strong>
                <p><?php echo htmlspecialchars($error); ?></p>
                <p>Please check your database connection and ensure the 'maneflow' database exists with all required tables.</p>
            </div>
        </div>
    <?php elseif (empty($allSymptoms)): ?>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <div>
                <strong>No concerns available!</strong>
                <p>Please add data to the database.</p>
            </div>
        </div>
    <?php else: ?>
    
    <div class="diagnosis-section">
        <h2><i class="fas fa-clipboard-list"></i> Select Your Concerns</h2>
        <p class="text-muted">Including common concerns for <strong><?php echo ucfirst(str_replace('_', ' ', $ageGroup)); ?></strong></p>
        <form id="diagnosisForm">
            <div class="symptoms-grid">
                <?php 
                $symptomsByCategory = [];
                foreach ($allSymptoms as $symptom) {
                    $category = $symptom['category'];
                    if (!isset($symptomsByCategory[$category])) {
                        $symptomsByCategory[$category] = [];
                    }
                    $symptomsByCategory[$category][] = $symptom;
                }
                
                // Ensure "Age Related" comes first if it exists
                if (isset($symptomsByCategory['Age Related'])) {
                    $ageCat = $symptomsByCategory['Age Related'];
                    unset($symptomsByCategory['Age Related']);
                    $symptomsByCategory = array_merge(['Age Related' => $ageCat], $symptomsByCategory);
                }
                
                $categoryNames = [
                    'breakage' => 'Breakage',
                    'dryness' => 'Dryness',
                    'dandruff' => 'Dandruff',
                    'shedding' => 'Shedding',
                    'scalp_irritation' => 'Scalp Irritation',
                    'thinning' => 'Thinning',
                    'split_ends' => 'Split Ends',
                    'lack_of_growth' => 'Lack of Growth',
                    'texture_change' => 'Texture Change',
                    'other' => 'Other',
                    'Age Related' => 'Age Specific Concerns'
                ];
                
                foreach ($symptomsByCategory as $category => $symptoms): 
                ?>
                    <div class="symptom-category">
                        <h3><?php echo $categoryNames[$category] ?? ucfirst($category); ?></h3>
                        <?php foreach ($symptoms as $symptom): ?>
                            <label class="symptom-checkbox">
                                <input type="checkbox" name="symptoms[]" value="<?php echo $symptom['id_prefix'] . $symptom['symptom_id']; ?>">
                                <span><?php echo htmlspecialchars($symptom['symptom_name']); ?></span>
                                <?php if ($symptom['description']): ?>
                                    <small><?php echo htmlspecialchars(substr($symptom['description'], 0, 100)); ?>...</small>
                                <?php endif; ?>
                            </label>
                        <?php endforeach; ?>
                    </div>
                <?php endforeach; ?>
            </div>
            
            <button type="submit" class="btn btn-primary btn-large" style="margin-top: 2rem;" id="diagnoseBtn">
                <i class="fas fa-search"></i> Diagnose Problem
            </button>
        </form>
    </div>
    
    <div id="diagnosisResults" style="display: none;">
        <h2><i class="fas fa-file-medical"></i> Diagnosis Results</h2>
        <div id="resultsContent"></div>
    </div>
    
    <?php if (!empty($pastDiagnoses)): ?>
        <div class="past-diagnoses-section">
            <h2><i class="fas fa-history"></i> Past Diagnoses</h2>
            <div class="diagnoses-list">
                <?php foreach ($pastDiagnoses as $diagnosis): ?>
                    <div class="diagnosis-card">
                        <div class="diagnosis-header">
                            <span class="diagnosis-date"><?php echo date('M d, Y', strtotime($diagnosis['diagnosis_date'])); ?></span>
                            <?php if ($diagnosis['is_resolved']): ?>
                                <span class="resolved-badge">Resolved</span>
                            <?php else: ?>
                                <span class="active-badge">Active</span>
                            <?php endif; ?>
                        </div>
                        <?php if ($diagnosis['symptoms_reported']): ?>
                            <p><strong>Symptoms:</strong> <?php echo htmlspecialchars($diagnosis['symptoms_reported']); ?></p>
                        <?php endif; ?>
                        <?php if ($diagnosis['identified_causes']): ?>
                            <p><strong>Causes:</strong> <?php echo htmlspecialchars($diagnosis['identified_causes']); ?></p>
                        <?php endif; ?>
                        <?php if ($diagnosis['recommended_solutions']): ?>
                            <p><strong>Solutions:</strong> <?php echo htmlspecialchars($diagnosis['recommended_solutions']); ?></p>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
    <?php endif; ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('diagnosisForm');
    const resultsDiv = document.getElementById('diagnosisResults');
    const resultsContent = document.getElementById('resultsContent');
    const submitBtn = document.getElementById('diagnoseBtn');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const selectedSymptoms = Array.from(document.querySelectorAll('input[name="symptoms[]"]:checked'))
                .map(cb => cb.value);
            
            if (selectedSymptoms.length === 0) {
                alert('Please select at least one concern');
                return;
            }

            // UI State: Processing
            const originalBtnText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            resultsDiv.style.display = 'block';
            resultsContent.innerHTML = '<div class="text-center p-5"><i class="fas fa-spinner fa-spin fa-3x"></i><p>Analyzing your concerns...</p></div>';
            resultsDiv.scrollIntoView({ behavior: 'smooth' });
            
            const xhr = new XMLHttpRequest();
            const url = 'api/diagnose.php<?php echo $isViewingChild ? "?child_id=" . $userId : ""; ?>';
            xhr.open('POST', url, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                // Reset Button
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnText;

                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            displayDiagnosisResults(response);
                        } else {
                            resultsDiv.style.display = 'none';
                            alert('Error: ' + (response.error || 'Diagnosis failed'));
                        }
                    } catch (e) {
                        resultsDiv.style.display = 'none';
                        alert('Error parsing server response');
                    }
                } else {
                     resultsDiv.style.display = 'none';
                     alert('Server error: ' + xhr.status);
                }
            };
            
            xhr.onerror = function() {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnText;
                resultsDiv.style.display = 'none';
                alert('Network error occurred');
            };
            
            const params = 'symptoms=' + encodeURIComponent(JSON.stringify(selectedSymptoms));
            xhr.send(params);
        });
    }

    
    function displayDiagnosisResults(response) {
        let html = '<div class="diagnosis-result-card">';
        
        if (response.causes && response.causes.length > 0) {
            html += '<h3><i class="fas fa-exclamation-triangle"></i> Possible Causes</h3>';
            html += '<ul class="causes-list">';
            response.causes.forEach(cause => {
                html += '<li>';
                html += '<strong>' + cause.cause_name + '</strong>';
                 if (cause.likelihood_score) {
                    html += ' <span class="likelihood-badge">' + cause.likelihood_score + '</span>'; // Removed /10 for cleaner look if unavailable
                } else if (cause.prevalence) {
                     html += ' <span class="likelihood-badge">' + cause.prevalence + '</span>';
                }

                if (cause.description) {
                    html += '<p>' + cause.description + '</p>';
                }
                html += '</li>';
            });
            html += '</ul>';
        }
        
        if (response.solutions && response.solutions.length > 0) {
            html += '<h3><i class="fas fa-lightbulb"></i> Recommended Actions</h3>';
            html += '<div class="solutions-list">';
            response.solutions.forEach(solution => {
                html += '<div class="solution-card">';
                html += '<h4>' + solution.solution_name + '</h4>';
                // html += '<span class="solution-type">' + (solution.solution_type || 'Advice') + '</span>';
                if (solution.description) {
                    html += '<p>' + solution.description + '</p>';
                }
                // if (solution.instructions) {
                //     html += '<p><strong>Instructions:</strong> ' + solution.instructions + '</p>';
                // }
                // if (solution.expected_timeframe) {
                //     html += '<p><i class="fas fa-clock"></i> Expected timeframe: ' + solution.expected_timeframe + '</p>';
                // }
                html += '</div>';
            });
            html += '</div>';
        }
        
        html += '</div>';
        resultsContent.innerHTML = html;
        resultsDiv.scrollIntoView({ behavior: 'smooth' });
    }
});
</script>

<?php include 'includes/footer.php'; ?>
