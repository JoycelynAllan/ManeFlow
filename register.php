<?php
require_once 'config/db.php';

$error = '';
$success = '';

/**
 * Validate password strength
 */
function validatePasswordStrength($password) {
    $errors = [];
    
    if (strlen($password) < 8) {
        $errors[] = 'Password must be at least 8 characters long.';
    }
    
    if (!preg_match('/[a-z]/', $password)) {
        $errors[] = 'Password must contain at least one lowercase letter.';
    }
    
    if (!preg_match('/[A-Z]/', $password)) {
        $errors[] = 'Password must contain at least one uppercase letter.';
    }
    
    if (!preg_match('/[0-9]/', $password)) {
        $errors[] = 'Password must contain at least one number.';
    }
    
    if (!preg_match('/[^a-zA-Z0-9]/', $password)) {
        $errors[] = 'Password must contain at least one special character (!@#$%^&*).';
    }
    
    return $errors;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirmPassword = $_POST['confirm_password'] ?? '';
    $firstName = trim($_POST['first_name'] ?? '');
    $lastName = trim($_POST['last_name'] ?? '');
    $gender = $_POST['gender'] ?? 'female';
    $dateOfBirth = $_POST['date_of_birth'] ?? '';
    
    if (empty($email) || empty($password) || empty($firstName) || empty($dateOfBirth)) {
        $error = 'Please fill in all required fields.';
    } elseif ($password !== $confirmPassword) {
        $error = 'Passwords do not match.';
    } else {
        // Validate password strength
        $passwordErrors = validatePasswordStrength($password);
        if (!empty($passwordErrors)) {
            $error = implode(' ', $passwordErrors);
        } elseif (!empty($dateOfBirth)) {
            // Validate date of birth
            $dob = DateTime::createFromFormat('Y-m-d', $dateOfBirth);
            if (!$dob || $dob->format('Y-m-d') !== $dateOfBirth) {
                $error = 'Invalid date of birth format.';
            } else {
                $today = new DateTime();
                $age = $today->diff($dob)->y;
                if ($age < 13) {
                    $error = 'You must be at least 13 years old to create an account. Parents can add children under 13 from their account dashboard after registration.';
                } elseif ($age > 120) {
                    $error = 'Please enter a valid date of birth.';
                }
            }
        }
    }
    
    if (empty($error)) {
        $conn = getDBConnection();
        
        // Check if email already exists
        $stmt = $conn->prepare("SELECT user_id FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $error = 'Email already registered. Please login instead.';
        } else {
            // Create new user with date of birth
            $passwordHash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("INSERT INTO users (email, password_hash, first_name, last_name, gender, date_of_birth) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("ssssss", $email, $passwordHash, $firstName, $lastName, $gender, $dateOfBirth);
            
            if ($stmt->execute()) {
                // Registration successful - redirect to login for double authentication
                $success = 'Registration successful! Please login to continue.';
                // Store success message in session to display on login page
                $_SESSION['registration_success'] = true;
                $_SESSION['registered_email'] = $email;
                $stmt->close();
                $conn->close();
                header('Location: login.php');
                exit;
            } else {
                $error = 'Registration failed. Please try again.';
            }
        }
        
        if (isset($stmt)) {
            $stmt->close();
        }
        $conn->close();
    }
}

$pageTitle = 'Register';
include 'includes/header.php';
?>

<div class="container">
    <div class="auth-container">
        <div class="auth-card">
            <h2><i class="fas fa-user-plus"></i> Create Your Account</h2>
            <p class="subtitle">Join ManeFlow and start your hair growth journey</p>
            
            <?php if ($error): ?>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>
            
            <?php if ($success): ?>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <?php echo htmlspecialchars($success); ?>
                </div>
            <?php endif; ?>
            
            <form method="POST" action="register.php" id="registerForm">
                <div class="form-group">
                    <label for="first_name">First Name <span class="required">*</span></label>
                    <input type="text" id="first_name" name="first_name" required 
                           value="<?php echo htmlspecialchars($_POST['first_name'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="last_name">Last Name</label>
                    <input type="text" id="last_name" name="last_name" 
                           value="<?php echo htmlspecialchars($_POST['last_name'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="email">Email <span class="required">*</span></label>
                    <input type="email" id="email" name="email" required 
                           value="<?php echo htmlspecialchars($_POST['email'] ?? ''); ?>">
                </div>
                
                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="female" <?php echo ($_POST['gender'] ?? 'female') === 'female' ? 'selected' : ''; ?>>Female</option>
                        <option value="male" <?php echo ($_POST['gender'] ?? '') === 'male' ? 'selected' : ''; ?>>Male</option>
                        <option value="other" <?php echo ($_POST['gender'] ?? '') === 'other' ? 'selected' : ''; ?>>Other</option>
                        <option value="prefer_not_to_say" <?php echo ($_POST['gender'] ?? '') === 'prefer_not_to_say' ? 'selected' : ''; ?>>Prefer not to say</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="date_of_birth">Date of Birth <span class="required">*</span></label>
                    <input type="date" id="date_of_birth" name="date_of_birth" required 
                           value="<?php echo htmlspecialchars($_POST['date_of_birth'] ?? ''); ?>"
                           max="<?php echo date('Y-m-d', strtotime('-13 years')); ?>"
                           min="<?php echo date('Y-m-d', strtotime('-120 years')); ?>">
                    <small>You must be at least 13 years old to create an account. Parents can add children under 13 from their account dashboard.</small>
                </div>
                
                <div class="form-group">
                    <label for="password">Password <span class="required">*</span></label>
                    <input type="password" id="password" name="password" required minlength="8">
                    <small id="passwordHelp">Password must be at least 8 characters with uppercase, lowercase, number, and special character</small>
                    <div id="passwordStrength" style="margin-top: 0.5rem;"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirm_password">Confirm Password <span class="required">*</span></label>
                    <input type="password" id="confirm_password" name="confirm_password" required minlength="6">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>
            
            <p class="auth-footer">
                Already have an account? <a href="login.php">Login here</a>
            </p>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('password');
    const passwordHelp = document.getElementById('passwordStrength');
    
    if (passwordInput && passwordHelp) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const checks = {
                length: password.length >= 8,
                lowercase: /[a-z]/.test(password),
                uppercase: /[A-Z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[^a-zA-Z0-9]/.test(password)
            };
            
            const passed = Object.values(checks).filter(v => v).length;
            const total = Object.keys(checks).length;
            
            let html = '<div style="font-size: 0.85rem; margin-top: 0.5rem;">';
            html += '<div style="margin-bottom: 0.25rem;">Password Strength: ';
            
            if (passed === total) {
                html += '<span style="color: var(--success-color); font-weight: bold;">Strong</span></div>';
            } else if (passed >= 3) {
                html += '<span style="color: var(--warning-color); font-weight: bold;">Medium</span></div>';
            } else {
                html += '<span style="color: var(--error-color); font-weight: bold;">Weak</span></div>';
            }
            
            html += '<div style="display: flex; flex-direction: column; gap: 0.25rem;">';
            html += '<span style="color: ' + (checks.length ? 'var(--success-color)' : 'var(--text-light)') + ';">✓ At least 8 characters</span>';
            html += '<span style="color: ' + (checks.lowercase ? 'var(--success-color)' : 'var(--text-light)') + ';">✓ Lowercase letter</span>';
            html += '<span style="color: ' + (checks.uppercase ? 'var(--success-color)' : 'var(--text-light)') + ';">✓ Uppercase letter</span>';
            html += '<span style="color: ' + (checks.number ? 'var(--success-color)' : 'var(--text-light)') + ';">✓ Number</span>';
            html += '<span style="color: ' + (checks.special ? 'var(--success-color)' : 'var(--text-light)') + ';">✓ Special character</span>';
            html += '</div></div>';
            
            passwordHelp.innerHTML = html;
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

