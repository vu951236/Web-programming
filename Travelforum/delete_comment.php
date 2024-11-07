<?php
session_start();
$config = include('config.php');

// Kết nối đến cơ sở dữ liệu
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

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_GET['commentId']) && isset($_GET['postId'])) {
    // Kiểm tra nếu commentId và postId có phải là số nguyên hợp lệ
    $commentId = $_GET['commentId'];
    $postId = $_GET['postId'];

    if (!is_numeric($commentId) || !is_numeric($postId)) {
        echo json_encode(['success' => false, 'message' => 'Tham số không hợp lệ']);
        exit();
    }

    // Kiểm tra nếu người dùng đã đăng nhập
    if (!isset($_SESSION['user_id'])) {
        echo json_encode(['success' => false, 'message' => 'Chưa đăng nhập']);
        exit();
    }

    // Lấy ID người dùng hiện tại từ session
    $currentUserId = $_SESSION['user_id'];

    // Kiểm tra quyền của người dùng (chỉ cho phép chủ bài viết xóa bình luận)
    $sql = "SELECT * FROM forumdetail WHERE id = :postId";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':postId', $postId);
    $stmt->execute();
    $post = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($post && $post['userid'] === $currentUserId) {
        // Người dùng là chủ bài viết, xóa bình luận
        $sqlDelete = "DELETE FROM forumcomment WHERE id = :commentId";
        $stmtDelete = $conn->prepare($sqlDelete);
        $stmtDelete->bindParam(':commentId', $commentId);

        if ($stmtDelete->execute()) {
            echo json_encode(['success' => true, 'message' => 'Xóa bình luận thành công']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Không thể xóa bình luận']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Không có quyền xóa bình luận']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Thiếu tham số']);
}

?>
