<?php
// Bao gồm tệp cấu hình
$config = include('config.php');

// Kiểm tra xem có thông tin cấu hình cơ sở dữ liệu không
if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    // Khởi tạo kết nối PDO
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Lấy thời gian hiện tại
    $current_time = date('Y-m-d H:i:s');

    // Xóa các mã admin đã hết hạn
    $sql = "DELETE FROM admincode WHERE expiration_time < :current_time";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([':current_time' => $current_time]);

    echo "Admin codes expired before $current_time have been deleted.\n";

} catch (PDOException $e) {
    echo "Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage();
}
