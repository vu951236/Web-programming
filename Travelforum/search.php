<?php
// Bắt đầu phiên
session_start();

// Kiểm tra xem có từ khóa tìm kiếm không
$locations = [];
$posts = []; // Khởi tạo biến $posts để sử dụng sau này
if (isset($_GET['keyword'])) {
    $keyword = $_GET['keyword'];

    // Cấu hình kết nối cơ sở dữ liệu
    $config = include('config.php');

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

    // Tìm kiếm tỉnh thành phù hợp
    $location_sql = "SELECT id, name, location, information, image FROM locationdetail WHERE name LIKE ?";
    $location_stmt = $conn->prepare($location_sql);
    $like_keyword = '%' . $keyword . '%';
    $location_stmt->bindParam(1, $like_keyword);
    $location_stmt->execute();

    if ($location_stmt->rowCount() > 0) {
        while ($row = $location_stmt->fetch(PDO::FETCH_ASSOC)) {
            $locations[] = [
                'id' => $row['id'],
                'name' => $row['name'],
                'location' => $row['location'],
                'information' => $row['information'],
                'image' => $row['image'], // Lưu hình ảnh vào mảng $locations
            ];
        }
    }
    
    $status = 'approve';
    // Tìm kiếm theo cả tên bài viết và tên tỉnh thành trong một truy vấn
    $post_sql = "
        SELECT pd.id, pd.name, pd.description, pd.image, pd.userid, u.username AS author_name, u.avatar AS author_avatar 
        FROM postdetail pd
        JOIN users u ON pd.userid = u.id
        LEFT JOIN locationdetail ld ON pd.location = ld.location
        WHERE (pd.name LIKE :keyword OR ld.name LIKE :keyword) AND pd.status = :status
    ";

    // Chuẩn bị và thực thi truy vấn với từ khóa tìm kiếm
    $post_stmt = $conn->prepare($post_sql);
    $post_stmt->execute([':keyword' => '%' . $keyword . '%', ':status' => $status]);

    // Lấy tất cả các kết quả bài viết
    $posts = $post_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Kiểm tra xem có thông tin người dùng trong session không
    if (isset($_SESSION['user_id'])) {
        $userId = $_SESSION['user_id']; // Lấy ID người dùng từ session

        // Lấy trạng thái người dùng từ cơ sở dữ liệu
        $userQuery = "SELECT id, status FROM users WHERE id = ?";
        $userStmt = $conn->prepare($userQuery); // Thay $pdo bằng $conn
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

    // Đóng kết nối
    $location_stmt = null;
    $post_stmt = null;
    $conn = null;
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/search.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
</head>
<body>
    <?php
        include 'header.php'; 
    ?>
    <div id="main">
        <div class="main-content">
            <div class="container text-center">
                <div id="locations">
                `   <h4>Địa điểm</h4>
                    <div class="explore-content">
                        <div class="row row-cols-1 row-cols-md-3 g-4">
                            <?php
                            if (isset($keyword)) {
                                if (!empty($locations)) {
                                    foreach ($locations as $location) {
                                        echo '<div class="col">';
                                        echo '  <div class="card">';
                                        // Thêm thẻ <a> xung quanh phần hình ảnh và nội dung của địa điểm
                                        echo '    <a href="locationdetail.php?id=' . urlencode($location['id']) . '">';
                                        echo '      <img src="./' . htmlspecialchars($location['image']) . '" class="card-img-top" alt="...">'; 
                                        echo '      <div class="card-body">';
                                        echo '        <h5 class="card-title">' . htmlspecialchars($location['name']) . '</h5>';
                                        echo '        <p class="card-text">' . htmlspecialchars($location['information']) . '</p>';
                                        echo '      </div>';
                                        echo '    </a>'; // đóng thẻ <a>
                                        echo '  </div>';
                                        echo '</div>'; // close col
                                    }
                                } else {
                                    echo "<p class='text-center'>Không có địa điểm nào phù hợp với từ khóa <strong>" . htmlspecialchars($keyword) . "</strong>.</p>";
                                }
                            }
                            ?>
                        </div>
                    </div> <!-- Kết thúc explore-content -->
                </div>`
                <div id="posts">
                    <?php
                    if (isset($posts) && !empty($posts)) {
                        echo '<h4>Bài viết</h4>';
                        echo '<div class="container text-center">';
                        echo '  <div class="row">';
                        foreach ($posts as $row) {
                            echo '<div class="col center">';
                            echo '    <div class="small-post">';
                            echo '      <div class="post-header">';
                            // Bao bọc ảnh avatar và tên tác giả trong thẻ <a> để chuyển đến trang chi tiết tác giả
                            echo '        <a href="profile.php?userId=' . urlencode($row['userid']) . '">';
                            echo '          <img src="' . htmlspecialchars($row['author_avatar'] ?? 'asset/img/test.jpg') . '" alt="Avatar" class="post-avatar">';
                            echo '          <div class="post-author">' . htmlspecialchars($row['author_name']) . '</div>';
                            echo '        </a>';
                            echo '      </div>';
                            // Bao bọc hình ảnh và nội dung bài viết trong thẻ <a> để chuyển đến trang chi tiết bài viết
                            echo '      <a href="postdetail.php?id=' . urlencode($row['id']) . '">';
                            echo '        <img src="' . htmlspecialchars($row['image']) . '" class="card-img-top" alt="...">';
                            echo '        <h5 class="card-title">' . htmlspecialchars($row['name']) . '</h5>';
                            echo '        <div class="post-content">' . htmlspecialchars($row['description']) . '</div>';
                            echo '      </a>';
                            echo '    </div>'; // close small-post
                            echo '</div>'; // close col
                        }
                        echo '  </div>'; // close row
                        echo '</div>'; // close container
                    } else {
                        echo "<p class='text-center'>Không có bài viết nào phù hợp với địa điểm tìm kiếm.</p>";
                    }
                    ?>
                </div>
            </div>
        </div>
    </div>

    <?php
        include 'footer.php'; 
    ?>
</body>
</html>
