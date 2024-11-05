<?php
session_start();

// Bao gồm tệp cấu hình
$config = include('config.php');

// Kiểm tra xem có thông tin cấu hình cơ sở dữ liệu không
if (!isset($config['db'])) {
    die("Thiếu thông tin cấu hình cơ sở dữ liệu.");
}

$dbConfig = $config['db'];
$dsn = "pgsql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['dbname']}";

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
    $userstatus = $_GET['status'] ?? 'all';
    $poststatus = $_GET['status'] ?? 'all';

    // Lọc theo status
    if ($userstatus === 'warned') {
        $userQuery = "SELECT * FROM users WHERE isadmin = FALSE AND status = 'warned' Order by id";
    } elseif ($userstatus === 'banned') {
        $userQuery = "SELECT * FROM users WHERE isadmin = FALSE AND status = 'banned' Order by id";
    } else {
        $userQuery = "SELECT * FROM users WHERE isadmin = FALSE Order by id";
    }

    $userStmt = $pdo->prepare($userQuery);
    $userStmt->execute();
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
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_status'])) {
    $postId = $_POST['post_id'];
    $status = $_POST['status'] === 'approve' ? 'approve' : 'canceled';

    // Cập nhật trạng thái bài viết
    $updateQuery = "UPDATE postdetail SET status = :status WHERE id = :id";
    $stmt = $pdo->prepare($updateQuery);
    $stmt->execute([':status' => $status, ':id' => $postId]);

    // Tải lại trang sau khi cập nhật
    header("Location: " . $_SERVER['PHP_SELF']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'deleteaccount') {
    $userId = $_POST['acount_id']; // Lấy ID tài khoản từ biểu mẫu thay vì từ session

    // Xóa tất cả bình luận của người dùng trong bảng postcomment
    $deleteCommentsStmt = $pdo->prepare("DELETE FROM postcomment WHERE userid = :userid");
    $deleteCommentsStmt->execute(['userid' => $userId]);

    // Xóa tất cả bài viết của người dùng trong bảng postdetail
    $deletePostsStmt = $pdo->prepare("DELETE FROM postdetail WHERE userid = :userid");
    $deletePostsStmt->execute(['userid' => $userId]);

    // Xóa các bản ghi trong login_attempts trước
    $deleteAttemptsStmt = $pdo->prepare("DELETE FROM login_attempts WHERE user_id = :user_id");
    $deleteAttemptsStmt->execute([':user_id' => $userId]);

    // Sau đó, xóa bản ghi trong bảng users
    $deleteUserStmt = $pdo->prepare("DELETE FROM users WHERE id = :id");
    $deleteUserStmt->execute([':id' => $userId]);


    // Xóa thông tin người dùng trong bảng users
    $deleteUserStmt = $pdo->prepare("DELETE FROM users WHERE id = :userid");
    $deleteUserStmt->execute(['userid' => $userId]);

    $_SESSION['section'] = 'userManagement';
    header("Location: admin.php"); // Chuyển hướng về trang chính hoặc trang đăng nhập
    exit;
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
            $message = "Mã admin đã được tạo thành công!";
        } else {
            $message = "Có lỗi xảy ra khi tạo mã admin.";
        }
    } else {
        $message = "Vui lòng nhập mã admin.";
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="./asset/css/admin.css">
    <link rel="stylesheet" href="./asset/css/base.css">
</head>
<body>
    <?php
        include 'header.php'; 
    ?>
    <div id="main" class="d-flex">
        <!-- Sidebar -->
        <nav class="aside-nav">
            <a href="#" class="new-item" onclick="showSection('dashboard')">Dash Board</a>
            <a href="#" class="new-item" onclick="showSection('userManagement')">Quản lý người dùng</a>
            <a href="#" class="new-item" onclick="showSection('postManagement')">Quản lý bài viết</a>
            <a href="#" class="new-item" onclick="showSection('adminCodeCreation')">Tạo mã admin</a> 
        </nav>

        <!-- Content -->
        <div class="content">
            <!-- Dashboard Section -->
            <div id="dashboard" class="section">
                <h2>Dash Board</h2>
                <!-- Nội dung Dashboard -->
            </div>
        
            <!-- User Management Section -->
            <div id="userManagement" class="section">
                <h2>Quản lý người dùng</h2>
                <!-- Filter Buttons -->
                <div class="filter-buttons">
                    <button class="active" onclick="filterUsers('all')">Tất cả người dùng</button>
                    <button onclick="filterUsers('warned')">Bị cảnh cáo</button>
                    <button onclick="filterUsers('banned')">Bị cấm</button>
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
                    <button class="active" onclick="filterUsers('all')">Tất cả bài viết</button>
                    <button onclick="filterUsers('notapproved')">Chưa duyệt</button>
                    <button onclick="filterUsers('approved')">Đã duyệt</button>
                    <button onclick="filterUsers('cancel')">Bị hủy</button>
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
                                    <a href="/Travelforum/Travelforum/postdetail.php?id=<?php echo htmlspecialchars($post['id']); ?>">
                                        <button><i class="fa-regular fa-eye"></i> Xem bài viết</button>
                                    </a>
                                </td>
                                <td class="approve-cell">
                                    <?php if ($post['status'] === 'notapproved'): ?>
                                        <!-- Form Duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <input type="hidden" name="status" value="approve">
                                            <button type="submit" name="update_status" class="approve-button">Duyệt</button>
                                        </form>
                                        <!-- Form Hủy duyệt -->
                                        <form method="POST" action="">
                                            <input type="hidden" name="post_id" value="<?php echo htmlspecialchars($post['id']); ?>">
                                            <input type="hidden" name="status" value="canceled">
                                            <button type="submit" name="update_status" class="cancel-button">Hủy</button>
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
                <input type="hidden" name="acount_id" id="account_id_to_delete">
                <button type="submit" class="btn btn-danger" name="action" value="deleteaccount">Xóa</button>
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
            </form>
        </div>
    </div>

    <script>
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
            window.location.href = `admin.php?status=${status}`;
        }

        function filterPosts(status) {
            // Chuyển hướng đến trang hiện tại với tham số status
            window.location.href = `admin.php?status=${status}`;
        }

    </script>
</body>
</html>
