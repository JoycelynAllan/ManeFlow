<?php
require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$userId = $_SESSION['user_id'];
$routineId = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if (!$routineId) {
    header('Location: routines.php');
    exit;
}

$conn = getDBConnection();

// Get routine details
$routineStmt = $conn->prepare("
    SELECT r.*, p.hair_type_id
    FROM hair_care_routines r
    INNER JOIN user_hair_profiles p ON r.profile_id = p.profile_id
    WHERE r.routine_id = ? AND p.user_id = ?
");
$routineStmt->bind_param("ii", $routineId, $userId);
$routineStmt->execute();
$routine = $routineStmt->get_result()->fetch_assoc();
$routineStmt->close();

if (!$routine) {
    $conn->close();
    header('Location: routines.php');
    exit;
}

// Get routine steps
$stepsStmt = $conn->prepare("
    SELECT rs.*, 
           p.product_name, p.brand,
           m.method_name
    FROM routine_steps rs
    LEFT JOIN products p ON rs.product_id = p.product_id
    LEFT JOIN growth_methods m ON rs.method_id = m.method_id
    WHERE rs.routine_id = ?
    ORDER BY rs.step_order ASC
");
$stepsStmt->bind_param("i", $routineId);
$stepsStmt->execute();
$steps = $stepsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stepsStmt->close();

// Get recommended protective styles for this hair type
$stylesStmt = $conn->prepare("
    SELECT ps.*, shc.suitability_score
    FROM protective_styles ps
    INNER JOIN style_hair_type_compatibility shc ON ps.style_id = shc.style_id
    WHERE shc.hair_type_id = ?
    ORDER BY shc.suitability_score DESC
    LIMIT 5
");
$stylesStmt->bind_param("i", $routine['hair_type_id']);
$stylesStmt->execute();
$recommendedStyles = $stylesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stylesStmt->close();

$conn->close();

$pageTitle = 'Routine Details';
include 'includes/header.php';
?>

<div class="container">
    <div class="page-header">
        <a href="routines.php" class="btn btn-secondary btn-small" style="margin-bottom: 1rem;">
            <i class="fas fa-arrow-left"></i> Back to Routines
        </a>
        <h1>
            <i class="fas fa-<?php 
                echo $routine['routine_type'] === 'morning' ? 'sun' : 
                    ($routine['routine_type'] === 'night' ? 'moon' : 
                    ($routine['routine_type'] === 'wash_day' ? 'shower' : 'calendar')); 
            ?>"></i>
            <?php echo htmlspecialchars($routine['routine_name'] ?? ucfirst(str_replace('_', ' ', $routine['routine_type']))); ?>
        </h1>
        <p><?php echo htmlspecialchars($routine['description'] ?? 'Your personalized hair care routine'); ?></p>
    </div>
    
    <?php if (!empty($steps)): ?>
        <div class="routine-steps-section">
            <h2><i class="fas fa-list-ol"></i> Routine Steps</h2>
            <div class="steps-list">
                <?php foreach ($steps as $index => $step): ?>
                    <div class="step-card <?php echo $step['is_optional'] ? 'optional' : ''; ?>">
                        <div class="step-number"><?php echo $index + 1; ?></div>
                        <div class="step-content">
                            <h3><?php echo htmlspecialchars($step['step_name'] ?? 'Step ' . ($index + 1)); ?></h3>
                            
                            <?php if ($step['product_name']): ?>
                                <p class="step-product">
                                    <i class="fas fa-pump-soap"></i> 
                                    <strong>Product:</strong> <?php echo htmlspecialchars($step['product_name']); ?>
                                    <?php if ($step['brand']): ?>
                                        by <?php echo htmlspecialchars($step['brand']); ?>
                                    <?php endif; ?>
                                </p>
                            <?php endif; ?>
                            
                            <?php if ($step['method_name']): ?>
                                <p class="step-method">
                                    <i class="fas fa-seedling"></i> 
                                    <strong>Method:</strong> <?php echo htmlspecialchars($step['method_name']); ?>
                                </p>
                            <?php endif; ?>
                            
                            <?php if ($step['instructions']): ?>
                                <p class="step-instructions"><?php echo nl2br(htmlspecialchars($step['instructions'])); ?></p>
                            <?php endif; ?>
                            
                            <?php if ($step['duration']): ?>
                                <p class="step-duration"><i class="fas fa-clock"></i> Duration: <?php echo htmlspecialchars($step['duration']); ?></p>
                            <?php endif; ?>
                            
                            <?php if ($step['frequency_note']): ?>
                                <p class="step-frequency"><i class="fas fa-calendar-alt"></i> <?php echo htmlspecialchars($step['frequency_note']); ?></p>
                            <?php endif; ?>
                            
                            <?php if ($step['is_optional']): ?>
                                <span class="optional-badge">Optional</span>
                            <?php endif; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php else: ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> No steps defined for this routine yet.
        </div>
    <?php endif; ?>
    
    <?php if (!empty($recommendedStyles)): ?>
        <div class="recommended-styles-section">
            <h2><i class="fas fa-palette"></i> Recommended Protective Styles</h2>
            <p class="section-intro">These protective styles work well with your hair type and complement this routine:</p>
            <div class="styles-grid">
                <?php foreach ($recommendedStyles as $style): ?>
                    <div class="style-card">
                        <h3><?php echo htmlspecialchars($style['style_name']); ?></h3>
                        <span class="difficulty-badge difficulty-<?php echo strtolower($style['difficulty_level'] ?? 'beginner'); ?>">
                            <?php echo ucfirst($style['difficulty_level'] ?? 'Beginner'); ?>
                        </span>
                        <?php if ($style['description']): ?>
                            <p><?php echo htmlspecialchars(substr($style['description'], 0, 150)); ?>...</p>
                        <?php endif; ?>
                        <?php if ($style['expected_longevity_days']): ?>
                            <p><i class="fas fa-calendar"></i> Lasts ~<?php echo $style['expected_longevity_days']; ?> days</p>
                        <?php endif; ?>
                        <a href="styles.php?id=<?php echo $style['style_id']; ?>" class="btn btn-primary btn-small">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
    
    <div class="routine-actions">
        <button id="markComplete" class="btn btn-success">
            <i class="fas fa-check"></i> Mark as Completed Today
        </button>
        <a href="routines.php" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Routines
        </a>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const markCompleteBtn = document.getElementById('markComplete');
    
    if (markCompleteBtn) {
        markCompleteBtn.addEventListener('click', function() {
            if (confirm('Mark this routine as completed for today?')) {
                const xhr = new XMLHttpRequest();
                xhr.open('POST', 'api/log_routine_completion.php', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                alert('Routine marked as completed! Great job!');
                                markCompleteBtn.disabled = true;
                                markCompleteBtn.innerHTML = '<i class="fas fa-check-circle"></i> Completed Today';
                            } else {
                                alert('Error: ' + (response.error || 'Failed to log completion'));
                            }
                        } catch (e) {
                            alert('Error parsing response');
                        }
                    }
                };
                
                xhr.send('routine_id=<?php echo $routineId; ?>');
            }
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

