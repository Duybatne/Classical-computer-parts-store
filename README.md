# ComputerStore - Hệ Thống Bán Linh Kiện Máy Tính

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta-EE%2010-blue.svg)](https://jakarta.ee/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Maven](https://img.shields.io/badge/Maven-3.6+-red.svg)](https://maven.apache.org/)

Ứng dụng web thương mại điện tử chuyên bán linh kiện máy tính với đầy đủ chức năng từ mua sắm, thanh toán đến quản trị.

## ✨ Tính Năng Chính

### 👥 Người Dùng

- 🛍️ **Mua sắm**: Xem sản phẩm, lọc, tìm kiếm, xem chi tiết
- 🛒 **Giỏ hàng**: Thêm, sửa, xóa sản phẩm
- 🖥️ **PC Builder**: Tự build cấu hình máy tính
- 💳 **Thanh toán**: Nhiều phương thức (COD, chuyển khoản, ví điện tử)
- 🎫 **Khuyến mãi**: Áp dụng mã giảm giá
- ⭐ **Đánh giá**: Review và rating sản phẩm

### 👨‍💼 Quản Trị Viên

- 📊 **Dashboard**: Thống kê, biểu đồ
- 📦 **Quản lý sản phẩm**: CRUD, hình ảnh, danh mục
- 📋 **Quản lý đơn hàng**: Xử lý, cập nhật trạng thái
- 👥 **Quản lý tài khoản**: User và admin
- 🏷️ **Quản lý khuyến mãi**: Tạo voucher, chương trình giảm giá
- 💬 **Duyệt đánh giá**: Kiểm duyệt reviews

## 🛠️ Công Nghệ Sử Dụng

| Thành Phần     | Công Nghệ                             |
| -------------- | ------------------------------------- |
| **Backend**    | Java 21, Jakarta Servlet 6.1, JSP 4.0 |
| **Database**   | MySQL 8.0, HikariCP Connection Pool   |
| **Frontend**   | JSP, JSTL, Bootstrap 5, JavaScript    |
| **Security**   | BCrypt password hashing               |
| **Build Tool** | Maven 3.6+                            |
| **Server**     | Tomcat 11.x                           |

## 📋 Yêu Cầu Hệ Thống

- Java 21+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 11.x (hoặc Jakarta EE compatible server)

## 🚀 Hướng Dẫn Cài Đặt

### 1. Clone và Cài Đặt Database

```bash
# Tạo database và nạp schema
mysql -u root -p < database/schema.sql

# Nạp dữ liệu mẫu (tùy chọn)
mysql -u root -p ComputerSpace < database/Sample_data.sql
```

### 2. Cấu Hình Database Connection

Sửa file `src/main/java/com/computerstore/utils/DBConnection.java`:

```java
config.setJdbcUrl("jdbc:mysql://localhost:3306/ComputerSpace");
config.setUsername("your_username");    // Thay bằng username của bạn
config.setPassword("your_password");    // Thay bằng password của bạn
```

### 3. Build Project

```bash
# Clean and build
mvn clean package

# Skip tests nếu cần
mvn clean package -DskipTests
```

### 4. Deploy lên Tomcat

```bash
# Copy WAR file
cp target/computerstore.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh
```

### 5. Truy Cập Ứng Dụng

```
http://localhost:8080/computerstore
```

### 6. Đăng Nhập Admin (Mặc Định)

Sau khi chạy `Sample_data.sql`:

- **Username**: `admin`
- **Password**: `admin123`

## 📁 Cấu Trúc Project

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
│   └── Sample_data.sql      # Sample data
└── pom.xml                  # Maven configuration
```

## 🗄️ Cơ Sở Dữ Liệu

### Các Bảng Chính (13 tables)

#### Quản Lý Người Dùng

- `TAI_KHOAN` - Tài khoản đăng nhập
- `KHACH_HANG` - Thông tin khách hàng
- `QUAN_TRI_VIEN` - Thông tin admin

#### Quản Lý Sản Phẩm

- `LOAI_SAN_PHAM` - Danh mục (8 loại: Main, CPU, VGA, Case, Nguồn, Tản nhiệt, Ổ cứng, RAM)
- `SAN_PHAM` - Thông tin sản phẩm
- `ANH_SAN_PHAM` - Ảnh sản phẩm
- `CHI_TIET_*` - 8 bảng chi tiết cho từng loại linh kiện

#### Giao Dịch

- `GIO_HANG` & `CHI_TIET_GIO_HANG` - Giỏ hàng
- `DON_HANG` & `CHI_TIET_DON_HANG` - Đơn hàng
- `THANH_TOAN` & `PHUONG_THUC_THANH_TOAN` - Thanh toán

#### Marketing

- `KHUYEN_MAI` & `KHUYEN_MAI_SAN_PHAM` - Khuyến mãi
- `DANH_GIA` - Đánh giá sản phẩm

## 🔗 API Endpoints

### Authentication

- `POST /login` - Đăng nhập
- `POST /register` - Đăng ký
- `GET /logout` - Đăng xuất

### Products

- `GET /shop` - Danh sách sản phẩm
- `GET /product/{id}` - Chi tiết sản phẩm
- `GET /category/{name}` - Sản phẩm theo danh mục
- `GET /search?q=keyword` - Tìm kiếm

### Cart

- `GET /cart` - Xem giỏ hàng
- `POST /cart` - Thêm vào giỏ
- `POST /cart/update` - Cập nhật số lượng
- `POST /cart/remove` - Xóa sản phẩm
- `POST /cart/voucher` - Áp dụng mã giảm giá

### Orders

- `GET /checkout` - Trang thanh toán
- `POST /order/place` - Đặt hàng
- `GET /orders` - Đơn hàng của tôi
- `POST /order/cancel` - Hủy đơn hàng

### PC Builder

- `GET /builder` - Trang build PC
- `POST /builder` - Thêm config vào giỏ

### Admin

- `GET /admin/` - Dashboard
- `GET /admin/products` - Quản lý sản phẩm
- `GET /admin/orders` - Quản lý đơn hàng
- `GET /admin/accounts` - Quản lý tài khoản
- `GET /admin/promotions` - Quản lý khuyến mãi
- `GET /admin/reviews` - Duyệt đánh giá

## ⚠️ Lưu Ý Quan Trọng

### Security Issues (Cần Cải Thiện)

1. **Hard-coded credentials** - Database credentials đang hard-code trong code
2. **Thiếu CSRF protection** - Không có CSRF token trong forms
3. **Session fixation** - Không regenerate session sau login

### Performance Issues

1. **Không có caching** - Tất cả queries đều hit database
2. **N+1 query problem** - Một số queries có thể tối ưu
3. **Thiếu indexes** - Một số columns quan trọng chưa có index

📖 **Xem chi tiết trong**: [docs/SYSTEM_DOCUMENTATION.md](docs/SYSTEM_DOCUMENTATION.md)

## 📖 Tài Liệu Chi Tiết

Để biết thêm thông tin chi tiết về kiến trúc, database schema, business logic và các vấn đề cần cải thiện, vui lòng xem:

👉 **[System Documentation](docs/SYSTEM_DOCUMENTATION.md)**

## 🤝 Đóng Góp

Mọi đóng góp về code, bug reports, hoặc feature requests đều được chào đón. Vui lòng tạo issue hoặc pull request.

## 📄 License

Dự án này được phát triển cho mục đích học tập và nghiên cứu.

## 👥 Tác Giả

ComputerStore Team

---

**Lưu ý**: Đây là project demo cho mục đích học tập, không nên sử dụng cho production mà không có các cải thiện về security và performance.
