<?php
session_start();

// Bao gồm tệp cấu hình
$config = include('config.php');

// Kiểm tra xem có thông tin cấu hình cơ sở dữ liệu không
if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

try {
    // Tạo kết nối đến cơ sở dữ liệu
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    // Thiết lập chế độ lỗi cho PDO
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Thông báo kết nối thành công
    $message = "Kết nối đến cơ sở dữ liệu thành công.";
} catch (PDOException $e) {
    // Nếu có lỗi xảy ra, lưu thông báo lỗi
    $message = "Kết nối thất bại: " . $e->getMessage();
}

// 1. Đếm tổng số user
$userCountQuery = "SELECT COUNT(*) as total_users FROM users";
$userCountStmt = $pdo->query($userCountQuery);
$userCount = $userCountStmt->fetch(PDO::FETCH_ASSOC)['total_users'];

// 2. Truy vấn tổng số bài viết
$totalPostCountQuery = "SELECT COUNT(*) as total_posts FROM postdetail";
$totalPostCountStmt = $pdo->query($totalPostCountQuery);
$totalPostCount = $totalPostCountStmt->fetch(PDO::FETCH_ASSOC)['total_posts'];

// 3. Số người đăng nhập theo tháng và năm
$loginCountQuery = "
    SELECT 
        YEAR(login_time) AS year,
        MONTH(login_time) AS month,
        COUNT(*) AS login_count
    FROM login_attempts
    GROUP BY YEAR(login_time), MONTH(login_time)
    ORDER BY year DESC, month DESC";
$loginCountStmt = $pdo->query($loginCountQuery);
$loginCounts = $loginCountStmt->fetchAll(PDO::FETCH_ASSOC);

// 4. Đếm số bài post theo tháng và năm
$postCountQuery = "
    SELECT 
        YEAR(date) AS year,
        MONTH(date) AS month,
        COUNT(*) AS post_count
    FROM postdetail
    GROUP BY YEAR(date), MONTH(date)
    ORDER BY year DESC, month DESC";
$postCountStmt = $pdo->query($postCountQuery);
$postCounts = $postCountStmt->fetchAll(PDO::FETCH_ASSOC);

// Dữ liệu cho biểu đồ
$loginCounts = array_map(function($row) {
    $row['month_year'] = $row['year'] . '-' . $row['month'];
    return $row;
}, $loginCounts);

$postCounts = array_map(function($row) {
    $row['month_year'] = $row['year'] . '-' . $row['month'];
    return $row;
}, $postCounts);


// Kiểm tra xem có thông tin người dùng trong session không
if (isset($_SESSION['user_id'])) {
    $userId = $_SESSION['user_id']; // Lấy ID người dùng từ session

    // Lấy thông tin người dùng từ cơ sở dữ liệu
    $userQuery = "SELECT status, isadmin FROM users WHERE id = ?";
    $userStmt = $pdo->prepare($userQuery); 
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

    // Kiểm tra quyền admin
    if (!isset($user['isadmin']) || $user['isadmin'] == false) {
        // Nếu không phải là admin, chuyển hướng đến login
        header("Location: login.php");
    }
    
} else {
    // Nếu không có thông tin người dùng trong session, đặt trạng thái là rỗng
    $userStatus = '';
    header("Location: login.php");
    exit();
}

// Biến để lưu phần nội dung
$section = '';

// Tiến hành truy vấn nếu kết nối thành công
if ($message === "Kết nối đến cơ sở dữ liệu thành công.") {
    // Kiểm tra status từ GET
    $userstatus = $_GET['UserStatus'] ?? 'all';
    $poststatus = $_GET['PostStatus'] ?? 'all';
    $forumstatus = $_GET['ForumStatus'] ?? 'all';

    // Lọc theo status
    if ($userstatus === 'warned') {
        $userQuery = "SELECT * FROM users WHERE id != :id AND status = 'warned' ORDER BY id";
    } elseif ($userstatus === 'banned') {
        $userQuery = "SELECT * FROM users WHERE id != :id AND status = 'banned' ORDER BY id";
    } else {
        $userQuery = "SELECT * FROM users WHERE id != :id ORDER BY id";
    }

    $userStmt = $pdo->prepare($userQuery);
    $userStmt->execute(['id' => $userId]); // Thay thế :id bằng $currentUserId
    $users = $userStmt->fetchAll(PDO::FETCH_ASSOC);


    // Lọc theo status
    if ($poststatus === 'cancel') {
        $postQuery = "SELECT * FROM postdetail WHERE status = 'canceled' Order by id";
    } elseif ($poststatus === 'notapproved') {
        $postQuery = "SELECT * FROM postdetail WHERE status = 'notapproved' Order by id";
    } elseif ($poststatus === 'approved') {
        $postQuery = "SELECT * FROM postdetail WHERE status = 'approve' Order by id";
    } else {
        $postQuery = "SELECT * FROM postdetail Order by id";
    }

    $postStmt = $pdo->prepare($postQuery);
    $postStmt->execute();
    $posts = $postStmt->fetchAll(PDO::FETCH_ASSOC);

    // Lọc theo status của bài đăng
    if ($forumstatus === 'cancel') {
        $forumQuery = "SELECT * FROM forumdetail WHERE status = 'canceled' ORDER BY id";
    } elseif ($forumstatus === 'notapproved') {
        $forumQuery = "SELECT * FROM forumdetail WHERE status = 'notapproved' ORDER BY id";
    } elseif ($forumstatus === 'approved') {
        $forumQuery = "SELECT * FROM forumdetail WHERE status = 'approve' ORDER BY id";
    } else {
        $forumQuery = "SELECT * FROM forumdetail ORDER BY id";
    }

    $forumStmt = $pdo->prepare($forumQuery);
    $forumStmt->execute();
    $forums = $forumStmt->fetchAll(PDO::FETCH_ASSOC);

}


if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['action']) && $_POST['action'] === 'ban') {
    $userId = $_POST['user_id'];
    $banTime = $_POST['ban_time']; // Thời gian cấm tính bằng phút

    // Tính toán thời gian hết hạn
    $bannerUntil = date('Y-m-d H:i:s', strtotime("+$banTime minutes"));

    // Tính toán warned_until (gấp đôi thời gian banTime)
    $warnedUntil = date('Y-m-d H:i:s', strtotime("+".(2 * $banTime)." minutes"));

    // Cập nhật cột banned_until, warned_until và status trong bảng người dùng
    $sql = "UPDATE users SET banned_until = ?, warned_until = ?, status = 'banned' WHERE id = ?";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$bannerUntil, $warnedUntil, $userId]);

    // Thông báo hoặc chuyển hướng sau khi cấm thành công
    $_SESSION['section'] = 'userManagement';
    header("Location: admin.php"); // Đổi thành trang trước đó
    exit();
}

// Xử lý yêu cầu hủy cấm người dùng
if (isset($_POST['action']) && $_POST['action'] == 'unban') {
    $userId = $_POST['user_id'];

    // Xóa thời gian cấm (banned_until) và giảm thời gian cảnh cáo xuống còn 5 phút
    $sql = "UPDATE users SET banned_until = NULL, warned_until = ?, status = 'warned' WHERE id = ?";
    
    // Tính toán warned_until (giảm xuống còn 5 phút)
    $warnedUntil = date('Y-m-d H:i:s', strtotime("+5 minutes"));

    $stmt = $pdo->prepare($sql);
    $stmt->execute([$warnedUntil, $userId]);

    // Thông báo hoặc chuyển hướng sau khi hủy cấm thành công
    $_SESSION['section'] = 'userManagement';
    header("Location: admin.php");
    exit();
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Kết nối PDO giả định: $pdo đã được khởi tạo trước đó

    if (isset($_POST['update_statusp'])) {
        $postId = $_POST['post_id'];
        $status = $_POST['status']; // Lấy trạng thái từ form

        // Cập nhật trạng thái bài viết
        $updateQuery = "UPDATE postdetail SET status = :status WHERE id = :id";
        $stmt = $pdo->prepare($updateQuery);
        $stmt->execute([':status' => $status, ':id' => $postId]);

        // Tải lại trang sau khi cập nhật
        header("Location: " . $_SERVER['PHP_SELF']);
        exit();
    }

    if (isset($_POST['delete_post'])) {
        $postId = $_POST['post_id'];
    
        try {
            // Bắt đầu giao dịch
            $pdo->beginTransaction();
    
            // Truy vấn để lấy đường dẫn ảnh của bài viết
            $getImageQuery = "SELECT image FROM postdetail WHERE id = :post_id";
            $stmtImage = $pdo->prepare($getImageQuery);
            $stmtImage->execute([':post_id' => $postId]);
            $imagePath = $stmtImage->fetchColumn();
    
            // Xóa ảnh khỏi thư mục nếu tồn tại
            if ($imagePath) {
                $imageFullPath = __DIR__ . '/database/posts/' . basename($imagePath);
                if (file_exists($imageFullPath)) {
                    unlink($imageFullPath);
                }
            }
    
            // Xóa các bình luận liên quan đến bài viết trong bảng postcomment
            $deleteCommentsQuery = "DELETE FROM postcomment WHERE idpost = :post_id";
            $stmtComments = $pdo->prepare($deleteCommentsQuery);
            $stmtComments->execute([':post_id' => $postId]);
    
            // Xóa các đánh giá liên quan đến bài viết trong bảng post_ratings
            $deleteRatingsQuery = "DELETE FROM post_ratings WHERE post_id = :post_id";
            $stmtRatings = $pdo->prepare($deleteRatingsQuery);
            $stmtRatings->execute([':post_id' => $postId]);
    
            // Xóa bài viết khỏi bảng postdetail
            $deletePostQuery = "DELETE FROM postdetail WHERE id = :id";
            $stmtPost = $pdo->prepare($deletePostQuery);
            $stmtPost->execute([':id' => $postId]);
    
            // Hoàn tất giao dịch
            $pdo->commit();
    
            // Tải lại trang sau khi xóa
            header("Location: " . $_SERVER['PHP_SELF']);
            exit();
        } catch (Exception $e) {
            // Rollback giao dịch nếu có lỗi
            $pdo->rollBack();
            die("Lỗi khi xóa bài viết: " . $e->getMessage());
        }
    }    
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Kiểm tra xem yêu cầu là cập nhật trạng thái hay xóa
    if (isset($_POST['update_status'])) {
        $forumId = $_POST['forum_id']; // Lấy ID bài viết
        $status = $_POST['status'];   // Trạng thái từ form

        // Cập nhật trạng thái bài viết trong bảng forumdetail
        $updateQuery = "UPDATE forumdetail SET status = :status WHERE id = :id";
        $stmt = $pdo->prepare($updateQuery);
        $stmt->execute([':status' => $status, ':id' => $forumId]);

        // Tải lại trang sau khi cập nhật
        header("Location: " . $_SERVER['PHP_SELF']);
        exit();
    }

    if (isset($_POST['delete_forum'])) {
        $forumId = $_POST['forum_id']; // Lấy ID bài viết
    
        try {
            // Bắt đầu giao dịch
            $pdo->beginTransaction();
    
            // Truy vấn để lấy đường dẫn ảnh của bài viết
            $getImageQuery = "SELECT image FROM forumdetail WHERE id = :forum_id";
            $stmtImage = $pdo->prepare($getImageQuery);
            $stmtImage->execute([':forum_id' => $forumId]);
            $imagePath = $stmtImage->fetchColumn();
    
            // Xóa ảnh khỏi thư mục nếu tồn tại
            if ($imagePath) {
                $imageFullPath = __DIR__ . '/database/forum/' . basename($imagePath);
                if (file_exists($imageFullPath)) {
                    unlink($imageFullPath);
                }
            }
    
            // Xóa các bình luận liên quan trong bảng forumcomment
            $deleteCommentsQuery = "DELETE FROM forumcomment WHERE post_id = :forum_id";
            $stmtComments = $pdo->prepare($deleteCommentsQuery);
            $stmtComments->execute([':forum_id' => $forumId]);
    
            // Xóa các lượt thích liên quan trong bảng post_likes
            $deleteLikesQuery = "DELETE FROM post_likes WHERE post_id = :forum_id";
            $stmtLikes = $pdo->prepare($deleteLikesQuery);
            $stmtLikes->execute([':forum_id' => $forumId]);
    
            // Xóa bài viết khỏi bảng forumdetail
            $deleteQuery = "DELETE FROM forumdetail WHERE id = :id";
            $stmt = $pdo->prepare($deleteQuery);
            $stmt->execute([':id' => $forumId]);
    
            // Xác nhận giao dịch
            $pdo->commit();
    
            // Tải lại trang sau khi xóa
            header("Location: " . $_SERVER['PHP_SELF']);
            exit();
        } catch (Exception $e) {
            // Hủy giao dịch nếu có lỗi
            $pdo->rollBack();
            echo "Lỗi khi xóa bài viết: " . $e->getMessage();
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'deleteaccount') {
    $userId = $_POST['account_id'];

    try {
        // Bắt đầu giao dịch
        $pdo->beginTransaction();

        // Xóa ảnh đại diện của người dùng trong thư mục database/users
        $stmt = $pdo->prepare("SELECT avatar FROM users WHERE id = :userid");
        $stmt->execute(['userid' => $userId]);
        $userAvatar = $stmt->fetchColumn();
        if ($userAvatar) {
            $userAvatarPath = __DIR__ . '/database/users/' . basename($userAvatar);
            if (file_exists($userAvatarPath)) {
                unlink($userAvatarPath);
            }
        }

        // Xóa tất cả ảnh bài viết trong bảng postdetail và thư mục database/posts
        $stmt = $pdo->prepare("SELECT image FROM postdetail WHERE userid = :userid");
        $stmt->execute(['userid' => $userId]);
        $postImages = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($postImages as $postImage) {
            if ($postImage) {
                $postImagePath = __DIR__ . '/database/posts/' . basename($postImage);
                if (file_exists($postImagePath)) {
                    unlink($postImagePath);
                }
            }
        }

        // Xóa tất cả ảnh bài đăng trong bảng forumdetail và thư mục database/forum
        $stmt = $pdo->prepare("SELECT image FROM forumdetail WHERE userid = :userid");
        $stmt->execute(['userid' => $userId]);
        $forumImages = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($forumImages as $forumImage) {
            if ($forumImage) {
                $forumImagePath = __DIR__ . '/database/forum/' . basename($forumImage);
                if (file_exists($forumImagePath)) {
                    unlink($forumImagePath);
                }
            }
        }

        // Xóa các bản ghi liên quan trong cơ sở dữ liệu
        $deleteLocationRatingStmt = $pdo->prepare("DELETE FROM location_ratings WHERE user_id = :userid");
        $deleteLocationRatingStmt->execute(['userid' => $userId]);

        $deletePostRatingStmt = $pdo->prepare("DELETE FROM post_ratings WHERE user_id = :userid");
        $deletePostRatingStmt->execute(['userid' => $userId]);

        $deletePostLikeStmt = $pdo->prepare("DELETE FROM post_likes WHERE user_id = :userid");
        $deletePostLikeStmt->execute(['userid' => $userId]);

        $deleteLocationCommentsStmt = $pdo->prepare("DELETE FROM locationcomment WHERE userid = :userid");
        $deleteLocationCommentsStmt->execute(['userid' => $userId]);

        $deletePostCommentsStmt = $pdo->prepare("DELETE FROM postcomment WHERE userid = :userid");
        $deletePostCommentsStmt->execute(['userid' => $userId]);

        $deleteForumCommentsStmt = $pdo->prepare("DELETE FROM forumcomment WHERE user_id = :userid");
        $deleteForumCommentsStmt->execute(['userid' => $userId]);

        $deletePostsStmt = $pdo->prepare("DELETE FROM postdetail WHERE userid = :userid");
        $deletePostsStmt->execute(['userid' => $userId]);

        $deleteForumStmt = $pdo->prepare("DELETE FROM forumdetail WHERE userid = :userid");
        $deleteForumStmt->execute(['userid' => $userId]);

        $deleteAttemptsStmt = $pdo->prepare("DELETE FROM login_attempts WHERE user_id = :user_id");
        $deleteAttemptsStmt->execute([':user_id' => $userId]);

        $deleteUserStmt = $pdo->prepare("DELETE FROM users WHERE id = :id");
        $deleteUserStmt->execute([':id' => $userId]);

        // Hoàn tất giao dịch
        $pdo->commit();

        $_SESSION['section'] = 'userManagement';
        header("Location: admin.php"); // Chuyển hướng về trang chính hoặc trang đăng nhập
        exit;
    } catch (Exception $e) {
        // Rollback nếu có lỗi
        $pdo->rollBack();
        die("Lỗi khi xóa dữ liệu: " . $e->getMessage());
    }
}

// Xử lý tạo mã admin
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['adminCode'])) {
    $adminCode = $_POST['adminCode'];

    // Kiểm tra tính hợp lệ của mã
    if (!empty($adminCode)) {
        // Thời gian hết hạn là 5 phút sau
        $expirationTime = date('Y-m-d H:i:s', strtotime('+5 minutes'));

        // Chuẩn bị câu SQL để lưu mã admin vào cơ sở dữ liệu
        $sql = "INSERT INTO admincode (code, expiration_time) VALUES (?, ?)";
        $stmt = $pdo->prepare($sql);

        // Thực thi truy vấn
        if ($stmt->execute([$adminCode, $expirationTime])) {
            $_SESSION['message'] = "Mã admin được tạo thành công! Hãy sử dụng trong 5 phút.";
        } else {
            $_SESSION['message'] = "Có lỗi xảy ra khi tạo mã!";
        }
    } else {
        $_SESSION['message'] = "Vui lòng nhập mã admin!";
    }
}
// Kiểm tra và lưu trạng thái nút vào session
if (isset($_GET['UserStatus'])) {
    $_SESSION['UserStatus'] = $_GET['UserStatus'];
} else {
    // Mặc định trạng thái là 'all'
    if (!isset($_SESSION['UserStatus'])) {
        $_SESSION['UserStatus'] = 'all';
    }
}
// Kiểm tra và lưu trạng thái nút vào session
if (isset($_GET['PostStatus'])) {
    $_SESSION['PostStatus'] = $_GET['PostStatus'];
} else {
    // Mặc định trạng thái là 'all'
    if (!isset($_SESSION['PostStatus'])) {
        $_SESSION['PostStatus'] = 'all';
    }
}
// Kiểm tra và lưu trạng thái nút vào session
if (isset($_GET['ForumStatus'])) {
    $_SESSION['ForumStatus'] = $_GET['ForumStatus'];
} else {
    // Mặc định trạng thái là 'all'
    if (!isset($_SESSION['ForumStatus'])) {
        $_SESSION['ForumStatus'] = 'all';
    }
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin TravelTalk</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/admin.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <style>
        h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        /* Đảm bảo các phần tử nằm trên cùng một hàng */
        .dashboard-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap; /* Cho phép các phần tử xuống dòng nếu không đủ không gian */
        }

        /* Bố cục riêng cho top row */
        .top-row {
            margin-bottom: 30px; /* Tạo khoảng cách giữa top và bottom row */
        }

        /* Bố cục riêng cho bottom row */
        .bottom-row {
            margin-top: 30px;
        }

        /* Kiểu cho phần Tổng số người dùng */
        .user-count, .post-count {
            display: flex;             /* Sử dụng Flexbox */
            flex-direction: column;    /* Đặt các phần tử theo chiều dọc */
            justify-content: center;   /* Căn giữa theo chiều dọc */
            align-items: center;       /* Căn giữa theo chiều ngang */
            height: 150px;             /* Đảm bảo div có chiều cao đủ để căn giữa nội dung */
            padding: 20px;             /* Khoảng cách xung quanh */
            background-color: #f0f0f0; /* Màu nền cho div */
            border-radius: 8px;        /* Bo góc div */
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); /* Thêm bóng mờ */
            flex: 1;                   /* Cho phép phần tử chiếm 1 phần không gian trong flex container */
            min-width: 250px;          /* Đảm bảo phần tử không nhỏ hơn 250px */
        }

        .user-count h3, .post-count h3 {
            font-size: 24px; /* Tăng kích thước chữ cho tiêu đề */
            color: #333;     /* Màu chữ tiêu đề */
            margin-bottom: 10px; /* Khoảng cách giữa tiêu đề và số người dùng */
            text-align: center;  /* Căn giữa tiêu đề */
        }

        .user-count p, .post-count p {
            font-size: 36px; /* Tăng kích thước chữ cho số người dùng */
            color: #007bff;  /* Màu chữ cho số người dùng */
            font-weight: bold; /* Làm đậm số lượng */
            text-align: center;  /* Căn giữa số lượng */
        }

        /* Kiểu cho các phần thống kê khác */
        .dashboard-item {
            width: 48%; /* Điều chỉnh các phần tử còn lại chiếm 48% chiều rộng */
            margin-bottom: 20px;
        }

        .dashboard-item h3 {
            text-align: center;
            font-size: 1.5em;
            margin-bottom: 10px;
            color: #333;
        }

        .dashboard-item p {
            font-size: 2em;  /* Tăng kích thước chữ cho số lượng */
            color: #007bff;
            font-weight: bold;
            text-align: center;
        }

        /* Kiểu cho Số bài viết theo tỉnh */
        .location-stats {
            width: 48%; /* Đảm bảo biểu đồ số bài viết theo tỉnh có chiều rộng vừa phải */
            margin-bottom: 20px;
        }

        /* Kiểu cho Số bài post theo tháng và năm và Số người đăng nhập theo tháng và năm */
        .post-stats,
        .login-stats {
            width: 48%; /* Đảm bảo các biểu đồ có chiều rộng hợp lý */
            margin-bottom: 20px;
        }

        /* Kiểu cho các biểu đồ */
        .chart-container {
            width: 100%;
            height: 350px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); /* Thêm bóng mờ cho biểu đồ */
        }

        /* Kiểu cho các dòng trong bảng */
        .dashboard-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .dashboard-table th, .dashboard-table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .dashboard-table th {
            background-color: #f4f4f4;
            font-weight: bold;
        }

        /* Kiểu cho các biểu đồ chính */
        .chart {
            height: 100%;
            width: 100%;
            border-radius: 8px;
            background-color: #ffffff;
        }

    </style>

</head>
<body>
    <?php
        include 'header.php'; 
    ?>
    <div id="main" class="d-flex">
        <!-- Sidebar -->
        <nav class="aside-nav">
            <a href="#" class="new-item" onclick="showSection('dashboard')">DashBoard</a>
            <a href="#" class="new-item" onclick="showSection('userManagement')">Quản lý người dùng</a>
            <a href="#" class="new-item" onclick="showSection('postManagement')">Quản lý bài viết</a>
            <a href="#" class="new-item" onclick="showSection('forumManagement')">Quản lý bài đăng</a>
            <a href="#" class="new-item" onclick="showSection('adminCodeCreation')">Tạo mã admin</a> 
        </nav>

        <!-- Content -->
        <div class="content">
            <!-- Dashboard Section -->
            <div id="dashboard" class="section">
                <h2>DashBoard</h2>

                <!-- Hàng ngang chứa Tổng số người dùng và Số bài viết theo tỉnh -->
                <div class="dashboard-row top-row">
                    <!-- Tổng số người dùng -->
                    <div class="dashboard-item user-count">
                        <h3>Tổng số người dùng:</h3>
                        <p><?php echo $userCount; ?></p>
                    </div>
                    
                    <div class="dashboard-item post-count">
                        <h3>Tổng số bài viết:</h3>
                        <p><?php echo $totalPostCount; ?></p>
                    </div>
                </div>

                <!-- Hàng ngang chứa Số người đăng nhập theo tháng và năm và Số bài post theo tháng và năm -->
                <div class="dashboard-row bottom-row">
                    <!-- Số người đăng nhập theo tháng và năm -->
                    <div class="dashboard-item login-stats">
                        <h3>Số lượt đăng nhập</h3>
                        <canvas id="loginChart"></canvas>
                    </div>

                    <!-- Số bài post theo tháng và năm -->
                    <div class="dashboard-item post-stats">
                        <h3>Số bài post</h3>
                        <canvas id="postChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- User Management Section -->
            <div id="userManagement" class="section">
                <h2>Quản lý người dùng</h2>
                <!-- Filter Buttons -->
                <div class="filter-buttons">
                    <button class="<?php echo ($_SESSION['UserStatus'] == 'all') ? 'active' : ''; ?>" onclick="filterUsers('all')">Tất cả người dùng</button>
                    <button class="<?php echo ($_SESSION['UserStatus'] == 'warned') ? 'active' : ''; ?>" onclick="filterUsers('warned')">Bị cảnh cáo</button>
                    <button class="<?php echo ($_SESSION['UserStatus'] == 'banned') ? 'active' : ''; ?>" onclick="filterUsers('banned')">Bị cấm</button>
                </div>

                <!-- User Table -->
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Trạng thái</th>
                            <th>Cấm tài khoản</th>
                            <th>Xóa tài khoản</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($users as $user): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($user['id']); ?></td>
                                <td><?php echo htmlspecialchars($user['username']); ?></td>
                                <td><p class="post-status" 
                                        style="
                                            color: <?php
                                                if ($user['status'] === 'banned') {
                                                    echo '#dc3545'; // Màu đỏ cho 'Không được duyệt'
                                                } elseif ($user['status'] === 'exemplary') {
                                                    echo '#28a745'; // Màu xanh lá cây cho 'Đã duyệt'
                                                } else {
                                                    echo '#ffc107'; // Màu cam cho 'Chưa duyệt'
                                                }
                                            ?>;
                                        ">
                                        <?php
                                            if ($user['status'] === 'banned') {
                                                echo "Đang cấm";
                                            } elseif ($user['status'] === 'exemplary') {
                                                echo "Hoạt động tốt";
                                            } else {
                                                echo "Đang cảnh cáo";
                                            }
                                        ?>
                                    </p></td>
                                <td class="ban-cell">
                                    <?php if ($user['status'] === 'banned'): ?>
                                        <form method="POST" action="admin.php" style="display:inline;">
                                            <input type="hidden" name="user_id" value="<?php echo htmlspecialchars($user['id']); ?>">
                                            <input type="hidden" name="action" value="unban">
                                            <button type="submit" class="unban-button">Hủy cấm</button>
                                        </form>                                        
                                        <?php else: ?>                                        
                                            <form action="admin.php" method="POST">
                                                <input type="number" name="ban_time" placeholder="Thời gian cấm (phút)" required>
                                                <input type="hidden" name="user_id" value="<?php echo htmlspecialchars($user['id']); ?>">
                                                <input type="hidden" name="action" value="ban">
                                                <button class="ban-button" type="submit">Cấm</button>
                                            </form>
                                    <?php endif; ?>
                                </td>
                                <td class="delete-cell">
                                    <button class="delete-button" onclick="openDeleteModal(<?php echo $user['id']; ?>)">Xóa</button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        
            <!-- Post Management Section -->
            <div id="postManagement" class="section">
                <h2>Quản lý bài viết</h2>
                <!-- Filter Buttons -->
                <div class="filter-buttons">
                    <button class="<?php echo ($_SESSION['PostStatus'] == 'all') ? 'active' : ''; ?>" onclick="filterPosts('all')">Tất cả bài viết</button>
                    <button class="<?php echo ($_SESSION['PostStatus'] == 'notapproved') ? 'active' : ''; ?>" onclick="filterPosts('notapproved')">Chưa duyệt</button>
                    <button class="<?php echo ($_SESSION['PostStatus'] == 'approved') ? 'active' : ''; ?>" onclick="filterPosts('approved')">Đã duyệt</button>
                    <button class="<?php echo ($_SESSION['PostStatus'] == 'cancel') ? 'active' : ''; ?>" onclick="filterPosts('cancel')">Bị hủy</button>
                </div>
        
                <!-- Post Table -->
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Trạng thái</th>
                            <th>Xem chi tiết</th>
                            <th>Duyệt bài viết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($posts as $post): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($post['id']); ?></td>
                                <td><?php echo htmlspecialchars($post['name']); ?></td>
                                <td><p class="post-status" 
                                        style="
                                            color: <?php
                                                if ($post['status'] === 'canceled') {
                                                    echo '#dc3545'; // Màu đỏ cho 'Không được duyệt'
                                                } elseif ($post['status'] === 'approve') {
                                                    echo '#28a745'; // Màu xanh lá cây cho 'Đã duyệt'
                                                } else {
                                                    echo '#ffc107'; // Màu cam cho 'Chưa duyệt'
                                                }
                                            ?>;
                                        ">
                                        <?php
                                            if ($post['status'] === 'canceled') {
                                                echo "Không được duyệt";
                                            } elseif ($post['status'] === 'approve') {
                                                echo "Đã duyệt";
                                            } else {
                                                echo "Chưa duyệt";
                                            }
                                        ?>
                                    </p></td>
                                <td class="view-cell">
                                    <a href="./postdetail.php?id=<?php echo htmlspecialchars($post['id']); ?>">
                                        <button><i class="fa-regular fa-eye"></i> Xem bài viết</button>
                                    </a>
                                </td>
                                <td class="approve-cell">
                                     <?php if ($post['status'] === 'notapproved'): ?>
                                        <!-- Form Duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <input type="hidden" name="status" value="approve">
                                            <button type="submit" name="update_statusp" class="approve-button">Duyệt</button>
                                        </form>
                                        <!-- Form Hủy -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <input type="hidden" name="status" value="canceled">
                                            <button type="submit" name="update_statusp" class="cancel-button">Hủy</button>
                                        </form>
                                    <?php elseif ($post['status'] === 'approve'): ?>
                                        <!-- Form Hủy duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <input type="hidden" name="status" value="notapproved">
                                            <button type="submit" name="update_statusp" class="notapproved-button">Hủy duyệt</button>
                                        </form>
                                    <?php elseif ($post['status'] === 'canceled'): ?>
                                        <!-- Form Xóa -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <button type="submit" name="delete_post" class="delete-button">Xóa</button>
                                        </form>
                                    <?php endif; ?>
                                </td>
                            </tr>
                     <?php endforeach; ?>
                    </tbody>
                </table>
            </div>  
            <!-- Forum Management Section -->
            <div id="forumManagement" class="section">
                <h2>Quản lý bài đăng</h2>
                <div class="filter-buttons">
                    <button class="<?php echo ($_SESSION['ForumStatus'] == 'all') ? 'active' : ''; ?>" onclick="filterForum('all')">Tất cả bài viết</button>
                    <button class="<?php echo ($_SESSION['ForumStatus'] == 'notapproved') ? 'active' : ''; ?>" onclick="filterForum('notapproved')">Chưa duyệt</button>
                    <button class="<?php echo ($_SESSION['ForumStatus'] == 'approved') ? 'active' : ''; ?>" onclick="filterForum('approved')">Đã duyệt</button>
                    <button class="<?php echo ($_SESSION['ForumStatus'] == 'cancel') ? 'active' : ''; ?>" onclick="filterForum('cancel')">Bị hủy</button>
                </div>

                <!-- Forum Table -->
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nội dung</th>
                            <th>Trạng thái</th>
                            <th>Xem chi tiết</th>
                            <th>Duyệt bài đăng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($forums as $forum): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($forum['id']); ?></td>
                                <td><?php echo htmlspecialchars($forum['content']); ?></td>
                                <td><p class="forum-status" 
                                        style="color: <?php
                                            if ($forum['status'] === 'canceled') {
                                                echo '#dc3545'; 
                                            } elseif ($forum['status'] === 'approve') {
                                                echo '#28a745'; 
                                            } else {
                                                echo '#ffc107'; 
                                            }
                                        ?>">
                                        <?php
                                            if ($forum['status'] === 'canceled') {
                                                echo "Không được duyệt";
                                            } elseif ($forum['status'] === 'approve') {
                                                echo "Đã duyệt";
                                            } else {
                                                echo "Chưa duyệt";
                                            }
                                        ?>
                                    </p></td>
                                <td class="view-cell">
                                    <a href="./forum.php?#post-<?php echo htmlspecialchars($forum['id']); ?>">
                                        <button><i class="fa-regular fa-eye"></i> Xem bài đăng</button>
                                    </a>
                                </td>
                                <td class="approve-cell">
                                    <?php if ($forum['status'] === 'notapproved'): ?>
                                        <!-- Form Duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="forum_id" value="<?php echo htmlspecialchars($forum['id']); ?>">
                                            <input type="hidden" name="status" value="approve">
                                            <button type="submit" name="update_status" class="approve-button">Duyệt</button>
                                        </form>
                                        <!-- Form Hủy -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="forum_id" value="<?php echo htmlspecialchars($forum['id']); ?>">
                                            <input type="hidden" name="status" value="canceled">
                                            <button type="submit" name="update_status" class="cancel-button">Hủy</button>
                                        </form>
                                    <?php elseif ($forum['status'] === 'approve'): ?>
                                        <!-- Form Hủy duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="forum_id" value="<?php echo htmlspecialchars($forum['id']); ?>">
                                            <input type="hidden" name="status" value="notapproved">
                                            <button type="submit" name="update_status" class="notapproved-button">Hủy duyệt</button>
                                        </form>
                                    <?php elseif ($forum['status'] === 'canceled'): ?>
                                        <!-- Form Xóa -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="forum_id" value="<?php echo htmlspecialchars($forum['id']); ?>">
                                            <button type="submit" name="delete_forum" class="delete-button">Xóa</button>
                                        </form>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

            <!-- Form tạo mã admin -->
            <div id="adminCodeCreation" class="section">
                <h2>Tạo mã admin</h2>
                <form action="admin.php" method="post">
                    <label for="adminCode">Nhập mã admin:</label>
                    <input type="text" id="adminCode" name="adminCode" required>
                    <button type="submit">Tạo mã</button>
                </form>
            </div>
        </div>   
    </div>
     <!-- Modal xác nhận xóa -->
     <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2>Xác nhận</h2>
            <p>Bạn có chắc chắn muốn xóa tài khoản này không?</p>
            <form id="deleteAccountForm" action="admin.php" method="post">
                <input type="hidden" name="account_id" id="account_id_to_delete">
                <button type="submit" class="btn btn-danger" name="action" value="deleteaccount">Xóa</button>
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
            </form>
        </div>
    </div>
    <!-- Modal thông báo -->
    <div id="notificationModal" class="notification-modal">
        <div class="modal-content">
            <span class="close" onclick="closeNotificationModal()">&times;</span>
            <h2>Thông báo</h2>
            <p id="notificationMessage">Nội dung thông báo ở đây</p>
            <button onclick="closeNotificationModal()">Xác nhận</button>
        </div>
    </div>

    <script>
        // Dashboard
        // Dữ liệu số người đăng nhập theo tháng và năm
        // Biểu đồ số người đăng nhập theo tháng và năm
        const loginData = {
            labels: <?php echo json_encode(array_column($loginCounts, 'month_year')); ?>,
            datasets: [{
                label: 'Số lượt đăng nhập',
                data: <?php echo json_encode(array_column($loginCounts, 'login_count')); ?>,
                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        };

        const loginCtx = document.getElementById('loginChart').getContext('2d');
        new Chart(loginCtx, {
            type: 'bar',
            data: loginData,
            options: {
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // Biểu đồ số bài post theo tháng và năm
        const postData = {
            labels: <?php echo json_encode(array_column($postCounts, 'month_year')); ?>,
            datasets: [{
                label: 'Số bài post',
                data: <?php echo json_encode(array_column($postCounts, 'post_count')); ?>,
                backgroundColor: 'rgba(153, 102, 255, 0.6)',
                borderColor: 'rgba(153, 102, 255, 1)',
                borderWidth: 1
            }]
        };

        const postCtx = document.getElementById('postChart').getContext('2d');
        new Chart(postCtx, {
            type: 'bar',
            data: postData,
            options: {
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        
        // Dashboard








      function openDeleteModal(accountId) {
            document.getElementById('account_id_to_delete').value = accountId; // Gán ID tài khoản vào input
            document.getElementById('deleteModal').style.display = 'block'; // Mở modal
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none'; // Đóng modal
        }


        function showSection(sectionId) {
            // Ẩn tất cả các phần nội dung
            document.querySelectorAll('.section').forEach(function(section) {
                section.classList.add('hidden'); // Thêm lớp hidden để ẩn
                section.classList.remove('visible'); // Loại bỏ lớp visible nếu có
            });

            // Hiển thị phần nội dung được chọn
            const selectedSection = document.getElementById(sectionId);
            selectedSection.classList.remove('hidden'); // Loại bỏ lớp hidden để hiển thị
            selectedSection.classList.add('visible'); // Thêm lớp visible

            // Cập nhật session trên server
            fetch('update_section_admin.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ section: sectionId })
            })
            .then(response => response.json())
            .then(data => {
                console.log(data.message); // Hiển thị thông báo từ server
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }

        // Khi tải trang, kiểm tra xem có giá trị trong Local Storage không
        window.onload = function() {
            const savedSection = localStorage.getItem('currentSection');
            const sectionId = savedSection || "<?php echo $_SESSION['section_admin'] ?? 'dashboard'; ?>"; // Nếu không có giá trị trong Local Storage, sử dụng giá trị từ session
            showSection(sectionId);
        };

        function filterUsers(status) {
        // Chuyển hướng đến trang hiện tại với tham số status
        window.location.href = 'admin.php?UserStatus=' + status;
        }

        function filterPosts(status) {
        // Chuyển hướng đến trang hiện tại với tham số status
        window.location.href = 'admin.php?PostStatus=' + status;
        }

        function filterForum(status) {
        // Chuyển hướng đến trang hiện tại với tham số status
        window.location.href = 'admin.php?ForumStatus=' + status;
        }

        function showNotification(message) {
            document.getElementById('notificationMessage').innerText = message;
            document.getElementById('notificationModal').style.display = 'block';
        }

        function closeNotificationModal() {
            document.getElementById('notificationModal').style.display = 'none';
        }

        <?php if (isset($_SESSION['message'])): ?>
            showNotification("<?php echo htmlspecialchars($_SESSION['message']); ?>");
            // Xóa thông báo sau khi hiển thị
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>

    </script>
</body>
</html>