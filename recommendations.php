<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Check if viewing a child's recommendations
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    
    // Verify this child belongs to the current user (parent) using direct query
    // Replacing stored procedure to avoid issues on servers without routine permissions
    $verifyStmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? AND parent_user_id = ? AND is_child_account = 1");
    $verifyStmt->bind_param("ii", $childId, $userId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->num_rows > 0;
    $verifyStmt->close();
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
        $isViewingChild = true;
        
        // Get child name
        $childNameStmt = $conn->prepare("SELECT first_name FROM users WHERE user_id = ?");
        $childNameStmt->bind_param("i", $childId);
        $childNameStmt->execute();
        $childInfo = $childNameStmt->get_result()->fetch_assoc();
        $childNameStmt->close();
    } else {
        header('Location: children.php?error=unauthorized');
        exit;
    }
}

// Get user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    if ($isViewingChild) {
        header('Location: profile.php?child_id=' . $userId); // Redirect to create profile for child
    } else {
        header('Location: profile.php');
    }
    exit;
}

// Get hair type information for care tips
$hairTypeInfo = null;
if ($profile['hair_type_id']) {
    $hairTypeStmt = $conn->prepare("SELECT * FROM hair_types WHERE hair_type_id = ?");
    $hairTypeStmt->bind_param("i", $profile['hair_type_id']);
    $hairTypeStmt->execute();
    $hairTypeInfo = $hairTypeStmt->get_result()->fetch_assoc();
    $hairTypeStmt->close();
}

// Get educational content for this hair type
$careTips = [];
if ($profile['hair_type_id']) {
    $tipsStmt = $conn->prepare("
        SELECT ec.*, chtr.relevance_score
        FROM educational_content ec
        INNER JOIN content_hair_type_relevance chtr ON ec.content_id = chtr.content_id
        WHERE chtr.hair_type_id = ? AND ec.category = 'guide'
        ORDER BY chtr.relevance_score DESC, ec.published_at DESC
        LIMIT 5
    ");
    $tipsStmt->bind_param("i", $profile['hair_type_id']);
    $tipsStmt->execute();
    $careTips = $tipsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $tipsStmt->close();
}

// Get recommendations
$recStmt = $conn->prepare("
    SELECT ur.*, 
           p.product_name, p.brand, p.category as product_category, p.description as product_desc, 
           p.key_ingredients, p.price, p.amazon_link, p.image_url, p.rating as product_rating,
           m.method_name, m.category as method_category, m.description as method_desc,
           m.instructions, m.frequency, m.difficulty_level, m.video_url as method_video_url,
           pf.pitfall_name, pf.category as pitfall_category, pf.description as pitfall_desc,
           pf.why_harmful, pf.alternative_suggestion
    FROM user_recommendations ur
    LEFT JOIN products p ON ur.product_id = p.product_id
    LEFT JOIN growth_methods m ON ur.method_id = m.method_id
    LEFT JOIN hair_pitfalls pf ON ur.pitfall_id = pf.pitfall_id
    WHERE ur.profile_id = ? AND ur.is_active = 1
    ORDER BY 
        CASE ur.priority
            WHEN 'critical' THEN 1
            WHEN 'high' THEN 2
            WHEN 'medium' THEN 3
            WHEN 'low' THEN 4
        END,
        ur.generated_at DESC
");
$recStmt->bind_param("i", $profile['profile_id']);
$recStmt->execute();
$recommendations = $recStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$recStmt->close();

// Organize by type and filter duplicates
$products = [];
$methods = [];
$pitfalls = [];
$seenProducts = [];
$seenMethods = [];
$seenPitfalls = [];

foreach ($recommendations as $rec) {
    if ($rec['recommendation_type'] === 'product' && $rec['product_id']) {
        // Only add if we haven't seen this product_id before
        if (!in_array($rec['product_id'], $seenProducts)) {
            $products[] = $rec;
            $seenProducts[] = $rec['product_id'];
        }
    } elseif ($rec['recommendation_type'] === 'method' && $rec['method_id']) {
        // Only add if we haven't seen this method_id before
        if (!in_array($rec['method_id'], $seenMethods)) {
            $methods[] = $rec;
            $seenMethods[] = $rec['method_id'];
        }
    } elseif ($rec['recommendation_type'] === 'pitfall_avoidance' && $rec['pitfall_id']) {
        // Only add if we haven't seen this pitfall_id before
        if (!in_array($rec['pitfall_id'], $seenPitfalls)) {
            $pitfalls[] = $rec;
            $seenPitfalls[] = $rec['pitfall_id'];
        }
    }
}

$conn->close();

$pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Recommendations") : 'My Recommendations';
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
            <h1><i class="fas fa-lightbulb"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Recommendations</h1>
            <p>Tailored suggestions based on <?php echo htmlspecialchars($childInfo['first_name']); ?>'s hair profile</p>
        <?php else: ?>
            <h1><i class="fas fa-lightbulb"></i> Personalized Recommendations</h1>
            <p>Tailored suggestions based on your hair profile</p>
        <?php endif; ?>
        <button id="fetchOnlineData" class="btn btn-primary" style="margin-top: 1rem;">
            <i class="fas fa-sync-alt"></i> Fetch Latest Products & Methods
        </button>
        <div id="fetchStatus" style="margin-top: 0.5rem; display: none;"></div>
    </div>
    
    <?php if ($hairTypeInfo): ?>
        <section class="hair-care-tips-section">
            <div class="hair-care-header">
                <h2><i class="fas fa-book-open"></i> How to Care for <?php echo htmlspecialchars($hairTypeInfo['type_name']); ?> Hair</h2>
                <p class="hair-type-subtitle"><?php echo htmlspecialchars($hairTypeInfo['type_code']); ?> - <?php echo htmlspecialchars($hairTypeInfo['category'] ?? 'Hair Care'); ?></p>
            </div>
            
            <?php if ($hairTypeInfo['description']): ?>
                <div class="hair-type-description">
                    <p><?php echo nl2br(htmlspecialchars($hairTypeInfo['description'])); ?></p>
                </div>
            <?php endif; ?>
            
            <?php if (!empty($careTips)): ?>
                <div class="care-tips-grid">
                    <?php foreach ($careTips as $tip): ?>
                        <div class="care-tip-card">
                            <h3><i class="fas fa-lightbulb"></i> <?php echo htmlspecialchars($tip['title']); ?></h3>
                            <?php if ($tip['content_text']): ?>
                                <div class="tip-content">
                                    <?php echo nl2br(htmlspecialchars(substr($tip['content_text'], 0, 300))); ?>
                                    <?php if (strlen($tip['content_text']) > 300): ?>...<?php endif; ?>
                                </div>
                            <?php endif; ?>
                            <?php if ($tip['reading_time_minutes']): ?>
                                <div class="tip-meta">
                                    <i class="fas fa-clock"></i> <?php echo $tip['reading_time_minutes']; ?> min read
                                </div>
                            <?php endif; ?>
                        </div>
                    <?php endforeach; ?>
                </div>
            <?php else: ?>
                <div class="care-tips-default">
                    <div class="tip-item">
                        <h4><i class="fas fa-droplet"></i> Moisture is Key</h4>
                        <p><?php echo htmlspecialchars($hairTypeInfo['type_name']); ?> hair requires regular deep conditioning and moisturizing to maintain elasticity and prevent breakage.</p>
                    </div>
                    <div class="tip-item">
                        <h4><i class="fas fa-shield-alt"></i> Protective Styling</h4>
                        <p>Use protective styles like braids, twists, or buns to minimize manipulation and protect your ends from damage.</p>
                    </div>
                    <div class="tip-item">
                        <h4><i class="fas fa-hand-sparkles"></i> Gentle Handling</h4>
                        <p>Always detangle from ends to roots using a wide-tooth comb or your fingers when hair is wet and conditioned.</p>
                    </div>
                    <div class="tip-item">
                        <h4><i class="fas fa-thermometer-half"></i> Low Heat</h4>
                        <p>Minimize heat styling and always use a heat protectant when heat is necessary. Air drying is preferred.</p>
                    </div>
                    <div class="tip-item">
                        <h4><i class="fas fa-cut"></i> Regular Trims</h4>
                        <p>Get regular trims every 8-12 weeks to remove split ends and maintain healthy hair growth.</p>
                    </div>
                </div>
            <?php endif; ?>
        </section>
    <?php endif; ?>
    
    <?php if (empty($recommendations)): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>No recommendations yet!</strong>
                <p>Complete or update your hair profile to receive personalized recommendations.</p>
                <a href="profile.php" class="btn btn-primary">Update Profile</a>
            </div>
        </div>
    <?php else: ?>
        
        <?php if (!empty($products)): ?>
            <section class="recommendations-section">
                <h2><i class="fas fa-shopping-bag"></i> Recommended Products</h2>
                <div class="recommendations-grid">
                    <?php foreach ($products as $rec): ?>
                        <div class="recommendation-card product-card priority-<?php echo $rec['priority']; ?>">
                            <div class="card-header">
                                <span class="priority-badge priority-<?php echo $rec['priority']; ?>">
                                    <?php echo ucfirst($rec['priority']); ?> Priority
                                </span>
                            </div>
                            <div class="card-content">
                                <?php if ($rec['image_url']): ?>
                                    <div class="product-image-container">
                                        <img src="<?php echo htmlspecialchars($rec['image_url']); ?>" 
                                             alt="<?php echo htmlspecialchars($rec['product_name']); ?>"
                                             class="product-image"
                                             onerror="this.style.display='none';">
                                    </div>
                                <?php endif; ?>
                                <h3><?php echo htmlspecialchars($rec['product_name']); ?></h3>
                                <?php if ($rec['brand']): ?>
                                    <p class="brand">by <?php echo htmlspecialchars($rec['brand']); ?></p>
                                <?php endif; ?>
                                <?php if ($rec['product_rating']): ?>
                                    <div class="rating">
                                        <?php 
                                        $rating = round($rec['product_rating']);
                                        for ($i = 1; $i <= 5; $i++): 
                                        ?>
                                            <i class="fas fa-star <?php echo $i <= $rating ? 'filled' : ''; ?>"></i>
                                        <?php endfor; ?>
                                        <span>(<?php echo number_format($rec['product_rating'], 1); ?>)</span>
                                    </div>
                                <?php endif; ?>
                                <p class="category"><?php echo ucfirst(str_replace('_', ' ', $rec['product_category'])); ?></p>
                                <?php if ($rec['product_desc']): ?>
                                    <p class="description"><?php echo htmlspecialchars(substr($rec['product_desc'], 0, 150)); ?>...</p>
                                <?php endif; ?>
                                <?php if ($rec['key_ingredients']): ?>
                                    <p class="ingredients"><strong>Key Ingredients:</strong> <?php echo htmlspecialchars($rec['key_ingredients']); ?></p>
                                <?php endif; ?>
                                <?php if ($rec['price']): ?>
                                    <p class="price">$<?php echo number_format($rec['price'], 2); ?></p>
                                <?php endif; ?>
                                <?php if ($rec['personalized_note']): ?>
                                    <div class="personalized-note">
                                        <i class="fas fa-user-check"></i> <?php echo htmlspecialchars($rec['personalized_note']); ?>
                                    </div>
                                <?php endif; ?>
                                <?php
                                // Generate Amazon link if not exists
                                $amazonLink = $rec['amazon_link'];
                                if (!$amazonLink) {
                                    $searchTerm = urlencode($rec['product_name'] . ' ' . ($rec['brand'] ?? ''));
                                    $amazonLink = 'https://www.amazon.com/s?k=' . $searchTerm;
                                }
                                ?>
                                <a href="<?php echo htmlspecialchars($amazonLink); ?>" 
                                   target="_blank" class="btn btn-primary btn-small" style="margin-top: 0.5rem;">
                                    <i class="fas fa-shopping-cart"></i> Buy on Amazon
                                </a>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>
        
        <?php if (!empty($methods)): ?>
            <section class="recommendations-section">
                <h2><i class="fas fa-seedling"></i> Recommended Growth Methods</h2>
                <div class="recommendations-grid">
                    <?php foreach ($methods as $rec): ?>
                        <div class="recommendation-card method-card priority-<?php echo $rec['priority']; ?>">
                            <div class="card-header">
                                <span class="priority-badge priority-<?php echo $rec['priority']; ?>">
                                    <?php echo ucfirst($rec['priority']); ?> Priority
                                </span>
                            </div>
                            <div class="card-content">
                                <h3><?php echo htmlspecialchars($rec['method_name']); ?></h3>
                                <p class="category"><?php echo ucfirst(str_replace('_', ' ', $rec['method_category'])); ?></p>
                                <?php if ($rec['difficulty_level']): ?>
                                    <p class="difficulty">
                                        <i class="fas fa-signal"></i> 
                                        Difficulty: <?php echo ucfirst($rec['difficulty_level']); ?>
                                    </p>
                                <?php endif; ?>
                                <?php if ($rec['frequency']): ?>
                                    <p class="frequency">
                                        <i class="fas fa-clock"></i> 
                                        Frequency: <?php echo htmlspecialchars($rec['frequency']); ?>
                                    </p>
                                <?php endif; ?>
                                <?php if ($rec['method_desc']): ?>
                                    <p class="description"><?php echo htmlspecialchars(substr($rec['method_desc'], 0, 200)); ?>...</p>
                                <?php endif; ?>
                                <?php if ($rec['instructions']): ?>
                                    <div class="instructions">
                                        <strong>Instructions:</strong>
                                        <p><?php echo nl2br(htmlspecialchars(substr($rec['instructions'], 0, 300))); ?>...</p>
                                    </div>
                                <?php endif; ?>
                                <?php if ($rec['personalized_note']): ?>
                                    <div class="personalized-note">
                                        <i class="fas fa-user-check"></i> <?php echo htmlspecialchars($rec['personalized_note']); ?>
                                    </div>
                                <?php endif; ?>
                                <?php if ($rec['method_video_url']): ?>
                                    <a href="<?php echo htmlspecialchars($rec['method_video_url']); ?>" 
                                       target="_blank" class="btn btn-primary btn-small" style="margin-top: 0.5rem;">
                                        <i class="fas fa-play"></i> Watch Video Tutorial
                                    </a>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>
        
        <?php if (!empty($pitfalls)): ?>
            <section class="recommendations-section">
                <h2><i class="fas fa-exclamation-triangle"></i> Things to Avoid</h2>
                <div class="recommendations-grid">
                    <?php foreach ($pitfalls as $rec): ?>
                        <div class="recommendation-card pitfall-card priority-<?php echo $rec['priority']; ?>">
                            <div class="card-header">
                                <span class="priority-badge priority-<?php echo $rec['priority']; ?>">
                                    <?php echo ucfirst($rec['priority']); ?> Priority
                                </span>
                            </div>
                            <div class="card-content">
                                <h3><i class="fas fa-ban"></i> <?php echo htmlspecialchars($rec['pitfall_name']); ?></h3>
                                <p class="category"><?php echo ucfirst(str_replace('_', ' ', $rec['pitfall_category'])); ?></p>
                                <?php if ($rec['pitfall_desc']): ?>
                                    <p class="description"><?php echo htmlspecialchars($rec['pitfall_desc']); ?></p>
                                <?php endif; ?>
                                <?php if ($rec['why_harmful']): ?>
                                    <div class="why-harmful">
                                        <strong><i class="fas fa-exclamation-circle"></i> Why it's harmful:</strong>
                                        <p><?php echo htmlspecialchars($rec['why_harmful']); ?></p>
                                    </div>
                                <?php endif; ?>
                                <?php if ($rec['alternative_suggestion']): ?>
                                    <div class="alternative">
                                        <strong><i class="fas fa-lightbulb"></i> Alternative:</strong>
                                        <p><?php echo htmlspecialchars($rec['alternative_suggestion']); ?></p>
                                    </div>
                                <?php endif; ?>
                                <?php if ($rec['personalized_note']): ?>
                                    <div class="personalized-note">
                                        <i class="fas fa-user-check"></i> <?php echo htmlspecialchars($rec['personalized_note']); ?>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>
        
    <?php endif; ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const fetchBtn = document.getElementById('fetchOnlineData');
    const statusDiv = document.getElementById('fetchStatus');
    
    if (fetchBtn) {
        fetchBtn.addEventListener('click', function() {
            fetchBtn.disabled = true;
            fetchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Fetching...';
            statusDiv.style.display = 'block';
            statusDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> Fetching latest products and methods...</div>';
            
            // Use AJAX to fetch online data
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'api/enhanced_recommendations.php', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                fetchBtn.disabled = false;
                fetchBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Fetch Latest Products & Methods';
                
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        console.log('Fetch response:', response);
                        
                        // Log database statistics
                        if (response.stats) {
                            console.log('📊 Database Statistics:', response.stats);
                            if (response.stats.products_found > 0) {
                                console.log('✅ Found ' + response.stats.products_found + ' products from database');
                            }
                            if (response.stats.methods_found > 0) {
                                console.log('✅ Found ' + response.stats.methods_found + ' methods from database');
                            }
                            if (response.stats.pitfalls_found > 0) {
                                console.log('✅ Found ' + response.stats.pitfalls_found + ' pitfalls from database');
                            }
                        }
                        if (response.compatibility_created > 0) {
                            console.log('✅ Created ' + response.compatibility_created + ' new compatibility records');
                        }
                        
                        if (response.success) {
                            let message = '<div class="alert alert-success">';
                            message += '<i class="fas fa-check-circle"></i> <strong>' + response.message + '</strong><br>';
                            
                            if (response.products_fetched > 0) {
                                message += '<small>✓ Found ' + response.products_fetched + ' products matching your ' + 
                                    (response.hair_type || 'hair type') + ' profile<br>';
                                message += '✓ Saved ' + response.products_saved + ' new products to database</small>';
                                
                                // Show sample products
                                if (response.filtered_products && response.filtered_products.length > 0) {
                                    message += '<div style="margin-top: 10px; padding: 10px; background: #f0f8ff; border-radius: 5px;">';
                                    message += '<strong>Sample products found:</strong><ul style="margin: 5px 0; padding-left: 20px;">';
                                    response.filtered_products.slice(0, 3).forEach(function(product) {
                                        message += '<li>' + product.product_name + ' (' + product.brand + ')</li>';
                                    });
                                    message += '</ul></div>';
                                }
                            } else {
                                message += '<small>No new products found, but recommendations have been updated.</small>';
                            }
                            
                            message += '</div>';
                            
                            // Show hair care tips info if available
                            if (response.hair_type_info) {
                                message += '<div style="margin-top: 15px; padding: 15px; background: linear-gradient(135deg, #8B4C9F, #F5A9B8); border-radius: 8px; color: white;">';
                                message += '<strong><i class="fas fa-book-open"></i> Hair Care Tips Available!</strong><br>';
                                message += '<small>Check the "How to Care for ' + (response.hair_type_info.type_name || response.hair_type) + ' Hair" section above for personalized care tips.</small>';
                                message += '</div>';
                            }
                            
                            // Add a button to manually reload if user wants to see new recommendations
                            message += '<div style="margin-top: 10px;"><button onclick="window.location.reload()" class="btn btn-primary btn-small">' +
                                '<i class="fas fa-sync-alt"></i> Refresh Page to See New Recommendations</button></div>';
                            statusDiv.innerHTML = message;
                        } else {
                            statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ' + 
                                (response.error || response.message || 'Unknown error occurred') + '</div>';
                        }
                    } catch (e) {
                        console.error('Parse error:', e, xhr.responseText);
                        statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Error parsing response: ' + e.message + '</div>';
                    }
                } else {
                    console.error('HTTP Error:', xhr.status, xhr.responseText);
                    statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Request failed with status ' + xhr.status + '</div>';
                }
            };
            
            xhr.onerror = function() {
                console.error('Network error');
                fetchBtn.disabled = false;
                fetchBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Fetch Latest Products & Methods';
                statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Network error occurred. Please check your connection and try again.</div>';
            };
            
            xhr.ontimeout = function() {
                console.error('Request timeout');
                fetchBtn.disabled = false;
                fetchBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Fetch Latest Products & Methods';
                statusDiv.innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Request timed out. Please try again.</div>';
            };
            
            xhr.timeout = 60000; // 60 second timeout
            
            console.log('Sending fetch request...');
            xhr.send();
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

