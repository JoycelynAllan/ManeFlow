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

// Optional: Filter by read status
$filter = isset($_GET['filter']) ? $_GET['filter'] : 'all';
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 20;
$offset = isset($_GET['offset']) ? intval($_GET['offset']) : 0;

$whereClause = "user_id = ?";
$types = "i";
$params = [$userId];

if ($filter === 'unread') {
    $whereClause .= " AND is_read = 0";
}

// Get total unread count (separate from the list query)
$countQuery = "SELECT COUNT(*) as unread_count FROM user_notifications WHERE user_id = ? AND is_read = 0";
$countStmt = $conn->prepare($countQuery);
$countStmt->bind_param("i", $userId);
$countStmt->execute();
$unreadCount = $countStmt->get_result()->fetch_assoc()['unread_count'];
$countStmt->close();

// Get notifications
$query = "SELECT * FROM user_notifications WHERE $whereClause ORDER BY created_at DESC LIMIT ? OFFSET ?";
$types .= "ii";
$params[] = $limit;
$params[] = $offset;

$stmt = $conn->prepare($query);
$stmt->bind_param($types, ...$params);
$stmt->execute();
$result = $stmt->get_result();
$notifications = $result->fetch_all(MYSQLI_ASSOC);

echo json_encode([
    'success' => true,
    'unread_count' => $unreadCount,
    'notifications' => $notifications
]);

$conn->close();
?>
