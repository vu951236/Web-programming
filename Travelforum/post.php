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

// Kiểm tra lựa chọn 'view'
$view = isset($_GET['view']) ? $_GET['view'] : 'forum';

if ($view === 'my_posts' && isset($_SESSION['user_id'])) {
    // Hiển thị bài viết của tôi
    $user_id = $_SESSION['user_id'];
    $sql = "SELECT postdetail.*, users.avatar, users.username, 
                   (SELECT COUNT(*) FROM postcomment WHERE postcomment.idpost = postdetail.id) AS comment_count 
            FROM postdetail 
            JOIN users ON postdetail.userid = users.id 
            WHERE postdetail.userid = :user_id 
            ORDER BY postdetail.date DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
    $stmt->execute();
} else {
    // Hiển thị tất cả bài viết
    $sql = "SELECT postdetail.*, users.avatar, users.username, 
                   (SELECT COUNT(*) FROM postcomment WHERE postcomment.idpost = postdetail.id) AS comment_count 
            FROM postdetail 
            JOIN users ON postdetail.userid = users.id 
            ORDER BY postdetail.date DESC";
    $stmt = $conn->query($sql);
}

$posts = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Hàm tính thời gian trôi qua
function time_elapsed_string($datetime, $full = false) {
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $diff->w = floor($diff->d / 7);
    $diff->d -= $diff->w * 7;

    $string = [
        'y' => 'năm',
        'm' => 'tháng',
        'w' => 'tuần',
        'd' => 'ngày',
        'h' => 'giờ',
        'i' => 'phút',
        's' => 'giây',
    ];
    foreach ($string as $k => &$v) {
        if ($diff->$k) {
            $v = $diff->$k . ' ' . $v;
        } else {
            unset($string[$k]);
        }
    }

    if (!$full) $string = array_slice($string, 0, 1);
    return $string ? implode(', ', $string) . ' trước' : 'vừa xong';
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài viết</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/post.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script src="./asset/js/post.js"></script>
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
                    <div class="col">
                        <div class="nav-wrapper">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'forum' ? 'active' : ''; ?>" href="post.php?view=forum">Diễn đàn chung</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'my_posts' ? 'active' : ''; ?>" href="post.php?view=my_posts">Bài viết của tôi</a>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Cột hiển thị bài viết -->
                    <div class="col-6">
                        <?php if (!empty($posts)): ?>
                            <?php foreach ($posts as $post): ?>
                                <div class="wrapper">
                                    <div class="post">
                                        <div class="post-header">
                                            <img src="<?php echo htmlspecialchars($post['avatar'] ?? 'asset/img/test.jpg'); ?>" alt="Avatar" class="post-avatar">
                                            <div>
                                                <div class="post-author"><?php echo htmlspecialchars($post['username']); ?></div>
                                                <div class="post-time"><?php echo time_elapsed_string($post['date']); ?></div>
                                            </div>
                                        </div>
                                        <div class="post-content">
                                            <?php echo htmlspecialchars($post['description']); ?>
                                        </div>
                                        <img src="<?php echo htmlspecialchars($post['image']); ?>" alt="Post Image" class="post-image">
                                        <div class="post-stats">
                                            <span><?php echo htmlspecialchars($post['rate']); ?> rating points</span>
                                            <span><?php echo htmlspecialchars($post['comment_count']); ?> comments</span>
                                        </div>
                                        <div class="post-footer">
                                            <div class="post-actions">
                                                <a href="/Travelforum/Travelforum/postdetail.php?id=<?php echo htmlspecialchars($post['id']); ?>">
                                                    <button><i class="fa-regular fa-eye"></i> Xem bài viết</button>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <p>Không có bài viết nào.</p>
                        <?php endif; ?>
                    </div>
                    <div class="col">
                        <div class="active-person">
                            <h4 style="font-size: 16px;">Người đang hoạt động</h4>
                            <ul class="active-users">
                                <li class="active-user">
                                    <img src="./asset/img/test.jpg" alt="User 1" class="user-avatar">
                                    <span class="user-name">Nguyễn Văn A</span>
                                </li>
                                <li class="active-user">
                                    <img src="./asset/img/test.jpg" alt="User 2" class="user-avatar">
                                    <span class="user-name">Trần Thị B</span>
                                </li>
                                <li class="active-user">
                                    <img src="./asset/img/test.jpg" alt="User 3" class="user-avatar">
                                    <span class="user-name">Lê Văn C</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
