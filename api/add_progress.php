<?php
/**
 * Add hair growth progress entry
 */

// Start output buffering and error handling
ob_start();
error_reporting(E_ALL);
ini_set('display_errors', 0);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Set JSON header immediately
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    ob_clean();
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

try {
    require_once __DIR__ . '/../config/db.php';
} catch (Exception $e) {
    ob_clean();
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Failed to load database configuration']);
    ob_end_flush();
    exit;
}

$userId = $_SESSION['user_id'];

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    // Verify this child belongs to the current user (parent) using direct query
    // Replacing stored procedure to avoid issues on servers without routine permissions
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    $verifyStmt->bind_param("ii", $childId, $userId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->num_rows > 0;
    $verifyStmt->close();
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
    } else {
        ob_clean();
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Unauthorized access to child profile']);
        ob_end_flush();
        exit;
    }
}
$length = isset($_POST['length']) ? (float)$_POST['length'] : 0;
$notes = isset($_POST['notes']) ? trim($_POST['notes']) : '';

if ($length <= 0) {
    ob_clean();
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Invalid length. Please enter a valid number greater than 0.']);
    ob_end_flush();
    exit;
}

try {
    $conn = getDBConnection();
    
    // Get user's profile
    $profileStmt = $conn->prepare("SELECT profile_id FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
    if (!$profileStmt) {
        throw new Exception("Profile query failed: " . $conn->error);
    }
    $profileStmt->bind_param("i", $userId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();
    
    if (!$profile) {
        $conn->close();
        ob_clean();
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'No profile found. Please create your hair profile first.']);
        ob_end_flush();
        exit;
    }
    
    // Get the most recent entry date to ensure we use a different date
    $checkStmt = $conn->prepare("
        SELECT measurement_date 
        FROM hair_growth_progress 
        WHERE profile_id = ? 
        ORDER BY measurement_date DESC 
        LIMIT 1
    ");
    $checkStmt->bind_param("i", $profile['profile_id']);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    $lastEntry = $result->fetch_assoc();
    $checkStmt->close();
    
    // Determine the date to use
    // Strategy: Find the next available date going backwards from today
    // This allows generating history quickly for testing forecasts
    $today = date('Y-m-d');
    $candidateDate = $today;
    
    // Get all existing dates
    $datesStmt = $conn->prepare("SELECT measurement_date FROM hair_growth_progress WHERE profile_id = ? ORDER BY measurement_date DESC");
    $datesStmt->bind_param("i", $profile['profile_id']);
    $datesStmt->execute();
    $existingDatesResult = $datesStmt->get_result();
    $existingDates = [];
    while ($row = $existingDatesResult->fetch_assoc()) {
        $existingDates[] = $row['measurement_date'];
    }
    $datesStmt->close();
    
    // Find first date not in existing dates
    while (in_array($candidateDate, $existingDates)) {
        $candidateDate = date('Y-m-d', strtotime('-1 day', strtotime($candidateDate)));
    }
    
    $measurementDate = $candidateDate;
    
    // Check if we are "updating" (conceptually we are creating new, but if logic falls back to existing, we update)
    // With the loop above, we will ALWAYS find a new date, so we will ALWAYS Insert.
    // However, keeping update logic just in case we change strategy later or race conditions occur.
    
    $existsStmt = $conn->prepare("SELECT progress_id FROM hair_growth_progress WHERE profile_id = ? AND measurement_date = ?");
    $existsStmt->bind_param("is", $profile['profile_id'], $measurementDate);
    $existsStmt->execute();
    $existing = $existsStmt->get_result()->fetch_assoc();
    $existsStmt->close();
    
    if ($existing) {
        // Update existing entry
        $updateStmt = $conn->prepare("UPDATE hair_growth_progress SET hair_length = ?, notes = ? WHERE progress_id = ?");
        $updateStmt->bind_param("dsi", $length, $notes, $existing['progress_id']);
        
        if ($updateStmt->execute()) {
            $updated = true;
        } else {
             throw new Exception("Failed to update progress entry: " . $updateStmt->error);
        }
        $updateStmt->close();
    } else {
        // Insert new entry with manual ID generation
        $maxIdStmt = $conn->prepare("SELECT MAX(progress_id) as max_id FROM hair_growth_progress");
        $maxIdStmt->execute();
        $maxResult = $maxIdStmt->get_result()->fetch_assoc();
        $nextId = ($maxResult['max_id'] ?? 0) + 1;
        $maxIdStmt->close();

        $insertStmt = $conn->prepare("INSERT INTO hair_growth_progress (progress_id, profile_id, measurement_date, hair_length, notes) VALUES (?, ?, ?, ?, ?)");
        $insertStmt->bind_param("iisds", $nextId, $profile['profile_id'], $measurementDate, $length, $notes);
        
        if ($insertStmt->execute()) {
            $updated = false;
        } else {
            throw new Exception("Failed to add progress entry: " . $insertStmt->error);
        }
        $insertStmt->close();
    }
    
    // Update profile current length
    $updateProfileStmt = $conn->prepare("UPDATE user_hair_profiles SET current_length = ? WHERE profile_id = ?");
    if ($updateProfileStmt) {
        $updateProfileStmt->bind_param("di", $length, $profile['profile_id']);
        $updateProfileStmt->execute();
        $updateProfileStmt->close();
    }
    
    $conn->close();
    
    ob_clean();
    echo json_encode([
        'success' => true, 
        'message' => $updated ? 'Progress entry updated successfully' : 'Progress entry added successfully',
        'length' => $length,
        'date' => $measurementDate
    ]);
    ob_end_flush();
    exit;
    
} catch (Exception $e) {
    error_log("Add progress error: " . $e->getMessage());
    if (isset($conn)) {
        $conn->close();
    }
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error adding progress: ' . $e->getMessage()
    ]);
    ob_end_flush();
    exit;
}
?>

