<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Get user's hair profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

// Get recommendations count
$recCount = 0;
if ($profile) {
    $recStmt = $conn->prepare("SELECT COUNT(*) as count FROM user_recommendations WHERE profile_id = ? AND is_active = 1");
    $recStmt->bind_param("i", $profile['profile_id']);
    $recStmt->execute();
    $recResult = $recStmt->get_result()->fetch_assoc();
    $recCount = $recResult['count'] ?? 0;
    $recStmt->close();
}

// Get progress entries count
$progressCount = 0;
if ($profile) {
    $progressStmt = $conn->prepare("SELECT COUNT(*) as count FROM hair_growth_progress WHERE profile_id = ?");
    $progressStmt->bind_param("i", $profile['profile_id']);
    $progressStmt->execute();
    $progressResult = $progressStmt->get_result()->fetch_assoc();
    $progressCount = $progressResult['count'] ?? 0;
    $progressStmt->close();
}

$conn->close();

$pageTitle = 'Dashboard';
include 'includes/header.php';
?>

<div class="container">
    <div class="dashboard-header">
        <h1>Welcome back, <?php echo htmlspecialchars($_SESSION['first_name'] ?? 'User'); ?>! <i class="fas fa-spa"></i></h1>
        <p class="dashboard-subtitle">Your hair growth journey dashboard</p>
    </div>
    
    <?php if (!$profile): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Get Started!</strong>
                <p>Create your hair profile to receive personalized recommendations.</p>
                <a href="profile.php" class="btn btn-primary">
                    <i class="fas fa-user-circle"></i> Create Profile
                </a>
            </div>
        </div>
    <?php else: ?>
        <div class="dashboard-stats">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <div class="stat-content">
                    <h3><?php echo $recCount; ?></h3>
                    <p>Active Recommendations</p>
                </div>
                <a href="recommendations.php" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-content">
                    <h3><?php echo $progressCount; ?></h3>
                    <p>Progress Entries</p>
                </div>
                <a href="profile.php" class="stat-link">View Profile <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="stat-content">
                    <h3>Profile</h3>
                    <p>Hair Type: <?php 
                        if ($profile['hair_type_id']) {
                            $conn = getDBConnection();
                            $typeStmt = $conn->prepare("SELECT type_name FROM hair_types WHERE hair_type_id = ?");
                            $typeStmt->bind_param("i", $profile['hair_type_id']);
                            $typeStmt->execute();
                            $typeResult = $typeStmt->get_result()->fetch_assoc();
                            echo htmlspecialchars($typeResult['type_name'] ?? 'Not set');
                            $typeStmt->close();
                            $conn->close();
                        } else {
                            echo 'Not set';
                        }
                    ?></p>
                </div>
                <a href="profile.php" class="stat-link">Edit Profile <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
        
        <div class="dashboard-actions">
            <a href="recommendations.php" class="action-card">
                <i class="fas fa-lightbulb"></i>
                <h3>View Recommendations</h3>
                <p>See personalized product and method recommendations</p>
            </a>
            
            <a href="routines.php" class="action-card">
                <i class="fas fa-calendar-check"></i>
                <h3>My Routines</h3>
                <p>Personalized morning, night, and wash-day routines</p>
            </a>
            
            <a href="forecast.php" class="action-card">
                <i class="fas fa-chart-line"></i>
                <h3>Growth Forecast</h3>
                <p>Track progress and see predicted growth milestones</p>
            </a>
            
            <a href="diagnosis.php" class="action-card">
                <i class="fas fa-stethoscope"></i>
                <h3>Hair Diagnosis</h3>
                <p>Identify problems and get solutions</p>
            </a>
            
            <a href="styles.php" class="action-card">
                <i class="fas fa-palette"></i>
                <h3>Style Library</h3>
                <p>Browse protective hairstyles for your hair type</p>
            </a>
            
            <a href="profile.php" class="action-card">
                <i class="fas fa-edit"></i>
                <h3>Update Profile</h3>
                <p>Modify your hair characteristics</p>
            </a>
        </div>
    <?php endif; ?>
</div>

<?php include 'includes/footer.php'; ?>

