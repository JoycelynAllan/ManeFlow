<?php
/**
 * Setup script to populate initial data
 * Run this once after importing the database
 */
require_once 'config/db.php';

$pageTitle = 'Database Setup';
include 'includes/header.php';

$conn = getDBConnection();

// Check if hair types exist
$checkStmt = $conn->query("SELECT COUNT(*) as count FROM hair_types");
$count = $checkStmt->fetch_assoc()['count'];
$checkStmt->close();

?>
<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-cog"></i> Database Setup</h1>
        <p>Initialize the ManeFlow database with essential data</p>
    </div>
    
    <?php if ($count == 0): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Setting up ManeFlow database...</strong>
            </div>
        </div>
        
        <?php
        // Insert Hair Types
        $hairTypes = [
            ['1A', 'Type 1A - Straight Fine', 'straight', 'Straight, fine hair with no curl pattern', 'Very fine, soft, and silky'],
            ['1B', 'Type 1B - Straight Medium', 'straight', 'Straight, medium-textured hair', 'Slightly thicker than 1A, still straight'],
            ['1C', 'Type 1C - Straight Coarse', 'straight', 'Straight, coarse hair', 'Thick and coarse, resistant to curling'],
            ['2A', 'Type 2A - Wavy Fine', 'wavy', 'Fine, wavy hair with loose S-shaped waves', 'Gentle waves, easy to style'],
            ['2B', 'Type 2B - Wavy Medium', 'wavy', 'Medium-textured wavy hair', 'More defined waves than 2A'],
            ['2C', 'Type 2C - Wavy Coarse', 'wavy', 'Coarse, wavy hair with defined waves', 'Thick waves, can be frizzy'],
            ['3A', 'Type 3A - Curly Loose', 'curly', 'Loose, springy curls', 'Large, defined curls'],
            ['3B', 'Type 3B - Curly Medium', 'curly', 'Medium, bouncy curls', 'Tight, springy ringlets'],
            ['3C', 'Type 3C - Curly Tight', 'curly', 'Tight, corkscrew curls', 'Small, tight curls'],
            ['4A', 'Type 4A - Coily Soft', 'coily', 'Soft, tightly coiled hair', 'Defined S-pattern coils'],
            ['4B', 'Type 4B - Coily Zigzag', 'coily', 'Zigzag pattern coils', 'Less defined, more cotton-like'],
            ['4C', 'Type 4C - Coily Tight', 'coily', 'Tightly coiled, very fragile', 'Tightest curl pattern, most fragile']
        ];
        
        $insertHairType = $conn->prepare("INSERT INTO hair_types (type_code, type_name, category, description, characteristics) VALUES (?, ?, ?, ?, ?)");
        foreach ($hairTypes as $type) {
            $insertHairType->bind_param("sssss", $type[0], $type[1], $type[2], $type[3], $type[4]);
            $insertHairType->execute();
        }
        $insertHairType->close();
        ?>
        
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong>✓ Hair types inserted:</strong> <?php echo count($hairTypes); ?> types
            </div>
        </div>
        
        <?php
        // Insert Hair Concerns
        $concerns = [
            ['Hair Loss', 'Excessive hair shedding or thinning', 'moderate'],
            ['Breakage', 'Hair breaking off at various lengths', 'moderate'],
            ['Dryness', 'Lack of moisture in hair strands', 'mild'],
            ['Frizz', 'Unruly, frizzy hair texture', 'mild'],
            ['Split Ends', 'Damaged hair ends splitting', 'mild'],
            ['Scalp Issues', 'Dandruff, itching, or scalp irritation', 'moderate'],
            ['Slow Growth', 'Hair not growing at expected rate', 'moderate'],
            ['Thinning', 'Hair becoming less dense over time', 'severe'],
            ['Damage', 'Overall hair damage from heat or chemicals', 'moderate'],
            ['Lack of Shine', 'Dull, lifeless hair appearance', 'mild']
        ];
        
        $insertConcern = $conn->prepare("INSERT INTO hair_concerns (concern_name, description, severity_level) VALUES (?, ?, ?)");
        foreach ($concerns as $concern) {
            $insertConcern->bind_param("sss", $concern[0], $concern[1], $concern[2]);
            $insertConcern->execute();
        }
        $insertConcern->close();
        ?>
        
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong>✓ Hair concerns inserted:</strong> <?php echo count($concerns); ?> concerns
            </div>
        </div>
        
        <?php
        // Insert Sample Growth Methods
        $methods = [
            ['Scalp Massage', 'massage', 'Stimulate blood flow to promote hair growth', 'Daily', '5-10 minutes', 'beginner', 'Improved circulation, potential growth boost', 'Use fingertips to gently massage scalp in circular motions for 5-10 minutes daily'],
            ['Protective Styling', 'protective_styling', 'Styles that protect ends from damage', 'Weekly', 'Varies', 'intermediate', 'Reduced breakage, length retention', 'Braid, twist, or bun hair to protect ends. Keep styles for 1-2 weeks'],
            ['Deep Conditioning', 'treatment', 'Intensive moisture treatment', 'Weekly', '30-60 minutes', 'beginner', 'Improved moisture, reduced breakage', 'Apply conditioner, cover with cap, apply heat for 15-30 min, then rinse'],
            ['Low Manipulation', 'lifestyle', 'Minimize handling and styling', 'Daily', 'Ongoing', 'beginner', 'Less breakage, length retention', 'Avoid daily styling, use gentle techniques, protective styles'],
            ['Regular Trims', 'trimming', 'Remove split ends regularly', 'Every 8-12 weeks', '15 minutes', 'beginner', 'Healthy ends, prevent further damage', 'Trim 1/4 to 1/2 inch every 8-12 weeks to maintain healthy ends'],
            ['Hot Oil Treatment', 'treatment', 'Nourish hair with warm oils', 'Bi-weekly', '30-45 minutes', 'beginner', 'Improved moisture and shine', 'Warm oil (coconut, olive, or castor), apply to hair, cover for 30 min, rinse']
        ];
        
        $insertMethod = $conn->prepare("INSERT INTO growth_methods (method_name, category, description, frequency, duration, difficulty_level, expected_results, instructions) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        foreach ($methods as $method) {
            $insertMethod->bind_param("ssssssss", $method[0], $method[1], $method[2], $method[3], $method[4], $method[5], $method[6], $method[7]);
            $insertMethod->execute();
        }
        $insertMethod->close();
        ?>
        
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong>✓ Growth methods inserted:</strong> <?php echo count($methods); ?> methods
            </div>
        </div>
        
        <div class="alert alert-success" style="border-left: 4px solid #28A745;">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong>Setup Complete!</strong>
                <p>The database has been initialized with all essential data. You can now use the application.</p>
                <a href="index.php" class="btn btn-primary">
                    <i class="fas fa-home"></i> Go to Homepage
                </a>
            </div>
        </div>
        
    <?php else: ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Database Already Set Up!</strong>
                <p>Hair types in database: <strong><?php echo $count; ?></strong></p>
                <p>The database is ready to use.</p>
                <a href="index.php" class="btn btn-primary">
                    <i class="fas fa-home"></i> Go to Homepage
                </a>
            </div>
        </div>
    <?php endif; ?>
</div>

<?php
$conn->close();
include 'includes/footer.php';
?>

