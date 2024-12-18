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

// Kiểm tra xem có yêu cầu AJAX từ phía client không
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu từ AJAX
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['like_post_id'])) {
        $postId = $data['like_post_id'];
        $userId = $_SESSION['user_id'];  // Giả sử bạn đã có session của người dùng

        // Kiểm tra userid của bài viết
        $postOwnerSql = "SELECT userid FROM forumdetail WHERE id = :post_id";
        $postOwnerStmt = $conn->prepare($postOwnerSql);
        $postOwnerStmt->execute([':post_id' => $postId]);
        $postOwnerId = $postOwnerStmt->fetchColumn();

        // Kiểm tra xem người dùng đã like bài viết chưa
        $checkLikeSql = "SELECT COUNT(*) FROM post_likes WHERE post_id = :post_id AND user_id = :user_id";
        $checkStmt = $conn->prepare($checkLikeSql);
        $checkStmt->execute([':post_id' => $postId, ':user_id' => $userId]);
        $hasLiked = $checkStmt->fetchColumn() > 0;

        // 1. Lấy tổng số like trước khi cập nhật
        $totalLikesBeforeSql = "SELECT COALESCE(SUM(likes_count), 0) AS totalLikes FROM forumdetail WHERE userid = :user_id";
        $totalLikesBeforeStmt = $conn->prepare($totalLikesBeforeSql);
        $totalLikesBeforeStmt->execute([':user_id' => $postOwnerId]);
        $totalLikesBefore = $totalLikesBeforeStmt->fetchColumn();

        if ($hasLiked) {
            // Nếu người dùng đã like, xóa like
            $deleteLikeSql = "DELETE FROM post_likes WHERE post_id = :post_id AND user_id = :user_id";
            $deleteStmt = $conn->prepare($deleteLikeSql);
            $deleteStmt->execute([':post_id' => $postId, ':user_id' => $userId]);
        
            // Giảm số lượt like trong bảng forumdetail
            $updateLikeSql = "UPDATE forumdetail SET likes_count = likes_count - 1 WHERE id = :post_id";
            $updateStmt = $conn->prepare($updateLikeSql);
            $updateStmt->execute([':post_id' => $postId]);
        } else {
            // Nếu người dùng chưa like, thêm like
            $insertLikeSql = "INSERT INTO post_likes (post_id, user_id) VALUES (:post_id, :user_id)";
            $insertStmt = $conn->prepare($insertLikeSql);
            $insertStmt->execute([':post_id' => $postId, ':user_id' => $userId]);
        
            // Tăng số lượt like trong bảng forumdetail
            $updateLikeSql = "UPDATE forumdetail SET likes_count = likes_count + 1 WHERE id = :post_id";
            $updateStmt = $conn->prepare($updateLikeSql);
            $updateStmt->execute([':post_id' => $postId]);
        }
        // Lấy số lượt like mới của bài viết
        $likeCountSql = "SELECT likes_count FROM forumdetail WHERE id = :post_id";
        $likeCountStmt = $conn->prepare($likeCountSql);
        $likeCountStmt->execute([':post_id' => $postId]);
        $likeCount = $likeCountStmt->fetchColumn();

        // Lấy số lượng bình luận từ bảng forumcomment
        $commentCountSql = "SELECT COUNT(*) FROM forumcomment WHERE post_id = :post_id";
        $commentCountStmt = $conn->prepare($commentCountSql);
        $commentCountStmt->execute([':post_id' => $postId]);
        $commentCount = $commentCountStmt->fetchColumn();

        // Tính toán lại điểm của người dùng
        
        // 2. Lấy điểm hiện tại của người dùng
        $currentPointSql = "SELECT point FROM users WHERE id = :user_id";
        $currentPointStmt = $conn->prepare($currentPointSql);
        $currentPointStmt->execute([':user_id' => $postOwnerId]);
        $currentPoint = $currentPointStmt->fetchColumn();
        
        // 3. Tính tổng số like sau khi cập nhật
        $totalLikesAfterSql = "SELECT COALESCE(SUM(likes_count), 0) AS totalLikes FROM forumdetail WHERE userid = :user_id";
        $totalLikesAfterStmt = $conn->prepare($totalLikesAfterSql);
        $totalLikesAfterStmt->execute([':user_id' => $postOwnerId]);
        $totalLikesAfter = $totalLikesAfterStmt->fetchColumn();
        
        // 4. Tính toán điểm mới
        $newPoint = $currentPoint - ($totalLikesBefore * 0.1) + ($totalLikesAfter * 0.1);
        
        // 5. Cập nhật điểm mới vào bảng users
        $updatePointSql = "UPDATE users SET point = :point WHERE id = :user_id";
        $updatePointStmt = $conn->prepare($updatePointSql);
        $updatePointStmt->execute([
            ':point' => $newPoint,
            ':user_id' => $postOwnerId
        ]);
               

        // Trả về kết quả dưới dạng JSON
        echo json_encode([
            'success' => true,
            'likes_count' => $likeCount,
            'comment_count' => $commentCount,
            'hasLiked' => !$hasLiked
        ]);
    }
}

