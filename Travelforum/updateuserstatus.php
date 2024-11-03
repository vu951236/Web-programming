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
    // Tạo kết nối đến cơ sở dữ liệu
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Lấy thời gian hiện tại
    $currentDateTime = new DateTime();

    // Cập nhật trạng thái người dùng
    // Xóa thời gian cấm và cập nhật trạng thái thành exemplary nếu thời gian hiện tại lớn hơn thời gian cấm
    $updateQuery = "UPDATE users SET status = 'warned', banned_until = NULL 
                    WHERE status = 'banned' AND banned_until < :current_time";
    $updateStmt = $pdo->prepare($updateQuery);
    $updateStmt->execute([':current_time' => $currentDateTime->format('Y-m-d H:i:s')]);


    // Kiểm tra các người dùng có trạng thái 'warned' để chuyển sang 'exemplary' khi hết thời gian
    $updateQuery3 = "UPDATE users 
    SET status = 'exemplary' 
    WHERE status = 'warned' 
    AND (warned_until < :current_time OR warned_until IS NULL)";

    $updateStmt3 = $pdo->prepare($updateQuery3);
    $updateStmt3->execute([':current_time' => $currentDateTime->format('Y-m-d H:i:s')]);

} catch (PDOException $e) {
    // Nếu có lỗi xảy ra, lưu thông báo lỗi
    error_log("Kết nối thất bại: " . $e->getMessage());
}
?>
