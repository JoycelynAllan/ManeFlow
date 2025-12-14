<?php
// Absolute minimal test - no sessions, no ob
header('Content-Type: application/json');

try {
    require_once __DIR__ . '/../config/db.php';
    $conn = getDBConnection();
    
    $result = $conn->query("SELECT 1");
    $conn->close();
    
    echo json_encode(['success' => true, 'message' => 'Works without session!']);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
