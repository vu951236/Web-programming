<?php
session_start(); // Bắt đầu phiên
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
    <link rel="stylesheet" href="./asset/css/aboutus.css">
    <script src="./asset/js/base.js"></script>
    <script src="./asset/js/index.js"></script>
</head>
<body>
    <?php
        include 'header.php'; 
    ?>


    <!-- Body -->
<div id="main" style="display: flex;">

    <!-- Sidebar -->
    <div id="sidebar" style="width: 20%; padding: 20px; background-color: #f8f9fa;">
        <h4>Mục lục</h4>
        <ul style="list-style-type: none; padding: 0;">
            <li><a href="#section1">1. Giới thiệu</a></li>
            <li><a href="#section2">2. Thông tin thu thập</a></li>
            <li><a href="#section3">3. Cách sử dụng thông tin</a></li>
            <li><a href="#section4">4. Bảo mật thông tin</a></li>
            <li><a href="#section5">5. Quyền lợi của bạn</a></li>
            <li><a href="#terms">6. Điều khoản sử dụng</a></li>
        </ul>
    </div>

    <!-- Main Content -->
        <div id="content" style="flex: 1; padding: 20px;">
            <h1>Chính sách bảo mật</h1>

            <h2 id="section1">1. Giới thiệu</h2>
            <p>
                Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn khi bạn sử dụng dịch vụ của chúng tôi. 
                Chính sách này mô tả cách chúng tôi thu thập, sử dụng, và bảo vệ thông tin cá nhân của bạn.
                Việc sử dụng dịch vụ của chúng tôi đồng nghĩa với việc bạn đồng ý với các điều khoản trong chính sách này.
            </p>

            <h2 id="section2">2. Thông tin thu thập</h2>
            <p>
                Chúng tôi thu thập thông tin từ bạn khi bạn đăng ký, đặt hàng hoặc tương tác với dịch vụ của chúng tôi. 
                Thông tin thu thập bao gồm nhưng không giới hạn:
            </p>
            <ul>
                <li>Tên đầy đủ</li>
                <li>Địa chỉ email</li>
                <li>Số điện thoại</li>
                <li>Địa chỉ giao hàng</li>
                <li>Thông tin thanh toán</li>
            </ul>
            <p>
                Ngoài ra, chúng tôi cũng có thể thu thập thông tin tự động khi bạn sử dụng dịch vụ, 
                bao gồm địa chỉ IP, loại trình duyệt, thời gian truy cập và trang web bạn đã truy cập.
            </p>

            <h2 id="section3">3. Cách sử dụng thông tin</h2>
            <p>
                Thông tin của bạn có thể được sử dụng để:
            </p>
            <ul>
                <li>Cung cấp dịch vụ cho bạn và cải thiện trải nghiệm người dùng.</li>
                <li>Gửi thông tin cập nhật về đơn hàng hoặc dịch vụ của chúng tôi.</li>
                <li>Liên lạc với bạn để thông báo về sản phẩm mới, khuyến mãi và thông tin khác mà bạn có thể quan tâm.</li>
                <li>Phân tích và cải thiện dịch vụ, thông qua việc nghiên cứu hành vi người dùng.</li>
            </ul>

            <h2 id="section4">4. Bảo mật thông tin</h2>
            <p>
                Chúng tôi thực hiện các biện pháp bảo mật cần thiết để bảo vệ thông tin cá nhân của bạn khỏi bị truy cập trái phép, 
                sử dụng sai mục đích hoặc tiết lộ cho bên thứ ba. 
                Chúng tôi sử dụng công nghệ mã hóa và hệ thống bảo mật dữ liệu để đảm bảo thông tin của bạn luôn được bảo vệ.
            </p>
            <p>
                Tuy nhiên, không có phương thức truyền tải qua Internet hay phương thức lưu trữ điện tử nào là an toàn tuyệt đối. 
                Do đó, chúng tôi không thể đảm bảo sự an toàn tuyệt đối của thông tin cá nhân của bạn.
            </p>

            <h2 id="section5">5. Quyền lợi của bạn</h2>
            <p>
                Bạn có quyền yêu cầu chúng tôi cung cấp thông tin về các dữ liệu cá nhân mà chúng tôi đang lưu trữ. 
                Bạn cũng có quyền yêu cầu sửa đổi hoặc xóa dữ liệu cá nhân của mình nếu bạn cảm thấy thông tin đó không chính xác hoặc không cần thiết.
            </p>
            <p>
                Bạn có quyền từ chối việc sử dụng thông tin cá nhân của bạn cho các mục đích tiếp thị. 
                Để thực hiện quyền lợi của mình, bạn chỉ cần liên hệ với chúng tôi qua địa chỉ email hoặc số điện thoại đã cung cấp trong phần Liên hệ.
            </p>

            <h2 id="terms">6. Điều khoản sử dụng</h2>
            <p>
                Khi bạn truy cập vào trang web của chúng tôi, bạn đồng ý với các điều khoản sử dụng sau đây:
            </p>
            <ul>
                <li>Bạn cam kết cung cấp thông tin chính xác và đầy đủ khi đăng ký sử dụng dịch vụ.</li>
                <li>Bạn chịu trách nhiệm về tất cả các hoạt động diễn ra dưới tài khoản của bạn.</li>
                <li>Chúng tôi có quyền từ chối hoặc chấm dứt dịch vụ của bạn nếu phát hiện hành vi vi phạm các điều khoản này.</li>
                <li>Bạn đồng ý không sử dụng dịch vụ của chúng tôi cho các mục đích bất hợp pháp hoặc trái với các quy định hiện hành.</li>
                <li>Chúng tôi có quyền sửa đổi hoặc cập nhật các điều khoản sử dụng mà không cần thông báo trước. Bạn nên thường xuyên kiểm tra để biết các thay đổi.</li>
            </ul>
            <p>
                Nếu bạn có bất kỳ câu hỏi nào liên quan đến điều khoản sử dụng này, xin vui lòng liên hệ với chúng tôi qua thông tin liên lạc có trong phần Liên hệ.
            </p>
        </div>
    </div>

    
    <?php
        include 'footer.php'; 
    ?>
</body>
</html>