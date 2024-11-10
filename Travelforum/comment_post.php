<?php
session_start();
// Bắt đầu bộ đệm đầu ra
ob_start();
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

// Xử lý yêu cầu POST cho thêm bình luận
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $postId = $data['post_id'];
    $commentContent = $data['content'];

    // Kiểm tra nếu người dùng đã đăng nhập
    if (!isset($_SESSION['user_id'])) {
        ob_end_clean();
        echo json_encode(['success' => false, 'message' => 'Bạn cần đăng nhập để bình luận']);
        exit();
    }

    $userId = $_SESSION['user_id'];

    if (!empty($commentContent)) {
        // Chèn bình luận vào cơ sở dữ liệu
        $sqlInsertComment = "INSERT INTO forumcomment (post_id, user_id, content, created_at) 
                             VALUES (:post_id, :user_id, :content, NOW())";
        $stmtInsert = $conn->prepare($sqlInsertComment);
        $stmtInsert->execute([ 
            ':post_id' => $postId, 
            ':user_id' => $userId, 
            ':content' => $commentContent 
        ]);

        // Lấy thông tin bình luận mới từ bảng forumcomment
        $sqlNewComment = "
            SELECT 
                fc.content, 
                fc.created_at, 
                u.username, 
                u.avatar
            FROM 
                forumcomment fc
            JOIN 
                users u ON fc.user_id = u.id
            WHERE 
                fc.post_id = :post_id
            ORDER BY 
                fc.created_at DESC
            LIMIT 1";  // Lấy chỉ bình luận mới nhất
        $stmtNewComment = $conn->prepare($sqlNewComment);
        $stmtNewComment->execute([':post_id' => $postId]);
        $newComment = $stmtNewComment->fetch(PDO::FETCH_ASSOC);

        // Lấy số lượt thích của bài viết từ bảng forumdetail
        $sqlLikesCount = "SELECT likes_count FROM forumdetail WHERE id = :post_id";
        $stmtLikesCount = $conn->prepare($sqlLikesCount);
        $stmtLikesCount->execute([':post_id' => $postId]);
        $likesCount = $stmtLikesCount->fetchColumn();

        // Kiểm tra nếu có bình luận mới
        if ($newComment) {
            $newComment['avatar'] = $newComment['avatar'] ?: 'asset/img/test.jpg'; // Sử dụng avatar mặc định nếu không có

            // Lấy số lượng bình luận của bài viết
            $sqlCommentCount = "SELECT COUNT(*) FROM forumcomment WHERE post_id = :post_id";
            $stmtCount = $conn->prepare($sqlCommentCount);
            $stmtCount->execute([':post_id' => $postId]);
            $commentCount = $stmtCount->fetchColumn();

            ob_end_clean();
            echo json_encode([
                'success' => true,
                'comment_count' => $commentCount,
                'likes_count' => $likesCount, // Trả về likes_count riêng biệt
                'new_comment' => $newComment  // Trả về bình luận mới
            ]);
        } else {
            ob_end_clean();
            echo json_encode(['success' => false, 'message' => 'Lỗi khi lấy bình luận mới']);
        }
    } else {
        ob_end_clean();
        echo json_encode(['success' => false, 'message' => 'Nội dung bình luận không được để trống']);
    }
    exit();
}
