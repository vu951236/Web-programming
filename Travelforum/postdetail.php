<?php
// Kết nối đến cơ sở dữ liệu PostgreSQL
$host = 'localhost';
$db = 'Webphp';
$user = 'postgres';
$pass = '951236vu';

try {
    $pdo = new PDO("pgsql:host=$host;dbname=$db", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}

// Lấy nội dung bài viết
$post_id = 1; // Thay thế bằng id của bài viết bạn muốn lấy
$stmt = $pdo->prepare("SELECT * FROM postdetail WHERE id = :id");
$stmt->execute(['id' => $post_id]);
$post = $stmt->fetch(PDO::FETCH_ASSOC);

// Lấy bình luận của bài viết
$comment_stmt = $pdo->prepare("SELECT * FROM comment WHERE idpost = :idpost");
$comment_stmt->execute(['idpost' => $post_id]);
$comments = $comment_stmt->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['rating'])) {
    $newRating = (int) $_POST['rating'];
    $postId = $post['id'];
    $currentRate = $post['rate'];
    $currentAmongRate = $post['amongrate'];

    // Tính toán đánh giá mới
    $updatedRate = (($currentRate * $currentAmongRate) + $newRating) / ($currentAmongRate + 1);
    $updatedAmongRate = $currentAmongRate + 1;

    // Cập nhật cơ sở dữ liệu
    $updateStmt = $pdo->prepare("UPDATE postdetail SET rate = :rate, amongrate = :amongrate WHERE id = :id");
    $updateStmt->execute([
        'rate' => $updatedRate,
        'amongrate' => $updatedAmongRate,
        'id' => $postId
    ]);
    
    // Tải lại trang sau khi cập nhật
    header("Location: " . $_SERVER['REQUEST_URI']);
    exit;
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
            <a class="btn-account activee" href="#login">Đăng nhập</a>
            <a class="btn-account" href="#register">Đăng ký</a>
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
                            // Giá trị rate có thể là số lẻ (ví dụ 4.3)
                            $rate = $post['rate'];
                            $fullStars = floor($rate); // Số lượng sao đầy
                            $partialStar = $rate - $fullStars; // Phần trăm cho sao lẻ

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
                                <span class="star <?php echo $starClass; ?>" style="--partial-fill: <?php echo $starClass == 'partial' ? $partialFill : 0; ?>%;" data-value="<?php echo $i; ?>" onclick="setRating(<?php echo $i; ?>)">&#9733;</span>
                            <?php endfor; ?>
                        </div>

                        <form method="POST" action="">
                            <input type="hidden" name="rating" id="ratingInput" value="<?php echo $rate; ?>"> <!-- Giá trị đánh giá sẽ được cập nhật -->
                            <button type="submit" class="btn btn-primary mt-2">Submit Rating</button>
                        </form>
                    </div>


                    <script>
                    // Hàm để cập nhật đánh giá khi người dùng chọn sao
                    function setRating(rating) {
                        const stars = document.querySelectorAll('.star-rating .star');
                        stars.forEach((star, index) => {
                            // Nếu chỉ số sao nhỏ hơn hoặc bằng giá trị được chọn, đổi màu sang vàng (filled)
                            if (index < rating) {
                                star.classList.add('filled');
                                star.classList.remove('empty');
                            } else {
                                star.classList.add('empty');
                                star.classList.remove('filled');
                            }
                        });
                        // Cập nhật giá trị rating vào input ẩn
                        document.getElementById('ratingInput').value = rating;
                    }
                    function displayRating(rating) {
                        const stars = document.querySelectorAll('.star');
                        stars.forEach((star, index) => {
                            const starValue = index + 1;
                            star.classList.remove('filled', 'partial');
                            
                            // Gán ngôi sao đầy đủ
                            if (starValue <= Math.floor(rating)) {
                                star.classList.add('filled');
                            } 
                            // Gán ngôi sao một phần
                            else if (starValue === Math.ceil(rating)) {
                                const partialFill = (rating - Math.floor(rating)) * 100; // Phần trăm lấp đầy
                                star.classList.add('partial');
                                star.style.setProperty('--partial-fill', `${partialFill}%`);
                            }
                        });
                    }

                    </script>
                    
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
