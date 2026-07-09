# TODO - Hoàn thiện chức năng Quản lý Khuyến mãi (Promotion)

**Trạng thái cuối: Đã hoàn thiện các chức năng chính (30/03/2025)**

## 1) Rà soát UI/Admin ✅

- [x] Kiểm tra `src/main/webapp/jsp/admin/promotions.jsp`:
  - Form tạo voucher có đúng field/parameter khớp `AdminPromotionServlet` → ✅
  - AJAX load products đã hoạt động (`/api/promotions/{maKM}/products?all=true`) → ✅ (đã sửa để load TẤT CẢ sản phẩm, đánh dấu checked)
  - Có action/submit để lưu mapping sản phẩm -> khuyến mãi → ✅ (`/admin/promotions/products` POST)
  - Modal hiển thị tất cả sản phẩm để chọn/bỏ chọn → ✅

## 2) Chuẩn hoá backend AdminPromotionServlet ✅

- [x] Parse/validate:
  - `maVoucher` (code) map vào `TenKM` → ✅
  - `loaiGiam` map đúng `PHAN_TRAM|SO_TIEN` → ✅
  - `giaTriGiam` > 0 → ✅
  - `hanSuDung` (ngày kết thúc) hợp lệ; default `2099-12-31` nếu rỗng → ✅
- [x] Thông báo `successMsg/errorMsg` được render ra đúng UI → ✅

## 3) Lưu mapping sản phẩm cho khuyến mãi ✅

- [x] `PromotionProductDAO.insert`/`DELETE` mapping (bảng `KHUYEN_MAI_SAN_PHAM`) → ✅ (`replaceProductsByPromotion`)
- [x] Handler POST trong `AdminPromotionProductsServlet` (`/admin/promotions/products`) để lưu mapping → ✅
- [x] UI chọn sản phẩm + nút lưu gán trong `promotions.jsp` → ✅

## 4) Logic apply voucher end-to-end ✅

- [x] `PromotionService.applyVoucherToCart(maKM, items)`:
  - eligibleSubtotal chỉ gồm sản phẩm nằm trong mapping → ✅
  - discount tính đúng theo `PHAN_TRAM` và `SO_TIEN` → ✅
- [x] `CartServlet` (/cart/voucher): discount session set đúng → ✅
- [x] `OrderServlet` (/checkout): voucher code map đúng `maKM` → ✅
- [x] `OrderService.placeOrder` trừ discount bằng `applyVoucherToCart` → ✅

## 5) Hiển thị ✅

- [x] `checkout.jsp` và `cart.jsp` hiển thị discountAmount/voucherCode đúng → ✅
- [x] Đơn vị tiền tệ thống nhất `₫` (VND) → ✅

## 6) Build & Test ✅

- [x] Build + unit test: **102 tests, 0 failures** → ✅

## 7) Kịch bản kiểm thử thủ công

- [ ] Admin tạo voucher + bật trạng thái.
- [ ] Admin gán 1 sản phẩm vào voucher.
- [ ] User add đúng sản phẩm -> áp voucher -> xem discount đúng.
- [ ] Checkout -> tổng tiền trong `DON_HANG.TongTien` phản ánh discount.
- [ ] User áp voucher khi voucher đã tắt/hết hạn -> discount = 0.
