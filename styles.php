<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$error = null;
$profile = null;
$styles = [];
$hairTypes = [];
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
    // Verify this child belongs to the current user (parent) using stored procedure
    $verifyStmt = $conn->prepare("CALL sp_verify_parent_child(?, ?)");
    $verifyStmt->bind_param("ii", $userId, $childId);
    $verifyStmt->execute();
    $verifyResult = $verifyStmt->get_result();
    $isValid = $verifyResult->fetch_assoc()['is_valid'] ?? 0;
    $verifyStmt->close();
    
    // Clear results
    while ($conn->next_result()) {
        $conn->store_result();
    }
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
        $isViewingChild = true;
        
        // Get child name
        $childNameStmt = $conn->prepare("SELECT first_name FROM users WHERE user_id = ?");
        $childNameStmt->bind_param("i", $childId);
        $childNameStmt->execute();
        $childInfo = $childNameStmt->get_result()->fetch_assoc();
        $childNameStmt->close();
        $conn->close();
    } else {
        $conn->close();
        header('Location: children.php?error=unauthorized');
        exit;
    }
}

try {
    $conn = getDBConnection();
    
    // Get user's profile
    $profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
    if (!$profileStmt) {
        throw new Exception("Profile query failed: " . $conn->error);
    }
    $profileStmt->bind_param("i", $userId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();

// Get style ID if viewing single style
$styleId = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($styleId) {
    // Get single style details
    $hairTypeId = $profile['hair_type_id'] ?? 0;
    $styleStmt = $conn->prepare("
        SELECT ps.*, shc.suitability_score, shc.special_considerations
        FROM protective_styles ps
        LEFT JOIN style_hair_type_compatibility shc ON ps.style_id = shc.style_id AND shc.hair_type_id = ?
        WHERE ps.style_id = ?
    ");
    $styleStmt->bind_param("ii", $hairTypeId, $styleId);
    $styleStmt->execute();
    $style = $styleStmt->get_result()->fetch_assoc();
    $styleStmt->close();
    
        if (!$style) {
            $conn->close();
            header('Location: styles.php');
            exit;
        }
        
        // Fix for Bantu Knots and any other styles with swapped image/video URLs
        $imageUrl = $style['image_url'] ?? '';
        $videoUrl = $style['video_tutorial_url'] ?? '';
        
        // Check if image_url is actually a video URL and video_url is an image
        if ($imageUrl && (strpos($imageUrl, 'youtube.com') !== false || strpos($imageUrl, 'youtu.be') !== false || strpos($imageUrl, 'youtube.com/shorts') !== false)) {
            // Swap them if image_url is a video
            if ($videoUrl && (strpos($videoUrl, '.jpg') !== false || strpos($videoUrl, '.jpeg') !== false || strpos($videoUrl, '.png') !== false || strpos($videoUrl, '.webp') !== false || strpos($videoUrl, 'frohub.com') !== false || strpos($videoUrl, 'encrypted-tbn') !== false)) {
                $temp = $imageUrl;
                $imageUrl = $videoUrl;
                $videoUrl = $temp;
            }
        }
        
        $pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Style Details") : ($style['style_name'] ?? 'Style Details');
        include 'includes/header.php';
        ?>
        
        <div class="container">
        <div class="page-header">
            <a href="<?php echo $isViewingChild ? 'styles.php?child_id=' . $childInfo['first_name'] : 'styles.php'; ?>" class="btn btn-secondary btn-small" style="margin-bottom: 1rem;">
                <i class="fas fa-arrow-left"></i> Back to Style Library
            </a>
            <h1><?php echo htmlspecialchars($style['style_name'] ?? 'Style Details'); ?></h1>
            <div class="style-meta">
                <span class="difficulty-badge difficulty-<?php echo strtolower($style['difficulty_level'] ?? 'beginner'); ?>">
                    <?php echo ucfirst($style['difficulty_level'] ?? 'Beginner'); ?>
                </span>
                <span class="category-badge"><?php echo ucfirst(str_replace('_', ' ', $style['category'] ?? 'Other')); ?></span>
                <?php if (!empty($style['suitability_score'])): ?>
                    <span class="suitability-badge"><?php echo $style['suitability_score']; ?>/10 Suitability</span>
                <?php endif; ?>
            </div>
        </div>
        
        <div class="style-detail-section">
            <?php if ($imageUrl): ?>
                <div class="style-image-section">
                    <img src="<?php echo htmlspecialchars($imageUrl); ?>" 
                         alt="<?php echo htmlspecialchars($style['style_name']); ?>"
                         class="style-detail-image"
                         onerror="this.style.display='none';">
                </div>
            <?php endif; ?>
            
            <?php if ($style['description']): ?>
                <div class="style-description">
                    <h2>Description</h2>
                    <p><?php echo nl2br(htmlspecialchars($style['description'])); ?></p>
                </div>
            <?php endif; ?>
            
            <div class="style-info-grid">
                <?php if ($style['expected_longevity_days']): ?>
                    <div class="info-card">
                        <i class="fas fa-calendar"></i>
                        <h3>Longevity</h3>
                        <p><?php echo $style['expected_longevity_days']; ?> days</p>
                    </div>
                <?php endif; ?>
                
                <?php if ($style['installation_time']): ?>
                    <div class="info-card">
                        <i class="fas fa-clock"></i>
                        <h3>Installation Time</h3>
                        <p><?php echo htmlspecialchars($style['installation_time']); ?></p>
                    </div>
                <?php endif; ?>
                
                <?php if ($style['cost_range']): ?>
                    <div class="info-card">
                        <i class="fas fa-dollar-sign"></i>
                        <h3>Cost Range</h3>
                        <p><?php echo htmlspecialchars($style['cost_range']); ?></p>
                    </div>
                <?php endif; ?>
            </div>
            
            <?php if ($style['maintenance_instructions']): ?>
                <div class="style-section">
                    <h2><i class="fas fa-tools"></i> Maintenance Instructions</h2>
                    <p><?php echo nl2br(htmlspecialchars($style['maintenance_instructions'])); ?></p>
                </div>
            <?php endif; ?>
            
            <?php if ($style['removal_instructions']): ?>
                <div class="style-section">
                    <h2><i class="fas fa-undo"></i> Removal Instructions</h2>
                    <p><?php echo nl2br(htmlspecialchars($style['removal_instructions'])); ?></p>
                </div>
            <?php endif; ?>
            
            <?php if ($style['common_mistakes']): ?>
                <div class="style-section">
                    <h2><i class="fas fa-exclamation-triangle"></i> Common Mistakes to Avoid</h2>
                    <p><?php echo nl2br(htmlspecialchars($style['common_mistakes'])); ?></p>
                </div>
            <?php endif; ?>
            
            <?php if ($style['special_considerations']): ?>
                <div class="style-section">
                    <h2><i class="fas fa-info-circle"></i> Special Considerations</h2>
                    <p><?php echo nl2br(htmlspecialchars($style['special_considerations'])); ?></p>
                </div>
            <?php endif; ?>
            
            <?php if ($videoUrl): ?>
                <div class="style-section">
                    <h2><i class="fas fa-video"></i> Video Tutorial</h2>
                    <a href="<?php echo htmlspecialchars($videoUrl); ?>" target="_blank" class="btn btn-primary">
                        <i class="fas fa-external-link-alt"></i> Watch Tutorial
                    </a>
                </div>
            <?php endif; ?>
        </div>
    </div>
    
        <?php
        $conn->close();
        include 'includes/footer.php';
        exit;
    }

    // List all styles
    $filterHairType = isset($_GET['hair_type']) ? (int)$_GET['hair_type'] : ($profile['hair_type_id'] ?? 0);

    if ($filterHairType) {
        $stylesStmt = $conn->prepare("
            SELECT ps.*, shc.suitability_score, shc.special_considerations
            FROM protective_styles ps
            INNER JOIN style_hair_type_compatibility shc ON ps.style_id = shc.style_id
            WHERE shc.hair_type_id = ?
            ORDER BY shc.suitability_score DESC, ps.style_name
        ");
        if ($stylesStmt) {
            $stylesStmt->bind_param("i", $filterHairType);
            $stylesStmt->execute();
            $styles = $stylesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $stylesStmt->close();
        }
    } else {
        $stylesStmt = $conn->prepare("SELECT * FROM protective_styles ORDER BY style_name");
        if ($stylesStmt) {
            $stylesStmt->execute();
            $styles = $stylesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $stylesStmt->close();
        }
    }

    // Get hair types for filter
    $hairTypesStmt = $conn->prepare("SELECT * FROM hair_types ORDER BY type_code");
    if ($hairTypesStmt) {
        $hairTypesStmt->execute();
        $hairTypes = $hairTypesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $hairTypesStmt->close();
    }
    
    $conn->close();
} catch (Exception $e) {
    $error = $e->getMessage();
    error_log("Styles page error: " . $error);
    if (isset($conn)) {
        $conn->close();
    }
}

$pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Style Library") : 'Protective Style Library';
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
            <h1><i class="fas fa-palette"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Style Library</h1>
            <p>Browse protective styles tailored to <?php echo htmlspecialchars($childInfo['first_name']); ?>'s hair type</p>
        <?php else: ?>
            <h1><i class="fas fa-palette"></i> Protective Hairstyle Library</h1>
            <p>Browse protective styles tailored to your hair type</p>
        <?php endif; ?>
    </div>
    
    <?php if ($error): ?>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Error loading styles:</strong>
                <p><?php echo htmlspecialchars($error); ?></p>
                <p>Please check your database connection and ensure the 'maneflow' database exists with all required tables.</p>
            </div>
        </div>
    <?php else: ?>
    
    <div class="filter-section">
        <label for="hairTypeFilter">Filter by Hair Type:</label>
        <select id="hairTypeFilter" class="form-control" style="max-width: 300px; display: inline-block;">
            <option value="0">All Hair Types</option>
            <?php foreach ($hairTypes as $type): ?>
                <option value="<?php echo $type['hair_type_id']; ?>" <?php echo $filterHairType == $type['hair_type_id'] ? 'selected' : ''; ?>>
                    <?php echo htmlspecialchars($type['type_code'] . ' - ' . $type['type_name']); ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>
    
    <?php if (empty($styles)): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>No styles found!</strong>
                <p>Try selecting a different hair type filter or check back later as we add more styles.</p>
            </div>
        </div>
    <?php else: ?>
        <div class="styles-grid">
            <?php foreach ($styles as $style): 
                // Fix for Bantu Knots and any other styles with swapped image/video URLs
                $imageUrl = $style['image_url'] ?? '';
                $videoUrl = $style['video_tutorial_url'] ?? '';
                
                // Check if image_url is actually a video URL and video_url is an image
                if ($imageUrl && (strpos($imageUrl, 'youtube.com') !== false || strpos($imageUrl, 'youtu.be') !== false || strpos($imageUrl, 'youtube.com/shorts') !== false)) {
                    // Swap them if image_url is a video
                    if ($videoUrl && (strpos($videoUrl, '.jpg') !== false || strpos($videoUrl, '.jpeg') !== false || strpos($videoUrl, '.png') !== false || strpos($videoUrl, '.webp') !== false || strpos($videoUrl, 'frohub.com') !== false || strpos($videoUrl, 'encrypted-tbn') !== false)) {
                        $temp = $imageUrl;
                        $imageUrl = $videoUrl;
                        $videoUrl = $temp;
                    }
                }
            ?>
                <div class="style-card">
                    <div class="style-header">
                        <h3><?php echo htmlspecialchars($style['style_name']); ?></h3>
                        <div class="style-badges">
                            <span class="difficulty-badge difficulty-<?php echo strtolower($style['difficulty_level'] ?? 'beginner'); ?>">
                                <?php echo ucfirst($style['difficulty_level'] ?? 'Beginner'); ?>
                            </span>
                            <?php if ($style['suitability_score']): ?>
                                <span class="suitability-badge"><?php echo $style['suitability_score']; ?>/10</span>
                            <?php endif; ?>
                        </div>
                    </div>
                    
                    <p class="style-category"><?php echo ucfirst(str_replace('_', ' ', $style['category'] ?? 'Other')); ?></p>
                    
                    <?php if ($style['description']): ?>
                        <p class="style-description"><?php echo htmlspecialchars(substr($style['description'], 0, 150)); ?>...</p>
                    <?php endif; ?>
                    
                    <div class="style-info">
                        <?php if ($style['expected_longevity_days']): ?>
                            <span><i class="fas fa-calendar"></i> <?php echo $style['expected_longevity_days']; ?> days</span>
                        <?php endif; ?>
                        <?php if ($style['installation_time']): ?>
                            <span><i class="fas fa-clock"></i> <?php echo htmlspecialchars($style['installation_time']); ?></span>
                        <?php endif; ?>
                    </div>
                    
                    <div class="style-actions">
                        <a href="styles.php?id=<?php echo $style['style_id']; ?><?php echo $isViewingChild ? '&child_id=' . $userId : ''; ?>" class="btn btn-primary btn-small">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                        <?php if ($videoUrl): ?>
                            <a href="<?php echo htmlspecialchars($videoUrl); ?>" 
                               target="_blank" class="btn btn-secondary btn-small" style="margin-top: 0.5rem;">
                                <i class="fas fa-play"></i> Watch Tutorial
                            </a>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
    <?php endif; ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const filter = document.getElementById('hairTypeFilter');
    if (filter) {
        filter.addEventListener('change', function() {
            const hairTypeId = this.value;
            window.location.href = 'styles.php' + (hairTypeId > 0 ? '?hair_type=' + hairTypeId : '') + '<?php echo $isViewingChild ? "&child_id=" . $userId : ""; ?>';
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

