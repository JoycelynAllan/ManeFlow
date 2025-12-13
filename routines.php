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
$error = null;
$profile = null;
$routines = [];
$updateAlerts = [];
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    // Verify this child belongs to the current user (parent) using stored procedure
    $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
    $verifyStmt->bind_param("ii", $userId, $childId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
    $verifyStmt->close();
    
    // Clear results
    while ($conn->next_result()) {
        $conn->store_result();
    }
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
        $isViewingChild = true;
        
        // Get child name
        $childNameStmt = $conn->prepare("SELECT first_name FROM users WHERE user_id = ?");
        $childNameStmt->bind_param("i", $childId);
        $childNameStmt->execute();
        $childInfo = $childNameStmt->get_result()->fetch_assoc();
        $childNameStmt->close();
        $conn->close();
    } else {
        $conn->close();
        header('Location: children.php?error=unauthorized');
        exit;
    }
}

try {
    $conn = getDBConnection();
    
    // Get user's profile
    $profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
    if (!$profileStmt) {
        throw new Exception("Profile query failed: " . $conn->error);
    }
    $profileStmt->bind_param("i", $userId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();
    
    if ($profile) {
        // Get existing routines
        $routinesStmt = $conn->prepare("
            SELECT r.*, 
                   COUNT(DISTINCT rs.step_id) as step_count,
                   COUNT(DISTINCT rcl.log_id) as completion_count
            FROM hair_care_routines r
            LEFT JOIN routine_steps rs ON r.routine_id = rs.routine_id
            LEFT JOIN routine_completion_log rcl ON r.routine_id = rcl.routine_id
            WHERE r.profile_id = ? AND r.is_active = 1
            GROUP BY r.routine_id
            ORDER BY 
                CASE r.routine_type
                    WHEN 'morning' THEN 1
                    WHEN 'night' THEN 2
                    WHEN 'wash_day' THEN 3
                    ELSE 4
                END,
                r.created_at DESC
        ");
        if ($routinesStmt) {
            $routinesStmt->bind_param("i", $profile['profile_id']);
            $routinesStmt->execute();
            $routines = $routinesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $routinesStmt->close();
        }
        
        // Check for routine update alerts
        foreach ($routines as $routine) {
            if ($routine['last_update_alert']) {
                $daysSinceUpdate = (time() - strtotime($routine['last_update_alert'])) / (60 * 60 * 24);
                if ($daysSinceUpdate >= ($routine['update_frequency_days'] ?? 90)) {
                    $updateAlerts[] = $routine;
                }
            }
        }
    }
    
    // Check for routine update alerts
    foreach ($routines as $routine) {
        if ($routine['last_update_alert']) {
            $daysSinceUpdate = (time() - strtotime($routine['last_update_alert'])) / (60 * 60 * 24);
            if ($daysSinceUpdate >= ($routine['update_frequency_days'] ?? 90)) {
                $updateAlerts[] = $routine;
            }
        }
    }
    
    $conn->close();
} catch (Exception $e) {
    $error = $e->getMessage();
    error_log("Routines page error: " . $error);
    if (isset($conn) && $conn) {
        $conn->close();
    }
}

$pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Routines") : 'My Hair Routines';
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
            <h1><i class="fas fa-calendar-check"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Routines</h1>
            <p>Custom routines tailored to <?php echo htmlspecialchars($childInfo['first_name']); ?>'s hair type, concerns, and goals</p>
        <?php else: ?>
            <h1><i class="fas fa-calendar-check"></i> Personalized Hair Routines</h1>
            <p>Custom routines tailored to your hair type, concerns, and goals</p>
        <?php endif; ?>
        <button id="generateRoutines" class="btn btn-primary" style="margin-top: 1rem;">
            <i class="fas fa-magic"></i> Generate/Update My Routines
        </button>
        <div id="routineStatus" style="margin-top: 0.5rem; display: none;"></div>
    </div>
    
    <?php if (!empty($updateAlerts)): ?>
        <div class="alert alert-warning">
            <i class="fas fa-bell"></i>
            <div>
                <strong>Routine Update Recommended!</strong>
                <p>The following routines may need updating based on your hair's current needs:</p>
                <ul>
                    <?php foreach ($updateAlerts as $alert): ?>
                        <li><?php echo htmlspecialchars($alert['routine_name'] ?? ucfirst($alert['routine_type'])); ?> - Last updated <?php echo date('M d, Y', strtotime($alert['last_update_alert'])); ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        </div>
    <?php endif; ?>
    
    <?php if ($error): ?>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Error loading routines:</strong>
                <p><?php echo htmlspecialchars($error); ?></p>
                <p>Please check your database connection and ensure the 'maneflow' database exists with all required tables.</p>
            </div>
        </div>
    <?php elseif (!$profile): ?>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <div>
                <strong>No hair profile found!</strong>
                <p>Please <a href="profile.php<?php echo $isViewingChild ? '?child_id=' . $userId : ''; ?>">create <?php echo $isViewingChild ? 'a' : 'your'; ?> hair profile</a> first to generate personalized routines.</p>
            </div>
        </div>
    <?php elseif (empty($routines)): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>No routines yet!</strong>
                <p>Click "Generate/Update My Routines" to create personalized morning, night, and wash-day routines based on your hair profile.</p>
            </div>
        </div>
    <?php else: ?>
        <div class="routines-grid">
            <?php foreach ($routines as $routine): ?>
                <div class="routine-card">
                    <div class="routine-header">
                        <h3>
                            <i class="fas fa-<?php 
                                echo $routine['routine_type'] === 'morning' ? 'sun' : 
                                    ($routine['routine_type'] === 'night' ? 'moon' : 
                                    ($routine['routine_type'] === 'wash_day' ? 'shower' : 'calendar')); 
                            ?>"></i>
                            <?php echo htmlspecialchars($routine['routine_name'] ?? ucfirst(str_replace('_', ' ', $routine['routine_type']))); ?>
                        </h3>
                        <span class="routine-type-badge"><?php echo ucfirst(str_replace('_', ' ', $routine['routine_type'])); ?></span>
                    </div>
                    
                    <?php if ($routine['description']): ?>
                        <p class="routine-description"><?php echo htmlspecialchars($routine['description']); ?></p>
                    <?php endif; ?>
                    
                    <div class="routine-stats">
                        <span><i class="fas fa-list-ol"></i> <?php echo $routine['step_count']; ?> Steps</span>
                        <span><i class="fas fa-check-circle"></i> <?php echo $routine['completion_count']; ?> Completions</span>
                    </div>
                    
                    <a href="routine_detail.php?id=<?php echo $routine['routine_id']; ?>" class="btn btn-primary btn-small">
                        <i class="fas fa-eye"></i> View Details
                    </a>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const generateBtn = document.getElementById('generateRoutines');
    const statusDiv = document.getElementById('routineStatus');
    
    if (generateBtn) {
        generateBtn.addEventListener('click', function() {
            generateBtn.disabled = true;
            generateBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
            statusDiv.style.display = 'block';
            statusDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> Generating personalized routines based on your profile...</div>';
            
            const xhr = new XMLHttpRequest();
            const url = 'api/generate_routines.php<?php echo $isViewingChild ? "?child_id=" . $userId : ""; ?>';
            xhr.open('POST', url, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                generateBtn.disabled = false;
                generateBtn.innerHTML = '<i class="fas fa-magic"></i> Generate/Update My Routines';
                
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            statusDiv.innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> ' + response.message + '</div>';
                            setTimeout(() => {
                                window.location.reload();
                            }, 2000);
                        } else {
                            statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ' + (response.error || 'Failed to generate routines') + '</div>';
                        }
                    } catch (e) {
                        statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Error parsing response</div>';
                    }
                } else {
                    statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Request failed with status ' + xhr.status + '</div>';
                }
            };
            
            xhr.onerror = function() {
                generateBtn.disabled = false;
                generateBtn.innerHTML = '<i class="fas fa-magic"></i> Generate/Update My Routines';
                statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Network error occurred</div>';
            };
            
            xhr.send();
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

