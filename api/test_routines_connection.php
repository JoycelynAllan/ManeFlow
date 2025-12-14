<?php
/**
 * Diagnostic script to test routine generation connection and tables
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
$diagnostics = [];

try {
    // Test 1: Database connection
    $conn = getDBConnection();
    $diagnostics['connection'] = 'SUCCESS';
    $diagnostics['database'] = $conn->query("SELECT DATABASE()")->fetch_row()[0];
    
    // Test 2: Check if child_id parameter exists
    if (isset($_GET['child_id'])) {
        $childId = (int)$_GET['child_id'];
        $diagnostics['child_id'] = $childId;
        
        // Test 3: Check users table
        $testUsers = $conn->query("SHOW TABLES LIKE 'users'");
        $diagnostics['users_table_exists'] = $testUsers->num_rows > 0;
        
        if ($testUsers->num_rows > 0) {
            // Test 4: Check users table structure
            $columns = $conn->query("SHOW COLUMNS FROM users");
            $userColumns = [];
            while ($col = $columns->fetch_assoc()) {
                $userColumns[] = $col['Field'];
            }
            $diagnostics['users_columns'] = $userColumns;
            
            // Test 5: Try to verify child
            $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
            if (!$verifyStmt) {
                $diagnostics['verify_prepare_error'] = $conn->error;
            } else {
                $verifyStmt->bind_param("ii", $childId, $userId);
                $verifyStmt->execute();
                $verifyResult = $verifyStmt->get_result();
                $diagnostics['child_verification'] = $verifyResult->num_rows > 0 ? 'VALID' : 'INVALID';
                $verifyStmt->close();
                
                if ($verifyResult->num_rows > 0) {
                    $userId = $childId;
                }
            }
        }
    }
    
    // Test 6: Check user_hair_profiles table
    $testProfiles = $conn->query("SHOW TABLES LIKE 'user_hair_profiles'");
    $diagnostics['user_hair_profiles_exists'] = $testProfiles->num_rows > 0;
    
    if ($testProfiles->num_rows > 0) {
        // Test 7: Try to get profile
        $profileStmt = $conn->prepare("SELECT profile_id FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
        if (!$profileStmt) {
            $diagnostics['profile_prepare_error'] = $conn->error;
        } else {
            $profileStmt->bind_param("i", $userId);
            $profileStmt->execute();
            $profile = $profileStmt->get_result()->fetch_assoc();
            $diagnostics['profile_found'] = $profile ? 'YES' : 'NO';
            if ($profile) {
                $diagnostics['profile_id'] = $profile['profile_id'];
            }
            $profileStmt->close();
        }
    }
    
    // Test 8: Check hair_care_routines table
    $testRoutines = $conn->query("SHOW TABLES LIKE 'hair_care_routines'");
    $diagnostics['hair_care_routines_exists'] = $testRoutines->num_rows > 0;
    
    if ($testRoutines->num_rows > 0) {
        // Test 9: Check table structure
        $columns = $conn->query("SHOW COLUMNS FROM hair_care_routines");
        $routineColumns = [];
        while ($col = $columns->fetch_assoc()) {
            $routineColumns[] = $col['Field'];
        }
        $diagnostics['hair_care_routines_columns'] = $routineColumns;
        
        // Test 10: Try to prepare UPDATE statement
        $updateStmt = $conn->prepare("UPDATE hair_care_routines SET is_active = 0 WHERE profile_id = 1");
        if (!$updateStmt) {
            $diagnostics['update_prepare_error'] = $conn->error;
        } else {
            $diagnostics['update_prepare'] = 'SUCCESS';
            $updateStmt->close();
        }
        
        // Test 11: Try to prepare INSERT statement
        $insertStmt = $conn->prepare("INSERT INTO hair_care_routines (profile_id, routine_name, routine_type, description, is_active, last_update_alert, update_frequency_days) VALUES (1, 'Test', 'morning', 'Test', 1, CURDATE(), 90)");
        if (!$insertStmt) {
            $diagnostics['insert_prepare_error'] = $conn->error;
        } else {
            $diagnostics['insert_prepare'] = 'SUCCESS';
            $insertStmt->close();
        }
    }
    
    $conn->close();
    
    echo json_encode([
        'success' => true,
        'diagnostics' => $diagnostics
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'diagnostics' => $diagnostics
    ], JSON_PRETTY_PRINT);
}
