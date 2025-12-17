<?php
/**
 * Diagnose hair problems based on symptoms
 */

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    exit;
}

require_once __DIR__ . '/../config/db.php';

$userId = $_SESSION['user_id'];

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    // Verify this child belongs to the current user (parent) using direct query
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    $verifyStmt->bind_param("ii", $childId, $userId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->num_rows > 0;
    $verifyStmt->close();
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
    } else {
        echo json_encode(['success' => false, 'error' => 'Unauthorized access to child profile']);
        exit;
    }
}
$symptomsJson = isset($_POST['symptoms']) ? $_POST['symptoms'] : '[]';
$symptomIds = json_decode($symptomsJson, true);

if (empty($symptomIds) || !is_array($symptomIds)) {
    echo json_encode(['success' => false, 'error' => 'No symptoms selected']);
    exit;
}

$conn = getDBConnection();

// Get user's profile
$profileStmt = $conn->prepare("SELECT profile_id FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'No profile found']);
    exit;
}

try {

    

    
    // Split symptoms by type
    // used AI for this
    $ageSymptomIds = [];
    $genericSymptomIds = [];
    
    foreach ($symptomIds as $idStr) {
        if (strpos($idStr, 'age_') === 0) {
            $ageSymptomIds[] = (int)str_replace('age_', '', $idStr);
        } elseif (strpos($idStr, 'gen_') === 0) {
            $genericSymptomIds[] = (int)str_replace('gen_', '', $idStr);
        } else {
            // Fallback for legacy calls or plain numeric IDs 
            $genericSymptomIds[] = (int)$idStr;
        }
    }
    
    $causes = [];
    $solutions = [];
    $symptomsTextParts = [];
    
    // Process Age-Specific Concerns
    if (!empty($ageSymptomIds)) {
        $idsStr = implode(',', $ageSymptomIds);
        $concernsStmt = $conn->prepare("SELECT concern_name, typical_causes, recommended_actions, prevalence FROM age_specific_concerns WHERE age_concern_id IN ($idsStr)");
        
        if ($concernsStmt) {
            $concernsStmt->execute();
            $concerns = $concernsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $concernsStmt->close();
            
            foreach ($concerns as $concern) {
                $symptomsTextParts[] = $concern['concern_name'];
                
                $causes[] = [
                    'cause_name' => 'Associated with ' . $concern['concern_name'],
                    'description' => $concern['typical_causes'],
                    'likelihood_score' => null,
                    'prevalence' => ucfirst($concern['prevalence'])
                ];
                
                $solutions[] = [
                    'solution_name' => 'Recommendation for ' . $concern['concern_name'],
                    'description' => $concern['recommended_actions'],
                    'solution_type' => 'Age-Specific Advice'
                ];
            }
        }
    }
    
    // Process Generic Symptoms
    if (!empty($genericSymptomIds)) {
        $idsStr = implode(',', $genericSymptomIds);
        
        // Get generic symptom names
        $symptomsStmt = $conn->prepare("SELECT symptom_name FROM hair_symptoms WHERE symptom_id IN ($idsStr)");
        if ($symptomsStmt) {
            $symptomsStmt->execute();
            $symptomNames = $symptomsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $symptomsStmt->close();
            foreach ($symptomNames as $s) {
                $symptomsTextParts[] = $s['symptom_name'];
            }
        }
        
        // Find causes based on generic symptoms
        $causesStmt = $conn->prepare("
            SELECT DISTINCT dc.*, scm.likelihood_score, scm.explanation
            FROM diagnosis_causes dc
            INNER JOIN symptom_cause_mapping scm ON dc.cause_id = scm.cause_id
            WHERE scm.symptom_id IN ($idsStr)
            ORDER BY scm.likelihood_score DESC
            LIMIT 50
        ");
        
        if ($causesStmt) {
            $causesStmt->execute();
            $genericCauses = $causesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $causesStmt->close();
            
            // Merge causes 
            $causes = array_merge($causes, $genericCauses);
            
            // Get solutions for identified generic causes
            if (!empty($genericCauses)) {
                $causeIds = array_column($genericCauses, 'cause_id');
                $causeIdsStr = implode(',', $causeIds);
                
                $solutionsStmt = $conn->prepare("
                    SELECT * FROM treatment_solutions 
                    WHERE cause_id IN ($causeIdsStr)
                    ORDER BY solution_id
                    LIMIT 10
                ");
                if ($solutionsStmt) {
                    $solutionsStmt->execute();
                    $genericSolutions = $solutionsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
                    $solutionsStmt->close();
                    $solutions = array_merge($solutions, $genericSolutions);
                }
            }
        }
    }
    
    // Prepare text for storage
    $symptomsText = implode(', ', $symptomsTextParts);
    $causesText = implode('; ', array_map(function($c) { return $c['cause_name']; }, $causes));
    $solutionsText = implode('; ', array_map(function($s) { return $s['solution_name']; }, $solutions));
    
    // Save diagnosis
    $insertDiagnosis = $conn->prepare("INSERT INTO user_diagnoses 
        (profile_id, diagnosis_date, symptoms_reported, identified_causes, recommended_solutions) 
        VALUES (?, CURDATE(), ?, ?, ?)");
    $insertDiagnosis->bind_param("isss", $profile['profile_id'], $symptomsText, $causesText, $solutionsText);
    $insertDiagnosis->execute();
    $insertDiagnosis->close();
    
    $conn->close();
    
    echo json_encode([
        'success' => true,
        'causes' => $causes,
        'solutions' => $solutions,
        'message' => 'Diagnosis completed successfully'
    ]);
    
} catch (Exception $e) {
    error_log("Error diagnosing: " . $e->getMessage());
    $conn->close();
    echo json_encode([
        'success' => false,
        'error' => 'Error diagnosing: ' . $e->getMessage()
    ]);
}
?>

