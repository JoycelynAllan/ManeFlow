<?php
/**
 * Log routine completion
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
$routineId = isset($_POST['routine_id']) ? (int)$_POST['routine_id'] : 0;

if (!$routineId) {
    echo json_encode(['success' => false, 'error' => 'Invalid routine ID']);
    exit;
}

$conn = getDBConnection();

// Verify routine belongs to user
$verifyStmt = $conn->prepare("
    SELECT r.routine_id, r.profile_id
    FROM hair_care_routines r
    INNER JOIN user_hair_profiles p ON r.profile_id = p.profile_id
    WHERE r.routine_id = ? AND p.user_id = ?
");
$verifyStmt->bind_param("ii", $routineId, $userId);
$verifyStmt->execute();
$routine = $verifyStmt->get_result()->fetch_assoc();
$verifyStmt->close();

if (!$routine) {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'Routine not found']);
    exit;
}

// Check if already logged today
$checkStmt = $conn->prepare("
    SELECT log_id FROM routine_completion_log 
    WHERE routine_id = ? AND profile_id = ? AND completion_date = CURDATE()
");
$checkStmt->bind_param("ii", $routineId, $routine['profile_id']);
$checkStmt->execute();
$existing = $checkStmt->get_result()->fetch_assoc();
$checkStmt->close();

if ($existing) {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'Routine already marked as completed today']);
    exit;
}

// Log completion
$insertStmt = $conn->prepare("INSERT INTO routine_completion_log 
    (routine_id, profile_id, completion_date, notes) 
    VALUES (?, ?, CURDATE(), 'Completed via app')");
$insertStmt->bind_param("ii", $routineId, $routine['profile_id']);

if ($insertStmt->execute()) {
    $conn->close();
    echo json_encode(['success' => true, 'message' => 'Routine completion logged successfully']);
} else {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'Failed to log completion']);
}

$insertStmt->close();
?>

