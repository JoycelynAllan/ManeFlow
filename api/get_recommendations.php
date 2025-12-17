<?php
require_once '../config/db.php';

header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Gets user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    echo json_encode(['success' => false, 'error' => 'No profile found']);
    $conn->close();
    exit;
}

// Get recommendations
$recStmt = $conn->prepare("
    SELECT ur.*, 
           p.product_name, p.brand, p.category as product_category, p.description as product_desc,
           m.method_name, m.category as method_category, m.description as method_desc,
           pf.pitfall_name, pf.category as pitfall_category, pf.description as pitfall_desc
    FROM user_recommendations ur
    LEFT JOIN products p ON ur.product_id = p.product_id
    LEFT JOIN growth_methods m ON ur.method_id = m.method_id
    LEFT JOIN hair_pitfalls pf ON ur.pitfall_id = pf.pitfall_id
    WHERE ur.profile_id = ? AND ur.is_active = 1
    ORDER BY 
        CASE ur.priority
            WHEN 'critical' THEN 1
            WHEN 'high' THEN 2
            WHEN 'medium' THEN 3
            WHEN 'low' THEN 4
        END
");
$recStmt->bind_param("i", $profile['profile_id']);
$recStmt->execute();
$recommendations = $recStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$recStmt->close();

$conn->close();

echo json_encode(['success' => true, 'data' => $recommendations]);
?>

