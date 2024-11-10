<?php
session_start(); // Bắt đầu phiên

// Load file cấu hình
$config = include('config.php');

// Kết nối cơ sở dữ liệu
$dbConfig = $config['db'];
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Kết nối đến cơ sở dữ liệu thất bại: " . $e->getMessage());
}

// Hủy bỏ tất cả dữ liệu phiên
if (isset($_SESSION)) {
    session_destroy(); // Hủy bỏ session nếu nó tồn tại
    session_unset();
}

// Chuyển hướng đến trang chính hoặc trang mong muốn
header("Location: index.php");
exit();
?>
