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
    
    // Verify this child belongs to the current user (parent) using stored procedure
    $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
    $verifyStmt->bind_param("ii", $userId, $childId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
    $verifyStmt->close();
    
    // Clear results
    while ($conn->next_result()) {
        $conn->store_result();
    }
    $conn->close();
    
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
    $today = date('Y-m-d');
    $measurementDate = $today;
    
    if ($lastEntry) {
        $lastDate = $lastEntry['measurement_date'];
        // If last entry is today or in the future, use yesterday
        if ($lastDate >= $today) {
            $measurementDate = date('Y-m-d', strtotime('-1 day', strtotime($lastDate)));
        } else {
            // Use today if last entry was in the past
            $measurementDate = $today;
        }
    }
    
    // Check if an entry already exists for this date
    $existsStmt = $conn->prepare("
        SELECT progress_id FROM hair_growth_progress 
        WHERE profile_id = ? AND measurement_date = ?
    ");
    $existsStmt->bind_param("is", $profile['profile_id'], $measurementDate);
    $existsStmt->execute();
    $existsResult = $existsStmt->get_result();
    $existing = $existsResult->fetch_assoc();
    $existsStmt->close();
    
    if ($existing) {
        // Update existing entry
        $updateStmt = $conn->prepare("
            UPDATE hair_growth_progress 
            SET hair_length = ?, notes = ? 
            WHERE progress_id = ?
        ");
        if (!$updateStmt) {
            throw new Exception("Update query failed: " . $conn->error);
        }
        $updateStmt->bind_param("dsi", $length, $notes, $existing['progress_id']);
        
        if ($updateStmt->execute()) {
            $updateStmt->close();
            $updated = true;
        } else {
            $updateStmt->close();
            throw new Exception("Failed to update progress entry: " . $updateStmt->error);
        }
    } else {
        // Insert new entry
        $insertStmt = $conn->prepare("INSERT INTO hair_growth_progress 
            (profile_id, measurement_date, hair_length, notes) 
            VALUES (?, ?, ?, ?)");
        
        if (!$insertStmt) {
            throw new Exception("Insert query failed: " . $conn->error);
        }
        
        $insertStmt->bind_param("isds", $profile['profile_id'], $measurementDate, $length, $notes);
        
        if ($insertStmt->execute()) {
            $insertStmt->close();
            $updated = false;
        } else {
            $errorMsg = $insertStmt->error;
            $insertStmt->close();
            throw new Exception("Failed to add progress entry: " . $errorMsg);
        }
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

