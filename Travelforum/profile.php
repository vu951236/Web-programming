<?php
// Bao gồm tệp cấu hình
$config = include('config.php');

// Kiểm tra thông tin cấu hình cơ sở dữ liệu
if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    // Kết nối đến cơ sở dữ liệu
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Lấy thông tin người dùng
    $userId = isset($_GET['userId']) ? $_GET['userId'] : 0;
    $stmt = $pdo->prepare("SELECT * FROM users WHERE id = :userId");
    $stmt->execute(['userId' => $userId]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        die("Người dùng không tồn tại.");
    }

    // Lấy bài viết của người dùng
    $stmt_posts = $pdo->prepare("SELECT * FROM postdetail WHERE userid = :userId");
    $stmt_posts->execute(['userId' => $userId]);
    $posts = $stmt_posts->fetchAll(PDO::FETCH_ASSOC);

    // Lấy bài đăng của người dùng
    $stmt_forums = $pdo->prepare("SELECT * FROM forumdetail WHERE userid = :userId");
    $stmt_forums->execute(['userId' => $userId]);
    $forums = $stmt_forums->fetchAll(PDO::FETCH_ASSOC);

   // Lấy bài viết nổi bật
    $stmt_featured_posts = $pdo->prepare("SELECT * FROM postdetail WHERE userid = :userId ORDER BY rate DESC LIMIT 3");
    $stmt_featured_posts->execute(['userId' => $userId]);
    $featured_posts = $stmt_featured_posts->fetchAll(PDO::FETCH_ASSOC);

    // Lấy bài đăng nổi bật
    $stmt_featured_forums = $pdo->prepare("SELECT * FROM forumdetail WHERE userid = :userId ORDER BY likes_count DESC LIMIT 3");
    $stmt_featured_forums->execute(['userId' => $userId]);
    $featured_forums = $stmt_featured_forums->fetchAll(PDO::FETCH_ASSOC);


} catch (PDOException $e) {
    die("Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <!-- Bootstrap and Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="./asset/css/profile.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
</head>
<body>
<?php include 'header.php'; ?>

<div class="container profile-container">
    <!-- Phần trên: Avatar và thông tin người dùng -->
    <div class="profile-header d-flex align-items-center border-bottom pb-4 mb-4">
        <img src="<?php echo $user['avatar'] ?: 'asset/img/test.jpg'; ?>" alt="Avatar" class="profile-avatar rounded-circle me-3">
        <div>
            <h2 class="mb-1"><?php echo htmlspecialchars($user['username']); ?></h2>
            <p class="text-muted">Điểm: <?php echo $user['point']; ?></p>
        </div>
    </div>

    <!-- Phần dưới: Nội dung chính -->
    <div class="row">
        <!-- Sidebar: Bộ lọc -->
        <div class="col-md-3">
            <div class="card mb-4 shadow-sm">
                <div class="card-body">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link <?php echo (!isset($_GET['filter']) || $_GET['filter'] == 'post') ? 'active' : ''; ?>" href="profile.php?userId=<?php echo $userId; ?>&filter=post">Bài viết</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo (isset($_GET['filter']) && $_GET['filter'] == 'forum') ? 'active' : ''; ?>" href="profile.php?userId=<?php echo $userId; ?>&filter=forum">Bài đăng</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Nội dung chính: Bài viết và bài đăng -->
        <div class="col-md-6">
            <div>
                <h4><?php echo (!isset($_GET['filter']) || $_GET['filter'] == 'post') ? 'Bài viết của ' . htmlspecialchars($user['username']) : 'Bài đăng của ' . htmlspecialchars($user['username']); ?></h4>
                <ul class="list-unstyled">
                    <?php 
                    $items = (!isset($_GET['filter']) || $_GET['filter'] == 'post') ? $posts : $forums;
                    foreach ($items as $item) { 
                        $title = isset($item['name']) ? $item['name'] : $item['content'];
                        $url = isset($item['name']) ? "postdetail.php?id={$item['id']}" : "forum.php?forumId#post-{$item['id']}";
                    ?>
                        <li class="mb-2">
                            <a href="<?php echo $url; ?>" class="text-decoration-none text-primary"><?php echo htmlspecialchars($title); ?></a>
                        </li>
                    <?php } ?>
                </ul>
            </div>
        </div>

        <!-- Phần nổi bật: Bài viết nổi bật và Bài đăng nổi bật -->
        <div class="col-md-3">
            <div class="featured-posts mb-4">
                <h5>Bài viết nổi bật</h5>
                <ul class="list-unstyled">
                    <?php foreach ($featured_posts as $featured_post) { ?>
                        <li>
                            <a href="postdetail.php?id=<?php echo $featured_post['id']; ?>" class="text-decoration-none text-primary"><?php echo htmlspecialchars($featured_post['name']); ?> - Đánh giá: <?php echo $featured_post['rate']; ?></a>
                        </li>
                    <?php } ?>
                </ul>
            </div>
            <div class="featured-forums">
                <h5>Bài đăng nổi bật</h5>
                <ul class="list-unstyled">
                    <?php foreach ($featured_forums as $featured_forum) { ?>
                        <li>
                            <a href="forum.php?#post-<?php echo $featured_forum['id']; ?>" class="text-decoration-none text-primary"><?php echo htmlspecialchars($featured_forum['content']); ?> - Lượt thích: <?php echo $featured_forum['likes_count']; ?></a>
                        </li>
                    <?php } ?>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
