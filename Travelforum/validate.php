<?php
session_start();

// Xử lý khi form được submit
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $resetCode = $_SESSION['resetCode']; // Mã xác nhận lưu trong session
    $userInputCode = trim($_POST['resetCode']); // Mã xác nhận do người dùng nhập

    $errorMessage = null;
    $successMessage = null;

    // Kiểm tra mã xác nhận
    if ($resetCode === null || $resetCode !== $userInputCode) {
        $errorMessage = "Mã xác nhận không chính xác.";
    } else {
        // Nếu mã xác nhận đúng, chuyển hướng đến trang nhập mật khẩu mới
        $successMessage = "Mã xác nhận thành công! Vui lòng nhập mật khẩu mới.";
        header("Location: updatepass.php"); // Chuyển hướng đến trang nhập mật khẩu mới
        exit;
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
            }, 300);
        }

        function showRegister() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "register.html";
            }, 300);
        }

        // Khi tải trang, thêm lớp 'show' cho body
        document.addEventListener("DOMContentLoaded", function() {
            document.body.classList.add('show');
        });
    </script>
    <style>
        .forgot-password-form {
            margin-top: 15px; 
        }

        img {
            margin-bottom: 10px; 
        }
    </style>
</head>
<body class="fade">
    <div id="header">
        <div class="header-logo">
            Logo
        </div>
        <div class="header-account">
            <a class="btn-account" href="./login.html">Đăng nhập</a>
            <a class="btn-account activee" href="./register.html">Đăng ký</a>
        </div>
    </div>
    <div class="container-fluid d-flex flex-column justify-content-center align-items-center" style="height: 100vh;">
        <img src="./asset/img/login_register/resetpass.png" alt="Reset Password" class="img-fluid mb-4" style="max-width: 20%; height: auto;">
        <div class="forgot-password-form text-center">
            <h2>Hãy nhập mã xác thực</h2>
            <br>
            <?php if (isset($errorMessage)): ?>
                <div class="alert alert-danger"><?php echo htmlspecialchars($errorMessage); ?></div>
            <?php endif; ?>
            <?php if (isset($successMessage)): ?>
                <div class="alert alert-success"><?php echo htmlspecialchars($successMessage); ?></div>
            <?php endif; ?>
            <form action="validate.php" method="POST">
                <div class="mb-3">
                    <input type="text" name="resetCode" class="form-control" placeholder="Nhập mã xác thực gửi qua email" required>
                </div>
                <button type="submit" class="btn btn-primary">Xác nhận</button>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
