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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $postId = $input['post_id'];

    // Kiểm tra quyền xóa bài viết
    $stmt = $conn->prepare("SELECT userid, image FROM forumdetail WHERE id = :post_id");
    $stmt->execute(['post_id' => $postId]);
    $post = $stmt->fetch();

    if ($post && $post['userid'] == $_SESSION['user_id']) {
        try {
            // Bắt đầu giao dịch
            $conn->beginTransaction();

            // Xóa bình luận liên quan
            $deleteCommentsStmt = $conn->prepare("DELETE FROM forumcomment WHERE post_id = :post_id");
            $deleteCommentsStmt->execute(['post_id' => $postId]);

            // Xóa lượt thích liên quan
            $deleteLikesStmt = $conn->prepare("DELETE FROM post_likes WHERE post_id = :post_id");
            $deleteLikesStmt->execute(['post_id' => $postId]);

            // Xóa hình ảnh trong thư mục (nếu có)
            if (!empty($post['image'])) {
                $imagePath = __DIR__ . '/database/forum/' . basename($post['image']);
                if (file_exists($imagePath)) {
                    unlink($imagePath);
                }
            }

            // Xóa bài viết
            $deletePostStmt = $conn->prepare("DELETE FROM forumdetail WHERE id = :post_id");
            $deletePostStmt->execute(['post_id' => $postId]);

            // Hoàn tất giao dịch
            $conn->commit();

            echo json_encode(['success' => true]);
        } catch (Exception $e) {
            // Rollback nếu có lỗi
            $conn->rollBack();
            echo json_encode(['success' => false, 'message' => 'Lỗi khi xóa dữ liệu: ' . $e->getMessage()]);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Không có quyền xóa bài viết này.']);
    }
}
