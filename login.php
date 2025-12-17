<?php
require_once 'config/db.php';

// Redirect if already logged in
if (isset($_SESSION['user_id'])) {
    header('Location: dashboard.php');
    exit;
}

$error = '';
$success = '';

// Checks if user just registered
if (isset($_SESSION['registration_success']) && $_SESSION['registration_success']) {
    $success = 'Registration successful! Please login with your credentials.';
    if (isset($_SESSION['registered_email'])) {
        $prefillEmail = $_SESSION['registered_email'];
    }
    unset($_SESSION['registration_success']);
    unset($_SESSION['registered_email']);
}

// Checks for remember me cookie
if (!isset($_SESSION['user_id']) && isset($_COOKIE['remember_token'])) {
    $conn = getDBConnection();
    $token = $_COOKIE['remember_token'];
    
    // Gets user by remember token 
    $tokenData = @json_decode(base64_decode($token), true);
    
    if ($tokenData && isset($tokenData['user_id']) && isset($tokenData['hash'])) {
        $userId = (int)$tokenData['user_id'];
        $stmt = $conn->prepare("SELECT user_id, email, password_hash, first_name, is_active FROM users WHERE user_id = ? AND is_active = 1");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            // Verifies token hash matches password hash
            if (hash_equals($tokenData['hash'], substr($user['password_hash'], 0, 20))) {
                $_SESSION['user_id'] = $user['user_id'];
                $_SESSION['email'] = $user['email'];
                $_SESSION['first_name'] = $user['first_name'];
                
                // Updates last login
                $updateStmt = $conn->prepare("UPDATE users SET last_login = NOW() WHERE user_id = ?");
                $updateStmt->bind_param("i", $user['user_id']);
                $updateStmt->execute();
                $updateStmt->close();
                
                $stmt->close();
                $conn->close();
                header('Location: dashboard.php');
                exit;
            }
        }
        $stmt->close();
    }
    $conn->close();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $rememberMe = isset($_POST['remember_me']) && $_POST['remember_me'] === '1';
    
    if (empty($email) || empty($password)) {
        $error = 'Please enter both email and password.';
    } else {
        $conn = getDBConnection();
        
        $stmt = $conn->prepare("SELECT user_id, email, password_hash, first_name, is_active, failed_login_attempts, lockout_until FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            
            // Checks if locked out
            if ($user['lockout_until'] && strtotime($user['lockout_until']) > time()) {
                $remTime = ceil((strtotime($user['lockout_until']) - time()) / 60);
                $error = "Account locked due to too many failed attempts. Please try again in $remTime minutes or <a href='reset_password.php' style='color: var(--error-color); text-decoration: underline;'>reset your password</a>.";
            } elseif (!$user['is_active']) {
                $error = 'Your account has been deactivated. Please contact support.';
            } elseif (password_verify($password, $user['password_hash'])) {
                // Reset failed attempts on success
                $conn->query("UPDATE users SET failed_login_attempts = 0, lockout_until = NULL WHERE user_id = " . $user['user_id']);
                
                $_SESSION['user_id'] = $user['user_id'];
                $_SESSION['email'] = $user['email'];
                $_SESSION['first_name'] = $user['first_name'];
                
                // Set remember me cookie if checked
                if ($rememberMe) {
                    $tokenData = [
                        'user_id' => $user['user_id'],
                        'hash' => substr($user['password_hash'], 0, 20),
                        'expires' => time() + (30 * 24 * 60 * 60) // 30 days
                    ];
                    $token = base64_encode(json_encode($tokenData));
                    setcookie('remember_token', $token, time() + (30 * 24 * 60 * 60), '/', '', true, true); // HttpOnly and Secure
                }
                
                // Updates last login
                $updateStmt = $conn->prepare("UPDATE users SET last_login = NOW() WHERE user_id = ?");
                $updateStmt->bind_param("i", $user['user_id']);
                $updateStmt->execute();
                $updateStmt->close();
                
                $stmt->close();
                $conn->close();
                header('Location: dashboard.php');
                exit;
            } else {
                // Increment failed attempts
                $newAttempts = $user['failed_login_attempts'] + 1;
                $lockoutUntil = 'NULL';
                $error = 'Invalid email or password.';
                
                if ($newAttempts >= 5) {
                    $lockoutTime = date('Y-m-d H:i:s', strtotime('+5 minutes'));
                    $lockoutUntil = "'$lockoutTime'";
                    $error = "Too many failed attempts. Account locked for 5 minutes. <a href='reset_password.php' style='color: var(--error-color); text-decoration: underline;'>Forgot Password?</a>";
                }
                
                $conn->query("UPDATE users SET failed_login_attempts = $newAttempts, lockout_until = $lockoutUntil WHERE user_id = " . $user['user_id']);
            }
        } else {
            $error = 'Invalid email or password.';
        }
        
        $stmt->close();
        $conn->close();
    }
}

$pageTitle = 'Login';
include 'includes/header.php';
?>

<div class="container">
    <div class="auth-container">
        <div class="auth-card">
            <h2><i class="fas fa-sign-in-alt"></i> Welcome Back</h2>
            <p class="subtitle">Login to continue your hair growth journey</p>
            
            <?php if ($error): ?>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo $error; ?>
                </div>
            <?php endif; ?>
            
            <?php if ($success): ?>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <?php echo htmlspecialchars($success); ?>
                </div>
            <?php endif; ?>
            
            <form method="POST" action="login.php" id="loginForm">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required 
                           value="<?php echo htmlspecialchars($_POST['email'] ?? ($prefillEmail ?? '')); ?>" 
                           autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember_me" value="1" id="remember_me">
                        <span>Remember me for 30 days</span>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>
            
            <p class="auth-footer">
                Don't have an account? <a href="register.php">Sign up here</a>
            </p>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>

