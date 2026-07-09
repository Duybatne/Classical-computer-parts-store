# ComputerStore - Tài Liệu Kiến Trúc MVC, Xác Thực & Phân Quyền

> **Phiên bản**: 1.0
> **Ngày tạo**: 2026-05-18
> **Công nghệ**: Java 21, Jakarta Servlet 6.1, MySQL 8.0, Tomcat 11
> **Mục đích**: Tài liệu chuyên sâu về kiến trúc MVC, cơ chế xác thực (Authentication) và phân quyền (Authorization) của hệ thống ComputerStore.

---

## MỤC LỤC

1. [Kiến Trúc MVC](#1-kiến-trúc-mvc)
   - 1.1. Tổng Quan Mô Hình MVC
   - 1.2. Controller Layer (Servlets)
   - 1.3. Service Layer (Business Logic)
   - 1.4. DAO Layer (Data Access)
   - 1.5. Model Layer (Entities)
   - 1.6. View Layer (JSP & JSTL)
   - 1.7. Luồng Xử Lý Request (MVC Flow)
   - 1.8. Ví dụ MVC Cụ Thể: Luồng Mua Hàng

2. [Xác Thực (Authentication)](#2-xác-thực-authentication)
   - 2.1. Tổng Quan Quy Trình Xác Thực
   - 2.2. Đăng Ký Tài Khoản
   - 2.3. Đăng Nhập
   - 2.4. Duy Trì Phiên (Session Management)
   - 2.5. Đăng Xuất
   - 2.6. Bảo Mật Mật Khẩu Với BCrypt
   - 2.7. Quên Mật Khẩu (Forgot Password)
   - 2.8. Sequence Diagram: Đăng Nhập

3. [Phân Quyền (Authorization)](#3-phân-quyền-authorization)
   - 3.1. Filter Chain Architecture
   - 3.2. SecurityFilter Chi Tiết
   - 3.3. Role-Based Access Control (RBAC)
   - 3.4. URL Protection Matrix
   - 3.5. JSP Direct Access Prevention
   - 3.6. Security Headers
   - 3.7. Sequence Diagram: Phân Quyền Admin

4. [Kết Luận & Cải Tiến](#4-kết-luận--cải-tiến)

---

## 1. KIẾN TRÚC MVC

### 1.1. Tổng Quan Mô Hình MVC

Hệ thống ComputerStore được xây dựng theo kiến trúc **MVC (Model-View-Controller)** kết hợp với **mô hình 3 lớp (3-Tier Architecture)**.

```
┌─────────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER (View)                        │
│                        JSP + JSTL + EL                               │
│                                                                      │
│  • index.jsp  • product-detail.jsp  • cart.jsp                      │
│  • checkout.jsp  • profile.jsp  • login.jsp  • register.jsp         │
│  • admin/*.jsp (dashboard, products, orders, accounts, etc.)        │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ HTTP Request/Response
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      CONTROLLER LAYER                                 │
│                        Jakarta Servlets                              │
│                                                                      │
│  User Servlets:  AuthServlet, ProductServlet, CartServlet,          │
│                  OrderServlet, ProfileServlet, ReviewServlet,        │
│                  PromotionServlet, PcBuilderServlet                  │
│                                                                      │
│  Admin Servlets: AdminProductServlet, AdminOrderServlet,             │
│                  AdminAccountServlet, AdminPromotionServlet,         │
│                  AdminReviewServlet, AdminStatsServlet               │
│                                                                      │
│  API Servlets:   PcBuilderApiServlet                                 │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ Method Calls
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      SERVICE LAYER (Model Logic)                      │
│                        Business Logic                                │
│                                                                      │
│  • UserService  • ProductService  • CartService                      │
│  • OrderService  • PromotionService  • ReviewService                 │
│  • PcBuilderService  • StatsService  • PaymentService                │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ Method Calls
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DAO LAYER (Data Access)                          │
│                        JDBC + HikariCP                               │
│                                                                      │
│  • UserDAO  • ProductDAO  • CategoryDAO  • CartDAO                   │
│  • OrderDAO  • OrderDetailDAO  • PaymentDAO                          │
│  • ReviewDAO  • PromotionDAO  • PromotionProductDAO                  │
│  • StatsDAO  • PcBuilderDAO  • ComponentDetailDAO                   │
│  • ProductImageDAO                                                   │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ JDBC / SQL
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                                   │
│                        MySQL 8.0                                     │
│                   Database: ComputerSpace                             │
└─────────────────────────────────────────────────────────────────────┘
```

**Giải thích vai trò từng thành phần trong MVC:**

| Thành phần     | Vai trò                   | Công nghệ               | Số lượng file          |
| -------------- | ------------------------- | ----------------------- | ---------------------- |
| **Model**      | Dữ liệu + Business Logic  | Java Classes + Services | 15 Models + 9 Services |
| **View**       | Hiển thị giao diện        | JSP + JSTL + EL         | ~14 JSP pages          |
| **Controller** | Xử lý request, điều hướng | Jakarta Servlets        | 17 Servlets            |

---

### 1.2. Controller Layer (Servlets)

Controller layer là nơi tiếp nhận và xử lý các HTTP request từ trình duyệt. Mỗi Servlet được ánh xạ tới một hoặc nhiều URL patterns thông qua annotation `@WebServlet`.

#### 1.2.1. User Servlets (11 files)

| Class              | URL Patterns                                                            | Chức năng chính                  |
| ------------------ | ----------------------------------------------------------------------- | -------------------------------- |
| `AuthServlet`      | `/login`, `/register`, `/logout`, `/forgot-password`                    | Xác thực, đăng ký, đăng xuất     |
| `ProductServlet`   | `/products`, `/product`, `/search`, `/category`                         | Xem danh sách, chi tiết sản phẩm |
| `CartServlet`      | `/cart`, `/cart/update`, `/cart/remove`, `/cart/clear`, `/cart/voucher` | Quản lý giỏ hàng                 |
| `OrderServlet`     | `/checkout`, `/order/place`, `/orders`, `/order/cancel`                 | Đặt hàng, xem lịch sử            |
| `ProfileServlet`   | `/profile`, `/profile/update`, `/profile/change-password`               | Thông tin cá nhân                |
| `ReviewServlet`    | `/review`                                                               | Đánh giá sản phẩm                |
| `PcBuilderServlet` | `/builder`                                                              | Build PC                         |
| `PromotionServlet` | `/promotions`                                                           | Xem khuyến mãi                   |
| `ContactServlet`   | `/contact`                                                              | Liên hệ                          |

#### 1.2.2. Admin Servlets (6 files)

| Class                   | URL Patterns                          | Chức năng chính     |
| ----------------------- | ------------------------------------- | ------------------- |
| `AdminStatsServlet`     | `/admin/dashboard`, `/admin/`         | Thống kê, dashboard |
| `AdminProductServlet`   | `/admin/products`, `/admin/product/*` | CRUD sản phẩm       |
| `AdminOrderServlet`     | `/admin/orders`, `/admin/order/*`     | Quản lý đơn hàng    |
| `AdminAccountServlet`   | `/admin/accounts`                     | Quản lý tài khoản   |
| `AdminPromotionServlet` | `/admin/promotions`                   | Quản lý khuyến mãi  |
| `AdminReviewServlet`    | `/admin/reviews`                      | Duyệt đánh giá      |

#### 1.2.3. Cấu Trúc Servlet Điển Hình

```java
@WebServlet(urlPatterns = { "/login", "/register", "/logout", "/forgot-password" })
public class AuthServlet extends HttpServlet {

    private UserService userService = new UserService();  // Gọi Service Layer

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        // Xác định action dựa trên URL path
        if ("/logout".equals(path)) {
            // Xử lý logout
        } else if ("/login".equals(path)) {
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        // Xử lý POST request (form submission)
        if ("/login".equals(path)) {
            // Gọi Service để xác thực
            User user = userService.authenticate(username, password);
            // Set session attribute
            req.getSession().setAttribute("user", user);
            // Redirect dựa trên role
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}
```

**Phân tích:**

- `@WebServlet` annotation thay thế cho cấu hình trong `web.xml`
- Servlet gọi `Service Layer` (không gọi trực tiếp DAO)
- Sử dụng `req.getRequestDispatcher().forward()` cho GET (hiển thị trang)
- Sử dụng `resp.sendRedirect()` cho POST (tránh resubmit form)
- Dữ liệu được truyền qua `req.setAttribute()` và `req.getSession().setAttribute()`

---

### 1.3. Service Layer (Business Logic)

Service layer chứa business logic của ứng dụng. Đây là lớp trung gian giữa Controller và DAO, đảm bảo Controller không phải xử lý logic phức tạp.

#### 1.3.1. Cấu Trúc Service Điển Hình

```java
public class UserService {
    private UserDAO userDAO = new UserDAO();  // Gọi DAO Layer

    public User authenticate(String username, String password) {
        User user = userDAO.getByUsername(username);
        if (user != null && BCrypt.checkpw(password, user.getMatKhauHash())) {
            userDAO.updateLastLogin(user.getMaTK());
            return user;
        }
        return null;
    }

    public boolean registerCustomer(String username, String password,
            String fullname, String email, String phone, String address) {
        // Kiểm tra username tồn tại
        if (userDAO.getByUsername(username) != null) {
            return false;
        }
        // Hash password trước khi lưu
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        User u = new User(0, username, hashed, "KHACH_HANG",
                          fullname, email, phone, address, null);
        return userDAO.insertCustomer(u);
    }
}
```

#### 1.3.2. Danh Sách Services

| Service            | DAOs sử dụng                                                 | Chức năng chính                     |
| ------------------ | ------------------------------------------------------------ | ----------------------------------- |
| `UserService`      | UserDAO                                                      | Xác thực, đăng ký, cập nhật profile |
| `ProductService`   | ProductDAO, CategoryDAO, ProductImageDAO, ComponentDetailDAO | CRUD sản phẩm, tìm kiếm             |
| `CartService`      | CartDAO, ProductDAO, PromotionService                        | Quản lý giỏ hàng, tính tiền         |
| `OrderService`     | OrderDAO, OrderDetailDAO, ProductDAO, CartDAO, PaymentDAO    | Đặt hàng (transaction), hủy đơn     |
| `PromotionService` | PromotionDAO                                                 | Áp dụng voucher, tính giảm giá      |
| `ReviewService`    | ReviewDAO                                                    | Thêm/duyệt đánh giá                 |
| `PcBuilderService` | PcBuilderDAO, ComponentDetailDAO                             | Kiểm tra tương thích linh kiện      |
| `StatsService`     | StatsDAO                                                     | Thống kê doanh thu, đơn hàng        |
| `PaymentService`   | PaymentDAO                                                   | Xử lý thanh toán                    |

---

### 1.4. DAO Layer (Data Access)

DAO layer thực hiện các truy vấn SQL trực tiếp qua JDBC, sử dụng HikariCP Connection Pool.

#### 1.4.1. Kết Nối Database

```java
// DBConnection.java - HikariCP Connection Pool
public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/ComputerSpace");
        config.setUsername("root");
        config.setPassword("123456");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() {
        return dataSource.getConnection();
    }
}
```

#### 1.4.2. Cấu Trúc DAO Điển Hình

```java
public class UserDAO {

    public User getByUsername(String username) {
        String sql = "SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, "
                   + "k.MaKH, k.HoTen, k.Email, k.SDT as SoDienThoai, k.DiaChi "
                   + "FROM TAI_KHOAN u "
                   + "LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK "
                   + "WHERE u.TenDangNhap = ? AND u.TrangThai = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi thao tác CSDL", e);
        }
        return null;
    }

    // Transaction: INSERT vào 2 bảng TAI_KHOAN + KHACH_HANG
    public boolean insertCustomer(User user) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. INSERT TAI_KHOAN
            String sqlTK = "INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro) "
                         + "VALUES (?, ?, 'KHACH_HANG')";
            try (PreparedStatement ps = conn.prepareStatement(sqlTK,
                    Statement.RETURN_GENERATED_KEYS)) {
                // Thực thi và lấy MaTK tự sinh
            }

            // 2. INSERT KHACH_HANG với MaTK vừa tạo
            String sqlKH = "INSERT INTO KHACH_HANG (MaTK, HoTen, Email, SDT, DiaChi) "
                         + "VALUES (?, ?, ?, ?, ?)";

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw new DatabaseException("Lỗi tạo khách hàng", e);
        } finally {
            if (conn != null) conn.close();
        }
    }
}
```

**Đặc điểm của DAO Layer:**

- Sử dụng `PreparedStatement` (chống SQL Injection)
- Dùng `Try-With-Resources` (tự động đóng Connection, PreparedStatement, ResultSet)
- Transaction được quản lý thủ công qua `conn.setAutoCommit(false)` / `commit()` / `rollback()`
- Kết quả ResultSet được map thủ công sang Model object qua method `extractUserFromResultSet()`

---

### 1.5. Model Layer (Entities)

Model layer chứa các Java class mapping với database tables. Mỗi thuộc tính tương ứng với một cột trong database.

#### 1.5.1. User Model

```java
public class User {
    private int maTK;               // PK từ TAI_KHOAN
    private int maKH;               // PK từ KHACH_HANG (nếu là customer)
    private String tenDangNhap;     // Tên đăng nhập
    private String matKhauHash;     // Mật khẩu đã hash BCrypt
    private String vaiTro;          // 'KHACH_HANG' hoặc 'QUAN_TRI_VIEN'
    private String hoTen;           // Họ tên (JOIN từ KHACH_HANG hoặc QUAN_TRI_VIEN)
    private String email;           // Email
    private String soDienThoai;     // Số điện thoại
    private String diaChi;          // Địa chỉ
    private int trangThai;          // 1: Active, 0: Inactive
    private Timestamp ngayDangNhapCuoi; // Lần đăng nhập cuối
    // Getters/Setters...
}
```

#### 1.5.2. Product Model (Ví dụ Model phức tạp)

```java
public class Product {
    private int maSP;
    private String tenSP;
    private int maLoaiSP;
    private String tenLoaiSP;           // JOIN từ LOAI_SAN_PHAM
    private String thuongHieu;
    private BigDecimal giaBan;
    private int soLuongTon;
    private int baoHanhThang;
    private String moTaNgan;
    private String moTaChiTiet;
    private int trangThai;
    private Timestamp ngayTao;
    private Timestamp ngayCapNhat;

    // Quan hệ (loaded eagerly bởi Service)
    private List<ProductImage> anhSanPhams;
    private Object chiTiet;             // Chi tiết linh kiện (tùy loại)
    private double avgRating;           // Điểm đánh giá trung bình
    private int reviewCount;            // Số lượng đánh giá
}
```

**Lưu ý:** Các model sử dụng Java class truyền thống (không phải Record) để hỗ trợ setter/getter linh hoạt. Dữ liệu từ JOIN queries được map thủ công trong DAO.

---

### 1.6. View Layer (JSP & JSTL)

View layer sử dụng JSP (Jakarta Server Pages) với JSTL (JSP Standard Tag Library) và EL (Expression Language).

#### 1.6.1. Cấu Trúc JSP Điển Hình

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html>
<head>
    <title>${product.tenSP}</title>
</head>
<body>
    <h1>${product.tenSP}</h1>
    <p>Giá: <fmt:formatNumber value="${product.giaBan}" type="currency"
                                currencySymbol="₫" maxFractionDigits="0"/></p>

    <c:choose>
        <c:when test="${product.soLuongTon > 0}">
            <span class="in-stock">Còn hàng (${product.soLuongTon})</span>
        </c:when>
        <c:otherwise>
            <span class="out-of-stock">Hết hàng</span>
        </c:otherwise>
    </c:choose>

    <c:forEach var="item" items="${cartItems}">
        <tr>
            <td>${item.tenSP}</td>
            <td><fmt:formatNumber value="${item.thanhTien}" type="currency"/></td>
        </tr>
    </c:forEach>
</body>
</html>
```

#### 1.6.2. Cách Dữ Liệu Di Chuyển Từ Controller Đến View

```
Controller (Servlet)                          View (JSP)
─────────────────────────                     ────────────
req.setAttribute("products", list);    →      ${products}
req.setAttribute("totalPages", 10);    →      ${totalPages}
req.getSession().setAttribute("user", user); → ${sessionScope.user}
req.setAttribute("error", "Sai mật khẩu"); →  ${error}
```

**Phân biệt Request Scope vs Session Scope:**

- **Request Scope** (`req.setAttribute`): Dữ liệu chỉ tồn tại trong 1 request
- **Session Scope** (`session.setAttribute`): Dữ liệu tồn tại xuyên suốt phiên làm việc (dùng cho thông tin user đăng nhập)

---

### 1.7. Luồng Xử Lý Request (MVC Flow)

```
Trình duyệt (Browser)
    │
    ▼ HTTP Request (GET/POST)
    │
┌───────────────────────────────────────────────────────────┐
│                     Filter Chain                           │
│                                                            │
│  1. EncodingFilter (/*)                                    │
│     → Set UTF-8 encoding cho request/response              │
│                                                            │
│  2. CategoryFilter (/*)                                    │
│     → Load danh mục sản phẩm vào request attribute         │
│                                                            │
│  3. SecurityFilter (admin/*, *.jsp)                        │
│     → Set security headers                                 │
│     → Chặn truy cập JSP trực tiếp                         │
│     → Kiểm tra đăng nhập & vai trò cho /admin/*            │
│                                                            │
└───────────────────────────────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────────────────────────────┐
│                  Controller (Servlet)                      │
│                                                            │
│  doGet() / doPost():                                       │
│  1. Đọc parameters từ request                              │
│  2. Gọi Service Layer (business logic)                    │
│  3. Đặt kết quả vào request/session attributes             │
│  4. Forward (GET) hoặc Redirect (POST)                    │
│                                                            │
└───────────────────────────────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────────────────────────────┐
│                  Service Layer                             │
│                                                            │
│  1. Kiểm tra validation (nếu cần)                         │
│  2. Gọi DAO Layer để truy vấn database                    │
│  3. Xử lý business logic (tính toán, kiểm tra...)         │
│  4. Trả kết quả về Controller                             │
│                                                            │
└───────────────────────────────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────────────────────────────┐
│                  DAO Layer                                 │
│                                                            │
│  1. Nhận Connection từ HikariCP pool                      │
│  2. Thực thi SQL với PreparedStatement                    │
│  3. Map ResultSet → Model objects                         │
│  4. Trả kết quả về Service                                │
│                                                            │
└───────────────────────────────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────────────────────────────┐
│                  JSP (View)                                │
│                                                            │
│  1. Đọc dữ liệu từ request/session attributes              │
│  2. Render HTML với JSTL tags (c:forEach, c:if, fmt:...)  │
│  3. Gửi HTML response về trình duyệt                      │
│                                                            │
└───────────────────────────────────────────────────────────┘
    │
    ▼ HTTP Response (HTML)
    │
Trình duyệt hiển thị trang web
```

---

### 1.8. Ví dụ MVC Cụ Thể: Luồng Mua Hàng

Phân tích chi tiết một use case điển hình: **Xem danh sách sản phẩm**

```
1. TRÌNH DUYỆT
   GET /products?category=2&page=1&sort=price_asc
       │
2. FILTER CHAIN
   ├─ EncodingFilter: set UTF-8
   ├─ CategoryFilter: load categories → req.setAttribute("categories", list)
   └─ SecurityFilter: path="/products" (không khớp pattern, cho qua)
       │
3. CONTROLLER (ProductServlet)
   ├─ doGet() được gọi
   ├─ String categoryStr = req.getParameter("category"); // "2"
   ├─ int page = Integer.parseInt(req.getParameter("page")); // 1
   ├─ String sort = req.getParameter("sort"); // "price_asc"
   ├─ GỌI SERVICE: productService.getProducts(2, "price_asc", 0, 12)
   │      │
   │      └─ SERVICE (ProductService)
   │         ├─ GỌI DAO: productDAO.findByCategory(2, "price_asc", 0, 12)
   │         │      │
   │         │      └─ DAO (ProductDAO)
   │         │         ├─ String sql = "SELECT ... LIMIT ? OFFSET ?"
   │         │         ├─ PreparedStatement with parameters
   │         │         ├─ ResultSet → extractProduct() → List<Product>
   │         │         └─ return products
   │         │
   │         └─ Trả List<Product> về Controller
   │
   ├─ req.setAttribute("products", productList);
   ├─ req.setAttribute("totalPages", totalPages);
   ├─ req.setAttribute("currentPage", 1);
   └─ req.getRequestDispatcher("/jsp/products.jsp").forward(req, resp);
       │
4. VIEW (products.jsp)
   ├─ <c:forEach var="product" items="${products}"> ...
   ├─ <fmt:formatNumber value="${product.giaBan}" type="currency"/>
   └─ Render HTML với Bootstrap
       │
5. TRÌNH DUYỆT
   Hiển thị danh sách sản phẩm
```

---

## 2. XÁC THỰC (AUTHENTICATION)

### 2.1. Tổng Quan Quy Trình Xác Thực

Xác thực (Authentication) là quá trình xác minh danh tính người dùng. Hệ thống ComputerStore sử dụng:

1. **Username/Password**: Phương thức xác thực chính
2. **Session-based**: Duy trì trạng thái đăng nhập qua HTTP Session
3. **BCrypt**: Hash và verify mật khẩu
4. **Role-based redirect**: Chuyển hướng đến trang phù hợp sau đăng nhập

### 2.2. Đăng Ký Tài Khoản

#### Luồng Xử Lý

```
User → POST /register
    │
    ▼
1. VALIDATION (Controller - AuthServlet)
   ├─ Kiểm tra username không rỗng, >= 3 ký tự (isValidUsername)
   ├─ Kiểm tra password >= 6 ký tự (isValidPassword)
   ├─ Kiểm tra email đúng định dạng (isValidEmail)
   └─ Kiểm tra phone đúng định dạng (isValidPhone)
       │
       ▼ (Nếu validation lỗi → forward lại register.jsp với error message)
       │
2. SERVICE (UserService)
   ├─ Kiểm tra username đã tồn tại?
   │   └─ Gọi UserDAO.getByUsername(username)
   │   └─ Nếu tồn tại → return false ("Tên đăng nhập đã tồn tại")
   │
   ├─ Hash password:
   │   └─ String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
   │   └─ Kết quả: "$2a$12$LJ3m4ys3Lk0TSwHnbfZxZ...."
   │
   └─ Gọi DAO:
       └─ UserDAO.insertCustomer(User(username, hashed, "KHACH_HANG", ...))
           │
           ▼
3. DAO (UserDAO) - TRANSACTION
   ├─ conn.setAutoCommit(false)
   ├─ INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro='KHACH_HANG')
   │   └─ Lấy MaTK tự sinh (Statement.RETURN_GENERATED_KEYS)
   ├─ INSERT INTO KHACH_HANG (MaTK, HoTen, Email, SDT, DiaChi)
   ├─ conn.commit()
   └─ return true
       │
       ▼
4. Controller → redirect /login?registered=true
```

#### Mã Nguồn Chi Tiết

```java
// AuthServlet.java - doPost("/register")
protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
    String uname = req.getParameter("username");
    String pass = req.getParameter("password");
    String name = req.getParameter("fullname");
    String email = req.getParameter("email");
    String phone = req.getParameter("phone");

    // Validate inputs
    String validationError = null;
    if (!ValidationUtil.isValidUsername(uname)) {
        validationError = "Tên đăng nhập phải từ 3-20 ký tự";
    } else if (!ValidationUtil.isValidPassword(pass)) {
        validationError = "Mật khẩu phải có ít nhất 8 ký tự";
    } else if (!ValidationUtil.isValidEmail(email)) {
        validationError = "Email không đúng định dạng";
    } else if (phone != null && !phone.isEmpty()
               && !ValidationUtil.isValidPhone(phone)) {
        validationError = "Số điện thoại không đúng định dạng";
    }

    if (validationError != null) {
        // Forward lại form với error message
        return;
    }

    if (userService.registerCustomer(uname, pass, name, email, phone, "")) {
        resp.sendRedirect(req.getContextPath() + "/login?registered=true");
    } else {
        req.setAttribute("error", "Tên đăng nhập đã tồn tại!");
    }
}
```

### 2.3. Đăng Nhập

#### Luồng Xử Lý

```
User → POST /login (username + password)
    │
    ▼
1. AuthServlet.doPost()
   ├─ String u = req.getParameter("username");
   └─ String p = req.getParameter("password");
       │
       ▼
2. UserService.authenticate(username, password)
   ├─ Gọi UserDAO.getByUsername(username)
   │   └─ SQL: "SELECT u.*, k.HoTen, k.Email, k.SDT, k.DiaChi
   │            FROM TAI_KHOAN u
   │            LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK
   │            WHERE u.TenDangNhap = ? AND u.TrangThai = 1"
   │
   ├─ Nếu user == null → return null (sai username)
   │
   ├─ BCrypt.checkpw(password, user.getMatKhauHash())
   │   ├─ Nếu match → Cập nhật NgayDangNhapCuoi
   │   │              userDAO.updateLastLogin(user.getMaTK())
   │   │              return user (thành công)
   │   └─ Nếu không match → return null (sai password)
   │
   ▼ (Controller nhận kết quả)
   │
3. Nếu user != null:
   ├─ req.getSession().setAttribute("user", user);
   │
   ├─ Nếu user.getVaiTro() == "QUAN_TRI_VIEN"
   │   └─ resp.sendRedirect("/admin/dashboard")
   │
   └─ Nếu user.getVaiTro() == "KHACH_HANG"
       └─ resp.sendRedirect("/")
   │
4. Nếu user == null:
   ├─ req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!")
   └─ Forward đến login.jsp (giữ nguyên form)
```

#### Mã Nguồn Chi Tiết

```java
// UserService.java - Authenticate
public User authenticate(String username, String password) {
    User user = userDAO.getByUsername(username);
    if (user != null && BCrypt.checkpw(password, user.getMatKhauHash())) {
        userDAO.updateLastLogin(user.getMaTK());
        return user;
    }
    return null;
}

// AuthServlet.java - doPost("/login")
protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
    String u = req.getParameter("username");
    String p = req.getParameter("password");
    User user = userService.authenticate(u, p);

    if (user != null) {
        req.getSession().setAttribute("user", user);
        if ("QUAN_TRI_VIEN".equals(user.getVaiTro())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    } else {
        req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }
}
```

### 2.4. Duy Trì Phiên (Session Management)

#### Cơ Chế Session

```java
// Tạo hoặc lấy session hiện tại
HttpSession session = req.getSession();          // Tạo mới nếu chưa có
HttpSession session = req.getSession(false);     // Chỉ lấy session hiện có

// Lưu dữ liệu vào session
session.setAttribute("user", user);              // User object sau khi login

// Đọc dữ liệu từ session
User user = (User) session.getAttribute("user"); // Kiểm tra đăng nhập

// Xóa session (logout)
session.invalidate();                            // Hủy toàn bộ session
```

#### Cấu Hình Session

```xml
<!-- web.xml - Session timeout: 30 phút -->
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

#### Dữ Liệu Lưu Trong Session

| Attribute | Kiểu dữ liệu | Mục đích                    |
| --------- | ------------ | --------------------------- |
| `user`    | `User`       | Thông tin user đã đăng nhập |
| `voucher` | (tạm thời)   | Mã giảm giá đang áp dụng    |
| `cartId`  | `Integer`    | ID giỏ hàng (nếu cần)       |

### 2.5. Đăng Xuất

```java
// AuthServlet.java - doGet("/logout")
protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
    if ("/logout".equals(path)) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();  // Hủy session → xóa toàn bộ dữ liệu
        }
        resp.sendRedirect(req.getContextPath() + "/");
    }
}
```

Quy trình:

1. Lấy session hiện tại (không tạo mới)
2. Gọi `session.invalidate()` - xóa tất cả attributes
3. Redirect về trang chủ

### 2.6. Bảo Mật Mật Khẩu Với BCrypt

#### Tại Sao Dùng BCrypt?

| Thuật toán | Hash speed                   | Salt          | Khuyến cáo                        |
| ---------- | ---------------------------- | ------------- | --------------------------------- |
| MD5        | Rất nhanh                    | Không tự động | ❌ Không dùng                     |
| SHA-256    | Nhanh                        | Không tự động | ❌ Không dùng (dễ bị brute-force) |
| **BCrypt** | **Chậm (có thể điều chỉnh)** | **Tự động**   | **✅ Khuyến nghị**                |

#### Cách Hoạt Động

```java
// Hash password (khi đăng ký)
String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
// Kết quả: $2a$12$LJ3m4ys3Lk0TSwHnbfZxZ.5Qx7Y1N0Kx9Xx9Xx9Xx9Xx9Xx9Xx9X

// Verify password (khi đăng nhập)
boolean match = BCrypt.checkpw(password, hashedPassword);
```

#### Cấu Trúc BCrypt Hash

```
$2a$12$LJ3m4ys3Lk0TSwHnbfZxZ.5Qx7Y1N0Kx9Xx9Xx9Xx9Xx9Xx9Xx9X
├──┴──┴──────────────────────────────────────────────────────┘
│    │                            │
Alg  Cost ($12)                 Hash + Salt (53 chars)
```

- **$2a**: Thuật toán BCrypt
- **$12**: Cost factor (2^12 = 4096 rounds) - càng cao càng chậm, càng an toàn
- **Phần còn lại**: Salt (22 chars) + Hash (31 chars)

#### Lưu Ý Bảo Mật

1. Không bao giờ lưu plain-text password
2. Cost factor ≥ 12
3. Salt tự động sinh bởi `BCrypt.gensalt()` (không cần lưu riêng salt)
4. So sánh password luôn dùng `BCrypt.checkpw()`, không dùng string equals

### 2.7. Quên Mật Khẩu (Forgot Password)

#### Quy Trình

```
User → POST /forgot-password (email)
    │
    ▼
1. Kiểm tra email rỗng? → error
    │
    ▼
2. UserService.getByEmail(email)
   └─ UserDAO.getByEmail(email)
      └─ SQL: "SELECT ... FROM TAI_KHOAN u
               LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK
               WHERE k.Email = ? AND u.TrangThai = 1"
    │
    ▼
3. Nếu user != null:
   → "Nếu email tồn tại, chúng tôi đã gửi hướng dẫn..."
   Nếu user == null:
   → "Email không tồn tại trong hệ thống"
```

**Lưu ý bảo mật:** Hiện tại hệ thống chưa tích hợp email service thực tế, message hiển thị khác nhau khi email tồn tại/không tồn tại. Best practice là luôn hiển thị message chung để tránh tiết lộ thông tin.

### 2.8. Sequence Diagram: Đăng Nhập

```
┌─────────┐     ┌──────────────┐     ┌────────────┐     ┌──────────┐
│ Browser │     │ AuthServlet  │     │ UserService│     │ UserDAO  │
│         │     │ (Controller) │     │ (Service)  │     │ (DAO)    │
└────┬────┘     └──────┬───────┘     └─────┬──────┘     └────┬─────┘
     │                 │                   │                 │
     │ POST /login     │                   │                 │
     │ (u, p)          │                   │                 │
     │────────────────>│                   │                 │
     │                 │                   │                 │
     │                 │ authenticate(u,p) │                 │
     │                 │──────────────────>│                 │
     │                 │                   │                 │
     │                 │                   │ getByUsername() │
     │                 │                   │────────────────>│
     │                 │                   │                 │
     │                 │                   │  SELECT ...     │
     │                 │                   │  FROM TAI_KHOAN │
     │                 │                   │  LEFT JOIN ...  │
     │                 │                   │  WHERE username │
     │                 │                   │  = ?            │
     │                 │                   │                 │
     │                 │                   │<────────────────│
     │                 │                   │   return User   │
     │                 │                   │                 │
     │                 │                   │ BCrypt.checkpw  │
     │                 │                   │ (p, hash)       │
     │                 │                   │                 │
     │                 │                   │ updateLastLogin │
     │                 │                   │────────────────>│
     │                 │                   │<────────────────│
     │                 │                   │                 │
     │                 │<──────────────────│                 │
     │                 │   return User     │                 │
     │                 │                   │                 │
     │                 │ setAttribute      │                 │
     │                 │ ("user", user)    │                 │
     │                 │                   │                 │
     │  ┌───[role=QUAN_TRI_VIEN]───┐      │                 │
     │  │                         │        │                 │
     │  │ Redirect /admin/        │        │                 │
     │  │ dashboard               │        │                 │
     │  │<────────────────────────│        │                 │
     │  │                         │        │                 │
     │  └─────────────────────────┘        │                 │
     │                                     │                 │
     │  ┌───[role=KHACH_HANG]─────┐       │                 │
     │  │                         │        │                 │
     │  │    Redirect /           │        │                 │
     │  │<────────────────────────│        │                 │
     │  │                         │        │                 │
     │  └─────────────────────────┘        │                 │
     │                                     │                 │
```

---

## 3. PHÂN QUYỀN (AUTHORIZATION)

### 3.1. Filter Chain Architecture

Phân quyền (Authorization) là quá trình kiểm tra người dùng đã xác thực có quyền truy cập tài nguyên hay không. Hệ thống sử dụng **Filter Chain** để thực hiện việc này.

#### Thứ Tự Filter Chain

```
HTTP Request
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│  1. EncodingFilter (/*)                                         │
│     • Set request encoding = UTF-8                              │
│     • Set response encoding = UTF-8                             │
│     → Mục đích: Hỗ trợ Unicode, tiếng Việt                     │
├─────────────────────────────────────────────────────────────────┤
│  2. CategoryFilter (/*)                                         │
│     • Load danh sách LOAI_SAN_PHAM từ database                 │
│     • Set req.setAttribute("categories", list)                 │
│     → Mục đích: Danh mục sản phẩm luôn sẵn sàng cho mọi trang │
├─────────────────────────────────────────────────────────────────┤
│  3. SecurityFilter (/admin/*, *.jsp)                            │
│     • Set security headers (XSS, Clickjacking, etc.)           │
│     • Chặn truy cập JSP trực tiếp (trừ index.jsp và 404.jsp)  │
│     • Kiểm tra đăng nhập cho /admin/*                          │
│     • Kiểm tra vai trò QUAN_TRI_VIEN cho /admin/*              │
│     → Mục đích: Bảo vệ toàn bộ hệ thống                        │
├─────────────────────────────────────────────────────────────────┤
│  4. PerformanceFilter (/*)                                      │
│     • Đo thời gian xử lý request                               │
│     • Log request info (path, method, duration)                │
│     → Mục đích: Monitoring và debugging                        │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
Servlet (Controller)
```

### 3.2. SecurityFilter Chi Tiết

`SecurityFilter` là filter quan trọng nhất trong hệ thống, đảm nhiệm cả bảo mật (security headers) và phân quyền.

#### Mã Nguồn Đầy Đủ

```java
@WebFilter(urlPatterns = { "/admin/*", "*.jsp" })
public class SecurityFilter extends HttpFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getServletPath();

        // ── 1. Set Security Headers ──
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("X-Frame-Options", "DENY");
        resp.setHeader("X-XSS-Protection", "1; mode=block");
        resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");

        // ── 2. Prevent Direct JSP Access ──
        if (path.endsWith(".jsp")
            && !path.startsWith("/jsp/")
            && !"/404.jsp".equals(path)
            && !"/index.jsp".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // ── 3. Admin Area Protection ──
        if (path.startsWith("/admin")) {
            // Allow static resources
            if (path.startsWith("/admin-asset/")) {
                chain.doFilter(request, response);
                return;
            }

            HttpSession session = req.getSession(false);
            User user = (session != null)
                ? (User) session.getAttribute("user") : null;

            if (user == null) {
                // Not logged in → redirect to login
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"QUAN_TRI_VIEN".equals(user.getVaiTro())) {
                // Logged in but not admin → 403 Forbidden
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
```

#### Các Bước Xử Lý Trong SecurityFilter

| Bước    | Mã lệnh                                                                | Mục đích                    |
| ------- | ---------------------------------------------------------------------- | --------------------------- |
| **3.1** | `resp.setHeader("X-Content-Type-Options", "nosniff")`                  | Chặn MIME-type sniffing     |
| **3.2** | `resp.setHeader("X-Frame-Options", "DENY")`                            | Chống Clickjacking          |
| **3.3** | `resp.setHeader("X-XSS-Protection", "1; mode=block")`                  | Chống XSS (trình duyệt cũ)  |
| **3.4** | `resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin")` | Kiểm soát Referrer header   |
| **3.5** | `resp.setHeader("Cache-Control", "no-store")`                          | Không cache trang           |
| **3.6** | Kiểm tra path kết thúc bằng `.jsp`                                     | Chặn truy cập JSP trực tiếp |
| **3.7** | Kiểm tra session và attribute "user"                                   | Xác thực cho admin area     |
| **3.8** | Kiểm tra `user.getVaiTro()`                                            | Phân quyền admin            |

### 3.3. Role-Based Access Control (RBAC)

Hệ thống sử dụng mô hình RBAC với 2 vai trò (roles):

#### 3.3.1. Các Vai Trò

| Vai trò           | ENUM value (DB) | Mô tả                       |
| ----------------- | --------------- | --------------------------- |
| **Khách hàng**    | `KHACH_HANG`    | Người mua hàng thông thường |
| **Quản trị viên** | `QUAN_TRI_VIEN` | Nhân viên quản lý hệ thống  |

#### 3.3.2. Cấu Trúc DB

```sql
CREATE TABLE TAI_KHOAN (
    MaTK      INT AUTO_INCREMENT PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau     VARCHAR(255) NOT NULL,
    VaiTro      ENUM('KHACH_HANG', 'QUAN_TRI_VIEN') NOT NULL,
    TrangThai   TINYINT DEFAULT 1,           -- 1: Active, 0: Inactive
    NgayTao     DATETIME DEFAULT CURRENT_TIMESTAMP,
    NgayDangNhapCuoi DATETIME
);
```

#### 3.3.3. Các Mức Phân Quyền

| Mức               | Mô tả                              | Kiểm tra tại                      |
| ----------------- | ---------------------------------- | --------------------------------- |
| **Public**        | Không cần đăng nhập                | Không                             |
| **Authenticated** | Chỉ cần đăng nhập (cả KH và Admin) | SecurityFilter (session != null)  |
| **Admin Only**    | Yêu cầu vai trò QUAN_TRI_VIEN      | SecurityFilter (user.getVaiTro()) |

#### 3.3.4. Phân Quyền Trong Code

```java
// 1. Redirect sau login (AuthServlet)
if ("QUAN_TRI_VIEN".equals(user.getVaiTro())) {
    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
} else {
    resp.sendRedirect(req.getContextPath() + "/");
}

// 2. Kiểm tra trong SecurityFilter
User user = (Session) session.getAttribute("user");
if (!"QUAN_TRI_VIEN".equals(user.getVaiTro())) {
    resp.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
    return;
}

// 3. Hiển thị trong View (JSP)
<c:choose>
    <c:when test="${sessionScope.user.vaiTro == 'QUAN_TRI_VIEN'}">
        <a href="/admin/dashboard">Quản trị</a>
    </c:when>
</c:choose>
```

### 3.4. URL Protection Matrix

#### Bảng Phân Quyền URL

| URL Pattern             | Yêu cầu       | Vai trò       | Filter kiểm tra | Hành vi nếu không đủ quyền |
| ----------------------- | ------------- | ------------- | --------------- | -------------------------- |
| `/`, `/home`            | Public        | -             | -               | -                          |
| `/products`, `/product` | Public        | -             | -               | -                          |
| `/search`, `/category`  | Public        | -             | -               | -                          |
| `/promotions`           | Public        | -             | -               | -                          |
| `/contact`              | Public        | -             | -               | -                          |
| `/login`, `/register`   | Public        | -             | -               | -                          |
| `/cart*`                | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/checkout`             | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/orders`               | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/profile*`             | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/review`               | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/builder`              | Authenticated | KH + Admin    | SecurityFilter  | Redirect `/login`          |
| `/admin/*`              | Authenticated | QUAN_TRI_VIEN | SecurityFilter  | 403 Forbidden              |
| `*.jsp` (trực tiếp)     | -             | -             | SecurityFilter  | 404 Not Found              |

#### Luồng Kiểm Tra Khi Truy Cập /admin/orders

```
Browser → GET /admin/orders
    │
    ▼
EncodingFilter (cho qua)
    │
    ▼
CategoryFilter (cho qua, set categories)
    │
    ▼
SecurityFilter
    │
    ├─ Set security headers (cho mọi request)
    │
    ├─ Path = "/admin/orders"
    │   ├─ Kết thúc bằng .jsp? → Không → Bỏ qua bước chặn JSP
    │   │
    │   ├─ Bắt đầu bằng "/admin"? → Có
    │   │   ├─ Bắt đầu bằng "/admin-asset/"? → Không
    │   │   │
    │   │   ├─ Session == null? ───┐
    │   │   │                      ├─ Có → Redirect /login
    │   │   │                      └─ Không → Tiếp tục
    │   │   │
    │   │   ├─ session.getAttribute("user") == null? ───┐
    │   │   │                                           ├─ Có → Redirect /login
    │   │   │                                           └─ Không → Tiếp tục
    │   │   │
    │   │   └─ user.getVaiTro() == "QUAN_TRI_VIEN"? ───┐
    │   │                                               ├─ Có → Cho qua (chain.doFilter)
    │   │                                               └─ Không → 403 Forbidden
    │   │
    │   └─ Cho qua (chain.doFilter)
    │
    ▼
PerformanceFilter (log request)
    │
    ▼
AdminOrderServlet.doGet() → Xử lý request
```

### 3.5. JSP Direct Access Prevention

SecurityFilter ngăn chặn truy cập trực tiếp vào file JSP (không qua Servlet). Đây là biện pháp bảo mật quan trọng để tránh lộ cấu trúc ứng dụng và bypass các kiểm tra trong Servlet.

#### Cơ Chế

```java
// Chặn mọi request đến file .jsp KHÔNG nằm trong thư mục /jsp/
// và không phải index.jsp hoặc 404.jsp
if (path.endsWith(".jsp")
    && !path.startsWith("/jsp/")
    && !"/404.jsp".equals(path)
    && !"/index.jsp".equals(path)) {
    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    return;
}
```

#### Ví Dụ

| URL truy cập                                | Kết quả           | Lý do                               |
| ------------------------------------------- | ----------------- | ----------------------------------- |
| `http://.../login.jsp` (trực tiếp)          | **404 Not Found** | Bị chặn, phải qua `/login` Servlet  |
| `http://.../jsp/login.jsp` (qua forward)    | **OK**            | Servlet forward hợp lệ              |
| `http://.../index.jsp`                      | **OK**            | White list (welcome file)           |
| `http://.../404.jsp`                        | **OK**            | White list (error page)             |
| `http://.../admin/products.jsp` (trực tiếp) | **404 Not Found** | Bị chặn, phải qua `/admin/products` |

### 3.6. Security Headers

SecurityFilter set các HTTP response headers để bảo vệ ứng dụng khỏi các tấn công phía client.

| Header                   | Giá trị                               | Mục đích                       | Chống tấn công                    |
| ------------------------ | ------------------------------------- | ------------------------------ | --------------------------------- |
| `X-Content-Type-Options` | `nosniff`                             | Chặn MIME-type sniffing        | Drive-by download, MIME confusion |
| `X-Frame-Options`        | `DENY`                                | Không cho phép iframe          | Clickjacking                      |
| `X-XSS-Protection`       | `1; mode=block`                       | Bật XSS filter của trình duyệt | Reflected XSS (trình duyệt cũ)    |
| `Referrer-Policy`        | `strict-origin-when-cross-origin`     | Kiểm soát Referrer header      | Information leakage               |
| `Cache-Control`          | `no-store, no-cache, must-revalidate` | Không cache nội dung           | Sensitive data in cache           |
| `Pragma`                 | `no-cache`                            | HTTP/1.0 cache control         | Sensitive data in cache           |
| `Expires`                | `0`                                   | Hết hạn ngay lập tức           | Sensitive data in cache           |

### 3.7. Sequence Diagram: Phân Quyền Admin

```
┌─────────┐     ┌──────────────┐     ┌─────────────────┐     ┌────────────┐
│ Browser │     │SecurityFilter│     │  AdminOrder     │     │  Database  │
│         │     │  (Filter)    │     │  Servlet        │     │            │
└────┬────┘     └──────┬───────┘     └───────┬─────────┘     └─────┬──────┘
     │                 │                     │                    │
     │ GET /admin/     │                     │                    │
     │ orders          │                     │                    │
     │────────────────>│                     │                    │
     │                 │                     │                    │
     │                 │  Set Security       │                    │
     │                 │  Headers (7 headers)│                    │
     │                 │                     │                    │
     │                 │  path = "/admin/    │                    │
     │                 │  orders"            │                    │
     │                 │                     │                    │
     │                 │  ┌─Kết thúc .jsp?   │                    │
     │                 │  │ → Không (bỏ qua) │                    │
     │                 │  │                  │                    │
     │                 │  └─Bắt đầu /admin?  │                    │
     │                 │    │                │                    │
     │                 │    ├─ /admin-asset/ │                    │
     │                 │    │ → Không        │                    │
     │                 │    │                │                    │
     │                 │    ├─ session==null?│                    │
     │                 │    │ → Kiểm tra     │                    │
     │                 │    │                │                    │
     │                 │    ├─ user==null?   │                    │
     │                 │    │ → Kiểm tra     │                    │
     │                 │    │                │                    │
     │                 │    └─ role==        │                    │
     │                 │       QUAN_TRI_VIEN?│                    │
     │                 │       → Kiểm tra    │                    │
     │                 │                     │                    │
     │  ┌───[TH1: Chưa đăng nhập]──┐        │                    │
     │  │                          │         │                    │
     │  │ Redirect /login          │         │                    │
     │  │<─────────────────────────│         │                    │
     │  │                          │         │                    │
     │  └──────────────────────────┘         │                    │
     │                                       │                    │
     │  ┌───[TH2: Đã login, không phải admin]│                   │
     │  │                          │         │                    │
     │  │ 403 Forbidden            │         │                    │
     │  │<─────────────────────────│         │                    │
     │  │                          │         │                    │
     │  └──────────────────────────┘         │                    │
     │                                       │                    │
     │  ┌───[TH3: Đã login, là admin]──┐    │                    │
     │  │                          │         │                    │
     │  │ chain.doFilter()         │         │                    │
     │  │──────────────────────────────────>│                    │
     │  │                          │         │                    │
     │  │                          │ doGet() │                    │
     │  │                          │         │                    │
     │  │                          │ orderService.getOrders()    │
     │  │                          │───────────────────────────>│
     │  │                          │         │                    │
     │  │                          │         │  SELECT * FROM    │
     │  │                          │         │  DON_HANG ...     │
     │  │                          │<───────────────────────────│
     │  │                          │         │                    │
     │  │                          │ List<Order> orders          │
     │  │                          │         │                    │
     │  │                          │ setAttr("orders", orders)   │
     │  │                          │ forward /jsp/admin/orders.jsp│
     │  │                          │         │                    │
     │  │<──────────────────────────────────│                    │
     │  │                          │         │                    │
     │  │ HTML (danh sách đơn hàng)│         │                    │
     │  │<──────────────────────────────────│                    │
     │  │                          │         │                    │
     └──┴──────────────────────────┴─────────┴────────────────────┘
```

---

## 4. KẾT LUẬN & CẢI TIẾN

### 4.1. Tổng Kết

Hệ thống ComputerStore đã triển khai thành công:

- ✅ **Kiến trúc MVC** rõ ràng với 4 layer riêng biệt (Controller → Service → DAO → DB)
- ✅ **Xác thực** dựa trên session, sử dụng BCrypt cho password hashing
- ✅ **Phân quyền** qua Filter Chain với mô hình RBAC (2 roles)
- ✅ **Bảo vệ tài nguyên** (chặn JSP trực tiếp, security headers)
- ✅ **PreparedStatement** chống SQL Injection

### 4.2. Các Cải Tiến Đề Xuất

| Vấn đề               | Mô tả                                  | Mức ưu tiên | Giải pháp đề xuất                                               |
| -------------------- | -------------------------------------- | ----------- | --------------------------------------------------------------- |
| **CSRF Protection**  | Thiếu token chống giả mạo request      | Cao         | Thêm CSRF token trong form và verify trong Filter               |
| **Rate Limiting**    | Không giới hạn số lần đăng nhập        | Cao         | Thêm filter đếm số lần thất bại, khóa tạm thời                  |
| **Password Policy**  | Chưa kiểm tra độ mạnh mật khẩu rõ ràng | Trung bình  | Thêm yêu cầu: 8+ ký tự, chữ hoa, chữ thường, số, ký tự đặc biệt |
| **Session Fixation** | Không regenerate session ID sau login  | Trung bình  | Gọi `session.changeSessionId()` sau login                       |
| **Logout others**    | Không thể đăng xuất thiết bị khác      | Thấp        | Theo dõi session IDs, cho phép hủy từ xa                        |
| **2FA**              | Chưa có xác thực 2 lớp                 | Thấp        | Tích hợp Google Authenticator hoặc OTP qua email                |
| **Audit Log**        | Chưa ghi log hành vi người dùng        | Trung bình  | Ghi log đăng nhập, thay đổi dữ liệu quan trọng                  |
| **HTTPS**            | Chưa cấu hình SSL/TLS                  | Cao         | Cấu hình HTTPS trên Tomcat (production)                         |

### 4.3. Sơ Đồ Kiến Trúc Bảo Mật Tổng Thể

```
┌────────────────────────────────────────────────────────────────────┐
│                     SECURITY ARCHITECTURE                           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                   DEFENSE IN DEPTH                            │  │
│  │                                                               │  │
│  │  Layer 1: Network Security                                    │  │
│  │  ├─ HTTPS (chưa cấu hình)                                    │  │
│  │  └─ Tomcat trên port 8080                                     │  │
│  │                                                               │  │
│  │  Layer 2: Application Security (Filter Chain)                │  │
│  │  ├─ EncodingFilter: UTF-8 (chống Unicode attacks)            │  │
│  │  ├─ SecurityFilter:                                          │  │
│  │  │  ├─ Security Headers (XSS, Clickjacking, Cache)           │  │
│  │  │  ├─ JSP Direct Access Prevention                          │  │
│  │  │  ├─ Authentication Check (session)                        │  │
│  │  │  └─ Authorization Check (role)                            │  │
│  │  └─ PerformanceFilter (monitoring)                            │  │
│  │                                                               │  │
│  │  Layer 3: Authentication & Session Management                │  │
│  │  ├─ BCrypt password hashing (cost=12)                        │  │
│  │  ├─ HTTP Session (timeout=30 phút)                           │  │
│  │  └─ session.invalidate() on logout                           │  │
│  │                                                               │  │
│  │  Layer 4: Data Access Security                                │  │
│  │  ├─ PreparedStatement (SQL Injection prevention)             │  │
│  │  ├─ Input Validation (ValidationUtil)                        │  │
│  │  └─ HikariCP Connection Pool (connection management)         │  │
│  │                                                               │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

> **Tài liệu tham khảo**:
>
> - `src/main/java/com/computerstore/filters/SecurityFilter.java`
> - `src/main/java/com/computerstore/controllers/AuthServlet.java`
> - `src/main/java/com/computerstore/services/UserService.java`
> - `src/main/java/com/computerstore/dao/UserDAO.java`
> - `src/main/java/com/computerstore/models/User.java`
> - `docs/SYSTEM_DOCUMENTATION_COMPREHENSIVE.md`
