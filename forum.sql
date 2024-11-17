-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 17, 2024 lúc 06:42 PM
-- Phiên bản máy phục vụ: 9.1.0
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `forum`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admincode`
--

CREATE TABLE `admincode` (
  `id` int NOT NULL,
  `code` varchar(255) NOT NULL,
  `expiration_time` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `forumcomment`
--

CREATE TABLE `forumcomment` (
  `id` int NOT NULL,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `forumdetail`
--

CREATE TABLE `forumdetail` (
  `id` int NOT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` text,
  `likes_count` int DEFAULT '0',
  `userid` int DEFAULT NULL,
  `status` varchar(50) DEFAULT 'notapproved'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `locationcomment`
--

CREATE TABLE `locationcomment` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `content` text,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idlocation` int NOT NULL,
  `userid` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `locationdetail`
--

CREATE TABLE `locationdetail` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `information` text,
  `image` varchar(255) DEFAULT NULL,
  `rate` decimal(3,2) DEFAULT '0.00',
  `amongrate` int DEFAULT '0',
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(255) DEFAULT NULL,
  `point` decimal(10,2) DEFAULT '0.00',
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `locationdetail`
--

INSERT INTO `locationdetail` (`id`, `name`, `information`, `image`, `rate`, `amongrate`, `date`, `location`, `point`, `type`) VALUES
(1, 'An Giang', 'Tỉnh An Giang nổi tiếng với chợ nổi Long Xuyên và vùng Bảy Núi linh thiêng.', 'database/locations/AnGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'angiang', 0.00, 'dongbang'),
(2, 'Bà Rịa - Vũng Tàu', 'Nơi có bãi biển Vũng Tàu nổi tiếng, thu hút nhiều khách du lịch.', 'database/locations/BaRia-VungTau.jpg', 0.00, 0, '2024-10-30 01:00:12', 'bariavungtau', 0.00, 'bien'),
(3, 'Bắc Giang', 'Bắc Giang có nhiều cảnh quan tự nhiên và là nơi sản xuất vải thiều nổi tiếng.', 'database/locations/BacGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'bacgiang', 0.00, 'nui'),
(4, 'Bắc Kạn', 'Bắc Kạn có hồ Ba Bể và nhiều cảnh quan thiên nhiên tuyệt đẹp.', 'database/locations/BacKan.jpg', 0.00, 0, '2024-10-30 01:00:12', 'backan', 0.00, 'nui'),
(5, 'Bạc Liêu', 'Nổi tiếng với điện gió và gắn liền với giai thoại Công tử Bạc Liêu.', 'database/locations/BacLieu.jpg', 0.00, 0, '2024-10-30 01:00:12', 'baclieu', 0.00, 'dongbang'),
(6, 'Bắc Ninh', 'Bắc Ninh là cái nôi của dân ca quan họ truyền thống Việt Nam.', 'database/locations/BacNinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'bacninh', 0.00, 'dongbang'),
(7, 'Bến Tre', 'Được mệnh danh là \"xứ dừa\" với nhiều đặc sản và làng nghề truyền thống.', 'database/locations/BenTre.jpg', 0.00, 0, '2024-10-30 01:00:12', 'bentre', 0.00, 'dongbang'),
(8, 'Bình Định', 'Bình Định nổi tiếng với võ cổ truyền và nhiều di tích lịch sử.', 'database/locations/BinhDinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'binhdinh', 0.00, 'bien'),
(9, 'Bình Dương', 'Bình Dương là trung tâm công nghiệp lớn của miền Nam Việt Nam.', 'database/locations/BinhDuong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'binhduong', 0.00, 'dongbang'),
(10, 'Bình Phước', 'Bình Phước nổi tiếng với rừng cao su và điều, kinh tế chủ yếu từ nông nghiệp.', 'database/locations/BinhPhuoc.jpg', 0.00, 0, '2024-10-30 01:00:12', 'binhphuoc', 0.00, 'dongbang'),
(11, 'Bình Thuận', 'Nơi có Mũi Né với bãi biển đẹp và các đồi cát nổi tiếng.', 'database/locations/BinhThuan.jpg', 0.00, 0, '2024-10-30 01:00:12', 'binhthuan', 0.00, 'bien'),
(12, 'Cà Mau', 'Cà Mau là cực Nam của Việt Nam, nổi tiếng với rừng ngập mặn.', 'database/locations/CaMau.jpg', 0.00, 0, '2024-10-30 01:00:12', 'camau', 0.00, 'bien'),
(13, 'Cần Thơ', 'Cần Thơ là trung tâm kinh tế, văn hóa của Đồng bằng sông Cửu Long.', 'database/locations/CanTho.jpg', 0.00, 0, '2024-10-30 01:00:12', 'cantho', 0.00, 'dongbang'),
(14, 'Cao Bằng', 'Cao Bằng có thác Bản Giốc và nhiều danh lam thắng cảnh.', 'database/locations/CaoBang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'caobang', 0.00, 'nui'),
(15, 'Đà Nẵng', 'Đà Nẵng là thành phố hiện đại, có nhiều bãi biển và cầu Rồng nổi tiếng.', 'database/locations/DaNang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'danang', 0.00, 'bien'),
(16, 'Đắk Lắk', 'Đắk Lắk là trung tâm cà phê lớn và văn hóa Tây Nguyên.', 'database/locations/DakLak.jpg', 0.00, 0, '2024-10-30 01:00:12', 'daklak', 0.00, 'nui'),
(17, 'Đắk Nông', 'Nổi tiếng với các thác nước và cảnh quan thiên nhiên hùng vĩ.', 'database/locations/DakNong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'daknong', 0.00, 'nui'),
(18, 'Điện Biên', 'Điện Biên gắn liền với chiến thắng Điện Biên Phủ lịch sử.', 'database/locations/DienBien.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dienbien', 0.00, 'nui'),
(19, 'Đồng Nai', 'Đồng Nai có nền công nghiệp phát triển và khu bảo tồn thiên nhiên Nam Cát Tiên.', 'database/locations/ DongNai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dongnai', 0.00, 'dongbang'),
(20, 'Đồng Tháp', 'Nơi có vườn quốc gia Tràm Chim và nhiều cánh đồng sen.', 'database/locations/ DongThap.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dongthap', 0.00, 'dongbang'),
(21, 'Gia Lai', 'Gia Lai nổi tiếng với Biển Hồ và văn hóa cồng chiêng Tây Nguyên.', 'database/locations/GiaLai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'gialai', 0.00, 'nui'),
(22, 'Hà Giang', 'Hà Giang có cao nguyên đá Đồng Văn và nhiều cung đường đèo đẹp.', 'database/locations/HaGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hagiang', 0.00, 'nui'),
(23, 'Hà Nam', 'Hà Nam nổi tiếng với làng nghề và chùa Tam Chúc lớn nhất Việt Nam.', 'database/locations/HaNam.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hanam', 0.00, 'dongbang'),
(24, 'Hà Nội', 'Thủ đô của Việt Nam với nhiều di tích lịch sử và văn hóa.', 'database/locations/HaNoi.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hanoi', 0.00, 'dongbang'),
(25, 'Hà Tĩnh', 'Hà Tĩnh có bãi biển Thiên Cầm và các di tích lịch sử.', 'database/locations/HaTinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hatinh', 0.00, 'nui'),
(26, 'Hải Dương', 'Hải Dương nổi tiếng với bánh đậu xanh và các làng nghề truyền thống.', 'database/locations/HaiDuong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haiduong', 0.00, 'bien'),
(27, 'Hải Phòng', 'Hải Phòng là thành phố cảng, có bãi biển Đồ Sơn nổi tiếng.', 'database/locations/HaiPhong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haiphong', 0.00, 'dongbang'),
(28, 'Hậu Giang', 'Hậu Giang là một tỉnh thuộc đồng bằng sông Cửu Long, phát triển nông nghiệp.', 'database/locations/HauGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haugiang', 0.00, 'dongbang'),
(29, 'Hòa Bình', 'Hòa Bình có thủy điện Hòa Bình và văn hóa dân tộc Mường.', 'database/locations/HoaBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hoabinh', 0.00, 'nui'),
(30, 'Hưng Yên', 'Hưng Yên nổi tiếng với nhãn lồng và nhiều làng nghề truyền thống.', 'database/locations/HungYen.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hungyen', 0.00, 'dongbang'),
(31, 'Khánh Hòa', 'Khánh Hòa có vịnh Nha Trang và nhiều bãi biển đẹp.', 'database/locations/KhanhHoa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'khanhhoa', 0.00, 'bien'),
(32, 'Kiên Giang', 'Kiên Giang có đảo Phú Quốc và cảnh quan biển đảo đẹp.', 'database/locations/KienGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'kiengiang', 0.00, 'bien'),
(33, 'Kon Tum', 'Kon Tum nổi tiếng với nhà rông Tây Nguyên và các bản làng dân tộc.', 'database/locations/KonTum.jpg', 0.00, 0, '2024-10-30 01:00:12', 'kontum', 0.00, 'nui'),
(34, 'Lai Châu', 'Lai Châu có nhiều đỉnh núi cao và phong cảnh hùng vĩ.', 'database/locations/LaiChau.jpg', 0.00, 0, '2024-10-30 01:00:12', 'laichau', 0.00, 'nui'),
(35, 'Lâm Đồng', 'Lâm Đồng có thành phố Đà Lạt với khí hậu mát mẻ quanh năm.', 'database/locations/LamDong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'lamdong', 0.00, 'nui'),
(36, 'Lạng Sơn', 'Lạng Sơn là tỉnh biên giới với nhiều danh lam thắng cảnh.', 'database/locations/LangSon.jpg', 0.00, 0, '2024-10-30 01:00:12', 'langson', 0.00, 'nui'),
(37, 'Lào Cai', 'Lào Cai có Sapa, điểm đến nổi tiếng với cảnh quan núi rừng.', 'database/locations/LaoCai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'laocai', 0.00, 'nui'),
(38, 'Long An', 'Long An có nền nông nghiệp phát triển và giáp ranh TP. Hồ Chí Minh.', 'database/locations/LongAn.jpg', 0.00, 0, '2024-10-30 01:00:12', 'longan', 0.00, 'dongbang'),
(39, 'Nam Định', 'Nam Định nổi tiếng với nhà thờ lớn và làng nghề chạm bạc.', 'database/locations/NamDinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'namdinh', 0.00, 'dongbang'),
(40, 'Nghệ An', 'Nghệ An là quê hương của Chủ tịch Hồ Chí Minh, có biển Cửa Lò.', 'database/locations/NgheAn.jpg', 0.00, 0, '2024-10-30 01:00:12', 'nghean', 0.00, 'bien'),
(41, 'Ninh Bình', 'Ninh Bình có Tràng An, Tam Cốc - Bích Động và nhiều di sản thiên nhiên.', 'database/locations/NinhBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'ninhbinh', 0.00, 'dongbang'),
(42, 'Ninh Thuận', 'Nổi tiếng với tháp Chăm và các cánh đồng muối, nho đặc trưng.', 'database/locations/NinhThuan.jpg', 0.00, 0, '2024-10-30 01:00:12', 'ninhthuan', 0.00, 'nui'),
(43, 'Phú Thọ', 'Phú Thọ là đất tổ Hùng Vương với đền Hùng nổi tiếng.', 'database/locations/PhuTho.jpg', 0.00, 0, '2024-10-30 01:00:12', 'phutho', 0.00, 'nui'),
(44, 'Phú Yên', 'Phú Yên có Gành Đá Đĩa và nhiều bãi biển hoang sơ.', 'database/locations/PhuYen.jpg', 0.00, 0, '2024-10-30 01:00:12', 'phuyen', 0.00, 'bien'),
(45, 'Quảng Bình', 'Quảng Bình có động Phong Nha - Kẻ Bàng và nhiều hang động lớn.', 'database/locations/QuangBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'quangbinh', 0.00, 'nui'),
(46, 'Quảng Nam', 'Quảng Nam có phố cổ Hội An và thánh địa Mỹ Sơn.', 'database/locations/QuangNam.jpg', 0.00, 0, '2024-10-30 01:00:12', 'quangnam', 0.00, 'bien'),
(47, 'Quảng Ngãi', 'Quảng Ngãi nổi tiếng với đảo Lý Sơn và văn hóa Champa.', 'database/locations/QuangNgai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'quangngai', 0.00, 'bien'),
(48, 'Quảng Ninh', 'Quảng Ninh có vịnh Hạ Long là di sản thiên nhiên thế giới.', 'database/locations/QuangNinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'quangninh', 0.00, 'bien'),
(49, 'Quảng Trị', 'Quảng Trị gắn liền với nhiều di tích lịch sử chiến tranh.', 'database/locations/QuangTri.jpg', 0.00, 0, '2024-10-30 01:00:12', 'quangtri', 0.00, 'nui'),
(50, 'Sóc Trăng', 'Sóc Trăng có chùa Dơi, chùa Chén Kiểu và văn hóa Khmer.', 'database/locations/SocTrang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'soctrang', 0.00, 'dongbang'),
(51, 'Sơn La', 'Sơn La có cao nguyên Mộc Châu với nhiều đồi chè và cảnh quan đẹp.', 'database/locations/SonLa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'sonla', 0.00, 'nui'),
(52, 'Tây Ninh', 'Tây Ninh có núi Bà Đen và đạo Cao Đài.', 'database/locations/tayninh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'tayninh', 0.00, 'dongbang'),
(53, 'Thái Bình', 'Thái Bình là quê lúa, phát triển nông nghiệp và làng nghề.', 'database/locations/ThaiBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thaibinh', 0.00, 'dongbang'),
(54, 'Thái Nguyên', 'Thái Nguyên nổi tiếng với chè Thái Nguyên và các khu công nghiệp.', 'database/locations/ThaiNguyen.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thainguyen', 0.00, 'nui'),
(55, 'Thanh Hóa', 'Thanh Hóa có bãi biển Sầm Sơn và nhiều di tích lịch sử.', 'database/locations/ThanhHoa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thanhhoa', 0.00, 'bien'),
(56, 'Thừa Thiên Huế', 'Huế là cố đô với nhiều di sản văn hóa và lăng tẩm triều Nguyễn.', 'database/locations/ThuaThienHue.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thuathienhue', 0.00, 'bien'),
(57, 'Tiền Giang', 'Tiền Giang có chợ nổi Cái Bè và các cù lao sông nước.', 'database/locations/TienGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'tiengiang', 0.00, 'dongbang'),
(58, 'TP. Hồ Chí Minh', 'Trung tâm kinh tế lớn nhất Việt Nam với nhiều hoạt động sôi động.', 'database/locations/TPHoChiMinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hochiminh', 0.00, 'bien'),
(59, 'Trà Vinh', 'Trà Vinh có nhiều chùa Khmer và văn hóa truyền thống.', 'database/locations/TraVinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'travinh', 0.00, 'dongbang'),
(60, 'Tuyên Quang', 'Tuyên Quang có di tích Tân Trào, gắn với lịch sử cách mạng.', 'database/locations/TuyenQuang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'tuyenquang', 0.00, 'nui'),
(61, 'Vĩnh Long', 'Vĩnh Long có nhiều cù lao và đặc trưng miền sông nước.', 'database/locations/VinhLong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'vinhlong', 0.00, 'dongbang'),
(62, 'Vĩnh Phúc', 'Vĩnh Phúc có Tam Đảo, địa điểm nghỉ dưỡng và phong cảnh đẹp.', 'database/locations/VinhPhuc.jpg', 0.00, 0, '2024-10-30 01:00:12', 'vinhphuc', 0.00, 'dongbang'),
(63, 'Yên Bái', 'Yên Bái có ruộng bậc thang Mù Cang Chải nổi tiếng.', 'database/locations/YenBai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'yenbai', 0.00, 'nui');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `location_ratings`
--

CREATE TABLE `location_ratings` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `location_id` int NOT NULL,
  `rating` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `user_id`, `login_time`) VALUES
(51, 18, '2024-11-17 03:50:23'),
(52, 19, '2024-11-17 03:52:42'),
(53, 22, '2024-11-17 04:36:51'),
(54, 18, '2024-11-17 04:38:08'),
(55, 27, '2024-11-17 08:21:21'),
(56, 22, '2024-11-17 09:06:31'),
(57, 32, '2024-11-17 09:16:40'),
(58, 32, '2024-11-17 09:29:58'),
(59, 22, '2024-11-17 10:10:50'),
(60, 18, '2024-11-17 10:19:28'),
(61, 18, '2024-11-17 10:31:15');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `postcomment`
--

CREATE TABLE `postcomment` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idpost` int DEFAULT NULL,
  `userid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `postdetail`
--

CREATE TABLE `postdetail` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` text,
  `rate` decimal(3,2) DEFAULT '0.00',
  `amongrate` int DEFAULT '0',
  `location` varchar(255) DEFAULT NULL,
  `view` int DEFAULT '0',
  `userid` int DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT 'notapproved',
  `typepost` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `postdetail`
--

INSERT INTO `postdetail` (`id`, `name`, `date`, `image`, `content`, `rate`, `amongrate`, `location`, `view`, `userid`, `description`, `status`, `typepost`) VALUES
(1, 'Vườn quốc gia Phong Nha - Kẻ Bàng', '2024-11-17 12:15:00', 'database/posts/post_8739c7335847c6.34761934.jpg', 'Vườn quốc gia Phong Nha - Kẻ Bàng, nằm ở tỉnh Quảng Bình, là một trong những điểm đến hấp dẫn nhất của Việt Nam, nơi lưu giữ hệ thống hang động đẹp nhất và kỳ vĩ nhất trên thế giới. Với sự kết hợp hoàn hảo giữa cảnh sắc thiên nhiên hoang dã, những hang động kỳ bí và hệ sinh thái rừng nhiệt đới phong phú, Phong Nha - Kẻ Bàng là thiên đường cho những ai yêu thích khám phá và chinh phục vẻ đẹp hoang sơ của thiên nhiên.\n\nVới hơn 300 hang động lớn nhỏ, Phong Nha - Kẻ Bàng nổi tiếng là \"vương quốc\" của các hang động, trong đó nổi bật nhất là Hang Sơn Đoòng – hang động lớn nhất thế giới. Sơn Đoòng không chỉ gây ấn tượng với kích thước khổng lồ mà còn sở hữu những cảnh quan độc đáo, như các thạch nhũ khổng lồ, hệ sinh thái riêng biệt và cả một khu rừng nhiệt đới bên trong hang. Ngoài Sơn Đoòng, Phong Nha còn nổi bật với các hang động đẹp không kém, như Hang Phong Nha, Hang Tiên Sơn, Hang Thien Duong, mỗi hang đều mang một vẻ đẹp riêng biệt, kỳ ảo và khiến du khách phải ngỡ ngàng.\n\nBên cạnh hệ thống hang động, vườn quốc gia Phong Nha - Kẻ Bàng còn sở hữu một khu rừng nhiệt đới xanh tươi, với đa dạng động, thực vật và hệ sinh thái phong phú. Đây là nơi sinh sống của nhiều loài động vật quý hiếm, trong đó có các loài đặc hữu và nguy cấp như hổ, voi, voọc, vượn, và hàng trăm loài chim, bò sát khác. Cảnh quan thiên nhiên tại đây hùng vĩ và hoang sơ, tạo điều kiện lý tưởng để du khách có thể tham gia các hoạt động leo núi, trekking và khám phá khu vực rừng nguyên sinh.\n\nVới vẻ đẹp thiên nhiên tuyệt vời, hệ sinh thái phong phú và những hang động kỳ vĩ, Vườn quốc gia Phong Nha - Kẻ Bàng là điểm đến lý tưởng cho những ai đam mê du lịch khám phá, yêu thích thiên nhiên hoang dã và muốn trải nghiệm những điều kỳ diệu mà mẹ thiên nhiên đã ban tặng.', 0.00, 0, 'quangbinh', 1, 24, 'Phong Nha - Kẻ Bàng, thiên đường hang động ở Việt Nam.', 'approve', 'dulichmuasam'),
(2, 'Cao nguyên Mộc Châu – Cảnh sắc thiên nhiên tươi đẹp', '2024-11-17 12:30:40', 'database/posts/post_8739c710ab54b1.54258134.jpg', 'Mộc Châu, cao nguyên nằm ở phía Bắc Việt Nam, là một điểm đến lý tưởng cho những ai muốn tìm kiếm sự bình yên và hòa mình vào thiên nhiên trong lành. Nổi tiếng với những thảo nguyên xanh mướt, những cánh đồng hoa cải trắng muốt và khí hậu mát mẻ quanh năm, Mộc Châu mang đến một không gian tĩnh lặng, thư thái, là nơi lý tưởng để du khách trốn khỏi nhịp sống ồn ào của thành phố.\n\nVào mỗi mùa, Mộc Châu lại khoác lên mình những vẻ đẹp khác nhau. Vào mùa đông, những cánh đồng hoa cải trắng nở rộ, phủ đầy trên các thung lũng và triền đồi, tạo nên một cảnh sắc thơ mộng và tinh khôi. Mùa xuân đến, Mộc Châu lại trở thành điểm ngắm hoa mận, hoa đào, khoe sắc hồng và trắng trên khắp các sườn núi, tạo nên một bức tranh thiên nhiên đầy màu sắc. Những thảo nguyên xanh ngắt, những đồi chè trải dài tít tắp không chỉ tạo nên vẻ đẹp hút hồn mà còn mang lại không khí trong lành và bình yên cho du khách.\n\nKhí hậu của Mộc Châu cũng là một điểm cộng lớn, với nhiệt độ mát mẻ quanh năm. Vào mùa hè, khi cái nóng oi ả của miền Bắc khiến nhiều người muốn tìm nơi tránh nóng, Mộc Châu với không khí trong lành và mát mẻ luôn là lựa chọn tuyệt vời. Những buổi sáng sớm ở Mộc Châu, khi sương mù còn giăng lối, du khách có thể cảm nhận được sự bình yên tuyệt đối, như lạc vào một thế giới khác, nơi chỉ có âm thanh của gió, tiếng chim hót và không khí trong lành.\n\nBên cạnh vẻ đẹp thiên nhiên, Mộc Châu còn có nền văn hóa đặc sắc của các dân tộc thiểu số như Mông, Thái, Tày, với những bản làng yên bình, cuộc sống giản dị và thân thiện. Du khách có thể ghé thăm các bản làng, tìm hiểu phong tục tập quán của người dân địa phương và thưởng thức những món ăn đặc sản thơm ngon, như rau cải, sữa bò, gà đồi và các món nướng đặc trưng.\n\nMộc Châu không chỉ là nơi để thưởng ngoạn cảnh đẹp thiên nhiên mà còn là nơi để tìm lại sự bình yên trong tâm hồn, là điểm đến lý tưởng cho những ai yêu thích không gian mở, sự tĩnh lặng và vẻ đẹp mộc mạc, giản dị của cao nguyên.', 0.00, 0, 'sonla', 1, 25, 'Mộc Châu – Khám phá cao nguyên mộng mơ.', 'canceled', 'dulichmuasam'),
(5, 'Huế – Thành phố của di sản văn hóa', '2024-11-17 13:15:25', 'database/posts/post_8739c7271ab3b2.20315648.jpg', 'Huế, với những di tích lịch sử nổi tiếng như Đại Nội và các lăng tẩm của các vua triều Nguyễn, không chỉ là một thành phố cổ kính mà còn là nơi lưu giữ những giá trị văn hóa, lịch sử vô giá của Việt Nam. Là cố đô của triều đại Nguyễn, Huế mang trong mình một vẻ đẹp trang nghiêm, lãng mạn và đậm chất lịch sử, làm say đắm lòng người yêu thích tìm hiểu về quá khứ huy hoàng của dân tộc.\n\nĐại Nội Huế, một trong những công trình kiến trúc vĩ đại của Việt Nam, là nơi từng là trung tâm quyền lực của các triều đại Nguyễn. Với những tường thành kiên cố, những cổng lớn, các cung điện nguy nga và các công trình kiến trúc tinh xảo, Đại Nội là minh chứng sống động cho sự phát triển rực rỡ của nền văn minh Việt Nam trong suốt hàng trăm năm. Nơi đây, du khách có thể cảm nhận được không khí uy nghiêm, lịch sử hào hùng của một thời đại vàng son.\n\nNgoài Đại Nội, Huế còn nổi tiếng với các lăng tẩm của các vua triều Nguyễn, như Lăng Minh Mạng, Lăng Khải Định, Lăng Gia Long, mỗi lăng đều mang một dấu ấn riêng biệt về kiến trúc và nghệ thuật. Các công trình này không chỉ đẹp về mặt thẩm mỹ mà còn chứa đựng nhiều câu chuyện lịch sử, phản ánh đời sống, tín ngưỡng và phong cách cai trị của các vị vua Nguyễn.\n\nKhông chỉ là nơi lưu giữ các di tích lịch sử, Huế còn là một vùng đất giàu văn hóa với những giá trị truyền thống đặc sắc. Ẩm thực Huế, với các món ăn như bún bò Huế, cơm hến, bánh bèo, bánh nậm, là những tinh hoa của nền văn hóa ẩm thực Việt Nam, mang đậm hương vị riêng biệt, hấp dẫn du khách gần xa. Các lễ hội truyền thống của Huế, như Festival Huế, cũng là dịp để du khách trải nghiệm và tìm hiểu về văn hóa đặc sắc của miền Trung.\n\nVới những giá trị lịch sử, văn hóa độc đáo, Huế là một điểm đến lý tưởng cho những ai muốn khám phá, tìm hiểu về quá khứ vinh quang của dân tộc, đồng thời thưởng thức không khí thanh bình và sự duyên dáng của một thành phố cổ kính.', 0.00, 0, 'thuathienhue', 1, 28, 'Huế – Thành phố với giá trị văn hóa trường tồn.', 'canceled', 'dulichmuasam'),
(6, 'Côn Đảo – Nơi lưu giữ dấu ấn lịch sử', '2024-11-17 13:30:40', 'database/posts/post_8739c71ea08ac6.54812419.jpg', 'Côn Đảo, một quần đảo nằm ở phía Nam của Việt Nam, không chỉ nổi tiếng với những bãi biển hoang sơ, làn nước trong vắt và thiên nhiên hùng vĩ, mà còn là nơi lưu giữ những câu chuyện lịch sử đầy đau thương nhưng cũng rất đỗi tự hào. Là một điểm đến lý tưởng cho những ai yêu thích sự kết hợp giữa thiên nhiên và lịch sử, Côn Đảo mang đến một trải nghiệm nghỉ dưỡng yên tĩnh nhưng cũng sâu sắc và đầy ý nghĩa.\n\nĐến Côn Đảo, du khách sẽ bị cuốn hút bởi vẻ đẹp hoang sơ, với những bãi biển dài, cát trắng mịn màng, làn nước trong xanh, rất lý tưởng cho các hoạt động tắm biển, bơi lội, và thư giãn. Những bãi biển như Đầm Trầu, Côn Sơn, và Vịnh Con Rùa là những địa điểm tuyệt vời để du khách tận hưởng không gian yên bình, tách biệt khỏi sự ồn ào của cuộc sống đô thị. Các khu rừng nguyên sinh và hệ sinh thái đa dạng của Côn Đảo cũng là một điểm nhấn cho những ai yêu thích khám phá thiên nhiên hoang dã.\n\nTuy nhiên, Côn Đảo không chỉ đơn thuần là một nơi nghỉ dưỡng. Đây còn là nơi chứng kiến những câu chuyện lịch sử đầy bi thương và hào hùng của dân tộc. Là nơi từng là nhà tù khét tiếng trong thời kỳ chiến tranh chống Pháp và Mỹ, Côn Đảo đã ghi dấu sự hy sinh của bao thế hệ chiến sĩ cách mạng. Các di tích lịch sử như Nhà Tù Côn Đảo, nơi giam giữ và tra tấn các chiến sĩ yêu nước, là những minh chứng sống động về lòng kiên cường và ý chí chiến đấu không khuất phục của người dân Việt Nam.\n\nĐiều đặc biệt ở Côn Đảo là sự kết hợp hài hòa giữa thiên nhiên tươi đẹp và giá trị lịch sử sâu sắc. Du khách đến đây không chỉ để tận hưởng không gian thư giãn mà còn có thể tìm hiểu về những ký ức bi hùng, những câu chuyện đấu tranh kiên cường của các chiến sĩ cách mạng, góp phần thấu hiểu và trân trọng hơn giá trị của tự do, độc lập.\n\nCôn Đảo là điểm đến lý tưởng cho những ai mong muốn tìm về sự yên tĩnh, tĩnh tâm trong không gian thiên nhiên hoang sơ, đồng thời cảm nhận sâu sắc về những giá trị lịch sử đáng trân trọng. Đây thực sự là một nơi kết hợp giữa nghỉ dưỡng thanh bình và những trải nghiệm đầy ý nghĩa về quá khứ oai hùng của dân tộc.', 0.00, 0, 'bariavungtau', 1, 29, 'Côn Đảo – Đảo ngọc với những câu chuyện lịch sử.', 'approve', 'dulichmuasam'),
(7, 'Bà Nà Hills – Chốn bồng lai tiên cảnh', '2024-11-17 13:45:10', 'database/posts/post_8739c72db276a1.58712349.jpg', 'Bà Nà Hills, tọa lạc ở thành phố Đà Nẵng, là một trong những điểm đến nổi bật, thu hút du khách bởi vẻ đẹp thiên nhiên hùng vĩ, không gian mát mẻ quanh năm và các công trình kiến trúc độc đáo. Với khí hậu ôn hòa, cảnh sắc tuyệt đẹp và những khu vui chơi, Bà Nà Hills đã trở thành một điểm đến lý tưởng cho những ai yêu thích khám phá vẻ đẹp của núi rừng và tìm kiếm những trải nghiệm thú vị.\n\nBà Nà Hills nổi bật với cảnh quan thiên nhiên tuyệt đẹp, những khu rừng nguyên sinh xanh tươi, đồi núi trập trùng và những đám mây bồng bềnh che phủ đỉnh núi. Không khí trong lành, mát mẻ quanh năm là một điểm cộng lớn, đặc biệt là vào những ngày hè oi ả, khi du khách có thể tạm rời xa cái nóng để tận hưởng khí hậu dễ chịu trên độ cao hơn 1.400 mét so với mực nước biển. Dù đến Bà Nà vào mùa nào, bạn cũng có thể cảm nhận được vẻ đẹp đặc trưng của thiên nhiên với những loài hoa nở rộ theo mùa và sự thay đổi của cảnh sắc theo từng thời khắc trong ngày.\n\nMột trong những điểm thu hút du khách nhất tại Bà Nà Hills là cây cầu Vàng nổi tiếng, với thiết kế độc đáo như đôi bàn tay khổng lồ nâng đỡ cây cầu. Cây cầu này không chỉ là một công trình kiến trúc ấn tượng mà còn là nơi lý tưởng để du khách chụp hình, ngắm cảnh và chiêm ngưỡng toàn cảnh Đà Nẵng từ trên cao. Bên cạnh đó, chùa Linh Ứng với tượng Phật Bà Quan Âm lớn nhất Việt Nam cũng là một điểm đến linh thiêng mà du khách không thể bỏ qua khi đến Bà Nà.\n\nNgoài những cảnh quan thiên nhiên và công trình kiến trúc nổi bật, Bà Nà Hills còn là nơi lý tưởng để vui chơi giải trí. Các khu vui chơi, trò chơi mạo hiểm, khu trượt tuyết, cáp treo dài nhất thế giới và nhiều hoạt động giải trí hấp dẫn khác sẽ mang lại cho du khách những trải nghiệm khó quên. Đặc biệt, hệ thống cáp treo Bà Nà với chiều dài hơn 5.800 mét là một trong những điểm nhấn ấn tượng, giúp du khách dễ dàng di chuyển và ngắm nhìn toàn cảnh vùng núi rừng từ trên cao.\n\nBà Nà Hills là sự kết hợp hoàn hảo giữa vẻ đẹp thiên nhiên hùng vĩ, những công trình kiến trúc độc đáo và các hoạt động vui chơi giải trí thú vị. Đây thực sự là điểm đến lý tưởng cho những ai muốn khám phá vẻ đẹp của núi rừng, tận hưởng không khí trong lành và tham gia vào các hoạt động đầy hấp dẫn.', 0.00, 0, 'danang', 1, 30, 'Bà Nà Hills – Chốn tiên cảnh giữa lòng Đà Nẵng.', 'approve', 'dulichmuasam'),
(8, 'Nha Trang – Thành phố biển quyến rũ', '2024-11-17 14:00:25', 'database/posts/post_8739c731cad97d.20545981.jpg', 'Bà Nà Hills, tọa lạc ở thành phố Đà Nẵng, là một trong những điểm đến nổi bật, thu hút du khách bởi vẻ đẹp thiên nhiên hùng vĩ, không gian mát mẻ quanh năm và các công trình kiến trúc độc đáo. Với khí hậu ôn hòa, cảnh sắc tuyệt đẹp và những khu vui chơi, Bà Nà Hills đã trở thành một điểm đến lý tưởng cho những ai yêu thích khám phá vẻ đẹp của núi rừng và tìm kiếm những trải nghiệm thú vị.\n\nBà Nà Hills nổi bật với cảnh quan thiên nhiên tuyệt đẹp, những khu rừng nguyên sinh xanh tươi, đồi núi trập trùng và những đám mây bồng bềnh che phủ đỉnh núi. Không khí trong lành, mát mẻ quanh năm là một điểm cộng lớn, đặc biệt là vào những ngày hè oi ả, khi du khách có thể tạm rời xa cái nóng để tận hưởng khí hậu dễ chịu trên độ cao hơn 1.400 mét so với mực nước biển. Dù đến Bà Nà vào mùa nào, bạn cũng có thể cảm nhận được vẻ đẹp đặc trưng của thiên nhiên với những loài hoa nở rộ theo mùa và sự thay đổi của cảnh sắc theo từng thời khắc trong ngày.\n\nMột trong những điểm thu hút du khách nhất tại Bà Nà Hills là cây cầu Vàng nổi tiếng, với thiết kế độc đáo như đôi bàn tay khổng lồ nâng đỡ cây cầu. Cây cầu này không chỉ là một công trình kiến trúc ấn tượng mà còn là nơi lý tưởng để du khách chụp hình, ngắm cảnh và chiêm ngưỡng toàn cảnh Đà Nẵng từ trên cao. Bên cạnh đó, chùa Linh Ứng với tượng Phật Bà Quan Âm lớn nhất Việt Nam cũng là một điểm đến linh thiêng mà du khách không thể bỏ qua khi đến Bà Nà.\n\nNgoài những cảnh quan thiên nhiên và công trình kiến trúc nổi bật, Bà Nà Hills còn là nơi lý tưởng để vui chơi giải trí. Các khu vui chơi, trò chơi mạo hiểm, khu trượt tuyết, cáp treo dài nhất thế giới và nhiều hoạt động giải trí hấp dẫn khác sẽ mang lại cho du khách những trải nghiệm khó quên. Đặc biệt, hệ thống cáp treo Bà Nà với chiều dài hơn 5.800 mét là một trong những điểm nhấn ấn tượng, giúp du khách dễ dàng di chuyển và ngắm nhìn toàn cảnh vùng núi rừng từ trên cao.\n\nBà Nà Hills là sự kết hợp hoàn hảo giữa vẻ đẹp thiên nhiên hùng vĩ, những công trình kiến trúc độc đáo và các hoạt động vui chơi giải trí thú vị. Đây thực sự là điểm đến lý tưởng cho những ai muốn khám phá vẻ đẹp của núi rừng, tận hưởng không khí trong lành và tham gia vào các hoạt động đầy hấp dẫn.\n\n\n\n\n\n\n', 0.00, 0, 'khanhhoa', 1, 31, 'Nha Trang – Thành phố biển đẹp như mơ.', 'approve', 'dulichmuasam'),
(86, 'Kinh nghiệm du lịch Hội An', '2024-11-17 10:36:35', 'database/posts/post_6739c7335847c6.05668108.jpg', 'Hội An, thành phố cổ nằm bên dòng sông Thu Bồn, là nơi lưu giữ trọn vẹn nét đẹp truyền thống, tạo nên sức hút đặc biệt với du khách. Nổi tiếng với những dãy nhà cổ kính phủ màu thời gian, Hội An còn quyến rũ bởi nền ẩm thực phong phú và vẻ đẹp lung linh của phố cổ trong ánh đèn lồng rực rỡ.\n\nVẻ đẹp của Hội An không chỉ đến từ kiến trúc độc đáo mà còn ở không gian yên bình, khác xa sự xô bồ của cuộc sống hiện đại. Những ngôi nhà mái ngói rêu phong, tường vàng đặc trưng, cùng những con đường nhỏ lát gạch là minh chứng sống động cho một thời kỳ lịch sử đầy sôi động. Vào mỗi buổi tối, phố cổ như khoác lên mình chiếc áo mới với hàng ngàn chiếc đèn lồng đủ sắc màu, phản chiếu ánh sáng huyền ảo trên dòng sông, tạo nên khung cảnh lãng mạn khó quên.\n\nHội An còn là thiên đường ẩm thực với các món ăn đặc trưng như cao lầu, bánh mì Hội An, cơm gà và chè bắp. Mỗi món ăn mang đậm hương vị truyền thống, là sự kết tinh của văn hóa và tình yêu ẩm thực của người dân nơi đây. Bên cạnh đó, những quán cà phê nhỏ ven đường hay các phiên chợ đêm nhộn nhịp càng làm cho Hội An trở nên gần gũi và hấp dẫn hơn.\n\nHội An không chỉ là nơi dừng chân, mà còn là nơi để tìm lại sự bình yên và cảm nhận vẻ đẹp của những giá trị xưa cũ. Với sự kết hợp giữa văn hóa, ẩm thực, và ánh sáng lung linh của những chiếc đèn lồng, Hội An thực sự là điểm đến không thể bỏ qua khi khám phá vẻ đẹp của Việt Nam.', 0.00, 0, 'quangnam', 1, 18, 'Hội An, thành phố cổ với nét đẹp truyền thống, ẩm thực phong phú và phố cổ lung linh đèn lồng.', 'approve', 'dulichmuasam'),
(87, 'Hành trình khám phá Đà Lạt', '2024-11-17 10:45:10', 'database/posts/post_8739c774abc9d6.12947200.jpg', 'Đà Lạt, thành phố ngàn hoa, từ lâu đã trở thành một điểm đến lý tưởng cho những ai muốn tìm kiếm sự yên bình và thơ mộng. Nằm trên cao nguyên Lâm Viên, Đà Lạt được thiên nhiên ưu ái ban tặng khí hậu mát mẻ quanh năm, cùng với vẻ đẹp lãng mạn của những đồi thông bạt ngàn, hồ nước trong xanh và những khu vườn hoa rực rỡ sắc màu.\n\nVẻ đẹp của Đà Lạt hiện lên từ những điều giản dị nhưng đầy cuốn hút. Đó là những buổi sáng mờ sương trên hồ Xuân Hương, khi ánh mặt trời nhẹ nhàng chiếu rọi qua tán cây thông, tạo nên một khung cảnh như tranh vẽ. Hay những buổi chiều lãng đãng bên thung lũng Tình Yêu, nơi mà mọi góc nhỏ đều thấm đượm sự thơ mộng. Không chỉ có cảnh quan thiên nhiên, Đà Lạt còn nổi bật với những khu vườn hoa đủ sắc màu, từ cẩm tú cầu, hoa hướng dương đến các loài hoa độc đáo chỉ có tại thành phố này, khiến bất kỳ ai đến đây cũng phải trầm trồ.\n\nBên cạnh thiên nhiên tươi đẹp, con người Đà Lạt cũng là một phần không thể thiếu trong việc tạo nên sức hút của thành phố. Sự hiếu khách, thân thiện của người dân địa phương mang lại cảm giác ấm áp, khiến du khách như được chào đón về nhà. Đà Lạt còn hấp dẫn bởi ẩm thực phong phú với những món ăn dân dã mà đậm đà như bánh căn, lẩu gà lá é hay sữa đậu nành nóng – tất cả góp phần làm cho hành trình thêm trọn vẹn.\n\nVới khí hậu mát lành, khung cảnh thơ mộng và con người thân thiện, Đà Lạt thực sự là nơi nghỉ dưỡng hoàn hảo, nơi giúp con người thoát khỏi sự ồn ào, tất bật của cuộc sống thường nhật. Đây chính là một thành phố mang lại sự an nhiên và những ký ức khó phai trong lòng mỗi du khách.', 0.00, 0, 'lamdong', 1, 19, 'Đà Lạt, nơi hội tụ của thiên nhiên và con người.', 'notapproved', 'dulichmuasam'),
(88, 'Khám phá vịnh Hạ Long', '2024-11-17 11:10:15', 'database/posts/post_8739c744dee0c8.45126847.jpg', 'Vịnh Hạ Long, một trong bảy kỳ quan thiên nhiên thế giới, là điểm đến không thể bỏ qua đối với những ai yêu thích vẻ đẹp thiên nhiên. Nằm ở tỉnh Quảng Ninh, Vịnh Hạ Long nổi bật với hàng ngàn hòn đảo lớn nhỏ, các hang động tuyệt đẹp và làn nước trong xanh như ngọc. Đây là nơi hội tụ của sự hùng vĩ, thơ mộng và nét đẹp hoang sơ, tạo nên một bức tranh sơn thủy hữu tình đầy mê hoặc.\n\nĐến Vịnh Hạ Long, du khách sẽ bị cuốn hút bởi những hòn đảo đá vôi đủ hình dáng, mỗi hòn đảo như mang một câu chuyện, một huyền thoại riêng. Những cái tên như Hòn Gà Chọi, Hòn Đỉnh Hương hay Hòn Trống Mái không chỉ gợi trí tò mò mà còn làm say lòng người bởi vẻ đẹp độc đáo. Các hang động như Động Thiên Cung, Hang Sửng Sốt hay Hang Đầu Gỗ lại là những kỳ quan bên trong kỳ quan, nơi mà thiên nhiên đã khéo léo chạm khắc nên những khối thạch nhũ lung linh, kỳ ảo.\n\nHành trình khám phá Vịnh Hạ Long không thể thiếu trải nghiệm đi thuyền lênh đênh trên làn nước xanh biếc. Từ trên thuyền, du khách có thể phóng tầm mắt ra xa, ngắm nhìn cảnh đẹp thiên nhiên hùng vĩ, hít thở không khí trong lành và cảm nhận sự bình yên đến lạ. Đặc biệt, việc ghé thăm các làng chài nổi như Cửa Vạn hay Vung Viêng sẽ mang đến một góc nhìn độc đáo về cuộc sống giản dị, gần gũi với thiên nhiên của người dân nơi đây.\n\nVới vẻ đẹp độc nhất vô nhị, Vịnh Hạ Long không chỉ là niềm tự hào của Việt Nam mà còn là điểm đến mơ ước của du khách khắp nơi trên thế giới. Một lần đến với Vịnh Hạ Long, du khách chắc chắn sẽ mang về những kỷ niệm khó quên, cùng tình yêu sâu sắc dành cho vùng đất kỳ diệu này.', 0.00, 0, 'quangninh', 1, 20, 'Vịnh Hạ Long, di sản thiên nhiên hùng vĩ của Việt Nam.', 'approve', 'dulichmuasam'),
(89, 'Đảo Lý Sơn – Thiên đường giữa biển khơi', '2024-11-17 11:25:30', 'database/posts/post_8739c715baf7e9.93517401.jpg', 'Đảo Lý Sơn, nằm ở tỉnh Quảng Ngãi, được ví như một viên ngọc giữa biển khơi, là điểm đến lý tưởng cho những ai yêu thích vẻ đẹp hoang sơ và không gian yên bình. Với bãi biển xanh ngắt, làn nước trong vắt và không khí trong lành, Lý Sơn mang đến một trải nghiệm khó quên cho du khách muốn tìm một nơi để tạm lánh khỏi sự ồn ào của cuộc sống hiện đại.\n\nĐiểm đặc biệt của Lý Sơn là những ngọn núi lửa đã ngừng hoạt động, tạo nên cảnh quan thiên nhiên kỳ thú và độc đáo. Núi Thới Lới, với hình dáng như chiếc ô khổng lồ, là một trong những nơi lý tưởng để ngắm toàn cảnh đảo. Những hòn đảo nhỏ quanh Lý Sơn cũng sở hữu vẻ đẹp không kém, với những bãi cát trắng mịn màng và nước biển xanh biếc, như đảo Bé, đảo An Bình, nơi mà du khách có thể thư giãn, tắm nắng hay tham gia các hoạt động thể thao dưới nước.\n\nNền văn hóa địa phương của Lý Sơn cũng mang đậm dấu ấn riêng biệt, đặc biệt là lễ hội \"Lý Sơn – Sắc màu văn hóa biển\" với những nghi lễ truyền thống gắn liền với lịch sử và đời sống ngư dân. Du khách đến đây không chỉ được thưởng thức các món ăn đặc sản như tỏi Lý Sơn, cá nhám, cua huỳnh đế mà còn có cơ hội tìm hiểu về những phong tục tập quán độc đáo của người dân nơi đây.\n\nĐảo Lý Sơn không chỉ là điểm đến lý tưởng để khám phá vẻ đẹp thiên nhiên mà còn là nơi để tìm lại sự bình yên trong tâm hồn. Với những ai yêu thích sự hoang sơ, những ngọn núi lửa hùng vĩ và nền văn hóa đặc sắc, Lý Sơn chắc chắn sẽ là nơi đáng để ghé thăm trong hành trình khám phá vẻ đẹp', 0.00, 0, 'quangngai', 0, 21, 'Lý Sơn – Điểm đến hấp dẫn với vẻ đẹp nguyên sơ.', 'notapproved', 'dulichmuasam'),
(90, 'Cù Lao Chàm – Hòn ngọc của Quảng Nam', '2024-11-17 11:40:55', 'database/posts/post_8739c774fde1a6.74280164.jpg', 'Cù Lao Chàm, cụm đảo nằm cách Hội An chỉ khoảng 15 km về phía Đông, là một trong những điểm đến hấp dẫn dành cho những ai yêu thích thiên nhiên hoang sơ và hệ sinh thái biển phong phú. Với vẻ đẹp tuyệt vời, những bãi biển cát trắng mịn màng, nước biển trong vắt và cảnh quan đa dạng, Cù Lao Chàm là nơi lý tưởng để du khách tận hưởng những giây phút thư giãn và khám phá vẻ đẹp thiên nhiên nguyên sơ.\n\nMột trong những trải nghiệm không thể bỏ qua khi đến Cù Lao Chàm là lặn biển ngắm san hô. Dưới làn nước trong xanh, du khách có thể chiêm ngưỡng hệ sinh thái san hô phong phú, với đủ màu sắc sống động và những loài sinh vật biển đa dạng. Ngoài việc lặn biển, du khách còn có thể tham gia các hoạt động thể thao dưới nước khác như chèo thuyền kayak hay câu cá, mang đến những trải nghiệm thú vị.\n\nCù Lao Chàm không chỉ nổi tiếng với cảnh quan thiên nhiên mà còn là nơi lưu giữ nhiều di tích lịch sử, đặc biệt là các công trình cổ từ thời Cham Pa, như chùa Hải Tạng, đền thờ cá Ông và các khu di tích khảo cổ. Những địa danh này không chỉ có giá trị lịch sử mà còn giúp du khách hiểu thêm về văn hóa, tín ngưỡng của người dân nơi đây.\n\nBên cạnh đó, Cù Lao Chàm cũng nổi bật với hải sản tươi sống, đặc biệt là các món ăn từ hải sản như mực, cá, tôm, ốc và các loại cua biển. Những món ăn này được chế biến đơn giản nhưng mang đậm hương vị biển cả, làm hài lòng bất kỳ thực khách nào.\n\nVới vẻ đẹp hoang sơ, hệ sinh thái biển phong phú và những giá trị văn hóa đặc sắc, Cù Lao Chàm thực sự là điểm đến lý tưởng cho những ai yêu thích thiên nhiên và mong muốn trải nghiệm một chuyến du lịch kết hợp giữa khám phá và nghỉ dưỡng.', 0.00, 0, 'quangnam', 1, 22, 'Cù Lao Chàm – Nơi giao thoa giữa thiên nhiên và lịch sử.', 'approve', 'dulichmuasam'),
(91, 'Khám phá Sapa – Thành phố mù sương', '2024-11-17 12:00:20', 'database/posts/post_8739c724dea3c2.87519420.jpg', 'Sapa, thị trấn nhỏ nằm ở vùng cao Tây Bắc, là một trong những điểm đến nổi bật của Việt Nam, nơi hội tụ vẻ đẹp thiên nhiên hùng vĩ và sự phong phú về văn hóa của các dân tộc thiểu số. Với những thửa ruộng bậc thang trải dài xanh mướt, dãy núi Hoàng Liên Sơn hùng vĩ và khí hậu se lạnh đặc trưng, Sapa mang đến một không gian thư giãn, bình yên và đầy mê hoặc cho du khách.\n\nMột trong những đặc trưng nổi bật của Sapa chính là những thửa ruộng bậc thang tuyệt đẹp, kéo dài dọc theo sườn núi, như những con sóng xanh mướt, mỗi mùa lại khoác lên mình một màu sắc khác nhau. Vào mùa lúa chín, những cánh đồng ruộng bậc thang vàng óng ánh dưới ánh nắng tạo nên một cảnh quan tuyệt mỹ khiến ai cũng phải trầm trồ. Cảnh sắc này càng trở nên huyền bí và ấn tượng hơn khi được bao quanh bởi dãy núi Hoàng Liên Sơn, với đỉnh Fansipan – \"Nóc nhà Đông Dương\" – cao chót vót, nơi du khách có thể chinh phục và ngắm nhìn toàn cảnh thiên nhiên hùng vĩ của vùng cao.\n\nKhí hậu ở Sapa cũng là một điểm cộng lớn, đặc biệt vào những ngày hè oi ả, Sapa trở thành một nơi lý tưởng để tránh nóng, với không khí trong lành và mát mẻ quanh năm. Vào mùa đông, thị trấn nhỏ này lại khoác lên mình lớp sương mù lạnh giá, đôi khi có tuyết rơi, tạo nên một không gian huyền ảo và lãng mạn.\n\nNgoài vẻ đẹp thiên nhiên, Sapa còn thu hút du khách bởi nền văn hóa đa dạng của các dân tộc thiểu số như H\'mông, Dao, Tay, Xã, với những phong tục, tập quán độc đáo. Du khách đến Sapa có thể khám phá các chợ phiên, tham gia vào các lễ hội truyền thống, hay tìm hiểu về cuộc sống của người dân địa phương qua những ngôi làng nhỏ xinh đẹp như bản Cát Cát, bản Tả Phìn.\n\nSapa không chỉ là nơi để chiêm ngưỡng vẻ đẹp thiên nhiên hùng vĩ mà còn là điểm đến giúp du khách hiểu thêm về đời sống và văn hóa của các dân tộc thiểu số Tây Bắc. Với cảnh sắc tuyệt vời, khí hậu mát mẻ và nền văn hóa phong phú, Sapa chắc chắn là điểm đến lý tưởng cho những ai yêu thích sự hoang sơ, bình yên và muốn khám phá vẻ đẹp độc đáo của vùng cao.', 0.00, 0, 'laocai', 1, 23, 'Sapa – Điểm đến mộng mơ giữa vùng cao Tây Bắc.', 'approve', 'dulichmuasam'),
(94, 'Phú Quốc – Đảo ngọc thiên đường', '2024-11-17 12:45:10', 'database/posts/post_8739c74cdae6d5.34121867.jpg', 'Phú Quốc, hòn đảo ngọc nổi tiếng của Việt Nam, là một trong những điểm đến du lịch hấp dẫn không thể bỏ qua. Nổi bật với những bãi biển dài, cát trắng mịn màng, làn nước trong xanh và không gian yên bình, Phú Quốc mang đến một kỳ nghỉ lý tưởng để tận hưởng sự thư giãn tuyệt đối trong thiên nhiên tươi đẹp.\n\nBãi Sao, Bãi Dài, và Bãi Trường là những bãi biển nổi tiếng tại Phú Quốc, mỗi bãi biển đều sở hữu vẻ đẹp riêng biệt. Làn nước trong vắt, sóng nhẹ nhàng vỗ về bờ, cùng bãi cát trắng mịn là nơi lý tưởng để du khách thư giãn, tắm nắng, bơi lội hoặc tham gia các hoạt động thể thao dưới nước như lặn biển, dù lượn, và đi cano. Khung cảnh thơ mộng, tĩnh lặng của Phú Quốc cũng là một điểm đến lý tưởng cho những ai tìm kiếm không gian yên bình để nghỉ ngơi, thư giãn và tái tạo năng lượng.\n\nBên cạnh thiên nhiên hoang sơ, Phú Quốc còn nổi bật với những khu resort cao cấp và các dịch vụ nghỉ dưỡng sang trọng, mang đến cho du khách những trải nghiệm đẳng cấp. Các khu nghỉ dưỡng ở Phú Quốc không chỉ có các tiện ích hiện đại mà còn được xây dựng trong không gian gần gũi với thiên nhiên, giúp du khách hòa mình vào vẻ đẹp của đảo ngọc. Những khu nghỉ dưỡng ven biển với các bungalow nằm sát bãi biển, hoặc những biệt thự sang trọng với hồ bơi riêng, đều mang lại sự thoải mái tuyệt đối cho du khách.\n\nPhú Quốc không chỉ là thiên đường biển cả, mà còn là nơi lưu giữ nhiều giá trị văn hóa đặc sắc. Du khách có thể tham quan những địa điểm nổi tiếng như Vinpearl Safari, Dinh Cậu, hay chợ Dương Đông để tìm hiểu về cuộc sống địa phương, thưởng thức những món ăn đặc sản nổi tiếng như hải sản tươi sống, nước mắm Phú Quốc và các món ăn mang đậm bản sắc của đảo.\n\nVới vẻ đẹp thiên nhiên tuyệt mỹ, những bãi biển hoang sơ, các khu nghỉ dưỡng đẳng cấp và nền văn hóa đặc sắc, Phú Quốc chính là điểm đến lý tưởng cho những ai muốn tận hưởng một kỳ nghỉ thư giãn và đầy ý nghĩa, mang lại những trải nghiệm khó quên.', 0.00, 0, 'kiengiang', 0, 26, 'Phú Quốc – Thiên đường nghỉ dưỡng đầy nắng và gió.', 'canceled', 'dulichmuasam'),
(95, 'Ninh Bình – Vùng đất của di sản thiên nhiên', '2024-11-17 13:00:30', 'database/posts/post_8739c730b73ae9.65490185.jpg', 'Ninh Bình, nằm ở miền Bắc Việt Nam, là một trong những điểm du lịch nổi bật với cảnh quan thiên nhiên tuyệt đẹp, những di tích lịch sử và văn hóa phong phú. Nơi đây nổi tiếng với các khu du lịch như Tràng An, Tam Cốc và chùa Bái Đính, là những địa điểm không thể bỏ qua đối với những ai yêu thích khám phá vẻ đẹp hoang sơ và hùng vĩ của thiên nhiên.\n\nTràng An, được mệnh danh là \"Vịnh Hạ Long trên cạn\", là một khu vực nổi bật với các dãy núi đá vôi hùng vĩ, hệ thống hang động kỳ bí và những dòng sông xanh biếc uốn lượn quanh các ngọn núi. Du khách có thể đi thuyền dọc theo các con sông, ngắm nhìn những khối đá vôi cao sừng sững và thỏa sức chiêm ngưỡng cảnh sắc thiên nhiên hoang sơ, tĩnh lặng. Tràng An không chỉ là một kỳ quan thiên nhiên mà còn là nơi có nhiều di tích lịch sử, văn hóa, mang đậm dấu ấn của thời kỳ đầu dựng nước.\n\nTam Cốc, hay còn gọi là \"Hạ Long trên cạn\", là một địa điểm du lịch không kém phần hấp dẫn. Tam Cốc nổi tiếng với ba hang động xuyên qua các ngọn núi đá vôi, nơi dòng sông Ngô Đồng chảy qua tạo nên một cảnh quan huyền bí và thơ mộng. Du khách sẽ được trải nghiệm hành trình đi thuyền qua những con sông xanh mướt, chiêm ngưỡng những cánh đồng lúa vàng ruộm vào mùa gặt, và tận hưởng bầu không khí trong lành của vùng đất này.\n\nChùa Bái Đính, một trong những ngôi chùa lớn và linh thiêng nhất ở Việt Nam, cũng là điểm đến nổi bật tại Ninh Bình. Nơi đây không chỉ thu hút du khách bởi những công trình kiến trúc hoành tráng, mà còn bởi không gian tôn nghiêm và cảnh sắc thiên nhiên tuyệt đẹp bao quanh. Với quần thể chùa lớn, các tượng Phật khổng lồ, và những con đường dẫn lên chùa nằm trên đỉnh núi, Bái Đính là nơi lý tưởng để du khách tìm hiểu về văn hóa Phật giáo và tận hưởng không gian thanh tịnh.\n\nNinh Bình là một điểm đến lý tưởng cho những ai yêu thích khám phá thiên nhiên hoang sơ, tìm kiếm sự bình yên trong không gian tĩnh lặng, đồng thời cũng muốn tìm hiểu về lịch sử, văn hóa và những giá trị truyền thống của Việt Nam. Những cảnh quan tuyệt đẹp như Tràng An, Tam Cốc và chùa Bái Đính sẽ khiến du khách không thể nào quên.', 0.00, 0, 'ninhbinh', 1, 27, 'Ninh Bình – Chuyến hành trình vào thế giới di sản.', 'notapproved', 'dulichmuasam'),
(100, 'Vũng Tàu – Thành phố biển nổi tiếng', '2024-11-17 14:15:50', 'database/posts/post_8739c7371a0cd4.69271813.jpg', 'Vũng Tàu, với những bãi biển xanh và các hoạt động thể thao dưới nước thú vị, là một điểm đến tuyệt vời cho những ai muốn thư giãn và tận hưởng không khí biển. Bên cạnh đó, Vũng Tàu còn nổi bật với các khu vui chơi và các công trình văn hóa.', 0.00, 0, 'bariavungtau', 0, 32, 'Vũng Tàu – Khám phá vẻ đẹp biển và núi.', 'notapproved', 'dulichmuasam'),
(101, 'Sơn La – Điểm đến đầy sắc màu', '2024-11-17 14:30:05', 'database/posts/post_8739c72af0d672.19537452.jpg', 'Sơn La, với những thung lũng xanh mát, những đồi chè bạt ngàn và những bản làng dân tộc thiểu số, là điểm đến đầy màu sắc cho những ai muốn trải nghiệm vẻ đẹp nguyên sơ của thiên nhiên và văn hóa.', 0.00, 0, 'sonla', 1, 33, 'Sơn La – Khám phá vẻ đẹp của vùng Tây Bắc.', 'notapproved', 'dulichmuasam'),
(102, 'Cao lầu Hội An', '2024-11-17 15:00:00', 'database/posts/post_8739c73cdaf6b3.15882439.jpg', 'Cao lầu là món ăn đặc sản của Hội An, nổi bật với sợi mì dày, giòn, được kết hợp với thịt xá xíu, rau sống và nước lèo đậm đà. Món ăn này mang hương vị đặc biệt không thể tìm thấy ở bất kỳ nơi nào khác.', 0.00, 0, 'quangnam', 0, 34, 'Cao lầu Hội An – Món ăn truyền thống độc đáo.', 'notapproved', 'anuong'),
(103, 'Bánh mì Phượng – Món ngon Hội An', '2024-11-17 15:15:30', 'database/posts/post_8739c73122d1a8.48375719.jpg', 'Bánh mì Phượng nổi tiếng khắp nơi với sự kết hợp hoàn hảo giữa bánh mì giòn và nhân đầy đặn. Món ăn này có thể được tùy chỉnh với nhiều loại nhân khác nhau, từ thịt nướng, thịt xá xíu đến rau củ tươi ngon.', 0.00, 0, 'quangnam', 0, 35, 'Bánh mì Phượng – Món ngon không thể bỏ qua ở Hội An.', 'approve', 'anuong'),
(104, 'Bánh xèo miền Trung', '2024-11-17 15:30:45', 'database/posts/post_8739c736fa6fe5.25389611.jpg', 'Bánh xèo miền Trung có vỏ giòn, nhân tôm, thịt và giá đỗ, ăn kèm với rau sống và nước chấm đặc trưng. Đây là món ăn được yêu thích không chỉ vì hương vị mà còn bởi cách chế biến tinh tế.', 0.00, 0, 'quangnam', 0, 36, 'Bánh xèo – Món ăn truyền thống miền Trung đầy hấp dẫn.', 'approve', 'anuong'),
(105, 'Phở Hà Nội', '2024-11-17 15:45:10', 'database/posts/post_8739c72f5579b8.98637093.jpg', 'Phở Hà Nội là món ăn nổi tiếng, được yêu thích với nước dùng trong veo, thơm ngon, thịt bò tươi mềm và sợi phở dai ngon. Đây là món ăn không thể thiếu trong bữa sáng của người dân Hà Nội.', 0.00, 0, 'hanoi', 0, 37, 'Phở Hà Nội – Hương vị truyền thống đặc sắc.', 'notapproved', 'anuong'),
(106, 'Gỏi cuốn – Món ăn nhẹ Việt Nam', '2024-11-17 16:00:30', 'database/posts/post_8739c73bb16f37.25874017.jpg', 'Gỏi cuốn là món ăn nhẹ phổ biến ở Việt Nam, với lớp bánh tráng mỏng bao phủ nhân tôm, thịt, rau sống và bún. Món ăn này được ăn kèm với nước mắm chua ngọt đặc trưng, mang đến hương vị tươi mát và dễ chịu.', 0.00, 0, 'hochiminh', 0, 38, 'Gỏi cuốn – Món ăn nhẹ thơm ngon, dễ làm.', 'approve', 'anuong'),
(107, 'Kỳ nghỉ tại Phú Quốc', '2024-11-17 16:15:30', 'database/posts/post_8739c7305c6bd2.41854628.jpg', 'Phú Quốc là một địa điểm lý tưởng để nghỉ dưỡng với những bãi biển đẹp, không khí trong lành và các khu nghỉ dưỡng cao cấp. Đây là nơi lý tưởng để thư giãn và khám phá những điểm du lịch nổi tiếng.', 0.00, 0, 'kiengiang', 0, 39, 'Phú Quốc – Thiên đường nghỉ dưỡng và khám phá.', 'notapproved', 'nghiduong'),
(108, 'Nha Trang – Thành phố biển', '2024-11-17 16:30:00', 'database/posts/post_8739c74e3fe4a5.32967408.jpg', 'Nha Trang, với những bãi biển cát trắng mịn và làn nước trong xanh, là điểm đến lý tưởng cho một kỳ nghỉ dưỡng tuyệt vời. Các khu nghỉ dưỡng cao cấp và các hoạt động thể thao dưới nước khiến Nha Trang trở thành thiên đường của du lịch.', 0.00, 0, 'khanhhoa', 0, 40, 'Nha Trang – Thành phố biển lý tưởng cho kỳ nghỉ', 'approve', 'nghiduong'),
(109, 'Đà Lạt – Thành phố ngàn hoa', '2024-11-17 16:45:15', 'database/posts/post_8739c721f8cdd1.13257709.jpg', 'Đà Lạt là một trong những điểm đến nổi tiếng với khí hậu mát mẻ quanh năm và những vườn hoa rực rỡ. Đây là nơi lý tưởng để thư giãn, tận hưởng cảnh quan thiên nhiên và khám phá các địa điểm du lịch nổi bật như hồ Xuân Hương và thác Datanla.', 0.00, 0, 'lamdong', 0, 41, 'Đà Lạt – Thành phố ngàn hoa, điểm đến lý tưởng cho kỳ nghỉ', 'approve', 'nghiduong'),
(110, 'Hạ Long – Vịnh di sản thiên nhiên', '2024-11-17 16:59:40', 'database/posts/post_8739c7389b1d7a.37421648.jpg', 'Hạ Long với vịnh biển xanh ngắt, hàng nghìn đảo đá vôi kỳ vĩ là một điểm đến không thể bỏ qua đối với những ai yêu thích du lịch thiên nhiên. Một chuyến du lịch Hạ Long mang đến cho du khách những trải nghiệm thú vị với cảnh sắc tuyệt đẹp và không khí trong lành.', 0.00, 0, 'quangninh', 0, 42, 'Hạ Long – Kỳ quan thiên nhiên kỳ vĩ của thế giới', 'notapproved', 'nghiduong'),
(111, 'Sapa – Khám phá vùng núi Tây Bắc', '2024-11-17 17:10:50', 'database/posts/post_8739c7359e7db2.19659019.jpg', 'Sapa với những thửa ruộng bậc thang xanh ngắt và những ngọn núi hùng vĩ là địa điểm du lịch tuyệt vời cho những ai muốn tìm kiếm sự bình yên. Đến Sapa, du khách có thể thưởng ngoạn cảnh sắc tuyệt đẹp và khám phá văn hóa đặc sắc của các dân tộc thiểu số.', 0.00, 0, 'laocai', 0, 43, 'Sapa – Vùng đất tuyệt đẹp của Tây Bắc', 'approve', 'nghiduong'),
(112, 'Bún chả Hà Nội', '2024-11-17 17:30:00', 'database/posts/post_8739c74b87e5b9.45673825.jpg', 'Bún chả Hà Nội là món ăn đặc trưng của thủ đô, với thịt nướng thơm ngon, ăn kèm với bún tươi, rau sống và nước mắm chua ngọt. Món ăn này được nhiều người yêu thích bởi hương vị đậm đà và dễ ăn.', 0.00, 0, 'hanoi', 0, 18, 'Bún chả Hà Nội – Món ăn nổi tiếng thủ đô.', 'approve', 'anuong'),
(113, 'Mì Quảng', '2024-11-17 17:45:30', 'database/posts/post_8739c7364893b1.71280164.jpg', 'Mì Quảng là món ăn đặc sản của Quảng Nam, với sợi mì dày, nước dùng đậm đà, ăn kèm với tôm, thịt, rau sống và đậu phộng rang. Đây là món ăn đậm hương vị miền Trung, không thể thiếu trong bữa ăn của người dân nơi đây.', 0.00, 0, 'quangnam', 0, 18, 'Mì Quảng – Món ăn đặc sản miền Trung.', 'approve', 'anuong'),
(114, 'Hủ tiếu Nam Vang', '2024-11-17 18:00:00', 'database/posts/post_8739c737c5c0b8.93821843.jpg', 'Hủ tiếu Nam Vang là món ăn phổ biến ở miền Nam, đặc biệt là TP. Hồ Chí Minh. Món ăn này có nước dùng trong, thơm ngon với hủ tiếu mềm, thịt nạc, tôm, gan, ăn kèm với rau sống và gia vị đặc trưng.', 0.00, 0, 'hochiminh', 0, 18, 'Hủ tiếu Nam Vang – Món ăn hấp dẫn miền Nam.', 'notapproved', 'anuong');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_likes`
--

CREATE TABLE `post_likes` (
  `id` int NOT NULL,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_ratings`
--

CREATE TABLE `post_ratings` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `post_id` int NOT NULL,
  `rating` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `address` text,
  `isadmin` tinyint(1) DEFAULT '0',
  `avatar` varchar(255) DEFAULT NULL,
  `banned_until` timestamp NULL DEFAULT NULL,
  `point` decimal(10,2) DEFAULT '0.00',
  `status` varchar(50) DEFAULT 'exemplary',
  `warned_until` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `fullname`, `address`, `isadmin`, `avatar`, `banned_until`, `point`, `status`, `warned_until`) VALUES
(18, 'NhuanAdmin', '$2y$10$fL4dGYdedkz5Tgsz7c6/NOqXn1zqw5Qff.M24HNfhVnadJjcmKxKy', 'admin@gmail.com', 'Huỳnh Hồng Nhuận', 'To Ky , District 12 ', 1, NULL, NULL, 0.00, 'exemplary', NULL),
(19, 'VuAdmin', '$2y$10$v6KCSqwy10jRUSSA5ypgdOVJm7oVRcxw4JhHo9NNUZUB5kPDQ/af6', 'admin1@gmail.com', 'Võ Hoàng Vũ', 'To Ky , District 12 ', 1, NULL, NULL, 0.00, 'exemplary', NULL),
(20, 'NhatUser', '$2y$10$tpKX/HIJC2r3DVEw8L.LS.qBiG9ZfapPyTYeUOcqqAinQDr3MzFIG', 'nhatuser@example.com', 'Trần Văn Nhật', 'Hà Nội', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(21, 'HieuUser', '$2y$10$UZYwMiBKVpaVbYnljeXbCevy3LcjbFI4bQypubHDFohQ2hQqSetXS', 'hieuuser@example.com', 'Trần Văn Hiếu', 'Hải Phòng', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(22, 'DucUser', '$2y$10$jyDcg/5ZHlPpXEbhVRdJZO50uIK8mINelmtarptBZn7AITSpKG7UK', 'ducuser@example.com', 'Trần Văn Đức', 'Đà Nẵng', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(23, 'LinhUser', '$2y$10$4nmy7D2DqU7jzo2f2quk0.fwG7gITiIlRV4/buyHx9NTao4LIoSL2', 'linhuser@example.com', 'Trần Văn Linh', 'TP Hồ Chí Minh', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(24, 'TrangUser', '$2y$10$NIK6GwVJpHLQ9VIggm5qfezAob3jhjFUrCr03dKbkkGrCzQj2GMD.', 'tranguser@example.com', 'Trần Văn Trang', 'Cần Thơ', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(25, 'MinhUser', '$2y$10$NTMRprdQU/zGylJ4BQjL4.IrwXu3lDrUrI1eV82w2bqzs8wze0i.6', 'minhuser@example.com', 'Trần Văn Minh', 'Nha Trang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(26, 'HoangUser', '$2y$10$kP.zSWQTeYo0uddGLwZDfO9GLddnsHkDRQpbtui5KsPXRtdAmUfry', 'hoanguser@example.com', 'Trần Văn Hoàng', 'Quảng Ninh', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(27, 'QuangUser', '$2y$10$AIOei70R5qsHFQvdvs30K.skwqyQ1wcFxhpo9iSgDTdBKLveRDta6', 'quanguser@example.com', 'Trần Văn Quang', 'Vũng Tàu', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(28, 'AnhUser', '$2y$10$r7JU4RT6ERTvae9Nx/0HkOSoHk72oxIh7dhgybia0DLHPsAz0O/.S', 'anhuser@example.com', 'Trần Văn Anh', 'Bình Dương', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(29, 'ThaoUser', '$2y$10$Yx64TI5LIGaH3RCVG6057u1.R9.ndcmPFBcVhhndH0IIJYh09sAYi', 'thaouser@example.com', 'Trần Văn Thảo', 'Đồng Nai', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(30, 'PhuongUser', '$2y$10$3QJjTXhLTsVWeRB/2ZoMU./FBQc4LkIPGNNH0/oW2ou.GoduqeXHu', 'phuonguser@example.com', 'Trần Văn Phương', 'Huế', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(31, 'ThanhUser', '$2y$10$dcdottD0Muic5e4KQr.ODOrHtTWihY/LZxd.1/DU.DY2NaKg9FdC6', 'thanhuser@example.com', 'Trần Văn Thanh', 'Quảng Bình', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(32, 'VanUser', '$2y$10$6ircTPlWk1WytuICeZYjX.68FCEKNqr05D8IIKyueoLQ64ObYcll2', 'vanuser@example.com', 'Trần Văn Vân', 'Hội An', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(33, 'MaiUser', '$2y$10$sFolaWIexPEkICZzz9houus1l0VVFs.n0BNCkyjyy.kNmJP79Rifi', 'maiuser@example.com', 'Trần Văn Mai', 'Lào Cai', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(34, 'HanhUser', '$2y$10$02wyGs3fydoV4c7Ku1g/I.WZKdGRCDnXdMLInqw2DLtaAFAeGJnfy', 'hanhuser@example.com', 'Trần Văn Hạnh', 'Hà Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(35, 'NamUser', '$2y$10$sQrGKaHeXBc7/Vu7nfesoei1RUvaWzuovTOWSkDoldYmE6RRdU3wu', 'namuser@example.com', 'Trần Văn Nam', 'Lâm Đồng', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(36, 'YenUser', '$2y$10$xP64IFnyjqVYogI0KOxx1.uxA0SxHn0afO/ZMz2X8fv1VgIB2bXam', 'yenuser@example.com', 'Trần Văn Yến', 'Bắc Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(37, 'TaiUser', '$2y$10$OVtpKjAmif.DeNmCx0DWU.e4MUCDg0FCVc.XvCSdLR4UVf6fB1Ewa', 'taiuser@example.com', 'Trần Văn Tài', 'Phú Yên', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(38, 'VietUser', '$2y$10$21dSlCCzuujwQaNLhvmIIO4esWm4MEtGZnxAfFvV5e94gISRek0fW', 'vietuser@example.com', 'Trần Văn Việt', 'Thái Nguyên', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(39, 'ToanUser', '$2y$10$AV40zK5kWlece7kEbjg3Mu5nIjGKVKbsTQnv6uaA6i6L2n/LdaJwO', 'toanuser@example.com', 'Trần Văn Toàn', 'Bình Thuận', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(40, 'KhanhUser', '$2y$10$OF.7PULYnUALfo3ZVwPjgO3KAsU.KU2nTCc3w82XOUuJs/XSj3viW', 'khanhuser@example.com', 'Trần Văn Khánh', 'Quảng Ngãi', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(41, 'SonUser', '$2y$10$Dk3aebEFCa7yoo55qMbAxuoRg3F0ZT4l9kXv/GGV3t8bq63vGARxi', 'sonuser@example.com', 'Trần Văn Sơn', 'Gia Lai', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(42, 'MyUser', '$2y$10$Idut.v6H2HJgUffMHqfOAOPv78P18G4HT05UcoJYsJyxmrCvOA/HK', 'myuser@example.com', 'Trần Văn Mỹ', 'Hà Tĩnh', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(43, 'HangUser', '$2y$10$4nD8Myz/F2zCt2vhH1Q/AOi0OklLfQvtAT0pmtBiWYTtugtqzXCJK', 'hanguser@example.com', 'Trần Văn Hằng', 'Vĩnh Long', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(44, 'LyUser', '$2y$10$nTwCTAZ0qD/fKhhjEQGDSeYRL4JMr/NnCErKTqW5ZcSI7IYeAQCb.', 'lyuser@example.com', 'Trần Văn Lý', 'Nam Định', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(45, 'NgaUser', '$2y$10$6heT1jv/hpJhUTQHQg9JOes6qqooKayRbbGXr3PYlu1gPJJIGmsrq', 'ngauser@example.com', 'Trần Văn Nga', 'Cao Bằng', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(46, 'DuyUser', '$2y$10$fiSn3lnfJnICq59ErwQix.00TmMBaSy2Au/.ZBpcM1mX.Uk/1zlZW', 'duyuser@example.com', 'Trần Văn Duy', 'Tuyên Quang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(47, 'HuyenUser', '$2y$10$G6TwqkWBs8qZNTOnU5L.eOsZ1y9nMJ0pQYZHHqJwXu1NkpflEqrTu', 'huyenuser@example.com', 'Trần Văn Huyền', 'Ninh Thuận', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(48, 'QuynhUser', '$2y$10$1xERdNS..60gX4zFxUioOuqtvr5.f3r/2WbEB65bDTZuIYfyTMIZ2', 'quynhuser@example.com', 'Trần Văn Quỳnh', 'Kon Tum', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(49, 'PhucUser', '$2y$10$d7PTjb9ifyFnGJUPsP5UhOvqy.G.7uZg0SfOW2KdyBfSg0NdRWrqG', 'phucuser@example.com', 'Trần Văn Phúc', 'Hà Nam', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(50, 'TrungUser', '$2y$10$VFr7XolknWGunh9UmuHErecNZI3ACASeP1YwDRHuz9tM678W76/cS', 'trunguser@example.com', 'Trần Văn Trung', 'Hòa Bình', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(51, 'PhatUser', '$2y$10$Tz4OTmMawGoxJ5RCfl4Ml.kqJuEotu/9brBSMhK5wNM/.BhrM/zBC', 'phatuser@example.com', 'Trần Văn Phát', 'Bến Tre', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(52, 'NhuUser', '$2y$10$fED00nQW4rObcewMB6oIiuuQhL8abiOqN.Wk012mmdz51zkr1XZna', 'nhuuser@example.com', 'Trần Văn Như', 'Sóc Trăng', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(53, 'LaiUser', '$2y$10$FnSlm4qkaHYh7vYTZrz7KOzrsjqPMETMpDHBCUR3MQ/Dv15Q1TMFC', 'laiuser@example.com', 'Trần Văn Lại', 'Hậu Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(54, 'TienUser', '$2y$10$uGFEu1QxRN6NEJ8YqsfmBOdHl1k7c0AqlaRg183PRhJaWtqtp94cy', 'tienuser@example.com', 'Trần Văn Tiến', 'Kiên Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(55, 'BinhUser', '$2y$10$fcG44ka5ktPvagJY/zUW9OkRRtnPvZ7s8Hltny4XQtggnsVo0E51m', 'binhuser@example.com', 'Trần Văn Bình', 'Bạc Liêu', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(56, 'HaiUser', '$2y$10$7mcyNKb/rFPIhwsy4cSRPOPMft3x/0fV754AI4LsIvfn4fZT7Pcom', 'haiuser@example.com', 'Trần Văn Hải', 'An Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(57, 'ThinhUser', '$2y$10$82GbUItLMvrEInwnN4IFGuiTwT4we2B78NpFwtgmdxzWNZhVglH0S', 'thinhuser@example.com', 'Trần Văn Thịnh', 'Tiền Giang', 0, NULL, NULL, 0.00, 'exemplary', NULL),
(58, 'KietUser', '$2y$10$fvfinrnfN2XplvbJzNOjzedzeY00MX97dqhIjlOgQ5ZoXBnvhj5v6', 'kietuser@example.com', 'Trần Văn Kiệt', 'Vĩnh Phúc', 0, NULL, NULL, 0.00, 'exemplary', NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admincode`
--
ALTER TABLE `admincode`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `forumcomment`
--
ALTER TABLE `forumcomment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_forumcomment_user` (`user_id`),
  ADD KEY `fk_forumcomment_post` (`post_id`);

--
-- Chỉ mục cho bảng `forumdetail`
--
ALTER TABLE `forumdetail`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `locationcomment`
--
ALTER TABLE `locationcomment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_locationcomment_users` (`userid`),
  ADD KEY `fk_locationcomment_locationdetail` (`idlocation`);

--
-- Chỉ mục cho bảng `locationdetail`
--
ALTER TABLE `locationdetail`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `locationdetail_unique` (`location`);

--
-- Chỉ mục cho bảng `location_ratings`
--
ALTER TABLE `location_ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_rating` (`user_id`,`location_id`),
  ADD KEY `fk_locationratings_locationdetail` (`location_id`);

--
-- Chỉ mục cho bảng `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_loginattempt_users` (`user_id`);

--
-- Chỉ mục cho bảng `postcomment`
--
ALTER TABLE `postcomment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_postcomment_postdetail` (`idpost`),
  ADD KEY `fk_postcomment_users` (`userid`);

--
-- Chỉ mục cho bảng `postdetail`
--
ALTER TABLE `postdetail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_location` (`location`);

--
-- Chỉ mục cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_post_likes_user` (`user_id`),
  ADD KEY `fk_post_likes_post` (`post_id`);

--
-- Chỉ mục cho bảng `post_ratings`
--
ALTER TABLE `post_ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`post_id`),
  ADD KEY `fk_postratings_postdetail` (`post_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admincode`
--
ALTER TABLE `admincode`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `forumcomment`
--
ALTER TABLE `forumcomment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT cho bảng `forumdetail`
--
ALTER TABLE `forumdetail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `locationcomment`
--
ALTER TABLE `locationcomment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `locationdetail`
--
ALTER TABLE `locationdetail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT cho bảng `location_ratings`
--
ALTER TABLE `location_ratings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT cho bảng `postcomment`
--
ALTER TABLE `postcomment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `postdetail`
--
ALTER TABLE `postdetail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT cho bảng `post_ratings`
--
ALTER TABLE `post_ratings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `forumcomment`
--
ALTER TABLE `forumcomment`
  ADD CONSTRAINT `fk_forumcomment_post` FOREIGN KEY (`post_id`) REFERENCES `forumdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_forumcomment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `locationcomment`
--
ALTER TABLE `locationcomment`
  ADD CONSTRAINT `fk_locationcomment_locationdetail` FOREIGN KEY (`idlocation`) REFERENCES `locationdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_locationcomment_users` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `location_ratings`
--
ALTER TABLE `location_ratings`
  ADD CONSTRAINT `fk_locationratings_locationdetail` FOREIGN KEY (`location_id`) REFERENCES `locationdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_locationratings_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `postdetail`
--
ALTER TABLE `postdetail`
  ADD CONSTRAINT `fk_location` FOREIGN KEY (`location`) REFERENCES `locationdetail` (`location`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
