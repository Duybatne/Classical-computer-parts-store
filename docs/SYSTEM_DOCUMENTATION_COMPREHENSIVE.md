# ComputerStore - Tài Liệu Tổng Hợp Hệ Thống Backend & Kiến Thức Liên Quan

> **Phiên bản**: 1.0
> **Ngày tạo**: 2026-05-12
> **Công nghệ**: Java 21, Jakarta Servlet 6.1, MySQL 8.0, Tomcat 11

---

## MỤC LỤC

1. [Tổng Quan Hệ Thống](#1-tổng-quan-hệ-thống)
2. [Kiến Trúc Hệ Thống (Architecture)](#2-kiến-trúc-hệ-thống-architecture)
3. [Cơ Sở Dữ Liệu (Database Design)](#3-cơ-sở-dữ-liệu-database-design)
4. [Backend Source Code Chi Tiết](#4-backend-source-code-chi-tiết)
5. [Kiến Thức Java & Jakarta EE Liên Quan](#5-kiến-thức-java--jakarta-ee-liên-quan)
6. [Kiến Thức Database & SQL](#6-kiến-thức-database--sql)
7. [Luồng Nghiệp Vụ (Business Flows)](#7-luồng-nghiệp-vụ-business-flows)
8. [Security & Performance](#8-security--performance)
9. [Hướng Dẫn Setup & Deploy](#9-hướng-dẫn-setup--deploy)
10. [Các Vấn Đề Cần Cải Thiện](#10-các-vấn-đề-cần-cải-thiện)

---

## 1. TỔNG QUAN HỆ THỐNG

### 1.1. Giới Thiệu

**ComputerStore** là ứng dụng web thương mại điện tử (E-commerce) chuyên bán linh kiện máy tính, được xây dựng bằng Java với Jakarta Servlet và JSP, sử dụng MySQL làm cơ sở dữ liệu.

### 1.2. Chức Năng Chính

#### Người Dùng (Customer)

| Chức năng                | Mô tả                                                             |
| ------------------------ | ----------------------------------------------------------------- |
| 🛍️ **Mua sắm**           | Xem danh sách sản phẩm, lọc theo danh mục, tìm kiếm, xem chi tiết |
| 🛒 **Giỏ hàng**          | Thêm, sửa số lượng, xóa sản phẩm, áp dụng voucher                 |
| 🖥️ **PC Builder**        | Tự build cấu hình máy tính với kiểm tra tương thích               |
| 💳 **Thanh toán**        | Đặt hàng với nhiều phương thức (COD, Chuyển khoản, Ví điện tử)    |
| 🎫 **Khuyến mãi**        | Áp dụng mã giảm giá, xem chương trình khuyến mãi                  |
| ⭐ **Đánh giá**          | Review và rating sản phẩm (1-5 sao)                               |
| 👤 **Quản lý tài khoản** | Đăng ký, đăng nhập, cập nhật thông tin, đổi mật khẩu              |

#### Quản Trị Viên (Admin)

| Chức năng                 | Mô tả                                     |
| ------------------------- | ----------------------------------------- |
| 📊 **Dashboard**          | Thống kê doanh thu, đơn hàng, biểu đồ     |
| 📦 **Quản lý sản phẩm**   | CRUD sản phẩm, quản lý hình ảnh, danh mục |
| 📋 **Quản lý đơn hàng**   | Xem, xử lý, cập nhật trạng thái đơn hàng  |
| 👥 **Quản lý tài khoản**  | Quản lý người dùng và admin               |
| 🏷️ **Quản lý khuyến mãi** | Tạo voucher, chương trình giảm giá        |
| 💬 **Duyệt đánh giá**     | Kiểm duyệt reviews sản phẩm               |

### 1.3. Công Nghệ Sử Dụng

| Layer                | Công Nghệ         | Phiên Bản      | Mục Đích                               |
| -------------------- | ----------------- | -------------- | -------------------------------------- |
| **Ngôn ngữ**         | Java              | 21             | Lập trình backend chính                |
| **Web Framework**    | Jakarta Servlet   | 6.1            | Xử lý request/response HTTP            |
| **View Template**    | JSP + JSTL        | 4.0 / 3.0      | Render giao diện người dùng            |
| **Template Engine**  | Thymeleaf         | 3.1.5.RELEASE  | Template engine (chưa dùng, đã import) |
| **Database**         | MySQL             | 8.0            | Lưu trữ dữ liệu                        |
| **Connection Pool**  | HikariCP          | 5.1.0          | Quản lý kết nối database               |
| **ORM**              | JDBC trực tiếp    | -              | Truy vấn database thuần                |
| **Password Hashing** | jBCrypt           | 0.4            | Mã hóa mật khẩu                        |
| **JSON Processing**  | Gson              | 2.10.1         | Serialize/Deserialize JSON             |
| **Logging**          | SLF4J + Simple    | 2.0.12         | Ghi log ứng dụng                       |
| **Caching Client**   | Jedis (Redis)     | 4.3.1          | Redis client (chưa dùng, đã import)    |
| **Build Tool**       | Maven             | 3.6+           | Build & quản lý dependency             |
| **Web Server**       | Tomcat            | 11.x           | Chạy ứng dụng                          |
| **Testing**          | JUnit 5 + Mockito | 5.10.0 / 5.5.0 | Unit test                              |

### 1.4. Thống Kê Dự Án

| Thành Phần                 | Số Lượng      |
| -------------------------- | ------------- |
| **Java files**             | ~68 files     |
| **Database tables**        | 15 tables     |
| **Controllers (Servlets)** | 17 files      |
| **Services**               | 9 files       |
| **DAOs**                   | 14 files      |
| **Models**                 | 15 files      |
| **Filters**                | 4 files       |
| **Utilities**              | 2 files       |
| **JSP Pages**              | ~14 pages     |
| **Dòng code Java**         | ~5,000+ lines |

---

## 2. KIẾN TRÚC HỆ THỐNG (ARCHITECTURE)

### 2.1. Mô Hình 3 Lớp (3-Tier Architecture)

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                            │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │                   View (JSP + JSTL)                           │    │
│   │  • index.jsp     • shop.jsp       • product-detail.jsp        │    │
│   │  • cart.jsp      • checkout.jsp   • builder.jsp              │    │
│   │  • login.jsp     • register.jsp   • profile.jsp              │    │
│   │  • admin/*.jsp                                               │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                           ↕ HTTP (GET/POST)                          │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                       CONTROLLER LAYER                               │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │                  Servlet Controllers                          │    │
│   │  ┌────────────────────────────────────────────────────────┐  │    │
│   │  │  User Servlets (11)                                    │  │    │
│   │  │  • AuthServlet          • CartServlet                  │  │    │
│   │  │  • ProductServlet       • HomeServlet                  │  │    │
│   │  │  • OrderServlet         • ProfileServlet               │  │    │
│   │  │  • ContactServlet       • PromotionServlet             │  │    │
│   │  │  • ReviewServlet        • PcBuilderServlet             │  │    │
│   │  └────────────────────────────────────────────────────────┘  │    │
│   │  ┌────────────────────────────────────────────────────────┐  │    │
│   │  │  Admin Servlets (6)                                    │  │    │
│   │  │  • AdminAccountServlet  • AdminProductServlet          │  │    │
│   │  │  • AdminOrderServlet    • AdminPromotionServlet        │  │    │
│   │  │  • AdminReviewServlet   • AdminStatsServlet            │  │    │
│   │  └────────────────────────────────────────────────────────┘  │    │
│   │  ┌────────────────────────────────────────────────────────┐  │    │
│   │  │  API Servlet (1)                                       │  │    │
│   │  │  • PcBuilderApiServlet                                 │  │    │
│   │  └────────────────────────────────────────────────────────┘  │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                           ↕ Method Calls                              │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                        SERVICE LAYER                                  │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │                  Business Logic Services                      │    │
│   │  ┌────────────────────────────────────────────────────────┐  │    │
│   │  │  • ProductService     • CartService                    │  │    │
│   │  │  • OrderService       • UserService                    │  │    │
│   │  │  • PaymentService     • PcBuilderService               │  │    │
│   │  │  • PromotionService   • ReviewService                  │  │    │
│   │  │  • StatsService                                        │  │    │
│   │  └────────────────────────────────────────────────────────┘  │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                           ↕ Method Calls                              │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         DAO LAYER                                    │
│                    (Data Access Objects)                              │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │  ┌────────────────────────────────────────────────────────┐  │    │
│   │  │  • ProductDAO        • OrderDAO        • CartDAO       │  │    │
│   │  │  • UserDAO           • CategoryDAO     • PaymentDAO    │  │    │
│   │  │  • ReviewDAO         • StatsDAO        • PromotionDAO  │  │    │
│   │  │  • OrderDetailDAO    • ProductImageDAO                 │  │    │
│   │  │  • ComponentDetailDAO• PcBuilderDAO                    │  │    │
│   │  │  • PromotionProductDAO                                 │  │    │
│   │  └────────────────────────────────────────────────────────┘  │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                           ↕ JDBC / SQL                                │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                       DATABASE LAYER                                  │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │              MySQL 8.0 (Database: ComputerSpace)              │    │
│   │            HikariCP Connection Pool (max 10)                  │    │
│   └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2. Cấu Trúc Thư Mục Chi Tiết

```
BTL_eco/                                    # Source code gốc
├── pom.xml                                 # Maven POM (Jakarta EE 10, Java 21)
├── src/
│   └── main/
│       ├── java/com/computerstore/
│       │   ├── controllers/                # Servlets (11 files)
│       │   │   ├── admin/                  # Admin servlets (6 files)
│       │   │   └── api/                    # API servlets (1 file)
│       │   ├── services/                   # Business logic (9 files)
│       │   ├── dao/                        # Data Access Objects (14 files)
│       │   ├── models/                     # Entity/Model classes (15 files)
│       │   ├── dto/                        # Data Transfer Objects (1 file)
│       │   ├── exceptions/                 # Custom exceptions (1 file)
│       │   ├── filters/                    # Servlet filters (4 files)
│       │   └── utils/                      # Utilities (2 files)
│       ├── resources/
│       │   └── database.properties         # DB connection config
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml                 # Deployment descriptor
│           │   └── tags/                   # Custom JSP tags
│           ├── jsp/                        # JSP view pages
│           │   └── admin/                  # Admin JSP pages
│           ├── css/                        # Stylesheets
│           ├── js/                         # JavaScript files
│           └── images/                     # Static images
└── database/
    ├── schema.sql                          # Database schema (DDL)
    ├── Sample_data.sql                     # Sample data (DML)
    ├── Extend_Data.sql                     # Extended data
    └── migrations/                         # Database migrations
        ├── v1-initial.sql
        ├── v2-add-reviews.sql
        └── v3-add-indexes.sql
```

### 2.3. Luồng Xử Lý Request (Request Lifecycle)

```
Trình duyệt (Browser)
    │
    ▼
HTTP Request (GET/POST)
    │
    ▼
Tomcat Web Server (port 8080)
    │
    ▼
┌──────────────────────────────────────────────────────┐
│                   Filter Chain                        │
│                                                       │
│ 1. EncodingFilter (UTF-8)                             │
│    → Set request encoding thành UTF-8                │
│                                                       │
│ 2. AuthenticationFilter                               │
│    → Kiểm tra session, user đăng nhập                │
│    → Nếu chưa đăng nhập → redirect /login            │
│                                                       │
│ 3. AdminFilter (/admin/*)                             │
│    → Kiểm tra vai trò QUAN_TRI_VIEN                  │
│    → Nếu không phải admin → 403 Forbidden             │
│                                                       │
│ 4. CategoryFilter                                     │
│    → Load danh mục sản phẩm vào request attributes    │
│                                                       │
└──────────────────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────────────────────────┐
│               Servlet (Controller)                    │
│                                                       │
│ • doGet()   → Xử lý GET request                      │
│ • doPost()  → Xử lý POST request                     │
│                                                       │
│ Gọi Service Layer để xử lý business logic            │
└──────────────────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────────────────────────┐
│               JSP (View)                              │
│                                                       │
│ • Nhận dữ liệu từ request attributes                  │
│ • Render HTML với JSTL tags                           │
│ • Gửi response về trình duyệt                         │
└──────────────────────────────────────────────────────┘
    │
    ▼
HTTP Response (HTML)
    │
    ▼
Trình duyệt hiển thị
```

---

## 3. CƠ SỞ DỮ LIỆU (DATABASE DESIGN)

### 3.1. Database: ComputerSpace

- **Charset**: `utf8mb4` (hỗ trợ Unicode đầy đủ, bao gồm emoji)
- **Collation**: `utf8mb4_unicode_ci`
- **Storage Engine**: InnoDB (hỗ trợ transaction, foreign keys)

### 3.2. Sơ Đồ Quan Hệ (ER Diagram)

```
┌──────────────────┐       ┌──────────────────┐
│    TAI_KHOAN      │       │  LOAI_SAN_PHAM   │
│──────────────────│       │──────────────────│
│ PK MaTK (INT)    │       │ PK MaLoaiSP (INT)│
│    TenDangNhap   │       │    TenLoaiSP     │
│    MatKhau (hash)│       │    MoTa          │
│    VaiTro (Enum) │       └──────────────────┘
│    TrangThai     │                │ 1
│    NgayTao       │                │
│    NgayDangNhapCuoi              │
└──────────────────┘                │
    │ 1                             │
    │                               │
    ├───────────────────────────────┤
    │                               │
    ▼ 1                             ▼ N
┌──────────────────┐  ┌─────────────────────────────┐
│   KHACH_HANG     │  │       SAN_PHAM               │
│──────────────────│  │─────────────────────────────│
│ PK MaKH (INT)    │  │ PK MaSP (INT)               │
│ FK MaTK (UNIQUE) │  │ FK MaLoaiSP (INT)           │
│    HoTen         │  │    TenSP (VARCHAR 255)       │
│    SDT (UNIQUE)  │  │    ThuongHieu               │
│    Email (UNIQUE)│  │    GiaBan (DECIMAL 15,2)     │
│    DiaChi        │  │    SoLuongTon (INT)          │
└──────────────────┘  │    BaoHanhThang (INT)        │
                       │    MoTaNgan (TEXT)           │
┌──────────────────┐  │    MoTaChiTiet (LONGTEXT)     │
│  QUAN_TRI_VIEN   │  │    TrangThai (TINYINT)        │
│──────────────────│  │    NgayTao (DATETIME)          │
│ PK MaNV (INT)    │  │    NgayCapNhat (DATETIME)     │
│ FK MaTK (UNIQUE) │  └─────────────────────────────┘
│    HoTen         │           │ 1
│    SDT (UNIQUE)  │           │
│    Email (UNIQUE)│           ├──┬──────────────────────────────┐
│    ChucVu        │           │  │                              │
└──────────────────┘           ▼  ▼                              ▼
                     ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
                     │ ANH_SAN_PHAM     │  │  CHI_TIET_*      │  │   GIO_HANG       │
                     │──────────────────│  │ (8 tables)       │  │──────────────────│
                     │ PK MaAnh (INT)   │  │ PK MaSP (FK)     │  │ PK MaGioHang     │
                     │ FK MaSP          │  │ (chi tiết riêng) │  │ FK MaKH (UNIQUE) │
                     │    DuongDanAnh   │  └──────────────────┘  │    NgayCapNhat   │
                     │    LaAnhDaiDien  │                        └──────────────────┘
                     └──────────────────┘                                 │ 1
                                                                          │
                                                                          ▼ N
                    ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────────┐
                    │   DON_HANG       │  │   KHUYEN_MAI     │  │ CHI_TIET_GIO_HANG    │
                    │──────────────────│  │──────────────────│  │──────────────────────│
                    │ PK MaDonHang     │  │ PK MaKM (INT)    │  │ PK MaGioHang (FK)    │
                    │ FK MaKH          │  │    TenKM         │  │ PK MaSP (FK)         │
                    │ FK MaNV (NULL)   │  │    LoaiGiam(Enum)│  │    SoLuong (INT)     │
                    │ FK MaKM (NULL)   │  │    GiaTriGiam    │  │    DonGia (DECIMAL)  │
                    │    NgayDat       │  │    NgayBatDau    │  └──────────────────────┘
                    │    TongTien      │  │    NgayKetThuc   │
                    │    PhiVanChuyen  │  │    TrangThai     │
                    │    TrangThai(Enum)│  │ FK MaNV (NULL)  │
                    │    DiaChiNhan    │  └──────────────────┘
                    │    SDTNhan       │           │ 1
                    │    GhiChu        │           │
                    └──────────────────┘           ▼ N
                           │ 1          ┌──────────────────┐
                           │            │ KHUYEN_MAI_SP    │
                           ▼ N          │──────────────────│
                    ┌──────────────────┐│ PK MaKM (FK)     │
                    │ CHI_TIET_DON_HANG ││ PK MaSP (FK)     │
                    │──────────────────│└──────────────────┘
                    │ PK MaDonHang (FK)│
                    │ PK MaSP (FK)     │  ┌──────────────────┐
                    │    SoLuong (INT) │  │   DANH_GIA       │
                    │    DonGia(DECIMAL)│  │──────────────────│
                    │    ThanhTien     │  │ PK MaDG (INT)    │
                    └──────────────────┘  │ FK MaKH          │
                                          │ FK MaSP          │
                    ┌──────────────────┐  │    SoSao (1-5)   │
                    │   THANH_TOAN     │  │    NoiDung (TEXT)│
                    │──────────────────│  │    NgayDanhGia   │
                    │ PK MaThanhToan   │  │    TrangThaiDuyet │
                    │ FK MaDonHang(UNI)│  │ UNIQUE(MaKH,MaSP)│
                    │ FK MaPTTT        │  └──────────────────┘
                    │    SoTien        │
                    │    TrangThai(Enum)│
                    │    MaGiaoDich    │  ┌──────────────────┐
                    │    TenNganHang   │  │ PHUONG_THUC_TT   │
                    └──────────────────┘  │──────────────────│
                           │              │ PK MaPTTT (INT)  │
                           ▼              │    TenPTTT       │
                    ┌──────────────────┐  │    MoTa          │
                    │  P.THUC THANH    │  │    TrangThai     │
                    │      TOAN        │  └──────────────────┘
                    └──────────────────┘
```

### 3.3. Chi Tiết Các Bảng

#### 3.3.1. Nhóm Quản Lý Người Dùng (3 tables)

##### Bảng: TAI_KHOAN (Accounts)

| Column           | Type                                | Constraints               | Mô tả                  |
| ---------------- | ----------------------------------- | ------------------------- | ---------------------- |
| MaTK             | INT                                 | PK, AUTO_INCREMENT        | Mã tài khoản           |
| TenDangNhap      | VARCHAR(50)                         | NOT NULL, UNIQUE          | Tên đăng nhập          |
| MatKhau          | VARCHAR(255)                        | NOT NULL                  | Mật khẩu (BCrypt hash) |
| VaiTro           | ENUM('KHACH_HANG', 'QUAN_TRI_VIEN') | NOT NULL                  | Vai trò người dùng     |
| TrangThai        | TINYINT                             | DEFAULT 1                 | 1: Active, 0: Inactive |
| NgayTao          | DATETIME                            | DEFAULT CURRENT_TIMESTAMP | Ngày tạo tài khoản     |
| NgayDangNhapCuoi | DATETIME                            | NULL                      | Lần đăng nhập cuối     |

##### Bảng: KHACH_HANG (Customers)

| Column | Type         | Constraints                            | Mô tả              |
| ------ | ------------ | -------------------------------------- | ------------------ |
| MaKH   | INT          | PK, AUTO_INCREMENT                     | Mã khách hàng      |
| MaTK   | INT          | NOT NULL, UNIQUE, FK → TAI_KHOAN(MaTK) | Liên kết tài khoản |
| HoTen  | VARCHAR(100) | NOT NULL                               | Họ và tên          |
| SDT    | VARCHAR(15)  | UNIQUE                                 | Số điện thoại      |
| Email  | VARCHAR(100) | UNIQUE                                 | Email              |
| DiaChi | VARCHAR(255) |                                        | Địa chỉ            |

##### Bảng: QUAN_TRI_VIEN (Admins)

| Column | Type         | Constraints                            | Mô tả              |
| ------ | ------------ | -------------------------------------- | ------------------ |
| MaNV   | INT          | PK, AUTO_INCREMENT                     | Mã nhân viên       |
| MaTK   | INT          | NOT NULL, UNIQUE, FK → TAI_KHOAN(MaTK) | Liên kết tài khoản |
| HoTen  | VARCHAR(100) | NOT NULL                               | Họ và tên          |
| SDT    | VARCHAR(15)  | UNIQUE                                 | Số điện thoại      |
| Email  | VARCHAR(100) | UNIQUE                                 | Email              |
| ChucVu | VARCHAR(100) |                                        | Chức vụ            |

#### 3.3.2. Nhóm Quản Lý Sản Phẩm (11 tables)

##### Bảng: LOAI_SAN_PHAM (Categories)

| Column    | Type         | Constraints        | Mô tả                               |
| --------- | ------------ | ------------------ | ----------------------------------- |
| MaLoaiSP  | INT          | PK, AUTO_INCREMENT | Mã loại sản phẩm                    |
| TenLoaiSP | VARCHAR(100) | NOT NULL, UNIQUE   | Tên loại ('CPU', 'VGA', 'RAM', ...) |
| MoTa      | TEXT         |                    | Mô tả                               |

**8 loại sản phẩm**: Mainboard, CPU, VGA, Case, Nguồn, Tản nhiệt, Ổ cứng, RAM

##### Bảng: SAN_PHAM (Products) - Bảng trung tâm

| Column       | Type          | Constraints                  | Mô tả                         |
| ------------ | ------------- | ---------------------------- | ----------------------------- |
| MaSP         | INT           | PK, AUTO_INCREMENT           | Mã sản phẩm                   |
| TenSP        | VARCHAR(255)  | NOT NULL                     | Tên sản phẩm (FULLTEXT INDEX) |
| MaLoaiSP     | INT           | NOT NULL, FK → LOAI_SAN_PHAM | Loại sản phẩm                 |
| ThuongHieu   | VARCHAR(100)  |                              | Thương hiệu (INDEX)           |
| GiaBan       | DECIMAL(15,2) | NOT NULL DEFAULT 0           | Giá bán                       |
| SoLuongTon   | INT           | NOT NULL DEFAULT 0           | Số lượng tồn kho              |
| BaoHanhThang | INT           | NOT NULL DEFAULT 0           | Bảo hành (tháng)              |
| MoTaNgan     | TEXT          |                              | Mô tả ngắn                    |
| MoTaChiTiet  | LONGTEXT      |                              | Mô tả chi tiết                |
| TrangThai    | TINYINT       | DEFAULT 1                    | 1: Hiển thị, 0: Ẩn            |
| NgayTao      | DATETIME      | DEFAULT CURRENT_TIMESTAMP    | Ngày tạo                      |
| NgayCapNhat  | DATETIME      | ON UPDATE CURRENT_TIMESTAMP  | Ngày cập nhật                 |

##### Bảng: ANH_SAN_PHAM (Product Images)

| Column       | Type         | Constraints                                     | Mô tả           |
| ------------ | ------------ | ----------------------------------------------- | --------------- |
| MaAnh        | INT          | PK, AUTO_INCREMENT                              | Mã ảnh          |
| MaSP         | INT          | NOT NULL, FK → SAN_PHAM(MaSP) ON DELETE CASCADE | Sản phẩm        |
| DuongDanAnh  | VARCHAR(255) | NOT NULL                                        | Đường dẫn ảnh   |
| LaAnhDaiDien | TINYINT      | DEFAULT 0                                       | 1: Ảnh đại diện |

##### 8 Bảng Chi Tiết Linh Kiện (Component Detail Tables)

Mỗi bảng có MaSP là PRIMARY KEY và FOREIGN KEY → SAN_PHAM(MaSP) ON DELETE CASCADE

**CHI_TIET_MAIN** (Mainboard Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| Chipset | VARCHAR(100) | Chipset (VD: B650, Z790) |
| Socket | VARCHAR(50) | Socket (VD: LGA1700, AM5) |
| KichThuocMain | VARCHAR(50) | Kích thước (VD: ATX, Micro-ATX) |
| HoTroCPU | VARCHAR(255) | CPU hỗ trợ |
| SoKheRam | INT | Số khe RAM |
| LoaiRam | VARCHAR(50) | Loại RAM (VD: DDR5) |
| DungLuongRamToiDa | VARCHAR(50) | Dung lượng RAM tối đa |
| KhePCIe | VARCHAR(100) | Khe PCI Express |
| SoCongSATA | INT | Số cổng SATA |
| SoKheM2 | INT | Số khe M.2 |
| CongXuatHinh | VARCHAR(255) | Cổng xuất hình |

**CHI_TIET_CPU** (CPU Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| HangCPU | VARCHAR(100) | Hãng (Intel/AMD) |
| DongCPU | VARCHAR(100) | Dòng (Core i7, Ryzen 7) |
| Socket | VARCHAR(50) | Socket tương thích |
| SoNhan | INT | Số nhân (cores) |
| SoLuongLuong | INT | Số luồng (threads) |
| XungNhipCoBan | VARCHAR(50) | Xung nhịp cơ bản |
| XungNhipTurbo | VARCHAR(50) | Xung nhịp turbo |
| CacheL1, CacheL2 | VARCHAR(50) | Cache L1, L2 |
| TDP | VARCHAR(50) | Công suất tiêu thụ (Watt) |
| CoGPU | TINYINT | Có GPU tích hợp? |

**CHI_TIET_VGA** (VGA/GPU Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| HangGPU | VARCHAR(100) | Hãng GPU (NVIDIA/AMD) |
| DungLuongVRAM | VARCHAR(50) | Dung lượng VRAM |
| KieuBoNho | VARCHAR(50) | Kiểu bộ nhớ (GDDR6/GDDR6X) |
| BusBoNho | VARCHAR(50) | Bus bộ nhớ (256-bit) |
| XungNhip | VARCHAR(50) | Xung nhịp |
| TDP | VARCHAR(50) | Công suất tiêu thụ |
| CongKetNoi | VARCHAR(255) | Cổng kết nối (HDMI, DP) |
| SoQuat | INT | Số quạt |
| KichThuocCard | VARCHAR(100) | Kích thước card |
| DauCapNguon | VARCHAR(100) | Đầu cấp nguồn |

**CHI_TIET_RAM** (RAM Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| LoaiRam | VARCHAR(50) | Loại (DDR4/DDR5) |
| DungLuong | VARCHAR(50) | Dung lượng (16GB, 32GB) |
| BusRam | VARCHAR(50) | Bus (3200MHz, 6000MHz) |
| DienAp | VARCHAR(50) | Điện áp (1.35V) |
| SoThanh | INT | Số thanh trong kit |

**CHI_TIET_O_CUNG** (Storage Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| LoaiOCung | VARCHAR(50) | Loại (HDD/SSD/NVMe) |
| DungLuong | VARCHAR(50) | Dung lượng (500GB, 2TB) |
| ChuanKetNoi | VARCHAR(50) | Chuẩn kết nối (SATA III, PCIe 4.0) |
| KichCo | VARCHAR(50) | Kích cỡ (2.5", M.2 2280) |
| TocDoDocGhi | VARCHAR(100) | Tốc độ đọc/ghi |

**CHI_TIET_CASE** (Case Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| HoTroMain | VARCHAR(100) | Mainboard hỗ trợ (ATX, E-ATX) |
| MauSac | VARCHAR(50) | Màu sắc |
| ChatLieu | VARCHAR(100) | Chất liệu (Steel, Tempered Glass) |
| KichThuoc | VARCHAR(100) | Kích thước |
| HoTroNguon | VARCHAR(100) | Nguồn hỗ trợ |
| SoLuongQuatHoTro | INT | Số quạt hỗ trợ |
| CoKinhCuongLuc | TINYINT | Có kính cường lực? |
| CongTruocCase | VARCHAR(255) | Cổng trước case |

**CHI_TIET_NGUON** (PSU Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| CongSuat | VARCHAR(50) | Công suất (750W, 1000W) |
| Chuan80Plus | VARCHAR(50) | Chuẩn 80 Plus (Gold, Platinum) |
| CongKetNoi | VARCHAR(255) | Cổng kết nối |
| KichThuocNguon | VARCHAR(100) | Kích thước (ATX, SFX) |
| DienApVao | VARCHAR(100) | Điện áp đầu vào |
| DauCapNguon | VARCHAR(255) | Đầu cáp nguồn |

**CHI_TIET_TAN_NHIET** (Cooler Details)
| Column | Type | Mô tả |
|--------|------|-------|
| MaSP | INT (PK, FK) | Mã sản phẩm |
| LoaiTanNhiet | VARCHAR(100) | Loại tản nhiệt (Air/Liquid) |
| TuongThichCPU | VARCHAR(255) | CPU tương thích |
| KichThuocRadiator | VARCHAR(100) | Kích thước Radiator (240/360mm) |
| SoQuat | INT | Số quạt |
| TocDoQuat | VARCHAR(50) | Tốc độ quạt (RPM) |
| DoOn | VARCHAR(50) | Độ ồn (dB) |
| LED | VARCHAR(50) | LED (RGB/ARGB/None) |
| KichThuocTan | VARCHAR(100) | Kích thước tản |

#### 3.3.3. Nhóm Giỏ Hàng & Đơn Hàng (4 tables)

##### Bảng: GIO_HANG (Carts)

| Column      | Type     | Constraints                             | Mô tả             |
| ----------- | -------- | --------------------------------------- | ----------------- |
| MaGioHang   | INT      | PK, AUTO_INCREMENT                      | Mã giỏ hàng       |
| MaKH        | INT      | NOT NULL, UNIQUE, FK → KHACH_HANG(MaKH) | 1 KH chỉ có 1 giỏ |
| NgayCapNhat | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE     | Ngày cập nhật     |

##### Bảng: CHI_TIET_GIO_HANG (Cart Items)

| Column    | Type          | Constraints                                    | Mô tả                  |
| --------- | ------------- | ---------------------------------------------- | ---------------------- |
| MaGioHang | INT           | PK, FK → GIO_HANG(MaGioHang) ON DELETE CASCADE | Giỏ hàng               |
| MaSP      | INT           | PK, FK → SAN_PHAM(MaSP) ON DELETE CASCADE      | Sản phẩm               |
| SoLuong   | INT           | DEFAULT 1                                      | Số lượng               |
| DonGia    | DECIMAL(15,2) | DEFAULT 0                                      | Giá tại thời điểm thêm |

##### Bảng: DON_HANG (Orders)

| Column           | Type          | Constraints                     | Mô tả               |
| ---------------- | ------------- | ------------------------------- | ------------------- |
| MaDonHang        | INT           | PK, AUTO_INCREMENT              | Mã đơn hàng         |
| MaKH             | INT           | NOT NULL, FK → KHACH_HANG(MaKH) | Khách hàng          |
| MaNV             | INT           | NULL, FK → QUAN_TRI_VIEN(MaNV)  | Admin xử lý         |
| MaKM             | INT           | NULL, FK → KHUYEN_MAI(MaKM)     | Mã khuyến mãi       |
| NgayDat          | DATETIME      | DEFAULT CURRENT_TIMESTAMP       | Ngày đặt            |
| DiaChiNhan       | VARCHAR(255)  | NOT NULL                        | Địa chỉ giao hàng   |
| SDTNhan          | VARCHAR(15)   | NOT NULL                        | SĐT người nhận      |
| TongTien         | DECIMAL(15,2) | DEFAULT 0                       | Tổng tiền           |
| PhiVanChuyen     | DECIMAL(15,2) | DEFAULT 0                       | Phí vận chuyển      |
| TrangThaiDonHang | ENUM          | DEFAULT 'CHO_XAC_NHAN'          | Trạng thái đơn hàng |
| GhiChu           | TEXT          |                                 | Ghi chú             |

**Trạng thái đơn hàng**: `CHO_XAC_NHAN` → `DA_XAC_NHAN` → `DANG_GIAO` → `DA_GIAO` | `DA_HUY`

##### Bảng: CHI_TIET_DON_HANG (Order Items)

| Column    | Type          | Constraints                  | Mô tả                 |
| --------- | ------------- | ---------------------------- | --------------------- |
| MaDonHang | INT           | PK, FK → DON_HANG(MaDonHang) | Đơn hàng              |
| MaSP      | INT           | PK, FK → SAN_PHAM(MaSP)      | Sản phẩm              |
| SoLuong   | INT           | NOT NULL                     | Số lượng              |
| DonGia    | DECIMAL(15,2) | NOT NULL                     | Giá tại thời điểm mua |
| ThanhTien | DECIMAL(15,2) | NOT NULL                     | = DonGia × SoLuong    |

#### 3.3.4. Nhóm Thanh Toán (2 tables)

##### Bảng: PHUONG_THUC_THANH_TOAN (Payment Methods)

| Column    | Type         | Constraints        | Mô tả                               |
| --------- | ------------ | ------------------ | ----------------------------------- |
| MaPTTT    | INT          | PK, AUTO_INCREMENT | Mã phương thức                      |
| TenPTTT   | VARCHAR(100) | NOT NULL, UNIQUE   | 'COD', 'Chuyển khoản', 'Ví điện tử' |
| MoTa      | TEXT         |                    | Mô tả                               |
| TrangThai | TINYINT      | DEFAULT 1          | 1: Active                           |

##### Bảng: THANH_TOAN (Payments)

| Column             | Type          | Constraints                           | Mô tả                     |
| ------------------ | ------------- | ------------------------------------- | ------------------------- |
| MaThanhToan        | INT           | PK, AUTO_INCREMENT                    | Mã thanh toán             |
| MaDonHang          | INT           | NOT NULL, UNIQUE, FK → DON_HANG       | 1 đơn hàng = 1 thanh toán |
| MaPTTT             | INT           | NOT NULL, FK → PHUONG_THUC_THANH_TOAN | Phương thức thanh toán    |
| SoTien             | DECIMAL(15,2) | NOT NULL                              | Số tiền                   |
| ThoiGianThanhToan  | DATETIME      | DEFAULT CURRENT_TIMESTAMP             | Thời gian                 |
| TrangThaiThanhToan | ENUM          | DEFAULT 'CHUA_THANH_TOAN'             | Trạng thái                |
| MaGiaoDich         | VARCHAR(100)  |                                       | Mã giao dịch              |
| TenNganHang        | VARCHAR(100)  |                                       | Tên ngân hàng             |

**Trạng thái thanh toán**: `CHUA_THANH_TOAN` → `DA_THANH_TOAN` | `HOAN_TIEN`

#### 3.3.5. Nhóm Khuyến Mãi (2 tables)

##### Bảng: KHUYEN_MAI (Promotions)

| Column      | Type                         | Constraints                    | Mô tả            |
| ----------- | ---------------------------- | ------------------------------ | ---------------- |
| MaKM        | INT                          | PK, AUTO_INCREMENT             | Mã khuyến mãi    |
| TenKM       | VARCHAR(150)                 | NOT NULL                       | Tên chương trình |
| LoaiGiam    | ENUM('PHAN_TRAM', 'SO_TIEN') | NOT NULL                       | Loại giảm giá    |
| GiaTriGiam  | DECIMAL(15,2)                | DEFAULT 0                      | Giá trị giảm     |
| NgayBatDau  | DATETIME                     | NOT NULL                       | Ngày bắt đầu     |
| NgayKetThuc | DATETIME                     | NOT NULL                       | Ngày kết thúc    |
| TrangThai   | TINYINT                      | DEFAULT 1                      | 1: Active        |
| MaNV        | INT                          | NULL, FK → QUAN_TRI_VIEN(MaNV) | Người tạo        |

##### Bảng: KHUYEN_MAI_SAN_PHAM (Promotion-Product mapping)

| Column | Type | Constraints                                 |
| ------ | ---- | ------------------------------------------- |
| MaKM   | INT  | PK, FK → KHUYEN_MAI(MaKM) ON DELETE CASCADE |
| MaSP   | INT  | PK, FK → SAN_PHAM(MaSP) ON DELETE CASCADE   |

#### 3.3.6. Nhóm Đánh Giá (1 table)

##### Bảng: DANH_GIA (Reviews)

| Column             | Type     | Constraints                     | Mô tả                      |
| ------------------ | -------- | ------------------------------- | -------------------------- |
| MaDG               | INT      | PK, AUTO_INCREMENT              | Mã đánh giá                |
| MaKH               | INT      | NOT NULL, FK → KHACH_HANG(MaKH) | Người đánh giá             |
| MaSP               | INT      | NOT NULL, FK → SAN_PHAM(MaSP)   | Sản phẩm                   |
| SoSao              | TINYINT  | NOT NULL (1-5)                  | Số sao                     |
| NoiDung            | TEXT     |                                 | Nội dung đánh giá          |
| NgayDanhGia        | DATETIME | DEFAULT CURRENT_TIMESTAMP       | Ngày đánh giá              |
| TrangThaiDuyet     | TINYINT  | DEFAULT 0                       | 0: Chờ duyệt, 1: Đã duyệt  |
| UNIQUE(MaKH, MaSP) |          |                                 | 1 KH chỉ đánh giá 1 lần/SP |

### 3.4. Các Index Quan Trọng

```sql
-- SAN_PHAM
CREATE INDEX IDX_SAN_PHAM_MaLoaiSP ON SAN_PHAM(MaLoaiSP);
CREATE FULLTEXT INDEX IDX_SAN_PHAM_TenSP ON SAN_PHAM(TenSP);  -- Fulltext search
CREATE INDEX IDX_SAN_PHAM_ThuongHieu ON SAN_PHAM(ThuongHieu);

-- ANH_SAN_PHAM
CREATE INDEX IDX_ANH_SAN_PHAM_MaSP ON ANH_SAN_PHAM(MaSP);

-- CHI_TIET_GIO_HANG
CREATE INDEX IDX_CTGH_MaSP ON CHI_TIET_GIO_HANG(MaSP);

-- DON_HANG
CREATE INDEX IDX_DON_HANG_MaKH ON DON_HANG(MaKH);
CREATE INDEX IDX_DON_HANG_MaNV ON DON_HANG(MaNV);

-- CHI_TIET_DON_HANG
CREATE INDEX IDX_CTDH_MaSP ON CHI_TIET_DON_HANG(MaSP);

-- THANH_TOAN
CREATE INDEX IDX_THANH_TOAN_MaPTTT ON THANH_TOAN(MaPTTT);

-- KHUYEN_MAI
CREATE INDEX IDX_KHUYEN_MAI_MaNV ON KHUYEN_MAI(MaNV);

-- KHUYEN_MAI_SAN_PHAM
CREATE INDEX IDX_KMSP_MaSP ON KHUYEN_MAI_SAN_PHAM(MaSP);

-- DANH_GIA
CREATE INDEX IDX_DANH_GIA_MaSP ON DANH_GIA(MaSP);
```

### 3.5. Foreign Key Relationships

| FK        | Source Table      | Target Table           | Type     |
| --------- | ----------------- | ---------------------- | -------- |
| MaTK      | KHACH_HANG        | TAI_KHOAN              | CASCADE  |
| MaTK      | QUAN_TRI_VIEN     | TAI_KHOAN              | CASCADE  |
| MaLoaiSP  | SAN_PHAM          | LOAI_SAN_PHAM          | RESTRICT |
| MaSP      | ANH_SAN_PHAM      | SAN_PHAM               | CASCADE  |
| MaSP      | CHI*TIET*\*       | SAN_PHAM               | CASCADE  |
| MaKH      | GIO_HANG          | KHACH_HANG             | CASCADE  |
| MaGioHang | CHI_TIET_GIO_HANG | GIO_HANG               | CASCADE  |
| MaSP      | CHI_TIET_GIO_HANG | SAN_PHAM               | CASCADE  |
| MaKH      | DON_HANG          | KHACH_HANG             | RESTRICT |
| MaNV      | DON_HANG          | QUAN_TRI_VIEN          | SET NULL |
| MaKM      | DON_HANG          | KHUYEN_MAI             | SET NULL |
| MaDonHang | CHI_TIET_DON_HANG | DON_HANG               | CASCADE  |
| MaSP      | CHI_TIET_DON_HANG | SAN_PHAM               | RESTRICT |
| MaDonHang | THANH_TOAN        | DON_HANG               | CASCADE  |
| MaPTTT    | THANH_TOAN        | PHUONG_THUC_THANH_TOAN | RESTRICT |
| MaNV      | KHUYEN_MAI        | QUAN_TRI_VIEN          | SET NULL |
| MaKH      | DANH_GIA          | KHACH_HANG             | CASCADE  |
| MaSP      | DANH_GIA          | SAN_PHAM               | CASCADE  |

---

## 4. BACKEND SOURCE CODE CHI TIẾT

### 4.1. Controller Layer (Servlets)

Tổng cộng **17 Servlets**, chia làm 3 nhóm:

#### 4.1.1. User Servlets (11 files)

##### AuthServlet.java

- **@WebServlet**: `/login`, `/register`, `/logout`, `/forgot-password`
- **doGet()**: Forward đến JSP tương ứng
- **doPost()**:
  - `/login`: Authenticate → set session attribute "user" → redirect (admin: `/admin/dashboard`, customer: `/`)
  - `/register`: Gọi UserService.registerCustomer() → redirect `/login?registered=true`
  - `/forgot-password`: Tìm user bằng email (luôn trả về message chung - security best practice)

```java
@WebServlet(urlPatterns = { "/login", "/register", "/logout", "/forgot-password" })
public class AuthServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        String path = req.getServletPath();
        if ("/login".equals(path)) {
            User user = userService.authenticate(username, password);
            if (user != null) {
                req.getSession().setAttribute("user", user);
                // Redirect based on role
            }
        }
    }
}
```

##### HomeServlet.java

- **@WebServlet**: `/home`, `/`
- **doGet()**: Load featured products, best sellers, categories → forward to index.jsp

##### ProductServlet.java

- **@WebServlet**: `/products`, `/product`, `/search`, `/category`
- **doGet()**:
  - `/products` hoặc `/shop`: List products with pagination, sorting, filtering by category
  - `/product`: Product detail with images, reviews, specifications
  - `/search`: Fulltext search by product name

```java
// Ví dụ: Lấy sản phẩm với phân trang
int page = 1, limit = 12;
String pageStr = req.getParameter("page");
if (pageStr != null) page = Integer.parseInt(pageStr);
int offset = (page - 1) * limit;
List<Product> products = productService.getProducts(categoryId, sortBy, offset, limit);
```

##### CartServlet.java

- **@WebServlet**: `/cart`, `/cart/update`, `/cart/remove`, `/cart/clear`, `/cart/voucher`
- **doGet()**: Xem giỏ hàng + danh sách item
- **doPost()**: Thêm sản phẩm, cập nhật số lượng, xóa, áp dụng voucher

```java
// Thêm vào giỏ hàng
int maSP = Integer.parseInt(req.getParameter("maSP"));
int quantity = Integer.parseInt(req.getParameter("quantity"));
String action = req.getParameter("action");
if ("add".equals(action)) {
    cartService.addItem(cartId, maSP, quantity);
}
```

##### OrderServlet.java

- **@WebServlet**: `/checkout`, `/order/place`, `/orders`, `/order/cancel`
- **doGet()**: Checkout form, order history, order detail
- **doPost()**: Place order (gọi OrderService.placeOrder trong transaction), Cancel order

```java
protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
    if ("/checkout".equals(req.getServletPath())) {
        // Place order - transaction trong OrderService
        boolean success = orderService.placeOrder(maKH, address, phone,
                                                    note, maKM, maPTTT);
        if (success) resp.sendRedirect("/orders?success=true");
    }
}
```

##### ProfileServlet.java

- **@WebServlet**: `/profile`, `/profile/update`, `/profile/change-password`
- **doGet()**: Hiển thị thông tin cá nhân
- **doPost()**: Cập nhật thông tin, đổi mật khẩu

##### ContactServlet.java

- **@WebServlet**: `/contact`
- **doGet()**: Forward contact form

##### PromotionServlet.java

- **@WebServlet**: `/promotions`
- **doGet()**: List active promotions

##### ReviewServlet.java

- **@WebServlet**: `/review`
- **doPost()**: Submit review cho sản phẩm

##### PcBuilderServlet.java

- **@WebServlet**: `/builder`
- **doGet()**: Hiển thị PC Builder interface
- **doPost()**: Add selected components to cart

#### 4.1.2. Admin Servlets (6 files)

##### AdminStatsServlet.java (Dashboard)

- **@WebServlet**: `/admin/dashboard`, `/admin/`
- **doGet()**:
  - Tổng số đơn hàng
  - Tổng doanh thu
  - Số lượng người dùng mới
  - Đơn hàng gần đây
  - Top sản phẩm bán chạy
  - Thống kê theo ngày/tháng

```java
// Ví dụ: Thống kê doanh thu
int totalOrders = statsService.getTotalOrders();
BigDecimal totalRevenue = statsService.getTotalRevenue();
int totalUsers = statsService.getTotalUsers();
List<Order> recentOrders = statsService.getRecentOrders(10);
```

##### AdminProductServlet.java

- **@WebServlet**: `/admin/products`, `/admin/product/add`, `/admin/product/update`, `/admin/product/delete`
- CRUD sản phẩm, upload hình ảnh

##### AdminOrderServlet.java

- **@WebServlet**: `/admin/orders`, `/admin/order/detail`, `/admin/order/update-status`
- Xem danh sách, chi tiết, cập nhật trạng thái đơn hàng

##### AdminAccountServlet.java

- **@WebServlet**: `/admin/accounts`
- Quản lý tài khoản người dùng và admin

##### AdminPromotionServlet.java

- **@WebServlet**: `/admin/promotions`
- CRUD chương trình khuyến mãi

##### AdminReviewServlet.java

- **@WebServlet**: `/admin/reviews`
- Duyệt hoặc xóa đánh giá

#### 4.1.3. API Servlet (1 file)

##### PcBuilderApiServlet.java

- **@WebServlet**: `/api/builder/*`
- Trả về JSON danh sách linh kiện tương thích cho PC Builder
- Kiểm tra tương thích giữa các components

### 4.2. Service Layer (9 files)

Service layer chứa business logic, gọi DAO layer để tương tác database.

#### UserService.java

```java
public class UserService {
    private UserDAO userDAO = new UserDAO();

    public User authenticate(String username, String password) {
        User user = userDAO.getByUsername(username);
        if (user != null && BCrypt.checkpw(password, user.getMatKhauHash())) {
            userDAO.updateLastLogin(user.getMaTK());
            return user;
        }
        return null;
    }

    public boolean registerCustomer(String username, String password, ...) {
        if (userDAO.getByUsername(username) != null) return false;
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        // Insert into TAI_KHOAN + KHACH_HANG
    }
}
```

**Kiến thức áp dụng**:

- BCrypt password hashing (`gensalt()` tạo salt tự động)
- Dependency Injection (field injection)
- Business validation (check username tồn tại)

#### ProductService.java

```java
public class ProductService {
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    public List<Product> getProducts(int categoryId, String sort, int offset, int limit) {
        return productDAO.findByCategory(categoryId, sort, offset, limit);
    }

    public Product getProductDetail(int id) {
        Product p = productDAO.getById(id);
        if (p != null) {
            p.setAnhSanPhams(productImageDAO.getByProductId(id));
            // Load chi tiết component dựa vào MaLoaiSP
            p.setChiTiet(componentDetailDAO.getByProductIdAndType(id, p.getMaLoaiSP()));
        }
        return p;
    }

    public List<Product> search(String keyword, int offset, int limit) {
        return productDAO.search(keyword, offset, limit);
    }
}
```

#### CartService.java

```java
public class CartService {
    private CartDAO cartDAO = new CartDAO();
    private ProductDAO productDAO = new ProductDAO();
    private PromotionService promotionService = new PromotionService();

    public boolean addItem(int cartId, int productId, int quantity) {
        Product p = productDAO.getById(productId);
        if (p == null || p.getSoLuongTon() < quantity) return false;
        cartDAO.addOrUpdateItem(cartId, productId, quantity, p.getGiaBan());
        return true;
    }

    public BigDecimal calculateSubtotal(int cartId) {
        List<CartItem> items = cartDAO.getItems(cartId);
        return items.stream()
            .map(CartItem::getThanhTien)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateShipping(BigDecimal subtotal) {
        // Miễn phí ship nếu đơn > 500,000đ, ngược lại 30,000đ
        return subtotal.compareTo(new BigDecimal("500000")) >= 0
            ? BigDecimal.ZERO : new BigDecimal("30000");
    }
}
```

#### OrderService.java

```java
public class OrderService {
    // Transaction quản lý thủ công bằng Connection
    public boolean placeOrder(int maKH, String address, String phone,
                                String note, Integer maKM, int maPTTT) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);  // Bắt đầu transaction

            // 1. Tạo đơn hàng
            int newOrderId = orderDAO.insert(order, conn);

            // 2. Tạo chi tiết đơn hàng
            orderDetailDAO.insertBatch(details, conn);

            // 3. Trừ tồn kho
            productDAO.updateStock(item.getMaSP(), -item.getSoLuong(), conn);

            // 4. Tạo bản ghi thanh toán
            paymentDAO.insert(payment, conn);

            // 5. Xóa giỏ hàng
            cartDAO.clearCart(cartId, conn);

            conn.commit();  // Commit transaction
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();  // Rollback nếu lỗi
            return false;
        }
    }

    // Hủy đơn hàng (cũng trong transaction)
    public boolean cancelOrder(int maDonHang) {
        // Kiểm tra trạng thái = 'CHO_XAC_NHAN'
        // Cập nhật status → 'DA_HUY'
        // Hoàn lại tồn kho
    }
}
```

**Kiến thức áp dụng**:

- Transaction management (begin, commit, rollback)
- Exception handling với try-catch-finally
- Connection pooling (HikariCP)

#### PromotionService.java

```java
public class PromotionService {
    private PromotionDAO promotionDAO = new PromotionDAO();

    public BigDecimal applyVoucher(int maKM, BigDecimal total) {
        Promotion promo = promotionDAO.getById(maKM);
        if (promo == null || !promo.isValid()) return BigDecimal.ZERO;

        if ("PHAN_TRAM".equals(promo.getLoaiGiam())) {
            return total.multiply(promo.getGiaTriGiam())
                       .divide(new BigDecimal("100"));
        } else { // SO_TIEN
            return promo.getGiaTriGiam().min(total);
        }
    }
}
```

#### ReviewService.java

```java
public class ReviewService {
    private ReviewDAO reviewDAO = new ReviewDAO();

    public boolean addReview(int maKH, int maSP, int soSao, String noiDung) {
        // Check unique constraint (1 KH chỉ review 1 lần/SP)
        if (reviewDAO.exists(maKH, maSP)) return false;
        return reviewDAO.insert(new Review(maKH, maSP, soSao, noiDung));
    }

    public List<Review> getApprovedReviews(int maSP) {
        return reviewDAO.getByProduct(maSP, true); // true = approved only
    }
}
```

#### PcBuilderService.java

```java
public class PcBuilderService {
    private PcBuilderDAO pcBuilderDAO = new PcBuilderDAO();

    public List<Product> getCompatibleComponents(String type, String socket) {
        // Lấy linh kiện tương thích dựa trên socket, chipset, etc.
        return pcBuilderDAO.findCompatible(type, socket);
    }

    public boolean checkCompatibility(int cpuId, int mainboardId) {
        // Kiểm tra CPU và Mainboard cùng socket
        String cpuSocket = componentDetailDAO.getCpuSocket(cpuId);
        String mbSocket = componentDetailDAO.getMainboardSocket(mainboardId);
        return cpuSocket != null && cpuSocket.equals(mbSocket);
    }
}
```

#### StatsService.java

```java
public class StatsService {
    private StatsDAO statsDAO = new StatsDAO();

    public int getTotalOrders() { return statsDAO.countOrders(); }
    public BigDecimal getTotalRevenue() { return statsDAO.sumRevenue(); }
    public int getTotalUsers() { return statsDAO.countUsers(); }
    public int getTotalProducts() { return statsDAO.countProducts(); }
    public List<Order> getRecentOrders(int limit) { return statsDAO.getRecentOrders(limit); }
    public List<Product> getTopSelling(int limit) { return statsDAO.getTopSellingProducts(limit); }
    public Map<String, Object> getMonthlyStats(int year, int month) {
        return statsDAO.getMonthlyStats(year, month);
    }
}
```

#### PaymentService.java

```java
public class PaymentService {
    private PaymentDAO paymentDAO = new PaymentDAO();

    public boolean processPayment(int maDonHang, int maPTTT, BigDecimal soTien) {
        // Xử lý thanh toán (có thể tích hợp payment gateway)
        return paymentDAO.insert(new Payment(maDonHang, maPTTT, soTien));
    }
}
```

### 4.3. DAO Layer (14 files)

DAOs thực hiện truy vấn SQL trực tiếp qua JDBC, sử dụng `Connection` từ HikariCP pool.

#### DBConnection.java (Connection Pool)

```java
public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/ComputerSpace");
        config.setUsername("root");
        config.setPassword("123456");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);    // 30s timeout
        config.setIdleTimeout(600000);          // 10 phút
        config.setMaxLifetime(1800000);         // 30 phút
        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() {
        return dataSource.getConnection();
    }
}
```

**Cấu hình HikariCP**:

- `maximumPoolSize=10`: Tối đa 10 connections
- `minimumIdle=2`: Tối thiểu 2 connections rảnh
- `connectionTimeout=30000`: Timeout 30s khi chờ connection
- `idleTimeout=600000`: 10 phút không dùng → đóng
- `maxLifetime=1800000`: 30 phút tối đa cho 1 connection

#### ProductDAO.java

```java
public class ProductDAO {
    public List<Product> findByCategory(int categoryId, String sort, int offset, int limit) {
        String sql = "SELECT sp.*, lsp.TenLoaiSP FROM SAN_PHAM sp " +
                     "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP " +
                     "WHERE sp.TrangThai = 1 " +
                     (categoryId > 0 ? "AND sp.MaLoaiSP = ? " : "") +
                     "ORDER BY " + getSortClause(sort) + " " +
                     "LIMIT ? OFFSET ?";
        // Execute query, map ResultSet → Product objects
    }

    public List<Product> search(String keyword, int offset, int limit) {
        String sql = "SELECT sp.*, MATCH(sp.TenSP) AGAINST(? IN BOOLEAN MODE) as relevance " +
                     "FROM SAN_PHAM sp WHERE MATCH(sp.TenSP) AGAINST(? IN BOOLEAN MODE) " +
                     "LIMIT ? OFFSET ?";
        // FULLTEXT search
    }

    public Product getById(int id) {
        String sql = "SELECT sp.*, lsp.TenLoaiSP FROM SAN_PHAM sp " +
                     "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP " +
                     "WHERE sp.MaSP = ?";
    }

    public void updateStock(int maSP, int delta, Connection conn) {
        String sql = "UPDATE SAN_PHAM SET SoLuongTon = SoLuongTon + ? WHERE MaSP = ?";
        // Dùng connection từ transaction
    }
}
```

#### OrderDAO.java

```java
public class OrderDAO {
    public int insert(Order order, Connection conn) {
        String sql = "INSERT INTO DON_HANG (MaKH, TongTien, DiaChiNhan, SDTNhan, " +
                     "GhiChu, MaKM, TrangThaiDonHang) VALUES (?, ?, ?, ?, ?, ?, 'CHO_XAC_NHAN')";
        // Execute với connection từ transaction
        // Lấy generated key (MaDonHang) bằng Statement.RETURN_GENERATED_KEYS
    }

    public boolean updateStatus(int maDonHang, String status) {
        String sql = "UPDATE DON_HANG SET TrangThaiDonHang = ? WHERE MaDonHang = ?";
    }

    public List<Order> getByCustomerId(int maKH) {
        String sql = "SELECT * FROM DON_HANG WHERE MaKH = ? ORDER BY NgayDat DESC";
    }
}
```

#### UserDAO.java

```java
public class UserDAO {
    public User getByUsername(String username) {
        String sql = "SELECT tk.*, kh.HoTen, kh.Email, kh.SDT as SoDienThoai, " +
                     "kh.DiaChi FROM TAI_KHOAN tk " +
                     "LEFT JOIN KHACH_HANG kh ON tk.MaTK = kh.MaTK " +
                     "WHERE tk.TenDangNhap = ?";
    }

    public User getByAdminUsername(String username) {
        String sql = "SELECT tk.*, qtv.HoTen, qtv.Email FROM TAI_KHOAN tk " +
                     "JOIN QUAN_TRI_VIEN qtv ON tk.MaTK = qtv.MaTK " +
                     "WHERE tk.TenDangNhap = ? AND tk.VaiTro = 'QUAN_TRI_VIEN'";
    }

    public boolean insertCustomer(User user) {
        // INSERT INTO TAI_KHOAN + INSERT INTO KHACH_HANG (2 queries)
    }
}
```

#### CartDAO.java

```java
public class CartDAO {
    public int getCartIdByCustomerId(int maKH) {
        String sql = "SELECT MaGioHang FROM GIO_HANG WHERE MaKH = ?";
    }

    public List<CartItem> getItems(int cartId) {
        String sql = "SELECT ctgh.*, sp.TenSP, sp.GiaBan, asp.DuongDanAnh " +
                     "FROM CHI_TIET_GIO_HANG ctgh " +
                     "JOIN SAN_PHAM sp ON ctgh.MaSP = sp.MaSP " +
                     "LEFT JOIN ANH_SAN_PHAM asp ON sp.MaSP = asp.MaSP AND asp.LaAnhDaiDien = 1 " +
                     "WHERE ctgh.MaGioHang = ?";
    }

    public void addOrUpdateItem(int cartId, int productId, int quantity, BigDecimal price) {
        // INSERT ... ON DUPLICATE KEY UPDATE
        String sql = "INSERT INTO CHI_TIET_GIO_HANG (MaGioHang, MaSP, SoLuong, DonGia) " +
                     "VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE SoLuong = SoLuong + ?";
    }
}
```

#### CategoryDAO.java

```java
public class CategoryDAO {
    public List<Category> getAll() {
        String sql = "SELECT * FROM LOAI_SAN_PHAM ORDER BY TenLoaiSP";
    }
}
```

#### ComponentDetailDAO.java

```java
public class ComponentDetailDAO {
    public Object getByProductIdAndType(int maSP, int maLoaiSP) {
        // Dựa vào maLoaiSP để query bảng chi tiết tương ứng
        String tableName = getTableName(maLoaiSP); // CHI_TIET_MAIN, CHI_TIET_CPU, ...
        String sql = "SELECT * FROM " + tableName + " WHERE MaSP = ?";
    }

    public String getCpuSocket(int maSP) {
        String sql = "SELECT Socket FROM CHI_TIET_CPU WHERE MaSP = ?";
    }

    public String getMainboardSocket(int maSP) {
        String sql = "SELECT Socket FROM CHI_TIET_MAIN WHERE MaSP = ?";
    }
}
```

#### StatsDAO.java

```java
public class StatsDAO {
    public BigDecimal sumRevenue() {
        String sql = "SELECT COALESCE(SUM(TongTien), 0) FROM DON_HANG " +
                     "WHERE TrangThaiDonHang IN ('DA_GIAO', 'DANG_GIAO')";
    }

    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM DON_HANG";
    }

    public List<Product> getTopSellingProducts(int limit) {
        String sql = "SELECT sp.*, SUM(ctdh.SoLuong) as TotalSold " +
                     "FROM CHI_TIET_DON_HANG ctdh " +
                     "JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP " +
                     "JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang " +
                     "WHERE dh.TrangThaiDonHang = 'DA_GIAO' " +
                     "GROUP BY sp.MaSP ORDER BY TotalSold DESC LIMIT ?";
    }

    public Map<String, Object> getMonthlyStats(int year, int month) {
        String sql = "SELECT DATE(NgayDat) as Ngay, COUNT(*) as SoDon, " +
                     "SUM(TongTien) as DoanhThu " +
                     "FROM DON_HANG WHERE YEAR(NgayDat) = ? AND MONTH(NgayDat) = ? " +
                     "AND TrangThaiDonHang = 'DA_GIAO' " +
                     "GROUP BY DATE(NgayDat) ORDER BY Ngay";
    }
}
```

#### ReviewDAO.java

```java
public class ReviewDAO {
    public List<Review> getByProduct(int maSP, boolean approvedOnly) {
        String sql = "SELECT dg.*, kh.HoTen FROM DANH_GIA dg " +
                     "JOIN KHACH_HANG kh ON dg.MaKH = kh.MaKH " +
                     "WHERE dg.MaSP = ? " +
                     (approvedOnly ? "AND dg.TrangThaiDuyet = 1 " : "") +
                     "ORDER BY dg.NgayDanhGia DESC";
    }
}
```

#### PaymentDAO.java

```java
public class PaymentDAO {
    public void insert(Payment payment, Connection conn) {
        String sql = "INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, " +
                     "TrangThaiThanhToan) VALUES (?, ?, ?, 'CHUA_THANH_TOAN')";
    }
}
```

#### OrderDetailDAO.java

```java
public class OrderDetailDAO {
    public void insertBatch(List<OrderDetail> details, Connection conn) {
        String sql = "INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (OrderDetail d : details) {
                ps.setInt(1, d.getMaDonHang());
                ps.setInt(2, d.getMaSP());
                // ... batch execute
            }
            ps.executeBatch();
        }
    }
}
```

#### PromotionDAO.java, PromotionProductDAO.java, PcBuilderDAO.java, ProductImageDAO.java

Các DAOs còn lại thực hiện các query CRUD cơ bản tương ứng.

### 4.4. Model Layer (15 files)

#### User.java

```java
public class User {
    private int maTK;
    private String tenDangNhap;
    private String matKhauHash;
    private String vaiTro;       // 'KHACH_HANG' hoặc 'QUAN_TRI_VIEN'
    private String hoTen;
    private String email;
    private String soDienThoai;
    private String diaChi;
    private int trangThai;
    private Timestamp ngayDangNhapCuoi;
    // Getters/Setters
}
```

#### Product.java

```java
public class Product {
    private int maSP;
    private String tenSP;
    private int maLoaiSP;
    private String tenLoaiSP;    // JOIN từ LOAI_SAN_PHAM
    private String thuongHieu;
    private BigDecimal giaBan;
    private int soLuongTon;
    private int baoHanhThang;
    private String moTaNgan;
    private String moTaChiTiet;
    private int trangThai;
    private Timestamp ngayTao;
    private Timestamp ngayCapNhat;

    // Quan hệ
    private List<ProductImage> anhSanPhams;
    private Object chiTiet;      // Chi tiết linh kiện (tùy loại)
    private double avgRating;    // Điểm đánh giá trung bình
    private int reviewCount;     // Số lượng đánh giá

    // Getters/Setters
}
```

#### Category.java

```java
public class Category {
    private int maLoaiSP;
    private String tenLoaiSP;
    private String moTa;
    private int productCount;    // Số sản phẩm trong danh mục
}
```

#### CartItem.java

```java
public class CartItem {
    private int maGioHang;
    private int maSP;
    private String tenSP;        // JOIN từ SAN_PHAM
    private int soLuong;
    private BigDecimal giaBan;
    private BigDecimal thanhTien; // = giaBan * soLuong
    private String hinhAnh;       // Ảnh đại diện
}
```

#### Order.java

```java
public class Order {
    private int maDonHang;
    private int maKH;
    private String tenKH;        // JOIN từ KHACH_HANG
    private Integer maNV;
    private String tenNV;        // JOIN từ QUAN_TRI_VIEN
    private Timestamp ngayDat;
    private String diaChiNhan;
    private String sdtNhan;
    private BigDecimal tongTien;
    private BigDecimal phiVanChuyen;
    private String trangThaiDonHang; // 'CHO_XAC_NHAN', 'DA_XAC_NHAN', ...
    private String ghiChu;
    private Integer maKM;
    private String tenKM;        // JOIN từ KHUYEN_MAI
    private List<OrderDetail> chiTietDonHangs;
}
```

#### OrderDetail.java

```java
public class OrderDetail {
    private int maDonHang;
    private int maSP;
    private String tenSP;        // JOIN từ SAN_PHAM
    private int soLuong;
    private BigDecimal donGia;
    private BigDecimal thanhTien;
}
```

#### Promotion.java

```java
public class Promotion {
    private int maKM;
    private String tenKM;
    private String loaiGiam;     // 'PHAN_TRAM' hoặc 'SO_TIEN'
    private BigDecimal giaTriGiam;
    private Timestamp ngayBatDau;
    private Timestamp ngayKetThuc;
    private int trangThai;

    public boolean isValid() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return trangThai == 1 &&
               now.after(ngayBatDau) &&
               now.before(ngayKetThuc);
    }
}
```

#### Review.java

```java
public class Review {
    private int maDG;
    private int maKH;
    private String tenKH;        // JOIN từ KHACH_HANG
    private int maSP;
    private int soSao;           // 1-5
    private String noiDung;
    private Timestamp ngayDanhGia;
    private int trangThaiDuyet;  // 0: Chờ duyệt, 1: Approved
}
```

#### Payment.java, PaymentMethod.java, ProductImage.java

Các models còn lại đơn giản, mapping trực tiếp với các cột trong database.

#### Component Detail Models (8 files)

- **CpuDetail.java**: hangCPU, dongCPU, socket, soNhan, soLuongLuong, xungNhipCoBan, xungNhipTurbo, cacheL1, cacheL2, TDP, coGPU
- **MainboardDetail.java**: chipset, socket, kichThuocMain, hoTroCPU, soKheRam, loaiRam, dungLuongRamToiDa, khePCIe, soCongSATA, soKheM2, congXuatHinh
- **VgaDetail.java**: hangGPU, dungLuongVRAM, kieuBoNho, busBoNho, xungNhip, TDP, congKetNoi, soQuat, kichThuocCard, dauCapNguon
- **RamDetail.java**: loaiRam, dungLuong, busRam, dienAp, soThanh
- **StorageDetail.java**: loaiOCung, dungLuong, chuanKetNoi, kichCo, tocDoDocGhi
- **PsuDetail.java**: congSuat, chuan80Plus, congKetNoi, kichThuocNguon, dienApVao, dauCapNguon
- **CoolerDetail.java**: loaiTanNhiet, tuongThichCPU, kichThuocRadiator, soQuat, tocDoQuat, doOn, LED, kichThuocTan
- **CaseDetail.java**: hoTroMain, mauSac, chatLieu, kichThuoc, hoTroNguon, soLuongQuatHoTro, coKinhCuongLuc, congTruocCase

### 4.5. Filter Layer (4 files)

#### EncodingFilter.java

```java
@WebFilter("/*")
public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }
}
```

#### AuthenticationFilter.java

```java
@WebFilter(urlPatterns = {"/cart/*", "/checkout", "/orders", "/profile/*", "/review", "/builder"})
public class AuthenticationFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ((HttpServletResponse) response).sendRedirect(req.getContextPath() + "/login");
        } else {
            chain.doFilter(request, response);
        }
    }
}
```

#### AdminFilter.java

```java
@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        HttpServletRequest req = (HttpServletRequest) request;
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"QUAN_TRI_VIEN".equals(user.getVaiTro())) {
            ((HttpServletResponse) response).sendError(403);
        } else {
            chain.doFilter(request, response);
        }
    }
}
```

#### CategoryFilter.java

```java
@WebFilter("/*")
public class CategoryFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        List<Category> categories = categoryDAO.getAll();
        request.setAttribute("categories", categories);
        chain.doFilter(request, response);
    }
}
```

### 4.6. DTO Layer (1 file)

#### PcComponentDTO.java

```java
public class PcComponentDTO {
    private int maSP;
    private String tenSP;
    private String loai;
    private String thuongHieu;
    private BigDecimal giaBan;
    private String hinhAnh;
    private Map<String, String> thongSoKyThuat; // Specifications

    // Constructor, Getters/Setters
}
```

### 4.7. Exception Layer (1 file)

#### DatabaseException.java

```java
public class DatabaseException extends RuntimeException {
    public DatabaseException(String message) { super(message); }
    public DatabaseException(String message, Throwable cause) { super(message, cause); }
}
```

### 4.8. Utility Layer (2 files)

#### ValidationUtil.java

```java
public class ValidationUtil {
    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("0[0-9]{9,10}");
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isValidUsername(String username) {
        return username != null && username.length() >= 3;
    }

    public static boolean isValidPositiveInt(String value) {
        try {
            return Integer.parseInt(value) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
```

---

## 5. KIẾN THỨC JAVA & JAKARTA EE LIÊN QUAN

### 5.1. Java 21

#### 5.1.1. Các Tính Năng Java 21 Được Sử Dụng

**Records** (có thể áp dụng cho Models):

```java
// Thay vì viết class truyền thống với getters/setters
public record ProductDTO(int maSP, String tenSP, BigDecimal giaBan) {}
```

**Pattern Matching for instanceof**:

```java
// Có thể dùng để thay thế:
if (obj instanceof String s) {
    System.out.println(s.length());
}
```

**Virtual Threads (Project Loom)** - chưa dùng nhưng có thể áp dụng:

```java
// Xử lý concurrent requests hiệu quả hơn
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(() -> processOrder(order));
}
```

#### 5.1.2. Lambda & Stream API

Hệ thống sử dụng Stream API trong CartService để tính tổng:

```java
BigDecimal subtotal = items.stream()
    .map(CartItem::getThanhTien)
    .reduce(BigDecimal.ZERO, BigDecimal::add);
```

Có thể mở rộng:

```java
// Filter + Collect
List<Product> filteredProducts = products.stream()
    .filter(p -> p.getGiaBan().compareTo(threshold) <= 0)
    .sorted(Comparator.comparing(Product::getGiaBan))
    .collect(Collectors.toList());

// Group by category
Map<String, List<Product>> productsByCategory = products.stream()
    .collect(Collectors.groupingBy(Product::getTenLoaiSP));
```

### 5.2. Jakarta Servlet 6.1

#### 5.2.1. Servlet Lifecycle

```
1. Khởi tạo: init()    - Gọi 1 lần khi servlet được load
2. Xử lý: service()    - Gọi mỗi request (phân phối đến doGet/doPost)
3. Hủy: destroy()      - Gọi 1 lần khi servlet bị hủy
```

Trong project, các servlets sử dụng `@WebServlet` annotation thay vì web.xml:

```java
@WebServlet(urlPatterns = { "/login", "/register", "/logout", "/forgot-password" })
public class AuthServlet extends HttpServlet {
    // Không cần override init/destroy vì không có resource nặng
}
```

#### 5.2.2. HttpServletRequest & HttpServletResponse

**Lấy tham số**:

```java
String username = req.getParameter("username");
String[] categories = req.getParameterValues("category"); // Multiple values
int page = Integer.parseInt(req.getParameterOrDefault("page", "1"));
```

**Set attributes** (chuyển dữ liệu đến JSP):

```java
req.setAttribute("products", productList);
req.setAttribute("totalPages", totalPages);
```

**Session management**:

```java
HttpSession session = req.getSession();        // Tạo mới hoặc lấy session
HttpSession session = req.getSession(false);   // Chỉ lấy session hiện có
session.setAttribute("user", user);             // Lưu vào session
session.invalidate();                           // Hủy session (logout)
```

**Forward vs Redirect**:

```java
// Forward (server-side, URL không đổi)
req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);

// Redirect (client-side, URL thay đổi)
resp.sendRedirect(req.getContextPath() + "/home");
```

#### 5.2.3. @WebServlet Annotation

```java
@WebServlet(
    urlPatterns = {"/cart", "/cart/update", "/cart/remove"},
    name = "CartServlet",
    loadOnStartup = 1,
    initParams = {@WebInitParam(name = "param", value = "value")}
)
```

#### 5.2.4. Error Handling trong Servlet

Sử dụng **try-catch** để bắt lỗi và forward đến error page:

```java
try {
    // Logic xử lý
} catch (NumberFormatException e) {
    req.setAttribute("error", "Dữ liệu không hợp lệ");
    req.getRequestDispatcher("/error.jsp").forward(req, resp);
} catch (DatabaseException e) {
    resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi database");
}
```

### 5.3. JSP 4.0 & JSTL 3.0

#### 5.3.1. JSP Directives

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
```

#### 5.3.2. EL (Expression Language) 3.0

```jsp
<!-- Đọc attribute từ request/session -->
<p>${product.tenSP}</p>
<p>Giá: <fmt:formatNumber value="${product.giaBan}" type="currency"/></p>

<!-- Toán tử EL -->
<c:if test="${empty products}">
    <p>Không có sản phẩm nào.</p>
</c:if>

<!-- Ternary operator -->
<p class="${product.soLuongTon > 0 ? 'in-stock' : 'out-of-stock'}">
    ${product.soLuongTon > 0 ? 'Còn hàng' : 'Hết hàng'}
</p>
```

#### 5.3.3. JSTL Core Tags

```jsp
<!-- ForEach loop -->
<c:forEach var="product" items="${products}" varStatus="status">
    <div class="product-card">
        <h3>${product.tenSP}</h3>
        <p>${product.giaBan}</p>
    </div>
</c:forEach>

<!-- Conditional -->
<c:choose>
    <c:when test="${user.vaiTro == 'QUAN_TRI_VIEN'}">
        <a href="/admin/">Admin Panel</a>
    </c:when>
    <c:otherwise>
        <a href="/profile">Profile</a>
    </c:otherwise>
</c:choose>

<!-- URL manipulation -->
<a href="<c:url value='/product'>
    <c:param name='id' value='${product.maSP}'/>
</c:url>">Xem chi tiết</a>
```

#### 5.3.4. JSTL Formatting Tags

```jsp
<!-- Format number as currency -->
<fmt:formatNumber value="${product.giaBan}" type="currency" currencySymbol="₫"
                  maxFractionDigits="0"/>

<!-- Format date -->
<fmt:formatDate value="${order.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>

<!-- Format number -->
<fmt:formatNumber value="${statistics.doanhThu}" type="number"
                  groupingUsed="true"/>
```

### 5.4. Thymeleaf 3.1 (Đã Import Nhưng Chưa Dùng)

Thymeleaf là template engine hiện đại, có thể thay thế JSP:

```xml
<!-- pom.xml đã import thymeleaf-3.1.5.RELEASE.jar -->
<dependency>
    <groupId>org.thymeleaf</groupId>
    <artifactId>thymeleaf</artifactId>
    <version>3.1.5.RELEASE</version>
</dependency>
```

Ví dụ cú pháp Thymeleaf:

```html
<!-- Thymeleaf expression -->
<p th:text="${product.name}">Product Name</p>

<!-- Loop -->
<tr th:each="product : ${products}">
  <td th:text="${product.id}">1</td>
  <td th:text="${product.name}">Product</td>
</tr>

<!-- Conditional -->
<div th:if="${#lists.isEmpty(products)}">No products found.</div>
```

### 5.5. HikariCP Connection Pool

#### 5.5.1. Tại Sao Dùng Connection Pool?

- **Không dùng pool**: Mỗi request tạo connection mới → tốn thời gian (handshake, auth)
- **Dùng pool**: Connections được tái sử dụng → giảm latency, tăng throughput

#### 5.5.2. Cấu Hình Trong Project

```java
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:mysql://localhost:3306/ComputerSpace");
config.setUsername("root"); // Nên đọc từ environment variables
config.setPassword("123456");
config.setMaximumPoolSize(10);
config.setMinimumIdle(2);
config.setConnectionTimeout(30000);  // 30 giây
config.setIdleTimeout(600000);       // 10 phút
config.setMaxLifetime(1800000);      // 30 phút
```

#### 5.5.3. Best Practices

| Tham số           | Giá trị khuyên dùng | Giải thích                       |
| ----------------- | ------------------- | -------------------------------- |
| maximumPoolSize   | CPU cores × 2 + HDD | Tùy theo hardware                |
| minimumIdle       | 2-5                 | Duy trì connection sẵn sàng      |
| connectionTimeout | 5000-30000ms        | Thời gian chờ tối đa             |
| idleTimeout       | 600000ms (10 phút)  | Đóng connection không dùng       |
| maxLifetime       | 1800000ms (30 phút) | Tránh connection bị network drop |

### 5.6. BCrypt Password Hashing

#### 5.6.1. Cách Hoạt Động

```java
// Hash password
String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
// Result: $2a$12$LJ3m4ys3Lk0TSwHnbfZxZ.5Qx7Y1N0Kx9Xx9Xx9Xx9Xx9Xx9Xx9X

// Verify password
boolean match = BCrypt.checkpw(password, hashedPassword);
```

#### 5.6.2. Cấu Trúc BCrypt Hash

```
$2a$12$LJ3m4ys3Lk0TSwHnbfZxZ.5Qx7Y1N0Kx9Xx9Xx9Xx9Xx9Xx9Xx9X
├──┴──┴──────────────────────────────────────────────────────┘
│    │                            │
Alg  Cost ($12)                 Hash + Salt (53 chars)
```

- **$2a**: Thuật toán BCrypt
- **$12**: Cost factor (số rounds = 2^12 = 4096 rounds)
- **Phần còn lại**: Salt (22 chars) + Hash (31 chars)

#### 5.6.3. Lưu Ý Bảo Mật

- Cost factor ≥ 12 (càng cao càng chậm, càng an toàn)
- Salt tự động sinh bởi `BCrypt.gensalt()`
- Không bao giờ lưu plain-text password
- Luôn verify bằng `BCrypt.checkpw()`

### 5.7. Servlet Filters

#### 5.7.1. Filter Chain

```
Request → EncodingFilter → AuthenticationFilter → AdminFilter → CategoryFilter → Servlet
```

#### 5.7.2. Filter Lifecycle

```java
@WebFilter("/*")
public class MyFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) { /* Khởi tạo */ }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        // Pre-processing (trước khi vào servlet)
        chain.doFilter(request, response);
        // Post-processing (sau khi servlet xử lý)
    }

    @Override
    public void destroy() { /* Dọn dẹp */ }
}
```

#### 5.7.3. Ứng Dụng Trong Project

1. **EncodingFilter**: Set UTF-8 encoding cho tất cả requests/responses
2. **AuthenticationFilter**: Bảo vệ các URL yêu cầu đăng nhập
3. **AdminFilter**: Bảo vệ admin pages, kiểm tra vai trò
4. **CategoryFilter**: Load danh mục sản phẩm cho tất cả pages

### 5.8. DAO Pattern

#### 5.8.1. Khái Niệm

DAO (Data Access Object) là design pattern tách biệt logic truy cập dữ liệu khỏi business logic.

```
Controller → Service → DAO → Database
```

#### 5.8.2. Cấu Trúc DAO

```java
public class ProductDAO {
    private static final String SELECT_BY_ID =
        "SELECT sp.*, lsp.TenLoaiSP FROM SAN_PHAM sp " +
        "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP WHERE sp.MaSP = ?";

    public Product getById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractProduct(rs);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error getting product", e);
        }
        return null;
    }

    private Product extractProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setMaSP(rs.getInt("MaSP"));
        p.setTenSP(rs.getString("TenSP"));
        // ... mapping columns
        return p;
    }
}
```

#### 5.8.3. Try-With-Resources

Java 7+ tự động đóng resource:

```java
try (Connection conn = DBConnection.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql);
     ResultSet rs = ps.executeQuery()) {
    // Tự động đóng conn, ps, rs khi kết thúc try block
}
```

#### 5.8.4. PreparedStatement

- **Chống SQL Injection**: Parameters được escape tự động
- **Performance**: SQL được compile trước, cache execution plan
- **Không nên dùng Statement** (dễ bị injection):

  ```java
  // KHÔNG AN TOÀN
  String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = " + id;

  // AN TOÀN
  String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = ?";
  PreparedStatement ps = conn.prepareStatement(sql);
  ps.setInt(1, id);
  ```

### 5.9. Transaction Management

#### 5.9.1. Manual Transaction (Hiện Tại)

```java
Connection conn = null;
try {
    conn = DBConnection.getConnection();
    conn.setAutoCommit(false);  // Bắt đầu transaction

    // Multiple SQL operations
    orderDAO.insert(order, conn);
    orderDetailDAO.insertBatch(details, conn);
    productDAO.updateStock(productId, -quantity, conn);

    conn.commit();  // Xác nhận tất cả thay đổi
} catch (SQLException e) {
    if (conn != null) {
        try {
            conn.rollback();  // Hoàn tác nếu lỗi
        } catch (SQLException ex) { /* log */ }
    }
    throw new DatabaseException("Transaction failed", e);
} finally {
    if (conn != null) {
        conn.setAutoCommit(true);  // Reset auto-commit
        conn.close();
    }
}
```

#### 5.9.2. ACID Properties

| Tính chất       | Mô tả                        | Ví dụ                                    |
| --------------- | ---------------------------- | ---------------------------------------- |
| **Atomicity**   | Toàn bộ hoặc không gì cả     | Cả 3 INSERT đều thành công hoặc rollback |
| **Consistency** | Dữ liệu luôn hợp lệ          | Tổng tiền = tổng chi tiết                |
| **Isolation**   | Transactions độc lập         | 2 đơn hàng cùng lúc không ảnh hưởng      |
| **Durability**  | Dữ liệu đã commit sẽ tồn tại | Dù mất điện, đơn hàng đã lưu vẫn còn     |

### 5.10. Maven Build Tool

#### 5.10.1. Cấu Trúc pom.xml

```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.computerstore</groupId>
    <artifactId>computerstore</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>      <!-- WAR cho web application -->

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
    </properties>
</project>
```

#### 5.10.2. Dependency Scopes

| Scope        | Mô tả                                   | Ví dụ                     |
| ------------ | --------------------------------------- | ------------------------- |
| **compile**  | Mặc định, có ở compile & runtime        | HikariCP, MySQL Connector |
| **provided** | Server cung cấp, không đóng gói vào WAR | Jakarta Servlet API       |
| **runtime**  | Chỉ cần ở runtime                       | JDBC Driver               |
| **test**     | Chỉ cho test                            | JUnit, Mockito            |

#### 5.10.3. Cargo Maven Plugin

Project sử dụng Cargo plugin để chạy Tomcat embedded:

```xml
<plugin>
    <groupId>org.codehaus.cargo</groupId>
    <artifactId>cargo-maven3-plugin</artifactId>
    <version>1.10.11</version>
    <configuration>
        <container>
            <containerId>tomcat11x</containerId>
            <type>embedded</type>
        </container>
        <configuration>
            <properties>
                <cargo.servlet.port>8080</cargo.servlet.port>
            </properties>
        </configuration>
    </configuration>
</plugin>
```

```bash
# Chạy ứng dụng với Cargo
mvn cargo:run
```

---

## 6. KIẾN THỨC DATABASE & SQL

### 6.1. MySQL 8.0 Features Used

#### 6.1.1. FULLTEXT Index

```sql
-- Tạo FULLTEXT index trên TenSP
CREATE FULLTEXT INDEX IDX_SAN_PHAM_TenSP ON SAN_PHAM(TenSP);

-- Tìm kiếm với BOOLEAN MODE
SELECT sp.*, MATCH(sp.TenSP) AGAINST('ryzen 5' IN BOOLEAN MODE) as relevance
FROM SAN_PHAM sp
WHERE MATCH(sp.TenSP) AGAINST('ryzen 5' IN BOOLEAN MODE)
ORDER BY relevance DESC;
```

**Boolean mode operators**:

- `+word`: Bắt buộc có
- `-word`: Không được có
- `word*`: Wildcard
- `"phrase"`: Tìm chính xác cụm từ
- `>word`: Tăng relevance

#### 6.1.2. ENUM Type

```sql
VaiTro ENUM('KHACH_HANG', 'QUAN_TRI_VIEN') NOT NULL,
TrangThaiDonHang ENUM('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY') NOT NULL DEFAULT 'CHO_XAC_NHAN',
TrangThaiThanhToan ENUM('CHUA_THANH_TOAN', 'DA_THANH_TOAN', 'HOAN_TIEN') NOT NULL DEFAULT 'CHUA_THANH_TOAN',
LoaiGiam ENUM('PHAN_TRAM', 'SO_TIEN') NOT NULL
```

**Lưu ý**: ENUM lưu dưới dạng số (1, 2, 3...), sorting theo thứ tự khai báo, không phải alphabet.

#### 6.1.3. utf8mb4 Character Set

```sql
CREATE DATABASE ComputerSpace
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

- `utf8mb4`: Unicode đầy đủ (bao gồm emoji)
- `utf8mb4_unicode_ci`: Case-insensitive, so sánh theo Unicode rules

#### 6.1.4. DECIMAL for Currency

```sql
GiaBan DECIMAL(15,2) NOT NULL DEFAULT 0
```

- **DECIMAL**: Lưu chính xác số thập phân (không floating-point error)
- **DOUBLE/FLOAT**: Có sai số khi tính toán tiền
- **15,2**: Tối đa 15 chữ số, 2 số thập phân (999,999,999,999,999.99)

### 6.2. SQL Query Mẫu

#### 6.2.1. Lấy sản phẩm với phân trang

```sql
SELECT sp.*, lsp.TenLoaiSP
FROM SAN_PHAM sp
JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP
WHERE sp.TrangThai = 1
  AND (? = 0 OR sp.MaLoaiSP = ?)
ORDER BY sp.NgayTao DESC
LIMIT ? OFFSET ?;
```

#### 6.2.2. Chi tiết sản phẩm với ảnh và đánh giá

```sql
-- Thông tin sản phẩm
SELECT sp.*, lsp.TenLoaiSP
FROM SAN_PHAM sp
JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP
WHERE sp.MaSP = ?;

-- Ảnh sản phẩm
SELECT * FROM ANH_SAN_PHAM WHERE MaSP = ?;

-- Đánh giá (đã duyệt)
SELECT dg.*, kh.HoTen
FROM DANH_GIA dg
JOIN KHACH_HANG kh ON dg.MaKH = kh.MaKH
WHERE dg.MaSP = ? AND dg.TrangThaiDuyet = 1
ORDER BY dg.NgayDanhGia DESC;

-- Rating trung bình
SELECT AVG(SoSao) as AvgRating, COUNT(*) as ReviewCount
FROM DANH_GIA
WHERE MaSP = ? AND TrangThaiDuyet = 1;
```

#### 6.2.3. Top sản phẩm bán chạy

```sql
SELECT sp.*, SUM(ctdh.SoLuong) as TotalSold
FROM CHI_TIET_DON_HANG ctdh
JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP
JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang
WHERE dh.TrangThaiDonHang = 'DA_GIAO'
GROUP BY sp.MaSP
ORDER BY TotalSold DESC
LIMIT 10;
```

#### 6.2.4. Thống kê doanh thu theo ngày

```sql
SELECT DATE(NgayDat) as Ngay,
       COUNT(*) as SoDon,
       SUM(TongTien) as DoanhThu
FROM DON_HANG
WHERE YEAR(NgayDat) = ?
  AND MONTH(NgayDat) = ?
  AND TrangThaiDonHang = 'DA_GIAO'
GROUP BY DATE(NgayDat)
ORDER BY Ngay;
```

### 6.3. SQL Injection Prevention

**Không an toàn** (dùng Statement):

```java
String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = " + id;
// Nếu id = "1 OR 1=1" → SELECT * FROM SAN_PHAM WHERE MaSP = 1 OR 1=1
```

**An toàn** (dùng PreparedStatement):

```java
String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = ?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setInt(1, id);  // Tự động escape
```

### 6.4. Database Design Patterns

#### 6.4.1. Class Table Inheritance (CTI)

Mỗi loại linh kiện có bảng chi tiết riêng:

```
SAN_PHAM (base table)
├── CHI_TIET_CPU (CPU-specific)
├── CHI_TIET_VGA (VGA-specific)
├── CHI_TIET_MAIN (Mainboard-specific)
└── ...
```

**Ưu điểm**: Không có NULL columns, dễ maintain, mỗi loại có schema riêng
**Nhược điểm**: Cần JOIN nhiều bảng

#### 6.4.2. One-to-One qua UNIQUE FK

```sql
-- Mỗi khách hàng chỉ có 1 giỏ hàng
CREATE TABLE GIO_HANG (
    MaKH INT NOT NULL UNIQUE,
    ...
);

-- Mỗi đơn hàng chỉ có 1 thanh toán
CREATE TABLE THANH_TOAN (
    MaDonHang INT NOT NULL UNIQUE,
    ...
);
```

#### 6.4.3. ON DELETE CASCADE vs RESTRICT

| Rule         | Mô tả                     | Ví dụ                                    |
| ------------ | ------------------------- | ---------------------------------------- |
| **CASCADE**  | Xóa tự động               | Xóa TAI_KHOAN → tự động xóa KHACH_HANG   |
| **RESTRICT** | Ngăn xóa nếu còn liên kết | Không xóa LOAI_SAN_PHAM nếu còn sản phẩm |
| **SET NULL** | Set FK thành NULL         | Xóa KHUYEN_MAI → DON_HANG.MaKM = NULL    |

---

## 7. LUỒNG NGHIỆP VỤ (BUSINESS FLOWS)

### 7.1. Luồng Đăng Ký & Đăng Nhập (Authentication Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│                       ĐĂNG KÝ TÀI KHOẢN                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User → POST /register                                           │
│  ├─ Kiểm tra username đã tồn tại?                                │
│  │  └─ Nếu có → error "Tên đăng nhập đã tồn tại"                 │
│  ├─ Hash password với BCrypt.gensalt()                           │
│  ├─ INSERT INTO TAI_KHOAN (VaiTro='KHACH_HANG')                  │
│  ├─ Lấy MaTK vừa tạo                                             │
│  ├─ INSERT INTO KHACH_HANG (MaTK, HoTen, SDT, Email, DiaChi)     │
│  ├─ Tạo session tự động                                           │
│  └─ Redirect đến /home                                           │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                       ĐĂNG NHẬP                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User → POST /login                                              │
│  ├─ Lấy tham số: username, password                              │
│  ├─ UserService.authenticate(username, password)                 │
│  │  ├─ userDAO.getByUsername(username)                           │
│  │  │  └─ JOIN TAI_KHOAN + KHACH_HANG/QUAN_TRI_VIEN             │
│  │  ├─ BCrypt.checkpw(password, user.getMatKhauHash())           │
│  │  │  └─ Nếu đúng → updateLastLogin()                           │
│  │  │  └─ Nếu sai → return null                                  │
│  ├─ Nếu user != null:                                            │
│  │  ├─ req.getSession().setAttribute("user", user)               │
│  │  ├─ Nếu vai trò = 'QUAN_TRI_VIEN' → redirect /admin/dashboard│
│  │  └─ Nếu vai trò = 'KHACH_HANG' → redirect /home              │
│  └─ Nếu user == null:                                            │
│     └─ setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu")  │
│     └─ forward đến /jsp/login.jsp                                │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                       PHÂN QUYỀN (Authorization)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  AuthenticationFilter:                                           │
│  ├─ URL patterns: /cart/*, /checkout, /orders, /profile/*, /review, /builder  │
│  ├─ Kiểm tra session.getAttribute("user") != null                │
│  └─ Nếu chưa login → redirect /login                             │
│                                                                  │
│  AdminFilter:                                                    │
│  ├─ URL patterns: /admin/*                                       │
│  ├─ Kiểm tra user.getVaiTro().equals("QUAN_TRI_VIEN")            │
│  └─ Nếu không phải admin → 403 Forbidden                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2. Luồng Mua Hàng (Shopping Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│                       LUỒNG MUA HÀNG                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Bước 1: XEM SẢN PHẨM (không cần đăng nhập)                     │
│  ─────────────────────────────────────────                      │
│  GET /shop?category=2&page=1&sort=price_asc                      │
│  ├─ ProductServlet.doGet()                                       │
│  ├─ ProductService.getProducts(categoryId, sort, offset, limit)  │
│  ├─ ProductDAO.findByCategory()                                  │
│  │  └─ SELECT sp.* FROM SAN_PHAM sp                              │
│  │     JOIN LOAI_SAN_PHAM lsp WHERE sp.TrangThai=1              │
│  │     AND sp.MaLoaiSP=? LIMIT ? OFFSET ?                        │
│  └─ Forward đến shop.jsp với products list và pagination         │
│                                                                  │
│  Bước 2: XEM CHI TIẾT SẢN PHẨM                                   │
│  ─────────────────────────────────────────                      │
│  GET /product?id=1                                                │
│  ├─ ProductServlet.doGet()                                       │
│  ├─ ProductService.getProductDetail(id)                          │
│  │  ├─ productDAO.getById(id) → Product                          │
│  │  ├─ productImageDAO.getByProductId(id) → List<ProductImage>   │
│  │  ├─ componentDetailDAO.getByProductIdAndType(id, type) → Detail│
│  │  └─ reviewDAO.getByProduct(id, true) → List<Review>          │
│  └─ Forward đến product-detail.jsp                                │
│                                                                  │
│  Bước 3: THÊM VÀO GIỎ HÀNG (cần đăng nhập)                       │
│  ─────────────────────────────────────────                      │
│  POST /cart (action=add)                                          │
│  ├─ CartServlet.doPost()                                         │
│  ├─ Kiểm tra user đã login (qua AuthenticationFilter)            │
│  ├─ cartService.addItem(cartId, productId, quantity)             │
│  │  ├─ Kiểm tra tồn kho                                          │
│  │  ├─ INSERT ON DUPLICATE KEY UPDATE vào CHI_TIET_GIO_HANG     │
│  │  └─ Cập nhật DonGia với giá hiện tại                          │
│  └─ Redirect đến /cart                                           │
│                                                                  │
│  Bước 4: XEM VÀ CHỈNH SỬA GIỎ HÀNG                               │
│  ────────────────────────────────────────                      │
│  GET /cart                                                        │
│  ├─ CartServlet.doGet()                                          │
│  ├─ cartService.getItems(cartId)                                 │
│  │  └─ JOIN 4 tables: CHI_TIET_GIO_HANG + SAN_PHAM +            │
│  │     ANH_SAN_PHAM (WHERE LaAnhDaiDien=1)                       │
│  └─ Forward đến cart.jsp                                          │
│                                                                  │
│  POST /cart/update (action=update, productId=X, quantity=Y)      │
│  ├─ CartServlet.doPost()                                         │
│  └─ cartService.updateItem(cartId, productId, newQuantity)       │
│                                                                  │
│  POST /cart/remove (productId=X)                                  │
│  ├─ cartServlet.doPost                                           │
│  └─ DELETE FROM CHI_TIET_GIO_HANG WHERE MaGioHang=? AND MaSP=?  │
│                                                                  │
│  Bước 5: ÁP DỤNG VOUCHER (tùy chọn)                              │
│  ─────────────────────────────────────────                      │
│  POST /cart/voucher (voucherCode=X)                               │
│  ├─ CartServlet.doPost()                                         │
│  ├─ Tìm KHUYEN_MAI theo TenKM                                    │
│  ├─ Kiểm tra promo.isValid() (thời gian, trạng thái)             │
│  ├─ Tính discount                                                │
│  │  └─ PHAN_TRAM: total × giaTriGiam / 100                      │
│  │  └─ SO_TIEN: min(giaTriGiam, total)                           │
│  └─ Lưu vào session attribute "voucher"                           │
│                                                                  │
│  Bước 6: THANH TOÁN                                               │
│  ─────────────────────                                           │
│  GET /checkout                                                    │
│  ├─ OrderServlet.doGet()                                          │
│  ├─ Tính subtotal, shipping, discount                            │
│  └─ Forward đến checkout.jsp                                     │
│                                                                  │
│  Bước 7: ĐẶT HÀNG (QUAN TRỌNG - CÓ TRANSACTION)                  │
│  ────────────────────────────────────────────                   │
│  POST /order/place                                                │
│  ├─ OrderServlet.doPost()                                        │
│  └─ OrderService.placeOrder(maKH, address, phone, note,          │
│                              maKM, maPTTT)                        │
│     ┌─────────────────────────────────────────────────────────┐  │
│     │  BẮT ĐẦU TRANSACTION (conn.setAutoCommit(false))         │  │
│     │                                                           │  │
│     │  1. INSERT INTO DON_HANG                                 │  │
│     │     → Lấy MaDonHang (auto-generated key)                 │  │
│     │                                                           │  │
│     │  2. INSERT INTO CHI_TIET_DON_HANG (batch)                │  │
│     │     → Mỗi item trong giỏ hàng                            │  │
│     │                                                           │  │
│     │  3. UPDATE SAN_PHAM SET SoLuongTon -= quantity            │  │
│     │     → Cập nhật tồn kho cho từng sản phẩm                 │  │
│     │                                                           │  │
│     │  4. INSERT INTO THANH_TOAN                               │  │
│     │     → Trạng thái: 'CHUA_THANH_TOAN'                      │  │
│     │                                                           │  │
│     │  5. DELETE FROM CHI_TIET_GIO_HANG                        │  │
│     │     → Xóa giỏ hàng (do đã đặt hàng xong)                 │  │
│     │                                                           │  │
│     │  COMMIT (Nếu tất cả thành công)                          │  │
│     │  ROLLBACK (Nếu có lỗi bất kỳ)                            │  │
│     └─────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Bước 8: ADMIN XỬ LÝ ĐƠN HÀNG                                    │
│  ─────────────────────────────                                  │
│  GET /admin/orders → AdminOrderServlet                           │
│  ├─ Danh sách đơn hàng (mới nhất ở trên)                        │
│  └─ Click "Xác nhận" → PUT /admin/order/update-status           │
│     Trạng thái: CHO_XAC_NHAN → DA_XAC_NHAN                      │
│                 → DANG_GIAO → DA_GIAO                            │
│     Hủy: → DA_HUY (hoàn lại tồn kho)                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 7.3. Luồng PC Builder

```
┌─────────────────────────────────────────────────────────────────┐
│                       PC BUILDER FLOW                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Bước 1: Mở PC Builder                                           │
│  ─────────────────────                                          │
│  GET /builder                                                     │
│  ├─ PcBuilderServlet.doGet()                                     │
│  ├─ PcBuilderService.getComponents()                             │
│  │  └─ Load tất cả linh kiện, phân loại theo danh mục           │
│  └─ Forward đến builder.jsp                                       │
│                                                                  │
│  Bước 2: Chọn Linh Kiện                                          │
│  ─────────────────────                                          │
│  User chọn từng loại linh kiện:                                  │
│  ├─ Chọn CPU                                                     │
│  ├─ Chọn Mainboard (cùng socket với CPU)                         │
│  ├─ Chọn RAM (cùng loại với Mainboard: DDR4/DDR5)               │
│  ├─ Chọn VGA (tương thích PCIe slot)                             │
│  ├─ Chọn Case (hỗ trợ kích thước Mainboard)                     │
│  ├─ Chọn PSU (đủ công suất cho toàn bộ hệ thống)                │
│  ├─ Chọn Ổ cứng (SATA/M.2 phù hợp)                              │
│  └─ Chọn Tản nhiệt (tương thích socket CPU)                     │
│                                                                  │
│  AJAX Request → GET /api/builder/compatible?type=cpu_socket=X    │
│  ├─ PcBuilderApiServlet.doGet()                                   │
│  ├─ PcBuilderDAO.findCompatible()                                │
│  └─ Return JSON: danh sách linh kiện tương thích                │
│                                                                  │
│  Bước 3: Kiểm Tra Tương Thích                                    │
│  ────────────────────────────                                   │
│  PcBuilderService.checkCompatibility(selectedParts):             │
│  ├─ CPU socket == Mainboard socket?                              │
│  ├─ RAM type == Mainboard supported RAM type?                    │
│  ├─ Case form factor >= Mainboard form factor?                   │
│  ├─ PSU wattage >= total TDP?                                    │
│  └─ Cooler socket compatibility list contains CPU socket?        │
│                                                                  │
│  Bước 4: Thêm Vào Giỏ Hàng                                       │
│  ──────────────────────────                                      │
│  POST /builder (maSP[] = [cpuId, mbId, ramId, ...])               │
│  ├─ PcBuilderServlet.doPost()                                     │
│  ├─ Thêm tất cả linh kiện vào giỏ hàng                          │
│  └─ Redirect đến /cart                                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 7.4. Luồng Admin Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                      ADMIN DASHBOARD FLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  GET /admin/dashboard → AdminStatsServlet                        │
│  ├─ StatsService                                                │
│  │  ├─ getTotalOrders() → COUNT(*) FROM DON_HANG                │
│  │  ├─ getTotalRevenue() → SUM(TongTien) WHERE DA_GIAO         │
│  │  ├─ getTotalUsers() → COUNT(*) FROM KHACH_HANG              │
│  │  ├─ getTotalProducts() → COUNT(*) FROM SAN_PHAM             │
│  │  ├─ getRecentOrders(10) → Top 10 đơn hàng mới nhất          │
│  │  ├─ getTopSelling(10) → Top 10 sản phẩm bán chạy            │
│  │  └─ getMonthlyStats(year, month) → Thống kê theo ngày       │
│  └─ Forward đến admin/dashboard.jsp                              │
│                                                                  │
│  Quản Lý Sản Phẩm → AdminProductServlet                          │
│  ├─ GET /admin/products → Danh sách sản phẩm                     │
│  ├─ POST /admin/product/add → Thêm sản phẩm mới                  │
│  ├─ POST /admin/product/update → Cập nhật sản phẩm               │
│  └─ POST /admin/product/delete → Xóa sản phẩm                   │
│                                                                  │
│  Quản Lý Đơn Hàng → AdminOrderServlet                            │
│  ├─ GET /admin/orders → Danh sách đơn hàng                       │
│  ├─ GET /admin/order/detail → Chi tiết đơn hàng                  │
│  └─ POST /admin/order/update-status → Cập nhật trạng thái       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 7.5. Luồng Khuyến Mãi (Promotion Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│                      PROMOTION FLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Admin tạo khuyến mãi:                                           │
│  ├─ POST /admin/promotion/create                                 │
│  ├─ Tham số: TenKM, LoaiGiam, GiaTriGiam, NgayBatDau,           │
│  │           NgayKetThuc, DanhSachSP                             │
│  └─ INSERT INTO KHUYEN_MAI + KHUYEN_MAI_SAN_PHAM                │
│                                                                  │
│  User áp dụng voucher tại giỏ hàng:                               │
│  ├─ POST /cart/voucher (voucherCode)                              │
│  ├─ PromotionService.applyVoucher(maKM, total)                   │
│  │  ├─ Validate:                                                  │
│  │  │  ├─ promotion != null                                      │
│  │  │  ├─ trangThai == 1 (active)                                │
│  │  │  ├─ Ngày hiện tại trong khoảng NgayBatDau..NgayKetThuc    │
│  │  │  └─ (Tùy chọn) Sản phẩm trong giỏ có thuộc KM không?      │
│  │  └─ Calculate:                                                │
│  │     ├─ PHAN_TRAM: discount = total × giaTriGiam / 100        │
│  │     └─ SO_TIEN: discount = min(giaTriGiam, total)             │
│  └─ Lưu voucher info vào session                                 │
│                                                                  │
│  Khi đặt hàng:                                                    │
│  ├─ MaKM được lưu vào DON_HANG                                   │
│  └─ Discount được tính vào TongTien                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 8. SECURITY & PERFORMANCE

### 8.1. Security Hiện Tại

#### ✅ Đã Có

| Biện pháp                   | Mô tả                              |
| --------------------------- | ---------------------------------- |
| **BCrypt Password Hashing** | Mật khẩu được hash trước khi lưu   |
| **PreparedStatement**       | Chống SQL Injection                |
| **Authentication Filter**   | Bảo vệ các URL yêu cầu đăng nhập   |
| **Admin Filter**            | Phân quyền admin                   |
| **Session Timeout**         | web.xml: session-timeout = 30 phút |
| **UTF-8 Encoding**          | EncodingFilter cho tất cả requests |

#### ❌ Chưa Có (Cần Cải Thiện)

| Vấn đề                     | Mức độ      | Giải pháp                      |
| -------------------------- | ----------- | ------------------------------ |
| **Hard-coded credentials** | 🔴 CRITICAL | Sử dụng env variables          |
| **No CSRF protection**     | 🔴 CRITICAL | Thêm CSRF token vào forms      |
| **Session fixation**       | 🔴 CRITICAL | Regenerate session sau login   |
| **No input validation**    | 🟡 MEDIUM   | Validate tất cả user input     |
| **No XSS prevention**      | 🟡 MEDIUM   | Escape output trong JSP        |
| **No rate limiting**       | 🟢 LOW      | Giới hạn số lần login/register |
| **No HTTPS**               | 🟢 LOW      | Cấu hình SSL/TLS               |

### 8.2. Performance Hiện Tại

#### ✅ Đã Có

| Biện pháp                    | Mô tả                                   |
| ---------------------------- | --------------------------------------- |
| **HikariCP Connection Pool** | Tái sử dụng connections                 |
| **Database Indexes**         | 11 indexes cho các queries thường xuyên |
| **FULLTEXT Index**           | Tìm kiếm sản phẩm nhanh                 |
| **Pagination**               | Giới hạn số lượng records mỗi lần query |
| **ON DUPLICATE KEY UPDATE**  | Update/Insert trong 1 query             |

#### ❌ Chưa Có (Cần Cải Thiện)

| Vấn đề                    | Mức độ    | Giải pháp                            |
| ------------------------- | --------- | ------------------------------------ |
| **No Caching**            | 🔴 HIGH   | Thêm Redis (Jedis đã import)         |
| **N+1 Query Problem**     | 🟡 MEDIUM | JOIN trong query chính               |
| **No Lazy Loading**       | 🟡 MEDIUM | Load chi tiết khi cần                |
| **No Query Optimization** | 🟢 LOW    | EXPLAIN queries, add missing indexes |

### 8.3. Redis Caching (Jedis đã import, chưa dùng)

```xml
<!-- pom.xml đã có dependency -->
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>4.3.1</version>
</dependency>
```

**Gợi ý triển khai**:

```java
public class CacheManager {
    private static JedisPool jedisPool;

    static {
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(10);
        jedisPool = new JedisPool(config, "localhost", 6379);
    }

    // Cache products
    public List<Product> getCachedProducts(String key) {
        try (Jedis jedis = jedisPool.getResource()) {
            String json = jedis.get(key);
            return json != null ? gson.fromJson(json, new TypeToken<List<Product>>(){}.getType()) : null;
        }
    }

    public void cacheProducts(String key, List<Product> products, int ttlSeconds) {
        try (Jedis jedis = jedisPool.getResource()) {
            jedis.setex(key, ttlSeconds, gson.toJson(products));
        }
    }

    // Cache categories (ít thay đổi)
    public void cacheCategories(List<Category> categories) {
        try (Jedis jedis = jedisPool.getResource()) {
            jedis.setex("categories", 3600, gson.toJson(categories));
        }
    }
}
```

### 8.4. CSRF Protection (Cần Thêm)

```java
// Filter tạo CSRF token
@WebFilter("/*")
public class CsrfFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession();
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }
        chain.doFilter(request, response);
    }
}

// Trong Servlet POST
protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
    String token = req.getParameter("csrfToken");
    String sessionToken = (String) req.getSession().getAttribute("csrfToken");
    if (!token.equals(sessionToken)) {
        resp.sendError(403, "Invalid CSRF token");
        return;
    }
    // Xử lý request
}

// Trong JSP form
<form method="post">
    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
    <!-- Các fields khác -->
</form>
```

---

## 9. HƯỚNG DẪN SETUP & DEPLOY

### 9.1. Yêu Cầu Hệ Thống

| Thành phần                 | Phiên bản                       |
| -------------------------- | ------------------------------- |
| Java Development Kit (JDK) | 21+                             |
| Apache Maven               | 3.6+                            |
| MySQL                      | 8.0+                            |
| Apache Tomcat              | 11.x (Jakarta EE 10 compatible) |

### 9.2. Cài Đặt Database

```bash
# 1. Tạo database và tables
mysql -u root -p < database/schema.sql

# 2. Nạp dữ liệu mẫu (tùy chọn)
mysql -u root -p ComputerSpace < database/Sample_data.sql

# 3. Nạp dữ liệu mở rộng (tùy chọn)
mysql -u root -p ComputerSpace < database/Extend_Data.sql
```

### 9.3. Cấu Hình Database Connection

Sửa file `src/main/resources/database.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/ComputerSpace?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh
db.username=root
db.password=123456
db.driver=com.mysql.cj.jdbc.Driver
```

**Khuyến nghị**: Sử dụng environment variables để bảo mật:

```bash
# Set environment variables
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=ComputerSpace
export DB_USERNAME=root
export DB_PASSWORD=your_secure_password
```

Source code sẽ tự động đọc `DB_HOST` từ env:

```java
String envHost = System.getenv("DB_HOST");
if (envHost != null && !envHost.isEmpty()) {
    url = url.replace("localhost", envHost);
}
```

### 9.4. Build Project

```bash
# Build WAR file
mvn clean package

# Skip tests nếu cần
mvn clean package -DskipTests

# Run with embedded Tomcat
mvn cargo:run
```

### 9.5. Deploy lên Tomcat

```bash
# Copy WAR to Tomcat webapps
cp target/computerstore.war /path/to/tomcat11/webapps/

# Start Tomcat
/path/to/tomcat11/bin/startup.sh

# Stop Tomcat
/path/to/tomcat11/bin/shutdown.sh
```

### 9.6. Truy Cập Ứng Dụng

| URL                                                   | Mô tả           |
| ----------------------------------------------------- | --------------- |
| `http://localhost:8080/computerstore/`                | Trang chủ       |
| `http://localhost:8080/computerstore/admin/dashboard` | Admin Dashboard |
| `http://localhost:8080/computerstore/login`           | Đăng nhập       |

### 9.7. Tài Khoản Mặc Định (Sample Data)

| Vai trò  | Username              | Password   |
| -------- | --------------------- | ---------- |
| Admin    | `admin`               | `admin123` |
| Customer | (tạo mới qua đăng ký) |            |

---

## 10. CÁC VẤN ĐỀ CẦN CẢI THIỆN

### 10.1. 🔴 Mức Độ Nghiêm Trọng Cao

| #   | Vấn đề                         | File              | Giải pháp                                                        |
| --- | ------------------------------ | ----------------- | ---------------------------------------------------------------- |
| 1   | **Hard-coded credentials**     | DBConnection.java | Đọc từ env variables hoặc file config bên ngoài                  |
| 2   | **Thiếu CSRF protection**      | Tất cả forms POST | Thêm CSRF token + filter validation                              |
| 3   | **Session fixation**           | AuthServlet       | `session.invalidate()` → tạo session mới sau login               |
| 4   | **Không review session regen** | AuthServlet       | `req.getSession(true).setAttribute(...)` thay vì dùng session cũ |

### 10.2. 🟡 Mức Độ Trung Bình

| #   | Vấn đề                               | Mô tả                                         | Giải pháp                                   |
| --- | ------------------------------------ | --------------------------------------------- | ------------------------------------------- |
| 5   | **Business logic trong Controller**  | Logic tính shipping fee trong CartServlet     | Di chuyển vào CartService/OrderService      |
| 6   | **Code trùng lặp**                   | Pagination logic lặp lại nhiều nơi            | Tạo utility method hoặc base servlet        |
| 7   | **Exception handling không đồng bộ** | Có nơi throw, có nơi printStackTrace          | Chuẩn hóa strategy (dùng DatabaseException) |
| 8   | **Thiếu validation**                 | parseInt không kiểm tra NumberFormatException | Dùng ValidationUtil.isValidPositiveInt()    |
| 9   | **ValidationUtil chưa dùng hết**     | Email/Phone validation có sẵn nhưng chưa dùng | Apply vào tất cả forms                      |

### 10.3. 🟢 Mức Độ Thấp

| #   | Vấn đề                  | Mô tả                                                 |
| --- | ----------------------- | ----------------------------------------------------- |
| 10  | **Typo URL**            | `/cheackout.jsp` → nên sửa thành `/checkout.jsp`      |
| 11  | **Thiếu JavaDoc**       | Hầu hết classes không có documentation                |
| 12  | **Không có Unit Tests** | JUnit + Mockito đã import nhưng chưa có test nào      |
| 13  | **Thiếu indexes**       | DON_HANG(NgayDat) chưa có index cho queries theo ngày |
| 14  | **N+1 Query Problem**   | ProductDAO.extractProduct() cần tối ưu JOIN           |
| 15  | **Không có caching**    | Redis (Jedis) đã import nhưng chưa triển khai         |

### 10.4. Roadmap Cải Thiện

```
Priority 1 (Security)
├── [ ] Externalize database credentials → env variables
├── [ ] Add CSRF protection → tokens + filter
├── [ ] Fix session fixation → regenerate session after login
├── [ ] Add input validation → apply ValidationUtil everywhere
└── [ ] Add XSS prevention → escape output in JSP

Priority 2 (Performance)
├── [ ] Implement Redis caching → CacheManager
├── [ ] Optimize N+1 queries → JOIN trong query chính
├── [ ] Add missing indexes → DON_HANG(NgayDat)
└── [ ] Analyze slow queries → EXPLAIN + optimize

Priority 3 (Code Quality)
├── [ ] Add Unit Tests → JUnit 5 + Mockito
├── [ ] Add JavaDoc → Tất cả public methods
├── [ ] Refactor business logic → Controller → Service
├── [ ] Standardize exception handling → Global handler
└── [ ] Add logging → SLF4J properly configured

Priority 4 (Features)
├── [ ] Implement forgot-password → Email service
├── [ ] Add payment gateway → VNPay/MoMo integration
├── [ ] Add product comparison
├── [ ] Add wishlist
├── [ ] Email notifications → Order confirmation
└── [ ] Export reports → Excel/PDF
```

---

## PHỤ LỤC

### A. Danh Sách Đầy Đủ Các Files

#### Controllers (17 files)

| File                       | Đường dẫn                                    | URL Patterns                                                  |
| -------------------------- | -------------------------------------------- | ------------------------------------------------------------- |
| AuthServlet.java           | controllers/AuthServlet.java                 | /login, /register, /logout, /forgot-password                  |
| HomeServlet.java           | controllers/HomeServlet.java                 | /home, /                                                      |
| ProductServlet.java        | controllers/ProductServlet.java              | /products, /product, /search, /category                       |
| CartServlet.java           | controllers/CartServlet.java                 | /cart, /cart/update, /cart/remove, /cart/clear, /cart/voucher |
| OrderServlet.java          | controllers/OrderServlet.java                | /checkout, /order/place, /orders, /order/cancel               |
| ProfileServlet.java        | controllers/ProfileServlet.java              | /profile, /profile/update, /profile/change-password           |
| ContactServlet.java        | controllers/ContactServlet.java              | /contact                                                      |
| PromotionServlet.java      | controllers/PromotionServlet.java            | /promotions                                                   |
| ReviewServlet.java         | controllers/ReviewServlet.java               | /review                                                       |
| PcBuilderServlet.java      | controllers/PcBuilderServlet.java            | /builder                                                      |
| AdminStatsServlet.java     | controllers/admin/AdminStatsServlet.java     | /admin/dashboard, /admin/                                     |
| AdminProductServlet.java   | controllers/admin/AdminProductServlet.java   | /admin/products, /admin/product/\*                            |
| AdminOrderServlet.java     | controllers/admin/AdminOrderServlet.java     | /admin/orders, /admin/order/\*                                |
| AdminAccountServlet.java   | controllers/admin/AdminAccountServlet.java   | /admin/accounts                                               |
| AdminPromotionServlet.java | controllers/admin/AdminPromotionServlet.java | /admin/promotions                                             |
| AdminReviewServlet.java    | controllers/admin/AdminReviewServlet.java    | /admin/reviews                                                |
| PcBuilderApiServlet.java   | controllers/api/PcBuilderApiServlet.java     | /api/builder/\*                                               |

#### Services (9 files)

| File                  | Mô tả                                       |
| --------------------- | ------------------------------------------- |
| UserService.java      | Authentication, registration, profile       |
| ProductService.java   | Product listing, detail, search             |
| CartService.java      | Cart operations, subtotal, shipping         |
| OrderService.java     | Place order, cancel, transaction management |
| PaymentService.java   | Payment processing                          |
| PromotionService.java | Voucher validation, discount calculation    |
| ReviewService.java    | Review submission, approval                 |
| PcBuilderService.java | Component compatibility checking            |
| StatsService.java     | Dashboard statistics, reports               |

#### DAOs (14 files)

| File                     | Bảng tương ứng                       |
| ------------------------ | ------------------------------------ |
| UserDAO.java             | TAI_KHOAN, KHACH_HANG, QUAN_TRI_VIEN |
| ProductDAO.java          | SAN_PHAM                             |
| CategoryDAO.java         | LOAI_SAN_PHAM                        |
| ProductImageDAO.java     | ANH_SAN_PHAM                         |
| ComponentDetailDAO.java  | CHI_TIET_MAIN, CHI_TIET_CPU, ...     |
| CartDAO.java             | GIO_HANG, CHI_TIET_GIO_HANG          |
| OrderDAO.java            | DON_HANG                             |
| OrderDetailDAO.java      | CHI_TIET_DON_HANG                    |
| PaymentDAO.java          | THANH_TOAN                           |
| PromotionDAO.java        | KHUYEN_MAI                           |
| PromotionProductDAO.java | KHUYEN_MAI_SAN_PHAM                  |
| ReviewDAO.java           | DANH_GIA                             |
| StatsDAO.java            | Aggregate queries                    |
| PcBuilderDAO.java        | Component queries                    |

#### Models (15 files)

| File                 | Mô tả                                |
| -------------------- | ------------------------------------ |
| User.java            | TAI_KHOAN + KHACH_HANG/QUAN_TRI_VIEN |
| Product.java         | SAN_PHAM                             |
| Category.java        | LOAI_SAN_PHAM                        |
| ProductImage.java    | ANH_SAN_PHAM                         |
| CartItem.java        | CHI_TIET_GIO_HANG + SAN_PHAM         |
| Order.java           | DON_HANG                             |
| OrderDetail.java     | CHI_TIET_DON_HANG                    |
| Payment.java         | THANH_TOAN                           |
| PaymentMethod.java   | PHUONG_THUC_THANH_TOAN               |
| Promotion.java       | KHUYEN_MAI                           |
| Review.java          | DANH_GIA                             |
| CpuDetail.java       | CHI_TIET_CPU                         |
| MainboardDetail.java | CHI_TIET_MAIN                        |
| VgaDetail.java       | CHI_TIET_VGA                         |
| RamDetail.java       | CHI_TIET_RAM                         |
| StorageDetail.java   | CHI_TIET_O_CUNG                      |
| PsuDetail.java       | CHI_TIET_NGUON                       |
| CoolerDetail.java    | CHI_TIET_TAN_NHIET                   |
| CaseDetail.java      | CHI_TIET_CASE                        |

### B. Cấu Hình Maven Dependencies

```xml
<dependencies>
    <!-- Jakarta Servlet API (provided by Tomcat) -->
    <dependency>
        <groupId>jakarta.servlet</groupId>
        <artifactId>jakarta.servlet-api</artifactId>
        <version>6.1.0</version>
        <scope>provided</scope>
    </dependency>

    <!-- Jakarta JSP API (provided by Tomcat) -->
    <dependency>
        <groupId>jakarta.servlet.jsp</groupId>
        <artifactId>jakarta.servlet.jsp-api</artifactId>
        <version>4.0.0</version>
        <scope>provided</scope>
    </dependency>

    <!-- JSTL (JSP Standard Tag Library) -->
    <dependency>
        <groupId>jakarta.servlet.jsp.jstl</groupId>
        <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
        <version>3.0.0</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.web</groupId>
        <artifactId>jakarta.servlet.jsp.jstl</artifactId>
        <version>3.0.1</version>
    </dependency>

    <!-- Thymeleaf Template Engine -->
    <dependency>
        <groupId>org.thymeleaf</groupId>
        <artifactId>thymeleaf</artifactId>
        <version>3.1.5.RELEASE</version>
    </dependency>

    <!-- MySQL JDBC Driver -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <version>8.3.0</version>
    </dependency>

    <!-- BCrypt Password Hashing -->
    <dependency>
        <groupId>org.mindrot</groupId>
        <artifactId>jbcrypt</artifactId>
        <version>0.4</version>
    </dependency>

    <!-- HikariCP Connection Pool -->
    <dependency>
        <groupId>com.zaxxer</groupId>
        <artifactId>HikariCP</artifactId>
        <version>5.1.0</version>
    </dependency>

    <!-- SLF4J Logging -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>2.0.12</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-simple</artifactId>
        <version>2.0.12</version>
    </dependency>

    <!-- Gson JSON Processing -->
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.10.1</version>
    </dependency>

    <!-- Redis Client (Caching) -->
    <dependency>
        <groupId>redis.clients</groupId>
        <artifactId>jedis</artifactId>
        <version>4.3.1</version>
    </dependency>

    <!-- Testing -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.0</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-junit-jupiter</artifactId>
        <version>5.5.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### C. Cấu Hình web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <display-name>ComputerSpace</display-name>

    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <error-page>
        <error-code>404</error-code>
        <location>/404.jsp</location>
    </error-page>
</web-app>
```

### D. Cấu Hình database.properties

```properties
db.url=jdbc:mysql://localhost:3306/ComputerSpace?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true
db.username=root
db.password=123456
db.driver=com.mysql.cj.jdbc.Driver
```

### E. Tài Liệu Tham Khảo

1. **Jakarta EE 10 Documentation**: https://jakarta.ee/specifications/
2. **Jakarta Servlet 6.0**: https://jakarta.ee/specifications/servlet/6.0/
3. **JSP 4.0**: https://jakarta.ee/specifications/pages/4.0/
4. **JSTL 3.0**: https://jakarta.ee/specifications/tags/3.0/
5. **HikariCP**: https://github.com/brettwooldridge/HikariCP
6. **jBCrypt**: https://github.com/jeremyh/jBCrypt
7. **MySQL 8.0**: https://dev.mysql.com/doc/refman/8.0/en/
8. **Maven**: https://maven.apache.org/guides/
9. **Thymeleaf 3.1**: https://www.thymeleaf.org/documentation.html
10. **Gson**: https://github.com/google/gson

---

> **Tài liệu được tạo ngày**: 2026-05-12
> **Phiên bản**: 1.0
> **Tổng số file**: ~68 Java files, 15 database tables, 14 JSP pages
> **Tổng dòng code**: ~5,000+ lines
