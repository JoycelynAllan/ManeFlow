<?php
// Test with session and database - step by step
ob_start();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');

$steps = [];

// Step 1: Check session
if (!isset($_SESSION['user_id'])) {
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Not authenticated', 'step' => 'session_check']);
    ob_end_flush();
    exit;
}
$steps[] = 'session_ok';

// Step 2: Load config
try {
    require_once __DIR__ . '/../config/db.php';
    $steps[] = 'config_loaded';
} catch (Exception $e) {
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Config error: ' . $e->getMessage(), 'step' => 'config_load']);
    ob_end_flush();
    exit;
}

// Step 3: Get connection
try {
    $conn = getDBConnection();
    $steps[] = 'connection_ok';
} catch (Exception $e) {
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Connection error: ' . $e->getMessage(), 'step' => 'db_connection']);
    ob_end_flush();
    exit;
}

// Step 4: Check child_id parameter
$userId = $_SESSION['user_id'];
if (isset($_GET['child_id'])) {
    $steps[] = 'has_child_id';
    $childId = (int)$_GET['child_id'];
    
    // Try verification
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    if (!$verifyStmt) {
        $conn->close();
        ob_clean();
        echo json_encode(['success' => false, 'error' => 'Verify prepare failed: ' . $conn->error, 'step' => 'verify_prepare', 'steps_completed' => $steps]);
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
        $steps[] = 'child_verified';
    } else {
        $conn->close();
        ob_clean();
        echo json_encode(['success' => false, 'error' => 'Invalid child', 'step' => 'child_verification', 'steps_completed' => $steps]);
        ob_end_flush();
        exit;
    }
}

// Step 5: Get profile
$profileStmt = $conn->prepare("SELECT profile_id FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
if (!$profileStmt) {
    $conn->close();
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Profile prepare failed: ' . $conn->error, 'step' => 'profile_prepare', 'steps_completed' => $steps]);
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
    echo json_encode(['success' => false, 'error' => 'No profile', 'step' => 'profile_fetch', 'steps_completed' => $steps]);
    ob_end_flush();
    exit;
}
$steps[] = 'profile_found';

// Step 6: Try UPDATE
$deactivateStmt = $conn->prepare("UPDATE hair_care_routines SET is_active = 0 WHERE profile_id = ?");
if (!$deactivateStmt) {
    $conn->close();
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Update prepare failed: ' . $conn->error, 'step' => 'update_prepare', 'steps_completed' => $steps]);
    ob_end_flush();
    exit;
}
$deactivateStmt->bind_param("i", $profile['profile_id']);
$deactivateStmt->execute();
$deactivateStmt->close();
$steps[] = 'update_ok';

// Step 7: Try INSERT
$insertRoutine = $conn->prepare("INSERT INTO hair_care_routines (profile_id, routine_name, routine_type, description, is_active, last_update_alert, update_frequency_days) VALUES (?, 'Test', 'morning', 'Test', 1, CURDATE(), 90)");
if (!$insertRoutine) {
    $conn->close();
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Insert prepare failed: ' . $conn->error, 'step' => 'insert_prepare', 'steps_completed' => $steps]);
    ob_end_flush();
    exit;
}
$insertRoutine->bind_param("i", $profile['profile_id']);
if ($insertRoutine->execute()) {
    $steps[] = 'insert_ok';
    $routineId = $conn->insert_id;
} else {
    $conn->close();
    ob_clean();
    echo json_encode(['success' => false, 'error' => 'Insert execute failed: ' . $insertRoutine->error, 'step' => 'insert_execute', 'steps_completed' => $steps]);
    ob_end_flush();
    exit;
}
$insertRoutine->close();

$conn->close();

ob_clean();
echo json_encode(['success' => true, 'message' => 'All steps passed!', 'steps_completed' => $steps, 'routine_id' => $routineId]);
ob_end_flush();
