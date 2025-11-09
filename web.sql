-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2025 at 11:02 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web`
--

-- --------------------------------------------------------

--
-- Table structure for table `chitietdonhang`
--

CREATE TABLE `chitietdonhang` (
  `MaDH` int(11) NOT NULL,
  `MaND` int(11) NOT NULL,
  `TenNguoiNhan` varchar(255) NOT NULL,
  `SDTNguoiNhan` varchar(20) NOT NULL,
  `NgayDatHang` datetime DEFAULT current_timestamp(),
  `TongTien` decimal(10,0) NOT NULL,
  `DiaChiGiaoHang` varchar(255) NOT NULL,
  `PhuongThucThanhToan` varchar(50) DEFAULT 'COD',
  `GhiChu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chitietdonhang`
--

INSERT INTO `chitietdonhang` (`MaDH`, `MaND`, `TenNguoiNhan`, `SDTNguoiNhan`, `NgayDatHang`, `TongTien`, `DiaChiGiaoHang`, `PhuongThucThanhToan`, `GhiChu`) VALUES
(1, 2, 'Nguyễn Thị Mỹ Tâm', '0987654321', '2025-11-03 13:45:10', 48000, 'Số 10, Đường Phan Văn Trị, TP.HCM', 'COD', ''),
(15, 2, 'Nguyễn Thị Mỹ Tâm', '0987654321', '2025-11-04 14:21:03', 180000, 'Số 10, Đường Phan Văn Trị, TP.HCM', 'COD', ''),
(16, 2, 'Nguyễn Thị Mỹ Tâm', '0987654321', '2025-11-04 21:18:27', 37000, 'Số 10, Đường Phan Văn Trị, TP.HCM', 'COD', ''),
(17, 2, 'Nguyễn Thị Mỹ Tâm', '0987654321', '2025-11-04 22:01:15', 42000, 'Số 10, Đường Phan Văn Trị, TP.HCM', 'ChuyenKhoan', '');

-- --------------------------------------------------------

--
-- Table structure for table `chitietgiohang`
--

CREATE TABLE `chitietgiohang` (
  `MaCTGH` int(11) NOT NULL,
  `MaGH` int(11) NOT NULL,
  `MaSP` varchar(30) NOT NULL,
  `SoLuong` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chitietgiohang`
--

INSERT INTO `chitietgiohang` (`MaCTGH`, `MaGH`, `MaSP`, `SoLuong`) VALUES
(1, 1, 'BCC48', 2),
(21, 1, 'TL170', 1),
(23, 1, 'MXH700', 1);

-- --------------------------------------------------------

--
-- Table structure for table `chitietphieunhap`
--

CREATE TABLE `chitietphieunhap` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MaCTPN` varchar(10) DEFAULT NULL,
  `MaPN` varchar(10) NOT NULL,
  `MaSP` varchar(20) NOT NULL,
  `SoLuong` int(11) NOT NULL,
  `GiaNhap` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_MaPN` (`MaPN`),
  KEY `FK_MaSP` (`MaSP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `danhmuc`
--

CREATE TABLE `danhmuc` (
  `MaDM` int(11) NOT NULL,
  `TenDanhMuc` varchar(100) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `danhmuc`
--

INSERT INTO `danhmuc` (`MaDM`, `TenDanhMuc`, `MoTa`) VALUES
(1, 'Thiết Bị Theo Dõi Sức Khỏe', 'Các thiết bị điện tử đo lường và theo dõi các chỉ số sức khỏe cơ bản.'),
(2, 'Dụng Cụ & Thiết Bị Massage', 'Các loại máy và công cụ giúp thư giãn cơ bắp, giảm căng thẳng, trị liệu bằng xung điện và nhiệt.'),
(3, 'Sản Phẩm Hỗ Trợ & Phục Hồi', 'Các dụng cụ hỗ trợ vận động, phục hồi chức năng, định hình tư thế, và các sản phẩm trị liệu nhiệt.'),
(4, 'Vật Tư Tiêu Hao & Chăm Sóc Cơ Bản', 'Các vật tư y tế sơ cấp cứu, dụng cụ cá nhân, và các sản phẩm hỗ trợ giấc ngủ và làm đẹp.');

-- --------------------------------------------------------

--
-- Table structure for table `donhang`
--

CREATE TABLE `donhang` (
  `MaCTDH` int(11) NOT NULL,
  `MaDH` int(11) NOT NULL,
  `MaSP` varchar(30) NOT NULL,
  `SoLuong` int(11) NOT NULL,
  `GiaBan` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donhang`
--

INSERT INTO `donhang` (`MaCTDH`, `MaDH`, `MaSP`, `SoLuong`, `GiaBan`) VALUES
(1, 1, 'BG18', 1, 18000),
(15, 15, 'MSDD150', 1, 150000),
(16, 16, 'MDTD7', 1, 7000),
(17, 17, 'CMS12', 1, 12000);

-- --------------------------------------------------------

--
-- Table structure for table `giohang`
--

CREATE TABLE `giohang` (
  `MaGH` int(11) NOT NULL,
  `MaND` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `giohang`
--

INSERT INTO `giohang` (`MaGH`, `MaND`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `khuyenmai`
--

CREATE TABLE `khuyenmai` (
  `MaKM` int(11) NOT NULL,
  `TenKM` varchar(255) NOT NULL,
  `MoTa` text DEFAULT NULL,
  `NgayBatDau` date NOT NULL,
  `NgayKetThuc` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `khuyenmai`
--

INSERT INTO `khuyenmai` (`MaKM`, `TenKM`, `MoTa`, `NgayBatDau`, `NgayKetThuc`) VALUES
(1, 'Ưu Đãi Giáng Sinh An Lành', 'Giảm giá 20% cho tất cả các sản phẩm. Áp dụng cho đơn hàng có giá trị trên 500.000 VNĐ.', '2025-12-15', '2025-12-25'),
(2, 'Khai Xuân Rước Lộc 2026', 'Tặng kèm bộ sản phẩm chăm sóc sức khỏe trị giá 150.000 VNĐ cho đơn hàng từ 800.000 VND', '2025-12-30', '2026-01-05');

-- --------------------------------------------------------

--
-- Table structure for table `lienhe`
--

CREATE TABLE `lienhe` (
  `MaLH` int(11) NOT NULL,
  `HoTen` varchar(100) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `SoDienThoai` varchar(15) DEFAULT NULL,
  `TieuDe` varchar(255) NOT NULL,
  `NoiDung` text NOT NULL,
  `PhanHoi` text DEFAULT NULL,
  `NgayPhanHoi` datetime DEFAULT NULL,
  `MaNguoiTraLoi` int(11) DEFAULT NULL,
  `NgayGui` datetime DEFAULT current_timestamp(),
  `TrangThaiPhanHoi` enum('ChuaDoc','DaDoc','DaPhanHoi') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lienhe`
--

INSERT INTO `lienhe` (`MaLH`, `HoTen`, `Email`, `SoDienThoai`, `TieuDe`, `NoiDung`, `PhanHoi`, `NgayPhanHoi`, `MaNguoiTraLoi`, `NgayGui`, `TrangThaiPhanHoi`) VALUES
(1, 'Trần Thị Khách Hàng', 'khach@gmail.com', NULL, 'Hỏi về chính sách giao hàng', 'Sản phẩm DHA140 có giao hỏa tốc không?', 'Chào chị, sản phẩm DHA140 có thể giao hỏa tốc. Vui lòng chọn tùy chọn này khi thanh toán.', '2025-10-28 17:02:30', 1, '2025-10-28 17:02:30', 'DaPhanHoi'),
(2, 'Lê Văn Thắc Mắc', 'levan@email.com', NULL, 'Phản hồi về chất lượng sản phẩm', 'Sản phẩm TL170 dùng tốt, tôi rất hài lòng!', NULL, NULL, NULL, '2025-10-28 17:02:30', 'ChuaDoc');

-- --------------------------------------------------------

--
-- Table structure for table `nguoidung`
--

CREATE TABLE `nguoidung` (
  `MaND` int(11) NOT NULL,
  `TenDangNhap` varchar(50) NOT NULL,
  `MatKhau` varchar(255) NOT NULL,
  `HoTen` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `SoDienThoai` varchar(15) DEFAULT NULL,
  `DiaChi` varchar(255) DEFAULT NULL,
  `LoaiNguoiDung` enum('KhachHang','QuanTriVien') NOT NULL,
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nguoidung`
--

INSERT INTO `nguoidung` (`MaND`, `TenDangNhap`, `MatKhau`, `HoTen`, `Email`, `SoDienThoai`, `DiaChi`, `LoaiNguoiDung`, `NgayTao`) VALUES
(1, 'admin', '123456', 'Hoàng Minh Ngọc', 'admin@webbanhang.com', '0901234567', 'Văn phòng chính', 'QuanTriVien', '2025-10-28 17:02:30'),
(2, 'nguyentam', '123456', 'Nguyễn Thị Mỹ Tâm', 'tam@gmail.com', '0987654321', 'Số 10, Đường Phan Văn Trị, TP.HCM', 'KhachHang', '2025-10-28 17:02:30'),
(3, 'hongnhung', '123456', 'Đào Hồng Nhung', 'nhung@gmail.com', '0378609372', '141 Tam Trinh, Hoàng Mai, Hà Nội', 'KhachHang', '2025-11-04 15:55:26');

-- --------------------------------------------------------

--
-- Table structure for table `nhacungcap`
--

CREATE TABLE `nhacungcap` (
  `MaNCC` int(11) NOT NULL,
  `TenNCC` varchar(100) NOT NULL,
  `DiaChi` varchar(100) DEFAULT NULL,
  `SDT` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `XuatXu` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nhacungcap`
--

INSERT INTO `nhacungcap` (`MaNCC`, `TenNCC`, `DiaChi`, `SDT`, `Email`, `XuatXu`) VALUES
(1, 'OEM', 'Khu Vực Sản Xuất, TPHCM', '0901000111', 'sales@oem.com', 'Trung Quốc'),
(2, 'HDEVICE', 'Văn Phòng Đại Diện, Hà Nội', '0981234000', 'support@hdevice.vn', 'Việt Nam'),
(3, 'Totita', 'Kho Phân Phối Tổng Miền Bắc', '0900112233', 'info@totita.com', 'Hàn Quốc'),
(4, 'Đại Việt', 'Trung Tâm Phân Phối Miền Nam', '0888999000', 'contact@daivietcorp.vn', 'Việt Nam'),
(5, 'TriggerPoint', 'Đại lý Ủy quyền, Quận 3, TPHCM', '0283999111', 'order@triggerpoint.com', 'Anh'),
(6, 'Lanmak', 'Công ty Phân Phối Toàn Quốc, HN', '0243888777', 'info@lanmak.vn', 'Việt Nam'),
(7, 'PILATES', 'Studio & Showroom Chính', '0912345678', 'contact@pilates.vn', 'Mỹ'),
(8, 'Tâm Phúc', 'Nhà Phân Phối Độc Quyền', '0976543210', 'sales@tamphuc.com', 'Việt Nam'),
(9, 'Dyna', 'Trung Tâm Dịch Vụ Khách Hàng, Biên Hòa', '0933445566', 'support@dyna.vn', 'Trung Quốc'),
(10, 'KACOCON', 'Đơn vị Nhập khẩu chính', '0945678901', 'info@kacocon.com', 'Nhật Bản'),
(11, 'Merach', 'Chi nhánh Quận 1, TPHCM', '0967890123', 'contact@merach.vn', 'Mỹ'),
(12, 'SOKANY', 'Văn phòng Kinh doanh, Hà Nội', '0987654321', 'sales@sokany.vn', 'Nhật Bản'),
(13, 'SHIBI', 'Cửa hàng Bán lẻ & Bảo hành', '0911223344', 'info@shibi.vn', 'Đức'),
(14, 'OMRON', 'Trung tâm Bảo hành Chính hãng', '0243210987', 'support@omron.vn', 'Trung Quốc'),
(15, 'Kinoki', 'Địa chỉ chung', '0900000000', 'chung@nhacungcap.com', 'Nhật Bản'),
(16, 'Sunhouse', 'Tập đoàn Sunhouse, Khu Công nghiệp', '0919293847', 'contact@sunhouse.com.vn', 'Việt Nam'),
(17, 'THAFA', 'Đại lý Cấp 1, Miền Tây', '0909876543', 'info@thafa.vn', 'Việt Nam'),
(18, 'Kachi', 'Kho Vận Trung Chuyển, Đà Nẵng', '0987123456', 'sales@kachi.vn', 'Nhật'),
(19, 'Nkio', 'Phòng Nghiên cứu & Phát triển', '0911998877', 'contact@nkio.com', 'Việt Nam'),
(20, 'Thiên An', 'Trung tâm Chăm sóc Sức khỏe', '0932109876', 'info@thienan.vn', 'Việt Nam'),
(21, 'BUMAS', 'Văn phòng Sáng tạo', '0943210987', 'sales@bumas.com', 'Hàn Quốc'),
(22, 'ZDEER', 'Cửa hàng Bán lẻ', '0998877665', 'contact@zdeer.vn', 'Việt Nam'),
(23, 'Harvia', 'Đại diện Chính thức tại Việt Nam', '0900999888', 'support@harvia.vn', 'Phần Lan'),
(24, 'Beurer', 'Nhà phân phối miền Nam, Q.1', '0888000111', 'support@beurer.vn', 'Đức'),
(25, 'Carefit', 'Kho miền Nam', '0283999888', 'sales@carefit.vn', 'Hàn Quốc'),
(26, 'Greetmed', 'Địa chỉ chung', '0900000000', 'chung@nhacungcap.com', 'Trung Quốc'),
(27, 'Thái Công', '123 Khu Công Nghiệp Bình Dương', '0901234567', 'support@thaicong.vn', 'Việt Nam'),
(28, 'Hoàng Thịnh An', 'Số 100, Nguyễn Trãi, Hà Nội (Trụ sở chính)', '0981234567', 'contact@hoangthinhan.com', 'Việt Nam');

-- --------------------------------------------------------

--
-- Table structure for table `phieunhap`
--

CREATE TABLE `phieunhap` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MaPN` varchar(10) DEFAULT NULL,
  `MaNCC` int(11) NOT NULL,
  `NgayLap` datetime NOT NULL,
  `TongTien` decimal(18,2) DEFAULT NULL,
  `MaNguoiLap` int(11) NOT NULL,
  `GhiChu` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `MaPN` (`MaPN`),
  KEY `MaNCC` (`MaNCC`),
  KEY `MaNguoiLap` (`MaNguoiLap`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sanpham`
--

CREATE TABLE `sanpham` (
  `MaSP` varchar(30) NOT NULL,
  `TenSP` varchar(200) NOT NULL,
  `Gia` decimal(10,0) NOT NULL,
  `HinhAnh` varchar(255) NOT NULL,
  `ThuongHieu` varchar(100) DEFAULT NULL,
  `XuatXu` varchar(100) DEFAULT NULL,
  `DonVi` varchar(50) DEFAULT NULL,
  `MoTa` text DEFAULT NULL,
  `HuongDanSuDung` text DEFAULT NULL,
  `SoLuongTon` int(11) NOT NULL DEFAULT 0,
  `MaDM` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sanpham`
--

INSERT INTO `sanpham` (`MaSP`, `TenSP`, `Gia`, `HinhAnh`, `ThuongHieu`, `XuatXu`, `DonVi`, `MoTa`, `HuongDanSuDung`, `SoLuongTon`, `MaDM`) VALUES
('BCC48', 'Bút châm cứu trị liệu xung điện DF618', 48000, 'BCC48.jpg', 'OEM', 'Trung Quốc', 'Chiếc', 'Châm cứu trực tiếp giúp loại bỏ ê ẩm, nhức mỏi, đau cơ xương khớp. Phục hồi sức khỏe, tăng cường tuần hòan máu.', 'Bắt đầu sử dụng ở mức cường độ thấp nhất (1-3). Không dùng quá 15 phút/lần.', 90, 2),
('BCG50', 'Bộ 7 món cạo gió', 50000, 'BCG50.jpg', 'HDEVICE', 'Việt Nam', 'Bộ', 'Bộ ngọc 7 món chăm sóc da là bộ sản phẩm chuyên dụng đa năng dùng trong các spa đông y, gội đầu dưỡng sinh.', 'Vệ sinh sạch sẽ trước và sau khi sử dụng. Dùng kèm dầu massage để tăng hiệu quả.', 150, 4),
('BG18', 'Băng cá nhân hàn quốc 100 miếng', 18000, 'BG18.jpg', 'Totita', 'Hàn Quốc', 'Hộp', 'Đảm bảo dính chắc, thông thoáng, độ co giãn cao bảo vệ các vết thương nhỏ, vết xước...', 'Làm sạch vết thương, lau khô. Dán băng sao cho phần gạc che kín vết thương. Thay băng hàng ngày.', 500, 4),
('BGH39', 'Bộ giác hơi 12 ống hút chân không', 39000, 'BGH39.jpeg', 'Đại Việt', 'Việt Nam', 'Bộ', 'Bộ giác hơi không dùng lửa. Giúp điều trị các chứng đau lưng; đau đầu; cảm cúm; nhức mỏi.', 'Gắn ống hút chân không và bơm 2-3 lần. Tránh giác ở vị trí tim và bụng dưới.', 120, 3),
('BMS20', 'Bóng massage tay', 20000, 'BMS20.jpg', 'TriggerPoint', 'Anh', 'Quả', 'Bóng massage tay. Bóng massage giúp thúc đẩy tuần hoàn máu. Tăng cường khả năng thẩm thấu da, lưu thông máu.', 'Cầm bóng và lăn trên lòng bàn tay hoặc ấn nhẹ lên các huyệt đạo. Dùng 5-10 phút mỗi ngày.', 250, 2),
('BNC28', 'Cây đấm bóp massage ngải cứu 26cm', 28000, 'BNC28.jpg', 'Lanmak', 'Việt Nam', 'Chiếc', 'Đấm bóp mát xa toàn thân, cho cảm giác thư thái, xua tan mệt mỏi. Hỗ trợ điều trị nhức mỏi cơ và xương khớp.', 'Cầm tay cầm và đấm nhẹ lên các vùng cơ bị mỏi (vai, lưng, chân). Tránh đấm trực tiếp vào xương.', 180, 2),
('BYOGA15', 'Bóng tập Yoga 25cm', 15000, 'BYOGA15.jpg', 'PILATES', 'Mỹ', 'Quả', 'Quả bóng mini là một công cụ tập thể dục tuyệt vời để cải thiện sự cân bằng, linh hoạt, tư thế, sức mạnh cốt lõi và sức khỏe tổng thể.', 'Thổi phồng vừa phải. Dùng cho các bài tập giữ thăng bằng hoặc hỗ trợ cơ bụng.', 75, 3),
('CMS12', 'Cây Massage với 3 chức năng', 12000, 'CMS12.jpg', 'Tâm Phúc', 'Việt Nam', 'Chiếc', 'Cây Massage với 3 chức năng. Thiết kế đơn giản, dễ sử dụng. Phù hợp nhiều đối tượng: học sinh, sinh viên, giới văn phòng.', 'Sử dụng các đầu massage khác nhau cho đầu, lưng và chân.', 300, 2),
('DCS55', 'Đai định hình cột sống', 55000, 'DCS55.jpg', 'Dyna', 'Trung Quốc', 'Chiếc', 'Đai định hình cột sống sẽ kéo lại vai, cổ và đầu thẳng khi sửa cột sống, sẽ cải thiện đáng kể của bạn thói quen xấu và giúp cột sống của bạn sức khỏe.', 'Đeo đai khi ngồi làm việc hoặc học tập. Không đeo quá 4 giờ liên tục.', 85, 3),
('DHA140', 'Máy đo huyết áp nhịp tim BP-S09', 140000, 'DHA140.jpg', 'KACOCON', 'Nhật Bản', 'Chiếc', 'Máy Đo Huyết ÁP Nhịp Tim BP-S09 đo chỉ số huyết áp và nhịp tim của cơ thể, đọc kết quả, theo dõi huyết áp, nhịp tim hàng ngày.', 'Đeo vòng bít vào bắp tay trần. Ngồi yên 5 phút trước khi đo. Nhấn nút START/STOP.', 50, 1),
('DN75', 'Dây Nhảy Đàn Hồi Có Màn Hình Đếm Số Tập Thể Dục', 75000, 'DN75.jpg', 'Merach', 'Mỹ', 'Chiếc', 'Đốt cháy mỡ thừa, hỗ trợ giảm cân, dáng đẹp săn chắc. Tăng cường mật độ xương, cải thiện sức khỏe tim mạch.', 'Kiểm tra chiều dài dây phù hợp với chiều cao. Tập luyện trên bề mặt phẳng, tránh trơn trượt.', 110, 3),
('GMS175', 'Gối massage SOKANY SKN-8028', 175000, 'GMS175.jpg', 'SOKANY', 'Nhật Bản', 'Chiếc', 'Gối massage hồng ngoại, gọn nhẹ rất dễ sử dụng. Kết cấu gồm 8 quả cầu massage có tác dụng xoa bóp vào các cơ và huyệt.', 'Cắm điện và bật nguồn. Đặt gối ở vùng cần massage (cổ, vai, lưng). Không sử dụng khi đang ngủ.', 65, 2),
('GNN1200', 'Gối ngủ ngon Dreamzie', 1200, 'GNN1200.jpg', 'SHIBI', 'Đức', 'Chiếc', 'Đặc biệt thích hợp cho người đau vai, cổ, gáy, khó ngủ, đêm trằn trọc. Giúp khớp với cổ và vai gáy người sử dụng.', 'Không giặt ruột gối. Vỏ gối có thể giặt máy ở chế độ nhẹ.', 20, 4),
('MDDH550', 'Máy đo đường huyết OMRON HGM-114 (Mẫu Trung)', 550000, 'MDDH550.jpg', 'OMRON', 'Trung Quốc', 'Chiếc', 'Máy đo Omron HGM-112 là sản phẩm của công nghệ hiện đại, giúp người dùng theo dõi và kiểm soát lượng đường trong máu. Cho ra kết quả nhanh và chính xác cao.', 'Dùng que thử đúng loại. Lấy lượng máu vừa đủ. Bảo quản máy và que thử nơi khô ráo.', 40, 1),
('MDMS55', 'Miếng dán massage xung', 55000, 'MDMS55.jpg', 'OEM', 'Trung Quốc', 'Miếng', 'Miếng Dán Massage Xung Điện Máy Massage Toàn Thân 6 Chế Độ. Giảm Đau Nhức Hiệu Quả. Pin Sạc USB.', 'Sạc đầy pin trước khi dùng. Dán miếng dán vào vùng cơ mỏi, chọn chế độ và cường độ mong muốn.', 130, 2),
('MDTD7', 'Miếng dán chân giải độc Kinoki', 7000, 'MDTD7.jpg', 'Kinoki', 'Nhật Bản', 'Miếng', 'Miếng dán chân giải độc Kinoki giúp tăng cường hệ thống miễn dịch. Cải thiện lưu thông máu và cải thiện chức năng trao đổi chất. Hỗ trợ một giấc ngủ chất lượng tốt.', 'Dán vào lòng bàn chân trước khi ngủ. Gỡ bỏ vào buổi sáng.', 450, 4),
('MS1500', 'Máy sưởi gốm', 1500000, 'MS1500.jpg', 'Sunhouse', 'Việt Nam', 'Chiếc', 'Máy sưởi gốm Sunhouse là thiết bị sưởi ấm sử dụng công nghệ gốm PTC, làm nóng nhanh chóng và tỏa nhiệt đối lưu, không đốt cháy oxy, không gây khô da.', 'Đặt cách xa vật liệu dễ cháy 1m. Không che phủ máy khi đang hoạt động. Tắt khi không sử dụng.', 25, 3),
('MSC20', 'Dụng cụ massage chân 5 hàng', 20000, 'MSC20.jpg', 'THAFA', 'Việt Nam', 'Chiếc', 'Dụng cụ massage chân 5 hàng, giúp cho đôi chân yêu quý được đả thông kinh mạch, sung sướng dài lâu sau một ngày đi lại mệt mỏi.', 'Đặt dưới chân và lăn qua lại. Có thể dùng khi đang ngồi xem TV hoặc làm việc.', 210, 2),
('MSC250', 'Máy Massage Cổ 4D', 250000, 'MSC250.jpg', 'Kachi', 'Nhật', 'Chiếc', 'Máy massage cổ 4D thông minh hoạt động dựa trên nguyên lý xung điện từ trường, tạo sự thoải mái khi sử dụng.', 'Sạc đầy pin. Dùng 15 phút mỗi lần. Không dùng cho người có máy trợ tim.', 70, 2),
('MSCT305', 'Máy Massage Cầm Tay SOKANY SKN-14019 32 Chế Độ', 305000, 'MSCT305.jpg', 'SOKANY', 'Nhật Bản', 'Chiếc', 'Máy đi kèm với 6 đầu massage khác nhau, mỗi đầu có thiết kế đặc biệt phù hợp với từng khu vực cơ thể.', 'Chọn đầu massage phù hợp. Bắt đầu với cường độ thấp và tăng dần nếu cần. Không dùng quá 20 phút/lần.', 55, 2),
('MSD6', 'Cây massage đầu bạch tuộc', 6000, 'MSD6.jpg', 'Nkio', 'Việt Nam', 'Chiếc', 'Cây massage đầu giúp thư giãn xua tan căng thẳng học tập, làm việc mệt mỏi.', 'Đặt lên đầu và nhẹ nhàng di chuyển lên xuống. Dùng bất cứ khi nào cảm thấy căng thẳng.', 400, 2),
('MSDD150', 'Máy Massage Da Đầu Đầu Và Toàn Thân Silicon MSHD-001', 150000, 'MSDD150.jpg', 'Thiên An', 'Việt Nam', 'Chiếc', 'Máy massage da đầu và toàn thân MSHD-001 với thiết kế 8 đầu silicon mềm mại, hoạt động bằng điện sạc pin, giúp thư giãn.', 'Sử dụng trên da đầu khô hoặc ướt. Sạc đầy pin sau mỗi lần dùng.', 80, 2),
('MSM70', 'Dụng cụ massage mắt chườm nóng', 70000, 'MSM70.jpg', 'BUMAS', 'Hàn Quốc', 'Chiếc', 'Làm nóng bằng điện cho nhiệt độ đều và ổn định (tối đa 50 độ C). Có thể điều chỉnh 3-5 mức nhiệt độ, 3-5 mức hẹn giờ.', 'Chườm nóng khi mắt mệt mỏi. Không chườm khi đang đeo kính áp tròng.', 140, 2),
('MTVM150', 'Máy trị liêu viêm mũi', 150000, 'MTVM150.jpg', 'ZDEER', 'Việt Nam', 'Chiếc', 'Thích hợp sử dụng để sấy khô viêm mũi có viêm mũi, viêm xoang... tất cả các loại viêm mũi bệnh nhân gây ra bởi sổ mũi, nghẹt mũi hắt hơi.', 'Đọc kỹ hướng dẫn đi kèm. Vệ sinh đầu xông sau mỗi lần sử dụng.', 45, 1),
('MXH700', 'Máy xông hơi', 700000, 'MXH700.jpg', 'Harvia', 'Phần Lan', 'Chiếc', 'Máy tạo hơi thích hợp cho gia đình và spa. Có 4 tốc độ xông hơi được gợi ý sắn nhằm tiết kiệm thời gian sử dụng.', 'Đổ nước sạch vào máy. Kết hợp với tinh dầu thiên nhiên (nếu muốn). Xông 15-20 phút.', 30, 1),
('NC500', 'Beurer FB50 – máy ngâm chân massage cao cấp', 500000, 'NC500.jpg', 'Beurer', 'Đức', 'Chiếc', 'Máy ngâm chân massage cao cấp, có màn hình LED, điều chỉnh nhiệt độ từ 35°C đến 48°C. Tích hợp rung, con lăn, hồng ngoại và chức năng tạo bọt khí thư giãn.', 'Đặt máy ở nơi bằng phẳng, đổ nước (không quá mức tối đa). Cắm điện, chọn nhiệt độ (35°C–48°C). Ngâm 15–30 phút. Tắt máy, rút điện, đổ nước và lau khô sau khi dùng.', 40, 2),
('ND11000', 'Nệm Đá Nóng Lục Giác Carefit CF-M80.PEMF Tích Hợp 24 Đèn Photon', 11000000, 'ND11000.jpg', 'Carefit', 'Hàn Quốc', 'Chiếc', 'Nệm Đá Nóng Lục Giác Carefit CF-M80.PEMF Tích Hợp 24 Đèn Photon. Giúp có giấc ngủ sâu sau khi sử dụng, phục hồi, thư giãn cơ thể.', 'Đặt nệm trên bề mặt phẳng. Điều chỉnh nhiệt độ phù hợp. Uống đủ nước trước khi nằm nệm.', 15, 3),
('TC20', 'Túi chườm nóng lạnh', 20000, 'TC20.jpg', 'Greetmed', 'Trung Quốc', 'Chiếc', 'Giúp giảm đau nhức. Túi bằng nhựa; lớp lót TPU chống thấm; giữ nhiệt tốt.', 'Chườm lạnh: Cho đá vào túi. Chườm nóng: Đổ nước nóng (dưới 60°C) vào túi.', 350, 4),
('TL170', 'Đồ tựa lưng công thái học', 170000, 'TL170.jpg', 'Thái Công', 'Việt Nam', 'Chiếc', 'Đồ tựa lưng công thái học là giải pháp hoàn hảo cho dân văn phòng, tài xế... giúp nâng đỡ phần lưng dưới, giữ cột sống ở tư thế tự nhiên.', 'Gắn vào ghế văn phòng hoặc ghế lái xe. Điều chỉnh vị trí ngang thắt lưng.', 160, 3),
('TNC500', 'Thảm sưởi ấm ngải cứu đông y', 500000, 'TNC500.jpg', 'Hoàng Thịnh An', 'Việt Nam', 'Chiếc', 'Thảm ngải cứu Hoàng Thịnh An là một loại đệm sưởi kết hợp giữa công nghệ sưởi ấm và thảo dược tự nhiên (ngải cứu và 8 loại thảo dược khác).', 'Cắm điện, chọn mức nhiệt phù hợp. Nằm hoặc đặt lên vùng cần trị liệu. Uống nước ấm sau khi dùng.', 95, 3);

-- --------------------------------------------------------

--
-- Table structure for table `tinnhan`
--

CREATE TABLE `tinnhan` (
  `MaTN` int(11) NOT NULL,
  `MaTC` int(11) NOT NULL,
  `NoiDung` text NOT NULL,
  `MaNguoiGui` int(11) NOT NULL,
  `ThoiGianGui` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tinnhan`
--

INSERT INTO `tinnhan` (`MaTN`, `MaTC`, `NoiDung`, `MaNguoiGui`, `ThoiGianGui`) VALUES
(1, 1, 'hello', 2, '2025-11-05 15:35:40'),
(2, 1, 'chào bạn, bạn cần giúp gì ạ', 1, '2025-11-05 15:42:42');

-- --------------------------------------------------------

--
-- Table structure for table `trochuyen`
--

CREATE TABLE `trochuyen` (
  `MaTC` int(11) NOT NULL,
  `MaND` int(11) NOT NULL,
  `TieuDe` varchar(255) NOT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `TrangThai` enum('Open','Closed','Waiting') NOT NULL DEFAULT 'Waiting',
  `AdminRead` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trochuyen`
--

INSERT INTO `trochuyen` (`MaTC`, `MaND`, `TieuDe`, `NgayTao`, `TrangThai`, `AdminRead`) VALUES
(1, 2, 'Hỗ trợ từ Nguyễn Thị Mỹ Tâm', '2025-11-05 15:34:27', 'Open', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD PRIMARY KEY (`MaDH`),
  ADD KEY `MaND` (`MaND`);

--
-- Indexes for table `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD PRIMARY KEY (`MaCTGH`),
  ADD KEY `MaGH` (`MaGH`),
  ADD KEY `MaSP` (`MaSP`);

--
-- Indexes for table `chitietphieunhap`
-- (Indexes are already defined in CREATE TABLE)
--

--
-- Indexes for table `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`MaDM`),
  ADD UNIQUE KEY `TenDanhMuc` (`TenDanhMuc`);

--
-- Indexes for table `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`MaCTDH`),
  ADD KEY `MaDH` (`MaDH`),
  ADD KEY `MaSP` (`MaSP`);

--
-- Indexes for table `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`MaGH`),
  ADD UNIQUE KEY `MaND` (`MaND`);

--
-- Indexes for table `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD PRIMARY KEY (`MaKM`);

--
-- Indexes for table `lienhe`
--
ALTER TABLE `lienhe`
  ADD PRIMARY KEY (`MaLH`),
  ADD KEY `MaNguoiTraLoi` (`MaNguoiTraLoi`);

--
-- Indexes for table `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`MaND`),
  ADD UNIQUE KEY `TenDangNhap` (`TenDangNhap`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `nhacungcap`
--
ALTER TABLE `nhacungcap`
  ADD PRIMARY KEY (`MaNCC`),
  ADD UNIQUE KEY `TenNCC` (`TenNCC`);

--
-- Indexes for table `phieunhap`
-- (Indexes are already defined in CREATE TABLE)
--

--
-- Indexes for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`MaSP`),
  ADD KEY `MaDM` (`MaDM`);

--
-- Indexes for table `tinnhan`
--
ALTER TABLE `tinnhan`
  ADD PRIMARY KEY (`MaTN`),
  ADD KEY `MaTC` (`MaTC`),
  ADD KEY `MaNguoiGui` (`MaNguoiGui`);

--
-- Indexes for table `trochuyen`
--
ALTER TABLE `trochuyen`
  ADD PRIMARY KEY (`MaTC`),
  ADD KEY `MaND` (`MaND`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  MODIFY `MaDH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  MODIFY `MaCTGH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `MaDM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `donhang`
--
ALTER TABLE `donhang`
  MODIFY `MaCTDH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `giohang`
--
ALTER TABLE `giohang`
  MODIFY `MaGH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `khuyenmai`
--
ALTER TABLE `khuyenmai`
  MODIFY `MaKM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lienhe`
--
ALTER TABLE `lienhe`
  MODIFY `MaLH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nguoidung`
--
ALTER TABLE `nguoidung`
  MODIFY `MaND` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nhacungcap`
--
ALTER TABLE `nhacungcap`
  MODIFY `MaNCC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `phieunhap`
--
ALTER TABLE `phieunhap`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tinnhan`
--
ALTER TABLE `tinnhan`
  MODIFY `MaTN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `trochuyen`
--
ALTER TABLE `trochuyen`
  MODIFY `MaTC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`);

--
-- Constraints for table `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD CONSTRAINT `chitietgiohang_ibfk_1` FOREIGN KEY (`MaGH`) REFERENCES `giohang` (`MaGH`),
  ADD CONSTRAINT `chitietgiohang_ibfk_2` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Constraints for table `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  ADD CONSTRAINT `FK_MaPN` FOREIGN KEY (`MaPN`) REFERENCES `phieunhap` (`MaPN`),
  ADD CONSTRAINT `FK_MaSP` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Constraints for table `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`MaDH`) REFERENCES `chitietdonhang` (`MaDH`),
  ADD CONSTRAINT `donhang_ibfk_2` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Constraints for table `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`);

--
-- Constraints for table `lienhe`
--
ALTER TABLE `lienhe`
  ADD CONSTRAINT `lienhe_ibfk_1` FOREIGN KEY (`MaNguoiTraLoi`) REFERENCES `nguoidung` (`MaND`);

--
-- Constraints for table `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD CONSTRAINT `phieunhap_ibfk_1` FOREIGN KEY (`MaNCC`) REFERENCES `nhacungcap` (`MaNCC`),
  ADD CONSTRAINT `phieunhap_ibfk_2` FOREIGN KEY (`MaNguoiLap`) REFERENCES `nguoidung` (`MaND`);

--
-- Constraints for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`MaDM`) REFERENCES `danhmuc` (`MaDM`);

--
-- Constraints for table `tinnhan`
--
ALTER TABLE `tinnhan`
  ADD CONSTRAINT `tinnhan_ibfk_1` FOREIGN KEY (`MaTC`) REFERENCES `trochuyen` (`MaTC`),
  ADD CONSTRAINT `tinnhan_ibfk_2` FOREIGN KEY (`MaNguoiGui`) REFERENCES `nguoidung` (`MaND`);

--
-- Constraints for table `trochuyen`
--
ALTER TABLE `trochuyen`
  ADD CONSTRAINT `trochuyen_ibfk_1` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
