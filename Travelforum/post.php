<?php
session_start();
$config = include('config.php');

if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    $conn = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Kết nối đến cơ sở dữ liệu thất bại: " . $e->getMessage());
}

// Kiểm tra lựa chọn 'view'
$view = isset($_GET['view']) ? $_GET['view'] : 'all_post';
// Xác định trạng thái của bài viết
$status = 'approve';

if ($view === 'my_posts' && isset($_SESSION['user_id'])) {
    // Hiển thị bài viết của tôi
    $user_id = $_SESSION['user_id'];
    $sql = "SELECT postdetail.*, users.avatar, users.username, 
                   (SELECT COUNT(*) FROM postcomment WHERE postcomment.idpost = postdetail.id) AS comment_count 
            FROM postdetail 
            JOIN users ON postdetail.userid = users.id 
            WHERE postdetail.userid = :user_id AND postdetail.status = :status 
            ORDER BY postdetail.date DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
    $stmt->bindParam(':status', $status, PDO::PARAM_STR);
    $stmt->execute();

} elseif ($view === 'anuong' || $view === 'nghiduong' || $view === 'dulichmuasam') {
    // Hiển thị bài viết theo danh mục
    $sql = "SELECT postdetail.*, users.avatar, users.username, 
                   (SELECT COUNT(*) FROM postcomment WHERE postcomment.idpost = postdetail.id) AS comment_count 
            FROM postdetail 
            JOIN users ON postdetail.userid = users.id 
            WHERE postdetail.typepost = :typepost AND postdetail.status = :status 
            ORDER BY postdetail.date DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':typepost', $view, PDO::PARAM_STR);
    $stmt->bindParam(':status', $status, PDO::PARAM_STR);
    $stmt->execute();

} else {
    // Hiển thị tất cả bài viết
    $sql = "SELECT postdetail.*, users.avatar, users.username, 
                   (SELECT COUNT(*) FROM postcomment WHERE postcomment.idpost = postdetail.id) AS comment_count 
            FROM postdetail 
            JOIN users ON postdetail.userid = users.id 
            WHERE postdetail.status = :status 
            ORDER BY postdetail.date DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':status', $status, PDO::PARAM_STR);
    $stmt->execute();
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
// Truy vấn để lấy 3 người dùng có điểm cao nhất
$sql = "
    SELECT id, avatar, username
    FROM users
    ORDER BY point DESC
    LIMIT 3
";
$stmt = $conn->prepare($sql);
$stmt->execute();
$topUsers = $stmt->fetchAll(PDO::FETCH_ASSOC);
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
    <?php
        include 'header.php'; 
    ?>

    <div id="main">
        <div class="main-content">
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <div class="nav-wrapper">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'all_post' ? 'active' : ''; ?>" href="post.php?view=all_post">Tất cả bài viết</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'my_posts' ? 'active' : ''; ?>" href="post.php?view=my_posts">Bài viết của tôi</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'anuong' ? 'active' : ''; ?>" href="post.php?view=anuong">Bài viết về ăn uống</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'nghiduong' ? 'active' : ''; ?>" href="post.php?view=nghiduong">Bài viết về kì nghỉ</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <?php echo $view === 'dulichmuasam' ? 'active' : ''; ?>" href="post.php?view=dulichmuasam">Bài viết về du lịch</a>
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
                                            <a href="profile.php?userId=<?php echo htmlspecialchars($post['userid']); ?>" class="text-decoration-none">
                                                <img src="<?php echo htmlspecialchars($post['avatar'] ?? 'asset/img/test.jpg'); ?>" alt="Avatar" class="post-avatar">
                                            </a>
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
                                                <a href="./postdetail.php?id=<?php echo htmlspecialchars($post['id']); ?>">
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
                            <h4 style="font-size: 16px;">Thành viên ưu tú</h4>
                            <ul class="active-users">
                                <?php foreach ($topUsers as $user): ?>
                                    <li class="active-user">
                                    <a href="profile.php?userId=<?php echo htmlspecialchars($user['id']); ?>" class="d-flex align-items-center text-decoration-none text-dark">
                                      <img src="<?php echo htmlspecialchars($user['avatar'] ?? 'asset/img/test.jpg'); ?>" alt="<?php echo htmlspecialchars($user['username']); ?>" class="user-avatar">
                                        <span class="user-name"><?php echo htmlspecialchars($user['username']); ?></span>
                                    </a>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
