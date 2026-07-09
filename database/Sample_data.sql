-- =========================
-- DỮ LIỆU MẪU THỰC TẾ
-- ComputerSpace Database
-- =========================

USE ComputerSpace;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- 1. TÀI KHOẢN
-- =========================
INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro, TrangThai, NgayTao, NgayDangNhapCuoi) VALUES
-- Quản trị viên
('admin',        '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'QUAN_TRI_VIEN', 1, '2024-01-01 08:00:00', '2025-05-01 09:00:00'),
('nhanvien01',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'QUAN_TRI_VIEN', 1, '2024-01-05 08:00:00', '2025-04-28 14:30:00'),
('nhanvien02',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'QUAN_TRI_VIEN', 1, '2024-02-10 08:00:00', '2025-04-20 10:00:00'),
-- Khách hàng
('nguyenvana',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG',    1, '2024-03-01 10:15:00', '2025-04-30 20:00:00'),
('tranthib',     '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG',    1, '2024-03-15 11:00:00', '2025-04-25 18:30:00'),
('lehongphuc',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG',    1, '2024-04-01 09:30:00', '2025-04-22 16:00:00'),
('phamthilan',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG',    1, '2024-05-10 14:00:00', '2025-04-18 21:00:00'),
('vuminhtuan',   '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG',    0, '2024-06-20 16:00:00', '2025-03-10 10:00:00');

-- =========================
-- 2. QUẢN TRỊ VIÊN
-- =========================
INSERT INTO QUAN_TRI_VIEN (MaTK, HoTen, SDT, Email, ChucVu) VALUES
(1, 'Trần Văn Quản',   '0901111001', 'quantri@computerspace.vn',   'Quản lý hệ thống'),
(2, 'Lê Thị Hoa',      '0901111002', 'lethihoa@computerspace.vn',  'Nhân viên bán hàng'),
(3, 'Nguyễn Minh Khôi','0901111003', 'nmkhoi@computerspace.vn',    'Nhân viên kho');

-- =========================
-- 3. KHÁCH HÀNG
-- =========================
INSERT INTO KHACH_HANG (MaTK, HoTen, SDT, Email, DiaChi) VALUES
(4, 'Nguyễn Văn A',   '0912345601', 'nguyenvana@gmail.com',  '12 Nguyễn Huệ, Quận 1, TP.HCM'),
(5, 'Trần Thị B',     '0912345602', 'tranthib@gmail.com',    '45 Lê Lợi, Quận Hải Châu, Đà Nẵng'),
(6, 'Lê Hồng Phúc',  '0912345603', 'lehongphuc@gmail.com',  '78 Trần Phú, Quận Ba Đình, Hà Nội'),
(7, 'Phạm Thị Lan',   '0912345604', 'phamthilan@gmail.com',  '33 Võ Thị Sáu, Quận 3, TP.HCM'),
(8, 'Vũ Minh Tuấn',   '0912345605', 'vuminhtuan@gmail.com',  '99 Đinh Tiên Hoàng, Quận Bình Thạnh, TP.HCM');

-- =========================
-- 4. SẢN PHẨM
-- =========================
-- Mainboard (MaLoaiSP = 1)
INSERT INTO SAN_PHAM (TenSP, MaLoaiSP, ThuongHieu, GiaBan, SoLuongTon, BaoHanhThang, MoTaNgan, TrangThai) VALUES
('ASUS ROG STRIX B650E-F GAMING WIFI',      1, 'ASUS',    7500000,  15, 36, 'Mainboard AMD AM5, DDR5, PCIe 5.0, WiFi 6E',         1),
('MSI MAG Z790 TOMAHAWK WIFI',              1, 'MSI',     6800000,  20, 36, 'Mainboard Intel Z790, DDR5, PCIe 5.0, WiFi 6E',      1),
('Gigabyte B760M AORUS ELITE AX DDR4',      1, 'Gigabyte',3200000,  30, 36, 'Mainboard Intel B760, mATX, DDR4, WiFi 6',           1),
-- CPU (MaLoaiSP = 2)
('Intel Core i9-13900K',                    2, 'Intel',  12500000,  10, 36, 'CPU Intel Gen 13, 24 nhân, 5.8GHz Turbo, không có quạt', 1),
('Intel Core i5-13600K',                    2, 'Intel',   7200000,  25, 36, 'CPU Intel Gen 13, 14 nhân, 5.1GHz Turbo, không có quạt', 1),
('AMD Ryzen 9 7950X',                       2, 'AMD',    15800000,   8, 36, 'CPU AMD Zen 4, 16 nhân 32 luồng, 5.7GHz Boost',      1),
-- VGA (MaLoaiSP = 3)
('ASUS ROG STRIX RTX 4090 OC 24GB',         3, 'ASUS',   45000000,   5, 36, 'GPU NVIDIA RTX 4090, GDDR6X 24GB, flagship gaming',  1),
('MSI GAMING X TRIO RTX 4070 Ti 12GB',      3, 'MSI',    18500000,  12, 36, 'GPU NVIDIA RTX 4070 Ti, GDDR6X 12GB, 3 quạt',       1),
('Gigabyte RX 7600 GAMING OC 8GB',          3, 'Gigabyte', 7200000, 18, 24, 'GPU AMD RX 7600, GDDR6 8GB, tản nhiệt WINDFORCE',    1),
-- Case (MaLoaiSP = 4)
('Lian Li PC-O11 Dynamic EVO RGB',          4, 'Lian Li', 3200000,  20, 24, 'Case Mid Tower, kính cường lực 3 mặt, hỗ trợ E-ATX', 1),
('NZXT H510 Flow',                          4, 'NZXT',    2100000,  25, 24, 'Case Mid Tower, mặt trước mesh, thiết kế tối giản',  1),
-- Nguồn (MaLoaiSP = 5)
('Corsair RM1000x 1000W 80+ Gold',          5, 'Corsair', 4500000,  15, 84, 'PSU fully modular, 1000W, 80+ Gold, Zero RPM mode',  1),
('Seasonic Focus GX-750 750W 80+ Gold',     5, 'Seasonic',3200000,  20, 60, 'PSU fully modular, 750W, 80+ Gold, bảo hành 5 năm', 1),
-- Tản nhiệt (MaLoaiSP = 6)
('Noctua NH-D15 Chromax Black',             6, 'Noctua',  2800000,  15, 72, 'Tản nhiệt khí dual tower, 2 quạt 140mm, cực êm',    1),
('NZXT Kraken X63 RGB 280mm',               6, 'NZXT',    3500000,  10, 36, 'Tản nhiệt nước AIO 280mm, 2 quạt Aer P 140mm',      1),
-- Ổ cứng (MaLoaiSP = 7)
('Samsung 870 EVO 1TB SATA SSD',            7, 'Samsung', 1800000,  40, 60, 'SSD SATA 2.5 inch, đọc 560MB/s, ghi 530MB/s',       1),
('WD Black SN850X 1TB NVMe PCIe 4.0',       7, 'Western Digital', 3200000, 30, 60, 'SSD NVMe M.2, PCIe 4.0, đọc 7300MB/s',      1),
('Seagate Barracuda 2TB 7200RPM',           7, 'Seagate', 1200000,  35, 24, 'HDD 3.5 inch, 7200RPM, SATA III, cache 256MB',      1),
-- RAM (MaLoaiSP = 8)
('Corsair Vengeance DDR5 32GB 5600MHz',     8, 'Corsair', 3800000,  25, 36, 'RAM DDR5 2x16GB, 5600MHz, tản nhiệt nhôm, XMP 3.0', 1),
('G.Skill Trident Z5 RGB DDR5 64GB 6000MHz',8, 'G.Skill', 7200000,  12, 36, 'RAM DDR5 2x32GB, 6000MHz, RGB, Intel XMP 3.0',      1),
('Kingston Fury Beast DDR4 16GB 3200MHz',   8, 'Kingston',1500000,  50, 36, 'RAM DDR4 2x8GB, 3200MHz, low profile, không LED',   1);

-- =========================
-- 5. ẢNH SẢN PHẨM
-- =========================
INSERT INTO ANH_SAN_PHAM (MaSP, DuongDanAnh, LaAnhDaiDien) VALUES
-- Mainboards
(1, '/images/products/asus-rog-maximus-z790-hero-1.jpg', 1),
(1, '/images/products/asus-rog-maximus-z790-hero-2.jpg', 0),
(2, '/images/products/msi-pro-b650p-1.jpg',  1),
(2, '/images/products/msi-mpg-b760i-edge-1.jpg',  0),
(3, '/images/products/gigabyte-z790-aorus-master-1.jpg',   1),
-- CPUs
(4, '/images/products/intel-i9-14900k-1.jpg',        1),
(5, '/images/products/intel-i7-13700k-1.jpg',        1),
(5, '/images/products/intel-i5-12400f-1.jpg',        0),
(6, '/images/products/amd-ryzen7-7700x-1.jpg',       1),
-- VGAs
(7, '/images/products/msi-suprim-rtx4090-1.jpg',       1),
(7, '/images/products/msi-suprim-rtx4090-2.jpg',       0),
(7, '/images/products/msi-suprim-rtx4090-1.jpg',       0),
(8, '/images/products/msi-ventus-rtx4060ti-1.jpg',          1),
(8, '/images/products/msi-ventus-rtx4060ti-1.jpg',          0),
(9, '/images/products/sapphire-pulse-rx7700xt-1.jpg',        1),
-- Cases
(10, '/images/products/nzxt-h9-flow-1.jpg',        1),
(10, '/images/products/nzxt-h9-flow-1.jpg',        0),
(11, '/images/products/lianli-lancool216-1.jpg',        1),
-- Nguồn
(12, '/images/products/corsair-rm850e-1.jpg',       1),
(13, '/images/products/seasonic-prime-tx1000-1.jpg',  1),
-- Tản nhiệt
(14, '/images/products/deepcool-ak620-digital-1.jpg',  1),
(14, '/images/products/thermalright-pa120se-1.jpg',  0),
(15, '/images/products/lianli-galahad2-240-1.jpg',       1),
-- Ổ cứng
(16, '/images/products/crucial-mx500-500gb-1.jpg',    1),
(17, '/images/products/wd-sn850x-1tb-1.jpeg',         1),
(18, '/images/products/wd-blue-4tb-1.jpg', 1),
-- RAM
(19, '/images/products/corsair-vengeance-lpx-ddr4-1.jpg',1),
(19, '/images/products/corsair-vengeance-lpx-ddr4-1.jpg',0),
(20, '/images/products/gskill-tridentz-rgb-ddr4-1.jpg',      1),
(21, '/images/products/kingston-fury-renegade-ddr5-1.jpg',   1);

-- =========================
-- 6. CHI TIẾT MAINBOARD
-- =========================
INSERT INTO CHI_TIET_MAIN VALUES
(1, 'AMD B650E', 'AM5',   'ATX',    'Ryzen 7000 Series',            4, 'DDR5', '128GB',   'PCIe 5.0 x16, PCIe 4.0 x1 (x2)', 4, 2, 'HDMI 2.1, DisplayPort 1.4'),
(2, 'Intel Z790','LGA1700','ATX',   'Intel 12th/13th Gen',          4, 'DDR5', '128GB',   'PCIe 5.0 x16, PCIe 3.0 x16',     6, 4, 'HDMI 2.1, DisplayPort 1.4'),
(3, 'Intel B760','LGA1700','mATX',  'Intel 12th/13th Gen',          4, 'DDR4', '128GB',   'PCIe 4.0 x16, PCIe 3.0 x1',      4, 2, 'HDMI 2.1, DisplayPort 1.2');

-- =========================
-- 7. CHI TIẾT CPU
-- =========================
INSERT INTO CHI_TIET_CPU VALUES
(4, 'Intel', 'Core i9-13900K', 'LGA1700', 24, 32, '3.0 GHz', '5.8 GHz', '80KB',   '32MB', '125W (PL1) / 253W (PL2)',  1),
(5, 'Intel', 'Core i5-13600K', 'LGA1700', 14, 20, '3.5 GHz', '5.1 GHz', '64KB',   '20MB', '125W (PL1) / 181W (PL2)',  1),
(6, 'AMD',   'Ryzen 9 7950X',  'AM5',     16, 32, '4.5 GHz', '5.7 GHz', '1MB',    '16MB', '170W',                     0);

-- =========================
-- 8. CHI TIẾT VGA
-- =========================
INSERT INTO CHI_TIET_VGA VALUES
(7, 'NVIDIA', '24GB GDDR6X', 'GDDR6X', '384-bit', '2610 MHz Boost', '450W', 'HDMI 2.1 x1, DP 1.4a x3', 3, '358 x 150 x 71 mm', '16-pin PCIe 5.0 x1'),
(8, 'NVIDIA', '12GB GDDR6X', 'GDDR6X', '192-bit', '2760 MHz Boost', '285W', 'HDMI 2.1 x1, DP 1.4a x3', 3, '340 x 140 x 56 mm', '16-pin PCIe 5.0 x1'),
(9, 'AMD',    '8GB GDDR6',   'GDDR6',  '128-bit', '2755 MHz Game',  '165W', 'HDMI 2.1 x1, DP 1.4 x2',  2, '245 x 120 x 42 mm', '8-pin PCIe x1');

-- =========================
-- 9. CHI TIẾT CASE
-- =========================
INSERT INTO CHI_TIET_CASE VALUES
(10, 'E-ATX / ATX / mATX / ITX', 'Đen',   'Nhôm + Kính cường lực', '470 x 285 x 459 mm', 'ATX (≤220mm)', 10, 1, 'USB-A 3.1 x2, USB-C 3.1 x1, Audio'),
(11, 'ATX / mATX / ITX',         'Đen/Trắng','Thép + Kính cường lực','428 x 210 x 460 mm','ATX (≤200mm)',  6, 1, 'USB-A 3.1 x1, USB-C 3.1 x1, Audio');

-- =========================
-- 10. CHI TIẾT NGUỒN
-- =========================
INSERT INTO CHI_TIET_NGUON VALUES
(12, '1000W',  '80+ Gold', 'Fully Modular', '150 x 86 x 160 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 16-pin x1, SATA x12, Molex x6'),
(13, '750W',   '80+ Gold', 'Fully Modular', '150 x 86 x 150 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 8-pin x4, SATA x9, Molex x4');

-- =========================
-- 11. CHI TIẾT TẢN NHIỆT
-- =========================
INSERT INTO CHI_TIET_TAN_NHIET VALUES
(14, 'Air Cooler (Tower)',
 'LGA1700/1200/115x, AM5/AM4',
 NULL, 2, '300 - 1500 RPM', '≤24.6 dB(A)', 'Không LED', '165 x 150 x 161 mm'),
(15, 'AIO Liquid Cooler',
 'LGA1700/1200/115x, AM5/AM4',
 '280mm', 2, '500 - 2000 RPM', '≤36 dB(A)', 'RGB', '143 x 322 x 30 mm (Radiator)');

-- =========================
-- 12. CHI TIẾT Ổ CỨNG
-- =========================
INSERT INTO CHI_TIET_O_CUNG VALUES
(16, 'SSD',  '1TB',  'SATA III',      '2.5 inch', 'Đọc: 560 MB/s, Ghi: 530 MB/s'),
(17, 'SSD',  '1TB',  'NVMe PCIe 4.0', 'M.2 2280',  'Đọc: 7300 MB/s, Ghi: 6600 MB/s'),
(18, 'HDD',  '2TB',  'SATA III',      '3.5 inch',  'Đọc: ~220 MB/s, Ghi: ~220 MB/s (7200RPM)');

-- =========================
-- 13. CHI TIẾT RAM
-- =========================
INSERT INTO CHI_TIET_RAM VALUES
(19, 'DDR5', '32GB (2x16GB)', '5600 MHz', '1.25V', 2),
(20, 'DDR5', '64GB (2x32GB)', '6000 MHz', '1.35V', 2),
(21, 'DDR4', '16GB (2x8GB)',  '3200 MHz', '1.35V', 2);

-- =========================
-- 14. KHUYẾN MÃI
-- (Phải insert trước DON_HANG vì có FK)
-- =========================
INSERT INTO KHUYEN_MAI (TenKM, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, TrangThai, MaNV) VALUES
('Khai trương - Giảm 10% toàn bộ CPU',       'PHAN_TRAM', 10.00, '2024-03-01 00:00:00', '2024-04-01 23:59:59', 0, 1),
('Flash Sale VGA - Giảm 1.500.000đ',          'SO_TIEN',   1500000, '2025-04-01 00:00:00', '2025-04-30 23:59:59', 0, 2),
('Tháng 5 - Giảm 5% Mainboard & RAM',         'PHAN_TRAM', 5.00,  '2025-05-01 00:00:00', '2025-05-31 23:59:59', 1, 1),
('Giảm 500.000đ cho đơn hàng từ 10 triệu',   'SO_TIEN',   500000, '2025-05-01 00:00:00', '2025-06-30 23:59:59', 1, 2);

-- Sản phẩm áp dụng khuyến mãi
INSERT INTO KHUYEN_MAI_SAN_PHAM (MaKM, MaSP) VALUES
(1, 4), (1, 5), (1, 6),                    -- KM1: CPU
(2, 7), (2, 8), (2, 9),                    -- KM2: VGA
(3, 1), (3, 2), (3, 3),                    -- KM3: Mainboard
(3, 19),(3, 20),(3, 21);                   -- KM3: RAM

-- =========================
-- 15. GIỎ HÀNG
-- =========================
INSERT INTO GIO_HANG (MaKH) VALUES (1),(2),(3),(4),(5);

INSERT INTO CHI_TIET_GIO_HANG (MaGioHang, MaSP, SoLuong, DonGia) VALUES
(1, 5,   1, 7200000),   -- KH1: i5-13600K
(1, 2,   1, 6800000),   -- KH1: MSI Z790
(1, 19,  2, 3800000),   -- KH1: 2 thanh RAM DDR5
(2, 8,   1, 18500000),  -- KH2: RTX 4070 Ti
(2, 17,  1, 3200000),   -- KH2: WD SN850X SSD
(3, 6,   1, 15800000),  -- KH3: Ryzen 9 7950X
(3, 1,   1, 7500000),   -- KH3: ASUS B650E
(4, 15,  1, 3500000),   -- KH4: NZXT Kraken X63
(4, 13,  1, 3200000),   -- KH4: Seasonic 750W
(5, 21,  2, 1500000);   -- KH5: Kingston DDR4 x2

-- =========================
-- 16. ĐƠN HÀNG
-- =========================
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu, MaKM) VALUES
-- Đơn đã giao
(1, 2, '2025-02-10 10:30:00', '12 Nguyễn Huệ, Q.1, TP.HCM',         '0912345601', 12500000,  30000, 'DA_GIAO',     'Giao giờ hành chính',       NULL),
(2, 1, '2025-02-20 14:00:00', '45 Lê Lợi, Q. Hải Châu, Đà Nẵng',    '0912345602', 21700000,  50000, 'DA_GIAO',     NULL,                         2),
(3, 2, '2025-03-05 09:15:00', '78 Trần Phú, Q. Ba Đình, Hà Nội',     '0912345603', 23300000,  50000, 'DA_GIAO',     'Để trước cửa nếu vắng',     NULL),
-- Đơn đang xử lý
(1, 1, '2025-04-15 11:00:00', '12 Nguyễn Huệ, Q.1, TP.HCM',         '0912345601', 17050000,  30000, 'DA_XAC_NHAN', NULL,                         3),
(4, 2, '2025-04-22 16:30:00', '33 Võ Thị Sáu, Q.3, TP.HCM',         '0912345604', 6700000,   30000, 'DANG_GIAO',   NULL,                         NULL),
(2, NULL,'2025-05-01 08:45:00','45 Lê Lợi, Q. Hải Châu, Đà Nẵng',   '0912345602', 7200000,   50000, 'CHO_XAC_NHAN',NULL,                         NULL),
-- Đơn bị hủy
(5, 3, '2025-03-20 20:00:00', '99 Đinh Tiên Hoàng, Q.Bình Thạnh',   '0912345605', 3800000,   30000, 'DA_HUY',      'Khách yêu cầu hủy',          NULL);

-- =========================
-- 17. CHI TIẾT ĐƠN HÀNG
-- =========================
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
-- Đơn 1: i9-13900K
(1, 4,  1, 12500000, 12500000),
-- Đơn 2: RTX 4070 Ti (giảm 1.5tr) + WD SN850X
(2, 8,  1, 18500000, 18500000),
(2, 17, 1,  3200000,  3200000),
-- Đơn 3: Ryzen 9 7950X + Corsair RM1000x
(3, 6,  1, 15800000, 15800000),
(3, 12, 1,  4500000,  4500000),
-- Đơn 4: MSI Z790 + Corsair DDR5 32GB (giảm 5%)
(4, 2,  1,  6800000,  6460000),
(4, 19, 2,  3800000,  7220000),
-- Đơn 5: Noctua NH-D15 + Seasonic 750W
(5, 14, 1,  2800000,  2800000),
(5, 13, 1,  3200000,  3200000),
-- Đơn 6: Gigabyte RX 7600
(6, 9,  1,  7200000,  7200000),
-- Đơn 7: Corsair Vengeance DDR5 (đã hủy)
(7, 19, 1,  3800000,  3800000);

-- =========================
-- 18. THANH TOÁN
-- =========================
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(1, 2, 12530000, '2025-02-10 10:35:00', 'DA_THANH_TOAN', 'TXN20250210001', 'Vietcombank'),
(2, 3, 21750000, '2025-02-20 14:05:00', 'DA_THANH_TOAN', 'VNP20250220098', NULL),
(3, 1, 23350000, '2025-03-07 11:20:00', 'DA_THANH_TOAN', NULL,             NULL),
(4, 2, 13710000, '2025-04-15 11:10:00', 'DA_THANH_TOAN', 'TXN20250415042', 'Techcombank'),
(5, 1,  6730000, NULL,                  'CHUA_THANH_TOAN', NULL,           NULL),
(6, 3,  7250000, '2025-05-01 08:50:00', 'DA_THANH_TOAN', 'VNP20250501011', NULL),
(7, 2,  3830000, '2025-03-20 20:10:00', 'HOAN_TIEN',     'TXN20250320005', 'MB Bank');

-- =========================
-- 19. ĐÁNH GIÁ
-- =========================
INSERT INTO DANH_GIA (MaKH, MaSP, SoSao, NoiDung, NgayDanhGia, TrangThaiDuyet) VALUES
(1, 4, 5, 'Chip cực mạnh, xử lý đa nhiệm tuyệt vời, nhiệt độ ổn với tản khí tốt. Rất hài lòng!',          '2025-02-15 10:00:00', 1),
(2, 8, 5, 'RTX 4070 Ti chơi game 4K mượt, ray tracing đẹp lung linh. Card chạy mát, đáng tiền!',           '2025-03-01 14:30:00', 1),
(2, 17,4, 'SSD nhanh thật, load game chưa đến 5 giây. Chỉ tiếc là giá hơi cao.',                            '2025-03-02 09:00:00', 1),
(3, 6, 5, 'Ryzen 9 7950X xuất sắc cho render và lập trình. Hiệu năng đa nhân vượt trội.',                   '2025-03-12 11:00:00', 1),
(3, 12,4, 'Nguồn chạy êm, modular dễ đi dây. Bảo hành 7 năm là điểm cộng lớn.',                            '2025-03-13 16:00:00', 1),
(1, 2, 4, 'Board Z790 ổn định, nhiều tùy chọn OC, BIOS dễ dùng. Hơi đắt nhưng xứng đáng.',                 '2025-04-20 20:00:00', 0),
(4, 14,5, 'Noctua NH-D15 quá êm, CPU 13600K chạy ở 65°C full load. Không cần AIO nữa!',                    '2025-05-02 10:30:00', 1),
(4, 13,5, 'Nguồn Seasonic chất lượng cao, im lặng hoàn toàn ở tải thấp, đóng gói cẩn thận.',               '2025-05-02 11:00:00', 0);

SET FOREIGN_KEY_CHECKS = 1;