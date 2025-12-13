<?php
/**
 * Generate personalized hair care routines
 */

// Start output buffering first
ob_start();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Set JSON header
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    ob_clean();
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

require_once __DIR__ . '/../config/db.php';

$userId = $_SESSION['user_id'];

if (isset($_GET['child_id'])) {
    $childId = (int)$_GET['child_id'];
    $conn = getDBConnection();
    
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
    } else {
        ob_clean();
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Unauthorized access to child profile']);
        ob_end_flush();
        exit;
    }
}
$conn = getDBConnection();

// Get user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    $conn->close();
    ob_clean();
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'No profile found']);
    ob_end_flush();
    exit;
}

// Get hair type info
$hairTypeInfo = null;
if ($profile['hair_type_id']) {
    $typeStmt = $conn->prepare("SELECT * FROM hair_types WHERE hair_type_id = ?");
    $typeStmt->bind_param("i", $profile['hair_type_id']);
    $typeStmt->execute();
    $hairTypeInfo = $typeStmt->get_result()->fetch_assoc();
    $typeStmt->close();
}

// Get user concerns
$concernsStmt = $conn->prepare("
    SELECT hc.concern_name, uhc.severity
    FROM user_hair_concerns uhc
    INNER JOIN hair_concerns hc ON uhc.concern_id = hc.concern_id
    WHERE uhc.profile_id = ?
");
$concernsStmt->bind_param("i", $profile['profile_id']);
$concernsStmt->execute();
$concerns = $concernsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$concernsStmt->close();

try {
    // Deactivate old routines
    $deactivateStmt = $conn->prepare("UPDATE hair_care_routines SET is_active = 0 WHERE profile_id = ?");
    $deactivateStmt->bind_param("i", $profile['profile_id']);
    $deactivateStmt->execute();
    $deactivateStmt->close();
    
    $routinesCreated = 0;
    $routineTypes = ['morning', 'night', 'wash_day'];
    
    foreach ($routineTypes as $routineType) {
        // Create routine
        $routineName = ucfirst($routineType) . ' Routine';
        $description = "Personalized " . $routineType . " hair care routine for " . 
                      ($hairTypeInfo ? $hairTypeInfo['type_name'] : 'your') . " hair type";
        
        $insertRoutine = $conn->prepare("INSERT INTO hair_care_routines 
            (profile_id, routine_name, routine_type, description, is_active, last_update_alert, update_frequency_days) 
            VALUES (?, ?, ?, ?, 1, CURDATE(), 90)");
        $insertRoutine->bind_param("isss", $profile['profile_id'], $routineName, $routineType, $description);
        
        if ($insertRoutine->execute()) {
            $routineId = $conn->insert_id;
            $routinesCreated++;
            
            // Generate steps based on routine type and profile
            $steps = generateRoutineSteps($routineType, $profile, $hairTypeInfo, $concerns, $conn);
            
            // Insert steps
            $stepOrder = 1;
            $insertStep = $conn->prepare("INSERT INTO routine_steps 
                (routine_id, step_order, step_name, product_id, method_id, duration, instructions, is_optional, frequency_note) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            foreach ($steps as $step) {
                $productId = $step['product_id'] ?? null;
                $methodId = $step['method_id'] ?? null;
                $duration = $step['duration'] ?? null;
                $instructions = $step['instructions'] ?? null;
                $isOptional = isset($step['is_optional']) ? (int)$step['is_optional'] : 0;
                $frequencyNote = $step['frequency_note'] ?? null;
                
                // Format: i (routine_id), i (step_order), s (step_name), i (product_id), i (method_id), s (duration), s (instructions), i (is_optional), s (frequency_note)
                // = "iisiisiss"
                $insertStep->bind_param("iisiisiss", 
                    $routineId, $stepOrder, $step['step_name'], 
                    $productId, $methodId, $duration, $instructions, $isOptional, $frequencyNote);
                
                if (!$insertStep->execute()) {
                    error_log("Error inserting routine step: " . $insertStep->error);
                }
                $stepOrder++;
            }
            
            $insertStep->close();
        }
        
        $insertRoutine->close();
    }
    
    $conn->close();
    
    ob_clean();
    echo json_encode([
        'success' => true,
        'message' => "Successfully generated {$routinesCreated} personalized routines!",
        'routines_created' => $routinesCreated
    ]);
    ob_end_flush();
    exit;
    
} catch (Exception $e) {
    error_log("Error generating routines: " . $e->getMessage());
    if (isset($conn)) {
        $conn->close();
    }
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error generating routines: ' . $e->getMessage()
    ]);
    ob_end_flush();
    exit;
}

function generateRoutineSteps($routineType, $profile, $hairTypeInfo, $concerns, $conn) {
    $steps = [];
    $products = [];
    $methods = [];
    
    // Get recommended products for this hair type
    if ($conn) {
        $productsStmt = $conn->prepare("
            SELECT p.*, phc.compatibility_score
            FROM products p
            INNER JOIN product_hair_type_compatibility phc ON p.product_id = phc.product_id
            WHERE phc.hair_type_id = ? AND phc.compatibility_score >= 7
            ORDER BY phc.compatibility_score DESC
            LIMIT 10
        ");
        
        if ($productsStmt) {
            $productsStmt->bind_param("i", $profile['hair_type_id']);
            if ($productsStmt->execute()) {
                $products = $productsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            }
            $productsStmt->close();
        } else {
             error_log("Warning: Failed to prepare products query (tables may be missing): " . $conn->error);
        }
    }
    
    // Get recommended methods
    if ($conn) {
        $methodsStmt = $conn->prepare("
            SELECT m.*, mhc.effectiveness_score
            FROM growth_methods m
            INNER JOIN method_hair_type_compatibility mhc ON m.method_id = mhc.method_id
            WHERE mhc.hair_type_id = ? AND mhc.effectiveness_score >= 7
            ORDER BY mhc.effectiveness_score DESC
            LIMIT 10
        ");
        
        if ($methodsStmt) {
            $methodsStmt->bind_param("i", $profile['hair_type_id']);
            if ($methodsStmt->execute()) {
                $methods = $methodsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            }
            $methodsStmt->close();
        } else {
            error_log("Warning: Failed to prepare methods query (tables may be missing): " . $conn->error);
        }
    }
    
    // Generate steps based on routine type
    // Fallbacks provided if products/methods are empty
    if ($routineType === 'morning') {
        $steps = [
            ['step_name' => 'Gentle Detangling', 'instructions' => 'Use a wide-tooth comb or fingers to gently detangle hair, starting from ends to roots.', 'duration' => '5-10 minutes'],
            ['step_name' => 'Moisturize', 'product_id' => $products[0]['product_id'] ?? null, 'instructions' => 'Apply leave-in conditioner or moisturizer to damp or dry hair.', 'duration' => '2-3 minutes'],
            ['step_name' => 'Seal with Oil', 'product_id' => $products[1]['product_id'] ?? null, 'instructions' => 'Apply a small amount of oil to seal in moisture.', 'duration' => '1-2 minutes'],
        ];
    } elseif ($routineType === 'night') {
        $steps = [
            ['step_name' => 'Protective Styling', 'instructions' => 'Style hair in a protective style (pineapple, braids, or satin wrap).', 'duration' => '5-10 minutes'],
            ['step_name' => 'Satin/Silk Protection', 'instructions' => 'Cover hair with satin or silk scarf/bonnet to prevent friction and moisture loss.', 'duration' => '1 minute'],
        ];
    } elseif ($routineType === 'wash_day') {
        $steps = [
            ['step_name' => 'Pre-Poo Treatment', 'product_id' => $products[2]['product_id'] ?? null, 'instructions' => 'Apply oil or conditioner to dry hair before washing.', 'duration' => '30-60 minutes', 'is_optional' => 1],
            ['step_name' => 'Shampoo', 'product_id' => $products[0]['product_id'] ?? null, 'instructions' => 'Wash hair with sulfate-free shampoo, focusing on scalp.', 'duration' => '5-10 minutes'],
            ['step_name' => 'Condition', 'product_id' => $products[1]['product_id'] ?? null, 'instructions' => 'Apply conditioner from mid-shaft to ends.', 'duration' => '5-10 minutes'],
            ['step_name' => 'Deep Condition', 'product_id' => $products[3]['product_id'] ?? null, 'instructions' => 'Apply deep conditioner and cover with cap. Leave in for recommended time.', 'duration' => '20-30 minutes', 'is_optional' => 1],
            ['step_name' => 'Leave-In Conditioner', 'product_id' => $products[1]['product_id'] ?? null, 'instructions' => 'Apply leave-in conditioner to damp hair.', 'duration' => '2-3 minutes'],
            ['step_name' => 'Style', 'instructions' => 'Style hair as desired using recommended products.', 'duration' => '15-30 minutes'],
        ];
    }
    
    return $steps;
}
?>

