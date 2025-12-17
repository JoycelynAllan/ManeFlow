<?php
/**
 * Cleanup script to remove invalid image URLs from database
 */

require_once 'config/db.php';

$conn = getDBConnection();

// Updates products with fake example.jpg URLs to NULL
$updateStmt = $conn->prepare("
    UPDATE products 
    SET image_url = NULL 
    WHERE image_url LIKE '%example.jpg%' 
       OR image_url LIKE '%placeholder%'
       OR image_url = ''
");

if ($updateStmt->execute()) {
    $affected = $conn->affected_rows;
    echo "✅ Updated $affected products - removed invalid image URLs\n";
} else {
    echo "❌ Error: " . $conn->error . "\n";
}

$updateStmt->close();
$conn->close();

echo "\n✅ Cleanup complete! Invalid image URLs have been removed from the database.\n";
?>


