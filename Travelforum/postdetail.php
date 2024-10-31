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
$post_id = 1; // Thay thế bằng id của bài viết bạn muốn lấy
$stmt = $pdo->prepare("SELECT * FROM postdetail WHERE id = :id");
$stmt->execute(['id' => $post_id]);
$post = $stmt->fetch(PDO::FETCH_ASSOC);

// Lấy bình luận của bài viết
$comment_stmt = $pdo->prepare("SELECT * FROM postcomment WHERE idpost = :idpost");
$comment_stmt->execute(['idpost' => $post_id]);
$comments = $comment_stmt->fetchAll(PDO::FETCH_ASSOC);

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
    <div id="header">
        <div class="header-logo">Logo</div>
        <div class="header-search">
            <input type="text" placeholder="Tìm kiếm..." />
            <button class="btn-header">Tìm kiếm</button>
        </div>
        <nav class="header-nav">
            <a href="mypost.html#status">Bài viết</a>
            <a href="mypost.html#explore">Khám phá</a>
            <a href="mypost.html#about">Về chúng tôi</a>
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

                    <!-- Comments -->
                    <div class="comments-section mt-4">
                        <h3>Comments</h3>
                        <?php foreach ($comments as $comment): ?>
                            <div class="comment">
                                <p><strong><?php echo htmlspecialchars($comment['username']); ?>:</strong> <?php echo nl2br(htmlspecialchars($comment['content'])); ?></p>
                            </div>
                        <?php endforeach; ?>
                        <form class="add-comment-form" method="POST" action="add_comment.php">
                            <textarea name="comment" placeholder="Add your comment here..." required></textarea>
                            <input type="hidden" name="idpost" value="<?php echo $post_id; ?>">
                            <button type="submit" class="btn btn-primary mt-2">Submit</button>
                        </form>
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
                    <div class="recent-post">
                        <h4><a href="postdetail.html">ABC</a></h4>
                        <p class="date">October 12, 2024</p>
                    </div>
                    <div class="recent-post">
                        <h4><a href="postdetail.html">ABD</a></h4>
                        <p class="date">October 10, 2024</p>
                    </div>
                    <div class="recent-post">
                        <h4><a href="postdetail.html">ABE</a></h4>
                        <p class="date">October 8, 2024</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
