<?php
session_start();
// Kiểm tra xem người dùng đã đăng nhập chưa
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php"); // Chuyển hướng về trang đăng nhập nếu chưa đăng nhập
    exit;
}

// Kết nối đến cơ sở dữ liệu
require 'db_connection.php'; // Thay đổi đường dẫn nếu cần
$user_id = $_SESSION['user_id'];

// Lấy thông tin người dùng từ cơ sở dữ liệu
$query = "SELECT username, email, avatar FROM users WHERE id = :id";
$stmt = $conn->prepare($query);
$stmt->bindValue(':id', $user_id, PDO::PARAM_INT); // Sử dụng bindValue với kiểu dữ liệu INT
$stmt->execute();
$user = $stmt->fetch(PDO::FETCH_ASSOC); // Lấy thông tin người dùng

if (!$user) {
    // Nếu không tìm thấy người dùng, có thể chuyển hướng hoặc hiển thị thông báo lỗi
    echo "Người dùng không tồn tại.";
    exit;
}

$conn = null; // Đóng kết nối
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Cá Nhân</title>
    <link rel="stylesheet" href="styles.css"> <!-- Thêm đường dẫn CSS nếu cần -->
</head>
<body>
    <header>
        <h1>Thông tin cá nhân</h1>
    </header>
    <main>
        <div class="profile-container">
            <h2>Tên người dùng: <?php echo htmlspecialchars($user['username']); ?></h2>
            <img src="<?php echo htmlspecialchars($user['avatar']); ?>" alt="Avatar" class="avatar">
            <p>Email: <?php echo htmlspecialchars($user['email']); ?></p>
        </div>
    </main>
</body>
</html>
Footer
