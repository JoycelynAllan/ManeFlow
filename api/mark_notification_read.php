<?php
header('Content-Type: application/json');
require_once '../config/db.php';

session_start();

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['mark_all']) && $data['mark_all'] === true) {
    // Mark all as read
    $stmt = $conn->prepare("UPDATE user_notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0");
    $stmt->bind_param("i", $userId);
} elseif (isset($data['notification_id'])) {
    // Mark single as read
    $notificationId = intval($data['notification_id']);
    $stmt = $conn->prepare("UPDATE user_notifications SET is_read = 1 WHERE notification_id = ? AND user_id = ?");
    $stmt->bind_param("ii", $notificationId, $userId);
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Missing notification_id or mark_all']);
    $conn->close();
    exit;
}

if ($stmt->execute()) {
    // Get updated unread count
    $countStmt = $conn->prepare("SELECT COUNT(*) as unread_count FROM user_notifications WHERE user_id = ? AND is_read = 0");
    $countStmt->bind_param("i", $userId);
    $countStmt->execute();
    $unreadCount = $countStmt->get_result()->fetch_assoc()['unread_count'];
    $countStmt->close();

    echo json_encode(['success' => true, 'unread_count' => $unreadCount]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Database error']);
}

$stmt->close();
$conn->close();
?>
