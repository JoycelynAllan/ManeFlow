<?php
/**
 * Migration Runner - Add Parent-Child Support
 * Run this file once to add the parent_user_id column to the users table
 */

require_once 'config/db.php';

// Check if user is logged in (optional - you can remove this if you want)
// For security, you might want to add a password check here
$isAdmin = isset($_GET['key']) && $_GET['key'] === 'migrate2024';

if (!$isAdmin) {
    die('Access denied. Add ?key=migrate2024 to the URL to run migration.');
}

$conn = getDBConnection();

$errors = [];
$success = false;

// Check if column already exists
$checkColumn = $conn->query("SHOW COLUMNS FROM `users` LIKE 'parent_user_id'");
$columnExists = $checkColumn->num_rows > 0;

if ($columnExists) {
    $message = "Migration already completed! The 'parent_user_id' column already exists.";
    $success = true;
} else {
    // Run the migration
    try {
        $sql = "ALTER TABLE `users` 
                ADD COLUMN `parent_user_id` INT(11) NULL DEFAULT NULL AFTER `hormonal_status`,
                ADD KEY `idx_parent_user` (`parent_user_id`),
                ADD CONSTRAINT `fk_user_parent` FOREIGN KEY (`parent_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE";
        
        if ($conn->query($sql)) {
            $message = "Migration completed successfully! The 'parent_user_id' column has been added.";
            $success = true;
        } else {
            $message = "Migration failed: " . $conn->error;
            $errors[] = $conn->error;
        }
    } catch (Exception $e) {
        $message = "Migration error: " . $e->getMessage();
        $errors[] = $e->getMessage();
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Migration - Parent-Child Support</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container" style="max-width: 800px; margin: 2rem auto; padding: 2rem;">
        <div class="card">
            <h1><i class="fas fa-database"></i> Database Migration</h1>
            
            <?php if ($success): ?>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <?php echo htmlspecialchars($message); ?>
                </div>
                <p>You can now use the "My Children" feature. <a href="children.php">Go to My Children</a></p>
            <?php else: ?>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($message); ?>
                </div>
                <?php if (!empty($errors)): ?>
                    <div class="alert alert-error">
                        <strong>Errors:</strong>
                        <ul>
                            <?php foreach ($errors as $error): ?>
                                <li><?php echo htmlspecialchars($error); ?></li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>
            <?php endif; ?>
            
            <div style="margin-top: 2rem;">
                <a href="dashboard.php" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>

