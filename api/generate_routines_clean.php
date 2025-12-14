<?php
/**
 * Generate personalized hair care routines - Clean version
 */

// Start output buffering first
ob_start();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Set JSON header
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

// Handle child profile verification
if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    if (!$verifyStmt) {
        $conn->close();
        ob_clean();
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'DB Error: ' . $conn->error]);
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
        echo json_encode(['success' => false, 'error' => 'Unauthorized child access']);
        ob_end_flush();
        exit;
    }
} else {
    $conn = getDBConnection();
}

// Get user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
if (!$profileStmt) {
    $conn->close();
    ob_clean();
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Profile query error: ' . $conn->error]);
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

// Get hair type info
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

// Get user concerns
$concerns = [];
$concernsStmt = $conn->prepare("SELECT hc.concern_name, uhc.severity FROM user_hair_concerns uhc INNER JOIN hair_concerns hc ON uhc.concern_id = hc.concern_id WHERE uhc.profile_id = ?");
if ($concernsStmt) {
    $concernsStmt->bind_param("i", $profile['profile_id']);
    $concernsStmt->execute();
    $concerns = $concernsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $concernsStmt->close();
}

try {
    // Deactivate old routines
    $deactivateStmt = $conn->prepare("UPDATE hair_care_routines SET is_active = 0 WHERE profile_id = ?");
    if (!$deactivateStmt) {
        throw new Exception("Deactivate error: " . $conn->error);
    }
    $deactivateStmt->bind_param("i", $profile['profile_id']);
    $deactivateStmt->execute();
    $deactivateStmt->close();
    
    $routinesCreated = 0;
    $routineTypes = ['morning', 'night', 'wash_day'];
    
    foreach ($routineTypes as $routineType) {
        $routineName = ucfirst(str_replace('_', ' ', $routineType)) . ' Routine';
        $description = "Personalized " . $routineType . " hair care routine";
        
        $insertRoutine = $conn->prepare("INSERT INTO hair_care_routines (profile_id, routine_name, routine_type, description, is_active, last_update_alert, update_frequency_days) VALUES (?, ?, ?, ?, 1, CURDATE(), 90)");
        if (!$insertRoutine) {
            throw new Exception("Insert routine error: " . $conn->error);
        }
        
        $insertRoutine->bind_param("isss", $profile['profile_id'], $routineName, $routineType, $description);
        
        if ($insertRoutine->execute()) {
            $routineId = $conn->insert_id;
            $routinesCreated++;
            
            // Generate basic steps
            $steps = [];
            if ($routineType === 'morning') {
                $steps = [
                    ['name' => 'Gentle Detangling', 'instructions' => 'Use a wide-tooth comb', 'duration' => '5-10 minutes'],
                    ['name' => 'Moisturize', 'instructions' => 'Apply leave-in conditioner', 'duration' => '2-3 minutes']
                ];
            } elseif ($routineType === 'night') {
                $steps = [
                    ['name' => 'Protective Styling', 'instructions' => 'Style in protective style', 'duration' => '5-10 minutes']
                ];
            } else {
                $steps = [
                    ['name' => 'Shampoo', 'instructions' => 'Wash with sulfate-free shampoo', 'duration' => '5-10 minutes'],
                    ['name' => 'Condition', 'instructions' => 'Apply conditioner', 'duration' => '5-10 minutes']
                ];
            }
            
            // Insert steps
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
    echo json_encode([
        'success' => true,
        'message' => "Successfully generated {$routinesCreated} personalized routines!",
        'routines_created' => $routinesCreated
    ]);
    ob_end_flush();
    exit;
    
} catch (Exception $e) {
    if (isset($conn)) {
        $conn->close();
    }
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
    ob_end_flush();
    exit;
}
