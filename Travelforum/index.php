<?php
session_start(); 
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
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
</head>
<body>
    <?php
    $config = include('config.php');

    // Kiểm tra cấu hình có đầy đủ không
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

    // Lấy dữ liệu từ bảng locationdetail
    $sql_locations = "SELECT * FROM locationdetail ORDER BY point DESC LIMIT 9";
    $result_locations = $conn->query($sql_locations);

    // Lấy dữ liệu từ bảng users
    $sql_users = "SELECT * FROM users ORDER BY point DESC LIMIT 5";
    $result_users = $conn->query($sql_users);

    // Xử lý kết quả
    $locations = $result_locations->fetchAll(PDO::FETCH_ASSOC);
    $users = $result_users->fetchAll(PDO::FETCH_ASSOC);
    ?>

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
        <div class="banner">
            <p>Đây là banner quần què gì đó</p>
        </div>
        
        <h3 style="padding: 10px 20px; font-size: 24px;">Địa điểm nổi bật</h3>
        <div id="carouselExampleDark" class="carousel carousel-dark slide">
            <div class="carousel-indicators">
                <?php for ($i = 0; $i < ceil(count($locations) / 3); $i++): // Tạo nút cho carousel ?>
                    <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="<?php echo $i; ?>" <?php if ($i == 0) echo 'class="active" aria-current="true"'; ?> aria-label="Slide <?php echo $i + 1; ?>"></button>
                <?php endfor; ?>
            </div>
            <div class="carousel-inner">
                <?php if (count($locations) > 0): ?>
                    <?php $active = true; ?>
                    <?php 
                    // Chia địa điểm thành 3 nhóm, mỗi nhóm có 3 địa điểm
                    for ($i = 0; $i < ceil(count($locations) / 3); $i++): ?>
                        <div class="carousel-item <?php echo $active ? 'active' : ''; ?>" data-bs-interval="10000">
                            <?php $active = false; ?>
                            <div class="container slider-padding text-center">
                                <div class="row">
                                    <?php for ($j = 0; $j < 3; $j++): // Hiển thị 3 cards trong mỗi item ?>
                                        <?php $index = $i * 3 + $j; // Tính chỉ số địa điểm ?>
                                        <?php if (isset($locations[$index])): // Kiểm tra xem địa điểm tồn tại không ?>
                                            <div class="col">
                                                <div class="card">
                                                    <img src="./asset/img/<?php echo $locations[$index]['image']; ?>" class="card-img-top" alt="...">
                                                    <div class="card-body">
                                                        <h5 class="card-title"><?php echo $locations[$index]['name']; ?></h5>
                                                        <p class="card-text"><?php echo $locations[$index]['information']; ?></p>
                                                        <a href="#" class="btn-card">Chi tiết</a>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php endif; ?>
                                    <?php endfor; ?>
                                </div>
                            </div>
                        </div>
                    <?php endfor; ?>
                <?php endif; ?>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
        
        <h3 style="padding: 10px 20px; font-size: 24px;">Thành viên nổi bật</h3>
        <div class="wrapper-member">
            <div class="container text-center">
                <div class="row">
                    <?php if (count($users) > 0): ?>
                        <?php foreach ($users as $row): ?>
                            <div class="col">
                                <div class="team-mem">
                                    <img class="member-img" src="./asset/img/<?php echo $row['avatar'] ?: 'test.jpg'; ?>">
                                    <h4 class="member-name"><?php echo $row['username']; ?></h4>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    <?php endif; ?>
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

    <?php $conn = null; // Đóng kết nối ?>
</body>
</html>
