<?php
/**
 * Generate personalized hair care routines
 */

ob_start();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    ob_clean();
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

require_once __DIR__ . '/../config/db.php';

$userId = $_SESSION['user_id'];

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    if (!$verifyStmt) {
        $conn->close();
        ob_clean();
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Verification error: ' . $conn->error]);
        ob_end_flush();
        exit;
    }
    
    $verifyStmt->bind_param("ii", $childId, $userId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->num_rows > 0;
    $verifyStmt->close();
    
    if ($isValid) {
        $userId = $childId;
    } else {
        $conn->close();
        ob_clean();
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Unauthorized access to child profile']);
        ob_end_flush();
        exit;
    }
} else {
    $conn = getDBConnection();
}

$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
if (!$profileStmt) {
    $conn->close();
    ob_clean();
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Profile query failed: ' . $conn->error]);
    ob_end_flush();
    exit;
}

$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    $conn->close();
    ob_clean();
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'No profile found']);
    ob_end_flush();
    exit;
}

$hairTypeInfo = null;
if ($profile['hair_type_id']) {
    $typeStmt = $conn->prepare("SELECT * FROM hair_types WHERE hair_type_id = ?");
    if ($typeStmt) {
        $typeStmt->bind_param("i", $profile['hair_type_id']);
        $typeStmt->execute();
        $hairTypeInfo = $typeStmt->get_result()->fetch_assoc();
        $typeStmt->close();
    }
}

try {
    $deactivateStmt = $conn->prepare("UPDATE hair_care_routines SET is_active = 0 WHERE profile_id = ?");
    if (!$deactivateStmt) {
        throw new Exception("Update failed: " . $conn->error);
    }
    $deactivateStmt->bind_param("i", $profile['profile_id']);
    $deactivateStmt->execute();
    $deactivateStmt->close();
    
    $routinesCreated = 0;
    $routineTypes = ['morning', 'night', 'wash_day'];
    
    foreach ($routineTypes as $routineType) {
        $routineName = ucfirst(str_replace('_', ' ', $routineType)) . ' Routine';
        $description = "Personalized " . $routineType . " routine";
        
        $insertRoutine = $conn->prepare("INSERT INTO hair_care_routines (profile_id, routine_name, routine_type, description, is_active, last_update_alert, update_frequency_days) VALUES (?, ?, ?, ?, 1, CURDATE(), 90)");
        if (!$insertRoutine) {
            throw new Exception("Insert failed: " . $conn->error);
        }
        
        $insertRoutine->bind_param("isss", $profile['profile_id'], $routineName, $routineType, $description);
        
        if ($insertRoutine->execute()) {
            $routineId = $conn->insert_id;
            $routinesCreated++;
            
            $steps = [];
            if ($routineType === 'morning') {
                $steps = [
                    ['name' => 'Gentle Detangling', 'instructions' => 'Use wide-tooth comb', 'duration' => '5-10 min'],
                    ['name' => 'Moisturize', 'instructions' => 'Apply leave-in conditioner', 'duration' => '2-3 min']
                ];
            } elseif ($routineType === 'night') {
                $steps = [
                    ['name' => 'Protective Styling', 'instructions' => 'Braid or wrap hair', 'duration' => '5-10 min']
                ];
            } else {
                $steps = [
                    ['name' => 'Shampoo', 'instructions' => 'Wash with sulfate-free shampoo', 'duration' => '5-10 min'],
                    ['name' => 'Condition', 'instructions' => 'Apply conditioner', 'duration' => '5-10 min']
                ];
            }
            
            $stepOrder = 1;
            $insertStep = $conn->prepare("INSERT INTO routine_steps (routine_id, step_order, step_name, product_id, method_id, duration, instructions, is_optional, frequency_note) VALUES (?, ?, ?, NULL, NULL, ?, ?, 0, NULL)");
            
            if ($insertStep) {
                foreach ($steps as $step) {
                    $insertStep->bind_param("iisss", $routineId, $stepOrder, $step['name'], $step['duration'], $step['instructions']);
                    $insertStep->execute();
                    $stepOrder++;
                }
                $insertStep->close();
            }
        }
        
        $insertRoutine->close();
    }
    
    $conn->close();
    
    ob_clean();
    echo json_encode(['success' => true, 'message' => "Generated {$routinesCreated} routines!", 'routines_created' => $routinesCreated]);
    ob_end_flush();
    
} catch (Exception $e) {
    if (isset($conn)) $conn->close();
    ob_clean();
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    ob_end_flush();
}
