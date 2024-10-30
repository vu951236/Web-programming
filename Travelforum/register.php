<?php
session_start();
$error_message = '';

$config = include('config.php');
// Kết nối cơ sở dữ liệu
$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

// Kiểm tra xem form đã được gửi hay chưa
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Kết nối đến cơ sở dữ liệu
    try {
        $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        $error_message = "Không thể kết nối đến cơ sở dữ liệu: " . $e->getMessage();
    }

    // Lấy dữ liệu từ form
    $email = $_POST['email'] ?? '';
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    $confirmPassword = $_POST['confirmPassword'] ?? '';
    $fullname = $_POST['fullname'] ?? '';
    $address = $_POST['address'] ?? '';
    $admin_code = $_POST['admin_code'] ?? '';
    $is_admin = 0;

    // Kiểm tra tính hợp lệ
    if (empty($username) || strlen($username) < 6 || strlen($username) > 12) {
        $error_message = "Tên đăng nhập phải từ 6-12 ký tự.";
    } elseif (empty($password) || strlen($password) < 6 || strlen($password) > 12) {
        $error_message = "Mật khẩu phải từ 6-12 ký tự.";
    } elseif ($password !== $confirmPassword) {
        $error_message = "Mật khẩu xác nhận không trùng khớp.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "Email không hợp lệ.";
    } elseif (empty($fullname)) {
        $error_message = "Họ và tên không được để trống.";
    } elseif (empty($address)) {
        $error_message = "Địa chỉ không được để trống.";
    }

    // Kiểm tra tính hợp lệ và email đã tồn tại
if (!$error_message) {
    try {
        // Kiểm tra tên người dùng đã tồn tại chưa
        $stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
        $stmt->execute([$username]);
        if ($stmt->fetch()) {
            $error_message = "Tên người dùng đã tồn tại.";
        }

        // Kiểm tra email đã tồn tại chưa
        $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            $error_message = "Email này đã được sử dụng.";
        }
    } catch (PDOException $e) {
        $error_message = "Lỗi khi kiểm tra tên người dùng hoặc email: " . $e->getMessage();
    }
}


    // Kiểm tra mã admin nếu có
    if (!$error_message && $admin_code) {
        try {
            $stmt = $conn->prepare("SELECT * FROM Idadmin WHERE id = ?");
            $stmt->execute([$admin_code]);
            if ($stmt->fetch()) {
                $is_admin = 1;
            }
        } catch (PDOException $e) {
            $error_message = "Lỗi khi kiểm tra mã admin: " . $e->getMessage();
        }
    }

    // Tiến hành đăng ký tài khoản
    if (!$error_message) {
        try {
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("INSERT INTO users (username, password, email, fullname, address, isadmin) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$username, $hashed_password, $email, $fullname, $address, $is_admin]);

            // Xóa mã admin nếu người dùng đã sử dụng
            if ($is_admin) {
                $stmt = $conn->prepare("DELETE FROM Idadmin WHERE id = ?");
                $stmt->execute([$admin_code]);
            }

            header("Location: login.php"); // Chuyển hướng đến trang đăng nhập
            exit;
        } catch (PDOException $e) {
            $error_message = "Lỗi khi tạo tài khoản: " . $e->getMessage();
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <link rel="stylesheet" href="./asset/css/register.css"> 
    <script>
        function showLogin() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "login.html";
            }, 500); // Đợi 500ms trước khi chuyển trang
        }
    
        function showRegister() {
            document.body.classList.remove('show');
            setTimeout(function() {
                window.location.href = "register.html";
            }, 500); // Đợi 500ms trước khi chuyển trang
        }
    
        // Khi tải trang, thêm lớp 'show' cho body
        document.addEventListener("DOMContentLoaded", function() {
            document.body.classList.add('show');
        });
    </script>
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
    <div id="header">
        <div class="header-logo">
            Logo
        </div>
        <div class="header-account">
            <a class="btn-account activee" href="./login.php">Đăng nhập</a>
            <a class="btn-account" href="./register.php">Đăng ký</a>
        </div>
    </div>

    <div class="container-fluid" style="height: 100vh;">
        <div class="row">
            <div class="col-md-6 d-flex align-items-center">
                <img src="./asset/img/login_register/register.jpg" alt="Register" class="img-fluid" >
            </div>
            <div class="col-md-6 d-flex justify-content-center align-items-center">
                <div class="register-form text-center">
                    <h2>Xin chào, thành viên mới!</h2>
                    <br>
                    <form method="post" action="register.php" onsubmit="return validatePassword()">
                        <div class="mb-3">
                            <input type="email" class="form-control" name="email" placeholder="Nhập Email" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="username" placeholder="Tên đăng nhập" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="fullname" placeholder="Họ và tên" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="address" placeholder="Địa chỉ" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="admin_code" placeholder="Mã admin">
                        </div>
                        <button type="submit" class="btn btn-primary">Đăng ký</button>
                        <div id="error-message" class="error-message" style="color: red; text-align: right;"><?= $error_message ?></div>
                    </form>
                    <p class="mt-3">Đã có tài khoản? <a href="login.php" onclick="showLogin()">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
