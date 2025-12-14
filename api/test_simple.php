<?php
// Ultra-simple test to see if PHP even executes
header('Content-Type: application/json');
echo json_encode(['success' => true, 'message' => 'PHP works!', 'test' => 'basic']);
