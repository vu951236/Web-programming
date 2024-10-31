<?php
session_start();
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

// Xử lý các bộ lọc
$filter = isset($_GET['filter']) ? $_GET['filter'] : 'high-rated';
$sql = '';

$valid_filters = ['beach', 'mountain', 'high-rated'];
if (in_array($filter, $valid_filters)) {
    switch ($filter) {
        case 'beach':
            $sql = "SELECT * FROM locationdetail WHERE type = 'bien' ORDER BY point DESC";
            break;
        case 'mountain':
            $sql = "SELECT * FROM locationdetail WHERE type = 'nui' ORDER BY point DESC";
            break;
        case 'high-rated':
        default:
            $sql = "SELECT * FROM locationdetail ORDER BY point DESC LIMIT 20";
            break;
    }
} else {
    $sql = "SELECT * FROM locationdetail ORDER BY point DESC LIMIT 20";
}

$result_locations = $conn->query($sql);
$locations = $result_locations->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/explore.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script src="./asset/js/explore.js"></script>
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
                <div class="row">
                    <!-- Cột điều hướng bộ lọc -->
                    <div class="col-sm-2">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link <?php echo $filter === 'high-rated' ? 'active' : ''; ?>" href="explore.php?filter=high-rated">Được đánh giá cao</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo $filter === 'beach' ? 'active' : ''; ?>" href="explore.php?filter=beach">Du lịch biển</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo $filter === 'mountain' ? 'active' : ''; ?>" href="explore.php?filter=mountain">Du lịch núi</a>
                            </li>
                        </ul>
                    </div>

                    <!-- Cột hiển thị nội dung địa điểm -->
                    <div class="col-sm-10">
                        <div class="explore-content">
                            <div class="row row-cols-1 row-cols-md-3 g-4">
                                <?php if (!empty($locations)): ?>
                                    <?php foreach ($locations as $location): ?>
                                        <div class="col">
                                            <div class="card">
                                                <img src="./asset/img/<?php echo htmlspecialchars($location['image']); ?>" class="card-img-top" alt="<?php echo htmlspecialchars($location['name']); ?>">
                                                <div class="card-body">
                                                    <h5 class="card-title"><?php echo htmlspecialchars($location['name']); ?></h5>
                                                    <p class="card-text"><?php echo htmlspecialchars($location['information']); ?></p>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <p>Không tìm thấy địa điểm nào.</p>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
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
    
    <?php pg_close($conn); ?>
</body>
</html>
