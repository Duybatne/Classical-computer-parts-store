<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Chi tiết đơn hàng" activePage="orders">
  <jsp:body>
    <div class="container py-5">
      <div class="bg-white rounded p-4 p-md-5 shadow-sm print-container">
        
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
              <h3 class="fw-bold text-dark mb-1">HÓA ĐƠN BÁN HÀNG</h3>
              <p class="mb-1 small"><strong>Mã đơn:</strong> #${order.maDonHang}</p>
              <p class="mb-0 small"><strong>Ngày đặt:</strong> ${order.ngayDat}</p>
            </div>
          </div>
          <hr class="border-secondary my-3">
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 d-print-none">
          <h1 class="display-6 mb-0">Chi tiết đơn hàng #${order.maDonHang}</h1>
          <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary">
            <i class="fa fa-arrow-left me-2"></i>Quay lại
          </a>
        </div>

        <c:if test="${param.cancel == 'success'}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            Đơn hàng đã được hủy thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <!-- Order Status -->
        <div class="mb-4">
          <span class="badge bg-${order.trangThaiDonHang == 'DA_GIAO' ? 'success' :
                                         order.trangThaiDonHang == 'DA_HUY' ? 'danger' :
                                         order.trangThaiDonHang == 'CHO_XAC_NHAN' ? 'warning' : 'info'} fs-6">
            ${order.trangThaiDonHang}
          </span>
        </div>

        <div class="row g-4">
          <!-- Order Info -->
          <div class="col-md-6">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">Thông tin đơn hàng</h5>
                <ul class="list-unstyled mb-0">
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
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">Thông tin thanh toán</h5>
                <ul class="list-unstyled mb-0">
                  <c:if test="${not empty payment}">
                    <li class="mb-2"><strong>Phương thức:</strong>
                      ${payment.maPTTT == 1 ? 'COD (Thanh toán khi nhận hàng)' :
                        payment.maPTTT == 2 ? 'Chuyển khoản ngân hàng' :
                        payment.maPTTT == 3 ? 'Ví điện tử' : 'Khác'}
                    </li>
                    <li class="mb-2"><strong>Trạng thái:</strong>
                      <span class="${payment.trangThaiThanhToan == 'DA_THANH_TOAN' ? 'text-success' : 'text-warning'}">
                        ${payment.trangThaiThanhToan}
                      </span>
                    </li>
                    <li class="mb-2"><strong>Số tiền:</strong>
                      <fmt:formatNumber value="${payment.soTien}" type="currency" currencySymbol="₫"/>
                    </li>
                  </c:if>
                  <c:if test="${empty payment}">
                    <li class="text-muted">Chưa có thông tin thanh toán</li>
                  </c:if>
                </ul>
              </div>
            </div>
          </div>

          <!-- Order Items -->
          <div class="col-12">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title mb-3">Sản phẩm đã đặt</h5>
                <c:choose>
                  <c:when test="${not empty orderDetails}">
                    <div class="table-responsive">
                      <table class="table table-hover align-middle">
                        <thead class="table-light">
                          <tr>
                            <th style="width: 8%">STT</th>
                            <th>Sản phẩm</th>
                            <th class="text-end" style="width: 18%">Đơn giá</th>
                            <th class="text-end" style="width: 12%">Số lượng</th>
                            <th class="text-end" style="width: 22%">Thành tiền</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="detail" items="${orderDetails}" varStatus="status">
                            <tr>
                              <td>${status.index + 1}</td>
                              <td><strong class="text-dark">${detail.tenSP}</strong></td>
                              <td class="text-end">
                                <fmt:formatNumber value="${detail.donGia}" type="currency" currencySymbol="₫"/>
                              </td>
                              <td class="text-end">${detail.soLuong}</td>
                              <td class="text-end fw-bold text-primary">
                                <fmt:formatNumber value="${detail.thanhTien}" type="currency" currencySymbol="₫"/>
                              </td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <p class="text-muted">Không có sản phẩm nào</p>
                  </c:otherwise>
                </c:choose>

                <!-- Order Summary -->
                <c:set var="subtotal" value="${order.tongTien - (order.phiVanChuyen != null ? order.phiVanChuyen : 0)}" />
                <div class="row mt-4">
                  <div class="col-md-6 offset-md-6">
                    <div class="card bg-light">
                      <div class="card-body">
                        <h6 class="card-title">Tổng cộng</h6>
                        <ul class="list-unstyled mb-0">
                          <li class="d-flex justify-content-between mb-2">
                            <span>Tạm tính:</span>
                            <fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫"/>
                          </li>
                          <c:if test="${order.phiVanChuyen != null && order.phiVanChuyen > 0}">
                            <li class="d-flex justify-content-between mb-2">
                              <span>Phí vận chuyển:</span>
                              <fmt:formatNumber value="${order.phiVanChuyen}" type="currency" currencySymbol="₫"/>
                            </li>
                          </c:if>
                          <c:if test="${order.phiVanChuyen == null || order.phiVanChuyen <= 0}">
                            <li class="d-flex justify-content-between mb-2">
                              <span>Phí vận chuyển:</span>
                              <span>Miễn phí</span>
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

          <!-- Actions -->
          <div class="col-12 d-print-none">
            <div class="d-flex justify-content-between">
              <c:if test="${order.trangThaiDonHang == 'CHO_XAC_NHAN'}">
                <form action="${pageContext.request.contextPath}/orders/cancel" method="post"
                      onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');">
                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                  <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                  <button type="submit" class="btn btn-danger">
                    <i class="fa fa-times me-2"></i>Hủy đơn hàng
                  </button>
                </form>
              </c:if>
              <c:if test="${order.trangThaiDonHang == 'DA_GIAO'}">
                <button class="btn btn-primary">
                  <i class="fa fa-rotate-left me-2"></i>Đánh giá sản phẩm
                </button>
              </c:if>
              <div>
                <button class="btn btn-outline-secondary" onclick="window.print()">
                  <i class="fa fa-print me-2"></i>In đơn hàng
                </button>
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
              <p class="fw-bold mb-5 pb-3">Người lập phiếu</p>
              <p class="text-muted small">(Ký và ghi rõ họ tên)</p>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Print Custom CSS Styling -->
    <style>
      @media print {
        .gearvn-topbar,
        .gearvn-header,
        .nav-bar,
        .gearvn-footer,
        #spinner,
        .back-to-top,
        .page-header,
        .btn,
        .alert,
        form,
        .d-print-none {
          display: none !important;
        }

        body {
          background-color: #fff !important;
          color: #000 !important;
          font-family: 'Roboto', 'Open Sans', Arial, sans-serif !important;
          font-size: 12px !important;
          line-height: 1.4 !important;
          margin: 0 !important;
          padding: 0 !important;
        }

        .container, .print-container {
          width: 100% !important;
          max-width: 100% !important;
          padding: 0 !important;
          margin: 0 !important;
          background: transparent !important;
          box-shadow: none !important;
          border: none !important;
        }

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

        .card {
          border: 1px solid #ddd !important;
          border-radius: 4px !important;
          box-shadow: none !important;
          background: transparent !important;
          margin-bottom: 15px !important;
        }

        .card-body {
          padding: 12px !important;
        }

        .card-title {
          font-size: 13px !important;
          font-weight: bold !important;
          border-bottom: 1px solid #ddd !important;
          padding-bottom: 6px !important;
          margin-bottom: 8px !important;
          color: #333 !important;
        }

        table {
          width: 100% !important;
          border-collapse: collapse !important;
          margin-bottom: 15px !important;
        }

        th, td {
          border: 1px solid #ddd !important;
          padding: 6px 8px !important;
          text-align: left !important;
        }

        th {
          background-color: #f5f5f5 !important;
          font-weight: bold !important;
          color: #000 !important;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }

        .text-end {
          text-align: right !important;
        }

        .text-success {
          color: #28a745 !important;
        }

        .text-warning {
          color: #ffc107 !important;
        }

        .text-primary {
          color: #0d6efd !important;
        }
        
        .badge {
          border: 1px solid #ccc !important;
          background: transparent !important;
          color: #000 !important;
          padding: 2px 6px !important;
          font-size: 11px !important;
        }
      }
    </style>
  </jsp:body>
</t:main>
