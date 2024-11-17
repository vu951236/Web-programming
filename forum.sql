-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 17, 2024 lúc 09:22 AM
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
(1, 'An Giang', 'Tỉnh An Giang nổi tiếng với chợ nổi Long Xuyên và vùng Bảy Núi linh thiêng.', 'database/locations/AnGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'angiang', 8.20, 'dongbang'),
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
(15, 'Đà Nẵng', 'Đà Nẵng là thành phố hiện đại, có nhiều bãi biển và cầu Rồng nổi tiếng.', 'database/locations/DaNang.jpg', 4.17, 12, '2024-10-30 01:00:12', 'danang', 19.92, 'bien'),
(16, 'Đắk Lắk', 'Đắk Lắk là trung tâm cà phê lớn và văn hóa Tây Nguyên.', 'database/locations/DakLak.jpg', 0.00, 0, '2024-10-30 01:00:12', 'daklak', 0.00, 'nui'),
(17, 'Đắk Nông', 'Nổi tiếng với các thác nước và cảnh quan thiên nhiên hùng vĩ.', 'database/locations/DakNong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'daknong', 0.00, 'nui'),
(18, 'Điện Biên', 'Điện Biên gắn liền với chiến thắng Điện Biên Phủ lịch sử.', 'database/locations/DienBien.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dienbien', 4.20, 'nui'),
(19, 'Đồng Nai', 'Đồng Nai có nền công nghiệp phát triển và khu bảo tồn thiên nhiên Nam Cát Tiên.', 'database/locations/ DongNai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dongnai', 0.00, 'dongbang'),
(20, 'Đồng Tháp', 'Nơi có vườn quốc gia Tràm Chim và nhiều cánh đồng sen.', 'database/locations/ DongThap.jpg', 0.00, 0, '2024-10-30 01:00:12', 'dongthap', 0.00, 'dongbang'),
(21, 'Gia Lai', 'Gia Lai nổi tiếng với Biển Hồ và văn hóa cồng chiêng Tây Nguyên.', 'database/locations/GiaLai.jpg', 0.00, 0, '2024-10-30 01:00:12', 'gialai', 0.00, 'nui'),
(22, 'Hà Giang', 'Hà Giang có cao nguyên đá Đồng Văn và nhiều cung đường đèo đẹp.', 'database/locations/HaGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hagiang', 6.00, 'nui'),
(23, 'Hà Nam', 'Hà Nam nổi tiếng với làng nghề và chùa Tam Chúc lớn nhất Việt Nam.', 'database/locations/HaNam.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hanam', 0.00, 'dongbang'),
(24, 'Hà Nội', 'Thủ đô của Việt Nam với nhiều di tích lịch sử và văn hóa.', 'database/locations/HaNoi.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hanoi', 0.00, 'dongbang'),
(25, 'Hà Tĩnh', 'Hà Tĩnh có bãi biển Thiên Cầm và các di tích lịch sử.', 'database/locations/HaTinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hatinh', 0.00, 'nui'),
(26, 'Hải Dương', 'Hải Dương nổi tiếng với bánh đậu xanh và các làng nghề truyền thống.', 'database/locations/HaiDuong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haiduong', 0.00, 'bien'),
(27, 'Hải Phòng', 'Hải Phòng là thành phố cảng, có bãi biển Đồ Sơn nổi tiếng.', 'database/locations/HaiPhong.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haiphong', 0.00, 'dongbang'),
(28, 'Hậu Giang', 'Hậu Giang là một tỉnh thuộc đồng bằng sông Cửu Long, phát triển nông nghiệp.', 'database/locations/HauGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'haugiang', 0.00, 'dongbang'),
(29, 'Hòa Bình', 'Hòa Bình có thủy điện Hòa Bình và văn hóa dân tộc Mường.', 'database/locations/HoaBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hoabinh', 0.00, 'nui'),
(30, 'Hưng Yên', 'Hưng Yên nổi tiếng với nhãn lồng và nhiều làng nghề truyền thống.', 'database/locations/HungYen.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hungyen', 0.00, 'dongbang'),
(31, 'Khánh Hòa', 'Khánh Hòa có vịnh Nha Trang và nhiều bãi biển đẹp.', 'database/locations/KhanhHoa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'khanhhoa', 5.00, 'bien'),
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
(51, 'Sơn La', 'Sơn La có cao nguyên Mộc Châu với nhiều đồi chè và cảnh quan đẹp.', 'database/locations/SonLa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'sonla', 6.00, 'nui'),
(52, 'Tây Ninh', 'Tây Ninh có núi Bà Đen và đạo Cao Đài.', 'database/locations/tayninh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'tayninh', 6.00, 'dongbang'),
(53, 'Thái Bình', 'Thái Bình là quê lúa, phát triển nông nghiệp và làng nghề.', 'database/locations/ThaiBinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thaibinh', 0.00, 'dongbang'),
(54, 'Thái Nguyên', 'Thái Nguyên nổi tiếng với chè Thái Nguyên và các khu công nghiệp.', 'database/locations/ThaiNguyen.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thainguyen', 0.00, 'nui'),
(55, 'Thanh Hóa', 'Thanh Hóa có bãi biển Sầm Sơn và nhiều di tích lịch sử.', 'database/locations/ThanhHoa.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thanhhoa', 0.00, 'bien'),
(56, 'Thừa Thiên Huế', 'Huế là cố đô với nhiều di sản văn hóa và lăng tẩm triều Nguyễn.', 'database/locations/ThuaThienHue.jpg', 0.00, 0, '2024-10-30 01:00:12', 'thuathienhue', 0.00, 'bien'),
(57, 'Tiền Giang', 'Tiền Giang có chợ nổi Cái Bè và các cù lao sông nước.', 'database/locations/TienGiang.jpg', 0.00, 0, '2024-10-30 01:00:12', 'tiengiang', 0.00, 'dongbang'),
(58, 'TP. Hồ Chí Minh', 'Trung tâm kinh tế lớn nhất Việt Nam với nhiều hoạt động sôi động.', 'database/locations/TPHoChiMinh.jpg', 0.00, 0, '2024-10-30 01:00:12', 'hochiminh', 11.73, 'bien'),
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
(43, 16, '2024-11-17 02:05:38'),
(44, 16, '2024-11-17 02:06:02'),
(45, 17, '2024-11-17 02:07:58');

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
(83, 'Kinh nghiệm du lịch Hội An', '2024-11-17 02:07:01', 'database/posts/post_67394fc55c08a1.59362254.jpg', 'fAf', 3.50, 2, 'dienbien', 2, 16, 'jjef', 'approve', 'nghiduong');

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

--
-- Đang đổ dữ liệu cho bảng `post_ratings`
--

INSERT INTO `post_ratings` (`id`, `user_id`, `post_id`, `rating`) VALUES
(18, 16, 83, 4),
(19, 17, 83, 3);

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
(16, 'vu951236', '$2y$10$Vkvbr4r8iZdzKmSBeGfxIOYvvWUxhnAKt8GhdgH0O5icU4dYn9Pz.', 'hoangvuvo907@gmail.com', 'Võ Hoàng Vũ', '440 Thống Nhất', 1, NULL, NULL, 4.20, 'exemplary', NULL),
(17, 'vu951237', '$2y$10$I4WOKCw0sGXCV7MTYr4FjOQBNo1v7WfonS64Hhf08Jg1Mkj7FxAjO', 'hoangvuvo999@gmail.com', 'Võ Hoàng Vũ', '440 Thống Nhất', 0, NULL, NULL, 0.00, 'exemplary', NULL);

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
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `postcomment`
--
ALTER TABLE `postcomment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `postdetail`
--
ALTER TABLE `postdetail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

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
-- Các ràng buộc cho bảng `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD CONSTRAINT `fk_loginattempt_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `postcomment`
--
ALTER TABLE `postcomment`
  ADD CONSTRAINT `fk_postcomment_postdetail` FOREIGN KEY (`idpost`) REFERENCES `postdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_postcomment_users` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `fk_post_likes_post` FOREIGN KEY (`post_id`) REFERENCES `forumdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_post_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_ratings`
--
ALTER TABLE `post_ratings`
  ADD CONSTRAINT `fk_postratings_postdetail` FOREIGN KEY (`post_id`) REFERENCES `postdetail` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_postratings_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
