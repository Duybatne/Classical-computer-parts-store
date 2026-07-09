# BÀI THUYẾT TRÌNH HỆ THỐNG: ComputerStore (IT6080 – Lập trình Web với Java)

> Phù hợp rubric trong **YC.md**:
>
> - 1 Use Case tổng quát
> - ≥ 3 Use Case chi tiết (chức năng chính)
> - ≥ 2 Sequence Diagram (chức năng quan trọng)
> - Slide có 4 phần đúng rubric: (1) Báo cáo & Thiết kế, (2) Source Code & Demo, (3) Kỹ năng thuyết trình, (4) Vấn đáp cá nhân
> - Có kịch bản demo + test case chạy

---

## 0) Thông tin nhóm (điền nhanh)

- Nhóm: …………………
- Thành viên 1: …………………
- Thành viên 2: …………………
- Thành viên 3: …………………
- Lớp/HP: IT6080 – Lập trình Web với Java
- Thời gian thuyết trình/dem o: 20 phút (10’ trình bày + 5’ demo + 5’ vấn đáp)

---

## 1) SLIDE RUBRIC (4 PHẦN ĐÚNG THỨ TỰ)

### PHẦN 1 — SLIDE: **Báo cáo & Thiết kế** (≈ 10 phút)

#### Slide 1 — Tổng quan hệ thống

- ComputerStore: e-commerce bán linh kiện máy tính
- Các module chính:
  - Quản lý sản phẩm (Admin)
  - Mua hàng: Shop → Product detail → Cart → Checkout → Place order
  - Khuyến mãi/Voucher
  - PC Builder (khuyến khích)
  - Review/Danh giá
- Công nghệ:
  - Backend: Java, Jakarta Servlet, JSP
  - UI: JSP + JSTL + Bootstrap 5
  - Database: MySQL + JDBC + (pool HikariCP nếu dùng trong code)
  - Security: BCrypt (mã hóa mật khẩu)

---

#### Slide 2 — Kiến trúc 3 lớp (3-Tier)

- Presentation Layer: JSP + Bootstrap + JS
- Controller Layer: Servlet (User + Admin)
- Service Layer: Business logic
- DAO Layer: JDBC CRUD
- Database: MySQL schema + export SQL

> Gợi ý ảnh: dùng sơ đồ 3-tier (từ docs/SYSTEM_DOCUMENTATION.md)

---

#### Slide 3 — **Use Case tổng quát (Use Case tổng quát: ≥1)**

**Actors**

- Customer (KHACH_HANG)
- Admin (QUAN_TRI_VIEN)
- System (ComputerStore)

**Use Case tổng quát (General UC)**

- “Quản lý mua sắm linh kiện & đơn hàng”
  - Customer: xem sản phẩm, mua hàng, dùng voucher, checkout, đặt hàng, xem đơn, review
  - Admin: quản lý sản phẩm, duyệt/quan lý đơn, quản lý voucher, duyệt review

> Hình: Use Case Diagram tổng quát (chèn ảnh UML)

---

#### Slide 4 — **Use Case chi tiết 1: Cart + Voucher**

**Mục tiêu:** Customer thêm sản phẩm vào giỏ và áp dụng voucher (giảm đúng eligible items).

**Tên UC:** UC-CART-VOUCHER

- Pre-condition:
  - Người dùng đã login
  - Có sản phẩm hợp lệ trong DB
- Main Flow (luồng chính):
  1. Customer truy cập trang Cart
  2. Customer thêm/sửa/xóa số lượng sản phẩm
  3. Customer nhập voucher code
  4. System gọi PromotionService/DAO để validate voucher + lấy eligible products
  5. System tính discount theo eligible items và cập nhật tổng tiền
  6. System trả về UI: subtotal, discount, shipping, total
- Exception/Alternate flows (ngoại lệ):
  - Voucher không tồn tại / hết hạn → báo lỗi, không thay đổi tổng
  - Không có item eligible → discount = 0
  - Cart rỗng → không áp dụng voucher
- Post-condition:
  - Session/biến hiển thị cart có discount/tổng cập nhật

> Chèn đặc tả theo mẫu Use Case (luồng chính/ngoại lệ)

---

#### Slide 5 — **Use Case chi tiết 2: Checkout → Place Order (transaction)**

**Mục tiêu:** đặt hàng từ cart, tạo đơn + chi tiết đơn + thanh toán + cập nhật tồn kho.

**Tên UC:** UC-PLACE-ORDER

- Pre-condition:
  - Customer đã login
  - Cart có ít nhất 1 item
- Main Flow:
  1. Customer vào Checkout và xác nhận thông tin giao hàng/Payment method
  2. Customer nhấn “Place order”
  3. System gọi OrderService.placeOrder()
  4. System:
     - Tính total (subtotal + shipping - discount)
     - Begin Transaction
     - Insert DON_HANG (status: CHO_XAC_NHAN)
     - Insert CHI_TIET_DON_HANG (mỗi item trong cart)
     - Update SAN_PHAM.SoLuongTon -= qty
     - Insert THANH_TOAN (trạng thái CHUA_THANH_TOAN)
     - Delete CHI_TIET_GIO_HANG (clear cart)
     - Commit
  5. System hiển thị trang xác nhận/đơn hàng
- Exception/Alternate:
  - Cart rỗng → từ chối đặt hàng
  - Tồn kho không đủ cho item → báo lỗi, rollback
  - Lỗi DB/transaction → rollback và hiển thị error
- Post-condition:
  - Đơn hàng + chi tiết đơn tồn tại trong DB
  - Cart được xóa
  - Tồn kho đã update

---

#### Slide 6 — **Use Case chi tiết 3: Admin cập nhật trạng thái đơn**

**Mục tiêu:** Admin quản lý đơn: chuyển trạng thái theo tiến trình giao hàng hoặc hủy.

**Tên UC:** UC-ADMIN-ORDER-STATUS

- Pre-condition:
  - Admin login
  - Có đơn ở trạng thái phù hợp
- Main Flow:
  1. Admin vào Admin Dashboard / Orders page
  2. System hiển thị danh sách đơn
  3. Admin chọn đơn và cập nhật trạng thái
  4. System cập nhật:
     - CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO
     - (Nếu có) có thể hủy ở các bước trước DA_GIAO
  5. System trả về danh sách cập nhật
- Exception:
  - Chọn trạng thái không hợp lệ theo business rule → từ chối
  - Lỗi DB → không cập nhật

---

#### Slide 7 — **Sequence Diagram 1: Place Order**

> Dùng để minh chứng transaction và mapping vào code (OrderService + DAO)

**Tên SD:** SD-PLACE-ORDER
**Participants:**

- Customer
- Checkout Servlet/Controller (OrderServlet)
- OrderService
- PromotionService (nếu voucher cần lấy discount)
- OrderDAO/PaymentDAO/CartDAO/ProductDAO (DAO layer)
- Database

**Luồng tóm tắt:**

1. Customer → OrderServlet: POST placeOrder()
2. OrderServlet → OrderService.placeOrder()
3. OrderService:
   - đọc cart items
   - validate tồn kho
   - transaction:
     - insert DON_HANG
     - insert CHI_TIET_DON_HANG
     - update SAN_PHAM (giảm SoLuongTon)
     - insert THANH_TOAN
     - delete cart items
4. OrderService commit
5. OrderServlet render kết quả

---

#### Slide 8 — **Sequence Diagram 2: Apply Voucher**

**Tên SD:** SD-APPLY-VOUCHER
**Participants:**

- Customer
- CartServlet
- PromotionService
- PromotionProductDAO/PromotionDAO
- CartDAO/SanPhamDAO (tùy code thực tế)
- Database

**Luồng tóm tắt:**

1. Customer → CartServlet: POST /cart/voucher (voucherCode)
2. CartServlet → PromotionService:
   - validate voucher (date/status)
   - get eligible product IDs
   - filter cart items theo eligible IDs
   - compute discount
3. PromotionService cập nhật discount trong session/return
4. CartServlet render cart UI với tổng mới

---

#### Slide 9 — DB schema / ERD (tóm tắt)

- Tóm tắt bảng chính liên quan demo:
  - SAN_PHAM (SoLuongTon)
  - GIO_HANG, CHI_TIET_GIO_HANG
  - DON_HANG, CHI_TIET_DON_HANG
  - THANH_TOAN
  - KHUYEN_MAI, KHUYEN_MAI_SAN_PHAM
- Trích ý: transaction tạo đơn + update tồn kho + clear cart.

> Nhắc: dùng `database/schema.sql` + export SQL để deliverable.

---

#### Slide 10 — Mapping Design ↔ Code (để chuẩn bị demo)

**Cart/Voucher**

- Controller: CartServlet
- Service: PromotionService (và/hoặc Cart logic)
- DAO: CartDAO + PromotionProductDAO/PromotionDAO + product/related DAO
- UI: cart.jsp (hiển thị discount/tổng)

**Place Order**

- Controller: OrderServlet (hoặc servlet đặt hàng trong project)
- Service: OrderService
- DAO: OrderDAO + PaymentDAO + ProductDAO + CartDAO
- UI: checkout/cart/order confirmation jsp

**Admin Orders**

- Controller: AdminOrderServlet (nếu có) / admin pages
- DAO: OrderDAO
- UI: admin/dashboard.jsp + admin pages

> Chèn danh sách các file/đoạn code key để giải thích khi vấn đáp.

---

### PHẦN 2 — SLIDE: **Source Code & Demo** (≈ 5 phút)

#### Slide 11 — Demo tổng quan (kịch bản 20 phút chia phần)

- Người trình bày 1: Cart + Voucher
- Người trình bày 2: Checkout → Place Order (transaction)
- Người trình bày 3: Admin cập nhật trạng thái đơn + giải thích logic

---

#### Slide 12 — Demo 1: Cart + Voucher

Checklist demo:

- [ ] Login Customer
- [ ] Vào trang Cart
- [ ] Thêm sản phẩm vào giỏ (add)
- [ ] Nhập voucher code (hợp lệ)
- [ ] Quan sát: discount tính đúng
- [ ] Thử voucher không hợp lệ / hết hạn → báo lỗi, total không đổi

Test evidence:

- Chụp ảnh UI trước/sau voucher
- Ghi voucherCode dùng từ Sample_data.sql

---

#### Slide 13 — Demo 2: Checkout → Place Order

Checklist demo:

- [ ] Vào Checkout
- [ ] Điền thông tin giao hàng + chọn Payment method
- [ ] Submit “Place order”
- [ ] Kiểm tra UI: đơn hàng tạo thành công
- [ ] Kiểm tra DB:
  - DON_HANG mới xuất hiện (status CHO_XAC_NHAN)
  - CHI_TIET_DON_HANG có đúng số dòng theo cart items
  - SAN_PHAM.SoLuongTon giảm
  - THANH_TOAN record tạo ra
  - Giỏ hàng được clear

---

#### Slide 14 — Demo 3: Admin cập nhật trạng thái đơn

Checklist demo:

- [ ] Login Admin
- [ ] Vào Admin Orders
- [ ] Chuyển trạng thái:
  - CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO
- [ ] Thể hiện danh sách cập nhật realtime
- [ ] Trường hợp cancel trước DA_GIAO (nếu project hỗ trợ)

---

#### Slide 15 — Test case & chạy lệnh

- Backend: chạy bằng Maven
  - `mvn test`
- Nêu 2 test case sẽ chứng minh:
  1. Voucher discount tính theo eligible items (khớp TODO.md rule chọn #1)
  2. placeOrder transaction tạo đúng record & xử lý rollback khi fail (nếu có test)

> Nếu project chưa có unit test cụ thể, bổ sung mục: “integration test thủ công” (screenshot + DB query) để đáp ứng demo/credibility.

---

### PHẦN 3 — SLIDE: **Kỹ năng thuyết trình** (≈ 2 phút nội dung + tips)

#### Slide 16 — Cách trình bày để đạt rubric

- Trình bày theo luồng: Use Case tổng quát → Use Case chi tiết → Sequence → mapping code
- Mỗi người trình bày đúng phần việc:
  - Người 1: Voucher eligibility + tính discount
  - Người 2: Place order transaction + tồn kho + clear cart
  - Người 3: Admin update order status + giải thích business rule
- Nhấn mạnh: “Thiết kế dẫn đường cho code thực thi được như thế nào”

---

### PHẦN 4 — SLIDE: **Vấn đáp cá nhân** (≈ 3–5 phút)

#### Slide 17 — Dự đoán câu hỏi thường gặp (chuẩn bị trả lời)

1. Voucher discount tính như thế nào? Eligible items lấy từ đâu?
2. Place order dùng transaction ra sao? Rollback khi nào?
3. Vì sao tách Controller/Service/DAO?
4. Đảm bảo tồn kho không bị âm bằng cách nào?
5. Admin update trạng thái có kiểm tra business rule không?
6. DB index/connection pooling ảnh hưởng gì?

> Chuẩn bị slide trả lời ngắn gọn theo “Design → Code → Demo evidence”.

---

## 2) GỢI Ý UML + “ĐỂ VẼ NHANH” (bạn có thể copy vào draw.io/StarUML)

### Use Case chi tiết (mẫu tóm tắt)

- UC-CART-VOUCHER
  - Actors: Customer
  - Preconditions: login, cart có item
  - Main: add → apply voucher → recalc total
  - Exceptions: invalid/expired voucher, no eligible items
  - Post: discount/total updated

- UC-PLACE-ORDER
  - Actors: Customer
  - Preconditions: login, cart not empty
  - Main: checkout → placeOrder → transaction create records → clear cart
  - Exceptions: empty cart, insufficient stock, DB failure
  - Post: order created

- UC-ADMIN-ORDER-STATUS
  - Actors: Admin
  - Preconditions: admin login
  - Main: view orders → update status step-by-step
  - Exceptions: invalid status transition / DB error
  - Post: order status updated

---

## 3) DANH SÁCH “DEMO EVIDENCE” NÊN CHỤP ẢNH

- Screenshot trang cart trước khi áp voucher
- Screenshot cart sau áp voucher (discount/total thay đổi)
- Screenshot checkout và trạng thái đặt hàng thành công
- Ảnh admin orders sau khi cập nhật status
- (Nếu có) screenshot/ảnh query DB hoặc log cho thấy insert/update/transaction

---

## 4) CHECKLIST TRƯỚC KHI NỘP

- [ ] Có 1 Use Case tổng quát + ≥3 Use Case chi tiết
- [ ] Có ≥2 Sequence Diagram (Place Order, Apply Voucher)
- [ ] Đặc tả mỗi Use Case: luồng chính + ngoại lệ
- [ ] UI Bootstrap responsive:
  - [ ] Trang chủ
  - [ ] Form nhập (login/register/checkout) có validation cơ bản
  - [ ] Menu điều hướng
  - [ ] Dashboard admin
- [ ] DB schema + export SQL (database/schema.sql + dữ liệu sample)
- [ ] DAO/JDBC CRUD chạy không lỗi
- [ ] Demo live:
  - [ ] cart → voucher
  - [ ] checkout → placeOrder (transaction)
  - [ ] admin cập nhật status
- [ ] ≥2 test case (unit/integration) hoặc bằng chứng chạy test (mvn test + kết quả) + demo DB state
