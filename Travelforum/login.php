<?php
session_start();

$config = include('config.php');
// Kết nối cơ sở dữ liệu
$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Kết nối đến cơ sở dữ liệu thất bại: " . $e->getMessage());
}

// Khởi tạo biến thông báo lỗi
$error_message = null;

// Xử lý đăng nhập
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['username']) && !empty($_POST['password'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];

    try {
        // Truy vấn người dùng
        $stmt = $conn->prepare("SELECT * FROM users WHERE username = :username");
        $stmt->execute(['username' => $username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $current_time = new DateTime();
            $banned_until = $user['banned_until'] ? new DateTime($user['banned_until']) : null;
        
            if ($banned_until && $banned_until > $current_time) {
                $error_message = "Bạn đã bị cấm đến " . $banned_until->format('Y-m-d H:i:s') . ".";
            } elseif (password_verify($password, $user['password'])) {
                // Đăng nhập thành công
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['username'] = $user['username'];
                $_SESSION['isadmin'] = $user['isadmin'];
                header("Location: index.php");
                exit;
            } else {
                $error_message = "Sai mật khẩu. Vui lòng thử lại.";
            }
        } else {
            $error_message = "Tài khoản không tồn tại.";
        }
    } catch (PDOException $e) {
        $error_message = "Lỗi khi thực hiện truy vấn: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Đăng Nhập</title>
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
                window.location.href = "login.php";
            }, 300); // Đợi 500ms trước khi chuyển trang
        }
    
        function showRegister() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "register.php";
            }, 300); // Đợi 500ms trước khi chuyển trang
        }
    
        // Khi tải trang, thêm lớp 'show' cho body
        document.addEventListener("DOMContentLoaded", function() {
            document.body.classList.add('show');
        });
    </script>
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

    <div class="container-fluid" style="height: 100vh;">
        <div class="row">
            <div class="col-md-6 d-flex justify-content-center align-items-center">
                <div class="login-form text-center">
                    <h2>Chào mừng bạn quay trở lại !</h2>
                    <br>
                    <form method="post" action="login.php">
                        <div class="mb-3">
                            <input type="username" name="username" class="form-control" placeholder="Nhập username" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
                        </div>
                        <p class="mt-3" style="text-align: right"><a href="forgetpass.php">Quên mật khẩu</a></p>
                        <button type="submit" class="btn btn-primary">Đăng nhập</button>
                    </form>
                    <?php if ($error_message): ?>
                        <p class="mt-3 text-danger"><?= htmlspecialchars($error_message) ?></p>
                    <?php endif; ?>
                    <p class="mt-3">Chưa có tài khoản? <a href="register.php">Đăng ký</a></p>
                </div>
            </div>
            <div class="col-md-6 d-flex align-items-center">
                <img src="./asset/img/login_register/login.jpg" alt="Login" class="img-fluid">
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
