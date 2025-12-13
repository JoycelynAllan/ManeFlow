<?php
require_once 'config/db.php';

session_start();

// Clear remember me cookie
if (isset($_COOKIE['remember_token'])) {
    setcookie('remember_token', '', time() - 3600, '/', '', true, true);
}

session_destroy();
header('Location: index.php');
exit;
?>

