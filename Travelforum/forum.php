<?php
session_start();
$config = include('config.php');

// Kết nối đến cơ sở dữ liệu
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

// Xử lý gửi bài viết
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action']) && $_POST['action'] === 'post_article') {
        $content = $_POST['content'] ?? '';
        $userId = $_SESSION['user_id'];

        // Xử lý ảnh
        $imagePath = null;
        if (isset($_FILES['post_image']) && $_FILES['post_image']['size'] > 0) {
            $imageFile = $_FILES['post_image'];
            $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION);
            $newImageName = uniqid('img_', true) . '.' . $extension;

            $uploadDir = __DIR__ . '/database/forum/';
            if (!file_exists($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }

            $uploadPath = $uploadDir . '/' . $newImageName;
            if (move_uploaded_file($imageFile['tmp_name'], $uploadPath)) {
                $imagePath = 'database/forum/' . $newImageName;
            }
        }

        // Thêm bài viết vào cơ sở dữ liệu
        $sql = "INSERT INTO forumdetail (userid, content, image, date, status) 
                VALUES (:userid, :content, :image, NOW(), 'notapproved')";
        $stmt = $conn->prepare($sql);
        $stmt->execute([
            ':userid' => $userId,
            ':content' => $content,
            ':image' => $imagePath
        ]);

        // Thông báo và làm mới trang
        $_SESSION['message'] = "Đăng bài thành công!";
        header("Location: forum.php");
        exit();
    }
}
// Khởi tạo mảng chứa dữ liệu bài viết
$postsData = [];

// Lấy ID người dùng từ session
$userId = $_SESSION['user_id'];  

// Lấy tham số filter từ URL
$filter = isset($_GET['filter']) ? $_GET['filter'] : 'all';

// Truy vấn cơ sở dữ liệu với bộ lọc
if ($filter == 'my_posts') {
    // Hiển thị bài viết của người dùng hiện tại
    $sqlPosts = "SELECT forumdetail.*, users.avatar, users.username, 
                        (SELECT COUNT(*) FROM forumcomment WHERE forumcomment.post_id = forumdetail.id) AS comment_count, 
                        forumdetail.likes_count
                 FROM forumdetail 
                 JOIN users ON forumdetail.userid = users.id 
                 WHERE forumdetail.userid = :userId
                 ORDER BY forumdetail.date DESC";
    $stmt = $conn->prepare($sqlPosts);
    $stmt->bindParam(':userId', $userId, PDO::PARAM_INT);
} else {
    // Kiểm tra xem người dùng có phải là admin không
    $sqlCheckAdmin = "SELECT isadmin FROM users WHERE id = :userId";
    $stmtCheckAdmin = $conn->prepare($sqlCheckAdmin);
    $stmtCheckAdmin->execute([':userId' => $userId]);
    $user = $stmtCheckAdmin->fetch(PDO::FETCH_ASSOC);

    // Kiểm tra nếu là admin, bỏ điều kiện WHERE
    if ($user && $user['isadmin'] == 1) {
        // Người dùng là admin, không cần điều kiện 'approve'
        $sqlPosts = "SELECT forumdetail.*, users.avatar, users.username, 
                            (SELECT COUNT(*) FROM forumcomment WHERE forumcomment.post_id = forumdetail.id) AS comment_count, 
                            forumdetail.likes_count
                     FROM forumdetail 
                     JOIN users ON forumdetail.userid = users.id
                     ORDER BY forumdetail.date DESC";
    } else {
        // Người dùng không phải admin, chỉ lấy bài đã phê duyệt
        $sqlPosts = "SELECT forumdetail.*, users.avatar, users.username, 
                            (SELECT COUNT(*) FROM forumcomment WHERE forumcomment.post_id = forumdetail.id) AS comment_count, 
                            forumdetail.likes_count
                     FROM forumdetail 
                     JOIN users ON forumdetail.userid = users.id 
                     WHERE forumdetail.status = 'approve' 
                     ORDER BY forumdetail.date DESC";
    }

    // Thực thi truy vấn SQL
    $stmt = $conn->prepare($sqlPosts);
}

// Thực thi truy vấn SQL và lấy kết quả
$stmt->execute();
$posts = $stmt->fetchAll(PDO::FETCH_ASSOC);


foreach ($posts as $post) {
    // Kiểm tra xem người dùng đã like bài viết này chưa
    $checkLikeSql = "SELECT COUNT(*) FROM post_likes WHERE post_id = :post_id AND user_id = :user_id";
    $checkStmt = $conn->prepare($checkLikeSql);
    $checkStmt->execute([':post_id' => $post['id'], ':user_id' => $userId]);
    $hasLiked = $checkStmt->fetchColumn() > 0;

    // Gửi thông tin trạng thái like cho mỗi bài viết
    $post['hasLiked'] = $hasLiked;

    // Thêm bài viết vào mảng dữ liệu
    $postsData[] = $post;
}
// Lấy danh sách thành viên tích cực
$sqlTopUsers = "SELECT id, username, avatar FROM users ORDER BY point DESC LIMIT 3";
$stmtTopUsers = $conn->prepare($sqlTopUsers);
$stmtTopUsers->execute();
$topUsers = $stmtTopUsers->fetchAll(PDO::FETCH_ASSOC);

function time_elapsed_string($datetime, $full = false) {
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $string = [
        'y' => 'năm',
        'm' => 'tháng',
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

    return $string ? implode(', ', $string) . ' trước' : 'vừa xong';
}
// Xử lý yêu cầu GET cho bài viết và bình luận
if (isset($_GET['post_id'])) {
    $postId = $_GET['post_id'];

    // Lấy thông tin bài viết và username của người đăng
    $sqlPost = "SELECT forumdetail.*, users.username, users.avatar 
                FROM forumdetail 
                JOIN users ON forumdetail.userid = users.id 
                WHERE forumdetail.id = :post_id";
    $stmtPost = $conn->prepare($sqlPost);
    $stmtPost->execute([':post_id' => $postId]);
    $post = $stmtPost->fetch(PDO::FETCH_ASSOC);

    // Kiểm tra và thay đổi avatar nếu là null
    if (empty($post['avatar']) || $post['avatar'] === 'null') {
        $post['avatar'] = 'asset/img/test.jpg';  // Đường dẫn mặc định nếu avatar không có
    }

    // Kiểm tra xem người dùng đã like bài viết này chưa
    $checkLikeSql = "SELECT COUNT(*) FROM post_likes WHERE post_id = :post_id AND user_id = :user_id";
    $checkStmt = $conn->prepare($checkLikeSql);
    $checkStmt->execute([':post_id' => $postId, ':user_id' => $userId]);
    $hasLiked = $checkStmt->fetchColumn() > 0;

    // Thêm trạng thái hasLiked vào dữ liệu bài viết
    $post['hasLiked'] = $hasLiked;

    // Lấy danh sách bình luận cùng với username của người bình luận
    $sqlComments = "SELECT forumcomment.*, users.username, users.avatar
                    FROM forumcomment 
                    JOIN users ON forumcomment.user_id = users.id 
                    WHERE forumcomment.post_id = :post_id";
    $stmtComments = $conn->prepare($sqlComments);
    $stmtComments->execute([':post_id' => $postId]);
    $comments = $stmtComments->fetchAll(PDO::FETCH_ASSOC);

    // Kiểm tra và thay đổi avatar cho các bình luận nếu là null
    foreach ($comments as &$comment) {
        if (empty($comment['avatar']) || $comment['avatar'] === 'null') {
            $comment['avatar'] = 'asset/img/test.jpg'; // Đường dẫn mặc định nếu avatar không có
        }
    }

    // Xóa bất kỳ khoảng trắng nào còn lại trước khi xuất JSON
    ob_end_clean();

    // Xuất JSON với trạng thái hasLiked và userid của người đăng bài
    echo json_encode([
        'post' => $post, 
        'comments' => $comments, 
        'hasLiked' => $hasLiked, 
        'user' => ['id' => $userId] // Thêm thông tin user hiện tại
    ]);
    exit();
}

?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diễn đàn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./asset/css/forum.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./asset/js/base.js"></script>
</head>
<body>
<?php include 'header.php'; ?>

<div class="container">
    <div class="row">
        <!-- Cột trái: Sidebar - Bộ lọc -->
        <div class="col-md-4">
            <div class="sidebar card mb-4 shadow-sm">
                <div class="card-body">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="forum.php?filter=all">Diễn đàn chung</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="forum.php?filter=my_posts">Bài viết của tôi</a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Thông tin thành viên tích cực -->
            <div class="sidebar card mb-4 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Thành viên tích cực</h5>
                    <ul class="list-unstyled">
                        <?php foreach ($topUsers as $user): ?>
                            <li class="d-flex align-items-center mb-3">
                                <a href="profile.php?userId=<?php echo htmlspecialchars($user['id']); ?>" class="d-flex align-items-center text-decoration-none text-dark">
                                    <img src="<?php echo htmlspecialchars($user['avatar'] ?? 'asset/img/test.jpg'); ?>" alt="<?php echo htmlspecialchars($user['username']); ?>" class="user-avatar rounded-circle" style="width: 40px; height: 40px;">
                                    <span class="user-name ms-3"><?php echo htmlspecialchars($user['username']); ?></span>
                                </a>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            </div>

        </div>

        <!-- Cột phải: Bài viết của người dùng -->
        <div class="col-md-8">
            <!-- Khu vực đăng bài viết mới -->
            <div class="new-post card mb-4 shadow-sm">
                <div class="card-body">
                    <form action="forum.php" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="post_article">
                        <div class="form-group">
                            <textarea name="content" class="form-control" placeholder="Bạn đang nghĩ gì?" rows="3" required></textarea>
                        </div>
                        <div class="form-group mt-2">
                            <input type="file" name="post_image" accept="image/*" class="form-control-file">
                        </div>
                        <button type="submit" class="btn btn-primary mt-3">Đăng</button>
                    </form>
                </div>
            </div>

            <!-- Các bài viết -->
            <?php foreach ($postsData as $post): ?>
                <div class="post card mb-4 shadow-sm" id="post-<?php echo $post['id']; ?>">
                    <div class="card-body">
                        <div class="post-header d-flex align-items-center mb-3">
                            <a href="profile.php?userId=<?php echo htmlspecialchars($post['userid']); ?>" class="text-decoration-none">
                                <img src="<?php echo htmlspecialchars($post['avatar'] ?? 'asset/img/test.jpg'); ?>" alt="Avatar" class="post-avatar rounded-circle" style="width: 40px; height: 40px;">
                            </a>

                            <div class="ms-3">
                                <div class="post-author"><?php echo htmlspecialchars($post['username']); ?></div>
                                <div class="post-time text-muted"><?php echo time_elapsed_string($post['date']); ?></div>
                            </div>
                            <button class="btn btn-sm btn-outline-secondary ms-auto" onclick="showCommentsModal(<?php echo $post['id']; ?>)">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>
                        <div class="post-content"><?php echo nl2br(htmlspecialchars($post['content'])); ?></div>
                        <?php if (!empty($post['image'])): ?>
                            <img src="<?php echo htmlspecialchars($post['image']); ?>" alt="Post Image" class="post-image img-fluid mt-3">
                        <?php endif; ?>
                        <div class="post-stats d-flex justify-content-between mt-3">
                            <span id="like-count-<?php echo $post['id']; ?>"><?php echo $post['likes_count']; ?> like</span>
                            <span id="comment-count-<?php echo $post['id']; ?>"><?php echo $post['comment_count']; ?> bình luận</span>
                        </div>
                        <div class="post-footer d-flex justify-content-between mt-3">
                            <button class="btn btn-outline-primary btn-sm like-button <?php echo $post['hasLiked'] ? 'liked' : ''; ?>" id="like-btn-<?php echo $post['id']; ?>" data-post-id="<?php echo $post['id']; ?>" onclick="toggleLike(<?php echo $post['id']; ?>)">
                                <i class="far fa-thumbs-up"></i> Thích
                            </button>
                            <button class="btn btn-outline-secondary btn-sm" onclick="showCommentsModal(<?php echo $post['id']; ?>)">
                                <i class="far fa-comment"></i> Bình luận
                            </button>
                            <button class="btn btn-outline-success btn-sm" onclick="copyLink(<?php echo $post['id']; ?>)">
                                <i class="fas fa-share"></i> Chia sẻ
                            </button>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>

            <!-- Modal Bình luận -->
            <div class="modal fade" id="commentsModal" tabindex="-1" aria-labelledby="commentsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="commentsModalLabel">Bài viết của <span id="modal-post-author"></span></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div id="modal-post-content">
                                <div id="modal-post-avatar" class="d-flex align-items-center mb-3"></div>
                                <div id="modal-post-text"></div>
                                <div id="modal-post-image" class="mt-3"></div>
                            </div>
                            <div class="post-stats d-flex justify-content-between mt-3" id="modal-post-stats"></div>
                            <div class="post-footer d-flex justify-content-between mt-3" id="modal-post-actions"></div>
                            <div id="comments-list"></div>
                            <form id="commentForm">
                                <textarea id="comment-input" name="comment_content" class="form-control" placeholder="Viết bình luận..." rows="3"></textarea>
                                <button type="submit" class="btn btn-primary mt-2">Gửi bình luận</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Modal Xác Nhận Xóa -->
<div id="confirmModal" class="modal">
    <div class="modal-content">
        <span id="modalCloseBtn" class="close">&times;</span>
        <p id="modalMessage"></p>
        <button id="confirmDeleteBtn">Xóa bình luận</button>
        <button id="cancelDeleteBtn">Hủy bỏ</button>
    </div>
</div>
<!-- Modal Thông Báo Thành Công -->
<div id="successModal" class="modal">
    <div class="modal-content">
        <span id="successModalCloseBtn" class="close">&times;</span>
        <p id="successModalMessage"></p>
    </div>
</div>
<!-- Modal Thông Báo Lỗi -->
<div id="errorModal" class="modal">
    <div class="modal-content">
        <span id="errorModalCloseBtn" class="close">&times;</span>
        <p id="errorModalMessage"></p>
    </div>
</div>

<script>
function copyLink(postId) {
    // Tạo đường dẫn URL của bài viết
    const postUrl = window.location.origin + '/Travelforum/Travelforum/forum.php#post-' + postId;

    // Tạo một thẻ input tạm thời để chứa URL
    const tempInput = document.createElement('input');
    tempInput.value = postUrl;
    document.body.appendChild(tempInput);

    // Chọn và sao chép giá trị của input
    tempInput.select();
    document.execCommand('copy');

    // Xóa thẻ input tạm thời
    document.body.removeChild(tempInput);

    // Hiển thị thông báo sao chép thành công
    alert('Đã sao chép liên kết bài viết!');
}
function showCommentsModal(postId) {
    // Kiểm tra xem có modal nào đang mở không
    const openModal = document.querySelector('.modal.show');
    if (openModal) {
        // Tìm và xóa lớp backdrop nếu có
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) {
            backdrop.remove(); // Xóa backdrop
        }
    }

    fetch('forum.php?post_id=' + postId)
        .then(response => response.json())
        .then(data => {
            console.log('hasLiked:', data.hasLiked); // Đảm bảo nhận đúng giá trị hasLiked từ server

            // Cập nhật modal với dữ liệu bài viết và bình luận
            updateModal(postId, data.likes_count, data.comment_count, data.hasLiked);

            // Làm sạch danh sách bình luận cũ trước khi thêm mới
            document.getElementById('comments-list').innerHTML = '';

            // Thông tin tác giả và nội dung bài viết
            document.getElementById('modal-post-author').innerText = data.post.username;
            document.getElementById('modal-post-avatar').innerHTML = `
              <img src="${data.post.avatar && data.post.avatar !== 'null' ? data.post.avatar : 'asset/img/test.jpg'}" alt="Avatar" class="post-avatar rounded-circle" style="width: 50px; height: 50px;">
                <div class="ms-3">
                    <div class="post-author">${data.post.username}</div>
                    <div class="post-time text-muted">${data.post.date}</div>
                </div>
            `;
            document.getElementById('modal-post-text').innerHTML = `<p>${data.post.content}</p>`;

            // Hiển thị ảnh nếu có
            if (data.post.image) {
                document.getElementById('modal-post-image').innerHTML = `<img src="${data.post.image}" alt="Post Image" class="post-image img-fluid rounded-3">`;
            } else {
                document.getElementById('modal-post-image').innerHTML = ''; // Xóa ảnh nếu không có
            }

            // Cập nhật số lượng like và bình luận
            document.getElementById('modal-post-stats').innerHTML = `
                <span>${data.post.likes_count} like</span>
                <span>${data.comments.length} bình luận</span>
            `;

            document.getElementById('modal-post-actions').innerHTML = `
                <button class="btn btn-outline-primary btn-sm like-button ${data.hasLiked ? 'liked' : ''}" id="like-btn-${postId}" data-post-id="${postId}" onclick="toggleLike(${postId})">
                    <i class="far fa-thumbs-up"></i> Thích
                </button>
                <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="collapse" data-bs-target="#commentFormContainer">
                    <i class="far fa-comment"></i> Bình luận
                </button>
                <button class="btn btn-outline-success btn-sm">
                    <i class="fas fa-share"></i> Chia sẻ
                </button>
            `;

            // Hiển thị bình luận
            let commentsHtml = '';
            data.comments.forEach(comment => {
                let deleteButton = '';
                // Kiểm tra nếu người dùng là chủ bài viết
                if (data.post.userid === data.user.id) {
                    deleteButton = `
                        <button class="btn btn-danger btn-sm" onclick="deleteComment(${comment.id}, ${postId})">Xóa bình luận</button>
                    `;
                }

                commentsHtml += `
                    <div class="comment d-flex mb-3">
                        <img src="${comment.avatar}" alt="Avatar" class="post-avatar rounded-circle" style="width: 50px; height: 50px;">
                        <div class="ms-3">
                            <strong>${comment.username}</strong>
                            <p class="mb-1">${comment.content}</p>
                            <span class="text-muted small">${comment.created_at}</span>
                            ${deleteButton}
                        </div>
                    </div>
                `;
            });
            document.getElementById('comments-list').innerHTML = commentsHtml;

            // Gán postId vào phần tử modal-post-content
            document.getElementById('modal-post-content').setAttribute('data-post-id', postId);

            // Hiển thị modal
            new bootstrap.Modal(document.getElementById('commentsModal')).show();
        })
        .catch(error => console.error('Error:', error));
}
function deleteComment(commentId, postId) {
    // Mở modal xác nhận xóa
    const modal = document.getElementById('confirmModal');
    const modalMessage = document.getElementById('modalMessage');
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
    
    modalMessage.innerText = 'Bạn có chắc chắn muốn xóa bình luận này không?';
    modal.style.display = 'block';  // Hiển thị modal xác nhận

    // Đóng modal khi nhấn vào nút đóng (X)
    document.getElementById('modalCloseBtn').onclick = function() {
        modal.style.display = 'none';
    }

    // Xử lý khi nhấn "Xóa bình luận"
    confirmDeleteBtn.onclick = function() {
        console.log('commentId:', commentId, 'postId:', postId);  // Kiểm tra giá trị tham số

        fetch('delete_comment.php?commentId=' + commentId + '&postId=' + postId, {
            method: 'POST'
        })
        .then(response => response.text())
        .then(text => {
            console.log('Phản hồi từ server:', text);
            try {
                const data = JSON.parse(text);
                modal.style.display = 'none';  // Đóng modal xác nhận sau khi xử lý

                // Hiển thị modal thông báo thành công
                if (data.success) {
                    const successModal = document.getElementById('successModal');
                    const successMessage = document.getElementById('successModalMessage');
                    successMessage.innerText = 'Xóa bình luận thành công';
                    successModal.style.display = 'block';

                    // Ẩn modal thành công sau 3 giây và reload trang
                    setTimeout(function() {
                        successModal.style.display = 'none';
                        location.reload();  
                    }, 1000);  // Reload trang sau khi xóa thành công
                } else {
                    const errorModal = document.getElementById('errorModal');
                    const errorMessage = document.getElementById('errorModalMessage');
                    errorMessage.innerText = 'Có lỗi xảy ra khi xóa bình luận';
                    errorModal.style.display = 'block';

                    document.getElementById('errorModalCloseBtn').onclick = function() {
                        errorModal.style.display = 'none';
                    }
                }
            } catch (error) {
                console.error('Lỗi khi phân tích cú pháp JSON:', error);
                const errorModal = document.getElementById('errorModal');
                const errorMessage = document.getElementById('errorModalMessage');
                errorMessage.innerText = 'Lỗi khi phân tích JSON: ' + error.message;
                errorModal.style.display = 'block';

                document.getElementById('errorModalCloseBtn').onclick = function() {
                    errorModal.style.display = 'none';
                }
            }
        })
        .catch(error => {
            console.error('Lỗi:', error);
            const errorModal = document.getElementById('errorModal');
            const errorMessage = document.getElementById('errorModalMessage');
            errorMessage.innerText = 'Lỗi: ' + error.message;
            errorModal.style.display = 'block';

            document.getElementById('errorModalCloseBtn').onclick = function() {
                errorModal.style.display = 'none';
            }
            modal.style.display = 'none';  // Đóng modal xác nhận nếu có lỗi
        });
    }

    // Đóng modal khi nhấn "Hủy bỏ"
    cancelDeleteBtn.onclick = function() {
        modal.style.display = 'none';
    }
}

function toggleLike(postId) {
    // Gửi yêu cầu tới server để thay đổi trạng thái like
    fetch('like_post.php', {
        method: 'POST',
        body: JSON.stringify({ like_post_id: postId }),
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Cập nhật trạng thái "liked" của nút like ngay lập tức trên trang chính
            updateLikeButton(postId, data.hasLiked, data.likes_count);

            // Kiểm tra xem modal có đang mở không
            if (isModalOpen()) {
                // Cập nhật trạng thái "liked" trong modal ngay lập tức
                showCommentsModal(postId);
            }
        }
    })
    .catch(error => console.error('Error:', error));
}

// Cập nhật trạng thái "liked" trong modal và số lượng like, bình luận
function updateModal(postId, likesCount, commentCount, hasLiked) {
    const likeButton = document.getElementById('like-btn-' + postId);
    const likeCountElement = document.getElementById('modal-post-stats');

    // Cập nhật nút like trong modal ngay lập tức
    if (hasLiked) {
        likeButton.classList.add('liked'); // Thêm lớp 'liked'
    } else {
        likeButton.classList.remove('liked'); // Xóa lớp 'liked'
    }

    // Cập nhật số lượng like và bình luận trong modal
    likeCountElement.innerHTML = `
        <span>${likesCount} like</span>
        <span>${commentCount} bình luận</span>
    `;
}

// Hàm để kiểm tra xem modal có đang mở hay không
function isModalOpen() {
    const modal = document.getElementById('commentsModal');
    return modal && modal.classList.contains('show');
}



// Hàm để cập nhật nút like và số lượng like ngoài modal
function updateLikeButton(postId, hasLiked, likesCount) {
    const likeButton = document.getElementById('like-btn-' + postId);
    const likeCount = document.getElementById('like-count-' + postId);

    if (hasLiked) {
        likeButton.classList.add('liked'); // Thêm lớp 'liked'
    } else {
        likeButton.classList.remove('liked'); // Xóa lớp 'liked'
    }

    likeCount.textContent = likesCount + ' like'; // Cập nhật số lượng like
}


document.addEventListener('DOMContentLoaded', function () {
    // Xử lý gửi bình luận mới
    document.getElementById('commentForm').addEventListener('submit', function (e) {
        e.preventDefault();

        // Lấy ID bài viết từ phần tử modal
        const postId = document.getElementById('modal-post-content')?.getAttribute('data-post-id');
        if (!postId) {
            alert('Không tìm thấy ID bài viết');
            return;
        }

        const commentContent = document.getElementById('comment-input').value;
        
        // Giả sử bạn đã có một hàm để gửi yêu cầu và nhận phản hồi
        fetch('comment_post.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                post_id: postId,
                content: commentContent
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const likesCountElement = document.getElementById('modal-post-stats');
                likesCountElement.innerHTML = 
                    `<span>${data.likes_count} like</span>
                    <span>${data.comment_count} bình luận</span>`
                ;
                
                // Chỉ thêm bình luận mới vào đầu danh sách, không làm lại tất cả bình luận
                const commentsContainer = document.getElementById('comments-list');
                
                // Lấy bình luận mới từ server và thêm vào đầu danh sách
                const newComment = data.new_comment; // Đây là bình luận mới trả về từ server

                const commentElement = document.createElement('div');
                commentElement.classList.add('comment', 'd-flex', 'mb-3');
                commentElement.innerHTML = 
                    `<img src="${newComment.avatar}" alt="Avatar" class="post-avatar rounded-circle" style="width: 50px; height: 50px;">
                    <div class="ms-3">
                        <strong>${newComment.username}</strong>
                        <p class="mb-1">${newComment.content}</p>
                        <span class="text-muted small">${newComment.created_at}</span>
                    </div>`;
                commentsContainer.prepend(commentElement); // Thêm bình luận mới lên đầu danh sách
                 // Cập nhật số lượng bình luận bên ngoài bài viết
                 document.getElementById(`comment-count-${postId}`).innerText = `${data.comment_count} bình luận`;
            } else {
                alert("Không thể cập nhật bình luận.");
            }
        })
        .catch(error => console.error('Error:', error));
    });
});

</script>

</body>
</html>

