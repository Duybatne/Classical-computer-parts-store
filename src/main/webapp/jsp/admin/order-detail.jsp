<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/common" %>

<t:admin-layout title="Chi tiết đơn hàng" activePage="orders">
  <div class="container-fluid py-4">
    <div class="row">
      <div class="col-12">
        <!-- Print Header -->
        <div class="d-none d-print-block mb-4">
          <div class="row align-items-center">
            <div class="col-6">
              <h3 class="text-primary fw-bold mb-1">COMPUTER SPACE</h3>
              <p class="text-muted mb-1 small">Cửa hàng linh kiện máy tính hàng đầu Việt Nam</p>
              <p class="text-muted mb-0 small">Địa chỉ: 123 Đường Ba Tháng Hai, Quận 10, TP. Hồ Chí Minh</p>
              <p class="text-muted mb-0 small">Hotline: 1900 123 456 | Email: contact@computerspace.vn</p>
            </div>
            <div class="col-6 text-end">
              <h3 class="fw-bold text-dark mb-1">HÓA ĐƠN BÁN HÀNG (ADMIN)</h3>
              <p class="mb-1 small"><strong>Mã đơn:</strong> #${order.maDonHang}</p>
              <p class="mb-0 small"><strong>Khách hàng:</strong> ${order.hoTenKhachHang}</p>
              <p class="mb-0 small"><strong>Ngày đặt:</strong> ${order.ngayDat}</p>
            </div>
          </div>
          <hr class="border-secondary my-3">
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 d-print-none">
          <h2><i class="fas fa-file-invoice me-2"></i>Chi tiết đơn hàng #${order.maDonHang}</h2>
          <div>
            <button class="btn btn-primary me-2" onclick="window.print()">
              <i class="fas fa-print me-2"></i>In hóa đơn
            </button>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
              <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
          </div>
        </div>

        <div class="row g-4">
          <!-- Order Info -->
          <div class="col-md-6">
            <div class="card shadow-sm h-100">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h5>
              </div>
              <div class="card-body">
                <div class="mb-3">
                  <span class="badge bg-${order.trangThaiDonHang == 'DA_GIAO' ? 'success' :
                                          order.trangThaiDonHang == 'DA_HUY' ? 'danger' :
                                          order.trangThaiDonHang == 'CHO_XAC_NHAN' ? 'warning' : 'info'} fs-6">
                    <c:choose>
                      <c:when test="${order.trangThaiDonHang == 'CHO_XAC_NHAN'}">Chờ xác nhận</c:when>
                      <c:when test="${order.trangThaiDonHang == 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                      <c:when test="${order.trangThaiDonHang == 'DANG_GIAO'}">Đang giao</c:when>
                      <c:when test="${order.trangThaiDonHang == 'DA_GIAO'}">Đã giao</c:when>
                      <c:when test="${order.trangThaiDonHang == 'DA_HUY'}">Đã hủy</c:when>
                      <c:otherwise>${order.trangThaiDonHang}</c:otherwise>
                    </c:choose>
                  </span>
                </div>
                <ul class="list-unstyled mb-0">
                  <li class="mb-2"><strong>Khách hàng:</strong> ${order.hoTenKhachHang}</li>
                  <li class="mb-2"><strong>Ngày đặt:</strong> ${order.ngayDat}</li>
                  <li class="mb-2"><strong>Địa chỉ nhận:</strong> ${order.diaChiNhan}</li>
                  <li class="mb-2"><strong>Số điện thoại:</strong> ${order.sdtNhan}</li>
                  <c:if test="${not empty order.ghiChu}">
                    <li class="mb-2"><strong>Ghi chú:</strong> ${order.ghiChu}</li>
                  </c:if>
                </ul>
              </div>
            </div>
          </div>

          <!-- Payment Info -->
          <div class="col-md-6">
            <div class="card shadow-sm h-100">
              <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>Thông tin thanh toán</h5>
              </div>
              <div class="card-body">
                <c:if test="${not empty payment}">
                  <ul class="list-unstyled mb-0">
                    <li class="mb-2"><strong>Phương thức:</strong>
                      ${payment.maPTTT == 1 ? 'COD (Thanh toán khi nhận hàng)' :
                        payment.maPTTT == 2 ? 'Chuyển khoản ngân hàng' :
                        payment.maPTTT == 3 ? 'Ví điện tử' : 'Khác'}
                    </li>
                    <li class="mb-2"><strong>Trạng thái:</strong>
                      <span class="${payment.trangThaiThanhToan == 'DA_THANH_TOAN' ? 'text-success fw-bold' : 'text-warning fw-bold'}">
                        ${payment.trangThaiThanhToan}
                      </span>
                    </li>
                    <li class="mb-2"><strong>Số tiền:</strong>
                      <fmt:formatNumber value="${payment.soTien}" type="currency" currencySymbol="₫"/>
                    </li>
                    <c:if test="${not empty payment.thoiGianThanhToan}">
                      <li class="mb-2"><strong>Thời gian:</strong> ${payment.thoiGianThanhToan}</li>
                    </c:if>
                  </ul>
                </c:if>
                <c:if test="${empty payment}">
                  <p class="text-muted mb-0">Chưa có thông tin thanh toán</p>
                </c:if>
              </div>
            </div>
          </div>

          <!-- Order Items -->
          <div class="col-12">
            <div class="card shadow-sm">
              <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-shopping-basket me-2"></i>Sản phẩm đã đặt</h5>
              </div>
              <div class="card-body">
                <c:choose>
                  <c:when test="${not empty details}">
                    <div class="table-responsive">
                      <table class="table table-striped">
                        <thead class="table-light">
                          <tr>
                            <th>STT</th>
                            <th>Sản phẩm</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Số lượng</th>
                            <th class="text-end">Thành tiền</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="detail" items="${details}" varStatus="status">
                            <tr>
                              <td>${status.index + 1}</td>
                              <td>${detail.tenSP}</td>
                              <td class="text-end">
                                <fmt:formatNumber value="${detail.donGia}" type="currency" currencySymbol="₫"/>
                              </td>
                              <td class="text-end">${detail.soLuong}</td>
                              <td class="text-end fw-bold">
                                <fmt:formatNumber value="${detail.thanhTien}" type="currency" currencySymbol="₫"/>
                              </td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <p class="text-muted text-center py-4">Không có sản phẩm nào</p>
                  </c:otherwise>
                </c:choose>

                <!-- Order Summary -->
                <div class="row mt-4">
                  <div class="col-md-6 offset-md-6">
                    <div class="card bg-light">
                      <div class="card-body">
                        <h6 class="card-title">Tổng cộng</h6>
                        <ul class="list-unstyled mb-0">
                          <li class="d-flex justify-content-between mb-2">
                            <span>Tổng sản phẩm:</span>
                            <fmt:formatNumber value="${order.tongTien}" type="currency" currencySymbol="₫"/>
                          </li>
                          <c:if test="${not empty order.phiVanChuyen && order.phiVanChuyen > 0}">
                            <li class="d-flex justify-content-between mb-2">
                              <span>Phí vận chuyển:</span>
                              <fmt:formatNumber value="${order.phiVanChuyen}" type="currency" currencySymbol="₫"/>
                            </li>
                          </c:if>
                          <li class="d-flex justify-content-between fw-bold fs-5 border-top pt-2 mt-2">
                            <span>Tổng thanh toán:</span>
                            <fmt:formatNumber value="${order.tongTien}" type="currency" currencySymbol="₫"/>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Status Update -->
          <div class="col-12 d-print-none">
            <div class="card shadow-sm">
              <div class="card-header bg-warning">
                <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Cập nhật trạng thái</h5>
              </div>
              <div class="card-body">
                <c:if test="${order.trangThaiDonHang != 'DA_GIAO' && order.trangThaiDonHang != 'DA_HUY'}">
                  <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="row g-3">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                    <div class="col-auto">
                      <select name="status" class="form-select">
                        <option value="">-- Chọn trạng thái --</option>
                        <c:if test="${order.trangThaiDonHang == 'CHO_XAC_NHAN'}">
                          <option value="DA_XAC_NHAN">Xác nhận đơn hàng</option>
                          <option value="DA_HUY">Hủy đơn hàng</option>
                        </c:if>
                        <c:if test="${order.trangThaiDonHang == 'DA_XAC_NHAN'}">
                          <option value="DANG_GIAO">Đang giao</option>
                          <option value="DA_HUY">Hủy đơn hàng</option>
                        </c:if>
                        <c:if test="${order.trangThaiDonHang == 'DANG_GIAO'}">
                          <option value="DA_GIAO">Đã giao</option>
                        </c:if>
                      </select>
                    </div>
                    <div class="col-auto">
                      <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-2"></i>Cập nhật
                      </button>
                    </div>
                  </form>
                </c:if>
                <c:if test="${order.trangThaiDonHang == 'DA_GIAO'}">
                  <div class="alert alert-success mb-0">
                    <i class="fas fa-check-circle me-2"></i>Đơn hàng đã được giao thành công.
                  </div>
                </c:if>
                <c:if test="${order.trangThaiDonHang == 'DA_HUY'}">
                  <div class="alert alert-danger mb-0">
                    <i class="fas fa-times-circle me-2"></i>Đơn hàng đã bị hủy.
                  </div>
                </c:if>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Print Footer Signature -->
        <div class="d-none d-print-block mt-5 pt-4">
          <div class="row text-center">
            <div class="col-6">
              <p class="fw-bold mb-5 pb-3">Khách hàng</p>
              <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
            </div>
            <div class="col-6">
              <p class="fw-bold mb-5 pb-3">Người bán hàng</p>
              <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- Print Custom CSS Styling -->
  <style>
    @media print {
      #accordionSidebar,
      .topbar,
      .sticky-footer,
      .scroll-to-top,
      .btn,
      .d-print-none {
        display: none !important;
      }
      
      body {
        background-color: #fff !important;
        color: #000 !important;
        font-family: 'Nunito', 'Roboto', 'Open Sans', Arial, sans-serif !important;
        font-size: 12px !important;
        line-height: 1.4 !important;
        margin: 0 !important;
        padding: 0 !important;
      }
      
      #content-wrapper {
        background-color: #fff !important;
      }
      
      .container-fluid, .print-container {
        width: 100% !important;
        max-width: 100% !important;
        padding: 0 !important;
        margin: 0 !important;
      }
      
      .card {
        border: 1px solid #ddd !important;
        border-radius: 4px !important;
        box-shadow: none !important;
        background: transparent !important;
        margin-bottom: 15px !important;
      }
      
      .card-header {
        background: #f8f9fc !important;
        border-bottom: 1px solid #e3e6f0 !important;
        color: #333 !important;
        padding: 8px 12px !important;
        font-weight: bold !important;
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
      
      .card-body {
        padding: 12px !important;
      }
      
      table {
        width: 100% !important;
        border-collapse: collapse !important;
      }
      
      th, td {
        border: 1px solid #ddd !important;
        padding: 6px 8px !important;
      }
      
      th {
        background-color: #f8f9fc !important;
        color: #333 !important;
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
      
      .text-end {
        text-align: right !important;
      }

      .text-success {
        color: #198754 !important;
      }

      .text-warning {
        color: #ffc107 !important;
      }
      
      /* Ensure flex grids print correctly */
      .row {
        display: flex !important;
        flex-wrap: wrap !important;
        margin-right: -10px !important;
        margin-left: -10px !important;
      }
      .col-md-6 {
        flex: 0 0 50% !important;
        max-width: 50% !important;
        padding-right: 10px !important;
        padding-left: 10px !important;
      }
      .col-12 {
        flex: 0 0 100% !important;
        max-width: 100% !important;
        padding-right: 10px !important;
        padding-left: 10px !important;
      }
      .col-md-6.offset-md-6 {
        margin-left: 50% !important;
        flex: 0 0 50% !important;
        max-width: 50% !important;
      }
    }
  </style>
</t:admin-layout>
