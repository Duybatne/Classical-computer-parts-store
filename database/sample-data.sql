USE ComputerSpace;

SET FOREIGN_KEY_CHECKS = 0;

-- Xóa dữ liệu cũ
TRUNCATE TABLE CHI_TIET_DON_HANG;
TRUNCATE TABLE DON_HANG;
TRUNCATE TABLE THANH_TOAN;
TRUNCATE TABLE CHI_TIET_GIO_HANG;
TRUNCATE TABLE GIO_HANG;
TRUNCATE TABLE ANH_SAN_PHAM;
TRUNCATE TABLE SAN_PHAM;
TRUNCATE TABLE KHACH_HANG;
TRUNCATE TABLE QUAN_TRI_VIEN;
TRUNCATE TABLE TAI_KHOAN;

-- 1. Thêm Tài Khoản (Mật khẩu: 123456)
INSERT INTO TAI_KHOAN (MaTK, TenDangNhap, MatKhau, VaiTro, TrangThai) VALUES
(1, 'admin', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'QUAN_TRI_VIEN', 1),
(2, 'khachhang1', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1),
(3, 'khachhang2', '$2a$10$s7AQS0Igo88K05BVGV9U5.PPFepBBVEWfGdV5FG1W2elOo3sPBnV.', 'KHACH_HANG', 1);

-- 2. Thêm Thông Tin Chi Tiết Tài Khoản
INSERT INTO QUAN_TRI_VIEN (MaTK, HoTen, Email, SDT, ChucVu) VALUES
(1, 'Quản Trị Viên', 'admin@computerspace.vn', '0901234567', 'Admin');

INSERT INTO KHACH_HANG (MaTK, HoTen, Email, SDT, DiaChi) VALUES
(2, 'Nguyễn Văn Khách', 'khach1@gmail.com', '0912345678', '12 Đại Cồ Việt, Hà Nội'),
(3, 'Trần Thị Hàng', 'khach2@gmail.com', '0987654321', '54 Giải Phóng, Hà Nội');

-- 3. Thêm Sản Phẩm Mẫu
-- MaLoaiSP: 1: Main, 2: CPU, 3: VGA, 4: Case, 5: Nguon, 6: Tan nhiet, 7: O cung, 8: RAM
INSERT INTO SAN_PHAM (MaSP, TenSP, MaLoaiSP, ThuongHieu, GiaBan, SoLuongTon, BaoHanhThang, MoTaNgan, TrangThai) VALUES
(1, 'Intel Core i9-14900K', 2, 'Intel', 15500000.00, 10, 36, 'CPU Intel thế hệ 14 mới nhất với 24 cores', 1),
(2, 'AMD Ryzen 9 7950X', 2, 'AMD', 14200000.00, 15, 36, 'CPU cực mạnh cho làm việc và chơi game', 1),
(3, 'NVIDIA RTX 4090 24GB', 3, 'NVIDIA', 52000000.00, 5, 36, 'Card đồ họa đẳng cấp vũ trụ', 1),
(4, 'Corsair Vengeance 32GB DDR5 6000MHz', 8, 'Corsair', 3500000.00, 50, 60, 'RAM DDR5 tốc độ cao, hỗ trợ RGB', 1),
(5, 'ASUS ROG Strix Z790-E', 1, 'ASUS', 12000000.00, 8, 36, 'Bo mạch chủ cao cấp nhất cho Intel socket 1700', 1),
(6, 'Samsung 990 Pro 2TB PCIe 4.0', 7, 'Samsung', 4200000.00, 30, 60, 'Ổ cứng SSD NVMe tốc độ cực khủng', 1);

-- 4. Thêm Ảnh Sản Phẩm
INSERT INTO ANH_SAN_PHAM (MaSP, DuongDanAnh, LaAnhDaiDien) VALUES
(1, 'https://placehold.co/500x500/000000/FFFFFF/png?text=Intel+Core+i9', 1),
(2, 'https://placehold.co/500x500/000000/FFFFFF/png?text=AMD+Ryzen+9', 1),
(3, 'https://placehold.co/500x500/000000/FFFFFF/png?text=RTX+4090', 1),
(4, 'https://placehold.co/500x500/000000/FFFFFF/png?text=Corsair+RAM', 1),
(5, 'https://placehold.co/500x500/000000/FFFFFF/png?text=ROG+Motherboard', 1),
(6, 'https://placehold.co/500x500/000000/FFFFFF/png?text=Samsung+SSD', 1);

SET FOREIGN_KEY_CHECKS = 1;
