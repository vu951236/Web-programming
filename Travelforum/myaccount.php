<?php
session_start();
$config = include('config.php');

if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

$message = ''; // Biến để lưu thông báo

try {
    // Tạo kết nối đến cơ sở dữ liệu
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Kiểm tra nếu người dùng đã đăng nhập
    if (!isset($_SESSION['user_id'])) {
        die("Bạn cần đăng nhập để cập nhật thông tin.");
    }

    // Kiểm tra nếu biểu mẫu được gửi
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Lấy dữ liệu từ biểu mẫu
        $fullname = $_POST['fullname'] ?? null; // Sử dụng null nếu không có dữ liệu
        $email = $_POST['email'] ?? null;
        $password = $_POST['password'] ?? null;

        // Tạo một mảng để lưu các cặp khóa-giá trị cho tham số
        $params = [];
        $sql = "UPDATE users SET";

        // Kiểm tra và thêm các trường cần cập nhật vào câu truy vấn
        if ($fullname) {
            $sql .= " fullname = :fullname,";
            $params[':fullname'] = $fullname; // Thêm tham số fullname
        }
        if ($email) {
            $sql .= " email = :email,";
            $params[':email'] = $email; // Thêm tham số email
        }
        if ($password) {
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            $sql .= " password = :password,";
            $params[':password'] = $hashedPassword; // Thêm tham số password
        }

        // Kiểm tra xem có trường nào được cập nhật hay không
        if (count($params) > 0) {
            // Xóa dấu phẩy cuối cùng nếu có
            $sql = rtrim($sql, ',') . " WHERE id = :id";
            $params[':id'] = $_SESSION['user_id']; // Thêm tham số id

            // Chuẩn bị và thực thi câu truy vấn
            $stmt = $pdo->prepare($sql);
            
            // Bind các tham số
            foreach ($params as $key => $value) {
                $stmt->bindValue($key, $value);
            }

            // Thực thi câu truy vấn
            $stmt->execute();

            $message = "Cập nhật thành công!"; // Lưu thông báo thành công
        } else {
            $message = "Không có thông tin nào để cập nhật."; // Lưu thông báo không có thông tin
        }
    }
} catch (PDOException $e) {
    $message = "Lỗi kết nối: " . $e->getMessage(); // Lưu thông báo lỗi
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/myaccount.css">
    <style>
        .hidden { display: none; }
    </style>
</head>
<body>
    <div id="header">
        <div class="header-logo">Logo</div>
        <div class="header-search">
            <form action="search.php" method="GET">
                <input type="text" name="keyword" placeholder="Tìm kiếm..." required />
                <button class="btn-header" type="submit">Tìm kiếm</button>
            </form>
        </div>
        <nav class="header-nav">
            <a href="post.php">Bài viết</a>
            <a href="explore.php">Khám phá</a>
            <a href="aboutus.html">Về chúng tôi</a>
        </nav>
        <div class="header-account">
            <?php
            // Kiểm tra xem có username trong session không
            if (isset($_SESSION['username'])) {
                // Nếu có username, hiển thị nút Đăng xuất
                echo '<a class="btn-account" href="logout.php">Đăng xuất</a>';
            } else {
                // Nếu không có username, hiển thị nút Đăng nhập và Đăng ký
                echo '<a class="btn-account activee" href="login.php">Đăng nhập</a>';
                echo '<a class="btn-account" href="register.php">Đăng ký</a>';
            }
            ?>
        </div>
    </div>


    <div id="main" class="d-flex">
        <nav class="aside-nav">
            <a href="#" class="new-item" onclick="showSection('accountSettings')">Cài đặt tài khoản</a>
            <a href="#" class="new-item" onclick="showSection('myPosts')">Bài viết của tôi</a>
            <a href="#" class="new-item" onclick="showSection('addPost')">Thêm bài viết</a>
            <a href="#" class="new-item" onclick="showSection('policyContent')">Chính sách sử dụng</a> 
            <a href="#" class="new-item" onclick="showSection('deleteAccount')">Xóa tài khoản</a>
        </nav>

        <div class="content p-4">
            <div id="accountSettings" class="section">
                <h2 class="mb-4">Sửa thông tin</h2>
                <form action="myaccount.php" method="post" class="d-flex flex-column">
                    <div class="d-flex align-items-start mb-3">
                        <div class="left-section flex-grow-1">
                            <div class="mb-3">
                                <label for="fullname" class="form-label">Tên người dùng</label>
                                <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Nhập tên người dùng" >
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email" >
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu mới</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu mới">
                            </div>
                            <div class="mb-3">
                                <label for="confirm_password" class="form-label">Xác nhận mật khẩu</label>
                                <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Xác nhận mật khẩu mới">
                            </div>
                        </div>
                        <div class="right-section ms-3 text-center">
                            <div class="image-container mb-2">
                                <img src="./asset/img/user_image.png" alt="User Image" class="profile-image">
                            </div>
                            <div class="upload-container">
                                <label for="profile_picture" class="custom-file-upload btn btn-secondary">Chọn ảnh</label>
                                <input type="file" id="profile_picture" name="profile_picture" accept="image/*" class="hidden-input">
                            </div>
                            <small class="form-text text-muted">Chọn ảnh để làm ảnh đại diện của bạn (JPEG, PNG).</small>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
                    <?php if ($message): ?>
                        <div class="text-danger"><?php echo htmlspecialchars($message); ?></div>
                    <?php endif; ?>
                </form>
            </div>

            <!-- Nội dung Bài viết của tôi -->
            <div id="myPosts" class="section hidden">
                <h2 class="mb-4">Bài viết của tôi</h2>
                <div id="postsContainer">
                    <div class="post">
                        <h3>Tên bài viết 1</h3>
                        <p>Mô tả ngắn gọn về bài viết 1...</p>
                    </div>
                    <div class="post">
                        <h3>Tên bài viết 2</h3>
                        <p>Mô tả ngắn gọn về bài viết 2...</p>
                    </div>
                </div>
            </div>

            <!-- Nội dung Thêm bài viết -->
            <div id="addPost" class="section hidden">
                <div class="container">
                    <h2>Thêm Bài Viết</h2>
                    <details>
                        <summary class="btn btn-primary">Mở Thêm Bài Viết</summary>
                        <div class="create-post">
                            <form action="your_post_submission_endpoint" method="POST" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <label for="postTitle" class="form-label">Tiêu đề</label>
                                    <input type="text" class="form-control" id="postTitle" name="postTitle" required>
                                </div>
                                <div class="mb-3">
                                    <label for="postContent" class="form-label">Nội dung</label>
                                    <textarea class="form-control" id="postContent" name="postContent" rows="4" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="postImage" class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" id="postImage" name="postImage">
                                </div>
                                <button type="submit" class="btn btn-success">Tạo Bài Viết</button>
                            </form>
                        </div>
                    </details>
                </div>
            </div>

            <!-- Nội dung Chính sách sử dụng -->
            <div id="policyContent" class="section hidden">
                <h2>Chính sách sử dụng</h2>
                <div id="policyText">
                    <!-- Nội dung chính sách sẽ được tải vào đây -->
                </div>
            </div>

            <!-- Nội dung Xóa tài khoản -->
            <div id="deleteAccount" class="section hidden">
                <h2 class="mb-4">Xóa tài khoản</h2>
                <p>Bạn chắc chắn muốn xóa tài khoản của mình? Hành động này không thể hoàn tác.</p>
                <button class="btn btn-danger">Xóa tài khoản</button>
            </div>

        </div>
    </div>

    <div id="footer">
        <div class="footer-container">
            <div class="footer-section">
                <h3>Liên hệ</h3>
                <p>Email: contact@example.com</p>
                <p>Điện thoại: +123 456 7890</p>
            </div>
            <div class="footer-section">
                <h3>Thông tin</h3>
                <ul>
                    <li><a href="./aboutus.html">Về chúng tôi</a></li>
                    <li><a href="./policy.html">Chính sách bảo mật</a></li>
                    <li><a href="./policy.html">Điều khoản sử dụng</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Liên kết hữu ích</h3>
                <ul>
                    <li><a href="#faq">Câu hỏi thường gặp</a></li>
                    <li><a href="#support">Hỗ trợ</a></li>
                    <li><a href="#forum">Diễn đàn</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Mạng xã hội</h3>
                <div class="social-icons">
                    <a href="https://www.threads.net/@hvdien04" target="_blank"><i class="fa-brands fa-square-threads"></i></a>
                    <a href="https://www.instagram.com/hvdien04/" target="_blank"><i class="fa-brands fa-square-instagram"></i></a>
                    <a href="https://www.facebook.com/HoangVanDien.Profile" target="_blank"><i class="fa-brands fa-facebook"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 Diễn đàn của chúng tôi. Bảo lưu mọi quyền.</p>
        </div>
    </div>
    
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script>
        function loadPolicyContent() {
            fetch('./policy.html')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    // Tạo một phần tử tạm thời để phân tích cú pháp nội dung
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = data;

                    // Xóa header và footer khỏi nội dung
                    const header = tempDiv.querySelector('#header'); 
                    const footer = tempDiv.querySelector('#footer'); 
                    
                    // Xóa header và footer nếu tồn tại
                    if (header) {
                        header.remove();
                    }
                    if (footer) {
                        footer.remove();
                    }

                    // Chèn nội dung còn lại vào div
                    document.getElementById('policyText').innerHTML = tempDiv.innerHTML;
                })
                .catch(error => {
                    console.error('Có lỗi xảy ra khi tải nội dung:', error);
                    document.getElementById('policyText').innerHTML = '<p>Có lỗi xảy ra. Vui lòng thử lại sau.</p>';
                });
        }

        // Gọi hàm tải nội dung khi trang được tải
        document.addEventListener('DOMContentLoaded', loadPolicyContent);


        // Cập nhật hàm hiển thị phần nội dung tương ứng
        function showSection(sectionId) {
            // Ẩn tất cả các phần nội dung
            document.querySelectorAll('.section').forEach(function(section) {
                section.classList.add('hidden');
            });
            
            // Hiển thị phần nội dung được chọn
            const selectedSection = document.getElementById(sectionId);
            selectedSection.classList.remove('hidden');

            // Tải nội dung chính sách khi nhấn vào liên kết
            if (sectionId === 'policyContent') {
                loadPolicyContent();
            }
        }

        // Hiển thị phần cài đặt tài khoản mặc định khi vào trang
        window.onload = function() {
            showSection('accountSettings');
        };

    </script>
</body>
</html>
