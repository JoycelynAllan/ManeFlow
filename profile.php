<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Check if viewing a child's profile
$viewingChildId = null;
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $viewingChildId = (int)$_GET['child_id'];
    
    // Verify this child belongs to the current user (parent) using stored procedure
    $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
    $verifyStmt->bind_param("ii", $userId, $viewingChildId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
    $verifyStmt->close();
    while ($conn->next_result()) {
        $conn->store_result();
    }
    
    if ($isValid) {
        // Get child info
        $childInfoStmt = $conn->prepare("SELECT user_id, first_name, last_name, date_of_birth FROM users WHERE user_id = ? AND is_child_account = 1");
        $childInfoStmt->bind_param("i", $viewingChildId);
        $childInfoStmt->execute();
        $childInfo = $childInfoStmt->get_result()->fetch_assoc();
        $childInfoStmt->close();
        
        if ($childInfo) {
            $isViewingChild = true;
            $userId = $viewingChildId; // Use child's ID for profile operations
            
            // Log activity - parent viewing child profile
            $logStmt = $conn->prepare("INSERT INTO parent_child_activity_log (parent_user_id, child_user_id, action_type, action_details) VALUES (?, ?, 'viewed_profile', 'Parent viewed child profile')");
            $logStmt->bind_param("ii", $_SESSION['user_id'], $viewingChildId);
            $logStmt->execute();
            $logStmt->close();
        } else {
            $conn->close();
            header('Location: children.php?error=unauthorized');
            exit;
        }
    } else {
        // Child doesn't belong to this parent
        $conn->close();
        header('Location: children.php?error=unauthorized');
        exit;
    }
}

// Verify user exists in users table
$userCheckStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? LIMIT 1");
$userCheckStmt->bind_param("i", $userId);
$userCheckStmt->execute();
$userExists = $userCheckStmt->get_result()->fetch_assoc();
$userCheckStmt->close();

if (!$userExists) {
    $conn->close();
    session_destroy();
    header('Location: login.php?error=invalid_user');
    exit;
}

// Get existing profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

// Get hair types - if empty, redirect to setup
$hairTypesStmt = $conn->prepare("SELECT * FROM hair_types ORDER BY type_code");
$hairTypesStmt->execute();
$hairTypes = $hairTypesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$hairTypesStmt->close();

// If no hair types exist, show message and link to setup
if (empty($hairTypes)) {
    $conn->close();
    $pageTitle = 'Setup Required';
    include 'includes/header.php';
    ?>
    <div class="container">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Database Setup Required!</strong>
                <p>The hair types database is empty. Please run the setup script first.</p>
                <a href="setup.php" class="btn btn-primary">
                    <i class="fas fa-cog"></i> Run Setup
                </a>
            </div>
        </div>
    </div>
    <?php
    include 'includes/footer.php';
    exit;
}

// Get hair concerns
$concernsStmt = $conn->prepare("SELECT * FROM hair_concerns ORDER BY concern_name");
$concernsStmt->execute();
$concerns = $concernsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$concernsStmt->close();

$success = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $childId = null;
    // Check if this is for a child profile
    if (isset($_POST['child_id']) || isset($_GET['child_id'])) {
        $childId = (int)($_POST['child_id'] ?? $_GET['child_id']);
        
        // Verify this child belongs to the current user (parent) using stored procedure
        $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
        $verifyStmt->bind_param("ii", $_SESSION['user_id'], $childId);
        $verifyStmt->execute();
        $verifyResult = $verifyStmt->get_result();
        $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
        $verifyStmt->close();
        while ($conn->next_result()) {
            $conn->store_result();
        }
        
        if ($isValid) {
            $isViewingChild = true;
            $userId = $childId; // Use child's ID for profile operations
            
            // Log activity - parent viewing child profile
            $logStmt = $conn->prepare("INSERT INTO parent_child_activity_log (parent_user_id, child_user_id, action_type, action_details) VALUES (?, ?, 'viewed_profile', 'Parent viewed child profile')");
            $logStmt->bind_param("ii", $_SESSION['user_id'], $childId);
            $logStmt->execute();
            $logStmt->close();
        } else {
            $conn->close();
            header('Location: children.php?error=unauthorized');
            exit;
        }
    }
    
    // Helper function to convert empty strings to NULL
    function emptyToNull($value) {
        return ($value === '' || $value === null) ? null : $value;
    }
    
    // Get and sanitize form data, converting empty strings to NULL for enum fields
    $hairTypeId = !empty($_POST['hair_type_id']) ? (int)$_POST['hair_type_id'] : null;
    $hairDensity = emptyToNull($_POST['hair_density'] ?? null);
    $hairPorosity = emptyToNull($_POST['hair_porosity'] ?? null);
    $scalpType = emptyToNull($_POST['scalp_type'] ?? null);
    $currentLength = !empty($_POST['current_length']) ? (float)$_POST['current_length'] : null;
    $goalLength = !empty($_POST['goal_length']) ? (float)$_POST['goal_length'] : null;
    $hairTexture = !empty(trim($_POST['hair_texture'] ?? '')) ? trim($_POST['hair_texture']) : null;
    $elasticity = emptyToNull($_POST['elasticity'] ?? null);
    $isColorTreated = isset($_POST['is_color_treated']) ? 1 : 0;
    $isChemicallyTreated = isset($_POST['is_chemically_treated']) ? 1 : 0;
    $chemicalTreatmentType = !empty(trim($_POST['chemical_treatment_type'] ?? '')) ? trim($_POST['chemical_treatment_type']) : null;
    $selectedConcerns = $_POST['concerns'] ?? [];
    
    // Validate enum values to prevent data truncation errors
    $validScalpTypes = ['dry', 'normal', 'oily', 'combination'];
    if ($scalpType !== null && !in_array($scalpType, $validScalpTypes)) {
        $scalpType = null;
    }
    
    $validDensity = ['low', 'medium', 'high'];
    if ($hairDensity !== null && !in_array($hairDensity, $validDensity)) {
        $hairDensity = null;
    }
    
    $validPorosity = ['low', 'medium', 'high'];
    if ($hairPorosity !== null && !in_array($hairPorosity, $validPorosity)) {
        $hairPorosity = null;
    }
    
    $validElasticity = ['low', 'normal', 'high'];
    if ($elasticity !== null && !in_array($elasticity, $validElasticity)) {
        $elasticity = null;
    }
    
    // Final cleanup: ensure empty strings become NULL for enum fields
    // MySQL enum fields don't accept empty strings, only NULL or valid enum values
    if ($hairDensity === '' || $hairDensity === null || !in_array($hairDensity, ['low', 'medium', 'high'])) {
        $hairDensity = null;
    }
    if ($hairPorosity === '' || $hairPorosity === null || !in_array($hairPorosity, ['low', 'medium', 'high'])) {
        $hairPorosity = null;
    }
    if ($scalpType === '' || $scalpType === null || !in_array($scalpType, ['dry', 'normal', 'oily', 'combination'])) {
        $scalpType = null;
    }
    if ($elasticity === '' || $elasticity === null || !in_array($elasticity, ['low', 'normal', 'high'])) {
        $elasticity = null;
    }
    
    if ($profile) {
        // Update existing profile
        // Build SQL with explicit NULL for enum fields to avoid bind_param issues
        $hairDensityVal = ($hairDensity === null || $hairDensity === '') ? 'NULL' : "'" . $conn->real_escape_string($hairDensity) . "'";
        $hairPorosityVal = ($hairPorosity === null || $hairPorosity === '') ? 'NULL' : "'" . $conn->real_escape_string($hairPorosity) . "'";
        $scalpTypeVal = ($scalpType === null || $scalpType === '') ? 'NULL' : "'" . $conn->real_escape_string($scalpType) . "'";
        $elasticityVal = ($elasticity === null || $elasticity === '') ? 'NULL' : "'" . $conn->real_escape_string($elasticity) . "'";
        
        $sql = "UPDATE user_hair_profiles SET 
            hair_type_id = ?, hair_density = $hairDensityVal, hair_porosity = $hairPorosityVal, scalp_type = $scalpTypeVal,
            current_length = ?, goal_length = ?, hair_texture = ?, elasticity = $elasticityVal,
            is_color_treated = ?, is_chemically_treated = ?, chemical_treatment_type = ?
            WHERE profile_id = ?";
        
        $updateStmt = $conn->prepare($sql);
        // Type string: i (hair_type_id), d (current_length), d (goal_length), 
        // s (hair_texture), i (is_color_treated), i (is_chemically_treated), s (chemical_treatment_type), i (profile_id)
        // Total: 8 placeholders
        $updateStmt->bind_param("iddsiisi", 
            $hairTypeId, $currentLength, $goalLength, $hairTexture,
            $isColorTreated, $isChemicallyTreated, $chemicalTreatmentType,
            $profile['profile_id']);
        
        if (!$updateStmt->execute()) {
            $error = 'Failed to update profile: ' . $updateStmt->error;
        } else {
            $profileId = $profile['profile_id'];
        }
        $updateStmt->close();
    } else {
        // Create new profile
        // Build SQL with explicit NULL for enum fields to avoid bind_param issues
        $hairDensityVal = ($hairDensity === null || $hairDensity === '') ? 'NULL' : "'" . $conn->real_escape_string($hairDensity) . "'";
        $hairPorosityVal = ($hairPorosity === null || $hairPorosity === '') ? 'NULL' : "'" . $conn->real_escape_string($hairPorosity) . "'";
        $scalpTypeVal = ($scalpType === null || $scalpType === '') ? 'NULL' : "'" . $conn->real_escape_string($scalpType) . "'";
        $elasticityVal = ($elasticity === null || $elasticity === '') ? 'NULL' : "'" . $conn->real_escape_string($elasticity) . "'";
        
        $sql = "INSERT INTO user_hair_profiles 
            (user_id, hair_type_id, hair_density, hair_porosity, scalp_type,
            current_length, goal_length, hair_texture, elasticity,
            is_color_treated, is_chemically_treated, chemical_treatment_type)
            VALUES (?, ?, $hairDensityVal, $hairPorosityVal, $scalpTypeVal,
            ?, ?, ?, $elasticityVal, ?, ?, ?)";
        
        $insertStmt = $conn->prepare($sql);
        // Type string: i (user_id), i (hair_type_id), d (current_length), d (goal_length), 
        // s (hair_texture), i (is_color_treated), i (is_chemically_treated), s (chemical_treatment_type)
        // Total: 8 placeholders
        $insertStmt->bind_param("iiddsiis", 
            $userId, $hairTypeId, $currentLength, $goalLength, 
            $hairTexture, $isColorTreated, $isChemicallyTreated, $chemicalTreatmentType);
        
        if (!$insertStmt->execute()) {
            $errorMsg = $insertStmt->error;
            // Check if it's a foreign key constraint error
            if (strpos($errorMsg, 'foreign key constraint') !== false || strpos($errorMsg, 'Cannot add or update') !== false) {
                $error = 'Database error: Your user account may not exist. Please log out and log back in, or contact support.';
                error_log("Foreign key constraint error for user_id: " . $userId . " - User may not exist in users table");
            } else {
                $error = 'Failed to save profile: ' . $errorMsg;
            }
            $profileId = null;
        } else {
            $profileId = $conn->insert_id;
        }
        $insertStmt->close();
    }
    
    // Update concerns only if profile was saved successfully
    if ($profileId && !$error) {
        // Delete existing concerns
        $deleteStmt = $conn->prepare("DELETE FROM user_hair_concerns WHERE profile_id = ?");
        $deleteStmt->bind_param("i", $profileId);
        $deleteStmt->execute();
        $deleteStmt->close();
        
        // Insert new concerns (only if checkbox was checked)
        if (!empty($selectedConcerns)) {
            $insertConcernStmt = $conn->prepare("INSERT INTO user_hair_concerns (profile_id, concern_id, severity) VALUES (?, ?, ?)");
            foreach ($selectedConcerns as $concernId => $severity) {
                // Only insert if severity is provided (checkbox was checked)
                if (!empty($severity)) {
                    $insertConcernStmt->bind_param("iis", $profileId, $concernId, $severity);
                    $insertConcernStmt->execute();
                }
            }
            $insertConcernStmt->close();
        }
        
        // Generate recommendations
        require_once 'api/generate_recommendations.php';
        generateRecommendations($profileId, $conn);
        
        // Log activity if this is a child profile being edited by parent
        if (isset($childId) && $isViewingChild) {
            $logStmt = $conn->prepare("INSERT INTO parent_child_activity_log (parent_user_id, child_user_id, action_type, action_details) VALUES (?, ?, 'edited_profile', 'Parent updated child hair profile')");
            $logStmt->bind_param("ii", $_SESSION['user_id'], $childId);
            $logStmt->execute();
            $logStmt->close();
        }
        
        $success = 'Profile updated successfully! Recommendations have been generated.';
        if (isset($childId) && $isViewingChild) {
            $redirectUrl = "profile.php?child_id=" . $childId;
        } else {
            $redirectUrl = "recommendations.php";
        }
    } else {
        $error = 'Failed to save profile. Please try again.';
    }
    
    // Refresh profile data
    $profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
    $profileStmt->bind_param("i", $userId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();
}

// Handle Password Change
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'change_password') {
    $currentPassword = $_POST['current_password'] ?? '';
    $newPassword = $_POST['new_password'] ?? '';
    $confirmPassword = $_POST['confirm_password'] ?? '';
    
    if (empty($currentPassword) || empty($newPassword) || empty($confirmPassword)) {
        $error = 'All password fields are required.';
    } elseif ($newPassword !== $confirmPassword) {
        $error = 'New passwords do not match.';
    } elseif (strlen($newPassword) < 6) {
        $error = 'New password must be at least 6 characters long.';
    } else {
        // Verify current password
        $userStmt = $conn->prepare("SELECT password_hash FROM users WHERE user_id = ?");
        $userStmt->bind_param("i", $userId);
        $userStmt->execute();
        $userres = $userStmt->get_result()->fetch_assoc();
        $userStmt->close();
        
        if ($userres && password_verify($currentPassword, $userres['password_hash'])) {
            // Update password
            $newHash = password_hash($newPassword, PASSWORD_DEFAULT);
            $updatePwdStmt = $conn->prepare("UPDATE users SET password_hash = ? WHERE user_id = ?");
            $updatePwdStmt->bind_param("si", $newHash, $userId);
            
            if ($updatePwdStmt->execute()) {
                $success = 'Password updated successfully.';
            } else {
                $error = 'Failed to update password. Please try again.';
            }
            $updatePwdStmt->close();
        } else {
            $error = 'Incorrect current password.';
        }
    }
}

// Get user's selected concerns
$userConcerns = [];
if ($profile) {
    $userConcernsStmt = $conn->prepare("SELECT concern_id, severity FROM user_hair_concerns WHERE profile_id = ?");
    $userConcernsStmt->bind_param("i", $profile['profile_id']);
    $userConcernsStmt->execute();
    $userConcernsResult = $userConcernsStmt->get_result();
    while ($row = $userConcernsResult->fetch_assoc()) {
        $userConcerns[$row['concern_id']] = $row['severity'];
    }
    $userConcernsStmt->close();
}

$conn->close();

$pageTitle = $isViewingChild ? 'Child Hair Profile' : 'My Hair Profile';
include 'includes/header.php';
?>

<div class="container">
    <div class="page-header">
        <?php if ($isViewingChild): ?>
            <div style="margin-bottom: 1rem;">
                <a href="children.php" class="btn btn-secondary" style="margin-bottom: 1rem;">
                    <i class="fas fa-arrow-left"></i> Back to My Children
                </a>
            </div>
            <h1><i class="fas fa-child"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Hair Profile</h1>
            <p>Manage your child's hair profile and get personalized recommendations</p>
        <?php else: ?>
            <h1><i class="fas fa-user-circle"></i> My Hair Profile</h1>
            <p>Tell us about your hair to get personalized recommendations</p>
        <?php endif; ?>
    </div>
    
    <?php if ($success): ?>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <?php echo htmlspecialchars($success); ?>
        </div>
        <?php if (isset($redirectUrl)): ?>
            <script>
                setTimeout(function() {
                    window.location.href = "<?php echo $redirectUrl; ?>";
                }, 1000);
            </script>
            <p><small>Redirecting you in a moment... <a href="<?php echo $redirectUrl; ?>">Click here if not redirected</a>.</small></p>
        <?php endif; ?>
    <?php endif; ?>
    
    <?php if ($error): ?>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($error); ?>
        </div>
    <?php endif; ?>
    
    <form method="POST" action="profile.php<?php echo $isViewingChild ? '?child_id=' . $viewingChildId : ''; ?>" id="profileForm" class="profile-form">
        <?php if ($isViewingChild): ?>
            <input type="hidden" name="child_id" value="<?php echo $viewingChildId; ?>">
        <?php endif; ?>
        <div class="form-section">
            <h2><i class="fas fa-info-circle"></i> Basic Information</h2>
            
            <div class="form-group">
                <label for="hair_type_id">Hair Type <span class="required">*</span></label>
                <select id="hair_type_id" name="hair_type_id" required>
                    <option value="">Select your hair type</option>
                    <?php foreach ($hairTypes as $type): ?>
                        <option value="<?php echo $type['hair_type_id']; ?>" 
                                <?php echo ($profile && $profile['hair_type_id'] == $type['hair_type_id']) ? 'selected' : ''; ?>>
                            <?php echo htmlspecialchars($type['type_code'] . ' - ' . $type['type_name']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
                <small>Select the type that best matches your hair pattern</small>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hair_density">Hair Density</label>
                    <select id="hair_density" name="hair_density">
                        <option value="">Select</option>
                        <option value="low" <?php echo ($profile && $profile['hair_density'] === 'low') ? 'selected' : ''; ?>>Low</option>
                        <option value="medium" <?php echo ($profile && $profile['hair_density'] === 'medium') ? 'selected' : ''; ?>>Medium</option>
                        <option value="high" <?php echo ($profile && $profile['hair_density'] === 'high') ? 'selected' : ''; ?>>High</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="hair_porosity">Hair Porosity</label>
                    <select id="hair_porosity" name="hair_porosity">
                        <option value="">Select</option>
                        <option value="low" <?php echo ($profile && $profile['hair_porosity'] === 'low') ? 'selected' : ''; ?>>Low</option>
                        <option value="medium" <?php echo ($profile && $profile['hair_porosity'] === 'medium') ? 'selected' : ''; ?>>Medium</option>
                        <option value="high" <?php echo ($profile && $profile['hair_porosity'] === 'high') ? 'selected' : ''; ?>>High</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label for="scalp_type">Scalp Type</label>
                <select id="scalp_type" name="scalp_type">
                    <option value="">Select</option>
                    <option value="dry" <?php echo ($profile && $profile['scalp_type'] === 'dry') ? 'selected' : ''; ?>>Dry</option>
                    <option value="normal" <?php echo ($profile && $profile['scalp_type'] === 'normal') ? 'selected' : ''; ?>>Normal</option>
                    <option value="oily" <?php echo ($profile && $profile['scalp_type'] === 'oily') ? 'selected' : ''; ?>>Oily</option>
                    <option value="combination" <?php echo ($profile && $profile['scalp_type'] === 'combination') ? 'selected' : ''; ?>>Combination</option>
                </select>
            </div>
        </div>
        
        <div class="form-section">
            <h2><i class="fas fa-ruler"></i> Length & Goals</h2>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="current_length">Current Length (inches)</label>
                    <input type="number" id="current_length" name="current_length" 
                           step="0.1" min="0" 
                           value="<?php echo htmlspecialchars($profile['current_length'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="goal_length">Goal Length (inches)</label>
                    <input type="number" id="goal_length" name="goal_length" 
                           step="0.1" min="0" 
                           value="<?php echo htmlspecialchars($profile['goal_length'] ?? ''); ?>">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hair_texture">Hair Texture</label>
                    <input type="text" id="hair_texture" name="hair_texture" 
                           placeholder="e.g., Fine, Medium, Coarse"
                           value="<?php echo htmlspecialchars($profile['hair_texture'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="elasticity">Elasticity</label>
                    <select id="elasticity" name="elasticity">
                        <option value="">Select</option>
                        <option value="low" <?php echo ($profile && $profile['elasticity'] === 'low') ? 'selected' : ''; ?>>Low</option>
                        <option value="normal" <?php echo ($profile && $profile['elasticity'] === 'normal') ? 'selected' : ''; ?>>Normal</option>
                        <option value="high" <?php echo ($profile && $profile['elasticity'] === 'high') ? 'selected' : ''; ?>>High</option>
                    </select>
                </div>
            </div>
        </div>
        
        <div class="form-section">
            <h2><i class="fas fa-flask"></i> Treatments</h2>
            
            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="is_color_treated" value="1" 
                           <?php echo ($profile && $profile['is_color_treated']) ? 'checked' : ''; ?>>
                    <span>Color Treated</span>
                </label>
            </div>
            
            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="is_chemically_treated" value="1" 
                           <?php echo ($profile && $profile['is_chemically_treated']) ? 'checked' : ''; ?>>
                    <span>Chemically Treated</span>
                </label>
            </div>
            
            <div class="form-group">
                <label for="chemical_treatment_type">Chemical Treatment Type</label>
                <input type="text" id="chemical_treatment_type" name="chemical_treatment_type" 
                       placeholder="e.g., Relaxer, Perm, Keratin"
                       value="<?php echo htmlspecialchars($profile['chemical_treatment_type'] ?? ''); ?>">
            </div>
        </div>
        
        <div class="form-section">
            <h2><i class="fas fa-exclamation-triangle"></i> Hair Concerns</h2>
            <p class="section-description">Select any concerns you have with your hair</p>
            
            <div class="concerns-grid">
                <?php foreach ($concerns as $concern): ?>
                    <div class="concern-item">
                        <label class="checkbox-label">
                            <input type="checkbox" 
                                   name="concerns[<?php echo $concern['concern_id']; ?>]" 
                                   value="<?php echo isset($userConcerns[$concern['concern_id']]) ? $userConcerns[$concern['concern_id']] : 'mild'; ?>"
                                   <?php echo isset($userConcerns[$concern['concern_id']]) ? 'checked' : ''; ?>
                                   data-concern-id="<?php echo $concern['concern_id']; ?>"
                                   class="concern-checkbox">
                            <span><?php echo htmlspecialchars($concern['concern_name']); ?></span>
                        </label>
                        <select name="concerns[<?php echo $concern['concern_id']; ?>]" 
                                class="severity-select" 
                                style="<?php echo isset($userConcerns[$concern['concern_id']]) ? '' : 'display: none;'; ?>">
                            <option value="mild" <?php echo (isset($userConcerns[$concern['concern_id']]) && $userConcerns[$concern['concern_id']] === 'mild') ? 'selected' : ''; ?>>Mild</option>
                            <option value="moderate" <?php echo (isset($userConcerns[$concern['concern_id']]) && $userConcerns[$concern['concern_id']] === 'moderate') ? 'selected' : ''; ?>>Moderate</option>
                            <option value="severe" <?php echo (isset($userConcerns[$concern['concern_id']]) && $userConcerns[$concern['concern_id']] === 'severe') ? 'selected' : ''; ?>>Severe</option>
                        </select>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
        
        <div class="form-actions">
            <button type="submit" class="btn btn-primary btn-large">
                <i class="fas fa-save"></i> Save Profile & Generate Recommendations
            </button>
        </div>
    </form>
    
    <?php if (!$isViewingChild): ?>
    <div class="profile-form" style="margin-top: 3rem;">
        <div class="form-section">
            <h2><i class="fas fa-lock"></i> Account Settings</h2>
            
            <div class="form-group">
                <label>Email Address</label>
                <input type="text" value="<?php echo htmlspecialchars($_SESSION['email'] ?? ''); ?>" readonly disabled style="background-color: #f9f9f9; cursor: not-allowed;">
                <small>To change your email, please contact support.</small>
            </div>
            
            <hr style="margin: 2rem 0; border: 0; border-top: 1px solid var(--border-color);">
            
            <h3>Change Password</h3>
            <form method="POST" action="profile.php">
                <input type="hidden" name="action" value="change_password">
                
                <div class="form-group">
                    <label for="current_password">Current Password</label>
                    <input type="password" id="current_password" name="current_password" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="new_password">New Password</label>
                        <input type="password" id="new_password" name="new_password" required minlength="6">
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm_password">Confirm New Password</label>
                        <input type="password" id="confirm_password" name="confirm_password" required minlength="6">
                    </div>
                </div>
                
                <div class="form-actions" style="text-align: left;">
                    <button type="submit" class="btn btn-secondary">
                        <i class="fas fa-key"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>
    <?php endif; ?>
</div>

<?php include 'includes/footer.php'; ?>

