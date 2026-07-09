# KỊCH BẢN THUYẾT TRÌNH: CHỨC NĂNG ADMIN - COMPUTERSTORE

**Thời lượng**: 10–12 phút

---

## Tổng Quan: 7 Module Admin

| # | Module | URL | Servlet |
|---|--------|-----|---------|
| 1 | Dashboard | `/admin/dashboard` | `AdminStatsServlet` |
| 2 | Sản phẩm | `/admin/products` | `AdminProductServlet` |
| 3 | Đơn hàng | `/admin/orders` | `AdminOrderServlet` |
| 4 | Tài khoản | `/admin/accounts` | `AdminAccountServlet` |
| 5 | Khuyến mãi | `/admin/promotions` | `AdminPromotionServlet` |
| 6 | Đánh giá | `/admin/reviews` | `AdminReviewServlet` |
| 7 | Báo cáo | `/admin/reports` | `AdminReportServlet` |

### Xác thực Admin (mọi module)

```
Request → isAdmin(req) → Session.getAttribute("user")
  ├── user.vaiTro != "QUAN_TRI_VIEN" → Redirect /login
  └── OK → Xử lý nghiệp vụ
```

---

## MODULE 1: DASHBOARD

> *"Dashboard hiển thị 4 KPI cards (Tổng đơn, Doanh thu, Khách hàng, Tỷ lệ hủy), 4 biểu đồ Chart.js (Line doanh thu, Pie trạng thái, Bar top sản phẩm, Doughnut danh mục), bảng 5 đơn gần nhất và Quick Links."*

```
StatsDAO:
  ├── getTotalOrders()       → COUNT(*) FROM DON_HANG
  ├── getTotalRevenue()      → SUM(TongTien) WHERE TrangThai='DA_GIAO'
  ├── getTotalCustomers()    → COUNT(*) WHERE VaiTro='KHACH_HANG'
  ├── getLowStockProducts()  → COUNT(*) WHERE SoLuongTon BETWEEN 1 AND 5
  └── getRecentOrders(5)     → TOP 5 ORDER BY NgayDat DESC
```

---

## MODULE 2: QUẢN LÝ SẢN PHẨM (783 dòng code)

> *"Module phức tạp nhất. CRUD cho 8 loại linh kiện, mỗi loại có bảng thông số riêng. Hỗ trợ tìm kiếm, lọc đa tiêu chí, sắp xếp, phân trang server-side (15 sản phẩm/trang)."*

### 2.1 Danh sách + Lọc

```
showList() → Xây WHERE clause động:
  ├── keyword  → AND (TenSP LIKE ? OR ThuongHieu LIKE ?)
  ├── category → AND MaLoaiSP = ?
  ├── status   → AND TrangThai = ?
  └── stock    → "low": 1-5 | "out": <=0 | "ok": >5
  + ORDER BY + LIMIT/OFFSET (PAGE_SIZE=15)
```

### 2.2 Thêm/Sửa sản phẩm

```
saveProduct():
  ├── Validate: tên, loại, giá >= 0
  ├── Upload ảnh: @MultipartConfig (max 5MB)
  │     ├── Check MIME: jpeg/png/gif/webp
  │     └── Filename: timestamp + "_" + sanitized_name
  ├── Build Product → insert hoặc update
  └── saveTechSpecs() → UPSERT vào bảng chi tiết theo loại
```

### 2.3 Thông số kỹ thuật (8 bảng)

| Loại | Bảng | Trường đặc trưng |
|------|------|-------------------|
| Mainboard | CT_MAINBOARD | Chipset, Socket, SoKheRam |
| CPU | CT_CPU | SoNhan, XungNhip, TDP |
| VGA | CT_VGA | VRAM, BusBoNho, SoQuat |
| Case | CT_CASE | HoTroMain, CoKinhCuongLuc |
| PSU | CT_NGUON | CongSuat, Chuan80Plus |
| Tản nhiệt | CT_TAN_NHIET | LoaiTanNhiet, TocDoQuat |
| Ổ cứng | CT_O_CUNG | DungLuong, TocDoDocGhi |
| RAM | CT_RAM | LoaiRam, BusRam, DienAp |

### 2.4 Toggle & Xóa

```
toggleProduct → productDAO.updateStatus(maSP, boolean)
deleteProduct → productDAO.delete(maSP)
```

---

## MODULE 3: QUẢN LÝ ĐƠN HÀNG

> *"Áp dụng State Machine Pattern – chỉ cho phép chuyển trạng thái theo thứ tự hợp lệ."*

### Vòng đời đơn hàng

```
CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO (kết thúc)
     ↓              ↓
   DA_HUY         DA_HUY (kết thúc)
```

| Hiện tại | Cho phép chuyển sang |
|----------|---------------------|
| CHO_XAC_NHAN | DA_XAC_NHAN, DA_HUY |
| DA_XAC_NHAN | DANG_GIAO, DA_HUY |
| DANG_GIAO | DA_GIAO |
| DA_GIAO | *(khóa)* |
| DA_HUY | *(khóa)* |

### Logic

```
updateStatus:
  ├── Lấy currentStatus từ DB
  ├── VALID_TRANSITIONS.get(currentStatus).contains(newStatus)?
  │     ├── YES → orderService.updateOrderStatus()
  │     └── NO  → "Không thể chuyển từ X sang Y"

Xem chi tiết: Order + List<OrderDetail> + Payment
```

---

## MODULE 4: QUẢN LÝ TÀI KHOẢN

> *"CRUD tài khoản với cơ chế bảo vệ: Admin không thể tự vô hiệu hóa hoặc xóa chính mình."*

| Chức năng | Logic |
|-----------|-------|
| **Tìm kiếm** | `getAllAccounts(q, role)` – lọc theo tên/email + vai trò |
| **Toggle** | Chặn `maTK == admin.getMaTK()`, sau đó `updateAccountStatus()` |
| **Tạo admin** | Sanitize + validate (username 3-20, pass ≥ 8, email hợp lệ) → BCrypt hash |
| **Xóa** | Chặn tự xóa. `type="hard"` → DELETE, `type="soft"` → SET TrangThai=0 |
| **Nâng cấp** | `upgradeToAdmin()` → UPDATE VaiTro='QUAN_TRI_VIEN' |

---

## MODULE 5: QUẢN LÝ KHUYẾN MÃI

> *"Tạo voucher giảm giá theo phần trăm hoặc số tiền cố định, gán sản phẩm áp dụng."*

### Tạo mã

```
  ├── tenKM = maVoucher.toUpperCase()
  ├── loaiGiam: "percent" → PHAN_TRAM | "fixed" → SO_TIEN
  ├── ngayKetThuc: có → dùng | null → 2099-12-31
  └── promotionDAO.insert(p)
```

### Gán sản phẩm (AdminPromotionProductsServlet)

```
POST /admin/promotions/products
  └── promotionProductDAO.replaceProductsByPromotion(maKM, maSPList)
        → DELETE cũ + INSERT mới (replace toàn bộ)
```

---

## MODULE 6: QUẢN LÝ ĐÁNH GIÁ

> *"Kiểm duyệt đánh giá: Lọc theo trạng thái, Duyệt/Từ chối/Xóa."*

```
GET  /admin/reviews?status=X → reviewDAO.getAll(status)
POST /admin/reviews/approve  → reviewDAO.approve(maDanhGia)
POST /admin/reviews/reject   → reviewDAO.reject(maDanhGia)
POST /admin/reviews/delete   → reviewDAO.delete(maDanhGia)
```

---

## MODULE 7: BÁO CÁO & XUẤT FILE

> *"7 tab báo cáo + xuất Excel/PDF chuyên nghiệp."*

### 7 Tab

| Tab | Nội dung |
|-----|----------|
| overview | KPI + biểu đồ tổng hợp |
| revenue | Doanh thu chi tiết từng đơn (lọc category, staff) |
| products | Tồn kho & lượng bán 30 ngày |
| customers | Tổng đơn, chi tiêu, đơn hủy mỗi KH |
| orders | Phân bố đơn theo giờ + lý do hủy |
| promotions | Hiệu quả từng mã KM |
| payments | Thống kê phương thức thanh toán |

### Xuất Excel (`AdminReportExportServlet`)

```
  ├── Apache POI XSSFWorkbook
  ├── Title block: tên cửa hàng + khoảng thời gian
  ├── 15+ CellStyle: header xanh đậm, zebra rows, currency format
  ├── Status coloring: xanh (DA_GIAO), đỏ (DA_HUY), cam (CHO_XAC_NHAN)
  ├── Summary row: border double, tổng cộng
  └── Auto-size columns
```

### Xuất PDF (`AdminReportPdfServlet`)

```
  └── ReportGeneratorService (iText)
        ├── Borderless table design
        ├── Branding header
        └── 7 loại báo cáo PDF
```

---

## BẢO MẬT ADMIN

| Cơ chế | Chi tiết |
|--------|----------|
| Xác thực | Session-based, kiểm tra VaiTro mỗi request |
| Chống tự hại | Không tự xóa/vô hiệu hóa tài khoản mình |
| Input validation | `ValidationUtil.sanitize()` chống XSS |
| CSRF | `CSRFFilter.java` bảo vệ POST request |
| Security Headers | 7 headers (X-Frame-Options, X-XSS-Protection...) |
| Upload an toàn | Check MIME, giới hạn 5MB, sanitize filename |
| State Machine | Ngăn chuyển trạng thái đơn hàng không hợp lệ |

---

## GỢI Ý DEMO

1. **Dashboard** → 4 KPI + hover biểu đồ
2. **Sản phẩm** → Thêm CPU mới + upload ảnh → Lọc "Sắp hết hàng"
3. **Đơn hàng** → Chi tiết đơn → Chuyển CHO_XAC_NHAN → DA_XAC_NHAN
4. **Tài khoản** → Tìm user → Toggle → Nâng cấp Admin
5. **Khuyến mãi** → Tạo SALE20 giảm 20% → Gán sản phẩm
6. **Đánh giá** → Lọc "Chờ duyệt" → Duyệt
7. **Báo cáo** → Tab Tổng quan → Xuất Excel → Xuất PDF
