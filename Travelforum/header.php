<div id="header">
    <div class="header-logo">
        <a href="index.php">
            <img src="./asset/img/ECHO.png" alt="">
        </a>
    </div>

    <div class="header-search">
        <form action="search.php" method="GET">
            <input type="text" name="keyword" placeholder="Tìm kiếm..." required />
            <button class="btn-header" type="submit">Tìm kiếm</button>
        </form>
    </div>

    <nav class="header-nav">
        <a href="post.php">Bài viết</a>
        <a href="explore.php">Khám phá</a>
        <a href="forum.php">Diễn đàn</a>
        <a href="aboutus.php">Về chúng tôi</a>
    </nav>

    <div class="header-account">
    <?php
        // Kiểm tra xem có username trong session không
        if (isset($_SESSION['username'])) {
            if (isset($_SESSION['isadmin']) && $_SESSION['isadmin'] == true) {
                // Nếu là admin, hiển thị nút Quản lí
                echo '<a class="btn-account" href="logout.php">Đăng xuất</a>';
                echo '<a class="btn-account" href="admin.php">Quản lí</a>';
                echo '<a class="btn-account" href="myaccount.php">Tài khoản</a>';
            } else {
                // Nếu không phải admin, hiển thị nút Tài khoản
                echo '<a class="btn-account" href="logout.php">Đăng xuất</a>';
                echo '<a class="btn-account" href="myaccount.php">Tài khoản</a>';
            }
        } else {
            // Nếu không có username, hiển thị nút Đăng nhập và Đăng ký
            echo '<a class="btn-account activee" href="login.php">Đăng nhập</a>';
            echo '<a class="btn-account" href="register.php">Đăng ký</a>';
        }
        ?>
    </div>
</div>
