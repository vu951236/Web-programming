<?php
// Bắt đầu phiên
session_start();

// Kiểm tra xem có từ khóa tìm kiếm không
$locations = [];
$posts = []; // Khởi tạo biến $posts để sử dụng sau này
if (isset($_GET['keyword'])) {
    $keyword = $_GET['keyword'];

    // Cấu hình kết nối cơ sở dữ liệu
    $config = include('config.php');

    if (!isset($config['db'])) {
        die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
    }

    $dbConfig = $config['db'];
    $dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

    try {
        $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        die("Kết nối đến cơ sở dữ liệu thất bại: " . $e->getMessage());
    }

    // Tìm kiếm tỉnh thành phù hợp
    $location_sql = "SELECT name, location, information, image FROM locationdetail WHERE name ILIKE ? LIMIT 20";
    $location_stmt = $conn->prepare($location_sql);
    $like_keyword = '%' . $keyword . '%';
    $location_stmt->bindParam(1, $like_keyword);
    $location_stmt->execute();

    if ($location_stmt->rowCount() > 0) {
        while ($row = $location_stmt->fetch(PDO::FETCH_ASSOC)) {
            $locations[] = [
                'name' => $row['name'],
                'location' => $row['location'],
                'information' => $row['information'],
                'image' => $row['image'], // Lưu hình ảnh vào mảng $locations
            ];
        }
    }

    // Nếu có các tỉnh thành, tìm kiếm bài viết
    if (!empty($locations)) {
        $location_placeholders = implode(',', array_fill(0, count($locations), '?')); // Tạo placeholder cho truy vấn
        $post_sql = "SELECT pd.name, pd.description, pd.image, u.username AS author_name, u.avatar AS author_avatar 
                     FROM postdetail pd 
                     JOIN users u ON pd.userid = u.id 
                     WHERE pd.location IN ($location_placeholders) LIMIT 20";
        $post_stmt = $conn->prepare($post_sql);
        $post_stmt->execute(array_column($locations, 'location')); // Truyền mảng locations vào
        $posts = $post_stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Đóng kết nối
    $location_stmt = null;
    $post_stmt = null;
    $conn = null;
}
// Kiểm tra xem có thông tin người dùng trong session không
if (isset($_SESSION['user_id'])) {
    $userId = $_SESSION['user_id']; // Lấy ID người dùng từ session

    // Lấy trạng thái người dùng từ cơ sở dữ liệu
    $userQuery = "SELECT status FROM users WHERE id = ?";
    $userStmt = $conn->prepare($userQuery); // Thay $pdo bằng $conn
    $userStmt->execute([$userId]);
    $user = $userStmt->fetch(PDO::FETCH_ASSOC);

    // Biến để lưu trạng thái, chỉ cập nhật nếu người dùng tồn tại
    $userStatus = $user['status'] ?? '';

    // Kiểm tra nếu trạng thái là banned
    if ($userStatus === 'banned') {
        // Xóa thông tin người dùng khỏi session
        session_unset();
        session_destroy();
        
        // Chuyển hướng đến trang đăng nhập hoặc thông báo
        header("Location: login.php"); // Thay đổi link đến trang bạn muốn chuyển hướng
        exit();
    }
} else {
    // Nếu không có thông tin người dùng trong session, đặt trạng thái là rỗng
    $userStatus = '';
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/search.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
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
    <div id="main">
        <div class="main-content">
            <div class="container text-center">
                <div id="locations">
                    <h4>Địa điểm</h4>
                    <div class="explore-content">
                        <div class="row row-cols-1 row-cols-md-3 g-4">
                            <?php
                            if (isset($keyword)) {
                                if (!empty($locations)) {
                                    foreach ($locations as $location) {
                                        echo '<div class="col">';
                                        echo '  <div class="card">';
                                        echo '    <img src="./' . htmlspecialchars($location['image']) . '" class="card-img-top" alt="...">'; // Hiển thị hình ảnh với đường dẫn mới
                                        echo '    <div class="card-body">';
                                        echo '      <h5 class="card-title">' . htmlspecialchars($location['name']) . '</h5>';
                                        echo '      <p class="card-text">' . htmlspecialchars($location['information']) . '</p>'; // Sử dụng information
                                        echo '    </div>';
                                        echo '  </div>';
                                        echo '</div>'; // close col
                                    }
                                } else {
                                    echo "<p class='text-center'>Không có địa điểm nào phù hợp với từ khóa <strong>" . htmlspecialchars($keyword) . "</strong>.</p>";
                                }
                            }
                            ?>
                        </div>
                    </div> <!-- Kết thúc explore-content -->
                </div>

                <div id="posts">
                    <?php
                    if (isset($posts) && !empty($posts)) {
                        echo '<h4>Bài viết</h4>';
                        echo '<div class="container text-center">';
                        echo '  <div class="row">';
                        foreach ($posts as $row) {
                            echo '<div class="col center">';
                            echo '    <div class="small-post">';
                            echo '      <div class="post-header">';
                            echo '        <img src="' . htmlspecialchars($row['author_avatar']?? 'asset/img/test.jpg') . '" alt="Avatar" class="post-avatar">'; // Sửa đường dẫn đến ảnh
                            echo '        <div class="post-author">' . htmlspecialchars($row['author_name']) . '</div>';
                            echo '      </div>';
                            echo '      <img src="' . htmlspecialchars($row['image']) . '" class="card-img-top" alt="...">';
                            echo '      <h5 class="card-title">' . htmlspecialchars($row['name']) . '</h5>';
                            echo '      <div class="post-content">' . htmlspecialchars($row['description']) . '</div>';
                            echo '    </div>'; // close small-post
                            echo '</div>'; // close col
                        }
                        echo '  </div>'; // close row
                        echo '</div>'; // close container
                    } else {
                        echo "<p class='text-center'>Không có bài viết nào phù hợp với địa điểm tìm kiếm.</p>";
                    }
                    ?>
                </div>
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
                    <li><a href="#about">Về chúng tôi</a></li>
                    <li><a href="#privacy">Chính sách bảo mật</a></li>
                    <li><a href="#terms">Điều khoản sử dụng</a></li>
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
</body>
</html>
