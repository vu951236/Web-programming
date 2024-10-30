<?php
session_start();

require_once '../vendor/autoload.php';

$config = include('config.php');


// Xử lý khi form được submit
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username']);
    $email = trim($_POST['email']);
    $error_message = null;
    $success_message = null;

    // Kiểm tra đầu vào
    if (empty($username) || empty($email)) {
        $error_message = "Vui lòng nhập tên người dùng và email.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "Địa chỉ email không hợp lệ.";
    } else {
        // Kết nối cơ sở dữ liệu
        $dbConfig = $config['db'];
        $dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";
        try {
            $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // Kiểm tra username và email
            $stmt = $conn->prepare("SELECT * FROM users WHERE username = :username AND email = :email");
            $stmt->execute(['username' => $username, 'email' => $email]);
            
            if ($stmt->rowCount() == 0) {
                $error_message = "Username hoặc email không đúng.";
            } else {
                // Tạo mã xác nhận ngẫu nhiên
                $resetCode = substr(uniqid(), -6);
                $_SESSION['resetUsername'] = $username;
                $_SESSION['resetCode'] = $resetCode;
                $_SESSION['resetEmail'] = $email;

                // Gửi mã xác nhận qua email
                $emailConfig = $config['email'];
                $to = $email;
                $subject = "Mã xác nhận đặt lại mật khẩu";
                $message = "Mã xác nhận của bạn là: $resetCode";
                $headers = [
                    'From' => $emailConfig['username'],
                    'Reply-To' => $emailConfig['username'],
                    'X-Mailer' => 'PHP/' . phpversion()
                ];

                // Thiết lập cấu hình gửi email
                $transport = (new Swift_SmtpTransport($emailConfig['smtp_host'], $emailConfig['smtp_port']))
                    ->setUsername($emailConfig['username'])
                    ->setPassword($emailConfig['password'])
                    ->setEncryption('tls');

                $mailer = new Swift_Mailer($transport);
                $swiftMessage = (new Swift_Message($subject))
                    ->setFrom([$emailConfig['username'] => 'Your App'])
                    ->setTo([$to])
                    ->setBody($message);

                if ($mailer->send($swiftMessage)) {
                    $success_message = "Mã xác nhận đã được gửi tới email của bạn. Vui lòng kiểm tra.";
                    $_SESSION['success_message'] = $success_message;
                    header("Location: validate.php");
                    exit;
                } else {
                    $error_message = "Gửi email thất bại. Vui lòng thử lại sau.";
                }
            }
        } catch (PDOException $e) {
            $error_message = "Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage();
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/login.css"> 
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
    
</head>
<body class="fade">
    <div id="header">
        <div class="header-logo">
            Logo
        </div>
        <div class="header-account">
            <a class="btn-account" href="./login.php">Đăng nhập</a>
            <a class="btn-account activee" href="./register.php">Đăng ký</a>
        </div>
    </div>
    <div class="container-fluid d-flex flex-column justify-content-center align-items-center" style="height: 100vh;">
        <img src="./asset/img/login_register/forgotpass.png" alt="Forgot Password" class="img-fluid mb-4" style="max-width: 20%; height: auto;">
        <div class="forgot-password-form text-center">
            <h2>Nhập thông tin để nhận mã xác thực</h2>
            <br>
            <?php if (isset($error_message)): ?>
                <div class="alert alert-danger"><?php echo htmlspecialchars($error_message); ?></div>
            <?php endif; ?>
            <?php if (isset($success_message)): ?>
                <div class="alert alert-success"><?php echo htmlspecialchars($success_message); ?></div>
            <?php endif; ?>
            <form action="forgetpass.php" method="POST">
                <div class="mb-3">
                    <input type="text" name="username" class="form-control" placeholder="Tên người dùng" required>
                </div>
                <div class="mb-3">
                    <input type="email" name="email" class="form-control" placeholder="Email" required>
                </div>
                <button type="submit" class="btn btn-primary">Gửi</button>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
