# ComputerStore — Hệ Thống Bán Linh Kiện Máy Tính

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-blue.svg)](https://jakarta.ee/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1.svg)](https://www.mysql.com/)
[![Maven](https://img.shields.io/badge/Maven-3.6+-C71A36.svg)](https://maven.apache.org/)
[![Tomcat](https://img.shields.io/badge/Tomcat-11.x-F8DC75.svg)](https://tomcat.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Ứng dụng web thương mại điện tử **full-stack** chuyên bán linh kiện máy tính, xây dựng theo mô hình MVC thuần với Java Servlet + JSP. Bao gồm cổng mua sắm cho người dùng và bảng quản trị toàn diện cho admin.

---

## 📸 Demo

> _Chạy `mvn clean package` và deploy lên Tomcat để xem giao diện._

| Trang Chủ | Trang Admin Dashboard | PC Builder |
|---|---|---|
| _(screenshot)_ | _(screenshot)_ | _(screenshot)_ |

---

## ✨ Tính Năng

### 🛍️ Cổng Người Dùng
- Duyệt, lọc và tìm kiếm sản phẩm theo danh mục (CPU, GPU, RAM, Mainboard, v.v.)
- Giỏ hàng — thêm, sửa, xóa; áp dụng mã khuyến mãi
- **PC Builder** — tự tổng hợp cấu hình máy và thêm vào giỏ
- Đặt hàng với nhiều phương thức thanh toán (COD, chuyển khoản, ví điện tử)
- Theo dõi trạng thái đơn hàng, hủy đơn
- Đánh giá và xếp hạng sản phẩm
- Đăng ký / đăng nhập / đổi mật khẩu

### 👨‍💼 Bảng Quản Trị (Admin)
- **Dashboard** — doanh thu, đơn hàng, người dùng mới theo thời gian thực
- **Sản phẩm** — CRUD đầy đủ, quản lý ảnh, danh mục, tồn kho
- **Đơn hàng** — xem, xử lý, cập nhật trạng thái
- **Tài khoản** — quản lý user và admin
- **Khuyến mãi** — tạo voucher, gán sản phẩm, thiết lập thời hạn
- **Đánh giá** — duyệt / ẩn review
- **Báo cáo** — xuất báo cáo doanh thu theo khoảng thời gian

---

## 🛠️ Công Nghệ

| Lớp | Công nghệ |
|---|---|
| **Backend** | Java 21, Jakarta Servlet 6.1, JSP 4.0, JSTL 3.0 |
| **Database** | MySQL 8.0, HikariCP Connection Pool |
| **Frontend** | Bootstrap 5, JavaScript (Vanilla), Chart.js |
| **Security** | BCrypt password hashing, Filter-based auth |
| **Build** | Apache Maven 3.6+ |
| **Server** | Apache Tomcat 11.x |

---

## 📋 Yêu Cầu

- **Java** 21+
- **Maven** 3.6+
- **MySQL** 8.0+
- **Tomcat** 11.x (hoặc bất kỳ Jakarta EE 10 compatible server)

---

## 🚀 Hướng Dẫn Cài Đặt

### 1. Clone repository

```bash
git clone https://github.com/YOUR_USERNAME/computerstore.git
cd computerstore
```

### 2. Khởi tạo Database

```bash
# Tạo schema
mysql -u root -p < database/schema.sql

# (Tùy chọn) Nạp dữ liệu mẫu
mysql -u root -p ComputerSpace < database/Sample_data.sql
```

Chạy migrations theo thứ tự nếu cần nâng cấp từ phiên bản cũ:

```bash
mysql -u root -p ComputerSpace < database/migrations/v1-initial.sql
mysql -u root -p ComputerSpace < database/migrations/v2-add-reviews.sql
mysql -u root -p ComputerSpace < database/migrations/v3-add-indexes.sql
mysql -u root -p ComputerSpace < database/migrations/v4-account-upgrade.sql
```

### 3. Cấu Hình Kết Nối Database

```bash
# Copy file template
cp src/main/database.properties.example src/main/database.properties
cp src/main/resources/database.properties.example src/main/resources/database.properties 2>/dev/null || true
```

Sau đó mở `src/main/database.properties` và điền thông tin thật:

```properties
db.url=jdbc:mysql://localhost:3306/ComputerSpace?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8
db.username=your_db_username
db.password=your_db_password
db.driver=com.mysql.cj.jdbc.Driver
```

> ⚠️ File `database.properties` đã được thêm vào `.gitignore` — không bao giờ commit thông tin này lên repo.

### 4. Build

```bash
mvn clean package

# Bỏ qua tests
mvn clean package -DskipTests
```

### 5. Deploy lên Tomcat

```bash
cp target/computerstore.war /path/to/tomcat/webapps/
/path/to/tomcat/bin/startup.sh
```

### 6. Truy Cập

```
http://localhost:8080/computerstore
```

**Tài khoản admin mặc định** (sau khi chạy `Sample_data.sql`):

| Field | Giá trị |
|---|---|
| Username | `admin` |
| Password | `admin123` |

---

## 📁 Cấu Trúc Project

```
computerstore/
├── src/
│   ├── main/
│   │   ├── java/com/computerstore/
│   │   │   ├── controllers/        # Servlet controllers (MVC - C)
│   │   │   │   ├── admin/          # Admin-only servlets
│   │   │   │   └── api/            # JSON API endpoints
│   │   │   ├── services/           # Business logic layer
│   │   │   ├── dao/                # Data Access Objects (Repository)
│   │   │   ├── models/             # Entity / domain classes (MVC - M)
│   │   │   ├── dto/                # Data Transfer Objects
│   │   │   ├── filters/            # Auth & request filters
│   │   │   ├── exceptions/         # Custom exception types
│   │   │   └── utils/              # Helpers & utilities
│   │   ├── webapp/
│   │   │   ├── jsp/                # JSP view pages (MVC - V)
│   │   │   │   └── admin/          # Admin pages
│   │   │   ├── css/                # Custom stylesheets
│   │   │   ├── js/                 # JavaScript
│   │   │   └── WEB-INF/
│   │   │       └── web.xml         # Servlet configuration
│   │   └── database.properties.example   # DB config template
│   └── test/java/com/computerstore/      # JUnit tests
├── database/
│   ├── schema.sql                  # Full database schema
│   ├── Sample_data.sql             # Demo data
│   └── migrations/                 # Versioned migration scripts
├── docs/                           # Architecture & documentation
├── config/                         # Application config files
├── pom.xml
└── .env.example                    # Environment variable template
```

---

## 🗄️ Database Schema

**13 bảng chính** theo 3 nhóm chức năng:

#### Người Dùng
| Bảng | Mô tả |
|---|---|
| `TAI_KHOAN` | Tài khoản đăng nhập (username, password hash, role) |
| `KHACH_HANG` | Thông tin khách hàng |
| `QUAN_TRI_VIEN` | Thông tin admin |

#### Sản Phẩm & Danh Mục
| Bảng | Mô tả |
|---|---|
| `LOAI_SAN_PHAM` | 8 danh mục: Mainboard, CPU, VGA, Case, Nguồn, Tản Nhiệt, Ổ Cứng, RAM |
| `SAN_PHAM` | Thông tin sản phẩm chung |
| `ANH_SAN_PHAM` | Ảnh sản phẩm (nhiều ảnh/sản phẩm) |
| `CHI_TIET_*` | 8 bảng chi tiết thông số kỹ thuật theo từng loại linh kiện |

#### Giao Dịch & Marketing
| Bảng | Mô tả |
|---|---|
| `GIO_HANG`, `CHI_TIET_GIO_HANG` | Giỏ hàng |
| `DON_HANG`, `CHI_TIET_DON_HANG` | Đơn hàng |
| `THANH_TOAN`, `PHUONG_THUC_THANH_TOAN` | Thanh toán |
| `KHUYEN_MAI`, `KHUYEN_MAI_SAN_PHAM` | Chương trình khuyến mãi |
| `DANH_GIA` | Đánh giá sản phẩm |

---

## 🔗 Các Endpoint Chính

### Người Dùng
```
GET  /                          Trang chủ
GET  /shop                      Danh sách sản phẩm
GET  /product?id={id}           Chi tiết sản phẩm
GET  /search?q={keyword}        Tìm kiếm
GET  /builder                   PC Builder
POST /cart                      Thêm vào giỏ hàng
POST /order/place               Đặt hàng
GET  /orders                    Đơn hàng của tôi
POST /login, /register          Xác thực
```

### Admin (`/admin/*`)
```
GET  /admin/                    Dashboard
GET  /admin/products            Quản lý sản phẩm
GET  /admin/orders              Quản lý đơn hàng
GET  /admin/accounts            Quản lý tài khoản
GET  /admin/promotions          Quản lý khuyến mãi
GET  /admin/reviews             Duyệt đánh giá
GET  /admin/reports             Báo cáo & thống kê
```

---

## 📖 Tài Liệu

| Tài liệu | Nội dung |
|---|---|
| [SYSTEM_DOCUMENTATION.md](docs/SYSTEM_DOCUMENTATION.md) | Kiến trúc tổng quan, luồng xử lý |
| [SYSTEM_DOCUMENTATION_COMPREHENSIVE.md](docs/SYSTEM_DOCUMENTATION_COMPREHENSIVE.md) | Tài liệu đầy đủ chi tiết |
| [DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md) | Kế hoạch phát triển |
| [database/schema.sql](database/schema.sql) | Schema database đầy đủ |

---

## 📄 License

Dự án này được phát triển cho mục đích học tập. Xem [LICENSE](LICENSE) để biết thêm.

---

> **Lưu ý**: Đây là project học tập (academic project). Trước khi đưa vào production cần bổ sung thêm CSRF protection, HTTPS, và environment-based configuration.
