CREATE TABLE postdetail (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date DATE,
    image VARCHAR(255),
    content TEXT,
    rate NUMERIC(3, 2)
);
INSERT INTO postdetail (name, date, image, content, rate)
VALUES (
    'Kinh nghiệm du lịch Đà Nẵng',
    '2024-10-15',
    '/images/danang.jpg',
    'Kinh Nghiệm Du Lịch Đà Nẵng – Điểm Đến Không Thể Bỏ Qua

Đà Nẵng, thành phố biển xinh đẹp miền Trung, từ lâu đã trở thành điểm đến lý tưởng cho những ai yêu thích vẻ đẹp thiên nhiên hòa quyện cùng nét văn hóa đặc sắc. Nổi tiếng với những bãi biển xanh ngắt, những cây cầu độc đáo và vô vàn món ăn ngon, Đà Nẵng mang đến cho du khách trải nghiệm đa dạng và khó quên.

Khi đến Đà Nẵng, bãi biển Mỹ Khê là điểm dừng chân đầu tiên không thể bỏ qua. Đây là một trong những bãi biển đẹp nhất Việt Nam, nổi tiếng với bãi cát trắng mịn và làn nước trong xanh. Thả mình dưới ánh nắng dịu nhẹ, cảm nhận làn gió biển mát lạnh và nghe tiếng sóng vỗ bờ, du khách sẽ cảm nhận được sự thư thái và bình yên.

Đà Nẵng còn được biết đến với hệ thống những cây cầu độc đáo, mà nổi bật nhất là Cầu Rồng. Cây cầu này không chỉ là điểm kết nối giữa các khu vực trong thành phố mà còn là biểu tượng hiện đại của Đà Nẵng. Vào cuối tuần, du khách sẽ được chiêm ngưỡng màn trình diễn rồng phun lửa và nước đặc sắc, tạo nên khung cảnh lung linh và sống động.

Nếu yêu thích không gian thiên nhiên hùng vĩ, Bà Nà Hills chắc chắn là điểm đến tiếp theo mà bạn nên ghé qua. Nằm ở độ cao hơn 1.400 mét, Bà Nà Hills là khu nghỉ dưỡng kết hợp giải trí với cảnh quan núi non trùng điệp, khí hậu mát mẻ quanh năm và những công trình kiến trúc Pháp cổ kính. Cầu Vàng với hai bàn tay khổng lồ nâng đỡ là điểm nhấn nổi tiếng, mang đến một góc nhìn tuyệt đẹp và huyền ảo giữa mây trời.

Ẩm thực Đà Nẵng là một trong những yếu tố góp phần tạo nên sức hút của thành phố này. Bạn có thể thử các món đặc sản như bánh tráng cuốn thịt heo, mì Quảng, bún chả cá và hải sản tươi ngon. Hương vị đậm đà và đa dạng của những món ăn này sẽ khiến bất kỳ ai cũng phải xiêu lòng và muốn quay lại để thưởng thức thêm.

Với cảnh sắc thiên nhiên tươi đẹp, những công trình hiện đại và nền ẩm thực phong phú, Đà Nẵng thực sự là điểm đến hoàn hảo cho những ai muốn tìm kiếm sự thư giãn và trải nghiệm văn hóa độc đáo của miền Trung. Đây là nơi bạn có thể hòa mình vào thiên nhiên, chiêm ngưỡng sự phát triển hiện đại của một thành phố trẻ, và tận hưởng những khoảnh khắc đáng nhớ cùng gia đình và bạn bè.',
    4.5
);
UPDATE postdetail
SET content = 'Đà Nẵng, thành phố biển xinh đẹp miền Trung, từ lâu đã trở thành điểm đến lý tưởng cho những ai yêu thích vẻ đẹp thiên nhiên hòa quyện cùng nét văn hóa đặc sắc. Nổi tiếng với những bãi biển xanh ngắt, những cây cầu độc đáo và vô vàn món ăn ngon, Đà Nẵng mang đến cho du khách trải nghiệm đa dạng và khó quên.

Khi đến Đà Nẵng, bãi biển Mỹ Khê là điểm dừng chân đầu tiên không thể bỏ qua. Đây là một trong những bãi biển đẹp nhất Việt Nam, nổi tiếng với bãi cát trắng mịn và làn nước trong xanh. Thả mình dưới ánh nắng dịu nhẹ, cảm nhận làn gió biển mát lạnh và nghe tiếng sóng vỗ bờ, du khách sẽ cảm nhận được sự thư thái và bình yên.

Đà Nẵng còn được biết đến với hệ thống những cây cầu độc đáo, mà nổi bật nhất là Cầu Rồng. Cây cầu này không chỉ là điểm kết nối giữa các khu vực trong thành phố mà còn là biểu tượng hiện đại của Đà Nẵng. Vào cuối tuần, du khách sẽ được chiêm ngưỡng màn trình diễn rồng phun lửa và nước đặc sắc, tạo nên khung cảnh lung linh và sống động.

Nếu yêu thích không gian thiên nhiên hùng vĩ, Bà Nà Hills chắc chắn là điểm đến tiếp theo mà bạn nên ghé qua. Nằm ở độ cao hơn 1.400 mét, Bà Nà Hills là khu nghỉ dưỡng kết hợp giải trí với cảnh quan núi non trùng điệp, khí hậu mát mẻ quanh năm và những công trình kiến trúc Pháp cổ kính. Cầu Vàng với hai bàn tay khổng lồ nâng đỡ là điểm nhấn nổi tiếng, mang đến một góc nhìn tuyệt đẹp và huyền ảo giữa mây trời.

Ẩm thực Đà Nẵng là một trong những yếu tố góp phần tạo nên sức hút của thành phố này. Bạn có thể thử các món đặc sản như bánh tráng cuốn thịt heo, mì Quảng, bún chả cá và hải sản tươi ngon. Hương vị đậm đà và đa dạng của những món ăn này sẽ khiến bất kỳ ai cũng phải xiêu lòng và muốn quay lại để thưởng thức thêm.

Với cảnh sắc thiên nhiên tươi đẹp, những công trình hiện đại và nền ẩm thực phong phú, Đà Nẵng thực sự là điểm đến hoàn hảo cho những ai muốn tìm kiếm sự thư giãn và trải nghiệm văn hóa độc đáo của miền Trung. Đây là nơi bạn có thể hòa mình vào thiên nhiên, chiêm ngưỡng sự phát triển hiện đại của một thành phố trẻ, và tận hưởng những khoảnh khắc đáng nhớ cùng gia đình và bạn bè.'
WHERE name = 'Kinh nghiệm du lịch Đà Nẵng';
CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    date DATE,
    idpost INT,
    FOREIGN KEY (idpost) REFERENCES postdetail(id) ON DELETE CASCADE
);
INSERT INTO comment (username, content, date, idpost)
VALUES ('vu951236', 'Đẹp quá', '2024-10-15', 1);
ALTER TABLE postdetail
ADD COLUMN view int;

CREATE TABLE locationdetail (
    id SERIAL PRIMARY KEY,        -- Thêm cột id làm khóa chính
    name VARCHAR(255) NOT NULL,   -- Cột name kiểu chuỗi, không được phép null
    information TEXT,             -- Cột information kiểu văn bản
    image VARCHAR(255),           -- Cột image kiểu chuỗi (đường dẫn đến hình ảnh)
    rate NUMERIC(3, 2),           -- Cột rate kiểu số (điểm số với tối đa 3 chữ số, 2 chữ số thập phân)
    amongrate NUMERIC(3, 2),      -- Cột amongrate kiểu số
    comment TEXT,                 -- Cột comment kiểu văn bản
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Cột date kiểu thời gian, mặc định là thời gian hiện tại
);
INSERT INTO locationdetail (name) VALUES
('An Giang'),
('Bà Rịa - Vũng Tàu'),
('Bắc Giang'),
('Bắc Kạn'),
('Bạc Liêu'),
('Bắc Ninh'),
('Bến Tre'),
('Bình Định'),
('Bình Dương'),
('Bình Phước'),
('Bình Thuận'),
('Cà Mau'),
('Cần Thơ'),
('Cao Bằng'),
('Đà Nẵng'),
('Đắk Lắk'),
('Đắk Nông'),
('Điện Biên'),
('Đồng Nai'),
('Đồng Tháp'),
('Gia Lai'),
('Hà Giang'),
('Hà Nam'),
('Hà Nội'),
('Hà Tĩnh'),
('Hải Dương'),
('Hải Phòng'),
('Hậu Giang'),
('Hòa Bình'),
('Hưng Yên'),
('Khánh Hòa'),
('Kiên Giang'),
('Kon Tum'),
('Lai Châu'),
('Lâm Đồng'),
('Lạng Sơn'),
('Lào Cai'),
('Long An'),
('Nam Định'),
('Nghệ An'),
('Ninh Bình'),
('Ninh Thuận'),
('Phú Thọ'),
('Phú Yên'),
('Quảng Bình'),
('Quảng Nam'),
('Quảng Ngãi'),
('Quảng Ninh'),
('Quảng Trị'),
('Sóc Trăng'),
('Sơn La'),
('Tây Ninh'),
('Thái Bình'),
('Thái Nguyên'),
('Thanh Hóa'),
('Thừa Thiên Huế'),
('Tiền Giang'),
('TP. Hồ Chí Minh'),
('Trà Vinh'),
('Tuyên Quang'),
('Vĩnh Long'),
('Vĩnh Phúc'),
('Yên Bái');
Select * from locationcomment
Select * from postcomment
Select * from locationdetail

ALTER TABLE locationdetail
DROP COLUMN comment;
CREATE TABLE locationcomment (
    id SERIAL PRIMARY KEY,        -- Khóa chính tự tăng
    username VARCHAR(255) NOT NULL,  -- Tên người dùng
    content TEXT,                 -- Nội dung bình luận
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Ngày giờ bình luận, mặc định là thời gian hiện tại
    idlocation INT NOT NULL,       -- ID của địa điểm, kiểu số nguyên
    FOREIGN KEY (idlocation) REFERENCES locationdetail(id) ON DELETE CASCADE
);

Drop table locationcomment
UPDATE locationdetail SET information = CASE name
    WHEN 'An Giang' THEN 'Tỉnh An Giang nổi tiếng với chợ nổi Long Xuyên và vùng Bảy Núi linh thiêng.'
    WHEN 'Bà Rịa - Vũng Tàu' THEN 'Nơi có bãi biển Vũng Tàu nổi tiếng, thu hút nhiều khách du lịch.'
    WHEN 'Bắc Giang' THEN 'Bắc Giang có nhiều cảnh quan tự nhiên và là nơi sản xuất vải thiều nổi tiếng.'
    WHEN 'Bắc Kạn' THEN 'Bắc Kạn có hồ Ba Bể và nhiều cảnh quan thiên nhiên tuyệt đẹp.'
    WHEN 'Bạc Liêu' THEN 'Nổi tiếng với điện gió và gắn liền với giai thoại Công tử Bạc Liêu.'
    WHEN 'Bắc Ninh' THEN 'Bắc Ninh là cái nôi của dân ca quan họ truyền thống Việt Nam.'
    WHEN 'Bến Tre' THEN 'Được mệnh danh là "xứ dừa" với nhiều đặc sản và làng nghề truyền thống.'
    WHEN 'Bình Định' THEN 'Bình Định nổi tiếng với võ cổ truyền và nhiều di tích lịch sử.'
    WHEN 'Bình Dương' THEN 'Bình Dương là trung tâm công nghiệp lớn của miền Nam Việt Nam.'
    WHEN 'Bình Phước' THEN 'Bình Phước nổi tiếng với rừng cao su và điều, kinh tế chủ yếu từ nông nghiệp.'
    WHEN 'Bình Thuận' THEN 'Nơi có Mũi Né với bãi biển đẹp và các đồi cát nổi tiếng.'
    WHEN 'Cà Mau' THEN 'Cà Mau là cực Nam của Việt Nam, nổi tiếng với rừng ngập mặn.'
    WHEN 'Cần Thơ' THEN 'Cần Thơ là trung tâm kinh tế, văn hóa của Đồng bằng sông Cửu Long.'
    WHEN 'Cao Bằng' THEN 'Cao Bằng có thác Bản Giốc và nhiều danh lam thắng cảnh.'
    WHEN 'Đà Nẵng' THEN 'Đà Nẵng là thành phố hiện đại, có nhiều bãi biển và cầu Rồng nổi tiếng.'
    WHEN 'Đắk Lắk' THEN 'Đắk Lắk là trung tâm cà phê lớn và văn hóa Tây Nguyên.'
    WHEN 'Đắk Nông' THEN 'Nổi tiếng với các thác nước và cảnh quan thiên nhiên hùng vĩ.'
    WHEN 'Điện Biên' THEN 'Điện Biên gắn liền với chiến thắng Điện Biên Phủ lịch sử.'
    WHEN 'Đồng Nai' THEN 'Đồng Nai có nền công nghiệp phát triển và khu bảo tồn thiên nhiên Nam Cát Tiên.'
    WHEN 'Đồng Tháp' THEN 'Nơi có vườn quốc gia Tràm Chim và nhiều cánh đồng sen.'
    WHEN 'Gia Lai' THEN 'Gia Lai nổi tiếng với Biển Hồ và văn hóa cồng chiêng Tây Nguyên.'
    WHEN 'Hà Giang' THEN 'Hà Giang có cao nguyên đá Đồng Văn và nhiều cung đường đèo đẹp.'
    WHEN 'Hà Nam' THEN 'Hà Nam nổi tiếng với làng nghề và chùa Tam Chúc lớn nhất Việt Nam.'
    WHEN 'Hà Nội' THEN 'Thủ đô của Việt Nam với nhiều di tích lịch sử và văn hóa.'
    WHEN 'Hà Tĩnh' THEN 'Hà Tĩnh có bãi biển Thiên Cầm và các di tích lịch sử.'
    WHEN 'Hải Dương' THEN 'Hải Dương nổi tiếng với bánh đậu xanh và các làng nghề truyền thống.'
    WHEN 'Hải Phòng' THEN 'Hải Phòng là thành phố cảng, có bãi biển Đồ Sơn nổi tiếng.'
    WHEN 'Hậu Giang' THEN 'Hậu Giang là một tỉnh thuộc đồng bằng sông Cửu Long, phát triển nông nghiệp.'
    WHEN 'Hòa Bình' THEN 'Hòa Bình có thủy điện Hòa Bình và văn hóa dân tộc Mường.'
    WHEN 'Hưng Yên' THEN 'Hưng Yên nổi tiếng với nhãn lồng và nhiều làng nghề truyền thống.'
    WHEN 'Khánh Hòa' THEN 'Khánh Hòa có vịnh Nha Trang và nhiều bãi biển đẹp.'
    WHEN 'Kiên Giang' THEN 'Kiên Giang có đảo Phú Quốc và cảnh quan biển đảo đẹp.'
    WHEN 'Kon Tum' THEN 'Kon Tum nổi tiếng với nhà rông Tây Nguyên và các bản làng dân tộc.'
    WHEN 'Lai Châu' THEN 'Lai Châu có nhiều đỉnh núi cao và phong cảnh hùng vĩ.'
    WHEN 'Lâm Đồng' THEN 'Lâm Đồng có thành phố Đà Lạt với khí hậu mát mẻ quanh năm.'
    WHEN 'Lạng Sơn' THEN 'Lạng Sơn là tỉnh biên giới với nhiều danh lam thắng cảnh.'
    WHEN 'Lào Cai' THEN 'Lào Cai có Sapa, điểm đến nổi tiếng với cảnh quan núi rừng.'
    WHEN 'Long An' THEN 'Long An có nền nông nghiệp phát triển và giáp ranh TP. Hồ Chí Minh.'
    WHEN 'Nam Định' THEN 'Nam Định nổi tiếng với nhà thờ lớn và làng nghề chạm bạc.'
    WHEN 'Nghệ An' THEN 'Nghệ An là quê hương của Chủ tịch Hồ Chí Minh, có biển Cửa Lò.'
    WHEN 'Ninh Bình' THEN 'Ninh Bình có Tràng An, Tam Cốc - Bích Động và nhiều di sản thiên nhiên.'
    WHEN 'Ninh Thuận' THEN 'Nổi tiếng với tháp Chăm và các cánh đồng muối, nho đặc trưng.'
    WHEN 'Phú Thọ' THEN 'Phú Thọ là đất tổ Hùng Vương với đền Hùng nổi tiếng.'
    WHEN 'Phú Yên' THEN 'Phú Yên có Gành Đá Đĩa và nhiều bãi biển hoang sơ.'
    WHEN 'Quảng Bình' THEN 'Quảng Bình có động Phong Nha - Kẻ Bàng và nhiều hang động lớn.'
    WHEN 'Quảng Nam' THEN 'Quảng Nam có phố cổ Hội An và thánh địa Mỹ Sơn.'
    WHEN 'Quảng Ngãi' THEN 'Quảng Ngãi nổi tiếng với đảo Lý Sơn và văn hóa Champa.'
    WHEN 'Quảng Ninh' THEN 'Quảng Ninh có vịnh Hạ Long là di sản thiên nhiên thế giới.'
    WHEN 'Quảng Trị' THEN 'Quảng Trị gắn liền với nhiều di tích lịch sử chiến tranh.'
    WHEN 'Sóc Trăng' THEN 'Sóc Trăng có chùa Dơi, chùa Chén Kiểu và văn hóa Khmer.'
    WHEN 'Sơn La' THEN 'Sơn La có cao nguyên Mộc Châu với nhiều đồi chè và cảnh quan đẹp.'
    WHEN 'Tây Ninh' THEN 'Tây Ninh có núi Bà Đen và đạo Cao Đài.'
    WHEN 'Thái Bình' THEN 'Thái Bình là quê lúa, phát triển nông nghiệp và làng nghề.'
    WHEN 'Thái Nguyên' THEN 'Thái Nguyên nổi tiếng với chè Thái Nguyên và các khu công nghiệp.'
    WHEN 'Thanh Hóa' THEN 'Thanh Hóa có bãi biển Sầm Sơn và nhiều di tích lịch sử.'
    WHEN 'Thừa Thiên Huế' THEN 'Huế là cố đô với nhiều di sản văn hóa và lăng tẩm triều Nguyễn.'
    WHEN 'Tiền Giang' THEN 'Tiền Giang có chợ nổi Cái Bè và các cù lao sông nước.'
    WHEN 'TP. Hồ Chí Minh' THEN 'Trung tâm kinh tế lớn nhất Việt Nam với nhiều hoạt động sôi động.'
    WHEN 'Trà Vinh' THEN 'Trà Vinh có nhiều chùa Khmer và văn hóa truyền thống.'
    WHEN 'Tuyên Quang' THEN 'Tuyên Quang có di tích Tân Trào, gắn với lịch sử cách mạng.'
    WHEN 'Vĩnh Long' THEN 'Vĩnh Long có nhiều cù lao và đặc trưng miền sông nước.'
    WHEN 'Vĩnh Phúc' THEN 'Vĩnh Phúc có Tam Đảo, địa điểm nghỉ dưỡng và phong cảnh đẹp.'
    WHEN 'Yên Bái' THEN 'Yên Bái có ruộng bậc thang Mù Cang Chải nổi tiếng.'
END;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,                  -- Khóa chính tự tăng
    username VARCHAR(50) UNIQUE NOT NULL,   -- Tên người dùng, giá trị duy nhất, không được phép null
    password VARCHAR(255) NOT NULL,         -- Mật khẩu
    email VARCHAR(255) UNIQUE NOT NULL,     -- Email, giá trị duy nhất, không được phép null
    fullname VARCHAR(255),                  -- Họ và tên đầy đủ của người dùng
    address TEXT,                           -- Địa chỉ người dùng
    isadmin BOOLEAN DEFAULT FALSE,          -- Cờ phân quyền quản trị, mặc định là false (người dùng bình thường)
    avatar VARCHAR(255),                    -- Đường dẫn ảnh đại diện
    banned_until TIMESTAMP,                 -- Ngày hết hạn khóa tài khoản
    count_post INT DEFAULT 0                -- Số lượng bài đăng, mặc định là 0
);
