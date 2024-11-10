-- MySQL equivalent of PostgreSQL dump

-- Tạo bảng admincode
CREATE TABLE admincode (
    id INT NOT NULL AUTO_INCREMENT,
    code VARCHAR(255) NOT NULL,
    expiration_time TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- Tạo bảng postcomment
CREATE TABLE postcomment (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idpost INT,
    userid INT,
    PRIMARY KEY (id)
);

-- Tạo bảng forumcomment
CREATE TABLE forumcomment (
    id INT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tạo bảng forumdetail
CREATE TABLE forumdetail (
    id INT NOT NULL AUTO_INCREMENT,
    date TIMESTAMP,
    image VARCHAR(255),
    content TEXT,
    likes_count INT DEFAULT 0,
    userid INT,
    status VARCHAR(50) DEFAULT 'notapproved',
    PRIMARY KEY (id)
);

-- Tạo bảng locationcomment
CREATE TABLE locationcomment (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    content TEXT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idlocation INT NOT NULL,
    PRIMARY KEY (id)
);

-- Tạo bảng locationdetail
CREATE TABLE locationdetail (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    information TEXT,
    image VARCHAR(255),
    rate DECIMAL(3,2) DEFAULT 0,
    amongrate DECIMAL(3,2) DEFAULT 0,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(255),
    point DECIMAL DEFAULT 0,
    type VARCHAR(50),
    PRIMARY KEY (id)
);

-- Tạo bảng login_attempts
CREATE TABLE login_attempts (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tạo bảng post_likes
CREATE TABLE post_likes (
    id INT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (id)
);

-- Tạo bảng postdetail
CREATE TABLE postdetail (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    date TIMESTAMP,
    image VARCHAR(255),
    content TEXT,
    rate DECIMAL(3,2) DEFAULT 0,
    amongrate INT DEFAULT 0,
    location VARCHAR(255),
    view INT DEFAULT 0,
    userid INT,
    description TEXT,
    status VARCHAR(50) DEFAULT 'notapproved',
    typepost VARCHAR(50),
    PRIMARY KEY (id)
);

-- Tạo bảng users
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    fullname VARCHAR(255),
    address TEXT,
    isadmin BOOLEAN DEFAULT FALSE,
    avatar VARCHAR(255),
    banned_until TIMESTAMP,
    point DECIMAL DEFAULT 0,
    status VARCHAR(50) DEFAULT 'exemplary',
    warned_until TIMESTAMP,
    PRIMARY KEY (id)
);
INSERT INTO locationdetail (id, name, information, rate, amongrate, date, location, point, type) VALUES
(1, 'An Giang', 'Tỉnh An Giang nổi tiếng với chợ nổi Long Xuyên và vùng Bảy Núi linh thiêng.', 0.00, 0.00, '2024-10-30 08:00:12', 'angiang', 0, 'dongbang'),
(50, 'Sóc Trăng', 'Sóc Trăng có chùa Dơi, chùa Chén Kiểu và văn hóa Khmer.', 0.00, 0.00, '2024-10-30 08:00:12', 'soctrang', 0, 'dongbang'),
(53, 'Thái Bình', 'Thái Bình là quê lúa, phát triển nông nghiệp và làng nghề.', 0.00, 0.00, '2024-10-30 08:00:12', 'thaibinh', 0, 'dongbang'),
(57, 'Tiền Giang', 'Tiền Giang có chợ nổi Cái Bè và các cù lao sông nước.', 0.00, 0.00, '2024-10-30 08:00:12', 'tiengiang', 0, 'dongbang'),
(59, 'Trà Vinh', 'Trà Vinh có nhiều chùa Khmer và văn hóa truyền thống.', 0.00, 0.00, '2024-10-30 08:00:12', 'travinh', 0, 'dongbang'),
(62, 'Vĩnh Phúc', 'Vĩnh Phúc có Tam Đảo, địa điểm nghỉ dưỡng và phong cảnh đẹp.', 0.00, 0.00, '2024-10-30 08:00:12', 'vinhphuc', 0, 'dongbang'),
(5, 'Bạc Liêu', 'Nổi tiếng với điện gió và gắn liền với giai thoại Công tử Bạc Liêu.', 0.00, 0.00, '2024-10-30 08:00:12', 'baclieu', 0, 'dongbang');
INSERT INTO locationdetail (id, name, information, rate, amongrate, date, location, point, type) VALUES
(6, 'Bắc Ninh', 'Bắc Ninh là cái nôi của dân ca quan họ truyền thống Việt Nam.', 0.00, 0.00, '2024-10-30 08:00:12', 'bacninh', 0, 'dongbang'),
(7, 'Bến Tre', 'Được mệnh danh là "xứ dừa" với nhiều đặc sản và làng nghề truyền thống.', 0.00, 0.00, '2024-10-30 08:00:12', 'bentre', 0, 'dongbang'),
(61, 'Vĩnh Long', 'Vĩnh Long có nhiều cù lao và đặc trưng miền sông nước.', 0.00, 0.00, '2024-10-30 08:00:12', 'vinhlong', 0, 'dongbang'),
(9, 'Bình Dương', 'Bình Dương là trung tâm công nghiệp lớn của miền Nam Việt Nam.', 0.00, 0.00, '2024-10-30 08:00:12', 'binhduong', 0, 'dongbang'),
(10, 'Bình Phước', 'Bình Phước nổi tiếng với rừng cao su và điều, kinh tế chủ yếu từ nông nghiệp.', 0.00, 0.00, '2024-10-30 08:00:12', 'binhphuoc', 0, 'dongbang'),
(13, 'Cần Thơ', 'Cần Thơ là trung tâm kinh tế, văn hóa của Đồng bằng sông Cửu Long.', 0.00, 0.00, '2024-10-30 08:00:12', 'cantho', 0, 'dongbang'),
(19, 'Đồng Nai', 'Đồng Nai có nền công nghiệp phát triển và khu bảo tồn thiên nhiên Nam Cát Tiên.', 0.00, 0.00, '2024-10-30 08:00:12', 'dongnai', 0, 'dongbang');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) VALUES
(4, 'Bắc Kạn', 'Bắc Kạn có hồ Ba Bể và nhiều cảnh quan thiên nhiên tuyệt đẹp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'backan', 0, 'nui'),
(16, 'Đắk Lắk', 'Đắk Lắk là trung tâm cà phê lớn và văn hóa Tây Nguyên.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'daklak', 0, 'nui'),
(52, 'Tây Ninh', 'Tây Ninh có núi Bà Đen và đạo Cao Đài.', 'database/locations/tayninh.jpg', 0.00, 0.00, '2024-10-30 08:00:12', 'tayninh', 5.9, 'dongbang'),
(54, 'Thái Nguyên', 'Thái Nguyên nổi tiếng với chè Thái Nguyên và các khu công nghiệp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'thainguyen', 0, 'nui'),
(60, 'Tuyên Quang', 'Tuyên Quang có di tích Tân Trào, gắn với lịch sử cách mạng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'tuyenquang', 0, 'nui'),
(63, 'Yên Bái', 'Yên Bái có ruộng bậc thang Mù Cang Chải nổi tiếng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'yenbai', 0, 'nui'),
(3, 'Bắc Giang', 'Bắc Giang có nhiều cảnh quan tự nhiên và là nơi sản xuất vải thiều nổi tiếng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'bacgiang', 0, 'nui');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(14, 'Cao Bằng', 'Cao Bằng có thác Bản Giốc và nhiều danh lam thắng cảnh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'caobang', 0, 'nui'),
(17, 'Đắk Nông', 'Nổi tiếng với các thác nước và cảnh quan thiên nhiên hùng vĩ.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'daknong', 0, 'nui'),
(18, 'Điện Biên', 'Điện Biên gắn liền với chiến thắng Điện Biên Phủ lịch sử.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'dienbien', 0, 'nui'),
(20, 'Đồng Tháp', 'Nơi có vườn quốc gia Tràm Chim và nhiều cánh đồng sen.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'dongthap', 0, 'dongbang'),
(24, 'Hà Nội', 'Thủ đô của Việt Nam với nhiều di tích lịch sử và văn hóa.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hanoi', 0, 'dongbang'),
(27, 'Hải Phòng', 'Hải Phòng là thành phố cảng, có bãi biển Đồ Sơn nổi tiếng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'haiphong', 0, 'dongbang'),
(28, 'Hậu Giang', 'Hậu Giang là một tỉnh thuộc đồng bằng sông Cửu Long, phát triển nông nghiệp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'haugiang', 0, 'dongbang');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(30, 'Hưng Yên', 'Hưng Yên nổi tiếng với nhãn lồng và nhiều làng nghề truyền thống.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hungyen', 0, 'dongbang'),
(23, 'Hà Nam', 'Hà Nam nổi tiếng với làng nghề và chùa Tam Chúc lớn nhất Việt Nam.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hanam', 0, 'dongbang'),
(38, 'Long An', 'Long An có nền nông nghiệp phát triển và giáp ranh TP. Hồ Chí Minh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'longan', 0, 'dongbang'),
(39, 'Nam Định', 'Nam Định nổi tiếng với nhà thờ lớn và làng nghề chạm bạc.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'namdinh', 0, 'dongbang'),
(41, 'Ninh Bình', 'Ninh Bình có Tràng An, Tam Cốc - Bích Động và nhiều di sản thiên nhiên.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'ninhbinh', 0, 'dongbang'),
(48, 'Quảng Ninh', 'Quảng Ninh có vịnh Hạ Long là di sản thiên nhiên thế giới.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'quangninh', 0, 'bien'),
(51, 'Sơn La', 'Sơn La có cao nguyên Mộc Châu với nhiều đồi chè và cảnh quan đẹp.', 'database/locations/sonla.jpg', 0.00, 0.00, '2024-10-30 08:00:12', 'sonla', 6, 'nui');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(22, 'Hà Giang', 'Hà Giang có cao nguyên đá Đồng Văn và nhiều cung đường đèo đẹp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hagiang', 5.6, 'nui'),
(36, 'Lạng Sơn', 'Lạng Sơn là tỉnh biên giới với nhiều danh lam thắng cảnh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'langson', 0, 'nui'),
(43, 'Phú Thọ', 'Phú Thọ là đất tổ Hùng Vương với đền Hùng nổi tiếng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'phutho', 0, 'nui'),
(21, 'Gia Lai', 'Gia Lai nổi tiếng với Biển Hồ và văn hóa cồng chiêng Tây Nguyên.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'gialai', 0, 'nui'),
(25, 'Hà Tĩnh', 'Hà Tĩnh có bãi biển Thiên Cầm và các di tích lịch sử.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hatinh', 0, 'nui'),
(29, 'Hòa Bình', 'Hòa Bình có thủy điện Hòa Bình và văn hóa dân tộc Mường.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hoabinh', 0, 'nui'),
(33, 'Kon Tum', 'Kon Tum nổi tiếng với nhà rông Tây Nguyên và các bản làng dân tộc.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'kontum', 0, 'nui');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(34, 'Lai Châu', 'Lai Châu có nhiều đỉnh núi cao và phong cảnh hùng vĩ.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'laichau', 0, 'nui'),
(35, 'Lâm Đồng', 'Lâm Đồng có thành phố Đà Lạt với khí hậu mát mẻ quanh năm.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'lamdong', 0, 'nui'),
(37, 'Lào Cai', 'Lào Cai có Sapa, điểm đến nổi tiếng với cảnh quan núi rừng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'laocai', 0, 'nui'),
(42, 'Ninh Thuận', 'Nổi tiếng với tháp Chăm và các cánh đồng muối, nho đặc trưng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'ninhthuan', 0, 'nui'),
(32, 'Kiên Giang', 'Kiên Giang có đảo Phú Quốc và cảnh quan biển đảo đẹp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'kiengiang', 0, 'bien'),
(47, 'Quảng Ngãi', 'Quảng Ngãi nổi tiếng với đảo Lý Sơn và văn hóa Champa.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'quangngai', 0, 'bien'),
(31, 'Khánh Hòa', 'Khánh Hòa có vịnh Nha Trang và nhiều bãi biển đẹp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'khanhhoa', 4.5, 'bien');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(45, 'Quảng Bình', 'Quảng Bình có động Phong Nha - Kẻ Bàng và nhiều hang động lớn.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'quangbinh', 0, 'nui'),
(49, 'Quảng Trị', 'Quảng Trị gắn liền với nhiều di tích lịch sử chiến tranh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'quangtri', 0, 'nui'),
(15, 'Đà Nẵng', 'Đà Nẵng là thành phố hiện đại, có nhiều bãi biển và cầu Rồng nổi tiếng.', 'database/locations/danang.jpg', 0.00, 0.00, '2024-10-30 08:00:12', 'danang', 6.37, 'bien'),
(55, 'Thanh Hóa', 'Thanh Hóa có bãi biển Sầm Sơn và nhiều di tích lịch sử.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'thanhhoa', 0, 'bien'),
(2, 'Bà Rịa - Vũng Tàu', 'Nơi có bãi biển Vũng Tàu nổi tiếng, thu hút nhiều khách du lịch.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'bariavungtau', 0, 'bien'),
(11, 'Bình Thuận', 'Nơi có Mũi Né với bãi biển đẹp và các đồi cát nổi tiếng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'binhthuan', 0, 'bien'),
(12, 'Cà Mau', 'Cà Mau là cực Nam của Việt Nam, nổi tiếng với rừng ngập mặn.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'camau', 0, 'bien');
INSERT INTO locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) 
VALUES 
(26, 'Hải Dương', 'Hải Dương nổi tiếng với bánh đậu xanh và các làng nghề truyền thống.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'haiduong', 0, 'bien'),
(44, 'Phú Yên', 'Phú Yên có Gành Đá Đĩa và nhiều bãi biển hoang sơ.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'phuyen', 0, 'bien'),
(46, 'Quảng Nam', 'Quảng Nam có phố cổ Hội An và thánh địa Mỹ Sơn.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'quangnam', 0, 'bien'),
(8, 'Bình Định', 'Bình Định nổi tiếng với võ cổ truyền và nhiều di tích lịch sử.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'binhdinh', 0, 'bien'),
(56, 'Thừa Thiên Huế', 'Huế là cố đô với nhiều di sản văn hóa và lăng tẩm triều Nguyễn.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'thuathienhue', 0, 'bien'),
(40, 'Nghệ An', 'Nghệ An là quê hương của Chủ tịch Hồ Chí Minh, có biển Cửa Lò.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'nghean', 0, 'bien'),
(58, 'TP. Hồ Chí Minh', 'Trung tâm kinh tế lớn nhất Việt Nam với nhiều hoạt động sôi động.', NULL, 0.00, 0.00, '2024-10-30 08:00:12', 'hochiminh', 0, 'bien');
INSERT INTO users (id, username, password, email, fullname, address, isadmin, avatar, point, status)
VALUES
(13, 'vu123456', '$2y$10$gcBmSwCNNKdYmNe1H5lEQui.LtiPux0wrImVY9TBHmUqzZTuzY6Bu', 'hoangvuvo999@gmail.com', 'Võ Vũ', '440 Thống Nhất', true, NULL, 0, 'exemplary'),
(1, 'vu951236', '$2y$10$wDuIK3liBjIFG7QeIaU93eyhNeyaDI20K2HkmngOoeCPuBaQHFBvC', 'hoangvuvo907@gmail.com', 'Võ Hoàng Vũ', '440 Thống Nhất', true, 'database/users/avatar_672671333a3676.09973899.png', 34.95875, 'exemplary'),
(3, 'thinh12345', '$2y$10$fsau3/2PpC4Ir5WF.04Yzea6vcav/3eIgtKbc3KxQdJQ13S1XJPQy', 'nguyenminhthinh26122004@gmail.com', 'Nguyễn Minh Thịnh', 'Quy Nhơn', false, NULL, 0, 'exemplary'),
(2, 'vuad951236', '$2y$10$m1Dxc0rQbJdakzKB2BArUegWilFq7yFdcArYROXL/vDeHhkp4DxOq', 'hoangvuvo877@gmail.com', 'Võ Hoàng Vũ', '440 Thống Nhất', true, NULL, 0, 'exemplary'),
(5, 'linh951236', '$2y$10$Nb63IuCqOuZpkqlooV9KreIMHZ1sHCsOuIwuzScD071KuVQE/8.86', 'truclinh300678@gmail.com', 'Trúc Linh', '440 Thống Nhất', false, NULL, 0, 'exemplary'),
(6, 'nhuan12345', '$2y$10$jYeRWMuLLX3ouJPkWH9OAue.1p.a6sO1YXuVkmAeXangL8Jgbp9cu', 'huynhhongnhuan@gmail.com', 'Huỳnh Hồng Nhuận', 'Tuy Phước', false, NULL, 0, 'exemplary'),
(4, 'vu951237', '$2y$10$eJAvVytP8xr1Adu8sgQQOe.lrXpFmRrxDc9VhxjyoUWmWsXLlSR6O', '2251120133@ut.edu.vn', 'Võ Hoàng Vũ', '440 Thống Nhất', false, NULL, 0, 'exemplary');
INSERT INTO forumcomment (id, post_id, user_id, content, created_at)
VALUES
(115, 12, 1, 'thật hoành tráng', '2024-11-07 19:50:07.128232'),
(116, 2, 1, 'dâu khá tươi nha mọi người', '2024-11-07 19:50:22.731197'),
(117, 12, 1, 'abc', '2024-11-09 13:52:55.978055');
INSERT INTO post_likes (id, post_id, user_id)
VALUES
(120, 2, 1),
(122, 12, 1);
INSERT INTO postcomment (id, username, content, date, idpost, userid)
VALUES
(2, 'vu951236', 'tôi muốn đi thử', '2024-11-01 11:20:39', 16, 1),
(3, 'nhuan12345', 'đẹp quá', '2024-11-01 11:21:23', 13, 6),
(4, 'vu951236', 'các bạn có thể trải nghiệm', '2024-11-02 19:21:15', 39, 1),
(5, 'nhuan12345', 'Nhìn như trong tranh', '2024-11-02 19:54:19', 40, 6);
INSERT INTO postdetail (id, name, date, image, content, rate, amongrate, location, view, userid, description, status, typepost)
VALUES
(70, 'Bún bò Huế', '2024-11-06 17:30:00', 'database/posts/bun_bo_hue.jpg', 'Bún bò Huế là món ăn đặc sản nổi tiếng của Huế, với nước dùng đậm đà, thịt bò mềm và các gia vị đặc trưng. Đây là món ăn không thể thiếu khi đến Huế.', 0.00, 0, 'thuathienhue', 0, 2, 'Bún bò Huế - Đặc sản Huế với hương vị đậm đà.', 'notapproved', 'anuong'),
(71, 'Mực nhồi thịt Phan Rang', '2024-11-06 18:00:00', 'database/posts/muc_nhoi_thit_phanrang.jpg', 'Mực nhồi thịt Phan Rang là món ăn đặc sản của Phan Rang, được chế biến từ mực tươi nhồi với thịt và gia vị, tạo nên hương vị thơm ngon, đậm đà. Đây là món ăn phổ biến trong các bữa tiệc.', 0.00, 0, 'ninhthuan', 0, 3, 'Mực nhồi thịt Phan Rang - Món ăn đặc sản hấp dẫn.', 'notapproved', 'anuong'),
(72, 'Bánh xèo Đà Nẵng', '2024-11-06 18:30:00', 'database/posts/banh_xeo_danang.jpg', 'Bánh xèo Đà Nẵng là món ăn truyền thống, với lớp vỏ giòn tan và nhân tôm, thịt, giá đỗ, ăn kèm với rau sống và nước mắm chua ngọt. Đây là món ăn không thể thiếu khi đến Đà Nẵng.', 0.00, 0, 'danang', 0, 4, 'Bánh xèo Đà Nẵng - Món ăn dân dã nhưng hấp dẫn.', 'notapproved', 'anuong'),
(1, 'Kinh nghiệm du lịch Đà Nẵng', '2024-10-15 00:00:00', 'database/posts/danang.jpg', 'Đà Nẵng, thành phố biển xinh đẹp miền Trung, từ lâu đã trở thành điểm đến lý tưởng cho những ai yêu thích vẻ đẹp thiên nhiên hòa quyện cùng nét văn hóa đặc sắc. Nổi tiếng với những bãi biển xanh ngắt, những cây cầu độc đáo và vô vàn món ăn ngon, Đà Nẵng mang đến cho du khách trải nghiệm đa dạng và khó quên.\nKhi đến Đà Nẵng, bãi biển Mỹ Khê là điểm dừng chân đầu tiên không thể bỏ qua. Đây là một trong những bãi biển đẹp nhất Việt Nam, nổi tiếng với bãi cát trắng mịn và làn nước trong xanh. Thả mình dưới ánh nắng dịu nhẹ, cảm nhận làn gió biển mát lạnh và nghe tiếng sóng vỗ bờ, du khách sẽ cảm nhận được sự thư thái và bình yên.\nĐà Nẵng còn được biết đến với hệ thống những cây cầu độc đáo, mà nổi bật nhất là Cầu Rồng. Cây cầu này không chỉ là điểm kết nối giữa các khu vực trong thành phố mà còn là biểu tượng hiện đại của Đà Nẵng. Vào cuối tuần, du khách sẽ được chiêm ngưỡng màn trình diễn rồng phun lửa và nước đặc sắc, tạo nên khung cảnh lung linh và sống động.\nNếu yêu thích không gian thiên nhiên hùng vĩ, Bà Nà Hills chắc chắn là điểm đến tiếp theo mà bạn nên ghé qua. Nằm ở độ cao hơn 1.400 mét, Bà Nà Hills là khu nghỉ dưỡng kết hợp giải trí với cảnh quan núi non trùng điệp, khí hậu mát mẻ quanh năm và những công trình kiến trúc Pháp cổ kính. Cầu Vàng với hai bàn tay khổng lồ nâng đỡ là điểm nhấn nổi tiếng, mang đến một góc nhìn tuyệt đẹp và huyền ảo giữa mây trời.\nẨm thực Đà Nẵng là một trong những yếu tố góp phần tạo nên sức hút của thành phố này. Bạn có thể thử các món đặc sản như bánh tráng cuốn thịt heo, mì Quảng, bún chả cá và hải sản tươi ngon. Hương vị đậm đà và đa dạng của những món ăn này sẽ khiến bất kỳ ai cũng phải xiêu lòng và muốn quay lại để thưởng thức thêm.\nVới cảnh sắc thiên nhiên tươi đẹp, những công trình hiện đại và nền ẩm thực phong phú, Đà Nẵng thực sự là điểm đến hoàn hảo cho những ai muốn tìm kiếm sự thư giãn và trải nghiệm văn hóa độc đáo của miền Trung. Đây là nơi bạn có thể hòa mình vào thiên nhiên, chiêm ngưỡng sự phát triển hiện đại của một thành phố trẻ, và tận hưởng những khoảnh khắc đáng nhớ cùng gia đình và bạn bè.', 4.37, 46, 'danang', 23, 1, 'Đà Nẵng, thành phố biển xinh đẹp miền Trung, nổi bật với bãi biển Mỹ Khê, cầu Rồng độc đáo, Bà Nà Hills hùng vĩ và nền ẩm thực phong phú.', 'approve', 'dulichmuasam'),
(6, 'Biển Nha Trang - Điểm đến lý tưởng', '2024-10-15 15:20:00', 'database/posts/nhatrang.jpg', 'Bãi biển Nha Trang nổi tiếng với cát trắng và nước biển trong xanh, điểm đến lý tưởng cho những ai yêu thích biển.', 4.90, 4, 'khanhhoa', 66, 4, 'Biển xanh Nha Trang và những trải nghiệm tuyệt vời.', 'approve', 'nghiduong'),
(12, 'Chinh phục núi Bạch Mã - Huế', '2024-10-18 06:30:00', 'database/posts/bachma.jpg', 'Núi Bạch Mã mang lại trải nghiệm leo núi thú vị với cảnh quan thiên nhiên tuyệt đẹp tại Huế.', 4.40, 3, 'thuathienhue', 46, 4, 'Núi Bạch Mã với thiên nhiên xanh mát và những trải nghiệm leo núi khó quên.', 'canceled', 'dulichmuasam'),
(5, 'Hành trình Hà Nội - Trái tim Việt Nam', '2024-10-10 14:15:00', 'database/posts/hanoi.jpeg', 'Hà Nội mang đậm nét văn hóa và lịch sử với Hồ Gươm, phố cổ và ẩm thực đường phố độc đáo.', 4.70, 2, 'hanoi', 70, 3, 'Hà Nội cổ kính và hiện đại với nhiều nét văn hóa đặc sắc.', 'approve', 'dulichmuasam');
INSERT INTO postdetail (id, name, date, image, content, rate, amongrate, location, view, userid, description, status, typepost)
VALUES
(39, "Khám phá Nha Trang", "2024-11-03 01:18:30", "database/posts/post_6726716a2964a9.34963547.jpg", 
"Nha Trang, thành phố biển nổi tiếng nằm ở miền Trung Việt Nam, là điểm đến lý tưởng cho những ai yêu thích vẻ đẹp của biển cả và ẩm thực phong phú. Với bãi biển Trần Phú trải dài và nước biển trong xanh, Nha Trang không chỉ thu hút du khách bởi cảnh quan thiên nhiên hùng vĩ mà còn bởi những trải nghiệm tuyệt vời mà nơi đây mang lại.\n\nBãi biển Trần Phú, một trong những bãi biển đẹp nhất Việt Nam, nổi bật với cát trắng mịn màng và làn nước trong vắt màu ngọc bích. Khi bước chân xuống bãi cát, du khách sẽ cảm nhận được sự dịu mát của gió biển và âm thanh của sóng vỗ rì rào. Nơi đây là thiên đường cho những hoạt động vui chơi, giải trí như tắm biển, lặn biển, hay tham gia các trò chơi thể thao dưới nước. Bạn có thể thuê một chiếc thuyền kayak để khám phá những hòn đảo xung quanh, hoặc chỉ đơn giản là nằm tắm nắng và thư giãn trong không gian yên bình.\n\nNgoài vẻ đẹp của biển, Nha Trang còn nổi tiếng với ẩm thực hải sản tươi ngon. Với lợi thế là một thành phố ven biển, Nha Trang mang đến cho du khách những món ăn đặc sắc được chế biến từ hải sản tươi sống. Bạn có thể thưởng thức những đĩa sò điệp nướng mỡ hành, ghẹ hấp, hay cá nướng thơm lừng. Đặc biệt, món bún chả cá Nha Trang với hương vị đậm đà và tươi ngon sẽ khiến bạn phải lòng ngay từ lần thử đầu tiên. Các quán hải sản ven biển luôn đông khách, nơi bạn có thể thưởng thức những bữa ăn ngon miệng và ngắm nhìn cảnh biển thơ mộng.\n\nNha Trang không chỉ có biển và hải sản mà còn là nơi có nhiều điểm tham quan hấp dẫn. Du khách có thể ghé thăm Tháp Bà Ponagar, một di tích lịch sử văn hóa của người Chăm, hay tham gia các hoạt động tại Vinpearl Land - khu vui chơi giải trí hàng đầu Việt Nam. Bên cạnh đó, những suối nước nóng và các khu nghỉ dưỡng cao cấp cũng là lựa chọn thú vị để bạn thư giãn và tái tạo năng lượng.\n\nNhìn chung, Nha Trang là một điểm đến lý tưởng cho những ai muốn trốn chạy khỏi nhịp sống hối hả, tìm kiếm sự thư giãn và tận hưởng những khoảnh khắc tuyệt vời bên biển. Với những bãi biển đẹp, ẩm thực phong phú và nhiều hoạt động thú vị, Nha Trang chắc chắn sẽ để lại trong lòng du khách những kỷ niệm khó quên.", 4.00, 1, "khanhhoa", 1, 1, "Nha Trang, thành phố biển với bãi biển Trần Phú đẹp tuyệt vời và hải sản tươi ngon.", "canceled", "dulichmuasam"),
(4, "Cảnh đẹp thiên nhiên Phú Yên", "2024-10-14 08:45:00", "database/posts/phuyen.jpg", 
"Phú Yên là nơi dành cho người thích khám phá thiên nhiên hoang sơ với các ghềnh đá và bãi biển tuyệt đẹp.", 4.60, 1, "phuyen", 41, 6, "Phú Yên đẹp với biển xanh và thiên nhiên hoang sơ.", "approve", "dulichmuasam"),
(67, "Bánh mì Hội An - Món ăn đặc sản phố cổ", "2024-11-06 16:00:00", "database/posts/banh_mi_hoi_an.jpg", 
"Bánh mì Hội An là món ăn nổi tiếng tại Hội An, với bánh mì giòn, nhân thịt nướng thơm lừng, và các nguyên liệu tươi ngon. Đây là một món ăn không thể bỏ qua khi du lịch Hội An.", 0.00, 0, "quangnam", 0, 6, "Bánh mì Hội An - Đặc sản phố cổ hấp dẫn.", "notapproved", "anuong"),
(14, "Ghé thăm rừng tràm Trà Sư - An Giang", "2024-10-08 09:15:00", "database/posts/trasu.jpg", 
"Rừng tràm Trà Sư là địa điểm lý tưởng cho những ai yêu thích khám phá thiên nhiên miền Tây.", 4.30, 1, "angiang", 55, 6, "Rừng tràm Trà Sư với hệ sinh thái đa dạng và không gian xanh mát.", "approve", "dulichmuasam"),
(68, "Bánh canh cua Phan Thiết", "2024-11-06 16:30:00", "database/posts/banh_canh_cua_phanthiet.jpg", 
"Bánh canh cua Phan Thiết là món ăn nổi tiếng với nước dùng đậm đà từ cua tươi, cùng bánh canh mềm và gia vị đặc trưng của vùng biển Phan Thiết.", 0.00, 0, "binhthuan", 0, 6, "Bánh canh cua Phan Thiết - Món ăn đậm đà hương vị biển.", "notapproved", "anuong"),
(11, "Ngắm hoàng hôn Vũng Tàu", "2024-10-17 17:45:00", "database/posts/vungtau.jpg", 
"Vũng Tàu có những bãi biển đẹp và phong cảnh lãng mạn, là điểm đến lý tưởng cho những ai yêu thích thiên nhiên.", 4.60, 1, "bariavungtau", 80, 3, "Vũng Tàu với biển xanh, phong cảnh lãng mạn và hoàng hôn đẹp.", "canceled", "nghiduong"),
(19, "Thuyền độc mộc trên sông Hương", "2024-10-17 16:30:00", "database/posts/docmoc.jpg", 
"Sông Hương, một biểu tượng văn hóa và lịch sử của thành phố Huế, không chỉ nổi tiếng với vẻ đẹp nên thơ mà còn là nơi lưu giữ những ký ức đẹp đẽ về cuộc sống của người dân miền Trung. Một trong những trải nghiệm độc đáo và yên bình mà du khách không thể bỏ lỡ khi đến với sông Hương chính là đi thuyền độc mộc.\n\nNgồi trên thuyền độc mộc, tôi cảm nhận được sự nhẹ nhàng và thanh bình. Thuyền lướt nhẹ trên mặt nước phẳng lặng, đôi khi có những cơn gió nhẹ thoảng qua, mang theo hương thơm của hoa nhài và các loại cây cỏ ven bờ. Ánh nắng mặt trời chiếu rọi xuống mặt nước, tạo nên những đợt sóng lấp lánh như những viên ngọc quý. Trong không gian tĩnh lặng, chỉ còn lại tiếng nước chảy và tiếng chim hót líu lo, tôi như được hòa mình vào thiên nhiên, quên đi những ồn ào của cuộc sống thường nhật.\n\nKhi thuyền trôi dọc theo dòng sông, tôi có cơ hội ngắm nhìn cảnh vật hai bên bờ. Những ngôi nhà mái ngói cổ kính, những cánh đồng xanh mướt và những rặng cây cao lớn tạo nên bức tranh thiên nhiên tuyệt đẹp. Dọc theo dòng sông, người dân tản bộ, thả câu hay gặt hái mùa màng, họ tỏ ra hiền hòa và thân thiện, tạo nên một bầu không khí gần gũi và ấm áp. Qua những câu chuyện giản dị, tôi dần hiểu thêm về cuộc sống của người dân nơi đây, về những khó khăn cũng như niềm vui trong cuộc sống hàng ngày.\n\nĐi thuyền độc mộc trên sông Hương không chỉ mang đến cho tôi cảm giác thư thái mà còn giúp tôi mở mang thêm tầm hiểu biết về văn hóa và con người nơi đây. Mỗi lần thuyền cập bến, tôi đều cảm thấy như mình đã thêm một phần ký ức đẹp đẽ vào hành trang cuộc sống của mình. Những khoảnh khắc yên bình trên sông Hương sẽ mãi mãi là một phần không thể quên trong hành trình khám phá vẻ đẹp của quê hương Việt Nam.\n\nTrải nghiệm này không chỉ đơn thuần là một chuyến đi, mà còn là dịp để tôi tìm về với chính mình, cảm nhận cuộc sống qua từng con sóng, từng cơn gió. Thuyền độc mộc trên sông Hương, một hình ảnh giản dị nhưng lại mang trong mình một giá trị văn hóa sâu sắc, đã để lại trong tôi những ấn tượng khó phai.", 0.00, 0, "hue", 0, 6, "Thuyền độc mộc trên sông Hương - Chuyến đi nhẹ nhàng và thư giãn.", "notapproved", "nghiduong");
INSERT INTO postdetail (id, name, date, image, content, rate, amongrate, location, view, userid, description, status, typepost)
VALUES
(69, "Cơm gà Tam Kỳ", "2024-11-06 17:00:00", "database/posts/com_ga_tamky.jpg", 
"Cơm gà Tam Kỳ là món ăn truyền thống của Tam Kỳ, Quảng Nam. Cơm gà thơm ngon, ăn kèm với rau sống và nước mắm, tạo nên một hương vị rất đặc biệt.", 0.00, 0, "quangnam", 0, 5, "Cơm gà Tam Kỳ - Món ăn truyền thống đầy hương vị.", "notapproved", "anuong"),
(8, "Thưởng thức ẩm thực Sài Gòn", "2024-10-11 18:30:00", "database/posts/saigon.jpg", 
"Sài Gòn là thiên đường ẩm thực với nhiều món ngon đường phố và sự pha trộn văn hóa đa dạng.", 4.80, 2, "hochiminh", 75, 6, "Ẩm thực Sài Gòn và trải nghiệm văn hóa đường phố.", "approve", "anuong"),
(10, "Lạc vào thiên nhiên Cần Thơ", "2024-10-13 11:25:00", "database/posts/cantho.jpg", 
"Cần Thơ nổi tiếng với chợ nổi, nét văn hóa sông nước và cuộc sống bình dị của người dân miền Tây.", 4.50, 2, "cantho", 50, 1, "Chợ nổi Cần Thơ và nét văn hóa miền Tây độc đáo.", "approve", "dulichmuasam"),
(9, "Kỳ nghỉ ở đảo Phú Quốc", "2024-10-09 16:10:00", "database/posts/phuquoc.jpg", 
"Phú Quốc nổi tiếng với biển xanh, resort sang trọng và không khí trong lành.", 4.90, 4, "kiengiang", 91, 2, "Phú Quốc với biển đẹp và các resort cao cấp.", "notapproved", "nghiduong"),
(7, "Đà Nẵng năng động", "2024-10-16 12:00:00", "database/posts/danang2.jpg", 
"Đà Nẵng nổi bật với biển Mỹ Khê, cầu Rồng và sự phát triển năng động của một thành phố trẻ.", 4.70, 1, "danang", 61, 5, "Đà Nẵng năng động với cầu Rồng, biển Mỹ Khê, và nền văn hóa đa dạng.", "approve", "nghiduong"),
(40, "Khám phá Hà Giang", "2024-11-03 01:48:17.418235", "database/posts/post_672673f165e765.05129740.jpg", 
"Hà Giang, miền đất nằm ở cực Bắc của Tổ quốc, nổi tiếng với cảnh đẹp thiên nhiên hùng vĩ và những cánh đồng hoa tam giác mạch bạt ngàn, tạo nên một bức tranh thơ mộng và quyến rũ. Nơi đây không chỉ thu hút du khách bởi vẻ đẹp tự nhiên mà còn bởi nền văn hóa phong phú và đời sống đặc sắc của các dân tộc thiểu số.\n\nHà Giang được biết đến với những dãy núi trùng điệp, những con đường uốn lượn quanh co và những thung lũng xanh tươi. Một trong những điểm đến nổi bật là cao nguyên đá Đồng Văn, nơi có những khối đá vôi đồ sộ và những ngọn đồi dốc đứng. Hành trình khám phá vùng đất này mang lại cho du khách những trải nghiệm tuyệt vời khi được chiêm ngưỡng những cảnh quan kỳ vĩ của thiên nhiên. Những khung cảnh hùng vĩ của núi rừng Hà Giang như một bức tranh sống động, khiến lòng người không khỏi trầm trồ ngưỡng mộ.\n\nĐặc biệt, mỗi khi mùa hoa tam giác mạch nở rộ, Hà Giang như được khoác lên mình một chiếc áo mới đầy màu sắc. Những cánh đồng hoa tam giác mạch trắng, hồng, tím trải dài trên những sườn đồi, tạo nên cảnh tượng mê hoặc lòng người. Đây là thời điểm lý tưởng để du khách đến tham quan, chụp ảnh và cảm nhận vẻ đẹp lãng mạn của thiên nhiên. Hoa tam giác mạch không chỉ là biểu tượng của vùng đất Hà Giang mà còn là niềm tự hào của người dân nơi đây, thể hiện sự kiên cường và sức sống mãnh liệt của con người trong điều kiện khí hậu khắc nghiệt.\n\nKhông chỉ có hoa tam giác mạch, Hà Giang còn nổi bật với nền văn hóa đa dạng của các dân tộc như Mông, Tày, Dao... Những phong tục tập quán, trang phục truyền thống và các lễ hội văn hóa phong phú đều góp phần làm cho du khách có cái nhìn sâu sắc hơn về đời sống của người dân nơi đây. Đặc biệt, lễ hội hoa tam giác mạch diễn ra vào tháng 11 hàng năm là dịp để người dân cùng nhau tổ chức các hoạt động văn hóa, nghệ thuật, tạo nên không khí rộn ràng và ấm áp.\n\nHà Giang không chỉ đơn thuần là một điểm đến du lịch mà còn là nơi để khám phá, trải nghiệm và tìm hiểu về thiên nhiên và con người. Với cảnh đẹp hùng vĩ, cánh đồng hoa tam giác mạch lôi cuốn và nền văn hóa phong phú, Hà Giang chắc chắn sẽ để lại trong lòng du khách những kỷ niệm đẹp và những cảm xúc khó quên.", 4.50, 2, "hagiang", 8, 1, "Hà Giang, vùng đất với cảnh đẹp thiên nhiên hùng vĩ và những cánh đồng hoa tam giác mạch.", "approve", "dulichmuasam"),
(18, "Tìm hiểu văn hóa người Chăm", "2024-10-14 15:15:00", "database/posts/cham.jpg", 
"Khám phá văn hóa độc đáo của người Chăm tại Ninh Thuận và Bình Thuận, với các lễ hội và phong tục tập quán đặc sắc.", 4.60, 2, "ninhthuan", 54, 5, "Văn hóa Chăm với các lễ hội đặc sắc và phong tục tập quán độc đáo.", "approve", "dulichmuasam");
INSERT INTO postdetail (name, date, image, content, rate, amongrate, location, view, userid, description, status, typepost)
VALUES
('Khám phá biển Quy Nhơn', '2024-10-11 14:40:00', 'database/posts/quynhon.jpg', 'Quy Nhơn có những bãi biển hoang sơ và thiên nhiên tuyệt đẹp, là nơi lý tưởng cho người thích khám phá.', 4.50, 1, 'binhdinh', 48, 3, 'Quy Nhơn với biển xanh trong và bãi cát trắng mịn.', 'notapproved', 'dulichmuasam'),
('Mộc Châu - Miền đất hoa cải trắng', '2024-10-10 07:30:00', 'database/posts/mocchau.webp', 'Mộc Châu mang đến vẻ đẹp của các mùa hoa, đặc biệt là hoa cải trắng nở rộ vào mùa đông.', 4.70, 1, 'sonla', 60, 1, 'Mộc Châu với những mùa hoa tuyệt đẹp, đặc biệt là hoa cải trắng.', 'approve', 'dulichmuasam'),
('Thưởng ngoạn cảnh đẹp Sapa', '2024-10-19 07:00:00', 'database/posts/sapa.jpg', 'Sapa, vùng đất nằm trên độ cao 1.600 mét so với mực nước biển, nổi tiếng với cảnh sắc hùng vĩ của núi đồi và những thửa ruộng bậc thang tuyệt đẹp, là điểm đến lý tưởng cho những ai yêu thích thiên nhiên và muốn khám phá vẻ đẹp hoang sơ của núi rừng phía Bắc Việt Nam.', 4.90, 1, 'laocai', 86, 5, 'Sapa và những ruộng bậc thang đẹp mê hồn giữa núi đồi.', 'notapproved', 'dulichmuasam'),
('Chợ đêm Đồng Xuân - Hà Nội', '2024-10-20 19:00:00', 'database/posts/dongxuan.jpg', 'Chợ đêm Đồng Xuân, một trong những điểm đến không thể bỏ qua khi đến Hà Nội, là nơi lý tưởng để du khách vừa mua sắm vừa khám phá văn hóa đặc sắc của thủ đô vào ban đêm.', 4.20, 2, 'hanoi', 52, 2, 'Chợ đêm Đồng Xuân với không khí sôi động và sản phẩm đa dạng.', 'approve', 'anuong'),
('Khám phá Huế cổ kính', '2024-10-18 09:00:00', 'database/posts/hue.webp', 'Huế, thành phố nằm bên dòng sông Hương thơ mộng, nổi tiếng với di sản cung đình và vẻ đẹp lãng mạn, là điểm đến không thể bỏ qua đối với những ai yêu thích lịch sử và văn hóa.', 4.50, 3, 'thuathienhue', 30, 2, 'Di sản Huế cổ kính, cảnh đẹp yên bình và di sản văn hóa.', 'approve', 'dulichmuasam'),
('Kinh nghiệm du lịch Hội An', '2024-11-03 01:12:54.849289', 'database/posts/post_67266ba6cf16d3.08818013.jpg', 'Hội An, thành phố cổ kính bên bờ sông Thu Bồn, là một trong những điểm đến hấp dẫn nhất của Việt Nam.', 0.00, 0, 'quangnam', 1, 1, 'Hội An, thành phố cổ với nét đẹp truyền thống, ẩm thực phong phú và phố cổ lung linh đèn lồng.', 'approve', 'dulichmuasam'),
('Trải nghiệm văn hóa Hội An', '2024-10-12 10:30:00', 'database/posts/hoian.jpg', 'Hội An, một thành phố nhỏ xinh đẹp nằm bên dòng sông Thu Bồn, được UNESCO công nhận là di sản thế giới, nổi tiếng với vẻ đẹp cổ kính của phố cổ, những chiếc đèn lồng lung linh và nền ẩm thực độc đáo.', 4.80, 1, 'quangnam', 57, 1, 'Phố cổ Hội An, đèn lồng rực rỡ, và nền văn hóa độc đáo.', 'approve', 'dulichmuasam');
INSERT INTO forumdetail (date, image, content, likes_count, userid, status)
VALUES
('2024-11-07 09:08:58.07424', 'database/forum/img_672c213a11e5e1.66430385.jpg', 'Hái dâu tại đà lạt <3', 17, 1, 'approve'),
('2024-11-07 17:09:14.158414', 'database/forum/img_672c91ca2672e7.31584331.webp', 'Tượng Phật núi Bà Đen', 1, 4, 'approve');

