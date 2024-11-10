<?php
session_start();

$config = include('config.php');

// Kiểm tra xem form có được gửi hay không
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy thông tin từ session
    $username = $_SESSION['resetUsername'] ?? null;
    $email = $_SESSION['resetEmail'] ?? null;
    $newPassword = $_POST['newPassword'] ?? null;

    $errorMessage = null;
    $successMessage = null;

    // Kiểm tra thông tin đầu vào
    if ($email === null || $newPassword === null || empty($newPassword)) {
        $errorMessage = "Vui lòng nhập đầy đủ thông tin.";
        // Hiển thị thông báo lỗi
        echo "<script>alert('$errorMessage');</script>";
    } else {
        // Kết nối cơ sở dữ liệu
        $dbConfig = $config['db'];
        $dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";
        try {
            $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // Băm mật khẩu mới
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            $sql = "UPDATE users SET password = :password WHERE username = :username AND email = :email";
            // Sử dụng biến $conn thay vì $pdo
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':password', $hashedPassword);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':email', $email);

            $rowsUpdated = $stmt->execute();

            if ($rowsUpdated > 0) {
                $successMessage = "Mật khẩu đã được cập nhật thành công!";
                echo "<script>alert('$successMessage');</script>";
                header("Location: Login.php"); // Chuyển hướng đến trang đăng nhập
                exit;
            } else {
                $errorMessage = "Không tìm thấy người dùng với email đã cho.";
                echo "<script>alert('$errorMessage');</script>";
            }
        } catch (PDOException $e) {
            $errorMessage = "Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage();
            echo "<script>alert('$errorMessage');</script>";
        }
    }
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/register.css"> 
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script>
        function showLogin() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "login.html";
            }, 300); // Đợi 500ms trước khi chuyển trang
        }
    
        function showRegister() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "register.html";
            }, 300); // Đợi 500ms trước khi chuyển trang
        }
    
        // Khi tải trang, thêm lớp 'show' cho body
        document.addEventListener("DOMContentLoaded", function() {
            document.body.classList.add('show');
        });
    </script>
    <style>
        /* CSS để điều chỉnh khoảng cách */
        .forgot-password-form {
            margin-top: 15px; /* Giảm khoảng cách giữa form và hình ảnh */
        }

        img {
            margin-bottom: 10px; /* Giảm khoảng cách giữa hình ảnh và form */
        }
    </style>
    <script>
        function validatePassword() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const errorMessage = document.getElementById("error-message");

            if (password !== confirmPassword) {
                errorMessage.textContent = "Xác nhận mật khẩu không trùng khớp.";
                return false; // Ngăn gửi form nếu mật khẩu không trùng
            }

            errorMessage.textContent = ""; // Xóa thông báo lỗi nếu trùng khớp
            return true;
        }
    </script>
</head>
<body class="fade">
    <?php
        include 'header.php'; 
    ?>
    <div class="container-fluid d-flex flex-column justify-content-center align-items-center" style="height: 100vh;">
        <img src="./asset/img/login_register/resetpass.png" alt="Reset Password" class="img-fluid mb-4" style="max-width: 20%; height: auto;">
        <div class="forgot-password-form text-center">
            <h2>Hãy nhập mật khẩu mới</h2>
            <br>
            <form action="updatepass.php" method="POST" onsubmit="return validatePassword()">
                <div class="mb-3">
                    <input type="password" id="password" name="newPassword" class="form-control" placeholder="Mật khẩu" required><br>
                    <input type="password" id="confirmPassword" class="form-control" placeholder="Xác nhận lại mật khẩu" required>
                    <div id="error-message" class="error-message" style="color: red; text-align: right;"></div><br> 
                </div>
                <button type="submit" class="btn btn-primary">Xác nhận</button>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
