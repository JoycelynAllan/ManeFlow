<?php
/**
 * API endpoint to get data for offline caching
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
$dataType = isset($_GET['type']) ? $_GET['type'] : 'all';

$conn = getDBConnection();

// Get user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'No profile found']);
    exit;
}

$data = [];

try {
    // Get routines
    if ($dataType === 'all' || $dataType === 'routines') {
        $routinesStmt = $conn->prepare("
            SELECT r.*, rs.*
            FROM hair_care_routines r
            LEFT JOIN routine_steps rs ON r.routine_id = rs.routine_id
            WHERE r.profile_id = ? AND r.is_active = 1
            ORDER BY r.routine_id, rs.step_order
        ");
        $routinesStmt->bind_param("i", $profile['profile_id']);
        $routinesStmt->execute();
        $routines = $routinesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $routinesStmt->close();
        $data['routines'] = $routines;
    }
    
    // Get recommendations
    if ($dataType === 'all' || $dataType === 'recommendations') {
        $recStmt = $conn->prepare("
            SELECT ur.*, p.product_name, p.brand, p.category, p.description,
                   m.method_name, pf.pitfall_name
            FROM user_recommendations ur
            LEFT JOIN products p ON ur.product_id = p.product_id
            LEFT JOIN growth_methods m ON ur.method_id = m.method_id
            LEFT JOIN hair_pitfalls pf ON ur.pitfall_id = pf.pitfall_id
            WHERE ur.profile_id = ? AND ur.is_active = 1
        ");
        $recStmt->bind_param("i", $profile['profile_id']);
        $recStmt->execute();
        $recommendations = $recStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $recStmt->close();
        $data['recommendations'] = $recommendations;
    }
    
    // Get progress entries
    if ($dataType === 'all' || $dataType === 'progress') {
        $progressStmt = $conn->prepare("
            SELECT * FROM hair_growth_progress 
            WHERE profile_id = ? 
            ORDER BY measurement_date DESC
            LIMIT 20
        ");
        $progressStmt->bind_param("i", $profile['profile_id']);
        $progressStmt->execute();
        $progress = $progressStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $progressStmt->close();
        $data['progress'] = $progress;
    }
    
    // Get educational content marked for offline
    if ($dataType === 'all' || $dataType === 'content') {
        $contentStmt = $conn->prepare("
            SELECT * FROM educational_content 
            WHERE is_offline_available = 1
            ORDER BY published_at DESC
            LIMIT 20
        ");
        $contentStmt->execute();
        $content = $contentStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $contentStmt->close();
        $data['content'] = $content;
    }
    
    $conn->close();
    
    echo json_encode([
        'success' => true,
        'data' => $data,
        'cached_at' => date('Y-m-d H:i:s')
    ]);
    
} catch (Exception $e) {
    error_log("Error fetching offline data: " . $e->getMessage());
    $conn->close();
    echo json_encode([
        'success' => false,
        'error' => 'Error fetching data: ' . $e->getMessage()
    ]);
}
?>

