<?php
/**
 * Checks if all required tables, columns, and procedures exist for parent-child feature
 */

require_once 'config/db.php';

$conn = getDBConnection();
$issues = [];
$success = [];

echo "<!DOCTYPE html><html><head><title>Database Check</title>";
echo "<style>body{font-family:Arial;padding:20px;} .success{color:green;} .error{color:red;} .warning{color:orange;} table{border-collapse:collapse;width:100%;margin:20px 0;} th,td{border:1px solid #ddd;padding:8px;text-align:left;} th{background:#f0f0f0;}</style>";
echo "</head><body><h1>Database Diagnostic Check</h1>";

//Check 1: parent_user_id column
echo "<h2>1. Checking users table columns...</h2>";
$columns = $conn->query("SHOW COLUMNS FROM users");
$columnNames = [];
while ($row = $columns->fetch_assoc()) {
    $columnNames[] = $row['Field'];
}

$requiredColumns = ['parent_user_id', 'is_child_account', 'child_age_when_created'];
foreach ($requiredColumns as $col) {
    if (in_array($col, $columnNames)) {
        echo "<p class='success'>✓ Column '$col' exists</p>";
        $success[] = "Column $col exists";
    } else {
        echo "<p class='error'>✗ Column '$col' is MISSING</p>";
        $issues[] = "Column $col is missing";
    }
}

// Check 2: parent_child_activity_log table
echo "<h2>2. Checking parent_child_activity_log table...</h2>";
$tableCheck = $conn->query("SHOW TABLES LIKE 'parent_child_activity_log'");
if ($tableCheck->num_rows > 0) {
    echo "<p class='success'>✓ Table 'parent_child_activity_log' exists</p>";
    $success[] = "parent_child_activity_log table exists";
    
    // Checks columns
    $logColumns = $conn->query("SHOW COLUMNS FROM parent_child_activity_log");
    $logColumnNames = [];
    while ($row = $logColumns->fetch_assoc()) {
        $logColumnNames[] = $row['Field'];
    }
    echo "<p>Columns: " . implode(', ', $logColumnNames) . "</p>";
} else {
    echo "<p class='error'>✗ Table 'parent_child_activity_log' is MISSING</p>";
    $issues[] = "parent_child_activity_log table is missing";
}

// Check 3: Stored procedures
echo "<h2>3. Checking stored procedures...</h2>";
$procedures = ['sp_add_child_account', 'sp_get_parent_children', 'sp_verify_parent_child'];
foreach ($procedures as $proc) {
    $procCheck = $conn->query("SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name = '$proc'");
    if ($procCheck && $procCheck->num_rows > 0) {
        echo "<p class='success'>✓ Procedure '$proc' exists</p>";
        $success[] = "Procedure $proc exists";
    } else {
        echo "<p class='error'>✗ Procedure '$proc' is MISSING</p>";
        $issues[] = "Procedure $proc is missing";
    }
}

// Check 4: Foreign key constraint
echo "<h2>4. Checking foreign key constraints...</h2>";
$fkCheck = $conn->query("
    SELECT CONSTRAINT_NAME 
    FROM information_schema.TABLE_CONSTRAINTS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'users' 
    AND CONSTRAINT_TYPE = 'FOREIGN KEY' 
    AND CONSTRAINT_NAME = 'fk_user_parent'
");
if ($fkCheck && $fkCheck->num_rows > 0) {
    echo "<p class='success'>✓ Foreign key 'fk_user_parent' exists</p>";
    $success[] = "Foreign key constraint exists";
} else {
    echo "<p class='warning'>⚠ Foreign key 'fk_user_parent' is MISSING (may cause issues)</p>";
    $issues[] = "Foreign key constraint missing";
}

// Check 5: Tests insert statement structure
echo "<h2>5. Testing INSERT statement structure...</h2>";
$testStmt = $conn->prepare("INSERT INTO users (email, password_hash, first_name, last_name, gender, date_of_birth, parent_user_id, is_child_account, child_age_when_created, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, 1)");
if ($testStmt) {
    echo "<p class='success'>✓ INSERT statement can be prepared</p>";
    $testStmt->close();
} else {
    echo "<p class='error'>✗ Cannot prepare INSERT statement: " . $conn->error . "</p>";
    $issues[] = "Cannot prepare INSERT: " . $conn->error;
}

// Check 6: Checks current user
echo "<h2>6. Checking current logged-in user...</h2>";
if (isset($_SESSION['user_id'])) {
    $userId = $_SESSION['user_id'];
    $userCheck = $conn->prepare("SELECT user_id, email, first_name, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) as age FROM users WHERE user_id = ?");
    $userCheck->bind_param("i", $userId);
    $userCheck->execute();
    $user = $userCheck->get_result()->fetch_assoc();
    $userCheck->close();
    
    if ($user) {
        echo "<p class='success'>✓ Current user found: {$user['email']} (ID: {$user['user_id']})</p>";
        echo "<p>Name: {$user['first_name']}</p>";
        echo "<p>Age: {$user['age']} years</p>";
        if ($user['age'] < 13) {
            echo "<p class='error'>✗ WARNING: Current user is under 13! Cannot create child accounts.</p>";
            $issues[] = "Current user is under 13 years old";
        }
    } else {
        echo "<p class='error'>✗ Current user not found in database</p>";
        $issues[] = "Current user not found";
    }
} else {
    echo "<p class='warning'>⚠ No user logged in. Please log in first.</p>";
}

// Check 7: Tests stored procedure call (if it exists)
echo "<h2>7. Testing stored procedure (if exists)...</h2>";
$procExists = $conn->query("SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name = 'sp_add_child_account'");
if ($procExists && $procExists->num_rows > 0) {
    // Just checks if we can prepare it, doesn't execute
    $testProc = $conn->prepare("CALL sp_add_child_account(?, ?, ?, ?, ?)");
    if ($testProc) {
        echo "<p class='success'>✓ Stored procedure can be prepared</p>";
        $testProc->close();
    } else {
        echo "<p class='error'>✗ Cannot prepare stored procedure: " . $conn->error . "</p>";
        $issues[] = "Cannot prepare stored procedure: " . $conn->error;
    }
} else {
    echo "<p class='warning'>⚠ Stored procedure doesn't exist, skipping test</p>";
}

// Check 8: Check for triggers
echo "<h2>8. Checking triggers...</h2>";
$triggers = $conn->query("SHOW TRIGGERS WHERE `Table` = 'users'");
if ($triggers) {
    $triggerList = [];
    while ($row = $triggers->fetch_assoc()) {
        $triggerList[] = $row['Trigger'];
        echo "<p>Trigger: <strong>{$row['Trigger']}</strong> - {$row['Event']} {$row['Timing']}</p>";
    }
    if (in_array('trg_prevent_child_as_parent', $triggerList)) {
        echo "<p class='success'>✓ Trigger 'trg_prevent_child_as_parent' exists (prevents child accounts from creating children)</p>";
    }
} else {
    echo "<p class='warning'>⚠ Could not check triggers</p>";
}

// Check 9: Test actual insert with sample data (if user is logged in)
if (isset($_SESSION['user_id'])) {
    echo "<h2>9. Testing actual INSERT (dry run - will rollback)...</h2>";
    $conn->autocommit(FALSE);
    $conn->begin_transaction();
    
    try {
        $testEmail = 'test.child.' . time() . '@maneflow.child';
        $testPassword = password_hash('test123', PASSWORD_DEFAULT);
        $testFirstName = 'Test';
        $testLastName = 'Child';
        $testGender = 'female';
        $testDOB = date('Y-m-d', strtotime('-5 years'));
        $testParentId = $_SESSION['user_id'];
        $testAge = 5;
        
        $testInsert = $conn->prepare("INSERT INTO users (email, password_hash, first_name, last_name, gender, date_of_birth, parent_user_id, is_child_account, child_age_when_created, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, 1)");
        $testInsert->bind_param("ssssssii", $testEmail, $testPassword, $testFirstName, $testLastName, $testGender, $testDOB, $testParentId, $testAge);
        
        if ($testInsert->execute()) {
            echo "<p class='success'>✓ Test INSERT succeeded! The database structure is correct.</p>";
            $testInsert->close();
            $conn->rollback(); // Rollback the test insert
        } else {
            echo "<p class='error'>✗ Test INSERT FAILED: " . $testInsert->error . "</p>";
            echo "<p class='error'>Error Code: " . $testInsert->errno . "</p>";
            $issues[] = "Test INSERT failed: " . $testInsert->error;
            $testInsert->close();
        }
    } catch (Exception $e) {
        echo "<p class='error'>✗ Exception during test INSERT: " . $e->getMessage() . "</p>";
        $issues[] = "Exception: " . $e->getMessage();
    }
    
    $conn->rollback();
    $conn->autocommit(TRUE);
}

// Summary
echo "<h2>Summary</h2>";
echo "<table>";
echo "<tr><th>Status</th><th>Count</th></tr>";
echo "<tr><td class='success'>Success</td><td>" . count($success) . "</td></tr>";
echo "<tr><td class='error'>Issues Found</td><td>" . count($issues) . "</td></tr>";
echo "</table>";

if (count($issues) > 0) {
    echo "<h3 class='error'>Issues that need to be fixed:</h3>";
    echo "<ul>";
    foreach ($issues as $issue) {
        echo "<li class='error'>$issue</li>";
    }
    echo "</ul>";
    
    echo "<h3>SQL to fix missing items:</h3>";
    echo "<pre style='background:#f0f0f0;padding:10px;border:1px solid #ccc;'>";
    
    if (in_array("Column parent_user_id is missing", $issues) || 
        in_array("Column is_child_account is missing", $issues) || 
        in_array("Column child_age_when_created is missing", $issues)) {
        echo "-- Add missing columns:\n";
        echo "ALTER TABLE `users` \n";
        if (!in_array('parent_user_id', $columnNames)) {
            echo "  ADD COLUMN `parent_user_id` INT(11) NULL DEFAULT NULL AFTER `hormonal_status`,\n";
        }
        if (!in_array('is_child_account', $columnNames)) {
            echo "  ADD COLUMN `is_child_account` TINYINT(1) DEFAULT 0 AFTER `parent_user_id`,\n";
        }
        if (!in_array('child_age_when_created', $columnNames)) {
            echo "  ADD COLUMN `child_age_when_created` INT(11) DEFAULT NULL AFTER `is_child_account`,\n";
        }
        echo "  ADD KEY `idx_parent_user` (`parent_user_id`),\n";
        echo "  ADD KEY `idx_child_account` (`is_child_account`);\n\n";
    }
    
    if (in_array("parent_child_activity_log table is missing", $issues)) {
        echo "-- Create parent_child_activity_log table:\n";
        echo "CREATE TABLE `parent_child_activity_log` (\n";
        echo "  `log_id` INT(11) NOT NULL AUTO_INCREMENT,\n";
        echo "  `parent_user_id` INT(11) NOT NULL,\n";
        echo "  `child_user_id` INT(11) NOT NULL,\n";
        echo "  `action_type` ENUM('created','viewed_profile','edited_profile','viewed_progress','viewed_recommendations','deleted') NOT NULL,\n";
        echo "  `action_details` TEXT DEFAULT NULL,\n";
        echo "  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\n";
        echo "  PRIMARY KEY (`log_id`),\n";
        echo "  KEY `idx_parent_activity` (`parent_user_id`),\n";
        echo "  KEY `idx_child_activity` (`child_user_id`),\n";
        echo "  CONSTRAINT `parent_child_activity_log_ibfk_1` FOREIGN KEY (`parent_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,\n";
        echo "  CONSTRAINT `parent_child_activity_log_ibfk_2` FOREIGN KEY (`child_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE\n";
        echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n";
    }
    
    echo "</pre>";
} else {
    echo "<p class='success'><strong>✓ All checks passed! Database structure looks good.</strong></p>";
    echo "<p>If child accounts still aren't being created, the issue is likely in the PHP code logic, not the database structure.</p>";
}

$conn->close();
echo "</body></html>";
?>

