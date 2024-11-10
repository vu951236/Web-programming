<?php
session_start();
$config = include('config.php');

if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

$message = ''; // Biến để lưu thông báo
$section = '';

try {
    // Tạo kết nối đến cơ sở dữ liệu
    $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Kiểm tra xem có thông tin người dùng trong session không
    if (isset($_SESSION['user_id'])) {
        $userId = $_SESSION['user_id']; // Lấy ID người dùng từ session

        // Lấy trạng thái người dùng từ cơ sở dữ liệu
        $userQuery = "SELECT status FROM users WHERE id = ?";
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
    } else {
        // Nếu không có thông tin người dùng trong session, đặt trạng thái là rỗng
        $userStatus = '';
        header("Location: login.php");
        exit();
    }

    // Lấy thông tin người dùng từ cơ sở dữ liệu
    $stmt = $pdo->prepare("SELECT fullname, email, avatar FROM users WHERE id = :id");
    $stmt->bindParam(':id', $_SESSION['user_id']);
    $stmt->execute();
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    $oldAvatar = $user['avatar'] ?? '';

    // Lấy tất cả bài viết của người dùng
    $stmt = $pdo->prepare("SELECT * FROM postdetail WHERE userid = :user_id ORDER BY date DESC");
    $stmt->bindParam(':user_id', $_SESSION['user_id']);
    $stmt->execute();
    $posts = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        if (isset($_POST['action']) && $_POST['action'] === 'editaccount') {
            // Cập nhật thông tin cá nhân
            $fullname = $_POST['fullname'] ?? null;
            $email = $_POST['email'] ?? null;
            $password = $_POST['password'] ?? null;
            $newAvatar = null;

            $params = [];
            $sql = "UPDATE users SET";

            if ($fullname) {
                $sql .= " fullname = :fullname,";
                $params[':fullname'] = $fullname;
            }
            if ($email) {
                $sql .= " email = :email,";
                $params[':email'] = $email;
            }
            if ($password) {
                $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
                $sql .= " password = :password,";
                $params[':password'] = $hashedPassword;
            }

            // Kiểm tra và xử lý file avatar
            if (isset($_FILES['profile_picture']) && $_FILES['profile_picture']['size'] > 0) {
                $avatarFile = $_FILES['profile_picture'];
                $extension = pathinfo($avatarFile['name'], PATHINFO_EXTENSION); // Lấy phần mở rộng của file
                $newAvatar = uniqid('avatar_', true) . '.' . $extension; // Tạo tên file duy nhất
                // Đường dẫn đến thư mục images trên server 
                $serverImagesDir = __DIR__ . '/database/users';

                // Tạo thư mục nếu chưa tồn tại
                if (!file_exists($serverImagesDir)) {
                    mkdir($serverImagesDir, 0777, true);
                }

                // Xóa avatar cũ
                if ($oldAvatar) {
                    $oldServerPath = $serverImagesDir . '/' . basename($oldAvatar);
                    if (file_exists($oldServerPath)) unlink($oldServerPath);
                }

                // Đường dẫn lưu avatar mới
                $serverUploadPath = $serverImagesDir . '/' . $newAvatar;

                // Di chuyển file avatar vào thư mục server 
                move_uploaded_file($avatarFile['tmp_name'], $serverUploadPath);

                // Cập nhật đường dẫn avatar vào cơ sở dữ liệu
                $sql .= " avatar = :avatar,";
                $params[':avatar'] = 'database/users/' . $newAvatar;
            }

            if (count($params) > 0) {
                $sql = rtrim($sql, ',') . " WHERE id = :id";
                $params[':id'] = $_SESSION['user_id'];

                $stmt = $pdo->prepare($sql);
                foreach ($params as $key => $value) {
                    $stmt->bindValue($key, $value);
                }
                $stmt->execute();

                $_SESSION['message'] = "Cập nhật thành công!";
                $_SESSION['section'] = 'accountSettings';
                header("Location: myaccount.php");
                exit();
            } else {
                $_SESSION['message'] = "Không có thông tin nào để cập nhật.";
            }
        }

        if (isset($_POST['action']) && $_POST['action'] === 'editpost') {
            $editPostId = $_POST['post_id'];
            $postName = $_POST['name'] ?? '';
            $postContent = $_POST['content'] ?? '';
            $newImage = null; // Biến lưu đường dẫn hình ảnh mới
        
            // Cập nhật bài viết
            $sql = "UPDATE postdetail SET name = :name, content = :content";
            $params = [
                ':name' => $postName,
                ':content' => $postContent,
            ];
        
            // Kiểm tra xem có hình ảnh mới không
            if (isset($_FILES['image']) && $_FILES['image']['size'] > 0) {
                $imageFile = $_FILES['image'];
                $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION); // Lấy phần mở rộng của file
                $newImage = uniqid('post_', true) . '.' . $extension; // Tạo tên file duy nhất
        
                // Đường dẫn đến thư mục lưu trữ hình ảnh trên server
                $serverImagesDir = __DIR__ . '/database/posts';
        
                // Tạo thư mục nếu chưa tồn tại
                if (!file_exists($serverImagesDir)) {
                    mkdir($serverImagesDir, 0777, true);
                }
        
                // Xóa hình ảnh cũ nếu có
                $stmt = $pdo->prepare("SELECT image FROM postdetail WHERE id = :id");
                $stmt->bindParam(':id', $editPostId);
                $stmt->execute();
                $oldImage = $stmt->fetchColumn();
        
                if ($oldImage) {
                    $oldServerPath = $serverImagesDir . '/' . basename($oldImage);
                    if (file_exists($oldServerPath)) unlink($oldServerPath);
                }
        
                // Di chuyển file hình ảnh mới vào thư mục server
                $serverUploadPath = $serverImagesDir . '/' . $newImage;
                move_uploaded_file($imageFile['tmp_name'], $serverUploadPath);
        
                // Cập nhật đường dẫn hình ảnh mới vào cơ sở dữ liệu
                $sql .= ", image = :image";
                $params[':image'] = 'database/posts/' . $newImage;
            }
        
            // Hoàn tất câu lệnh SQL
            $sql .= " WHERE id = :id";
            $params[':id'] = $editPostId;
        
            $stmt = $pdo->prepare($sql);
            foreach ($params as $key => $value) {
                $stmt->bindValue($key, $value);
            }
            $stmt->execute();
        
            $affectedRows = $stmt->rowCount();
            if ($affectedRows > 0) {
                $_SESSION['message'] = "Chỉnh sửa bài viết thành công!";
            } else {
                $_SESSION['message'] = "Không có thay đổi nào được thực hiện. Post ID: $editPostId, Name: $postName, Content: $postContent";
            }
        
            $_SESSION['section'] = 'myPosts';
            header("Location: myaccount.php");
            exit();
        }
        // Xử lý thêm bài viết
        if (isset($_POST['action']) && $_POST['action'] === 'addpost') {
            $postTitle = $_POST['postTitle'] ?? '';
            $postDescription = $_POST['postDescription'] ?? ''; // Nhận trường mô tả
            $postContent = $_POST['postContent'] ?? '';
            $postLocation = $_POST['postLocation'] ?? ''; // Nhận tỉnh thành
            $newImage = null;

            // Xử lý hình ảnh
            if (isset($_FILES['postImage']) && $_FILES['postImage']['size'] > 0) {
                $imageFile = $_FILES['postImage'];
                $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION); // Lấy phần mở rộng của file
                $newImageName = uniqid('post_', true) . '.' . $extension; // Tạo tên file duy nhất

                // Đường dẫn đến thư mục lưu trữ hình ảnh trên server
                $serverImagesDir = __DIR__ . '/database/posts';

                // Tạo thư mục nếu chưa tồn tại
                if (!file_exists($serverImagesDir)) {
                    mkdir($serverImagesDir, 0777, true);
                }

                // Di chuyển file hình ảnh vào thư mục server
                $serverUploadPath = $serverImagesDir . '/' . $newImageName;
                move_uploaded_file($imageFile['tmp_name'], $serverUploadPath);
                $newImage = 'database/posts/' . $newImageName; // Lưu đường dẫn hình ảnh
            }

            // Thêm bài viết vào cơ sở dữ liệu
            $sql = "INSERT INTO postdetail (userid, name, description, content, image, location, date) VALUES (:userid, :name, :description, :content, :image, :location, NOW())";
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':userid', $_SESSION['user_id']);
            $stmt->bindParam(':name', $postTitle);
            $stmt->bindParam(':description', $postDescription); 
            $stmt->bindParam(':content', $postContent);
            $stmt->bindParam(':image', $newImage);
            $stmt->bindParam(':location', $postLocation); 
            $stmt->execute();

            $_SESSION['message'] = "Thêm bài viết thành công!";
            $_SESSION['section'] = 'addPost';
            header("Location: myaccount.php");
            exit();
        }
    }

    // Kiểm tra và xử lý yêu cầu xóa bài viết
    if (isset($_POST['action']) && $_POST['action'] === 'deletepost' && isset($_POST['post_id'])) {
        $deletePostId = $_POST['post_id']; // Thay đổi từ $_GET sang $_POST
        $stmt = $pdo->prepare("DELETE FROM postdetail WHERE id = :id AND userid = :user_id");
        $stmt->bindParam(':id', $deletePostId);
        $stmt->bindParam(':user_id', $_SESSION['user_id']);
        $stmt->execute();

        $affectedRows = $stmt->rowCount();
        if ($affectedRows > 0) {
            $_SESSION['message'] = "Xóa bài viết thành công!";
        } else {
            $_SESSION['message'] = "Không có thay đổi nào được thực hiện. Post ID: $deletePostId"; // Cập nhật ID đúng
        }
        $_SESSION['section'] = 'myPosts';
        header("Location: myaccount.php");
        exit();
    }
    // Xử lý yêu cầu xóa tài khoản
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'deleteaccount') {
        $userId = $_SESSION['user_id']; // Lấy ID người dùng từ phiên làm việc

        // Xóa tất cả bình luận của người dùng trong bảng postcomment
        $deleteCommentsStmt = $pdo->prepare("DELETE FROM postcomment WHERE userid = :userid");
        $deleteCommentsStmt->execute(['userid' => $userId]);

        // Xóa tất cả bài viết của người dùng trong bảng postdetail
        $deletePostsStmt = $pdo->prepare("DELETE FROM postdetail WHERE userid = :userid");
        $deletePostsStmt->execute(['userid' => $userId]);

        // Xóa thông tin người dùng trong bảng users
        $deleteUserStmt = $pdo->prepare("DELETE FROM users WHERE id = :userid");
        $deleteUserStmt->execute(['userid' => $userId]);

        // Hủy phiên làm việc và chuyển hướng về trang chính
        session_destroy();
        header("Location: index.php"); // Chuyển hướng về trang chính hoặc trang đăng nhập
        exit;
    }
    // Xử lý yêu cầu đăng lại bài viết
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['new_status'])) {
        $postId = $_POST['post_id'] ?? null;
        $newStatus = $_POST['new_status'] ?? null;

        if ($postId && $newStatus) {
            $stmt = $pdo->prepare("UPDATE postdetail SET status = ? WHERE id = ?");
            $stmt->execute([$newStatus, $postId]);
            
            // Thêm thông báo thành công
            $_SESSION['message'] = "Bài viết đã được đăng lại thành công!";
        }
        header("Location: myaccount.php");
        exit();
    }

} catch (PDOException $e) {
    $message = "Lỗi kết nối: " . $e->getMessage();
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./asset/font/fontawesome-free-6.6.0-web/fontawesome-free-6.6.0-web/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/index.css">
    <link rel="stylesheet" href="./asset/css/base.css">
    <link rel="stylesheet" href="./asset/css/post.css">
    <link rel="stylesheet" href="./asset/css/myaccount.css">
    <style>
        .hidden { display: none; }
    </style>
</head>
<body>
    <?php
        include 'header.php'; 
    ?>


    <div id="main" class="d-flex">
        <nav class="aside-nav">
            <a href="#" class="new-item" onclick="showSection('accountSettings')">Cài đặt tài khoản</a>
            <a href="#" class="new-item" onclick="showSection('myPosts')">Bài viết của tôi</a>
            <a href="#" class="new-item" onclick="showSection('addPost')">Thêm bài viết</a>
            <a href="#" class="new-item" onclick="showSection('policyContent')">Chính sách sử dụng</a> 
            <a href="#" class="new-item" onclick="showSection('deleteAccount')">Xóa tài khoản</a>
        </nav>

        <div class="content p-4">
            <div id="accountSettings" class="section">
                <h2 class="mb-4">Sửa thông tin</h2>
                <form action="myaccount.php" method="post" enctype="multipart/form-data" class="d-flex flex-column">
                    <div class="d-flex align-items-start mb-3">
                        <div class="left-section flex-grow-1">
                            <div class="mb-3">
                                <label for="fullname" class="form-label">Tên người dùng</label>
                                <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Nhập tên người dùng" value="<?php echo htmlspecialchars($user['fullname'] ?? ''); ?>">
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email" value="<?php echo htmlspecialchars($user['email'] ?? ''); ?>">
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu mới</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu mới">
                            </div>
                            <div class="mb-3">
                                <label for="confirm_password" class="form-label">Xác nhận mật khẩu</label>
                                <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Xác nhận mật khẩu mới">
                            </div>
                        </div>
                        <div class="right-section ms-3 text-center">
                            <div class="image-container mb-2">
                                <img src="<?php echo $user['avatar'] ? './' . htmlspecialchars($user['avatar']) : './asset/img/user_image.png'; ?>" alt="User Image" class="profile-image" id="current-image">
                            </div>
                            <div class="upload-container">
                                <label for="profile_picture" class="custom-file-upload btn btn-secondary">Chọn ảnh</label>
                                <input type="file" id="profile_picture" name="profile_picture" accept="image/*" class="hidden-input">
                            </div>
                            <small class="form-text text-muted">Chọn ảnh để làm ảnh đại diện của bạn (JPEG, PNG).</small>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary mt-3" name="action" value="editaccount">Lưu thay đổi</button>
                </form>
            </div>

            <!-- Nội dung Bài viết của tôi -->
            <div id="myPosts" class="section">
                <h2 class="mb-4">Bài viết của tôi</h2>
                <div id="postsContainer">
                    <?php if (!empty($posts)): ?>
                        <?php foreach ($posts as $post): ?>
                            <div class="post">
                                <div class="post-header">
                                    <img src="<?php echo htmlspecialchars($post['image'] ?? 'asset/img/default.jpg'); ?>" alt="Ảnh bài viết" class="post-image">
                                    <h3><?php echo htmlspecialchars($post['name']); ?></h3>
                                    <p><?php echo htmlspecialchars($post['description']); ?></p>
                                    <small><?php echo htmlspecialchars($post['date']); ?></small>
                                    <p class="post-status" 
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
                                        Trạng thái: 
                                        <?php
                                            if ($post['status'] === 'canceled') {
                                                echo "Không được duyệt";
                                                // Hiển thị nút "Đăng lại" nếu trạng thái là "canceled"
                                                echo '
                                                    <button type="button" class="repost-btn" onclick="openRepostModal(' . $post['id'] . ')">
                                                        <i class="fa fa-rotate-left"></i> Đăng lại
                                                    </button>
                                                    ';
                                            } elseif ($post['status'] === 'approve') {
                                                echo "Đã duyệt";
                                            } else {
                                                echo "Chưa duyệt";
                                            }
                                        ?>
                                    </p>

                                </div>
                                <!-- Nút chỉnh sửa và xóa -->
                                <div class="post-actions">
                                    <button class="edit-btn" onclick="openEditModal(<?php echo htmlspecialchars(json_encode($post)); ?>)">
                                        <i class="fa fa-pencil"></i> Sửa
                                    </button>
                                    <a href="/Travelforum/Travelforum/postdetail.php?id=<?php echo htmlspecialchars($post['id']); ?>">
                                        <button><i class="fa-regular fa-eye"></i> Xem bài viết</button>
                                    </a>
                                    <form action="javascript:void(0);" style="display: inline;" onclick="openDeleteModal(<?php echo htmlspecialchars($post['id']); ?>)">
                                        <button type="button" class="delete-btn">
                                            <i class="fa fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </div>
                            </div>                         
                        <?php endforeach; ?>                       
                    <?php else: ?>
                        <p>Không có bài viết nào.</p>
                    <?php endif; ?>
                </div>              
            </div>

            <!-- Modal chỉnh sửa bài viết -->
            <div id="editModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeEditModal()">&times;</span>
                    <h2>Chỉnh sửa bài viết</h2>
                    <form action="myaccount.php" method="post" enctype="multipart/form-data">
                        <input type="hidden" id="edit-post-id" name="post_id">
                        <div class="form-group">
                            <label for="edit-post-name">Tên bài viết:</label>
                            <input type="text" id="edit-post-name" name="name" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="edit-post-content">Nội dung:</label>
                            <textarea id="edit-post-content" name="content" class="form-control" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="edit-post-image">Ảnh bài viết:</label>
                            <input type="file" id="edit-post-image" name="image" accept="image/*" class="form-control">
                        </div>
                        <button type="submit" class="btn btn-primary" name="action" value="editpost">Sửa bài viết</button>
                    </form>
                </div>
            </div>

            <!-- Nội dung Thêm bài viết -->
            <div id="addPost" class="section hidden">
                <div class="container">
                    <h2>Thêm Bài Viết</h2>
                    <details>
                        <summary class="btn btn-primary">Mở Thêm Bài Viết</summary>
                        <div class="create-post">
                            <form action="myaccount.php" method="POST" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <label for="postTitle" class="form-label">Tiêu đề</label>
                                    <input type="text" class="form-control" id="postTitle" name="postTitle" required>
                                </div>
                                <div class="mb-3">
                                    <label for="postDescription" class="form-label">Mô tả</label>
                                    <input type="text" class="form-control" id="postDescription" name="postDescription" required>
                                </div>
                                <div class="mb-3">
                                    <label for="postContent" class="form-label">Nội dung</label>
                                    <textarea class="form-control" id="postContent" name="postContent" rows="4" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="postImage" class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" id="postImage" name="postImage">
                                </div>
                                <div class="mb-3">
                                    <label for="postLocation" class="form-label">Chọn Tỉnh Thành</label>
                                    <select class="form-select" id="postLocation" name="postLocation" required>
                                        <option value="">Chọn Tỉnh Thành</option>
                                        <option value="angiang">An Giang</option>
                                        <option value="bariavungtau">Bà Rịa - Vũng Tàu</option>
                                        <option value="bacgiang">Bắc Giang</option>
                                        <option value="bacninh">Bắc Ninh</option>
                                        <option value="bentre">Bến Tre</option>
                                        <option value="binhduong">Bình Dương</option>
                                        <option value="binhphuoc">Bình Phước</option>
                                        <option value="binhdinh">Bình Định</option>
                                        <option value="caobang">Cao Bằng</option>
                                        <option value="daklak">Đắk Lắk</option>
                                        <option value="daknong">Đắk Nông</option>
                                        <option value="dienbien">Điện Biên</option>
                                        <option value="hagiang">Hà Giang</option>
                                        <option value="hanoi">Hà Nội</option>
                                        <option value="haiphong">Hải Phòng</option>
                                        <option value="hanam">Hà Nam</option>
                                        <option value="hatinh">Hà Tĩnh</option>
                                        <option value="hochiminh">Hồ Chí Minh</option>
                                        <option value="hoabinh">Hòa Bình</option>
                                        <option value="hungyen">Hưng Yên</option>
                                        <option value="khanhhoa">Khánh Hòa</option>
                                        <option value="kiengiang">Kiên Giang</option>
                                        <option value="kontum">Kon Tum</option>
                                        <option value="laichau">Lai Châu</option>
                                        <option value="lamdong">Lâm Đồng</option>
                                        <option value="langson">Lạng Sơn</option>
                                        <option value="longan">Long An</option>
                                        <option value="namdinh">Nam Định</option>
                                        <option value="nghean">Nghệ An</option>
                                        <option value="ninhbinh">Ninh Bình</option>
                                        <option value="ninhthuan">Ninh Thuận</option>
                                        <option value="phutho">Phú Thọ</option>
                                        <option value="phuquoc">Phú Quốc</option>
                                        <option value="quangbinh">Quảng Bình</option>
                                        <option value="quangnam">Quảng Nam</option>
                                        <option value="quangngai">Quảng Ngãi</option>
                                        <option value="quangninh">Quảng Ninh</option>
                                        <option value="quangtri">Quảng Trị</option>
                                        <option value="soctrang">Sóc Trăng</option>
                                        <option value="sola">Sơn La</option>
                                        <option value="tayninh">Tây Ninh</option>
                                        <option value="thanhhoa">Thanh Hóa</option>
                                        <option value="thuathienhue">Thừa Thiên Huế</option>
                                        <option value="tiengiang">Tiền Giang</option>
                                        <option value="travinh">Trà Vinh</option>
                                        <option value="tuyenquang">Tuyên Quang</option>
                                        <option value="vinhphuc">Vĩnh Phúc</option>
                                        <option value="vinhlong">Vĩnh Long</option>
                                        <option value="yenbai">Yên Bái</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-success" name="action" value="addpost">Tạo Bài Viết</button>
                            </form>
                        </div>
                    </details>
                </div>
            </div>



            <!-- Nội dung Chính sách sử dụng -->
            <div id="policyContent" class="section hidden">
                <h2>Chính sách sử dụng</h2>
                <div id="policyText">
                    <!-- Nội dung chính sách sẽ được tải vào đây -->
                </div>
            </div>

            <!-- Nội dung Xóa tài khoản -->
            <div id="deleteAccount" class="section hidden">
                <h2 class="mb-4">Xóa tài khoản</h2>
                <p>Bạn chắc chắn muốn xóa tài khoản của mình? Hành động này không thể hoàn tác.</p>
                <button class="btn btn-danger" onclick="openDeleteAccountModal()">Xóa tài khoản</button>
            </div>

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

    <!-- Modal xác nhận xóa bài viết -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2>Xác nhận</h2>
            <p>Bạn có chắc chắn muốn xóa bài viết này không?</p>
            <form id="deletePostForm" action="myaccount.php" method="post">
                <input type="hidden" name="post_id" id="post_id_to_delete">
                <button type="submit" class="btn btn-danger" name="action" value="deletepost">Xóa</button>
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
            </form>
        </div>
    </div>

    <!-- Modal xác nhận xóa tài khoản -->
    <div id="deleteAccountModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteAccountModal()">&times;</span>
            <h2>Xác nhận</h2>
            <p>Sau khi xóa tài khoản, tất cả các bình luận và bài viết của bạn sẽ biến mất. Bạn có chắc chắn muốn xóa tài khoản không?</p>
            <form id="deleteAccountForm" action="myaccount.php" method="post">
                <input type="hidden" name="action" value="deleteaccount">
                <button type="submit" class="btn btn-danger">Xóa tài khoản</button>
                <button type="button" class="btn btn-secondary" onclick="closeDeleteAccountModal()">Hủy</button>
            </form>
        </div>
    </div>

    <!-- Modal đăng lại bài viết -->
    <div id="repostModal" class="repost-modal">
        <div class="repost-modal-content">
            <form id="repostForm" method="post" action="myaccount.php">
                <input type="hidden" name="post_id" value="" id="repostPostId">
                <input type="hidden" name="new_status" value="notapproved">
                <p>Bạn có chắc muốn đăng lại bài viết?</p>
                <button type="submit">Xác nhận</button>
                <button type="button" onclick="closeRepostModal()">Hủy</button>
            </form>
        </div>
    </div>

    <div id="footer">
        <div class="footer-container">
            <div class="footer-section">
                <h3>Liên hệ</h3>
                <p>Email: contact@example.com</p>
                <p>Điện thoại: +123 456 7890</p>
            </div>
            <div class="footer-section">
                <h3>Thông tin</h3>
                <ul>
                    <li><a href="./aboutus.html">Về chúng tôi</a></li>
                    <li><a href="./policy.html">Chính sách bảo mật</a></li>
                    <li><a href="./policy.html">Điều khoản sử dụng</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Liên kết hữu ích</h3>
                <ul>
                    <li><a href="#faq">Câu hỏi thường gặp</a></li>
                    <li><a href="#support">Hỗ trợ</a></li>
                    <li><a href="#forum">Diễn đàn</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Mạng xã hội</h3>
                <div class="social-icons">
                    <a href="https://www.threads.net/@hvdien04" target="_blank"><i class="fa-brands fa-square-threads"></i></a>
                    <a href="https://www.instagram.com/hvdien04/" target="_blank"><i class="fa-brands fa-square-instagram"></i></a>
                    <a href="https://www.facebook.com/HoangVanDien.Profile" target="_blank"><i class="fa-brands fa-facebook"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 Diễn đàn của chúng tôi. Bảo lưu mọi quyền.</p>
        </div>
    </div>
    
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
    <script>
        function loadPolicyContent() {
            fetch('./policy.html')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    // Tạo một phần tử tạm thời để phân tích cú pháp nội dung
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = data;

                    // Xóa header và footer khỏi nội dung
                    const header = tempDiv.querySelector('#header'); 
                    const footer = tempDiv.querySelector('#footer'); 
                    
                    // Xóa header và footer nếu tồn tại
                    if (header) {
                        header.remove();
                    }
                    if (footer) {
                        footer.remove();
                    }

                    // Chèn nội dung còn lại vào div
                    document.getElementById('policyText').innerHTML = tempDiv.innerHTML;
                })
                .catch(error => {
                    console.error('Có lỗi xảy ra khi tải nội dung:', error);
                    document.getElementById('policyText').innerHTML = '<p>Có lỗi xảy ra. Vui lòng thử lại sau.</p>';
                });
        }

        // Gọi hàm tải nội dung khi trang được tải
        document.addEventListener('DOMContentLoaded', loadPolicyContent);


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
            fetch('update_section_user.php', {
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

            // Tải nội dung chính sách khi nhấn vào liên kết
            if (sectionId === 'policyContent') {
                loadPolicyContent(); // Giả sử đây là hàm tải nội dung chính sách
            }
        }

        // Khi tải trang, kiểm tra xem có giá trị trong Local Storage không
        window.onload = function() {
            const savedSection = localStorage.getItem('currentSection');
            const sectionId = savedSection || "<?php echo $_SESSION['section_user'] ?? 'accountSettings'; ?>"; // Nếu không có giá trị trong Local Storage, sử dụng giá trị từ session
            showSection(sectionId);
        };


         // Hiển thị ảnh mới ngay khi người dùng chọn
         document.getElementById("profile_picture").addEventListener("change", function(event) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("current-image").src = e.target.result;
            };
            reader.readAsDataURL(event.target.files[0]);
        });
        // Hàm mở modal
        function openEditModal(post) {
            document.getElementById('editModal').style.display = 'block';
            document.getElementById('edit-post-id').value = post.id;
            document.getElementById('edit-post-name').value = post.name;
            document.getElementById('edit-post-content').value = post.content;
        }

        // Hàm đóng modal
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // Thêm sự kiện cho nút đóng
        document.querySelector('.close').addEventListener('click', closeEditModal);

        // Ngăn không cho modal đóng khi nhấn vào nội dung của modal
        document.querySelector('.modal-content').addEventListener('click', function(event) {
            event.stopPropagation();
        });

        // Đóng modal khi nhấn vào vùng tối bên ngoài modal
        document.querySelector('.modal').addEventListener('click', closeEditModal);


        function showNotification(message) {
            document.getElementById('notificationMessage').innerText = message;
            document.getElementById('notificationModal').style.display = 'block';
        }

        function closeNotificationModal() {
            document.getElementById('notificationModal').style.display = 'none';
        }

        function openDeleteModal(postId) {
            document.getElementById('post_id_to_delete').value = postId; // Gán ID bài viết vào input
            document.getElementById('deleteModal').style.display = 'block'; // Mở modal
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none'; // Đóng modal
        }

        // Đóng modal khi người dùng nhấn bên ngoài modal
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        function openDeleteAccountModal() {
            document.getElementById('deleteAccountModal').style.display = 'block'; // Mở modal
        }

        function closeDeleteAccountModal() {
            document.getElementById('deleteAccountModal').style.display = 'none'; // Đóng modal
        }

        // Đóng modal khi người dùng nhấn bên ngoài modal
        window.onclick = function(event) {
            var modal = document.getElementById('deleteAccountModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        <?php if (isset($_SESSION['message'])): ?>
            showNotification("<?php echo htmlspecialchars($_SESSION['message']); ?>");
            // Xóa thông báo sau khi hiển thị
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>

        function openRepostModal(postId) {
            document.getElementById("repostPostId").value = postId; // Gán ID bài viết vào input ẩn
            document.getElementById("repostModal").style.display = "block"; // Mở modal
        }

        function closeRepostModal() {
            document.getElementById("repostModal").style.display = "none"; // Đóng modal
        }

    </script>
</body>
</html>
