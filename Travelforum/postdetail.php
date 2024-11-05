<?php
session_start(); 

// Load file cấu hình
$config = include('config.php');

// Kết nối cơ sở dữ liệu
$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Kết nối đến cơ sở dữ liệu thất bại: " . $e->getMessage());
}

// Lấy nội dung bài viết
$post_id = isset($_GET['id']) ? (int) $_GET['id'] : 1; // Lấy post_id từ query string
$stmt = $pdo->prepare("SELECT * FROM postdetail WHERE id = :id");
$stmt->execute(['id' => $post_id]);
$post = $stmt->fetch(PDO::FETCH_ASSOC);

// Kiểm tra xem bài viết có tồn tại không
if (!$post) {
    echo "Bài viết không tồn tại.";
    exit; // Dừng thực hiện script nếu không có bài viết
}

// Kiểm tra nếu người dùng chưa xem bài viết
if (!isset($_SESSION['viewed_posts'])) {
    $_SESSION['viewed_posts'] = []; // Khởi tạo session nếu chưa có
}

// Nếu người dùng chưa xem bài viết này, tăng cột view
if (!in_array($post_id, $_SESSION['viewed_posts'])) {
    // Tăng view cho bài viết
    $updateViewStmt = $pdo->prepare("UPDATE postdetail SET view = view + 1 WHERE id = :id");
    $updateViewStmt->execute(['id' => $post_id]);

    // Lưu lại post_id vào session
    $_SESSION['viewed_posts'][] = $post_id;
}

// Lấy bình luận của bài viết
$comment_stmt = $pdo->prepare("SELECT * FROM postcomment WHERE idpost = :idpost");
$comment_stmt->execute(['idpost' => $post_id]);
$comments = $comment_stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy 3 bài viết gần đây
$recentPostsStmt = $pdo->prepare("SELECT * FROM postdetail ORDER BY date DESC LIMIT 3");
$recentPostsStmt->execute();
$recentPosts = $recentPostsStmt->fetchAll(PDO::FETCH_ASSOC);

// Xử lý đánh giá mới
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['rating'])) {
    $newRating = (int) $_POST['rating'];
    
    // Kiểm tra nếu bài viết tồn tại
    if ($post) {
        $currentRate = $post['rate'];
        $currentAmongRate = $post['amongrate'];
        $postCreatorId = $post['userid'];
        $postLocation = $post['location'];

        // Tính toán đánh giá mới
        $updatedRate = (($currentRate * $currentAmongRate) + $newRating) / ($currentAmongRate + 1);
        $updatedAmongRate = $currentAmongRate + 1;

        // Cập nhật cột rate và amongrate trong cơ sở dữ liệu
        $updateStmt = $pdo->prepare("UPDATE postdetail SET rate = :rate, amongrate = :amongrate WHERE id = :id");
        $updateStmt->execute([
            'rate' => $updatedRate,
            'amongrate' => $updatedAmongRate,
            'id' => $post_id
        ]);

        // Cập nhật điểm cho người tạo bài viết
        $userPostsStmt = $pdo->prepare("SELECT rate, view FROM postdetail WHERE userid = :userid");
        $userPostsStmt->execute(['userid' => $postCreatorId]);
        $userPosts = $userPostsStmt->fetchAll(PDO::FETCH_ASSOC);

        $totalUserRate = 0;
        $totalUserViews = 0;
        $numUserPosts = count($userPosts);
        
        foreach ($userPosts as $userPost) {
            $totalUserRate += $userPost['rate'];
            $totalUserViews += $userPost['view'];
        }

        $userPoint = ($totalUserRate / max($numUserPosts, 1)) + ($numUserPosts * 0.5) + ($totalUserViews * 0.1);
        $updateUserPointStmt = $pdo->prepare("UPDATE users SET point = :point WHERE id = :userid");
        $updateUserPointStmt->execute([
            'point' => $userPoint,
            'userid' => $postCreatorId
        ]);

        // Cập nhật điểm cho địa điểm trong bảng locationdetail
        $locationPostsStmt = $pdo->prepare("SELECT rate, view FROM postdetail WHERE location = :location");
        $locationPostsStmt->execute(['location' => $postLocation]);
        $locationPosts = $locationPostsStmt->fetchAll(PDO::FETCH_ASSOC);

        $totalLocationRate = 0;
        $totalLocationViews = 0;
        $numLocationPosts = count($locationPosts);
        
        foreach ($locationPosts as $locationPost) {
            $totalLocationRate += $locationPost['rate'];
            $totalLocationViews += $locationPost['view'];
        }

        $locationPoint = ($totalLocationRate / max($numLocationPosts, 1)) + ($numLocationPosts * 0.5) + ($totalLocationViews * 0.1);
        $updateLocationPointStmt = $pdo->prepare("UPDATE locationdetail SET point = :point WHERE location = :location");
        $updateLocationPointStmt->execute([
            'point' => $locationPoint,
            'location' => $postLocation
        ]);

        // Tải lại trang sau khi cập nhật
        header("Location: " . $_SERVER['REQUEST_URI']);
        exit;
    } else {
        echo "Bài viết không tồn tại.";
    }
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['comment'])) {
    if (isset($_SESSION['user_id'])) {
        $commentContent = trim($_POST['comment']);
        $post_id = (int) $_POST['idpost'];
        $username = $_SESSION['username'];
        $date = date('Y-m-d H:i:s'); // Lấy thời gian hiện tại
        $userid = $_SESSION['user_id'];

        // Danh sách từ khóa spam
        $spamKeywords = ['quảng cáo', 'mua ngay', 'giảm giá', 'khuyến mãi'];

        // Kiểm tra nếu bình luận chứa từ khóa spam
        foreach ($spamKeywords as $keyword) {
            if (stripos($commentContent, $keyword) !== false) {
                // Cập nhật trạng thái người dùng
                $stmt = $pdo->prepare("UPDATE users SET status = 'warned', warned_until = :warned_until WHERE id = :userid");
                $warnedUntil = (new DateTime($date))->add(new DateInterval('PT10M'))->format('Y-m-d H:i:s'); // Cộng 10 phút
                $stmt->execute([
                    'warned_until' => $warnedUntil,
                    'userid' => $userid
                ]);

                // Chuyển hướng về trang chi tiết bài viết sau khi cảnh báo
                header("Location: postdetail.php?id=" . $post_id);
                exit;
            }
        }

        // Kiểm tra bình luận gần nhất của người dùng
        $stmt = $pdo->prepare("SELECT date FROM postcomment WHERE userid = :userid ORDER BY date DESC LIMIT 1");
        $stmt->execute(['userid' => $userid]);
        $lastComment = $stmt->fetchColumn();

        // Nếu có bình luận gần nhất, kiểm tra thời gian
        if ($lastComment) {
            $lastCommentTime = new DateTime($lastComment);
            $currentTime = new DateTime($date);
            $timeDifference = $currentTime->getTimestamp() - $lastCommentTime->getTimestamp();

            // Nếu bình luận gần nhất được đăng trong vòng 10 giây
            if ($timeDifference < 10) {
                // Cập nhật trạng thái người dùng
                $stmt = $pdo->prepare("UPDATE users SET status = 'warned', warned_until = :warned_until WHERE id = :userid");
                $warnedUntil = $currentTime->add(new DateInterval('PT10M'))->format('Y-m-d H:i:s'); // Cộng 10 phút
                $stmt->execute([
                    'warned_until' => $warnedUntil,
                    'userid' => $userid
                ]);

                // Chuyển hướng về trang chi tiết bài viết sau khi cảnh báo
                header("Location: postdetail.php?id=" . $post_id);
                exit;
            }
        }

        // Chuẩn bị câu lệnh SQL để chèn bình luận vào bảng postcomment
        $stmt = $pdo->prepare("INSERT INTO postcomment (idpost, date, content, username, userid) VALUES (:idpost, :date, :content, :username, :userid)");
        $stmt->execute([
            'idpost' => $post_id,
            'date' => $date,
            'content' => $commentContent,
            'username' => $username,
            'userid' => $userid
        ]);

        // Chuyển hướng về trang chi tiết bài viết sau khi bình luận thành công
        header("Location: postdetail.php?id=" . $post_id);
        exit;
    }
    // Nếu người dùng chưa đăng nhập, không làm gì cả
}


// Kiểm tra xem có thông tin người dùng trong session không
if (isset($_SESSION['user_id'])) {
    $userId = $_SESSION['user_id']; // Lấy ID người dùng từ session

    // Lấy trạng thái người dùng từ cơ sở dữ liệu
    $userQuery = "SELECT status FROM users WHERE id = ?";
    $userStmt = $pdo->prepare($userQuery); // Thay $pdo bằng $conn
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
    <title>Post Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/style.css"> 
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script>
        // Hàm để cập nhật đánh giá khi người dùng chọn sao
        function setRating(rating) {
            const stars = document.querySelectorAll('.star-rating .star');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('filled');
                    star.classList.remove('empty');
                } else {
                    star.classList.add('empty');
                    star.classList.remove('filled', 'partial');
                }
            });
            document.getElementById('ratingInput').value = rating; // Cập nhật giá trị vào input ẩn
        }

        function hoverRating(rating) {
            const stars = document.querySelectorAll('.star-rating .star');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('filled');
                    star.classList.remove('empty');
                } else if (index === Math.floor(rating) && rating % 1 !== 0) {
                    star.classList.add('partial');
                    star.classList.remove('empty');
                    star.style.setProperty('--partial-fill', `${(rating % 1) * 100}%`); // Đặt tỷ lệ phần trăm cho sao một phần
                } else {
                    star.classList.add('empty');
                    star.classList.remove('filled', 'partial');
                }
            });
        }

        function resetRating() {
            const currentRating = document.getElementById('ratingInput').value;
            displayRating(currentRating); // Gọi hàm hiển thị lại rating
        }

        function displayRating(rating) {
            const stars = document.querySelectorAll('.star');
            stars.forEach((star, index) => {
                const starValue = index + 1; // Giá trị sao hiện tại

                // Xóa tất cả các lớp
                star.classList.remove('filled', 'partial', 'empty'); // Xóa tất cả lớp
                star.style.visibility = 'visible'; // Đảm bảo hiển thị tất cả các sao

                // Gán ngôi sao đầy đủ
                if (starValue <= Math.floor(rating)) {
                    star.classList.add('filled'); // Ngôi sao đầy
                } 
                // Gán ngôi sao một phần
                else if (starValue === Math.ceil(rating) && rating % 1 !== 0) {
                    const partialFill = (rating - Math.floor(rating)) * 100; // Phần trăm lấp đầy
                    star.classList.add('partial');
                    star.style.setProperty('--partial-fill', `${partialFill}%`);
                } else {
                    star.classList.add('empty'); // Ngôi sao rỗng
                }
            });
        }

    </script>

</head>
<body>
    <?php
        include 'header.php'; 
    ?>

    <div id="main">
        <div class="post-detail">
            <div class="navbar text-center">
                <h2>POST</h2>
            </div>
            <div class="post-layout d-flex">
                <div class="post-content flex-grow-1">
                    <h1><?php echo htmlspecialchars($post['name']); ?></h1>
                    <p class="date"><?php echo date('F j, Y', strtotime($post['date'])); ?></p>
                    <img src="<?php echo htmlspecialchars($post['image']); ?>" alt="Post Image" class="detail-image">
                    <p><?php echo nl2br(htmlspecialchars($post['content'])); ?></p>

                    <div class="comments-section mt-4">
                        <h3>Comments</h3>
                        <?php foreach ($comments as $comment): ?>
                            <div class="comment">
                                <p><strong><?php echo htmlspecialchars($comment['username']); ?>:</strong> <?php echo nl2br(htmlspecialchars($comment['content'])); ?></p>
                            </div>
                        <?php endforeach; ?>

                        <?php if (isset($_SESSION['username'])): ?>
                            <form class="add-comment-form" method="POST" action="postdetail.php">
                                <textarea name="comment" placeholder="Add your comment here..." required></textarea>
                                <input type="hidden" name="idpost" value="<?php echo $post_id; ?>">
                                <button type="submit" class="btn btn-primary mt-2">Submit</button>
                            </form>
                        <?php else: ?>
                            <p class="text-danger">Vui lòng <a href="login.php">đăng nhập</a> để bình luận.</p>
                        <?php endif; ?>
                    </div>


                    <div class="rating-section">
                        <h3>Rate this post</h3>
                        <div class="star-rating">
                            <?php
                            $rate = $post['rate'];
                            $fullStars = floor($rate);
                            $partialStar = $rate - $fullStars;

                            for ($i = 1; $i <= 5; $i++):
                                if ($i <= $fullStars) {
                                    $starClass = 'filled'; // Ngôi sao đầy
                                } elseif ($i == $fullStars + 1 && $partialStar > 0) {
                                    $starClass = 'partial'; // Ngôi sao một phần
                                    $partialFill = $partialStar * 100; // Tỷ lệ phần trăm
                                } else {
                                    $starClass = 'empty'; // Ngôi sao chưa đánh giá
                                }
                            ?>
                                <span class="star <?php echo $starClass; ?>" style="--partial-fill: <?php echo $starClass == 'partial' ? $partialFill : 0; ?>%;" data-value="<?php echo $i; ?>" 
                                    onmouseover="hoverRating(<?php echo $i; ?>)" 
                                    onmouseout="resetRating()" 
                                    onclick="setRating(<?php echo $i; ?>)">&#9733;</span>
                            <?php endfor; ?>
                        </div>

                        <form method="POST" action="">
                            <input type="hidden" name="rating" id="ratingInput" value="<?php echo $rate; ?>"> <!-- Giá trị đánh giá sẽ được cập nhật -->
                            <button type="submit" class="btn btn-primary mt-2">Submit Rating</button>
                        </form>
                    </div>
           
                </div>

                <!-- Recent Posts Sidebar -->
                <div class="recent-posts ms-4">
                    <h3>Các bài viết gần đây</h3>
                    <?php foreach ($recentPosts as $recentPost): ?>
                        <div class="recent-post">
                            <h4><a href="postdetail.php?id=<?php echo $recentPost['id']; ?>"><?php echo htmlspecialchars($recentPost['name']); ?></a></h4>
                            <p class="date"><?php echo date('F j, Y', strtotime($recentPost['date'])); ?></p>
                        </div>
                    <?php endforeach; ?>
                </div>

            </div>
        </div>
    </div>
    <!-- Modal -->
    <div id="warningModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close-button" id="closeModal">&times;</span>
            <h2>Thông báo</h2>
            <p>Vui lòng chú ý hành vi của mình.</p>
            <button id="confirmButton">Xác nhận</button>
        </div>
    </div>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Kiểm tra xem người dùng có trạng thái là warned không
        const userStatus = '<?php echo $userStatus; ?>';
        const modal = document.getElementById('warningModal');
        const closeModalButton = document.getElementById('closeModal');
        const confirmButton = document.getElementById('confirmButton');

        if (userStatus === 'warned') {
            modal.style.display = 'flex'; // Hiển thị modal
        }

        // Đóng modal khi nhấn nút đóng
        closeModalButton.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        // Đóng modal khi nhấn nút xác nhận
        confirmButton.addEventListener('click', function() {
            modal.style.display = 'none';
        });
    });
    </script>

</body>
</html>
