<?php
session_start();
$config = include('config.php');

if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Lấy ID địa điểm từ URL hoặc session
    $location_id = isset($_GET['id']) ? $_GET['id'] : 1; // Mặc định là 1 nếu không có ID

    // Truy vấn thông tin địa điểm
    $stmt = $pdo->prepare("SELECT * FROM locationdetail WHERE id = :id");
    $stmt->execute(['id' => $location_id]);
    $location = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$location) {
        die("Không tìm thấy địa điểm.");
    }

    // Truy vấn các bài viết liên quan
    $stmtPosts = $pdo->prepare("SELECT id, name, image FROM postdetail WHERE location = :location");
    $stmtPosts->execute(['location' => $location['location']]);
    $relatedPosts = $stmtPosts->fetchAll(PDO::FETCH_ASSOC);

    // Lấy bình luận của bài viết
    $comment_stmt = $pdo->prepare("SELECT * FROM locationcomment WHERE idlocation = :idlocation");
    $comment_stmt->execute(['idlocation' => $location_id]);
    $comments = $comment_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Xử lý đánh giá mới
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['rating'])) {
        $newRating = (int) $_POST['rating'];
        
        // Kiểm tra nếu bài viết tồn tại
        if ($location) {
            $currentRate = $location['rate'];
            $currentAmongRate = $location['amongrate'];

            // Tính toán đánh giá mới
            $updatedRate = (($currentRate * $currentAmongRate) + $newRating) / ($currentAmongRate + 1);
            $updatedAmongRate = $currentAmongRate + 1;

            // Cập nhật cột rate và amongrate trong cơ sở dữ liệu
            $updateStmt = $pdo->prepare("UPDATE locationdetail SET rate = :rate, amongrate = :amongrate WHERE id = :id");
            $updateStmt->execute([
                'rate' => $updatedRate,
                'amongrate' => $updatedAmongRate,
                'id' => $location_id
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
            $location_id = (int) $_POST['idlocation'];
            $username = $_SESSION['username'];
            $date = date('Y-m-d H:i:s'); // Lấy thời gian hiện tại
            $userid = $_SESSION['user_id'];

        // Danh sách từ khóa spam
        $spamKeywords = [
            'quảng cáo', 'mua ngay', 'giảm giá', 'khuyến mãi', 
            'cần mua', 'chuyên cung cấp', 'giảm giá cực mạnh', 'mua ngay kẻo lỡ', 
            'chúng tôi bảo đảm', 'đặt ngay', 'tặng quà', 'ưu đãi', 'siêu khuyến mãi',
            'miễn phí', 'gọi ngay', 'tuyển dụng', 'đăng ký ngay', 'bán hàng', 
            'quảng cáo độc', 'chuyên gia', 'quảng cáo trực tuyến', 'cần tiền gấp', 
            'chuyên cung cấp', 'gọi điện ngay', 'khuyến mại lớn', 'mua sắm', 'hàng giả',
            'thẻ cào', 'bán hàng online', 'tuyển dụng', 'đặt hàng nhanh', 'kết bạn làm ăn',
            // Các từ tục tĩu

        ];


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
                    header("Location: locationdetail.php?id=" . $location_id);
                    exit;
                }
            }

            // Kiểm tra bình luận gần nhất của người dùng
            $stmt = $pdo->prepare("SELECT date FROM locationcomment WHERE userid = :userid ORDER BY date DESC LIMIT 1");
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
                    header("Location: locationdetail.php?id=" . $location_id);
                    exit;
                }
            }

            // Chuẩn bị câu lệnh SQL để chèn bình luận vào bảng locationcomment
            $stmt = $pdo->prepare("INSERT INTO locationcomment (idlocation, date, content, username, userid) VALUES (:idlocation, :date, :content, :username, :userid)");
            $stmt->execute([
                'idlocation' => $location_id,
                'date' => $date,
                'content' => $commentContent,
                'username' => $username,
                'userid' => $userid
            ]);

            // Chuyển hướng về trang chi tiết bài viết sau khi bình luận thành công
            header("Location: locationdetail.php?id=" . $location_id);
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

} catch (PDOException $e) {
    die("Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage());
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Location Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/style.css">
    <link rel="stylesheet" href="./asset/css/locationdetail.css">
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

    <main id="main" class="container">
        <div class="rating-section">
            <h3>Rate this location</h3>
            <div class="star-rating">
                <?php
                $rate = $location['rate'];
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

        <!-- Related Posts Section -->
        <section class="related-posts mb-5">
            <h3>Bài viết liên quan</h3>
            <div class="row">
                <?php foreach ($relatedPosts as $post): ?>
                    <div class="col-md-4 mb-3">
                        <div class="post p-3 border">
                            <h5><?php echo htmlspecialchars($post['name']); ?></h5>
                            <a href="postdetail.php?id=<?php echo $post['id']; ?>">
                                <img src="<?php echo htmlspecialchars($post['image']); ?>" alt="Post Image" class="img-fluid">
                            </a>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </section>


        <!-- Comments Section -->
        <div class="comments-section mt-4">
            <h3>Comments</h3>
            <?php foreach ($comments as $comment): ?>
                <div class="comment">
                    <p><strong><?php echo htmlspecialchars($comment['username']); ?>:</strong> <?php echo nl2br(htmlspecialchars($comment['content'])); ?></p>
                </div>
            <?php endforeach; ?>

            <?php if (isset($_SESSION['username'])): ?>
                <form class="add-comment-form" method="POST" action="locationdetail.php">
                    <textarea name="comment" placeholder="Add your comment here..." required></textarea>
                    <input type="hidden" name="idlocation" value="<?php echo $location_id; ?>">
                    <button type="submit" class="btn btn-primary mt-2">Submit</button>
                </form>
            <?php else: ?>
                <p class="text-danger">Vui lòng <a href="login.php">đăng nhập</a> để bình luận.</p>
            <?php endif; ?>
         </div>
    </main>
    <!-- Modal -->
    <div id="warningModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close-button" id="closeModal">&times;</span>
            <h2>Thông báo</h2>
            <p>Vui lòng chú ý hành vi của mình.</p>
            <button id="confirmButton">Xác nhận</button>
        </div>
    </div>

    <!-- Footer -->
    <footer id="footer" class="bg-light p-4 mt-5">
        <div class="container d-flex justify-content-between">
            <div>
                <h5>Contact</h5>
                <p>Email: contact@example.com</p>
                <p>Điện thoại: +123 456 7890</p>
            </div>
            <div>
                <h5>Explore</h5>
                <ul class="list-unstyled">
                    <li><a href="#about">Về chúng tôi</a></li>
                    <li><a href="#privacy">Chính sách bảo mật</a></li>
                    <li><a href="#terms">Điều khoản sử dụng</a></li>
                </ul>
            </div>
        </div>
    </footer>

    <script>
        // Example function to display posts related to a location
        function showPostsByLocation(location) {
            const postsContainer = document.querySelector(".related-posts .row");

            // Clear previous posts
            postsContainer.innerHTML = '';

            // Example posts data based on location
            const posts = {
                "Hà Nội": [
                    { title: "Du lịch Hà Nội", content: "Bài viết về du lịch Hà Nội..." },
                    { title: "Hà Nội mùa thu", content: "Khám phá vẻ đẹp Hà Nội..." }
                ],
                "Hồ Chí Minh": [
                    { title: "Cuộc sống Sài Gòn", content: "Bài viết về cuộc sống ở Hồ Chí Minh..." }
                ]
            };

            // Display posts for the selected location
            (posts[location] || []).forEach(post => {
                const postElement = document.createElement("div");
                postElement.classList.add("col-md-4", "mb-3");
                postElement.innerHTML = `
                    <div class="post p-3 border">
                        <h5>${post.title}</h5>
                        <p>${post.content}</p>
                    </div>
                `;
                postsContainer.appendChild(postElement);
            });
        }
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
