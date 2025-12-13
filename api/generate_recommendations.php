<?php
/**
 * Generate personalized recommendations based on user's hair profile
 * Uses database queries only - no AI
 */

/**
 * Ensure priority is always a valid enum value
 * Returns exactly one of: 'low', 'medium', 'high', 'critical'
 */
function validatePriority($priority) {
    // Valid enum values from database schema
    $validPriorities = ['low', 'medium', 'high', 'critical'];
    
    // Handle null, empty, or non-string values
    if (empty($priority) || (!is_string($priority) && !is_numeric($priority))) {
        return 'medium'; // Safe default
    }
    
    // Convert to string and normalize to lowercase
    $priority = strtolower(trim((string)$priority));
    
    // Return valid priority or default to 'medium'
    if (in_array($priority, $validPriorities, true)) {
        return $priority;
    }
    
    // Always return a valid enum value
    return 'medium';
}

function generateRecommendations($profileId, $conn) {
    // Get user's hair profile and user info (including age)
    // Get user's hair profile and user info (including age)
    // Removed fn_get_age_group usage to avoid issues if function is missing on DB
    $profileStmt = $conn->prepare("
        SELECT uhp.*, u.date_of_birth, 
               TIMESTAMPDIFF(YEAR, u.date_of_birth, CURDATE()) as current_age
        FROM user_hair_profiles uhp
        INNER JOIN users u ON uhp.user_id = u.user_id
        WHERE uhp.profile_id = ?
    ");
    $profileStmt->bind_param("i", $profileId);
    $profileStmt->execute();
    $profile = $profileStmt->get_result()->fetch_assoc();
    $profileStmt->close();
    
    // Helper helper to calculate age group in PHP
    if (!function_exists('calculateAgeGroup')) {
        function calculateAgeGroup($age) {
            if ($age === null) return null;
            if ($age < 13) return 'child';
            if ($age >= 13 && $age <= 19) return 'teen';
            if ($age >= 20 && $age <= 35) return 'young_adult';
            if ($age >= 36 && $age <= 50) return 'adult';
            if ($age >= 51 && $age <= 65) return 'middle_aged';
            return 'senior';
        }
    }
    
    // Add age_group to profile array for downstream usage
    if ($profile && isset($profile['current_age'])) {
        $profile['age_group'] = calculateAgeGroup($profile['current_age']);
    }
    
    if (!$profile || !$profile['hair_type_id']) {
        return ['products_found' => 0, 'methods_found' => 0, 'pitfalls_found' => 0];
    }
    
    $hairTypeId = $profile['hair_type_id'];
    $ageGroup = $profile['age_group'] ?? null;
    
    // Deactivate old recommendations
    $deactivateStmt = $conn->prepare("UPDATE user_recommendations SET is_active = 0 WHERE profile_id = ?");
    $deactivateStmt->bind_param("i", $profileId);
    $deactivateStmt->execute();
    $deactivateStmt->close();
    
    $products = [];
    
    // Get product recommendations based on compatibility and age appropriateness
    if ($ageGroup) {
        
        $productStmt = $conn->prepare("
            SELECT p.*, phc.compatibility_score, phc.notes,
                   paa.suitability_score as product_age_score, paa.age_specific_notes as product_age_notes, 
                   paa.warnings as product_age_warnings
            FROM products p
            INNER JOIN product_hair_type_compatibility phc ON p.product_id = phc.product_id
            LEFT JOIN product_age_appropriateness paa ON p.product_id = paa.product_id AND paa.age_group = ?
            WHERE phc.hair_type_id = ? AND phc.compatibility_score >= 7
            AND (paa.age_group IS NULL OR paa.suitability_score >= 6)
            ORDER BY phc.compatibility_score DESC, COALESCE(paa.suitability_score, 5) DESC
            LIMIT 10
        ");
        
        $productStmt->bind_param("si", $ageGroup, $hairTypeId);
    } else {
        $productStmt = $conn->prepare("
            SELECT p.*, phc.compatibility_score, phc.notes,
                   NULL as product_age_score, NULL as product_age_notes, NULL as product_age_warnings
            FROM products p
            INNER JOIN product_hair_type_compatibility phc ON p.product_id = phc.product_id
            WHERE phc.hair_type_id = ? AND phc.compatibility_score >= 7
            ORDER BY phc.compatibility_score DESC
            LIMIT 10
        ");
        $productStmt->bind_param("i", $hairTypeId);
    }
    $productStmt->execute();
    $products = $productStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $productStmt->close();
    
    // If no products found with compatibility, try to get any products and create compatibility on the fly
    if (empty($products)) {
        // First, try to get products that don't have compatibility for this hair type
        $fallbackStmt = $conn->prepare("
            SELECT p.*, 7 as compatibility_score, 'Auto-generated compatibility' as notes
            FROM products p
            LEFT JOIN product_hair_type_compatibility phc ON p.product_id = phc.product_id AND phc.hair_type_id = ?
            WHERE phc.compatibility_id IS NULL
            ORDER BY p.rating DESC, p.product_id DESC
            LIMIT 10
        ");
        $fallbackStmt->bind_param("i", $hairTypeId);
        $fallbackStmt->execute();
        $fallbackProducts = $fallbackStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $fallbackStmt->close();
        
        // Create compatibility records for fallback products
        if (!empty($fallbackProducts)) {
            $insertCompStmt = $conn->prepare("INSERT INTO product_hair_type_compatibility 
                (product_id, hair_type_id, compatibility_score, notes) 
                VALUES (?, ?, 7, 'Auto-generated for recommendations')");
            
            foreach ($fallbackProducts as $fp) {
                $insertCompStmt->bind_param("ii", $fp['product_id'], $hairTypeId);
                $insertCompStmt->execute();
            }
            $insertCompStmt->close();
            
            $products = $fallbackProducts;
        } else {
            // Last resort: get ANY products
            $anyProductsStmt = $conn->prepare("SELECT p.*, 7 as compatibility_score, 'Auto-generated compatibility' as notes FROM products p ORDER BY p.rating DESC LIMIT 10");
            $anyProductsStmt->execute();
            $anyProducts = $anyProductsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $anyProductsStmt->close();
            
            if (!empty($anyProducts)) {
                $insertCompStmt = $conn->prepare("INSERT IGNORE INTO product_hair_type_compatibility 
                    (product_id, hair_type_id, compatibility_score, notes) 
                    VALUES (?, ?, 7, 'Auto-generated for recommendations')");
                
                foreach ($anyProducts as $ap) {
                    $insertCompStmt->bind_param("ii", $ap['product_id'], $hairTypeId);
                    $insertCompStmt->execute();
                }
                $insertCompStmt->close();
                
                $products = $anyProducts;
            }
        }
    }
    
    // Insert product recommendations
    if (!empty($products)) {
        $insertRecStmt = $conn->prepare("
            INSERT INTO user_recommendations (profile_id, recommendation_type, product_id, priority, personalized_note, age_consideration, age_modified)
            VALUES (?, 'product', ?, ?, ?, ?, ?)
        ");
        
        foreach ($products as $index => $product) {
            if (empty($product['product_id'])) {
                continue;
            }
            
            // Set priority based on index
            if ($index < 3) {
                $priority = 'high';
            } elseif ($index < 6) {
                $priority = 'medium';
            } else {
                $priority = 'low';
            }
            
            $priority = validatePriority($priority);
            
            // Build personalized note with age considerations
            $note = "Recommended for your hair type. " . ($product['notes'] ?? 'Compatibility score: ' . ($product['compatibility_score'] ?? 'N/A'));
            
            // Add age-specific notes if available
            if (!empty($product['product_age_notes'])) {
                $note .= " " . $product['product_age_notes'];
            }
            if (!empty($product['product_age_warnings'])) {
                $note .= " Note: " . $product['product_age_warnings'];
            }
            
            $note = trim($note);
            
            // Prepare age consideration data
            $ageConsideration = null;
            $ageModified = 0;
            if ($ageGroup && isset($product['product_age_score'])) {
                $ageConsideration = "Age group: {$ageGroup}. Age score: " . ($product['product_age_score'] ?? 'N/A');
                if (isset($product['product_age_score']) && $product['product_age_score'] < 7) {
                    $ageModified = 1; // Mark as age-modified if score is lower
                }
            }
            
            $priorityStr = (string)$priority;
            $insertRecStmt->bind_param("iissii", $profileId, $product['product_id'], $priorityStr, $note, $ageConsideration, $ageModified);
            
            if (!$insertRecStmt->execute()) {
                error_log("Error inserting product recommendation: " . $insertRecStmt->error);
                continue;
            }
        }
        $insertRecStmt->close();
    }
    
    // Get method recommendations based on compatibility and age suitability
    if ($ageGroup) {
        $methodStmt = $conn->prepare("
            SELECT m.*, mhtc.effectiveness_score, mhtc.notes,
                   mas.suitability_score as method_age_score, mas.age_modifications as method_age_modifications,
                   mas.precautions as method_age_precautions
            FROM growth_methods m
            INNER JOIN method_hair_type_compatibility mhtc ON m.method_id = mhtc.method_id
            LEFT JOIN method_age_suitability mas ON m.method_id = mas.method_id AND mas.age_group = ?
            WHERE mhtc.hair_type_id = ? AND mhtc.effectiveness_score >= 7
            AND (mas.age_group IS NULL OR mas.suitability_score >= 6)
            ORDER BY mhtc.effectiveness_score DESC, COALESCE(mas.suitability_score, 5) DESC
            LIMIT 10
        ");
        $methodStmt->bind_param("si", $ageGroup, $hairTypeId);
    } else {
        $methodStmt = $conn->prepare("
            SELECT m.*, mhtc.effectiveness_score, mhtc.notes,
                   NULL as method_age_score, NULL as method_age_modifications, NULL as method_age_precautions
            FROM growth_methods m
            INNER JOIN method_hair_type_compatibility mhtc ON m.method_id = mhtc.method_id
            WHERE mhtc.hair_type_id = ? AND mhtc.effectiveness_score >= 7
            ORDER BY mhtc.effectiveness_score DESC
            LIMIT 10
        ");
        $methodStmt->bind_param("i", $hairTypeId);
    }
    $methodStmt->execute();
    $methods = $methodStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $methodStmt->close();
    
    // Insert method recommendations
    if (!empty($methods)) {
        $insertMethodStmt = $conn->prepare("
            INSERT INTO user_recommendations (profile_id, recommendation_type, method_id, priority, personalized_note, age_consideration, age_modified)
            VALUES (?, 'method', ?, ?, ?, ?, ?)
        ");
        
        foreach ($methods as $index => $method) {
            if (empty($method['method_id'])) {
                continue;
            }
            
            if ($index < 3) {
                $priority = 'high';
            } elseif ($index < 6) {
                $priority = 'medium';
            } else {
                $priority = 'low';
            }
            
            $priority = validatePriority($priority);
            
            // Build personalized note with age considerations
            $note = "Effective method for your hair type. " . ($method['notes'] ?? 'Effectiveness score: ' . ($method['effectiveness_score'] ?? 'N/A'));
            
            // Add age-specific modifications if available
            if (!empty($method['method_age_modifications'])) {
                $note .= " Age-specific: " . $method['method_age_modifications'];
            }
            if (!empty($method['method_age_precautions'])) {
                $note .= " Precautions: " . $method['method_age_precautions'];
            }
            
            $note = trim($note);
            
            // Prepare age consideration data for methods
            $ageConsideration = null;
            $ageModified = 0;
            if ($ageGroup && isset($method['method_age_score'])) {
                $ageConsideration = "Age group: {$ageGroup}. Suitability score: " . ($method['method_age_score'] ?? 'N/A');
                if (isset($method['method_age_score']) && $method['method_age_score'] < 7) {
                    $ageModified = 1;
                }
            }
            
            $priorityStr = (string)$priority;
            $insertMethodStmt->bind_param("iissii", $profileId, $method['method_id'], $priorityStr, $note, $ageConsideration, $ageModified);
            
            if (!$insertMethodStmt->execute()) {
                error_log("Error inserting method recommendation: " . $insertMethodStmt->error);
                continue;
            }
        }
        $insertMethodStmt->close();
    }
    
    // Get pitfalls to avoid
    $pitfallStmt = $conn->prepare("
        SELECT p.*, phta.risk_level, phta.specific_notes
        FROM hair_pitfalls p
        INNER JOIN pitfall_hair_type_applicability phta ON p.pitfall_id = phta.pitfall_id
        WHERE phta.hair_type_id = ? AND phta.risk_level IN ('high', 'critical')
        ORDER BY 
            CASE phta.risk_level 
                WHEN 'critical' THEN 1 
                WHEN 'high' THEN 2 
                ELSE 3 
            END
        LIMIT 10
    ");
    $pitfallStmt->bind_param("i", $hairTypeId);
    $pitfallStmt->execute();
    $pitfalls = $pitfallStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $pitfallStmt->close();
    
    // Insert pitfall recommendations
    if (!empty($pitfalls)) {
        $insertPitfallStmt = $conn->prepare("
            INSERT INTO user_recommendations (profile_id, recommendation_type, pitfall_id, priority, personalized_note, age_consideration, age_modified)
            VALUES (?, 'pitfall_avoidance', ?, ?, ?, ?, ?)
        ");
        
        foreach ($pitfalls as $pitfall) {
            if (empty($pitfall['pitfall_id'])) {
                continue;
            }
            
            // Map risk_level to priority
            $riskLevel = isset($pitfall['risk_level']) ? trim($pitfall['risk_level']) : 'high';
            
            // Age consideration for pitfalls (generally applicable to all ages, but note if age-specific)
            $ageConsideration = null;
            $ageModified = 0;
            if ($ageGroup) {
                $ageConsideration = "Age group: {$ageGroup}. This pitfall applies to your age group.";
            }
            if ($riskLevel === 'critical') {
                $priority = 'critical';
            } elseif ($riskLevel === 'high') {
                $priority = 'high';
            } else {
                $priority = 'medium';
            }
            
            $priority = validatePriority($priority);
            
            // Use database notes or default note
            $note = "Important to avoid for your hair type. " . ($pitfall['specific_notes'] ?? $pitfall['description'] ?? '');
            $note = trim($note);
            
            // Age consideration for pitfalls (generally applicable to all ages, but note if age-specific)
            $ageConsideration = null;
            $ageModified = 0;
            if ($ageGroup) {
                $ageConsideration = "Age group: {$ageGroup}. This pitfall applies to your age group.";
            }
            
            $priorityStr = (string)validatePriority($priority);
            $insertPitfallStmt->bind_param("iissii", $profileId, $pitfall['pitfall_id'], $priorityStr, $note, $ageConsideration, $ageModified);
            
            if (!$insertPitfallStmt->execute()) {
                error_log("Error inserting pitfall recommendation: " . $insertPitfallStmt->error);
                continue;
            }
        }
        $insertPitfallStmt->close();
    }
    
    return [
        'products_found' => count($products),
        'methods_found' => count($methods),
        'pitfalls_found' => count($pitfalls)
    ];
}
