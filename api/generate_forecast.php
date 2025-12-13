<?php
/**
 * Generate hair growth forecast
 */

// Start output buffering and error handling
ob_start();
error_reporting(E_ALL);
ini_set('display_errors', 0);

// Register shutdown function to catch fatal errors
register_shutdown_function(function() {
    $error = error_get_last();
    if ($error !== NULL && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        ob_clean();
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode([
            'success' => false,
            'error' => 'Fatal error: ' . $error['message'] . ' in ' . $error['file'] . ' on line ' . $error['line']
        ]);
        ob_end_flush();
    }
});

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Set JSON header immediately
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    ob_clean();
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

try {
    require_once __DIR__ . '/../config/db.php';
} catch (Exception $e) {
    ob_clean();
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Failed to load database configuration']);
    ob_end_flush();
    exit;
}

$userId = $_SESSION['user_id'];

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
    $conn->close();
    
    if ($isValid) {
        $userId = $childId; // Switch context to child
    } else {
        ob_clean();
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Unauthorized access to child profile']);
        ob_end_flush();
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
    
    if (!$profile) {
        $conn->close();
        ob_clean();
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'No profile found. Please create your hair profile first.']);
        ob_end_flush();
        exit;
    }
    
    // Get progress entries - group by date and use the latest entry for each date
    $progressStmt = $conn->prepare("
        SELECT * FROM hair_growth_progress 
        WHERE profile_id = ? 
        ORDER BY measurement_date ASC, created_at DESC
    ");
    
    if (!$progressStmt) {
        throw new Exception("Progress query failed: " . $conn->error);
    }
    
    $progressStmt->bind_param("i", $profile['profile_id']);
    $progressStmt->execute();
    $allEntries = $progressStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $progressStmt->close();
    
    // Group by date and keep only the latest entry for each date
    $progressEntries = [];
    $seenDates = [];
    foreach ($allEntries as $entry) {
        $date = $entry['measurement_date'];
        if (!isset($seenDates[$date])) {
            $progressEntries[] = $entry;
            $seenDates[$date] = true;
        }
    }
    
    // Limit to 12 unique dates
    $progressEntries = array_slice($progressEntries, -12);
    
    if (count($progressEntries) < 2) {
        $conn->close();
        ob_clean();
        http_response_code(400);
        echo json_encode([
            'success' => false, 
            'error' => 'Need at least 2 progress entries with different dates to generate forecast. Please add more progress entries first.'
        ]);
        ob_end_flush();
        exit;
    }
    
    // Calculate growth rate
    $latest = $progressEntries[count($progressEntries) - 1];
    $oldest = $progressEntries[0];
    $daysDiff = (strtotime($latest['measurement_date']) - strtotime($oldest['measurement_date'])) / (60 * 60 * 24);
    
    if ($daysDiff <= 0) {
        $conn->close();
        ob_clean();
        http_response_code(400);
        echo json_encode([
            'success' => false, 
            'error' => 'Invalid date range in progress entries. Please ensure entries have different dates. You may have multiple entries on the same date - try adding entries on different days.'
        ]);
        ob_end_flush();
        exit;
    }
    
    $lengthDiff = $latest['hair_length'] - $oldest['hair_length'];
    $growthRatePerMonth = ($lengthDiff / $daysDiff) * 30;
    
    // Validate growth rate (decimal(4,2) can store up to 99.99)
    if ($growthRatePerMonth > 99.99) {
        $growthRatePerMonth = 99.99;
    } elseif ($growthRatePerMonth < -99.99) {
        $growthRatePerMonth = -99.99;
    }
    
    // Generate forecasts
    // We project up to 12 months ahead, or until goal is reached
    $currentLength = $latest['hair_length'];
    $goalLength = $profile['goal_length'] ?? 999;
    $currentDate = strtotime($latest['measurement_date']);
    $confidenceLevel = min(1.0, max(0.0, count($progressEntries) / 12.0)); // More data = higher confidence, ensure between 0 and 1
    
    // Delete old forecasts for this profile
    $deleteStmt = $conn->prepare("DELETE FROM growth_forecasts WHERE profile_id = ?");
    if ($deleteStmt) {
        $deleteStmt->bind_param("i", $profile['profile_id']);
        $deleteStmt->execute();
        $deleteStmt->close();
    }
    
    // If growth rate is not positive, we can't forecast growth towards a goal
    if ($growthRatePerMonth <= 0.01) {
        // Return success but with warning message in result, or just 0 forecasts
         $conn->close();
         ob_clean();
         echo json_encode([
            'success' => true,
            'message' => "Growth rate is zero or negative. No new forecasts generated.",
            'forecasts_created' => 0,
            'growth_rate' => $growthRatePerMonth,
            'confidence_level' => $confidenceLevel
        ]);
        ob_end_flush();
        exit;
    }
    
    $forecastsCreated = 0;
    $dataPoints = count($progressEntries);
    
    // Project up to 24 months or until goal reached
    for ($i = 1; $i <= 24; $i++) {
        try {
            $forecastDate = date('Y-m-d', strtotime("+{$i} months", $currentDate));
            $predictedLength = $currentLength + ($growthRatePerMonth * $i);
            
            // Validate predicted_length (decimal(5,2) can store up to 999.99)
            if ($predictedLength > 999.99) {
                $predictedLength = 999.99;
            } elseif ($predictedLength < 0) {
                $predictedLength = 0;
            }
            
            $notes = "Based on " . $dataPoints . " data points. Average growth rate: " . number_format($growthRatePerMonth, 2) . " inches/month.";
            
            $insertForecast = $conn->prepare("INSERT INTO growth_forecasts 
                (profile_id, forecast_date, predicted_length, confidence_level, based_on_data_points, growth_rate_per_month, notes) 
                VALUES (?, ?, ?, ?, ?, ?, ?)");
            
            if (!$insertForecast) {
                error_log("Failed to prepare forecast insert for month {$i}: " . $conn->error);
                continue;
            }
            
            $insertForecast->bind_param("isddids", 
                $profile['profile_id'], 
                $forecastDate, 
                $predictedLength, 
                $confidenceLevel,
                $dataPoints,
                $growthRatePerMonth,
                $notes
            );
            
            if ($insertForecast->execute()) {
                $forecastsCreated++;
            } else {
                error_log("Failed to insert forecast for month {$i}: " . $insertForecast->error);
            }
            $insertForecast->close();
            
            // STOP if goal is reached (and we have generated at least this one entry showing the goal reached)
            if ($predictedLength >= $goalLength) {
                break;
            }
            
        } catch (Exception $e) {
            error_log("Exception inserting forecast for month {$i}: " . $e->getMessage());
            continue;
        }
    }
    $conn->close();
    
    ob_clean();
    echo json_encode([
        'success' => true,
        'message' => "Generated {$forecastsCreated} growth forecasts!",
        'forecasts_created' => $forecastsCreated,
        'growth_rate' => $growthRatePerMonth,
        'confidence_level' => $confidenceLevel
    ]);
    ob_end_flush();
    exit;
    
} catch (Exception $e) {
    $errorMsg = $e->getMessage();
    error_log("Error generating forecast: " . $errorMsg);
    error_log("Stack trace: " . $e->getTraceAsString());
    
    if (isset($conn) && $conn) {
        if (isset($insertForecast) && $insertForecast) {
            $insertForecast->close();
        }
        $conn->close();
    }
    
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error generating forecast: ' . $errorMsg
    ]);
    ob_end_flush();
    exit;
} catch (Error $e) {
    $errorMsg = $e->getMessage();
    error_log("Fatal error generating forecast: " . $errorMsg);
    error_log("Stack trace: " . $e->getTraceAsString());
    
    if (isset($conn) && $conn) {
        if (isset($insertForecast) && $insertForecast) {
            $insertForecast->close();
        }
        $conn->close();
    }
    
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Fatal error generating forecast: ' . $errorMsg
    ]);
    ob_end_flush();
    exit;
}
