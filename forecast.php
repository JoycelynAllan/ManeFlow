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
$isViewingChild = false;
$childInfo = null;

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    
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
    } else {
        header('Location: children.php?error=unauthorized');
        exit;
    }
}
$error = null;
$profile = null;
$progressEntries = [];
$forecasts = [];
$growthRate = null;

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
    
    if ($profile) {
        // Get growth progress entries
        $progressStmt = $conn->prepare("
            SELECT * FROM hair_growth_progress 
            WHERE profile_id = ? 
            ORDER BY measurement_date DESC
            LIMIT 12
        ");
        if ($progressStmt) {
            $progressStmt->bind_param("i", $profile['profile_id']);
            $progressStmt->execute();
            $progressEntries = $progressStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $progressStmt->close();
        }
        
        // Get forecasts
        $forecastStmt = $conn->prepare("
            SELECT * FROM growth_forecasts 
            WHERE profile_id = ? 
            ORDER BY forecast_date ASC
            LIMIT 6
        ");
        if ($forecastStmt) {
            $forecastStmt->bind_param("i", $profile['profile_id']);
            $forecastStmt->execute();
            $forecasts = $forecastStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $forecastStmt->close();
        }
        
        // Calculate current growth rate if we have enough data
        if (count($progressEntries) >= 2) {
            $latest = $progressEntries[0];
            $oldest = $progressEntries[count($progressEntries) - 1];
            $daysDiff = (strtotime($latest['measurement_date']) - strtotime($oldest['measurement_date'])) / (60 * 60 * 24);
            if ($daysDiff > 0) {
                $lengthDiff = $latest['hair_length'] - $oldest['hair_length'];
                $growthRate = ($lengthDiff / $daysDiff) * 30; // per month
            }
        }
    }
    
    $conn->close();
} catch (Exception $e) {
    $error = $e->getMessage();
    error_log("Forecast page error: " . $error);
    if (isset($conn) && $conn) {
        $conn->close();
    }
}

$pageTitle = $isViewingChild ? ($childInfo['first_name'] . "'s Growth Forecast") : 'Growth Forecast';
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
            <h1><i class="fas fa-chart-line"></i> <?php echo htmlspecialchars($childInfo['first_name'] . "'s"); ?> Growth Forecast</h1>
            <p>Track <?php echo htmlspecialchars($childInfo['first_name']); ?>'s progress and see predicted growth milestones</p>
        <?php else: ?>
            <h1><i class="fas fa-chart-line"></i> Hair Growth Forecast</h1>
            <p>Track your progress and see predicted growth milestones</p>
        <?php endif; ?>
        <?php if ($profile): ?>
            <button type="button" id="generateForecast" class="btn btn-primary" style="margin-top: 1rem;">
                <i class="fas fa-calculator"></i> Generate Forecast
            </button>
            <button type="button" id="addProgress" class="btn btn-secondary" style="margin-top: 1rem;">
                <i class="fas fa-plus"></i> Add Progress Entry
            </button>
        <?php endif; ?>
        <div id="forecastStatus" style="margin-top: 0.5rem; display: none;"></div>
    </div>
    
    <?php if ($error): ?>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Error loading forecast:</strong>
                <p><?php echo htmlspecialchars($error); ?></p>
                <p>Please check your database connection and ensure the 'maneflow' database exists with all required tables.</p>
            </div>
        </div>
    <?php elseif (!$profile): ?>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <div>
                <strong>No hair profile found!</strong>
                <p>Please <a href="profile.php<?php echo $isViewingChild ? '?child_id=' . $userId : ''; ?>">create <?php echo $isViewingChild ? 'a' : 'your'; ?> hair profile</a> first to track your growth progress.</p>
            </div>
        </div>
    <?php elseif ($profile['goal_length'] && $profile['current_length']): ?>
        <div class="goal-card">
            <h2><i class="fas fa-bullseye"></i> Your Growth Goal</h2>
            <div class="goal-progress">
                <div class="goal-info">
                    <span>Current: <?php echo number_format($profile['current_length'], 1); ?> inches</span>
                    <span>Goal: <?php echo number_format($profile['goal_length'], 1); ?> inches</span>
                    <span>Remaining: <?php echo number_format($profile['goal_length'] - $profile['current_length'], 1); ?> inches</span>
                </div>
                <?php 
                $progressPercent = min(100, ($profile['current_length'] / $profile['goal_length']) * 100);
                ?>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <?php echo $progressPercent; ?>%"></div>
                </div>
                <?php if ($growthRate && $growthRate > 0): ?>
                    <p class="estimated-time">
                        <i class="fas fa-clock"></i> 
                        Estimated time to goal: <?php 
                            $monthsNeeded = ($profile['goal_length'] - $profile['current_length']) / $growthRate;
                            echo ceil($monthsNeeded) . ' months';
                        ?>
                    </p>
                <?php endif; ?>
            </div>
        </div>
    <?php endif; ?>
    
    <?php if (!empty($forecasts)): ?>
        <div class="forecast-section">
            <h2><i class="fas fa-crystal-ball"></i> Growth Predictions</h2>
            <div class="forecast-chart-container">
                <canvas id="forecastChart"></canvas>
            </div>
            <div class="forecast-list">
                <?php foreach ($forecasts as $forecast): ?>
                    <div class="forecast-card">
                        <div class="forecast-date"><?php echo date('M d, Y', strtotime($forecast['forecast_date'])); ?></div>
                        <div class="forecast-length">
                            <strong><?php echo number_format($forecast['predicted_length'], 1); ?> inches</strong>
                            <?php if ($forecast['confidence_level']): ?>
                                <span class="confidence-badge"><?php echo number_format($forecast['confidence_level'] * 100, 0); ?>% confidence</span>
                            <?php endif; ?>
                        </div>
                        <?php if ($forecast['growth_rate_per_month']): ?>
                            <p>Growth rate: <?php echo number_format($forecast['growth_rate_per_month'], 2); ?> inches/month</p>
                        <?php endif; ?>
                        <?php if ($forecast['notes']): ?>
                            <p class="forecast-notes"><?php echo htmlspecialchars($forecast['notes']); ?></p>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php else: ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>No forecasts yet!</strong>
                <p>Add progress entries and generate a forecast to see your predicted growth timeline.</p>
            </div>
        </div>
    <?php endif; ?>
    
    <?php if (!empty($progressEntries)): ?>
        <div class="progress-section">
            <h2><i class="fas fa-history"></i> Progress History</h2>
            <div class="progress-list">
                <?php foreach ($progressEntries as $entry): ?>
                    <div class="progress-entry">
                        <div class="entry-date"><?php echo date('M d, Y', strtotime($entry['measurement_date'])); ?></div>
                        <div class="entry-length"><?php echo number_format($entry['hair_length'], 1); ?> inches</div>
                        <?php if ($entry['notes']): ?>
                            <p class="entry-notes"><?php echo htmlspecialchars($entry['notes']); ?></p>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php if (!empty($forecasts) && !empty($progressEntries)): ?>
    // Create forecast chart
    const ctx = document.getElementById('forecastChart');
    if (ctx) {
        const progressData = <?php echo json_encode($progressEntries); ?>;
        const forecastData = <?php echo json_encode($forecasts); ?>;
        
        const labels = [];
        const actualData = [];
        const forecastDataPoints = [];
        
        // Add progress entries
        progressData.reverse().forEach(entry => {
            labels.push(new Date(entry.measurement_date).toLocaleDateString());
            actualData.push(parseFloat(entry.hair_length));
            forecastDataPoints.push(null);
        });
        
        // Add forecast points
        forecastData.forEach(forecast => {
            labels.push(new Date(forecast.forecast_date).toLocaleDateString());
            actualData.push(null);
            forecastDataPoints.push(parseFloat(forecast.predicted_length));
        });
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Actual Length',
                    data: actualData,
                    borderColor: 'rgb(139, 76, 159)',
                    backgroundColor: 'rgba(139, 76, 159, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Predicted Length',
                    data: forecastDataPoints,
                    borderColor: 'rgb(245, 169, 184)',
                    backgroundColor: 'rgba(245, 169, 184, 0.1)',
                    borderDash: [5, 5],
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: false,
                        title: {
                            display: true,
                            text: 'Hair Length (inches)'
                        }
                    }
                }
            }
        });
    }
    <?php endif; ?>
    
    // Generate forecast button
    const generateBtn = document.getElementById('generateForecast');
    console.log('Generate button found:', generateBtn);
    
    if (generateBtn) {
        console.log('Attaching click handler to generate button');
        generateBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            console.log('Generate forecast button clicked');
            
            generateBtn.disabled = true;
            generateBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
            
            const xhr = new XMLHttpRequest();
            const url = 'api/generate_forecast.php<?php echo $isViewingChild ? "?child_id=" . $userId : ""; ?>';
            xhr.open('POST', url, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                console.log('XHR response received:', xhr.status, xhr.responseText);
                generateBtn.disabled = false;
                generateBtn.innerHTML = '<i class="fas fa-calculator"></i> Generate Forecast';
                
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        console.log('Parsed response:', response);
                        if (response.success) {
                            alert('Forecast generated successfully! ' + (response.message || ''));
                            window.location.reload();
                        } else {
                            alert('Error: ' + (response.error || 'Failed to generate forecast'));
                        }
                    } catch (e) {
                        console.error('Parse error:', e, xhr.responseText);
                        alert('Error parsing response. Please check the console for details.');
                    }
                } else {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        const errorMsg = response.error || 'Request failed with status ' + xhr.status;
                        console.error('API Error:', errorMsg);
                        alert('Error: ' + errorMsg);
                    } catch (e) {
                        console.error('Failed to parse error response:', xhr.responseText);
                        alert('Error: Request failed with status ' + xhr.status + '. Please check the console for details.');
                    }
                }
            };
            
            xhr.onerror = function() {
                console.error('XHR error occurred');
                generateBtn.disabled = false;
                generateBtn.innerHTML = '<i class="fas fa-calculator"></i> Generate Forecast';
                alert('Network error occurred. Please check your connection and try again.');
            };
            
            xhr.ontimeout = function() {
                console.error('XHR timeout');
                generateBtn.disabled = false;
                generateBtn.innerHTML = '<i class="fas fa-calculator"></i> Generate Forecast';
                alert('Request timed out. Please try again.');
            };
            
            console.log('Sending XHR request to api/generate_forecast.php');
            xhr.send();
        });
    } else {
        console.error('Generate forecast button not found!');
    }
    
    // Add progress button
    const addProgressBtn = document.getElementById('addProgress');
    if (addProgressBtn) {
        addProgressBtn.addEventListener('click', function() {
            const length = prompt('Enter current hair length (inches):');
            if (length && !isNaN(length) && parseFloat(length) > 0) {
                const notes = prompt('Optional notes:') || '';
                
                addProgressBtn.disabled = true;
                addProgressBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
                
                const xhr = new XMLHttpRequest();
                const url = 'api/add_progress.php<?php echo $isViewingChild ? "?child_id=" . $userId : ""; ?>';
                xhr.open('POST', url, true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onload = function() {
                    addProgressBtn.disabled = false;
                    addProgressBtn.innerHTML = '<i class="fas fa-plus"></i> Add Progress Entry';
                    
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                alert('Progress entry added successfully!');
                                window.location.reload();
                            } else {
                                alert('Error: ' + (response.error || 'Failed to add progress'));
                            }
                        } catch (e) {
                            console.error('Parse error:', e, xhr.responseText);
                            alert('Error parsing response. Please check the console for details.');
                        }
                    } else {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            alert('Error: ' + (response.error || 'Request failed with status ' + xhr.status));
                        } catch (e) {
                            alert('Error: Request failed with status ' + xhr.status);
                        }
                    }
                };
                
                xhr.onerror = function() {
                    addProgressBtn.disabled = false;
                    addProgressBtn.innerHTML = '<i class="fas fa-plus"></i> Add Progress Entry';
                    alert('Network error occurred. Please check your connection and try again.');
                };
                
                xhr.send('length=' + encodeURIComponent(length) + '&notes=' + encodeURIComponent(notes));
            } else if (length) {
                alert('Please enter a valid number greater than 0.');
            }
        });
    }
});
</script>

<?php include 'includes/footer.php'; ?>

