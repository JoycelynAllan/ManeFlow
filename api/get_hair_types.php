<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$conn = getDBConnection();

$stmt = $conn->prepare("SELECT * FROM hair_types ORDER BY type_code");
$stmt->execute();
$result = $stmt->get_result();

$hairTypes = [];
while ($row = $result->fetch_assoc()) {
    $hairTypes[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode(['success' => true, 'data' => $hairTypes]);
?>

