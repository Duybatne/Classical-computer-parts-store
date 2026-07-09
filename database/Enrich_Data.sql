-- ==========================
-- DỮ LIỆU LÀM GIÀU HỆ THỐNG
-- ComputerSpace Database
-- ==========================

USE ComputerSpace;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. THÊM TÀI KHOẢN MỚI
INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro, TrangThai, NgayTao) VALUES
('nguyenvanbinh', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-01-01 08:00:00'),
('tranthichau', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-01-11 14:00:00'),
('lehoangduy', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-01-21 15:00:00'),
('phamthigiang', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-01-31 17:00:00'),
('vuminhhai', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-02-10 14:00:00'),
('hoangthihuong', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-02-20 15:00:00'),
('nguyenquockhanh', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-03-02 17:00:00'),
('tranquanglam', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-03-12 18:00:00'),
('lethimai', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-03-22 09:00:00'),
('phamhoangnam', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-04-01 16:00:00'),
('vuongthiphong', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-04-11 09:00:00'),
('nguyenhuuquang', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-04-21 18:00:00'),
('tranthithanh', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-05-01 17:00:00'),
('leminhtri', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-05-11 08:00:00'),
('phamthixuan', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1, '2026-05-21 12:00:00');

-- 2. THÊM THÔNG TIN CHI TIẾT KHÁCH HÀNG
INSERT INTO KHACH_HANG (MaTK, HoTen, SDT, Email, DiaChi) VALUES
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'nguyenvanbinh'), 'Nguyễn Văn Bình', '0912345701', 'binhnv@gmail.com', '15 Lê Duẩn, Quận 1, TP.HCM'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'tranthichau'), 'Trần Thị Châu', '0912345702', 'chautt@gmail.com', '124 Bạch Đằng, Quận Hải Châu, Đà Nẵng'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'lehoangduy'), 'Lê Hoàng Duy', '0912345703', 'duylh@gmail.com', '88 Lý Thường Kiệt, Quận Hoàn Kiếm, Hà Nội'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'phamthigiang'), 'Phạm Thị Giang', '0912345704', 'giangpt@gmail.com', '56 Nguyễn Trãi, Quận 5, TP.HCM'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'vuminhhai'), 'Vũ Minh Hải', '0912345705', 'haivm@gmail.com', '210 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'hoangthihuong'), 'Hoàng Thị Hương', '0912345706', 'huonght@gmail.com', '45 Hùng Vương, TP. Nha Trang, Khánh Hòa'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'nguyenquockhanh'), 'Nguyễn Quốc Khánh', '0912345707', 'khanhnq@gmail.com', '12 Lạch Tray, Quận Ngô Quyền, Hải Phòng'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'tranquanglam'), 'Trần Quang Lâm', '0912345708', 'lamtq@gmail.com', '330 Đại Lộ Hòa Bình, Quận Ninh Kiều, Cần Thơ'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'lethimai'), 'Lê Thị Mai', '0912345709', 'mailt@gmail.com', '99 Trần Hưng Đạo, TP. Quy Nhơn, Bình Định'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'phamhoangnam'), 'Phạm Hoàng Nam', '0912345710', 'namph@gmail.com', '140 Lê Lợi, TP. Vinh, Nghệ An'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'vuongthiphong'), 'Vương Thị Phong', '0912345711', 'phongvt@gmail.com', '12 Quang Trung, Quận Gò Vấp, TP.HCM'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'nguyenhuuquang'), 'Nguyễn Hữu Quang', '0912345712', 'quangnh@gmail.com', '27 Nguyễn Chí Thanh, Quận Đống Đa, Hà Nội'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'tranthithanh'), 'Trần Thị Thanh', '0912345713', 'thanhtt@gmail.com', '82 Cách Mạng Tháng 8, Quận 3, TP.HCM'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'leminhtri'), 'Lê Minh Trí', '0912345714', 'trilm@gmail.com', '54 Nguyễn Văn Linh, Quận Thanh Khê, Đà Nẵng'),
((SELECT MaTK FROM TAI_KHOAN WHERE TenDangNhap = 'phamthixuan'), 'Phạm Thị Xuân', '0912345715', 'xuanpt@gmail.com', '18B Lê Hồng Phong, TP. Vũng Tàu, Bà Rịa - Vũng Tàu');

-- 3. KHỞI TẠO GIỎ HÀNG CHO KHÁCH HÀNG CHƯA CÓ GIỎ HÀNG
INSERT INTO GIO_HANG (MaKH)
SELECT MaKH FROM KHACH_HANG WHERE MaKH NOT IN (SELECT MaKH FROM GIO_HANG);

-- 4. THÊM ĐƠN HÀNG LÀM GIÀU DỮ LIỆU THỐNG KÊ (01/2026 - 06/2026)
-- Khai báo biến session cho các khách hàng mới
SET @kh_new_1 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'binhnv@gmail.com');
SET @kh_new_2 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'chautt@gmail.com');
SET @kh_new_3 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'duylh@gmail.com');
SET @kh_new_4 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'giangpt@gmail.com');
SET @kh_new_5 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'haivm@gmail.com');
SET @kh_new_6 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'huonght@gmail.com');
SET @kh_new_7 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'khanhnq@gmail.com');
SET @kh_new_8 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'lamtq@gmail.com');
SET @kh_new_9 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'mailt@gmail.com');
SET @kh_new_10 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'namph@gmail.com');
SET @kh_new_11 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'phongvt@gmail.com');
SET @kh_new_12 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'quangnh@gmail.com');
SET @kh_new_13 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'thanhtt@gmail.com');
SET @kh_new_14 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'trilm@gmail.com');
SET @kh_new_15 = (SELECT MaKH FROM KHACH_HANG WHERE Email = 'xuanpt@gmail.com');
SET @kh_ext_1 = 1;
SET @kh_ext_2 = 2;
SET @kh_ext_3 = 3;
SET @kh_ext_4 = 4;
SET @kh_ext_5 = 5;
SET @kh_ext_6 = 6;

-- Đơn hàng 1
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_3, NULL, '2026-01-02 11:58:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_3), 3230000.00, 30000.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 3, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 3230000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 2
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 1, '2026-01-03 15:03:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 110600000.00, 0.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 11, 1, 2100000.00, 2100000.00),
(@curr_order_id, 8, 1, 18500000.00, 18500000.00),
(@curr_order_id, 7, 2, 45000000.00, 90000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 110600000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 3
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_2, 3, '2026-01-05 16:07:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_2), 12000000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 11, 1, 2100000.00, 2100000.00),
(@curr_order_id, 15, 1, 3500000.00, 3500000.00),
(@curr_order_id, 3, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 12000000.00, '2026-01-06 13:07:00', 'DA_THANH_TOAN', 'TXN202601052726', NULL);

-- Đơn hàng 4
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_1, 2, '2026-01-07 13:04:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_1), 9430000.00, 30000.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 21, 2, 1500000.00, 3000000.00),
(@curr_order_id, 13, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 9430000.00, '2026-01-08 05:04:00', 'DA_THANH_TOAN', 'TXN202601076343', NULL);

-- Đơn hàng 5
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 3, '2026-01-09 13:57:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 17200000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 18, 1, 1200000.00, 1200000.00),
(@curr_order_id, 4, 1, 12500000.00, 12500000.00),
(@curr_order_id, 15, 1, 3500000.00, 3500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 17200000.00, '2026-01-10 19:57:00', 'DA_THANH_TOAN', 'TXN202601096555', 'Vietcombank');

-- Đơn hàng 6
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_11, 1, '2026-01-12 18:20:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_11), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_11), 34700000.00, 0.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 8, 1, 18500000.00, 18500000.00),
(@curr_order_id, 1, 2, 7500000.00, 15000000.00),
(@curr_order_id, 18, 1, 1200000.00, 1200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 34700000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 7
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_8, 3, '2026-01-13 20:11:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_8), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_8), 22600000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 1, 2, 7500000.00, 15000000.00),
(@curr_order_id, 18, 1, 1200000.00, 1200000.00),
(@curr_order_id, 3, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 22600000.00, '2026-01-14 17:11:00', 'DA_THANH_TOAN', 'TXN202601134380', 'Techcombank');

-- Đơn hàng 8
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_5, 1, '2026-01-15 20:56:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_5), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_5), 8130000.00, 30000.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 14, 1, 2800000.00, 2800000.00),
(@curr_order_id, 11, 1, 2100000.00, 2100000.00),
(@curr_order_id, 3, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 8130000.00, '2026-01-16 10:56:00', 'DA_THANH_TOAN', 'TXN202601154636', 'Techcombank');

-- Đơn hàng 9
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_11, NULL, '2026-01-18 08:08:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_11), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_11), 14200000.00, 0.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 9, 1, 7200000.00, 7200000.00),
(@curr_order_id, 19, 1, 3800000.00, 3800000.00),
(@curr_order_id, 17, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 14200000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 10
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_7, NULL, '2026-01-20 11:45:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_7), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_7), 96400000.00, 0.00, 'CHO_XAC_NHAN', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 17, 2, 3200000.00, 6400000.00),
(@curr_order_id, 7, 2, 45000000.00, 90000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 96400000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 11
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_10, 1, '2026-01-22 14:46:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_10), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_10), 11700000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 1, 1, 7500000.00, 7500000.00),
(@curr_order_id, 11, 2, 2100000.00, 4200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 11700000.00, '2026-01-23 14:46:00', 'DA_THANH_TOAN', 'TXN202601226693', NULL);

-- Đơn hàng 12
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 2, '2026-01-23 17:11:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 15600000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 5, 1, 7200000.00, 7200000.00),
(@curr_order_id, 20, 1, 7200000.00, 7200000.00),
(@curr_order_id, 18, 1, 1200000.00, 1200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 15600000.00, '2026-01-24 06:11:00', 'DA_THANH_TOAN', 'TXN202601234045', 'Techcombank');

-- Đơn hàng 13
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_10, 3, '2026-01-25 14:13:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_10), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_10), 12800000.00, 0.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 13, 2, 3200000.00, 6400000.00),
(@curr_order_id, 10, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 12800000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 14
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_7, 3, '2026-01-27 20:24:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_7), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_7), 12900000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 19, 2, 3800000.00, 7600000.00),
(@curr_order_id, 16, 1, 1800000.00, 1800000.00),
(@curr_order_id, 15, 1, 3500000.00, 3500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 12900000.00, '2026-01-27 23:24:00', 'DA_THANH_TOAN', 'TXN202601275294', 'Vietcombank');

-- Đơn hàng 15
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_7, 1, '2026-01-30 17:32:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_7), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_7), 45200000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 9, 1, 7200000.00, 7200000.00),
(@curr_order_id, 6, 2, 15800000.00, 31600000.00),
(@curr_order_id, 13, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 45200000.00, '2026-02-01 06:32:00', 'DA_THANH_TOAN', 'TXN202601302628', NULL);

-- Đơn hàng 16
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_5, NULL, '2026-02-01 14:00:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_5), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_5), 41200000.00, 0.00, 'CHO_XAC_NHAN', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 11, 2, 2100000.00, 4200000.00),
(@curr_order_id, 8, 2, 18500000.00, 37000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 41200000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 17
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_3, 3, '2026-02-02 17:51:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_3), 8430000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 20, 1, 7200000.00, 7200000.00),
(@curr_order_id, 18, 1, 1200000.00, 1200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 8430000.00, '2026-02-03 20:51:00', 'DA_THANH_TOAN', 'TXN202602029290', 'Vietcombank');

-- Đơn hàng 18
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_12, 3, '2026-02-05 08:03:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_12), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_12), 32200000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 4, 2, 12500000.00, 25000000.00),
(@curr_order_id, 5, 1, 7200000.00, 7200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 32200000.00, '2026-02-07 03:03:00', 'DA_THANH_TOAN', 'TXN202602058666', NULL);

-- Đơn hàng 19
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_11, 2, '2026-02-06 14:58:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_11), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_11), 13400000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 15, 2, 3500000.00, 7000000.00),
(@curr_order_id, 3, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 13400000.00, '2026-02-08 01:58:00', 'DA_THANH_TOAN', 'TXN202602069031', NULL);

-- Đơn hàng 20
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_15, 1, '2026-02-08 12:35:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_15), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_15), 15800000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 1, 15800000.00, 15800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 15800000.00, '2026-02-08 22:35:00', 'DA_THANH_TOAN', 'TXN202602085932', 'Vietcombank');

-- Đơn hàng 21
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_15, 3, '2026-02-10 16:11:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_15), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_15), 12000000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 18, 2, 1200000.00, 2400000.00),
(@curr_order_id, 17, 1, 3200000.00, 3200000.00),
(@curr_order_id, 13, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 12000000.00, '2026-02-11 19:11:00', 'DA_THANH_TOAN', 'TXN202602103850', NULL);

-- Đơn hàng 22
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_9, 3, '2026-02-12 18:57:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_9), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_9), 13600000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 10, 2, 3200000.00, 6400000.00),
(@curr_order_id, 5, 1, 7200000.00, 7200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 13600000.00, '2026-02-13 14:57:00', 'DA_THANH_TOAN', 'TXN202602121667', NULL);

-- Đơn hàng 23
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_3, 1, '2026-02-15 09:30:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_3), 12500000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 15, 1, 3500000.00, 3500000.00),
(@curr_order_id, 12, 2, 4500000.00, 9000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 12500000.00, '2026-02-16 03:30:00', 'DA_THANH_TOAN', 'TXN202602152485', NULL);

-- Đơn hàng 24
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_11, NULL, '2026-02-16 16:55:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_11), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_11), 96800000.00, 0.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 7, 2, 45000000.00, 90000000.00),
(@curr_order_id, 2, 1, 6800000.00, 6800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 96800000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 25
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_6, 2, '2026-02-19 08:40:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_6), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_6), 31600000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 2, 15800000.00, 31600000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 31600000.00, '2026-02-21 03:40:00', 'DA_THANH_TOAN', 'TXN202602197890', NULL);

-- Đơn hàng 26
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 2, '2026-02-20 09:39:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 22200000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 19, 2, 3800000.00, 7600000.00),
(@curr_order_id, 12, 2, 4500000.00, 9000000.00),
(@curr_order_id, 14, 2, 2800000.00, 5600000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 22200000.00, '2026-02-21 18:39:00', 'DA_THANH_TOAN', 'TXN202602205464', NULL);

-- Đơn hàng 27
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_15, NULL, '2026-02-23 17:38:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_15), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_15), 4830000.00, 30000.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 21, 2, 1500000.00, 3000000.00),
(@curr_order_id, 16, 1, 1800000.00, 1800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 4830000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 28
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_6, 3, '2026-02-25 18:44:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_6), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_6), 6430000.00, 30000.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 3, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 6430000.00, NULL, 'HOAN_TIEN', NULL, NULL);

-- Đơn hàng 29
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_12, NULL, '2026-02-27 11:47:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_12), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_12), 37000000.00, 0.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 8, 2, 18500000.00, 37000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 37000000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 30
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_8, 2, '2026-03-01 09:12:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_8), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_8), 6830000.00, 30000.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 2, 1, 6800000.00, 6800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 6830000.00, '2026-03-01 14:12:00', 'DA_THANH_TOAN', 'TXN202603018679', NULL);

-- Đơn hàng 31
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_3, 1, '2026-03-02 20:53:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_3), 20800000.00, 0.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 9, 2, 7200000.00, 14400000.00),
(@curr_order_id, 10, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 20800000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 32
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_2, 2, '2026-03-05 08:19:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_2), 51400000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 8, 2, 18500000.00, 37000000.00),
(@curr_order_id, 5, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 51400000.00, '2026-03-05 13:19:00', 'DA_THANH_TOAN', 'TXN202603058152', NULL);

-- Đơn hàng 33
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_3, 2, '2026-03-06 13:43:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_3), 9630000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 17, 1, 3200000.00, 3200000.00),
(@curr_order_id, 10, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 9630000.00, '2026-03-07 11:43:00', 'DA_THANH_TOAN', 'TXN202603068655', NULL);

-- Đơn hàng 34
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 2, '2026-03-09 19:41:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 22000000.00, 0.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 1, 15800000.00, 15800000.00),
(@curr_order_id, 21, 2, 1500000.00, 3000000.00),
(@curr_order_id, 13, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 22000000.00, NULL, 'HOAN_TIEN', NULL, NULL);

-- Đơn hàng 35
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_10, 1, '2026-03-11 14:01:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_10), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_10), 24300000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 9, 2, 7200000.00, 14400000.00),
(@curr_order_id, 15, 1, 3500000.00, 3500000.00),
(@curr_order_id, 10, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 24300000.00, '2026-03-13 06:01:00', 'DA_THANH_TOAN', 'TXN202603119295', NULL);

-- Đơn hàng 36
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_4, 1, '2026-03-13 13:34:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_4), 23500000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 10, 2, 3200000.00, 6400000.00),
(@curr_order_id, 2, 2, 6800000.00, 13600000.00),
(@curr_order_id, 15, 1, 3500000.00, 3500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 23500000.00, '2026-03-15 05:34:00', 'DA_THANH_TOAN', 'TXN202603132783', NULL);

-- Đơn hàng 37
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_2, 3, '2026-03-14 12:57:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_2), 3230000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 17, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 3230000.00, '2026-03-14 14:57:00', 'DA_THANH_TOAN', 'TXN202603141697', NULL);

-- Đơn hàng 38
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_13, 2, '2026-03-17 17:20:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_13), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_13), 35800000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 4, 2, 12500000.00, 25000000.00),
(@curr_order_id, 19, 1, 3800000.00, 3800000.00),
(@curr_order_id, 15, 2, 3500000.00, 7000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 35800000.00, '2026-03-19 17:20:00', 'DA_THANH_TOAN', 'TXN202603176916', 'Vietcombank');

-- Đơn hàng 39
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_7, 3, '2026-03-18 20:09:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_7), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_7), 14400000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 20, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 14400000.00, '2026-03-19 13:09:00', 'DA_THANH_TOAN', 'TXN202603189406', NULL);

-- Đơn hàng 40
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_15, 1, '2026-03-21 20:50:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_15), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_15), 30200000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 12, 2, 4500000.00, 9000000.00),
(@curr_order_id, 2, 1, 6800000.00, 6800000.00),
(@curr_order_id, 20, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 30200000.00, '2026-03-22 14:50:00', 'DA_THANH_TOAN', 'TXN202603214806', NULL);

-- Đơn hàng 41
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_1, 1, '2026-03-23 19:41:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_1), 70400000.00, 0.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 2, 15800000.00, 31600000.00),
(@curr_order_id, 8, 2, 18500000.00, 37000000.00),
(@curr_order_id, 16, 1, 1800000.00, 1800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 70400000.00, NULL, 'HOAN_TIEN', NULL, NULL);

-- Đơn hàng 42
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_13, 1, '2026-03-25 18:31:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_13), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_13), 5630000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 16, 1, 1800000.00, 1800000.00),
(@curr_order_id, 19, 1, 3800000.00, 3800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 5630000.00, '2026-03-27 01:31:00', 'DA_THANH_TOAN', 'TXN202603252642', NULL);

-- Đơn hàng 43
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_1, 2, '2026-03-26 19:07:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_1), 51400000.00, 0.00, 'DANG_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 13, 1, 3200000.00, 3200000.00),
(@curr_order_id, 7, 1, 45000000.00, 45000000.00),
(@curr_order_id, 10, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 51400000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 44
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_9, 2, '2026-03-29 12:12:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_9), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_9), 15100000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 1, 1, 7500000.00, 7500000.00),
(@curr_order_id, 19, 2, 3800000.00, 7600000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 15100000.00, '2026-03-31 00:12:00', 'DA_THANH_TOAN', 'TXN202603299988', NULL);

-- Đơn hàng 45
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_3, 3, '2026-03-30 12:17:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_3), 45200000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 2, 15800000.00, 31600000.00),
(@curr_order_id, 9, 1, 7200000.00, 7200000.00),
(@curr_order_id, 17, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 45200000.00, '2026-03-30 22:17:00', 'DA_THANH_TOAN', 'TXN202603306795', NULL);

-- Đơn hàng 46
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_8, 3, '2026-04-01 10:47:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_8), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_8), 6430000.00, 30000.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 13, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 6430000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 47
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_14, 1, '2026-04-03 12:17:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_14), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_14), 15800000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 1, 15800000.00, 15800000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 15800000.00, '2026-04-03 14:17:00', 'DA_THANH_TOAN', 'TXN202604037676', NULL);

-- Đơn hàng 48
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_6, 3, '2026-04-05 19:14:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_6), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_6), 11700000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 5, 1, 7200000.00, 7200000.00),
(@curr_order_id, 12, 1, 4500000.00, 4500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 11700000.00, '2026-04-07 08:14:00', 'DA_THANH_TOAN', 'TXN202604052703', NULL);

-- Đơn hàng 49
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_2, 2, '2026-04-07 12:53:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_2), 18000000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 20, 1, 7200000.00, 7200000.00),
(@curr_order_id, 19, 2, 3800000.00, 7600000.00),
(@curr_order_id, 10, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 18000000.00, '2026-04-07 23:53:00', 'DA_THANH_TOAN', 'TXN202604075008', 'Techcombank');

-- Đơn hàng 50
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_6, 1, '2026-04-09 13:36:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_6), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_6), 36300000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 5, 2, 7200000.00, 14400000.00),
(@curr_order_id, 1, 1, 7500000.00, 7500000.00),
(@curr_order_id, 9, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 36300000.00, '2026-04-10 01:36:00', 'DA_THANH_TOAN', 'TXN202604093179', NULL);

-- Đơn hàng 51
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_13, 1, '2026-04-12 18:22:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_13), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_13), 20000000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 15, 1, 3500000.00, 3500000.00),
(@curr_order_id, 9, 2, 7200000.00, 14400000.00),
(@curr_order_id, 11, 1, 2100000.00, 2100000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 20000000.00, '2026-04-14 09:22:00', 'DA_THANH_TOAN', 'TXN202604121823', NULL);

-- Đơn hàng 52
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_15, 3, '2026-04-13 08:55:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_15), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_15), 107600000.00, 0.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 3, 1, 3200000.00, 3200000.00),
(@curr_order_id, 7, 2, 45000000.00, 90000000.00),
(@curr_order_id, 9, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 107600000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 53
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_14, 1, '2026-04-16 08:29:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_14), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_14), 14400000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 5, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 14400000.00, '2026-04-18 07:29:00', 'DA_THANH_TOAN', 'TXN202604165492', NULL);

-- Đơn hàng 54
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 3, '2026-04-17 08:12:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 8230000.00, 30000.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 16, 1, 1800000.00, 1800000.00),
(@curr_order_id, 17, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 8230000.00, '2026-04-17 16:12:00', 'DA_THANH_TOAN', 'TXN202604178549', NULL);

-- Đơn hàng 55
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_12, 2, '2026-04-20 20:37:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_12), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_12), 12200000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 15, 2, 3500000.00, 7000000.00),
(@curr_order_id, 14, 1, 2800000.00, 2800000.00),
(@curr_order_id, 18, 2, 1200000.00, 2400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 12200000.00, '2026-04-22 20:37:00', 'DA_THANH_TOAN', 'TXN202604207936', NULL);

-- Đơn hàng 56
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_5, 1, '2026-04-22 09:13:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_5), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_5), 31600000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 2, 15800000.00, 31600000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 31600000.00, '2026-04-24 05:13:00', 'DA_THANH_TOAN', 'TXN202604223606', NULL);

-- Đơn hàng 57
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 3, '2026-04-23 20:09:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 7530000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 1, 1, 7500000.00, 7500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 7530000.00, '2026-04-25 17:09:00', 'DA_THANH_TOAN', 'TXN202604239787', NULL);

-- Đơn hàng 58
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_4, NULL, '2026-04-26 14:55:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_4), 43000000.00, 0.00, 'CHO_XAC_NHAN', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 20, 2, 7200000.00, 14400000.00),
(@curr_order_id, 16, 2, 1800000.00, 3600000.00),
(@curr_order_id, 4, 2, 12500000.00, 25000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 43000000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 59
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 3, '2026-04-27 17:12:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 16800000.00, 0.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 2, 2, 6800000.00, 13600000.00),
(@curr_order_id, 13, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 16800000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 60
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_3, 2, '2026-04-30 15:50:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_3), 55600000.00, 0.00, 'DA_HUY', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 1, 15800000.00, 15800000.00),
(@curr_order_id, 14, 1, 2800000.00, 2800000.00),
(@curr_order_id, 8, 2, 18500000.00, 37000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 55600000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 61
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 3, '2026-05-01 19:43:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 48200000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 7, 1, 45000000.00, 45000000.00),
(@curr_order_id, 3, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 2, 48200000.00, '2026-05-02 04:43:00', 'DA_THANH_TOAN', 'TXN202605019506', NULL);

-- Đơn hàng 62
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_10, 2, '2026-05-04 10:33:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_10), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_10), 3030000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 21, 2, 1500000.00, 3000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 3030000.00, '2026-05-05 22:33:00', 'DA_THANH_TOAN', 'TXN202605047943', NULL);

-- Đơn hàng 63
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_11, 2, '2026-05-05 09:36:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_11), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_11), 26400000.00, 0.00, 'DA_GIAO', 'Giao giờ hành chính, gọi trước khi giao');
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 20, 2, 7200000.00, 14400000.00),
(@curr_order_id, 12, 2, 4500000.00, 9000000.00),
(@curr_order_id, 21, 2, 1500000.00, 3000000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 26400000.00, '2026-05-06 17:36:00', 'DA_THANH_TOAN', 'TXN202605053709', NULL);

-- Đơn hàng 64
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_3, 3, '2026-05-08 16:26:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_3), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_3), 3230000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 10, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 3230000.00, '2026-05-09 02:26:00', 'DA_THANH_TOAN', 'TXN202605087297', NULL);

-- Đơn hàng 65
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_4, 3, '2026-05-10 08:21:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_4), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_4), 4030000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 14, 1, 2800000.00, 2800000.00),
(@curr_order_id, 18, 1, 1200000.00, 1200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 4030000.00, '2026-05-12 05:21:00', 'DA_THANH_TOAN', 'TXN202605105541', NULL);

-- Đơn hàng 66
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_ext_6, 1, '2026-05-12 17:23:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_ext_6), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_ext_6), 5630000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 14, 2, 2800000.00, 5600000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 5630000.00, '2026-05-13 06:23:00', 'DA_THANH_TOAN', 'TXN202605124170', NULL);

-- Đơn hàng 67
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_2, 2, '2026-05-14 08:06:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_2), 3230000.00, 30000.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 13, 1, 3200000.00, 3200000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 3230000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- Đơn hàng 68
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 1, '2026-05-15 17:53:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 7530000.00, 30000.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 1, 1, 7500000.00, 7500000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 7530000.00, '2026-05-15 18:53:00', 'DA_THANH_TOAN', 'TXN202605151518', NULL);

-- Đơn hàng 69
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_1, 3, '2026-05-17 18:09:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_1), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_1), 38000000.00, 0.00, 'DA_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 6, 2, 15800000.00, 31600000.00),
(@curr_order_id, 17, 2, 3200000.00, 6400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 3, 38000000.00, '2026-05-18 21:09:00', 'DA_THANH_TOAN', 'TXN202605173900', NULL);

-- Đơn hàng 70
INSERT INTO DON_HANG (MaKH, MaNV, NgayDat, DiaChiNhan, SDTNhan, TongTien, PhiVanChuyen, TrangThaiDonHang, GhiChu) VALUES
(@kh_new_2, 1, '2026-05-19 15:58:00', (SELECT DiaChi FROM KHACH_HANG WHERE MaKH = @kh_new_2), (SELECT SDT FROM KHACH_HANG WHERE MaKH = @kh_new_2), 20800000.00, 0.00, 'DANG_GIAO', NULL);
SET @curr_order_id = LAST_INSERT_ID();
INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(@curr_order_id, 3, 2, 3200000.00, 6400000.00),
(@curr_order_id, 20, 2, 7200000.00, 14400000.00);
INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, ThoiGianThanhToan, TrangThaiThanhToan, MaGiaoDich, TenNganHang) VALUES
(@curr_order_id, 1, 20800000.00, NULL, 'CHUA_THANH_TOAN', NULL, NULL);

-- 5. THÊM ĐÁNH GIÁ SẢN PHẨM MỚI
INSERT INTO DANH_GIA (MaKH, MaSP, SoSao, NoiDung, NgayDanhGia, TrangThaiDuyet) VALUES
(@kh_new_2, 11, 4, 'Card màn hình chạy rất mát, hiệu năng đỉnh cao chơi game mượt.', '2026-01-11 16:07:00', 1),
(@kh_ext_1, 21, 4, 'RAM load nhanh, bật XMP nhận luôn bus cao, led RGB đẹp.', '2026-01-14 13:04:00', 1),
(@kh_new_7, 19, 5, 'Case đẹp, rộng rãi, dễ lắp đặt linh kiện, luồng khí thông thoáng.', '2026-01-29 20:24:00', 1),
(@kh_new_7, 9, 5, 'Sản phẩm dùng cực kỳ mượt mà, đóng gói rất cẩn thận, vote 5 sao.', '2026-02-03 17:32:00', 1),
(@kh_new_12, 4, 5, 'Chip xử lý nhanh, làm việc lập trình đồ họa render rất đã.', '2026-02-12 08:03:00', 1),
(@kh_new_11, 15, 5, 'Hàng chính hãng, chất lượng tuyệt vời, nhân viên tư vấn nhiệt tình.', '2026-02-12 14:58:00', 1),
(@kh_new_15, 6, 5, 'Chip xử lý nhanh, làm việc lập trình đồ họa render rất đã.', '2026-02-12 12:35:00', 1),
(@kh_new_15, 18, 5, 'Chip xử lý nhanh, làm việc lập trình đồ họa render rất đã.', '2026-02-17 16:11:00', 1),
(@kh_new_9, 10, 5, 'RAM load nhanh, bật XMP nhận luôn bus cao, led RGB đẹp.', '2026-02-14 18:57:00', 1),
(@kh_new_2, 8, 5, 'Nguồn modular đi dây gọn gàng, chạy êm không ồn.', '2026-03-09 08:19:00', 1),
(@kh_new_10, 9, 5, 'Card màn hình chạy rất mát, hiệu năng đỉnh cao chơi game mượt.', '2026-03-13 14:01:00', 1),
(@kh_new_9, 1, 4, 'SSD tốc độ cực nhanh, khởi động máy và load game mất chưa tới 5s.', '2026-04-04 12:12:00', 1),
(@kh_new_14, 6, 5, 'Nguồn modular đi dây gọn gàng, chạy êm không ồn.', '2026-04-05 12:17:00', 1),
(@kh_new_6, 5, 4, 'Card màn hình chạy rất mát, hiệu năng đỉnh cao chơi game mượt.', '2026-04-15 13:36:00', 1),
(@kh_new_13, 15, 5, 'SSD tốc độ cực nhanh, khởi động máy và load game mất chưa tới 5s.', '2026-04-18 18:22:00', 1),
(@kh_new_4, 16, 5, 'Tản nhiệt hoạt động hiệu quả, CPU luôn mát mẻ dưới 70 độ.', '2026-04-20 08:12:00', 1),
(@kh_new_12, 15, 4, 'RAM load nhanh, bật XMP nhận luôn bus cao, led RGB đẹp.', '2026-04-26 20:37:00', 1),
(@kh_ext_5, 6, 5, 'RAM load nhanh, bật XMP nhận luôn bus cao, led RGB đẹp.', '2026-04-26 09:13:00', 1),
(@kh_new_11, 20, 5, 'Nguồn modular đi dây gọn gàng, chạy êm không ồn.', '2026-05-11 09:36:00', 1),
(@kh_ext_3, 10, 5, 'Card màn hình chạy rất mát, hiệu năng đỉnh cao chơi game mượt.', '2026-05-14 16:26:00', 1),
(@kh_new_4, 14, 5, 'Sản phẩm dùng cực kỳ mượt mà, đóng gói rất cẩn thận, vote 5 sao.', '2026-05-12 08:21:00', 1),
(@kh_new_1, 1, 5, 'Hàng chính hãng, chất lượng tuyệt vời, nhân viên tư vấn nhiệt tình.', '2026-05-17 17:53:00', 1);

SET FOREIGN_KEY_CHECKS = 1;