<?php
require_once 'config/db.php';

// Redirect logged-in users to dashboard
if (isset($_SESSION['user_id'])) {
    header('Location: dashboard.php');
    exit;
}

$pageTitle = 'Home';
// Add body class for home page styling
$bodyClass = 'home-page';
include 'includes/header.php';
?>

<div class="hero-section">
    <div class="container">
        <div class="hero-content">
            <h1><i class="fas fa-spa"></i> ManeFlow</h1>
            <p class="hero-subtitle">Your Comprehensive Resource for Hair Growth & Care</p>
            <p class="hero-description">
                Empower your hair growth journey with personalized recommendations, expert guidance, 
                and proven methods tailored to your unique hair type.
            </p>
            <?php if (!isset($_SESSION['user_id'])): ?>
                <div class="hero-cta">
                    <a href="register.php" class="btn btn-primary btn-large">
                        <i class="fas fa-rocket"></i> Get Started
                    </a>
                    <a href="login.php" class="btn btn-secondary btn-large">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </div>
            <?php else: ?>
                <div class="hero-cta">
                    <a href="dashboard.php" class="btn btn-primary btn-large">
                        <i class="fas fa-tachometer-alt"></i> Go to Dashboard
                    </a>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<div class="features-section">
    <div class="container">
        <h2 class="section-title">Why Choose ManeFlow?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-user-cog"></i>
                </div>
                <h3>Personalized Profiles</h3>
                <p>Input your unique hair characteristics and get tailored recommendations specifically suited to your needs.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-seedling"></i>
                </div>
                <h3>Growth Strategies</h3>
                <p>Discover effective methods and techniques to promote healthy hair growth based on your hair type.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <h3>Product Recommendations</h3>
                <p>Find ideal hair care products that work best for your specific hair type and concerns.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3>Avoid Pitfalls</h3>
                <p>Learn what to avoid to prevent damage and maintain healthy, luscious locks.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3>Educational Content</h3>
                <p>Access a wealth of information about various hair types and effective growth methods.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3>Track Progress</h3>
                <p>Monitor your hair growth journey and see your progress over time.</p>
            </div>
        </div>
    </div>
</div>

<div class="cta-section">
    <div class="container">
        <div class="cta-content">
            <h2>Ready to Transform Your Hair?</h2>
            <p>Join thousands of users on their journey to healthier, longer hair.</p>
            <?php if (!isset($_SESSION['user_id'])): ?>
                <a href="register.php" class="btn btn-primary btn-large">
                    <i class="fas fa-user-plus"></i> Start Your Journey Today
                </a>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>

