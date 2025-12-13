<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$conn = getDBConnection();
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    
    // Verify this child belongs to the current user (parent) using stored procedure
    $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
    $verifyStmt->bind_param("ii", $_SESSION['user_id'], $childId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
    $verifyStmt->close();
    
    // Clear results
    while ($conn->next_result()) {
        $conn->store_result();
    }
    
    if ($isValid) {
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

// Get all hair types with detailed information
$hairTypesStmt = $conn->prepare("SELECT * FROM hair_types ORDER BY type_code");
$hairTypesStmt->execute();
$hairTypes = $hairTypesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$hairTypesStmt->close();

// Get all growth methods
$methodsStmt = $conn->prepare("SELECT * FROM growth_methods ORDER BY method_name");
$methodsStmt->execute();
$methods = $methodsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$methodsStmt->close();

// Get educational content if any
$contentStmt = $conn->prepare("SELECT * FROM educational_content ORDER BY published_at DESC, created_at DESC LIMIT 10");
$contentStmt->execute();
$educationalContent = $contentStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$contentStmt->close();

$conn->close();

$pageTitle = 'Educational Resources';
include 'includes/header.php';
?>

<div class="container">
    <div class="page-header">
    <div class="page-header">
        <?php if ($isViewingChild): ?>
             <div style="margin-bottom: 1rem;">
                <a href="children.php" class="btn btn-secondary" style="margin-bottom: 1rem;">
                    <i class="fas fa-arrow-left"></i> Back to My Children
                </a>
            </div>
            <h1><i class="fas fa-book"></i> Educational Resources for <?php echo htmlspecialchars($childInfo['first_name']); ?></h1>
            <p>Discover a wealth of information about hair types and effective growth methods</p>
        <?php else: ?>
            <h1><i class="fas fa-book"></i> Educational Resources</h1>
            <p>Discover a wealth of information about hair types and effective growth methods</p>
        <?php endif; ?>
    </div>
    
    <!-- Hair Types Section -->
    <section class="education-section">
        <h2><i class="fas fa-info-circle"></i> Understanding Hair Types</h2>
        <p class="section-intro">
            Hair types are classified using a system that categorizes hair based on curl pattern, texture, and characteristics. 
            Understanding your hair type is the first step toward achieving healthy, luscious locks.
        </p>
        
        <div class="hair-types-grid">
            <?php if (!empty($hairTypes)): ?>
                <?php 
                // Group hair types by category
                $groupedTypes = [];
                foreach ($hairTypes as $type) {
                    $category = $type['category'];
                    if (!isset($groupedTypes[$category])) {
                        $groupedTypes[$category] = [];
                    }
                    $groupedTypes[$category][] = $type;
                }
                
                $categoryNames = [
                    'straight' => 'Straight Hair (Type 1)',
                    'wavy' => 'Wavy Hair (Type 2)',
                    'curly' => 'Curly Hair (Type 3)',
                    'coily' => 'Coily Hair (Type 4)'
                ];
                
                foreach ($groupedTypes as $category => $types): 
                ?>
                    <div class="hair-category-section">
                        <h3><?php echo $categoryNames[$category] ?? ucfirst($category); ?></h3>
                        <div class="hair-types-list">
                            <?php foreach ($types as $type): ?>
                                <div class="hair-type-card">
                                    <div class="hair-type-header">
                                        <h4><?php echo htmlspecialchars($type['type_code'] . ' - ' . $type['type_name']); ?></h4>
                                    </div>
                                    <div class="hair-type-content">
                                        <?php if ($type['description']): ?>
                                            <p class="description"><strong>Description:</strong> <?php echo htmlspecialchars($type['description']); ?></p>
                                        <?php endif; ?>
                                        <?php if ($type['characteristics']): ?>
                                            <p class="characteristics"><strong>Characteristics:</strong> <?php echo htmlspecialchars($type['characteristics']); ?></p>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <p>Hair type information will be available after running the setup script.</p>
                    <a href="setup.php" class="btn btn-primary">Run Setup</a>
                </div>
            <?php endif; ?>
        </div>
    </section>
    
    <!-- Growth Methods Section -->
    <section class="education-section">
        <h2><i class="fas fa-seedling"></i> Effective Growth Methods</h2>
        <p class="section-intro">
            Discover proven methods and techniques to promote healthy hair growth. These strategies are tailored 
            to work with your specific hair type for optimal results.
        </p>
        
        <?php if (!empty($methods)): ?>
            <div class="methods-grid">
                <?php 
                // Group methods by category
                $groupedMethods = [];
                foreach ($methods as $method) {
                    $category = $method['category'] ?? 'other';
                    if (!isset($groupedMethods[$category])) {
                        $groupedMethods[$category] = [];
                    }
                    $groupedMethods[$category][] = $method;
                }
                
                $methodCategoryNames = [
                    'protective_styling' => 'Protective Styling',
                    'scalp_care' => 'Scalp Care',
                    'nutrition' => 'Nutrition',
                    'trimming' => 'Trimming',
                    'massage' => 'Scalp Massage',
                    'treatment' => 'Treatments',
                    'lifestyle' => 'Lifestyle',
                    'other' => 'Other Methods'
                ];
                
                foreach ($groupedMethods as $category => $categoryMethods): 
                ?>
                    <div class="method-category-section">
                        <h3><?php echo $methodCategoryNames[$category] ?? ucfirst(str_replace('_', ' ', $category)); ?></h3>
                        <div class="methods-list">
                            <?php foreach ($categoryMethods as $method): ?>
                                <div class="method-card">
                                    <h4><?php echo htmlspecialchars($method['method_name']); ?></h4>
                                    
                                    <?php if ($method['description']): ?>
                                        <p class="description"><?php echo htmlspecialchars($method['description']); ?></p>
                                    <?php endif; ?>
                                    
                                    <div class="method-details">
                                        <?php if ($method['difficulty_level']): ?>
                                            <span class="method-badge">
                                                <i class="fas fa-signal"></i> 
                                                <?php echo ucfirst($method['difficulty_level']); ?>
                                            </span>
                                        <?php endif; ?>
                                        
                                        <?php if ($method['frequency']): ?>
                                            <span class="method-badge">
                                                <i class="fas fa-clock"></i> 
                                                <?php echo htmlspecialchars($method['frequency']); ?>
                                            </span>
                                        <?php endif; ?>
                                        
                                        <?php if ($method['duration']): ?>
                                            <span class="method-badge">
                                                <i class="fas fa-hourglass-half"></i> 
                                                <?php echo htmlspecialchars($method['duration']); ?>
                                            </span>
                                        <?php endif; ?>
                                    </div>
                                    
                                    <?php if ($method['instructions']): ?>
                                        <div class="instructions">
                                            <strong><i class="fas fa-list-ol"></i> Instructions:</strong>
                                            <p><?php echo nl2br(htmlspecialchars($method['instructions'])); ?></p>
                                        </div>
                                    <?php endif; ?>
                                    
                                    <?php if ($method['expected_results']): ?>
                                        <div class="expected-results">
                                            <strong><i class="fas fa-check-circle"></i> Expected Results:</strong>
                                            <p><?php echo htmlspecialchars($method['expected_results']); ?></p>
                                        </div>
                                    <?php endif; ?>
                                    
                                    <?php if ($method['video_url']): ?>
                                        <a href="<?php echo htmlspecialchars($method['video_url']); ?>" 
                                           target="_blank" class="btn btn-primary btn-small">
                                            <i class="fas fa-play"></i> Watch Video
                                        </a>
                                    <?php endif; ?>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php else: ?>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <p>Growth method information will be available after adding methods to the database.</p>
            </div>
        <?php endif; ?>
    </section>
    
    <!-- Educational Content Section -->
    <?php if (!empty($educationalContent)): ?>
        <section class="education-section">
            <h2><i class="fas fa-newspaper"></i> Articles & Tutorials</h2>
            <div class="content-grid">
                <?php foreach ($educationalContent as $content): ?>
                    <div class="content-card">
                        <div class="content-body">
                            <span class="content-type-badge"><?php echo ucfirst($content['content_type'] ?? 'article'); ?></span>
                            <h3><?php echo htmlspecialchars($content['title']); ?></h3>
                            <?php if ($content['category']): ?>
                                <p class="content-category"><?php echo htmlspecialchars($content['category']); ?></p>
                            <?php endif; ?>
                            <?php if ($content['content_text']): ?>
                                <p class="content-excerpt"><?php echo htmlspecialchars(substr($content['content_text'], 0, 150)); ?>...</p>
                            <?php endif; ?>
                            <?php if ($content['content_url']): ?>
                                <a href="<?php echo htmlspecialchars($content['content_url']); ?>" 
                                   target="_blank" class="btn btn-primary btn-small">
                                    <i class="fas fa-external-link-alt"></i> Read More
                                </a>
                            <?php endif; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </section>
    <?php endif; ?>
</div>

<?php include 'includes/footer.php'; ?>

