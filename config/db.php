<?php
// Load environment variables
require_once __DIR__ . '/env.php';

// Database configuration 
// Determine environment
$isProd = false;
if (isset($_SERVER['HTTP_HOST'])) {
    // Checks if running on the production server IP or domain
    $host = $_SERVER['HTTP_HOST'];
    if (strpos($host, '169.239.251.102') !== false || strpos($host, '159.239.251.102') !== false) { // Covering user provided IP
         $isProd = true;
    }
}

if ($isProd) {
    define('DB_HOST', env('DB_HOST_PROD', 'localhost'));
    define('DB_USER', env('DB_USER_PROD', 'joycelyn.allan'));
    define('DB_PASS', env('DB_PASS_PROD', 'Jalla@123'));
    define('DB_NAME', env('DB_NAME_PROD', 'webtech_2025A_joycelyn_allan'));
} else {
    define('DB_HOST', env('DB_HOST_LOCAL', '127.0.0.1'));
    define('DB_USER', env('DB_USER_LOCAL', 'root'));
    define('DB_PASS', env('DB_PASS_LOCAL', ''));
    define('DB_NAME', env('DB_NAME_LOCAL', 'maneflow'));
}

define('DB_PORT', env('DB_PORT', 3306));

// Creates database connection
function getDBConnection() {
    try {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);
        
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }
        
        $conn->set_charset("utf8mb4");
        return $conn;
    } catch (Exception $e) {
        die("Database connection error: " . $e->getMessage());
    }
}

// Starts session if not already started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
