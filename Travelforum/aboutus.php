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

    <!-- Banner about us -->
    <div class="banner text-center">
        <img src="./asset/img/aboutus/Banner.png" alt="Sứ mệnh" class="img-fluid my-3 banner-img">
    </div>


    <div class="content-container text-center my-5">
        <!-- Giới thiệu -->
        <section id="intro" class="my-5">
            <h2>Giới thiệu</h2>
            <p>Diễn đàn du lịch Việt Nam là nơi tập hợp những câu chuyện thú vị, kinh nghiệm quý báu và những địa điểm độc đáo từ khắp mọi miền tổ quốc. Chúng tôi tin rằng mỗi chuyến đi không chỉ là một hành trình về địa lý mà còn là một cuộc hành trình tâm hồn, nơi bạn có thể khám phá văn hóa, ẩm thực và phong tục tập quán đa dạng của các dân tộc. Từ những bãi biển tuyệt đẹp ở miền Trung cho đến những rặng núi hùng vĩ ở miền Bắc, mỗi điểm đến đều mang đến cho du khách những trải nghiệm mới mẻ và đầy cảm hứng.
            Chúng tôi khuyến khích các thành viên trong diễn đàn chia sẻ những kỷ niệm, những bài viết và hình ảnh về chuyến đi của mình, giúp mọi người có thêm thông tin và ý tưởng cho những hành trình sắp tới. Với mục tiêu kết nối những người yêu thích du lịch, diễn đàn không chỉ là nơi để trao đổi kiến thức mà còn là một cộng đồng nơi bạn có thể tìm kiếm sự hỗ trợ, lời khuyên và thậm chí là những người bạn đồng hành trong các cuộc phiêu lưu. Chúng tôi hy vọng rằng, qua từng bài viết và chia sẻ, bạn sẽ tìm thấy những góc nhìn mới và cảm nhận được vẻ đẹp tuyệt vời của đất nước Việt Nam.</p>
            <img src="./asset/img/aboutus/Aboutus1.jpg" alt="Giới thiệu" class="img-fluid my-3" style="border-radius: 10px;">
        </section>
    
        <!-- Sứ mệnh -->
        <section id="mission" class="my-5">
            <h2>Sứ mệnh của chúng tôi</h2>
            <p>Sứ mệnh của diễn đàn là cung cấp một nền tảng kết nối những người yêu thích du lịch, nhằm xây dựng một cộng đồng vững mạnh nơi mọi người có thể chia sẻ thông tin, kiến thức và cảm hứng trong hành trình khám phá Việt Nam. Chúng tôi mong muốn tạo ra một không gian mở, nơi mọi người đều có thể đóng góp ý kiến, chia sẻ những câu chuyện và trải nghiệm của riêng mình về các địa điểm, món ăn, văn hóa và con người Việt Nam. 
                Chúng tôi tin rằng, bằng cách kết nối các thành viên lại với nhau, diễn đàn sẽ trở thành một nguồn tài nguyên phong phú, giúp mọi người không chỉ có thêm thông tin hữu ích mà còn tìm thấy niềm đam mê và động lực để lên đường khám phá những điều kỳ diệu của đất nước. Từ việc tìm kiếm các chuyến đi thú vị cho đến việc khám phá những điểm đến ít người biết đến, diễn đàn là nơi lý tưởng để bạn bắt đầu hành trình của mình và xây dựng những kỷ niệm không thể nào quên.</p>            <img src="./asset/img/aboutus/Aboutus2.jpg" alt="Sứ mệnh" class="img-fluid my-3" style="border-radius: 10px;">
        </section>
    
        <!-- Cộng đồng -->
        <section id="community" class="my-5">
            <h2>Cộng đồng mạnh mẽ</h2>
            <p>Cộng đồng của chúng tôi không ngừng lớn mạnh, với các thành viên đến từ nhiều nơi khác nhau, tất cả đều có chung niềm đam mê du lịch và khám phá. Chúng tôi khuyến khích các thành viên chia sẻ không chỉ các kinh nghiệm thực tế mà còn cả những câu chuyện, hình ảnh và mẹo nhỏ giúp cho chuyến đi trở nên thú vị và an toàn hơn. Mỗi bài viết, mỗi bình luận và mỗi phản hồi đều góp phần làm phong phú thêm kho tàng kiến thức của chúng tôi. 
                 Ngoài ra, cộng đồng cũng tổ chức các hoạt động giao lưu, workshop và buổi gặp mặt để mọi người có cơ hội kết nối trực tiếp, trao đổi và học hỏi lẫn nhau. Với một môi trường thân thiện và cởi mở, chúng tôi mong muốn tất cả các thành viên đều có thể tìm thấy niềm vui và cảm hứng mới từ những người cùng đam mê. Hãy tham gia cùng chúng tôi, để không chỉ là một người du lịch mà còn là một phần của một cộng đồng đầy năng lượng và sáng tạo!</p>
            <a href="explore.php" class="btn btn-primary mt-3">Khám phá ngay!</a>
        </section>
    </div>
    <?php
        include 'footer.php'; 
    ?>
</body>
</html>
