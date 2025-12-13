<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
$isLoggedIn = isset($_SESSION['user_id']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($pageTitle) ? $pageTitle . ' - ManeFlow' : 'ManeFlow - Your Hair Growth Journey'; ?></title>
    <link rel="stylesheet" href="css/style.css?v=<?php echo time(); ?>_rev2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <meta name="theme-color" content="#6B5B73">
    <link rel="manifest" href="manifest.json">
    <?php 
    // Check if we should load the child theme
    $shouldLoadChildTheme = (isset($isViewingChild) && $isViewingChild) || 
                           (basename($_SERVER['PHP_SELF']) == 'children.php');
    
    if ($shouldLoadChildTheme): 
    ?>
    <link rel="stylesheet" href="css/child-theme.css">
    <?php endif; ?>
    <script>
        // Register service worker for offline mode
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', function() {
                navigator.serviceWorker.register('sw.js')
                    .then(function(registration) {
                        console.log('ServiceWorker registration successful');
                    })
                    .catch(function(err) {
                        console.log('ServiceWorker registration failed');
                    });
            });
        }
        
        // Cache offline data when online
        function cacheOfflineData() {
            if (navigator.onLine && 'caches' in window) {
                fetch('api/offline_data.php?type=all')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            localStorage.setItem('offline_data', JSON.stringify(data.data));
                            localStorage.setItem('offline_data_timestamp', new Date().toISOString());
                            console.log('Offline data cached successfully');
                        }
                    })
                    .catch(err => console.log('Error caching offline data:', err));
            }
        }
        
        // Cache data on page load if online
        if (navigator.onLine) {
            cacheOfflineData();
        }
        
        // Listen for online/offline events
        window.addEventListener('online', function() {
            console.log('Back online - syncing data');
            cacheOfflineData();
        });
        
        window.addEventListener('offline', function() {
            console.log('Gone offline - using cached data');
        });
    </script>
</head>
<body<?php echo isset($bodyClass) ? ' class="' . htmlspecialchars($bodyClass) . '"' : ''; ?>>
    <nav class="navbar">
        <div class="container">
            <div class="nav-brand">
                <a href="index.php">
                    <i class="fas fa-spa"></i>
                    <span>ManeFlow</span>
                </a>
            </div>
            <ul class="nav-menu">
                <?php if ($isLoggedIn): ?>
                    <li><a href="dashboard.php"><i class="fas fa-home"></i> <span class="nav-text">Dashboard</span></a></li>
                    <li><a href="profile.php"><i class="fas fa-user-circle"></i> <span class="nav-text">Profile</span></a></li>
                    <li><a href="children.php"><i class="fas fa-child"></i> <span class="nav-text">My Children</span></a></li>
                    <li><a href="recommendations.php"><i class="fas fa-lightbulb"></i> <span class="nav-text">Recommendations</span></a></li>
                    <li class="nav-dropdown">
                        <a href="routines.php" class="dropdown-toggle"><i class="fas fa-calendar-check"></i> <span class="nav-text">Routines</span> <i class="fas fa-chevron-down"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="routines.php"><i class="fas fa-list"></i> My Routines</a></li>
                            <li><a href="forecast.php"><i class="fas fa-chart-line"></i> Growth Forecast</a></li>
                        </ul>
                    </li>
                    <li class="nav-dropdown">
                        <a href="diagnosis.php" class="dropdown-toggle"><i class="fas fa-heartbeat"></i> <span class="nav-text">Health</span> <i class="fas fa-chevron-down"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="diagnosis.php"><i class="fas fa-stethoscope"></i> Diagnosis</a></li>
                            <li><a href="styles.php"><i class="fas fa-palette"></i> Styles</a></li>
                        </ul>
                    </li>
                    <li><a href="education.php"><i class="fas fa-book"></i> <span class="nav-text">Education</span></a></li>
                    <li>
                        <a href="notifications.php" style="position: relative;">
                            <i class="fas fa-bell"></i> 
                            <span class="nav-text">Notifications</span>
                            <span id="nav-notification-badge" style="display: none; position: absolute; top: -8px; right: -5px; background: #dc3545; color: white; border-radius: 50%; padding: 2px 5px; font-size: 10px; line-height: 1; min-width: 15px; text-align: center;">0</span>
                        </a>
                    </li>
                    <li><a href="logout.php"><i class="fas fa-sign-out-alt"></i> <span class="nav-text">Logout</span></a></li>
                <?php else: ?>
                    <li><a href="index.php">Home</a></li>
                    <li><a href="login.php">Login</a></li>
                    <li><a href="register.php" class="btn-primary">Sign Up</a></li>
                <?php endif; ?>
            </ul>
            <div class="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </nav>

