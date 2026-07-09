# Bài Trình Bày: Xác Thực, Bảo Mật & Hiệu Năng Hệ Thống ComputerStore

> **Thời lượng**: 5 phút
> **Người trình bày**: [Tên bạn]
> **Công nghệ**: Java 21, Jakarta Servlet 6.1, MySQL 8.0, Tomcat 11

---

## 📑 Mục lục

1. [Authentication - Xác thực người dùng](#1-authentication---xác-thực-người-dùng)
2. [Authorization - Phân quyền](#2-authorization---phân-quyền)
3. [Security Headers & Protection](#3-security-headers--protection)
4. [Performance - Hiệu năng](#4-performance---hiệu-năng)
5. [Các vấn đề đã fix & cải tiến](#5-các-vấn-đề-đã-fix--cải-tiến)
6. [Kịch bản Demo](#6-kịch-bản-demo)

---

## 1. Authentication - Xác thực người dùng

### 1.1. Luồng đăng nhập

```
User → POST /login (username + password)
  ↓
AuthServlet.doPost()
  ↓
UserService.authenticate(username, password)
  ↓
UserDAO.getByUsername(username) → SQL
  ↓
BCrypt.checkpw(password, hash)
  ↓
Session.setAttribute("user", user)
  ↓
Redirect theo role:
  - QUAN_TRI_VIEN → /admin/dashboard
  - KHACH_HANG   → /
```

### 1.2. BCrypt Password Hashing

- **Thuật toán**: BCrypt (cost factor = 12)
- **Salt**: Tự động sinh bởi `BCrypt.gensalt()`
- **Đặc điểm**: Chậm có chủ đích (2^12 = 4096 rounds), chống brute-force

```java
// Hash khi đăng ký
String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
// $2a$12$LJ3m4ys3Lk0TSwHnbfZxZ.....

// Verify khi đăng nhập
boolean match = BCrypt.checkpw(password, user.getMatKhauHash());
```

### 1.3. Validation đầu vào

| Field    | Rule                                   |
| -------- | -------------------------------------- |
| Username | 3-20 ký tự (chữ, số, dấu gạch dưới)    |
| Password | ≥ 8 ký tự, gồm chữ hoa, chữ thường, số |
| Email    | Đúng định dạng email                   |
| Phone    | 0912345678 hoặc +84912345678           |

### 1.4. Session Management

- Session timeout: 30 phút (cấu hình trong `web.xml`)
- Attribute `"user"`: Lưu thông tin user đã đăng nhập
- `session.invalidate()` khi logout
- **Đã fix**: Regenerate session ID sau login (`session.changeSessionId()`) chống session fixation

---

## 2. Authorization - Phân quyền

### 2.1. Filter Chain

```
HTTP Request
  ↓
1. EncodingFilter (/*) → UTF-8 encoding
  ↓
2. CategoryFilter (/*) → Load danh mục sản phẩm
  ↓
3. SecurityFilter (/admin/*, *.jsp) → Bảo mật & phân quyền
  ↓
4. PerformanceFilter (/*) → Đo hiệu năng
  ↓
Servlet (Controller)
```

### 2.2. SecurityFilter chi tiết

```java
@WebFilter(urlPatterns = { "/admin/*", "*.jsp" })
public class SecurityFilter extends HttpFilter {
    public void doFilter(request, response, chain) {
        // 1. Set Security Headers (7 headers)
        resp.setHeader("X-Frame-Options", "DENY");
        resp.setHeader("X-XSS-Protection", "1; mode=block");
        // ...

        // 2. Chặn JSP trực tiếp (trừ index.jsp, 404.jsp)
        if (path.endsWith(".jsp") && !path.startsWith("/jsp/") ...) {
            resp.sendError(404); return;
        }

        // 3. Admin protection
        if (path.startsWith("/admin")) {
            // Kiểm tra session
            // Kiểm tra vai trò QUAN_TRI_VIEN
        }
    }
}
```

### 2.3. URL Protection Matrix

| URL Pattern                                             | Yêu cầu        | Hành vi nếu không đủ quyền           |
| ------------------------------------------------------- | -------------- | ------------------------------------ |
| `/`, `/products`, `/search`                             | Public         | -                                    |
| `/cart`, `/checkout`, `/orders`, `/profile`, `/builder` | Authenticated  | Redirect `/login`                    |
| `/admin/*`                                              | QUAN_TRI_VIEN  | 403 Forbidden hoặc redirect `/login` |
| `*.jsp` (direct access)                                 | Không cho phép | 404 Not Found                        |

### 2.4. RBAC - 2 Roles

| Role            | Mô tả          | Quyền                                |
| --------------- | -------------- | ------------------------------------ |
| `KHACH_HANG`    | Người mua hàng | Xem sản phẩm, mua hàng, xem đơn hàng |
| `QUAN_TRI_VIEN` | Quản trị viên  | Toàn quyền trên admin area           |

---

## 3. Security Headers & Protection

### 3.1. HTTP Security Headers

| Header                   | Giá trị                               | Chống                  |
| ------------------------ | ------------------------------------- | ---------------------- |
| `X-Content-Type-Options` | `nosniff`                             | MIME-type sniffing     |
| `X-Frame-Options`        | `DENY`                                | Clickjacking           |
| `X-XSS-Protection`       | `1; mode=block`                       | Reflected XSS          |
| `Referrer-Policy`        | `strict-origin-when-cross-origin`     | Information leakage    |
| `Cache-Control`          | `no-store, no-cache, must-revalidate` | Cache dữ liệu nhạy cảm |
| `Pragma`                 | `no-cache`                            | HTTP/1.0 cache         |
| `Expires`                | `0`                                   | Hết hạn ngay           |

### 3.2. SQL Injection Protection

- Sử dụng **PreparedStatement** với tham số `?`
- Không bao giờ concatenate SQL string

```java
// SAFE ✅
String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = ?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setInt(1, productId);

// DANGER ❌ (không dùng)
String sql = "SELECT * FROM SAN_PHAM WHERE MaSP = " + productId;
```

### 3.3. CSRF Protection (Đã thêm)

- Token được tạo và lưu trong session
- So sánh token trong request với token trong session
- Tất cả form POST đều có CSRF input ẩn

### 3.4. Forgot Password (Đã fix)

- **Trước**: Trả về message khác nhau ("đã gửi email" vs "không tồn tại")
- **Sau**: Luôn trả về message chung: _"Nếu email tồn tại, chúng tôi đã gửi hướng dẫn..."_
- Tránh tiết lộ thông tin user

---

## 4. Performance - Hiệu năng

### 4.1. HikariCP Connection Pool

| Tham số           | Giá trị                | Giải thích              |
| ----------------- | ---------------------- | ----------------------- |
| MaximumPoolSize   | 10                     | Số connection tối đa    |
| MinimumIdle       | 5                      | Số connection tối thiểu |
| ConnectionTimeout | 30,000 ms (30s)        | Timeout chờ connection  |
| IdleTimeout       | 600,000 ms (10 phút)   | Timeout connection rảnh |
| MaxLifetime       | 1,800,000 ms (30 phút) | Thời gian sống tối đa   |

```java
// Monitor pool real-time
String stats = DBConnection.getPoolStats();
// "HikariCP Stats - Active: 3, Idle: 7, Total: 10, Waiting: 0"
```

### 4.2. PerformanceFilter

- Đo thời gian xử lý mọi request
- Cảnh báo request chậm (>500ms)
- Thống kê mỗi 100 request (avg, max, count)
- **Đã fix**: Dùng SLF4J Logger thay vì System.out

### 4.3. Database Indexes

```sql
-- Các index quan trọng
FULLTEXT INDEX ON SAN_PHAM(TenSP)        -- Tìm kiếm sản phẩm
INDEX ON SAN_PHAM(MaLoaiSP)               -- Lọc theo danh mục
INDEX ON DON_HANG(MaKH)                    -- Lịch sử đơn hàng
INDEX ON DANH_GIA(MaSP)                    -- Đánh giá sản phẩm
INDEX ON CHI_TIET_GIO_HANG(MaSP)           -- Giỏ hàng
```

### 4.4. Các cải tiến hiệu năng

| Vấn đề                 | Trạng thái | Mô tả                                                            |
| ---------------------- | ---------- | ---------------------------------------------------------------- |
| ✅ System.out → Logger | Đã fix     | Dùng SLF4J thay System.out trong PerformanceFilter, DBConnection |
| ❌ Caching (Redis)     | Chưa dùng  | Đã import Jedis trong pom.xml nhưng chưa triển khai              |
| ✅ Connection Pool     | Đã có      | HikariCP với cấu hình tối ưu                                     |
| ✅ PreparedStatement   | Đã có      | Chống SQL injection, cache query plan                            |

---

## 5. Các vấn đề đã fix & cải tiến

| #   | Vấn đề                             | Fix                                           | File                      |
| --- | ---------------------------------- | --------------------------------------------- | ------------------------- |
| 1   | Session fixation                   | Thêm `session.changeSessionId()` sau login    | AuthServlet.java          |
| 2   | Forgot-password info disclosure    | Luôn trả về message chung                     | AuthServlet.java          |
| 3   | Thiếu CSRF token                   | Thêm CSRFFilter + token trong form            | SecurityFilter/CSRFFilter |
| 4   | System.out trong PerformanceFilter | Chuyển sang SLF4J Logger                      | PerformanceFilter.java    |
| 5   | System.out trong DBConnection      | Chuyển sang SLF4J Logger                      | DBConnection.java         |
| 6   | Database credentials hardcode      | Externalize sang .env + environment variables | .env, DBConnection.java   |

---

## 6. Kịch bản Demo

### Demo 1: Authentication (1.5 phút)

**Bước 1 - Đăng nhập thất bại:**

1. Mở trình duyệt → `http://localhost:8080/computerstore/login`
2. Nhập username: `admin`, password: `sai mat khau`
3. Click Login
4. **Kết quả**: Hiển thị error "Sai tên đăng nhập hoặc mật khẩu!"

**Bước 2 - Đăng nhập Admin thành công:**

1. Nhập username: `admin`, password: `Admin@123`
2. Click Login
3. **Kết quả**: Redirect đến `/admin/dashboard` (vì role QUAN_TRI_VIEN)

**Bước 3 - Kiểm tra session:**

1. F12 → Application → Cookies → JSESSIONID
2. Logout → Login lại → Quan sát JSESSIONID thay đổi (chống session fixation)

### Demo 2: Security (1.5 phút)

**Bước 1 - Direct JSP access:**

1. Mở tab mới → `http://localhost:8080/computerstore/jsp/admin/orders.jsp`
2. **Kết quả**: 404 Not Found (bị SecurityFilter chặn)

**Bước 2 - Admin không có quyền:**

1. Đăng nhập với tài khoản customer
2. Truy cập `http://localhost:8080/computerstore/admin/products`
3. **Kết quả**: 403 Forbidden

**Bước 3 - Security Headers:**

1. F12 → Network → Reload trang chủ
2. Click request đầu tiên → Headers → Response Headers
3. **Kết quả**: Thấy X-Frame-Options: DENY, X-XSS-Protection, X-Content-Type-Options...

### Demo 3: Performance (1 phút)

**Bước 1 - Pool monitoring:**

1. Mở terminal/server log
2. Vào trang `/admin/dashboard`
3. **Kết quả**: Log hiển thị "HikariCP Stats - Active: 1, Idle: 9, Total: 10..."

**Bước 2 - Request timing:**

1. Server log hiển thị:
   ```
   [PERF] /products?category=1 took 45ms
   [PERF] /admin/dashboard took 120ms
   ```
2. Giải thích: Request >500ms sẽ có flag "SLOW"

**Bước 3 - Search fulltext:**

1. Search sản phẩm "CPU Intel"
2. **Kết quả**: Nhanh nhờ FULLTEXT INDEX trên TenSP

---

## 📊 Tổng kết

### Điểm mạnh

- ✅ MVC architecture rõ ràng
- ✅ BCrypt + PreparedStatement bảo vệ dữ liệu
- ✅ Security headers đầy đủ
- ✅ HikariCP connection pool tối ưu
- ✅ RBAC với 2 roles rõ ràng
- ✅ Chặn JSP direct access
- ✅ Logging bằng SLF4J

### Điểm yếu & hướng phát triển

| Vấn đề        | Ưu tiên    | Giải pháp                          |
| ------------- | ---------- | ---------------------------------- |
| Rate limiting | Cao        | Giới hạn số lần đăng nhập thất bại |
| Redis caching | Trung bình | Cache danh mục, sản phẩm hot       |
| HTTPS         | Cao        | Cấu hình SSL/TLS production        |
| 2FA           | Thấp       | Xác thực 2 lớp cho admin           |

---

> **Tài liệu tham khảo**: `docs/SYSTEM_DOCUMENTATION_MVC_AUTH.md`, `docs/SYSTEM_DOCUMENTATION_COMPREHENSIVE.md`
