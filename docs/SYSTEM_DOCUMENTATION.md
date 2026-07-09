# ComputerStore - Hệ Thống Bán Linh Kiện Máy Tính

## Mục Lục

1. [Tổng Quan Hệ Thống](#tổng-quan-hệ-thống)
2. [Kiến Trúc Hệ Thống](#kiến-trúc-hệ-thống)
3. [Cơ Sở Dữ Liệu](#cơ-sở-dữ-liệu)
4. [Backend API](#backend-api)
5. [Frontend Pages](#frontend-pages)
6. [Luồng Nghiệp Vụ Chính](#luồng-nghiệp-vụ-chính)
7. [Hướng Dẫn Setup](#hướng-dẫn-setup)
8. [Các Vấn Đề Cần Cải Thiện](#các-vấn-đề-cần-cải-thiện)

---

## Tổng Quan Hệ Thống

**ComputerStore** là ứng dụng web thương mại điện tử chuyên bán linh kiện máy tính với các chức năng chính:

- 👤 **Quản lý người dùng**: Đăng ký, đăng nhập, phân quyền (Customer/Admin)
- 🛍️ **Mua sắm**: Xem sản phẩm, giỏ hàng, đặt hàng, thanh toán
- 🖥️ **PC Builder**: Tự build cấu hình máy tính
- 📊 **Admin Dashboard**: Quản lý sản phẩm, đơn hàng, khuyến mãi
- ⭐ **Đánh giá**: Review và rating sản phẩm

### Công Nghệ Sử Dụng

| Layer          | Technology                            |
| -------------- | ------------------------------------- |
| **Backend**    | Java 21, Jakarta Servlet 6.1, JSP 4.0 |
| **Database**   | MySQL 8.0, HikariCP Connection Pool   |
| **Frontend**   | JSP, JSTL, Bootstrap 5, JavaScript    |
| **Security**   | BCrypt password hashing               |
| **Build Tool** | Maven 3.x                             |
| **Server**     | Tomcat 11.x                           |

---

## Kiến Trúc Hệ Thống

### Mô Hình 3 Lớp (3-Tier Architecture)

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   JSP Pages │  │  Bootstrap  │  │ JavaScript  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                     Controller Layer                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Servlet Controllers                     │   │
│  │  • AuthServlet      • CartServlet    • OrderServlet │   │
│  │  • ProductServlet   • AdminServlets  • ApiServlets  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            Business Logic Services                   │   │
│  │  • ProductService   • CartService    • OrderService │   │
│  │  • UserService      • PromotionService • ReviewService│  │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                       DAO Layer                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Data Access Objects (14 DAOs)              │   │
│  │  • ProductDAO  • OrderDAO  • UserDAO  • CartDAO ... │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                     Database Layer                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              MySQL Database (13 Tables)              │   │
│  │         HikariCP Connection Pool Management          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Cấu Trúc Thư Mục

```
computerstore/
├── src/main/java/com/computerstore/
│   ├── controllers/          # Servlet controllers
│   │   ├── admin/           # Admin controllers
│   │   └── api/             # REST API controllers
│   ├── services/            # Business logic
│   ├── dao/                 # Data access objects
│   ├── models/              # Entity classes
│   ├── dto/                 # Data transfer objects
│   ├── exceptions/          # Custom exceptions
│   └── utils/               # Utility classes
├── src/main/webapp/
│   ├── jsp/                 # JSP view pages
│   │   └── admin/           # Admin pages
│   ├── css/                 # Stylesheets
│   ├── js/                  # JavaScript files
│   └── images/              # Static images
├── database/
│   ├── schema.sql           # Database schema
│   └── migrations/          # Database migrations
└── pom.xml                  # Maven configuration
```

---

## Cơ Sở Dữ Liệu

### Sơ Đồ Quan Hệ (ERD)

```
┌──────────────────┐       ┌──────────────────┐
│   TAI_KHOAN      │       │  LOAI_SAN_PHAM   │
│──────────────────│       │──────────────────│
│ PK MaTK          │       │ PK MaLoaiSP      │
│    TenDangNhap   │       │    TenLoaiSP     │
│    MatKhau       │       │    MoTa          │
│    VaiTro        │       └──────────────────┘
│    TrangThai     │                │
│    NgayTao       │                │
│    NgayDangNhapCuoi              │
└──────────────────┘                │
        │                           │
        ├──┬─────────────────────────┤
        │  │                         │
        ▼  ▼                         ▼
┌──────────────┐  ┌─────────────────────────────┐
│ KHACH_HANG   │  │      SAN_PHAM               │
│──────────────│  │─────────────────────────────│
│ PK MaKH      │  │ PK MaSP                     │
│ FK MaTK      │  │ FK MaLoaiSP                 │
│    HoTen     │◄─┤    TenSP                    │
│    SDT       │  │    ThuongHieu               │
│    Email     │  │    GiaBan                   │
│    DiaChi    │  │    SoLuongTon               │
└──────────────┘  │    BaoHanhThang             │
                  │    MoTaNgan                  │
┌──────────────┐  │    MoTaChiTiet              │
│QUAN_TRI_VIEN │  │    TrangThai                 │
│──────────────│  │    NgayTao                   │
│ PK MaNV      │  │    NgayCapNhat               │
│ FK MaTK      │  └─────────────────────────────┘
│    HoTen     │           │
│    SDT       │           ├──┬─────────────────────────┐
│    Email     │           │  │                         │
│    ChucVu    │           ▼  ▼                         ▼
└──────────────┘  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
                  │ ANH_SAN_PHAM │  │CHI_TIET_*    │  │  GIO_HANG    │
                  │──────────────│  │(8 tables)    │  │──────────────│
                  │ PK MaAnh     │  │FK MaSP (PK)  │  │ PK MaGioHang │
                  │ FK MaSP      │  │Spec fields   │  │ FK MaKH      │
                  │    DuongDan  │  └──────────────┘  │    NgayCapNhat
                  │    LaAnhDaiDien│                  └──────────────┘
                  └──────────────┘                           │
                                                             ▼
                                                       ┌──────────────┐
                                                       │CHI_TIET_GIO_H│
                                                       │──────────────│
┌──────────────┐  ┌──────────────┐                    │FK MaGioHang  │
│  DON_HANG    │  │KHUYEN_MAI    │                    │FK MaSP       │
│──────────────│  │──────────────│                    │    SoLuong   │
│ PK MaDonHang │  │ PK MaKM      │                    │    DonGia    │
│ FK MaKH      │  │    TenKM     │◄─────────────────┐  └──────────────┘
│ FK MaNV      │  │    LoaiGiam  │                  │
│    NgayDat   │  │    GiaTriGiam│                  │
│    DiaChiNhan│  │    NgayBD    │                  │
│    SDTNhan   │  │    NgayKT    │                  │
│    TongTien  │  │    TrangThai │                  │
│    PhiVC     │  └──────────────┘                  │
│    TrangThai │           │                        │
│    GhiChu    │           ▼                        │
│ FK MaKM      │  ┌──────────────┐                  │
└──────────────┘  │KHUYEN_MAI_SP │                  │
        │         │──────────────│                  │
        │         │FK MaKM       │                  │
        │         │FK MaSP       │                  │
        │         └──────────────┘                  │
        ▼                                            │
┌──────────────┐                                    │
│CHI_TIET_DH   │  ┌──────────────┐  ┌────────────┐ │
│──────────────│  │ THANH_TOAN   │  │DANH_GIA    │ │
│FK MaDonHang  │  │──────────────│  │────────────│ │
│FK MaSP       │  │ PK MaTT      │  │ PK MaDG    │ │
│    SoLuong   │  │ FK MaDonHang │  │ FK MaKH    │ │
│    DonGia    │  │ FK MaPTTT    │  │ FK MaSP    │ │
│    ThanhTien │  │    SoTien    │  │    SoSao   │ │
└──────────────┘  │    ThoiGian  │  │    NoiDung │ │
                  │    TrangThai │  │    NgayDG  │ │
                  │    MaGiaoDich│  │    TrangThai││
                  │    TenNH     │  └────────────┘ │
                  └──────────────┘                 │
                           │                       │
                           ▼                       │
                  ┌──────────────┐                 │
                  │PHUONG_THUC_TT│                 │
                  │──────────────│                 │
                  │ PK MaPTTT    │                 │
                  │    TenPTTT   │                 │
                  │    MoTa      │                 │
                  │    TrangThai │                 │
                  └──────────────┘                 │
```

### Chi Tiết Các Bảng

#### 1. Nhóm Quản Lý Người Dùng

**TAI_KHOAN** - Tài khoản đăng nhập

```sql
CREATE TABLE TAI_KHOAN (
    MaTK INT AUTO_INCREMENT PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,           -- BCrypt hashed
    VaiTro ENUM('KHACH_HANG', 'QUAN_TRI_VIEN') NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1,    -- 1: Active, 0: Inactive
    NgayTao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayDangNhapCuoi DATETIME NULL
);
```

**KHACH_HANG** - Thông tin khách hàng

```sql
CREATE TABLE KHACH_HANG (
    MaKH INT AUTO_INCREMENT PRIMARY KEY,
    MaTK INT NOT NULL UNIQUE,                -- FK to TAI_KHOAN
    HoTen VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DiaChi VARCHAR(255)
);
```

**QUAN_TRI_VIEN** - Thông tin admin

```sql
CREATE TABLE QUAN_TRI_VIEN (
    MaNV INT AUTO_INCREMENT PRIMARY KEY,
    MaTK INT NOT NULL UNIQUE,                -- FK to TAI_KHOAN
    HoTen VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    ChucVu VARCHAR(100)
);
```

#### 2. Nhóm Quản Lý Sản Phẩm

**LOAI_SAN_PHAM** - Danh mục sản phẩm

```sql
CREATE TABLE LOAI_SAN_PHAM (
    MaLoaiSP INT AUTO_INCREMENT PRIMARY KEY,
    TenLoaiSP VARCHAR(100) NOT NULL UNIQUE,  -- 'CPU', 'VGA', 'RAM', 'Mainboard', etc.
    MoTa TEXT
);
```

**SAN_PHAM** - Thông tin cơ bản sản phẩm

```sql
CREATE TABLE SAN_PHAM (
    MaSP INT AUTO_INCREMENT PRIMARY KEY,
    TenSP VARCHAR(255) NOT NULL,
    MaLoaiSP INT NOT NULL,                   -- FK to LOAI_SAN_PHAM
    ThuongHieu VARCHAR(100),
    GiaBan DECIMAL(15,2) NOT NULL DEFAULT 0,
    SoLuongTon INT NOT NULL DEFAULT 0,
    BaoHanhThang INT NOT NULL DEFAULT 0,
    MoTaNgan TEXT,
    MoTaChiTiet LONGTEXT,
    TrangThai TINYINT NOT NULL DEFAULT 1,    -- 1: Hiển thị, 0: Ẩn
    NgayTao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayCapNhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**CHI*TIET*\*** - 8 bảng chi tiết cho từng loại linh kiện

- **CHI_TIET_MAIN**: Chipset, Socket, KichThuocMain, HoTroCPU, SoKheRam, LoaiRam, ...
- **CHI_TIET_CPU**: HangCPU, DongCPU, Socket, SoNhan, SoLuongLuong, XungNhip, ...
- **CHI_TIET_VGA**: HangGPU, DungLuongVRAM, KieuBoNho, BusBoNho, ...
- **CHI_TIET_RAM**: LoaiRam, DungLuong, BusRam, DienAp, SoThanh, ...
- **CHI_TIET_O_CUNG**: LoaiOCung (HDD/SSD), DungLuong, ChuanKetNoi, ...
- **CHI_TIET_CASE**: HoTroMain, MauSac, ChatLieu, KichThuoc, ...
- **CHI_TIET_NGUON**: CongSuat, Chuan80Plus, CongKetNoi, ...
- **CHI_TIET_TAN_NHIET**: LoaiTanNhiet (Air/Liquid), TuongThichCPU, ...

#### 3. Nhóm Giỏ Hàng & Đơn Hàng

**GIO_HANG** - Giỏ hàng

```sql
CREATE TABLE GIO_HANG (
    MaGioHang INT AUTO_INCREMENT PRIMARY KEY,
    MaKH INT NOT NULL UNIQUE,                -- 1 customer = 1 cart
    NgayCapNhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**CHI_TIET_GIO_HANG** - Chi tiết giỏ hàng

```sql
CREATE TABLE CHI_TIET_GIO_HANG (
    MaGioHang INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL DEFAULT 1,
    DonGia DECIMAL(15,2) NOT NULL DEFAULT 0,  -- Giá tại thời điểm thêm
    PRIMARY KEY (MaGioHang, MaSP)
);
```

**DON_HANG** - Đơn hàng

```sql
CREATE TABLE DON_HANG (
    MaDonHang INT AUTO_INCREMENT PRIMARY KEY,
    MaKH INT NOT NULL,                       -- FK to KHACH_HANG
    MaNV INT NULL,                           -- FK to QUAN_TRI_VIEN (admin xử lý)
    NgayDat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DiaChiNhan VARCHAR(255) NOT NULL,
    SDTNhan VARCHAR(15) NOT NULL,
    TongTien DECIMAL(15,2) NOT NULL DEFAULT 0,
    PhiVanChuyen DECIMAL(15,2) NOT NULL DEFAULT 0,
    TrangThaiDonHang ENUM('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')
        NOT NULL DEFAULT 'CHO_XAC_NHAN',
    GhiChu TEXT,
    MaKM INT NULL                            -- FK to KHUYEN_MAI (nếu dùng voucher)
);
```

**CHI_TIET_DON_HANG** - Chi tiết đơn hàng

```sql
CREATE TABLE CHI_TIET_DON_HANG (
    MaDonHang INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(15,2) NOT NULL,           -- Giá tại thời điểm mua
    ThanhTien DECIMAL(15,2) NOT NULL,        -- = DonGia * SoLuong
    PRIMARY KEY (MaDonHang, MaSP)
);
```

#### 4. Nhóm Thanh Toán

**PHUONG_THUC_THANH_TOAN** - Phương thức thanh toán

```sql
CREATE TABLE PHUONG_THUC_THANH_TOAN (
    MaPTTT INT AUTO_INCREMENT PRIMARY KEY,
    TenPTTT VARCHAR(100) NOT NULL UNIQUE,    -- 'COD', 'Chuyển khoản', 'Ví điện tử'
    MoTa TEXT,
    TrangThai TINYINT NOT NULL DEFAULT 1
);
```

**THANH_TOAN** - Giao dịch thanh toán

```sql
CREATE TABLE THANH_TOAN (
    MaThanhToan INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL UNIQUE,           -- 1 order = 1 payment record
    MaPTTT INT NOT NULL,                     -- FK to PHUONG_THUC_THANH_TOAN
    SoTien DECIMAL(15,2) NOT NULL,
    ThoiGianThanhToan DATETIME DEFAULT CURRENT_TIMESTAMP,
    TrangThaiThanhToan ENUM('CHUA_THANH_TOAN', 'DA_THANH_TOAN', 'HOAN_TIEN')
        NOT NULL DEFAULT 'CHUA_THANH_TOAN',
    MaGiaoDich VARCHAR(100),                 -- Transaction ID từ payment gateway
    TenNganHang VARCHAR(100)
);
```

#### 5. Nhóm Khuyến Mãi

**KHUYEN_MAI** - Chương trình khuyến mãi

```sql
CREATE TABLE KHUYEN_MAI (
    MaKM INT AUTO_INCREMENT PRIMARY KEY,
    TenKM VARCHAR(150) NOT NULL,             -- Tên mã giảm giá
    LoaiGiam ENUM('PHAN_TRAM', 'SO_TIEN') NOT NULL,
    GiaTriGiam DECIMAL(15,2) NOT NULL DEFAULT 0,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1,    -- 1: Active, 0: Expired
    MaNV INT NULL                            -- FK to QUAN_TRI_VIEN (người tạo)
);
```

**KHUYEN_MAI_SAN_PHAM** - Sản phẩm áp dụng khuyến mãi

```sql
CREATE TABLE KHUYEN_MAI_SAN_PHAM (
    MaKM INT NOT NULL,
    MaSP INT NOT NULL,
    PRIMARY KEY (MaKM, MaSP)
);
```

#### 6. Nhóm Đánh Giá

**DANH_GIA** - Đánh giá sản phẩm

```sql
CREATE TABLE DANH_GIA (
    MaDG INT AUTO_INCREMENT PRIMARY KEY,
    MaKH INT NOT NULL,                       -- FK to KHACH_HANG
    MaSP INT NOT NULL,                       -- FK to SAN_PHAM
    SoSao TINYINT NOT NULL,                  -- 1-5 stars
    NoiDung TEXT,
    NgayDanhGia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TrangThaiDuyet TINYINT NOT NULL DEFAULT 0, -- 0: Pending, 1: Approved
    CONSTRAINT UQ_DANH_GIA UNIQUE (MaKH, MaSP) -- 1 customer = 1 review per product
);
```

---

## Backend API

### Base URL

```
http://localhost:8080/computerstore
```

### Authentication APIs

| Method | Endpoint    | Description | Parameters                                           |
| ------ | ----------- | ----------- | ---------------------------------------------------- |
| POST   | `/login`    | Đăng nhập   | `username`, `password`                               |
| POST   | `/register` | Đăng ký     | `username`, `password`, `email`, `fullname`, `phone` |
| GET    | `/logout`   | Đăng xuất   | -                                                    |

### Product APIs

| Method | Endpoint           | Description            | Parameters                          |
| ------ | ------------------ | ---------------------- | ----------------------------------- |
| GET    | `/shop`            | Xem danh sách sản phẩm | `category`, `page`, `limit`, `sort` |
| GET    | `/product/{id}`    | Chi tiết sản phẩm      | `id`: MaSP                          |
| GET    | `/category/{name}` | Sản phẩm theo danh mục | `name`: TenLoaiSP, `page`, `limit`  |
| GET    | `/search`          | Tìm kiếm sản phẩm      | `q`: keyword, `page`, `limit`       |

### Cart APIs

| Method | Endpoint        | Description         | Parameters                        |
| ------ | --------------- | ------------------- | --------------------------------- |
| GET    | `/cart`         | Xem giỏ hàng        | -                                 |
| POST   | `/cart`         | Thêm vào giỏ        | `maSP`, `quantity`, `action=add`  |
| POST   | `/cart/update`  | Cập nhật số lượng   | `productId`, `quantity`, `action` |
| POST   | `/cart/remove`  | Xóa sản phẩm        | `productId`                       |
| POST   | `/cart/clear`   | Xóa toàn bộ giỏ     | -                                 |
| POST   | `/cart/voucher` | Áp dụng mã giảm giá | `voucherCode`                     |

### Order APIs

| Method | Endpoint        | Description       | Parameters                                             |
| ------ | --------------- | ----------------- | ------------------------------------------------------ |
| GET    | `/checkout`     | Trang thanh toán  | -                                                      |
| POST   | `/order/place`  | Đặt hàng          | `address`, `phone`, `note`, `paymentMethod`, `voucher` |
| GET    | `/orders`       | Đơn hàng của tôi  | -                                                      |
| GET    | `/order/{id}`   | Chi tiết đơn hàng | `id`: MaDonHang                                        |
| POST   | `/order/cancel` | Hủy đơn hàng      | `orderId`                                              |

### PC Builder APIs

| Method | Endpoint                  | Description               | Parameters                      |
| ------ | ------------------------- | ------------------------- | ------------------------------- |
| GET    | `/builder`                | Trang build PC            | -                               |
| POST   | `/builder`                | Thêm config vào giỏ       | `maSP[]` (array of product IDs) |
| GET    | `/api/builder/compatible` | Lấy linh kiện tương thích | `type`: component type          |

### Admin APIs

| Method | Endpoint                | Description             |
| ------ | ----------------------- | ----------------------- |
| GET    | `/admin/`               | Admin dashboard         |
| GET    | `/admin/products`       | Quản lý sản phẩm        |
| POST   | `/admin/product/add`    | Thêm sản phẩm mới       |
| PUT    | `/admin/product/update` | Cập nhật sản phẩm       |
| DELETE | `/admin/product/delete` | Xóa sản phẩm            |
| GET    | `/admin/orders`         | Quản lý đơn hàng        |
| PUT    | `/admin/order/status`   | Cập nhật trạng thái đơn |
| GET    | `/admin/accounts`       | Quản lý tài khoản       |
| GET    | `/admin/promotions`     | Quản lý khuyến mãi      |
| GET    | `/admin/reviews`        | Duyệt đánh giá          |

### User Profile APIs

| Method | Endpoint                   | Description        | Parameters                              |
| ------ | -------------------------- | ------------------ | --------------------------------------- |
| GET    | `/profile`                 | Trang cá nhân      | -                                       |
| PUT    | `/profile/update`          | Cập nhật thông tin | `fullname`, `email`, `phone`, `address` |
| PUT    | `/profile/change-password` | Đổi mật khẩu       | `oldPassword`, `newPassword`            |

---

## Frontend Pages

### User Pages

| Page            | URL             | Description                               |
| --------------- | --------------- | ----------------------------------------- |
| **Trang chủ**   | `/home`         | Hiển thị featured products, best sellers  |
| **Cửa hàng**    | `/shop`         | Danh sách sản phẩm với filter, pagination |
| **Chi tiết SP** | `/product/{id}` | Thông tin chi tiết, hình ảnh, reviews     |
| **Giỏ hàng**    | `/cart`         | Xem và chỉnh sửa giỏ hàng                 |
| **Thanh toán**  | `/checkout`     | Nhập thông tin giao hàng, chọn payment    |
| **PC Builder**  | `/builder`      | Tự build cấu hình máy tính                |
| **Đăng nhập**   | `/login`        | Form đăng nhập                            |
| **Đăng ký**     | `/register`     | Form đăng ký tài khoản mới                |
| **Hồ sơ**       | `/profile`      | Thông tin cá nhân, đơn hàng               |
| **Đơn hàng**    | `/orders`       | Lịch sử đơn hàng                          |
| **Liên hệ**     | `/contact`      | Form liên hệ                              |

### Admin Pages

| Page           | URL                 | Description               |
| -------------- | ------------------- | ------------------------- |
| **Dashboard**  | `/admin/`           | Thống kê, biểu đồ         |
| **Sản phẩm**   | `/admin/products`   | CRUD sản phẩm             |
| **Đơn hàng**   | `/admin/orders`     | Quản lý và xử lý đơn hàng |
| **Tài khoản**  | `/admin/accounts`   | Quản lý user và admin     |
| **Khuyến mãi** | `/admin/promotions` | Tạo và quản lý voucher    |
| **Đánh giá**   | `/admin/reviews`    | Duyệt/xóa reviews         |

---

## Luồng Nghiệp Vụ Chính

### 1. Luồng Mua Hàng (Purchase Flow)

```
1. XEM SẢN PHẨM
   User → /shop → ProductServlet → ProductService → ProductDAO → Database

2. XEM CHI TIẾT
   User → /product/{id} → ProductServlet → getProductDetail() → Display

3. THÊM VÀO GIỎ
   User → POST /cart (action=add) → CartServlet → CartService → CartDAO
   → Insert into CHI_TIET_GIO_HANG

4. XEM GIỎ HÀNG
   User → /cart → CartServlet → CartService → CartDAO → Display items

5. ÁP DỤNG VOUCHER (Optional)
   User → POST /cart/voucher → CartServlet → PromotionService
   → Validate voucher → Calculate discount → Store in session

6. THANH TOÁN
   User → /checkout → OrderServlet → Display checkout form

7. ĐẶT HÀNG
   User → POST /order/place → OrderServlet → OrderService.placeOrder()

   OrderService.placeOrder() Transaction Flow:
   ┌─────────────────────────────────────────────────────────────┐
   │ 1. Get cart items from GIO_HANG                             │
   │ 2. Calculate total (subtotal + shipping - discount)         │
   │ 3. Begin Transaction                                        │
   │    ├─ INSERT INTO DON_HANG (status='CHO_XAC_NHAN')          │
   │    ├─ INSERT INTO CHI_TIET_DON_HANG (for each item)         │
   │    ├─ UPDATE SAN_PHAM SET SoLuongTon -= qty (for each item) │
   │    ├─ INSERT INTO THANH_TOAN (status='CHUA_THANH_TOAN')     │
   │    ├─ DELETE FROM CHI_TIET_GIO_HANG (clear cart)            │
   │ 4. Commit Transaction                                       │
   └─────────────────────────────────────────────────────────────┘

8. XÁC NHẬN ĐƠN HÀNG
   Admin → /admin/orders → AdminOrderServlet → Update status
   → 'DA_XAC_NHAN' → 'DANG_GIAO' → 'DA_GIAO'
```

### 2. Luồng PC Builder

```
1. CHỌN LINH KIỆN
   User → /builder → PcBuilderServlet → Display builder interface

2. LỰA CHỌN TỪNG LOẠI
   - Chọn CPU → Hiển thị compatible Mainboards
   - Chọn Mainboard → Hiển thị compatible RAM, VGA
   - Chọn case → Check kích thước mainboard
   - Chọn PSU → Tính tổng công suất tiêu thụ

3. LƯU CẤU HÌNH
   User → POST /builder → PcBuilderServlet
   → Add all selected components to cart

4. THANH TOÁN
   → Same as purchase flow
```

### 3. Luồng Đăng Nhập/Đăng Ký

```
ĐĂNG KÝ:
User → /register → AuthServlet.doPost()
→ Validate input (username, password, email)
→ Hash password with BCrypt
→ INSERT INTO TAI_KHOAN (VaiTro='KHACH_HANG')
→ INSERT INTO KHACH_HANG
→ Auto login (create session)
→ Redirect to /home

ĐĂNG NHẬP:
User → /login → AuthServlet.doPost()
→ Query TAI_KHOAN by username
→ Verify password with BCrypt.checkpw()
→ Load user details (KHACH_HANG or QUAN_TRI_VIEN)
→ Create session with User object
→ Check role:
   ├─ 'KHACH_HANG' → Redirect to /home
   └─ 'QUAN_TRI_VIEN' → Redirect to /admin/
```

---

## Hướng Dẫn Setup

### Yêu Cầu Hệ Thống

- Java 21+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 11.x (hoặc Jakarta EE compatible server)

### Bước 1: Cài Đặt Database

```bash
# 1. Tạo database
mysql -u root -p < database/schema.sql

# 2. Nạp dữ liệu mẫu (optional)
mysql -u root -p ComputerSpace < database/Sample_data.sql
```

### Bước 2: Cấu Hình Database Connection

Sửa file `src/main/java/com/computerstore/utils/DBConnection.java`:

```java
config.setJdbcUrl("jdbc:mysql://localhost:3306/ComputerSpace");
config.setUsername("your_username");    // Thay bằng username của bạn
config.setPassword("your_password");    // Thay bằng password của bạn
```

### Bước 3: Build Project

```bash
# Clean and build
mvn clean package

# Skip tests (nếu có lỗi test)
mvn clean package -DskipTests
```

### Bước 4: Deploy lên Tomcat

```bash
# Copy WAR file to Tomcat webapps
cp target/computerstore.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh
```

### Bước 5: Truy Cập Ứng Dụng

```
http://localhost:8080/computerstore
```

### Bước 6: Đăng Nhập Admin (Mặc Định)

Sau khi chạy `Sample_data.sql`, có thể đăng nhập với:

- **Username**: `admin`
- **Password**: `admin123`

---

## Các Vấn Đề Cần Cải Thiện

### 🔴 Mức Độ Nghiêm Trọng Cao

#### 1. **Hard-coded Database Credentials** ⚠️ CRITICAL

**File**: `src/main/java/com/computerstore/utils/DBConnection.java`

```java
// Lines 18-21 - KHÔNG NÊN hard-code credentials
config.setUsername("root");
config.setPassword("123456");
```

**Giải pháp**: Sử dụng environment variables hoặc external config file

```java
// Nên dùng:
config.setUsername(System.getenv("DB_USERNAME"));
config.setPassword(System.getenv("DB_PASSWORD"));
```

#### 2. **Thiếu CSRF Protection**

Tất cả các form POST đều không có CSRF token, dễ bị tấn công Cross-Site Request Forgery.

**Giải pháp**: Thêm CSRF token vào tất cả forms và validate trong servlet filter.

#### 3. **Session Fixation**

Không có session regeneration sau khi login, dễ bị session fixation attack.

**Giải pháp**: Invalidate old session và create new session after successful login.

### 🟡 Mức Độ Trung Bình

#### 4. **Business Logic trong Controller**

```java
// CartServlet.java - Lines 131-146
// Logic tính shipping fee nên đưa vào Service
BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) >= 0
    ? BigDecimal.ZERO : new BigDecimal("30000");
```

**Giải pháp**: Di chuyển vào `CartService` hoặc `OrderService`.

#### 5. **Code Trùng Lặp**

Nhiều servlet có logic pagination tương tự:

```java
int offset = (page - 1) * limit;
```

**Giải pháp**: Tạo utility method hoặc base servlet.

#### 6. **Exception Handling Không Đồng Bộ**

- Có nơi throw `DatabaseException`
- Có nơi `printStackTrace()`
- Có nơi return `null` hoặc `-1`

**Giải pháp**: Chuẩn hóa exception handling strategy.

#### 7. **Thiếu Validation**

Nhiều nơi không validate input đầy đủ:

```java
int maSP = Integer.parseInt(req.getParameter("maSP")); // Có thể NFE
```

**Giải pháp**: Thêm validation layer.

### 🟢 Mức Độ Thấp

#### 8. **Typo trong URL**

```
/cheackout.jsp → Nên đổi thành /checkout.jsp
```

#### 9. **Thiếu JavaDoc**

Hầu hết các classes không có JavaDoc documentation.

**Giải pháp**: Thêm JavaDoc cho tất cả public methods.

#### 10. **Không có Unit Tests**

Không có test nào cho service layer hoặc DAO layer.

**Giải pháp**: Viết unit tests với JUnit 5.

#### 11. **Database Indexes**

Một số queries có thể chậm nếu dữ liệu lớn:

- `CHI_TIET_DON_HANG(MaSP)` - Đã có index ✓
- `DANH_GIA(MaSP)` - Đã có index ✓
- Thiếu index trên `DON_HANG(NgayDat)` cho queries theo ngày

### 📊 Performance Issues

#### 12. **N+1 Query Problem**

Trong `ProductDAO.extractProduct()`:

```java
// Query chính lấy products
// Sau đó riêng lẻ lấy TenLoaiSP nếu cần
try {
    p.setTenLoaiSP(rs.getString("TenLoaiSP"));
} catch (SQLException ignored) { }
```

**Giải pháp**: Luôn JOIN trong query chính.

#### 13. **Không có Caching**

Tất cả queries đều hit database, không có caching layer.

**Giải pháp**: Thêm Redis hoặc in-memory cache cho frequently accessed data.

---

## Phụ Lục

### A. Database Configuration Properties

File: `src/main/resources/database.properties`

```properties
db.url=jdbc:mysql://localhost:3306/ComputerSpace
db.username=root
db.password=123456
db.driver=com.mysql.cj.jdbc.Driver
```

### B. Environment Variables (Recommended)

```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=ComputerSpace
export DB_USERNAME=root
export DB_PASSWORD=your_secure_password
```

### C. Default Admin Account

Sau khi chạy `Sample_data.sql`:

- **Username**: `admin`
- **Password**: `admin123` (BCrypt hashed trong database)

### D. Product Categories (LOAI_SAN_PHAM)

| MaLoaiSP | TenLoaiSP | Description        |
| -------- | --------- | ------------------ |
| 1        | Mainboard | Bo mạch chủ        |
| 2        | CPU       | Bộ vi xử lý        |
| 3        | VGA       | Card đồ họa        |
| 4        | Case      | Vỏ máy tính        |
| 5        | Nguồn     | Bộ nguồn máy tính  |
| 6        | Tản nhiệt | Thiết bị tản nhiệt |
| 7        | Ổ cứng    | HDD/SSD            |
| 8        | RAM       | Bộ nhớ trong       |

### E. Order Status Flow

```
CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO
      ↓
   DA_HUY (Cancel at any point before DA_GIAO)
```

### F. Payment Status Flow

```
CHUA_THANH_TOAN → DA_THANH_TOAN
        ↓
    HOAN_TIEN (Refund)
```

---

## Kết Luận

Hệ thống ComputerStore có kiến trúc rõ ràng, code tương đối sạch và dễ bảo trì. Tuy nhiên, cần cải thiện về:

1. **Security**: CSRF protection, session management, input validation
2. **Performance**: Caching, query optimization, connection pooling config
3. **Code Quality**: Unit tests, JavaDoc, error handling standardization
4. **Configuration**: Externalize database credentials, use environment variables

**Tổng số files**: ~60 Java files, 13 database tables, 14 JSP pages
**Dòng code**: ~5,000+ lines of Java code
**Độ phức tạp**: Medium - Phù hợp cho đồ án môn học hoặc SME e-commerce

---

_Tài liệu này được tạo ngày: 2026-05-09_
_Phiên bản: 1.0_
