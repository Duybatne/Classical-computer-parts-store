# Kịch bản thuyết trình (Frontend - Database - Backend) – ComputerStore (IT6080)

## Mục tiêu

- Nói rõ **thiết kế → code thực thi được → demo chứng minh**
- Chuẩn rubric YC.md:
  - Báo cáo & Thiết kế
  - Source Code & Demo (live)
  - Kỹ năng thuyết trình
  - Vấn đáp cá nhân

---

# A) FRONTEND (Bootstrap/JSP/UI) – Kịch bản nói 1–2 phút

## A1. Trang chủ & điều hướng (Landing/Home)

**Mục tiêu UI:** hiển thị danh sách sản phẩm nổi bật + nút dẫn tới Shop/Cart/Builder/Admin.

**Điểm cần highlight khi demo**

- Menu điều hướng:
  - Shop / Sản phẩm
  - Cart
  - Checkout
  - (Admin) Dashboard
- Trang có layout responsive (Bootstrap 5):
  - grid sản phẩm co giãn theo màn hình
  - nút CTA rõ ràng (Add to cart / View detail)

**Cách nói (script ngắn)**

> “Frontend dùng JSP + Bootstrap 5 để đảm bảo responsive. Trang chủ đóng vai trò điều hướng vào các luồng chính: xem sản phẩm, xem chi tiết, thêm vào giỏ và checkout; đồng thời có phần admin dashboard cho quản trị viên.”

---

## A2. Shop / Products list (pagination/filter nếu có)

**Mục tiêu UI:** lọc theo category/tìm kiếm, hiển thị danh sách sản phẩm.

**Điểm cần highlight**

- Component card hiển thị:
  - tên sản phẩm
  - giá
  - ảnh đại diện
  - nút xem chi tiết / add cart
- Nếu có pagination:
  - hiển thị page/limit
  - điều hướng qua các trang

**Khu vực liên quan file**

- `src/main/webapp/jsp/index.jsp`
- `src/main/webapp/jsp/products.jsp`

---

## A3. Product detail + Review/Rating

**Mục tiêu UI:** xem thông tin chi tiết và để user để lại review.

**Điểm cần highlight**

- Hiển thị thông tin linh kiện (tùy loại)
- Review form:
  - input rating
  - textarea nội dung comment
  - submit review
- Validation cơ bản:
  - rating theo range
  - comment không rỗng

**File liên quan**

- `src/main/webapp/jsp/product-detail.jsp` (nếu có trong project)
- servlet liên quan review (tra theo codebase để trỏ cho đúng endpoint)

---

## A4. Cart (add/update/remove/clear) + Voucher UI

**Mục tiêu UI:** hiển thị subtotal/shipping/discount/total và cho người dùng áp voucher.

**Điểm cần highlight**

- Bảng/box giỏ hàng hiển thị:
  - danh sách item
  - số lượng
  - giá tại thời điểm thêm
- Form áp voucher:
  - input voucherCode
  - nút Apply
- Khi áp voucher:
  - total thay đổi ngay trên UI (dựa session/server response)
- Có xử lý lỗi:
  - voucher không hợp lệ → hiển thị message

**File liên quan**

- `src/main/webapp/jsp/cart.jsp`
- Controller:
  - `src/main/java/com/computerstore/controllers/CartServlet.java`

---

## A5. Checkout (submit đặt hàng)

**Mục tiêu UI:** thu thập địa chỉ + chọn payment method.

**Điểm cần highlight**

- form checkout có validation cơ bản:
  - address, phone bắt buộc
  - payment method chọn từ dropdown
- Nút “Place order” submit POST lên backend
- Sau đặt hàng:
  - hiển thị trang xác nhận/chi tiết đơn

**Gợi ý file trong build/**

- Có trong log build: `target/computerstore/cheackout.jsp` (typo trong route có thể tồn tại)
- Trên repo thường nằm ở `src/main/webapp/jsp/...checkout...`

---

# B) DATABASE (MySQL + schema/export) – Kịch bản nói 2 phút

## B1. ERD/Schema & các bảng quan trọng cho demo

Khi thuyết trình, tập trung bảng liên quan trực tiếp luồng demo (cart → order → payment → inventory).

**Bảng cốt lõi**

1. `SAN_PHAM`

- `GiaBan`
- `SoLuongTon` (cập nhật sau đặt hàng)

2. `GIO_HANG`, `CHI_TIET_GIO_HANG`

- chứa giỏ theo customer
- mỗi dòng là item và quantity

3. `DON_HANG`, `CHI_TIET_DON_HANG`

- đơn tổng
- chi tiết từng sản phẩm trong đơn

4. `THANH_TOAN`

- record giao dịch thanh toán theo đơn

5. Voucher/Promotion

- `KHUYEN_MAI`
- `KHUYEN_MAI_SAN_PHAM` (eligible products)

6. Review

- `DANH_GIA`

---

## B2. Export SQL & setup DB (đúng rubric “DataBase + export file SQL”)

**Script nói**

> “Database được thiết kế theo schema.sql và có dữ liệu sample trong Sample_data.sql. Nhóm dùng file SQL export để đảm bảo giảng viên/nhóm khác có thể chạy tạo DB và demo ngay.”

**File liên quan**

- `database/schema.sql`
- `database/Sample_data.sql` (hoặc `database/sample-data.sql`)

---

## B3. Point nhấn transaction consistency

**Nêu rõ**

- place order chạy transaction:
  - insert DON_HANG
  - insert CHI_TIET_DON_HANG
  - update SAN_PHAM.SoLuongTon
  - insert THANH_TOAN
  - clear CHI_TIET_GIO_HANG

> “Transaction đảm bảo trạng thái DB không bị lệch nếu có lỗi ở giữa.”

---

# C) BACKEND (DAO/JDBC + Service/Business logic) – Kịch bản nói 3–4 phút

## C1. Kiến trúc backend: Controller → Service → DAO

**Script nói**

> “Backend theo mô hình 3 lớp. Controller đảm nhiệm nhận request/form, Service chứa logic nghiệp vụ theo Use Case, và DAO thực hiện JDBC CRUD với MySQL.”

**Map theo file**

- DAO:
  - `src/main/java/com/computerstore/dao/ProductDAO.java`
  - `src/main/java/com/computerstore/dao/CartDAO.java`
  - `src/main/java/com/computerstore/dao/...`
- Service:
  - `src/main/java/com/computerstore/services/PromotionService.java`
  - `src/main/java/com/computerstore/services/OrderService.java`
- Controller:
  - `CartServlet.java`
  - `ProductServlet.java`
  - `admin/...`

---

## C2. Luồng backend trọng tâm #1: Apply Voucher (Promotion/Eligible items)

**Khi demo, nói rõ rule**

- Voucher discount chỉ áp dụng cho **eligible items** (theo `KHUYEN_MAI_SAN_PHAM`)
- Tính discount dựa trên tổng tiền phần eligible items

**Mapping code để nói**

- Entry point:
  - `CartServlet` cho route áp voucher
- Logic:
  - `PromotionService` validate + tính discount eligible
- DAO:
  - Promotion DAO lấy eligible products
- Kết quả:
  - cập nhật discount/total trong session hoặc response cho UI

---

## C3. Luồng backend trọng tâm #2: Place Order (transaction)

**Nói rõ trách nhiệm**

- OrderService.placeOrder() chịu trách nhiệm transaction để:
  - tạo order (DON_HANG)
  - tạo order details (CHI_TIET_DON_HANG)
  - giảm tồn kho (SAN_PHAM.SoLuongTon)
  - tạo payment record (THANH_TOAN)
  - clear cart

**Điểm nhấn cho vấn đáp**

- Khi thiếu tồn kho:
  - rollback và báo lỗi
- Khi thành công:
  - commit và cập nhật UI trang xác nhận

**Mapping code**

- `src/main/java/com/computerstore/services/OrderService.java`
- DAO tương ứng (OrderDAO/PaymentDAO/ProductDAO/CartDAO) tùy project

---

## C4. Luồng backend trọng tâm #3: Admin update order status

**Mục tiêu**

- Admin đổi trạng thái đơn theo workflow:
  - CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO
  - có thể DA_HUY ở bước trước DA_GIAO

**Mapping code**

- Controller admin:
  - `src/main/java/com/computerstore/controllers/admin/...`
- Service:
  - OrderService / Admin service (tùy codebase)
- DAO:
  - cập nhật status order

---

# D) BẢNG CHECKLIST DEMO (frontend+backend+db)

## D1. Demo Cart + Voucher

1. Frontend: vào cart
2. Frontend: thêm item vào cart
3. Frontend: nhập voucherCode hợp lệ
4. Backend: PromotionService validate voucher + eligible items
5. Database: đọc eligible products + tính discount
6. Frontend: total/discount hiển thị đúng

## D2. Demo Checkout + Place Order

1. Frontend: checkout form submit
2. Backend: OrderService transaction tạo order + details + payment
3. Database: update SoLuongTon và clear cart detail lines
4. Frontend: hiển thị đơn thành công

## D3. Demo Admin update status

1. Frontend: admin dashboard/orders list
2. Backend: update order status
3. Database: trạng thái thay đổi theo rule
4. Frontend: reload hiển thị trạng thái mới

---

# E) Gợi ý chia vai trình bày (3 thành viên)

- Thành viên 1 (Frontend): UI flow + validation + hiển thị total/discount + confirm đặt hàng
- Thành viên 2 (Backend/Business logic): Promotion eligible items + Order transaction
- Thành viên 3 (Database/Admin): schema + export SQL + cập nhật trạng thái + explanation mapping DAO/JDBC
