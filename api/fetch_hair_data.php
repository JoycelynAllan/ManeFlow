<?php
/**
 * Fetch hair-related data from online sources
 * This module scrapes/fetches data from various hair care websites and APIs
 */

// Suppresses errors if called as API
if (!defined('INCLUDED')) {
    error_reporting(E_ALL);
    ini_set('display_errors', 0);
}

require_once '../config/db.php';

class HairDataFetcher {
    private $conn;
    private $userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
    
    public function __construct($conn) {
        $this->conn = $conn;
    }
    
    /**
     * Fetch product information from online sources
     */
    public function fetchProducts($hairType = null, $category = null) {
        $products = [];
        
        // Gets the hair type details for better filtering
        $hairTypeInfo = null;
        if ($hairType) {
            $typeStmt = $this->conn->prepare("SELECT type_code, type_name, category FROM hair_types WHERE hair_type_id = ?");
            $typeStmt->bind_param("i", $hairType);
            $typeStmt->execute();
            $hairTypeInfo = $typeStmt->get_result()->fetch_assoc();
            $typeStmt->close();
        }
        
        //Used AI for this block
        // Fetches the products from multiple sources with better error handling
        try {
            $amazonProducts = $this->fetchFromAmazon($hairType, $category, $hairTypeInfo);
            $products = array_merge($products, $amazonProducts);
        } catch (Exception $e) {
            error_log("Amazon fetch error: " . $e->getMessage());
        }
        
        try {
            $ultaProducts = $this->fetchFromUlta($hairType, $category, $hairTypeInfo);
            $products = array_merge($products, $ultaProducts);
        } catch (Exception $e) {
            error_log("Ulta fetch error: " . $e->getMessage());
        }
        
        // Uses the curated product database as fallback
        if (empty($products)) {
            $products = $this->fetchFromCuratedDatabase($hairType, $category, $hairTypeInfo);
        }
        
        // Filters the products based on hair profile
        $products = $this->filterProductsByHairType($products, $hairTypeInfo);
        
        return $products;
    }
    
    /**
     * Fetches the products from Amazon (using search)
     * Used AI here
     */
    private function fetchFromAmazon($hairType = null, $category = null, $hairTypeInfo = null) {
        $products = [];
        
        try {
            // Builds search query based on hair type
            $searchTerms = $this->buildSearchTerms($hairType, $category, $hairTypeInfo);
            
            // Limits to 2 searches to avoid timeout
            $searchTerms = array_slice($searchTerms, 0, 2);
            
            foreach ($searchTerms as $term) {
                // In production, use Amazon Product Advertising API
                $simulatedProducts = $this->getSimulatedAmazonProducts($term, $hairTypeInfo);
                $products = array_merge($products, $simulatedProducts);
                
                // A Small delay
                usleep(500000); // 0.5 seconds
            }
        } catch (Exception $e) {
            error_log("Amazon fetch error: " . $e->getMessage());
        }
        
        return $products;
    }
    
    /**
     * Get simulated Amazon products (for demonstration)
     * In production, replaces with actual API calls
     */
    private function getSimulatedAmazonProducts($searchTerm, $hairTypeInfo) {
        $products = [];
        
        // Curates product list based on hair type
        $curatedProducts = [
            [
                'product_name' => 'SheaMoisture Coconut & Hibiscus Curl & Shine Shampoo',
                'brand' => 'SheaMoisture',
                'category' => 'shampoo',
                'price' => 9.99,
                'rating' => 4.5,
                'description' => 'Sulfate-free shampoo for curly and coily hair',
                'key_ingredients' => 'Coconut Oil, Hibiscus, Shea Butter',
                'amazon_link' => 'https://www.amazon.com/s?k=sheamoisture+coconut+hibiscus',
                'image_url' => null, 
                'source' => 'amazon'
            ],
            [
                'product_name' => 'Cantu Shea Butter for Natural Hair Leave-In Conditioning Repair Cream',
                'brand' => 'Cantu',
                'category' => 'leave_in',
                'price' => 6.99,
                'rating' => 4.6,
                'description' => 'Moisturizing leave-in conditioner for natural hair',
                'key_ingredients' => 'Shea Butter, Coconut Oil, Jojoba Oil',
                'amazon_link' => 'https://www.amazon.com/s?k=cantu+shea+butter',
                'image_url' => null, 
                'source' => 'amazon'
            ],
            [
                'product_name' => 'Mielle Organics Rosemary Mint Strengthening Hair Masque',
                'brand' => 'Mielle Organics',
                'category' => 'mask',
                'price' => 12.99,
                'rating' => 4.7,
                'description' => 'Deep conditioning mask for hair growth and strength',
                'key_ingredients' => 'Rosemary, Mint, Biotin, Protein',
                'amazon_link' => 'https://www.amazon.com/s?k=mielle+rosemary+mint',
                'image_url' => null, 
                'source' => 'amazon'
            ],
            [
                'product_name' => 'Olaplex No.3 Hair Perfector',
                'brand' => 'Olaplex',
                'category' => 'treatment',
                'price' => 28.00,
                'rating' => 4.8,
                'description' => 'Repairing treatment for damaged hair',
                'key_ingredients' => 'Bis-Aminopropyl Diglycol Dimaleate',
                'amazon_link' => 'https://www.amazon.com/s?k=olaplex+no3',
                'image_url' => null, 
                'source' => 'amazon'
            ],
            [
                'product_name' => 'Jamaican Black Castor Oil',
                'brand' => 'Tropic Isle Living',
                'category' => 'oil',
                'price' => 8.99,
                'rating' => 4.5,
                'description' => 'Pure Jamaican black castor oil for hair growth',
                'key_ingredients' => '100% Jamaican Black Castor Oil',
                'amazon_link' => 'https://www.amazon.com/s?k=jamaican+black+castor+oil',
                'image_url' => null, 
                'source' => 'amazon'
            ]
        ];
        
        // Filters based on search term and hair type
        foreach ($curatedProducts as $product) {
            $match = false;
            $searchLower = strtolower($searchTerm);
            $productLower = strtolower($product['product_name'] . ' ' . $product['description']);
            
            // Checks if search term matches
            if (strpos($productLower, $searchLower) !== false || 
                strpos($searchLower, $product['category']) !== false) {
                $match = true;
            }
            
            // Additional filtering based on hair type
            if ($hairTypeInfo) {
                $hairCategory = strtolower($hairTypeInfo['category']);
                if ($hairCategory === 'coily' || $hairCategory === 'curly') {

                    // Checks if the product is for curly/coily hair
                    if (stripos($product['description'], 'curly') !== false ||
                        stripos($product['description'], 'coily') !== false ||
                        stripos($product['description'], 'natural') !== false) {
                        $match = true;
                    }
                }
            }
            
            if ($match) {
                $products[] = $product;
            }
        }
        
        return $products;
    }
    
    /**
     * Fetches products from Ulta 
     * Used AI for this function
     */
    private function fetchFromUlta($hairType = null, $category = null, $hairTypeInfo = null) {
        $products = [];
        
        try {
            // Simulated Ulta products
            $ultaProducts = [
                [
                    'product_name' => 'DevaCurl No-Poo Original Zero Lather Conditioning Cleanser',
                    'brand' => 'DevaCurl',
                    'category' => 'shampoo',
                    'price' => 24.00,
                    'rating' => 4.4,
                    'description' => 'Sulfate-free cleanser for curly hair',
                    'key_ingredients' => 'Wheat Protein, Chamomile',
                    'amazon_link' => 'https://www.ulta.com/p/devacurl-no-poo',
                    'image_url' => '',
                    'source' => 'ulta'
                ],
                [
                    'product_name' => 'Briogeo Don\'t Despair, Repair! Deep Conditioning Mask',
                    'brand' => 'Briogeo',
                    'category' => 'mask',
                    'price' => 36.00,
                    'rating' => 4.6,
                    'description' => 'Repairing mask for damaged hair',
                    'key_ingredients' => 'Rosehip Oil, B vitamins, Algae Extract',
                    'amazon_link' => 'https://www.ulta.com/p/briogeo-dont-despair-repair',
                    'image_url' => '',
                    'source' => 'ulta'
                ]
            ];
            
            $products = array_merge($products, $ultaProducts);
        } catch (Exception $e) {
            error_log("Ulta fetch error: " . $e->getMessage());
        }
        
        return $products;
    }
    
    /**
     * Fetch products from Sephora 
     * Used AI for this function
     */
    private function fetchFromSephora($hairType = null, $category = null, $hairTypeInfo = null) {
        $products = [];
        
        try {
            // Simulated Sephora products
            $sephoraProducts = [
                [
                    'product_name' => 'Moroccanoil Treatment',
                    'brand' => 'Moroccanoil',
                    'category' => 'oil',
                    'price' => 48.00,
                    'rating' => 4.7,
                    'description' => 'Argan oil treatment for all hair types',
                    'key_ingredients' => 'Argan Oil, Linseed Extract',
                    'amazon_link' => 'https://www.sephora.com/product/moroccanoil-treatment',
                    'image_url' => '',
                    'source' => 'sephora'
                ],
                [
                    'product_name' => 'Living Proof Restore Repair Treatment',
                    'brand' => 'Living Proof',
                    'category' => 'treatment',
                    'price' => 38.00,
                    'rating' => 4.5,
                    'description' => 'Repairing treatment for damaged hair',
                    'key_ingredients' => 'OFPMA, Amino Acids',
                    'amazon_link' => 'https://www.sephora.com/product/living-proof-restore',
                    'image_url' => '',
                    'source' => 'sephora'
                ]
            ];
            
            $products = array_merge($products, $sephoraProducts);
        } catch (Exception $e) {
            error_log("Sephora fetch error: " . $e->getMessage());
        }
        
        return $products;
    }
    
    /**
     * Builds search terms based on hair type and category
     */
    private function buildSearchTerms($hairType = null, $category = null, $hairTypeInfo = null) {
        $terms = [];
        
        if ($hairTypeInfo) {
            $hairTypeName = $hairTypeInfo['type_name'];
            $hairTypeCode = $hairTypeInfo['type_code'];
            $hairCategory = $hairTypeInfo['category'];
        } else {
            $hairTypeName = null;
            $hairTypeCode = null;
            $hairCategory = null;
        }
        
        // Builds search terms based on hair type
        if ($category) {
            $terms[] = $category . ($hairTypeName ? " for " . $hairTypeName : "");
            $terms[] = $category . ($hairTypeCode ? " " . $hairTypeCode : "");
        } else {
            if ($hairTypeName) {
                $terms[] = "hair products for " . $hairTypeName;
                $terms[] = $hairTypeCode . " hair products";
            }
            if ($hairCategory) {
                $terms[] = $hairCategory . " hair products";
                $terms[] = $hairCategory . " hair care";
            }
            $terms[] = "hair growth products";
            $terms[] = "hair care products";
        }
        
        return array_unique($terms);
    }
    
    /**
     * Filters the products based on hair type compatibility
     */
    private function filterProductsByHairType($products, $hairTypeInfo) {
        if (!$hairTypeInfo || empty($products)) {
            return $products;
        }
        
        $filtered = [];
        $hairCategory = strtolower($hairTypeInfo['category']);
        $hairTypeCode = strtolower($hairTypeInfo['type_code']);
        
        foreach ($products as $product) {
            $score = 5; // Default score
            
            $productText = strtolower($product['product_name'] . ' ' . ($product['description'] ?? ''));
            
            // Score based on hair type mentions
            if ($hairCategory === 'coily' || $hairCategory === 'curly') {
                if (stripos($productText, 'coily') !== false || 
                    stripos($productText, '4c') !== false ||
                    stripos($productText, '4b') !== false ||
                    stripos($productText, '4a') !== false) {
                    $score += 3;
                }
                if (stripos($productText, 'curly') !== false || 
                    stripos($productText, 'natural') !== false) {
                    $score += 2;
                }
            } elseif ($hairCategory === 'curly') {
                if (stripos($productText, 'curly') !== false ||
                    stripos($productText, '3c') !== false ||
                    stripos($productText, '3b') !== false ||
                    stripos($productText, '3a') !== false) {
                    $score += 3;
                }
            } elseif ($hairCategory === 'wavy') {
                if (stripos($productText, 'wavy') !== false ||
                    stripos($productText, '2c') !== false ||
                    stripos($productText, '2b') !== false ||
                    stripos($productText, '2a') !== false) {
                    $score += 3;
                }
            } elseif ($hairCategory === 'straight') {
                if (stripos($productText, 'straight') !== false ||
                    stripos($productText, '1c') !== false ||
                    stripos($productText, '1b') !== false ||
                    stripos($productText, '1a') !== false) {
                    $score += 3;
                }
            }
            
            // Boost score for high ratings
            if (isset($product['rating']) && $product['rating'] >= 4.5) {
                $score += 2;
            } elseif (isset($product['rating']) && $product['rating'] >= 4.0) {
                $score += 1;
            }
            
            // Only include products with score >= 6
            if ($score >= 6) {
                $product['compatibility_score'] = min($score, 10);
                $filtered[] = $product;
            }
        }
        
        // Sorts by compatibility score
        usort($filtered, function($a, $b) {
            $scoreA = $a['compatibility_score'] ?? 0;
            $scoreB = $b['compatibility_score'] ?? 0;
            return $scoreB <=> $scoreA;
        });
        
        return $filtered;
    }
    
    /**
     * Fetches from curated database (a fallback)
     */
    private function fetchFromCuratedDatabase($hairType = null, $category = null, $hairTypeInfo = null) {
        $products = [];
        
        // Gets products from database that match hair type
        if ($hairType) {
            $stmt = $this->conn->prepare("
                SELECT p.*, phc.compatibility_score
                FROM products p
                LEFT JOIN product_hair_type_compatibility phc ON p.product_id = phc.product_id AND phc.hair_type_id = ?
                WHERE phc.compatibility_score >= 7 OR phc.compatibility_score IS NULL
                ORDER BY phc.compatibility_score DESC, p.rating DESC
                LIMIT 10
            ");
            $stmt->bind_param("i", $hairType);
            $stmt->execute();
            $result = $stmt->get_result();
            
            while ($row = $result->fetch_assoc()) {
                $products[] = [
                    'product_name' => $row['product_name'],
                    'brand' => $row['brand'],
                    'category' => $row['category'],
                    'price' => $row['price'],
                    'rating' => $row['rating'],
                    'description' => $row['description'],
                    'key_ingredients' => $row['key_ingredients'],
                    'amazon_link' => $row['amazon_link'],
                    'image_url' => $row['image_url'],
                    'source' => 'database',
                    'compatibility_score' => $row['compatibility_score'] ?? 7
                ];
            }
            $stmt->close();
        }
        
        return $products;
    }
    
    /**
     * Fetchs the URL content using cURL
     */
    private function fetchURL($url) {
        $ch = curl_init();
        
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_USERAGENT => $this->userAgent,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_CONNECTTIMEOUT => 10,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_HTTPHEADER => [
                'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language: en-US,en;q=0.5',
                'Accept-Encoding: gzip, deflate',
                'Connection: keep-alive',
            ]
        ]);
        
        $html = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        
        curl_close($ch);
        
        if ($httpCode !== 200 || $error) {
            error_log("Failed to fetch URL: $url - HTTP $httpCode - $error");
            return false;
        }
        
        return $html;
    }
    
    /**
     * Parses Amazon search results
     * Used AI for this function
     */
    private function parseAmazonResults($html) {
        $products = [];
        
        // Uses DOMDocument to parse HTML
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
        
        // Amazon product selectors 
        $productNodes = $xpath->query("//div[contains(@class, 's-result-item')]");
        
        foreach ($productNodes as $node) {
            $product = [];
            
            // Extracts product name
            $nameNodes = $xpath->query(".//h2//span", $node);
            if ($nameNodes->length > 0) {
                $product['product_name'] = trim($nameNodes->item(0)->textContent);
            }
            
            // Extracts price
            $priceNodes = $xpath->query(".//span[contains(@class, 'a-price')]//span[contains(@class, 'a-offscreen')]", $node);
            if ($priceNodes->length > 0) {
                $priceText = $priceNodes->item(0)->textContent;
                $product['price'] = $this->extractPrice($priceText);
            }
            
            // Extracts rating
            $ratingNodes = $xpath->query(".//span[contains(@class, 'a-icon-alt')]", $node);
            if ($ratingNodes->length > 0) {
                $ratingText = $ratingNodes->item(0)->textContent;
                $product['rating'] = $this->extractRating($ratingText);
            }
            
            // Extracts image
            $imgNodes = $xpath->query(".//img[@data-image-latency]", $node);
            if ($imgNodes->length > 0) {
                $product['image_url'] = $imgNodes->item(0)->getAttribute('src');
            }
            
            // Extracts the link
            $linkNodes = $xpath->query(".//h2//a", $node);
            if ($linkNodes->length > 0) {
                $href = $linkNodes->item(0)->getAttribute('href');
                $product['amazon_link'] = 'https://www.amazon.com' . $href;
            }
            
            if (!empty($product['product_name'])) {
                $product['source'] = 'amazon';
                $products[] = $product;
            }
        }
        
        return $products;
    }
    
    /**
     * Parses Ulta search results
     */
    private function parseUltaResults($html) {
        $products = [];
        
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
        
        // Ulta product selectors
        $productNodes = $xpath->query("//div[contains(@class, 'product')]");
        
        foreach ($productNodes as $node) {
            $product = [];
            
            // Extracts the product name
            $nameNodes = $xpath->query(".//h4//a", $node);
            if ($nameNodes->length > 0) {
                $product['product_name'] = trim($nameNodes->item(0)->textContent);
            }
            
            // Extracts the price
            $priceNodes = $xpath->query(".//span[contains(@class, 'price')]", $node);
            if ($priceNodes->length > 0) {
                $product['price'] = $this->extractPrice($priceNodes->item(0)->textContent);
            }
            
            // Extract image
            $imgNodes = $xpath->query(".//img", $node);
            if ($imgNodes->length > 0) {
                $product['image_url'] = $imgNodes->item(0)->getAttribute('src');
            }
            
            if (!empty($product['product_name'])) {
                $product['source'] = 'ulta';
                $products[] = $product;
            }
        }
        
        return $products;
    }
    
    /**
     * Parses Sephora search results
     */
    private function parseSephoraResults($html) {
        $products = [];
        
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
        
        // Sephora product selectors
        $productNodes = $xpath->query("//div[contains(@class, 'product')]");
        
        foreach ($productNodes as $node) {
            $product = [];
            
            // Extracts the product name
            $nameNodes = $xpath->query(".//a[contains(@class, 'product-name')]", $node);
            if ($nameNodes->length > 0) {
                $product['product_name'] = trim($nameNodes->item(0)->textContent);
            }
            
            // Extracts the price
            $priceNodes = $xpath->query(".//span[contains(@class, 'price')]", $node);
            if ($priceNodes->length > 0) {
                $product['price'] = $this->extractPrice($priceNodes->item(0)->textContent);
            }
            
            // Extracts the rating
            $ratingNodes = $xpath->query(".//span[contains(@class, 'rating')]", $node);
            if ($ratingNodes->length > 0) {
                $product['rating'] = $this->extractRating($ratingNodes->item(0)->textContent);
            }
            
            if (!empty($product['product_name'])) {
                $product['source'] = 'sephora';
                $products[] = $product;
            }
        }
        
        return $products;
    }
    
    /**
     * Extracts the price from text
     * Used AI for this function
     */
    private function extractPrice($text) {
        // Remove currency symbols and extract number
        preg_match('/[\d,]+\.?\d*/', $text, $matches);
        if (!empty($matches)) {
            return (float)str_replace(',', '', $matches[0]);
        }
        return null;
    }
    
    /**
     * Extracts the rating from text
     * Used AI for this function
     */
    private function extractRating($text) {
        // Extract rating (usually 1-5)
        preg_match('/(\d+\.?\d*)\s*(?:out of|\/|stars?)/i', $text, $matches);
        if (!empty($matches)) {
            return (float)$matches[1];
        }
        // Try simple number extraction
        preg_match('/(\d+\.?\d*)/', $text, $matches);
        if (!empty($matches)) {
            $rating = (float)$matches[1];
            return ($rating <= 5) ? $rating : null;
        }
        return null;
    }
    
    /**
     * Fetchs hair care methods and tips from online
     */
    public function fetchGrowthMethods($hairType = null) {
        $methods = [];
        
        // Fetch from hair care blogs and websites
        $sources = [
            'https://www.naturallycurly.com/curlreading',
            'https://www.curlcentric.com',
            'https://www.haircare.com/articles'
        ];
        
        foreach ($sources as $source) {
            try {
                $html = $this->fetchURL($source);
                if ($html) {
                    $parsed = $this->parseMethodArticles($html, $source);
                    $methods = array_merge($methods, $parsed);
                }
                sleep(2);
            } catch (Exception $e) {
                error_log("Method fetch error for $source: " . $e->getMessage());
            }
        }
        
        return $methods;
    }
    
    /**
     * Parse method articles from HTML
     */
    private function parseMethodArticles($html, $source) {
        $methods = [];
        
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
        
        // Find article links
        $articleNodes = $xpath->query("//a[contains(@href, 'hair') or contains(@href, 'growth') or contains(@href, 'care')]");
        
        foreach ($articleNodes as $node) {
            $title = trim($node->textContent);
            $link = $node->getAttribute('href');
            
            if (!empty($title) && strlen($title) > 10) {
                $methods[] = [
                    'method_name' => $title,
                    'description' => 'Article from ' . parse_url($source, PHP_URL_HOST),
                    'source_url' => $link,
                    'source' => $source
                ];
            }
        }
        
        return $methods;
    }
    
    /**
     * Save fetched products to database
     */
    public function saveProductsToDB($products) {
        $saved = 0;
        
        foreach ($products as $product) {
            // Check if product already exists
            $checkStmt = $this->conn->prepare("SELECT product_id FROM products WHERE product_name = ? AND brand = ?");
            $brand = $product['brand'] ?? 'Unknown';
            $checkStmt->bind_param("ss", $product['product_name'], $brand);
            $checkStmt->execute();
            $result = $checkStmt->get_result();
            $checkStmt->close();
            
            if ($result->num_rows === 0) {
                // Insert new product
                $insertStmt = $this->conn->prepare("INSERT INTO products 
                    (product_name, brand, category, description, price, amazon_link, image_url, rating, key_ingredients)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                
                $category = $product['category'] ?? $this->determineCategory($product['product_name']);
                $description = $product['description'] ?? 'Product from ' . ($product['source'] ?? 'online');
                $price = $product['price'] ?? null;
                $amazonLink = $product['amazon_link'] ?? null;
                $imageUrl = $product['image_url'] ?? null;
                $rating = $product['rating'] ?? null;
                $keyIngredients = $product['key_ingredients'] ?? null;
                
                $insertStmt->bind_param("ssssdssds", 
                    $product['product_name'], $brand, $category, $description,
                    $price, $amazonLink, $imageUrl, $rating, $keyIngredients);
                
                if ($insertStmt->execute()) {
                    $saved++;
                }
                $insertStmt->close();
            } else {
                // Update existing product if it doesn't have an image or amazon link
                $existingProduct = $result->fetch_assoc();
                $updateFields = [];
                $updateValues = [];
                $updateTypes = '';
                
                if (!empty($product['image_url'])) {
                    $updateFields[] = "image_url = ?";
                    $updateValues[] = $product['image_url'];
                    $updateTypes .= 's';
                }
                
                if (!empty($product['amazon_link'])) {
                    $updateFields[] = "amazon_link = ?";
                    $updateValues[] = $product['amazon_link'];
                    $updateTypes .= 's';
                }
                
                if (!empty($updateFields)) {
                    $updateValues[] = $existingProduct['product_id'];
                    $updateTypes .= 'i';
                    
                    $updateStmt = $this->conn->prepare("UPDATE products SET " . implode(', ', $updateFields) . " WHERE product_id = ?");
                    $updateStmt->bind_param($updateTypes, ...$updateValues);
                    $updateStmt->execute();
                    $updateStmt->close();
                }
            }
        }
        
        return $saved;
    }
    
    /**
     * Determines the product category from name
     */
    private function determineCategory($productName) {
        $name = strtolower($productName);
        
        if (strpos($name, 'shampoo') !== false) return 'shampoo';
        if (strpos($name, 'conditioner') !== false) return 'conditioner';
        if (strpos($name, 'deep condition') !== false) return 'deep_conditioner';
        if (strpos($name, 'leave-in') !== false || strpos($name, 'leave in') !== false) return 'leave_in';
        if (strpos($name, 'oil') !== false) return 'oil';
        if (strpos($name, 'serum') !== false) return 'serum';
        if (strpos($name, 'mask') !== false) return 'mask';
        
        return 'other';
    }
}

// API endpoint to trigger fetching
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    $conn = getDBConnection();
    $fetcher = new HairDataFetcher($conn);
    
    $action = $_POST['action'];
    $hairTypeId = $_POST['hair_type_id'] ?? null;
    $category = $_POST['category'] ?? null;
    
    $response = ['success' => false, 'message' => '', 'data' => []];
    
    try {
        switch ($action) {
            case 'fetch_products':
                $products = $fetcher->fetchProducts($hairTypeId, $category);
                $saved = $fetcher->saveProductsToDB($products);
                $response = [
                    'success' => true,
                    'message' => "Fetched " . count($products) . " products, saved $saved new products",
                    'data' => $products
                ];
                break;
                
            case 'fetch_methods':
                $methods = $fetcher->fetchGrowthMethods($hairTypeId);
                $response = [
                    'success' => true,
                    'message' => "Fetched " . count($methods) . " growth methods",
                    'data' => $methods
                ];
                break;
                
            default:
                $response['message'] = 'Invalid action';
        }
    } catch (Exception $e) {
        $response['message'] = 'Error: ' . $e->getMessage();
    }
    
    $conn->close();
    echo json_encode($response);
    exit;
}
?>

