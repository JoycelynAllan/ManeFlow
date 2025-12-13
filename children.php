<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Check if parent_user_id column exists
$checkColumn = $conn->query("SHOW COLUMNS FROM `users` LIKE 'parent_user_id'");
if ($checkColumn->num_rows === 0) {
    $conn->close();
    $pageTitle = 'Migration Required';
    include 'includes/header.php';
    ?>
    <div class="container">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Database Migration Required!</strong>
                <p>The parent-child feature requires a database migration to be run first.</p>
                <p>Please run the migration by visiting: <a href="run_migration.php?key=migrate2024" style="color: var(--primary-color); font-weight: bold;">run_migration.php?key=migrate2024</a></p>
                <p><small>This will add the necessary column to support parent-child accounts.</small></p>
            </div>
        </div>
    </div>
    <?php
    include 'includes/footer.php';
    exit;
}

$error = '';
$success = '';

// Check for success message from redirect
if (isset($_GET['success'])) {
    $success = urldecode($_GET['success']);
}

// Enable error reporting for debugging (remove in production)
error_reporting(E_ALL);
ini_set('display_errors', 0); // Don't display on page, but log them

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    error_log("POST request received. POST data: " . print_r($_POST, true));
    
    if (isset($_POST['add_child'])) {
        error_log("add_child button was clicked");
        // Add a new child account using stored procedure
        $childFirstName = trim($_POST['child_first_name'] ?? '');
        $childLastName = trim($_POST['child_last_name'] ?? '');
        $childGender = $_POST['child_gender'] ?? 'female';
        $childDateOfBirth = $_POST['child_date_of_birth'] ?? '';
        
        error_log("Form submitted - First Name: '$childFirstName', DOB: '$childDateOfBirth', Gender: '$childGender'");
        
        if (empty($childFirstName)) {
            $error = 'Please enter the child\'s first name.';
            error_log("Validation failed - First Name is empty");
        } elseif (empty($childDateOfBirth)) {
            $error = 'Please enter the child\'s date of birth.';
            error_log("Validation failed - Date of Birth is empty. Received: '" . ($_POST['child_date_of_birth'] ?? 'NOT SET') . "'");
        } else {
            // Validate date of birth format - try multiple formats
            $dob = null;
            $dateFormats = ['Y-m-d', 'd/m/Y', 'm/d/Y', 'Y/m/d'];
            
            foreach ($dateFormats as $format) {
                $dob = DateTime::createFromFormat($format, $childDateOfBirth);
                if ($dob && $dob->format($format) === $childDateOfBirth) {
                    // Convert to standard format
                    $childDateOfBirth = $dob->format('Y-m-d');
                    error_log("Date parsed successfully using format $format: $childDateOfBirth");
                    break;
                }
            }
            
            if (!$dob) {
                $error = 'Invalid date of birth format. Please use YYYY-MM-DD format (e.g., 2019-03-14).';
                error_log("Date validation failed for: '$childDateOfBirth'");
            } else {
                // Validate child age first
                $today = new DateTime();
                $dob = new DateTime($childDateOfBirth);
                $age = $today->diff($dob)->y;
                
                if ($age >= 13) {
                    $error = 'Children must be under 13 years old. Users 13 and older should create their own account.';
                } elseif ($age < 0 || $age > 12) {
                    $error = 'Please enter a valid date of birth for a child (under 13 years old).';
                } else {
                    // Use direct insert method (simpler and more reliable)
                    $childCreated = false;
                    
                    // Generate a unique email for the child account
                    $parentEmailStmt = $conn->prepare("SELECT email FROM users WHERE user_id = ?");
                    if (!$parentEmailStmt) {
                        $error = 'Failed to get parent email: ' . $conn->error;
                        error_log("Error getting parent email: " . $conn->error);
                    } else {
                        $parentEmailStmt->bind_param("i", $userId);
                        if (!$parentEmailStmt->execute()) {
                            $error = 'Failed to execute parent email query: ' . $parentEmailStmt->error;
                            error_log("Parent email execute error: " . $parentEmailStmt->error);
                            $parentEmailStmt->close();
                        } else {
                            $parentEmailResult = $parentEmailStmt->get_result();
                            $parentEmailRow = $parentEmailResult->fetch_assoc();
                            $parentEmailStmt->close();
                            
                            if (!$parentEmailRow) {
                                $error = 'Parent account not found. Please log out and log back in.';
                                error_log("Parent account not found for user_id: $userId");
                            } else {
                                $parentEmail = $parentEmailRow['email'];
                                
                                $parentEmailParts = explode('@', $parentEmail);
                                $childEmail = $parentEmailParts[0] . '.' . strtolower(preg_replace('/[^a-z0-9]/', '', $childFirstName)) . time() . '@maneflow.child';
                                
                                // Generate a secure random password for the child account
                                $childPassword = bin2hex(random_bytes(16));
                                $childPasswordHash = password_hash($childPassword, PASSWORD_DEFAULT);
                                
                                error_log("Attempting to insert child: email=$childEmail, parent_id=$userId, age=$age, first_name=$childFirstName");
                                
                                // Create child account with all new fields
                                $insertStmt = $conn->prepare("INSERT INTO users (email, password_hash, first_name, last_name, gender, date_of_birth, parent_user_id, is_child_account, child_age_when_created, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, 1)");
                                
                                if (!$insertStmt) {
                                    $error = 'Failed to prepare insert statement: ' . $conn->error;
                                    error_log("Prepare error: " . $conn->error);
                                } else {
                                    // Log all values being inserted
                                    error_log("Binding parameters - Email: $childEmail, FirstName: $childFirstName, LastName: $childLastName, Gender: $childGender, DOB: $childDateOfBirth, ParentID: $userId, Age: $age");
                                    
                                    $insertStmt->bind_param("ssssssii", $childEmail, $childPasswordHash, $childFirstName, $childLastName, $childGender, $childDateOfBirth, $userId, $age);
                                    
                                    // Enable error reporting for this operation
                                    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
                                    
                                    try {
                                        if ($insertStmt->execute()) {
                                            $childUserId = $conn->insert_id;
                                            error_log("SUCCESS: Child account created with ID: $childUserId, email: $childEmail");
                                            
                                            // Log the activity if table exists
                                            $logStmt = $conn->prepare("INSERT INTO parent_child_activity_log (parent_user_id, child_user_id, action_type, action_details) VALUES (?, ?, 'created', ?)");
                                            if ($logStmt) {
                                                $details = "Created child account for {$childFirstName}";
                                                $logStmt->bind_param("iis", $userId, $childUserId, $details);
                                                $logStmt->execute();
                                                $logStmt->close();
                                            }
                                            
                                            // Close connection before redirect
                                            $conn->close();
                                            
                                            // Redirect to show the new child in the list
                                            header("Location: children.php?success=" . urlencode("Child account created successfully for {$childFirstName}! The account email is: {$childEmail}"));
                                            exit;
                                        } else {
                                            $errorMsg = $insertStmt->error;
                                            $errorCode = $insertStmt->errno;
                                            $error = 'Failed to create child account: ' . $errorMsg . ' (Error Code: ' . $errorCode . ')';
                                            error_log("Insert execute error: " . $errorMsg . " (Code: " . $errorCode . ")");
                                        }
                                    } catch (mysqli_sql_exception $e) {
                                        $error = 'Database error: ' . $e->getMessage();
                                        error_log("Database exception: " . $e->getMessage());
                                    } finally {
                                        mysqli_report(MYSQLI_REPORT_OFF);
                                        $insertStmt->close();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    } elseif (isset($_POST['delete_child'])) {
        // Delete a child account
        $childId = (int)$_POST['child_id'];
        
        // Verify this child belongs to the current user using stored procedure
        $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
        $verifyStmt->bind_param("ii", $userId, $childId);
        $verifyStmt->execute();
        $verifyResult = $verifyStmt->get_result();
        $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
        $verifyStmt->close();
        while ($conn->next_result()) {
            $conn->store_result();
        }
        
        if ($isValid) {
            // Log the deletion activity
            $logStmt = $conn->prepare("INSERT INTO parent_child_activity_log (parent_user_id, child_user_id, action_type, action_details) VALUES (?, ?, 'deleted', 'Parent deleted child account')");
            $logStmt->bind_param("ii", $userId, $childId);
            $logStmt->execute();
            $logStmt->close();
            
            // Delete child account (CASCADE will handle related records)
            $deleteStmt = $conn->prepare("DELETE FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
            $deleteStmt->bind_param("ii", $childId, $userId);
            if ($deleteStmt->execute()) {
                $success = 'Child account deleted successfully.';
            } else {
                $error = 'Failed to delete child account.';
            }
            $deleteStmt->close();
        } else {
            $error = 'Child account not found or you do not have permission to delete it.';
        }
    }
}

// Get all children for this parent using stored procedure
// Get all children for this parent using stored procedure
$childrenStmt = $conn->prepare("CALL sp_get_parent_children(?)");
$childrenStmt->bind_param("i", $userId);
$childrenStmt->execute();
$result = $childrenStmt->get_result();
$children = [];
while ($row = $result->fetch_assoc()) {
    $children[] = $row;
}
$childrenStmt->close();

// Clear any additional result sets from the stored procedure
while ($conn->more_results() && $conn->next_result()) {
    $conn->store_result();
}

// Now process the children to add age groups (after the previous statement is fully closed)
foreach ($children as &$child) {
    if (!empty($child['date_of_birth'])) {
        $ageGroupStmt = $conn->prepare("SELECT fn_get_age_group(?) as age_group");
        if ($ageGroupStmt) {
            $ageGroupStmt->bind_param("s", $child['date_of_birth']);
            $ageGroupStmt->execute();
            $ageGroupResult = $ageGroupStmt->get_result()->fetch_assoc();
            $child['age_group'] = $ageGroupResult['age_group'] ?? null;
            $ageGroupStmt->close();
        } else {
             // Fallback if prepare fails
             error_log("Failed to prepare age group statement: " . $conn->error);
             $child['age_group'] = null;
        }
    }
}
unset($child); // Break reference

$conn->close();

$pageTitle = 'My Children';
include 'includes/header.php';
?>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-child"></i> My Children</h1>
        <p>Manage your children's hair care profiles and monitor their progress</p>
    </div>
    
    <!-- Always show POST status for debugging -->
    <?php if ($_SERVER['REQUEST_METHOD'] === 'POST'): ?>
        <div class="alert" style="background-color: #ffffcc; border: 2px solid #ffcc00; padding: 1rem; margin: 1rem 0; border-radius: 4px;">
            <strong>Form Submitted!</strong><br>
            Method: <?php echo $_SERVER['REQUEST_METHOD']; ?><br>
            add_child button: <?php echo isset($_POST['add_child']) ? 'YES' : 'NO'; ?><br>
            First Name: <?php echo htmlspecialchars($_POST['child_first_name'] ?? 'NOT SET'); ?><br>
            Date of Birth: <?php echo htmlspecialchars($_POST['child_date_of_birth'] ?? 'NOT SET'); ?><br>
        </div>
    <?php endif; ?>
    
    <?php if (!empty($error)): ?>
        <div class="alert alert-error" style="background-color: #fee; border: 2px solid #f00; padding: 1rem; margin: 1rem 0; border-radius: 4px;">
            <i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> <?php echo htmlspecialchars($error); ?>
        </div>
    <?php endif; ?>
    
    <?php if (!empty($success)): ?>
        <div class="alert alert-success" style="background-color: #efe; border: 2px solid #0f0; padding: 1rem; margin: 1rem 0; border-radius: 4px;">
            <i class="fas fa-check-circle"></i> <strong>Success:</strong> <?php echo htmlspecialchars($success); ?>
        </div>
    <?php endif; ?>
    
    <?php 
    // Debug: Show POST data if in development
    if (isset($_POST['add_child']) && !empty($_POST)): 
    ?>
        <div style="background: #f0f0f0; padding: 1rem; margin: 1rem 0; border-radius: 4px; font-size: 0.9rem;">
            <strong>Debug Info:</strong><br>
            POST received: <?php echo isset($_POST['add_child']) ? 'Yes' : 'No'; ?><br>
            First Name: <?php echo htmlspecialchars($_POST['child_first_name'] ?? 'NOT SET'); ?><br>
            Date of Birth: <?php echo htmlspecialchars($_POST['child_date_of_birth'] ?? 'NOT SET'); ?><br>
            User ID: <?php echo $userId; ?>
        </div>
    <?php endif; ?>
    
    <!-- Add Child Form -->
    <div class="card" style="margin-bottom: 2rem;">
        <h2><i class="fas fa-plus-circle"></i> Add a Child</h2>
        <form method="POST" action="children.php" class="profile-form" id="addChildForm" onsubmit="console.log('Form submitting...', this); return true;">
            <div class="form-row">
                <div class="form-group">
                    <label for="child_first_name">First Name <span class="required">*</span></label>
                    <input type="text" id="child_first_name" name="child_first_name" required
                           value="<?php echo htmlspecialchars($_POST['child_first_name'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="child_last_name">Last Name</label>
                    <input type="text" id="child_last_name" name="child_last_name"
                           value="<?php echo htmlspecialchars($_POST['child_last_name'] ?? ''); ?>">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="child_gender">Gender</label>
                    <select id="child_gender" name="child_gender">
                        <option value="female" <?php echo ($_POST['child_gender'] ?? 'female') === 'female' ? 'selected' : ''; ?>>Female</option>
                        <option value="male" <?php echo ($_POST['child_gender'] ?? '') === 'male' ? 'selected' : ''; ?>>Male</option>
                        <option value="other" <?php echo ($_POST['child_gender'] ?? '') === 'other' ? 'selected' : ''; ?>>Other</option>
                        <option value="prefer_not_to_say" <?php echo ($_POST['child_gender'] ?? '') === 'prefer_not_to_say' ? 'selected' : ''; ?>>Prefer not to say</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="child_date_of_birth">Date of Birth <span class="required">*</span></label>
                    <input type="date" id="child_date_of_birth" name="child_date_of_birth" required
                           value="<?php echo htmlspecialchars($_POST['child_date_of_birth'] ?? ''); ?>"
                           max="<?php echo date('Y-m-d', strtotime('-1 day')); ?>"
                           min="<?php echo date('Y-m-d', strtotime('-12 years')); ?>">
                    <small>Child must be under 13 years old</small>
                </div>
            </div>
            
            <input type="hidden" name="add_child" value="1">
            <button type="submit" name="add_child" value="1" class="btn btn-primary" id="addChildBtn">
                <i class="fas fa-user-plus"></i> Add Child
            </button>
        </form>
    </div>
    
    <script>
    // Debug: Log form submission
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('addChildForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                console.log('Form submit event fired');
                var formData = new FormData(this);
                for (var pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }
            });
        }
        
        var btn = document.getElementById('addChildBtn');
        if (btn) {
            btn.addEventListener('click', function(e) {
                console.log('Add Child button clicked');
            });
        }
    });
    </script>
    
    <!-- Children List -->
    <div class="card">
        <h2><i class="fas fa-users"></i> My Children (<?php echo count($children); ?>)</h2>
        
        <?php if (empty($children)): ?>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> You haven't added any children yet. Add a child above to get started!
            </div>
        <?php else: ?>
            <div class="children-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <?php foreach ($children as $child): ?>
                    <div class="child-card" style="border: 1px solid var(--border-color); border-radius: 8px; padding: 1.5rem; background: var(--card-bg);">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                            <div>
                                <h3 style="margin: 0; color: var(--primary-color);">
                                    <i class="fas fa-child"></i> <?php echo htmlspecialchars($child['first_name'] . ' ' . ($child['last_name'] ?? '')); ?>
                                </h3>
                                <p style="margin: 0.5rem 0 0 0; color: var(--text-light); font-size: 0.9rem;">
                                    Age: <?php echo $child['current_age']; ?> years old<?php if (isset($child['age_group'])): ?> (<?php echo ucfirst(str_replace('_', ' ', $child['age_group'])); ?>)<?php endif; ?>
                                </p>
                            </div>
                        </div>
                        
                        <div style="margin-bottom: 1rem;">
                            <p style="margin: 0.5rem 0; font-size: 0.9rem;">
                                <strong>Profile Status:</strong> 
                                <?php if ($child['has_profile']): ?>
                                    <span style="color: var(--success-color);"><i class="fas fa-check-circle"></i> Profile Created</span>
                                <?php else: ?>
                                    <span style="color: var(--warning-color);"><i class="fas fa-exclamation-circle"></i> No Profile Yet</span>
                                <?php endif; ?>
                            </p>
                            <?php if (isset($child['account_created'])): ?>
                                <p style="margin: 0.5rem 0; font-size: 0.85rem; color: var(--text-light);">
                                    Account created: <?php echo date('M j, Y', strtotime($child['account_created'])); ?>
                                </p>
                            <?php endif; ?>
                        </div>
                        
<div style="display: flex; flex-direction: column; gap: 0.5rem; margin-top: 1rem;">
                            <?php if ($child['has_profile']): ?>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem;">
                                    <a href="recommendations.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-primary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-lightbulb"></i> Recommendations
                                    </a>
                                    <a href="routines.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-primary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-calendar-check"></i> Routines
                                    </a>
                                    <a href="styles.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-palette"></i> Styles
                                    </a>
                                    <a href="forecast.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-chart-line"></i> Forecast
                                    </a>
                                    <a href="diagnosis.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-stethoscope"></i> Diagnosis
                                    </a>
                                    <a href="education.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 0.5rem;">
                                        <i class="fas fa-book"></i> Education
                                    </a>
                                </div>
                                <div style="display: flex; gap: 0.5rem; margin-top: 0.5rem;">
                                    <a href="profile.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-secondary" style="flex: 1; font-size: 0.9rem;">
                                        <i class="fas fa-edit"></i> Edit Profile
                                    </a>
                                    <form method="POST" action="children.php" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this child account? This action cannot be undone.');">
                                        <input type="hidden" name="child_id" value="<?php echo $child['user_id']; ?>">
                                        <button type="submit" name="delete_child" class="btn btn-danger" title="Delete Child Account">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            <?php else: ?>
                                <div style="display: flex; gap: 0.5rem;">
                                    <a href="profile.php?child_id=<?php echo $child['user_id']; ?>" class="btn btn-primary" style="flex: 1;">
                                        <i class="fas fa-plus-circle"></i> Create Profile
                                    </a>
                                    <form method="POST" action="children.php" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this child account? This action cannot be undone.');">
                                        <input type="hidden" name="child_id" value="<?php echo $child['user_id']; ?>">
                                        <button type="submit" name="delete_child" class="btn btn-danger" title="Delete Child Account">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </div>
</div>

<?php include 'includes/footer.php'; ?>

