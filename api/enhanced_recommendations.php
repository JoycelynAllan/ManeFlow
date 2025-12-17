<?php
/**
 * Enhanced recommendation generator - Database only
 */

// Start session first
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Turn off error display and start output buffering
error_reporting(E_ALL);
ini_set('display_errors', 0);
ob_start();

// Sets the JSON header immediately
header('Content-Type: application/json');

// An error handler to catch fatal errors
function handleFatalError() {
    $error = error_get_last();
    if ($error !== NULL && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        ob_clean();
        http_response_code(500);
        echo json_encode([
            'success' => false, 
            'error' => 'Fatal error: ' . $error['message'] . ' in ' . basename($error['file']) . ' on line ' . $error['line']
        ]);
        ob_end_flush();
        exit;
    }
}

register_shutdown_function('handleFatalError');

try {
    require_once __DIR__ . '/../config/db.php';
    require_once __DIR__ . '/fetch_hair_data.php';
    require_once __DIR__ . '/generate_recommendations.php';
} catch (Exception $e) {
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false, 
        'error' => 'Failed to load required files: ' . $e->getMessage()
    ]);
    ob_end_flush();
    exit;
}

// Clear any output that might have been generated
ob_clean();

if (!isset($_SESSION['user_id'])) {
    ob_clean();
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// Gets the user's profile
$profileStmt = $conn->prepare("SELECT * FROM user_hair_profiles WHERE user_id = ? LIMIT 1");
$profileStmt->bind_param("i", $userId);
$profileStmt->execute();
$profile = $profileStmt->get_result()->fetch_assoc();
$profileStmt->close();

if (!$profile) {
    $conn->close();
    echo json_encode(['success' => false, 'error' => 'No profile found. Please create your hair profile first.']);
    ob_end_flush();
    exit;
}

try {
    // Gets the hair type information
    $hairTypeInfo = null;
    if ($profile['hair_type_id']) {
        $typeStmt = $conn->prepare("SELECT type_code, type_name, category FROM hair_types WHERE hair_type_id = ?");
        $typeStmt->bind_param("i", $profile['hair_type_id']);
        $typeStmt->execute();
        $hairTypeInfo = $typeStmt->get_result()->fetch_assoc();
        $typeStmt->close();
    }
    
    // Fetches the products from database based on hair type compatibility
    $fetcher = new HairDataFetcher($conn);
    $onlineProducts = $fetcher->fetchProducts($profile['hair_type_id'], null);
    $savedCount = $fetcher->saveProductsToDB($onlineProducts);
    
    // Fetches the growth methods from database
    $onlineMethods = $fetcher->fetchGrowthMethods($profile['hair_type_id']);
    
    // Links the products to hair types if needed
    $compatibilityCreated = 0;
    if (!empty($onlineProducts) && $profile['hair_type_id']) {
        foreach ($onlineProducts as $product) {
            $productName = trim($product['product_name'] ?? '');
            $brand = trim($product['brand'] ?? ($product['source'] ?? 'Unknown'));
            
            if (!empty($productName)) {
                // Trying to find product
                $productResult = null;
                if (!empty($brand) && $brand !== 'Unknown') {
                    $productStmt = $conn->prepare("SELECT product_id FROM products WHERE product_name = ? AND brand = ? LIMIT 1");
                    $productStmt->bind_param("ss", $productName, $brand);
                    $productStmt->execute();
                    $productResult = $productStmt->get_result()->fetch_assoc();
                    $productStmt->close();
                }
                
                if (!$productResult) {
                    $productStmt = $conn->prepare("SELECT product_id FROM products WHERE LOWER(product_name) = LOWER(?) LIMIT 1");
                    $productStmt->bind_param("s", $productName);
                    $productStmt->execute();
                    $productResult = $productStmt->get_result()->fetch_assoc();
                    $productStmt->close();
                }
                
                if ($productResult) {
                    // Checks if compatibility exists
                    $compStmt = $conn->prepare("SELECT compatibility_id FROM product_hair_type_compatibility 
                        WHERE product_id = ? AND hair_type_id = ?");
                    $compStmt->bind_param("ii", $productResult['product_id'], $profile['hair_type_id']);
                    $compStmt->execute();
                    $compResult = $compStmt->get_result();
                    $compStmt->close();
                    
                    if ($compResult->num_rows === 0) {
                        $score = isset($product['compatibility_score']) ? $product['compatibility_score'] : 7;
                        if (isset($product['rating']) && $product['rating'] >= 4.5) {
                            $score = 9;
                        } elseif (isset($product['rating']) && $product['rating'] >= 4.0) {
                            $score = 8;
                        }
                        
                        $insertComp = $conn->prepare("INSERT INTO product_hair_type_compatibility 
                            (product_id, hair_type_id, compatibility_score, notes) 
                            VALUES (?, ?, ?, ?)");
                        $notes = "Fetched from " . ($product['source'] ?? 'database');
                        $insertComp->bind_param("iiis", 
                            $productResult['product_id'], $profile['hair_type_id'], $score, $notes);
                        if ($insertComp->execute()) {
                            $compatibilityCreated++;
                        }
                        $insertComp->close();
                    }
                }
            }
        }
    }
    
    // Generates recommendations using database data
    // used AI for this
    $stats = generateRecommendations($profile['profile_id'], $conn);
    
} catch (Exception $e) {
    error_log("Enhanced recommendations error: " . $e->getMessage());
    error_log("Stack trace: " . $e->getTraceAsString());
    
    if (isset($conn)) {
        $conn->close();
    }
    
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'success' => false, 
        'error' => 'Error fetching data: ' . $e->getMessage(),
        'details' => 'Check PHP error logs for more information'
    ]);
    ob_end_flush();
    exit;
}

// Get hair care tips/educational content
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

// Builds the response
$response = [
    'success' => true,
    'message' => "Successfully fetched and filtered products for your hair type!",
    'products_fetched' => count($onlineProducts),
    'products_saved' => $savedCount,
    'methods_fetched' => count($onlineMethods),
    'hair_type' => $hairTypeInfo ? $hairTypeInfo['type_name'] : 'Unknown',
    'hair_type_id' => $profile['hair_type_id'] ?? null,
    'hair_type_info' => $hairTypeInfo,
    'care_tips' => $careTips,
    'filtered_products' => [],
    'compatibility_created' => $compatibilityCreated,
    'stats' => $stats
];

// Adds a sample of filtered products
if (!empty($onlineProducts)) {
    $response['filtered_products'] = array_slice($onlineProducts, 0, 5);
    $response['message'] .= " Found " . count($onlineProducts) . " products matching your " . 
        ($hairTypeInfo ? $hairTypeInfo['type_name'] : 'hair type') . " profile. " . 
        $savedCount . " new products added to database.";
} else {
    $response['message'] = "No new products found, but recommendations have been updated with existing data.";
}

$conn->close();

// Clears any output and sends JSON
ob_clean();
echo json_encode($response);
ob_end_flush();
exit;
?>
