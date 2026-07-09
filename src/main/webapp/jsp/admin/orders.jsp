<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/common" %>

<t:admin-layout title="Quản lý đơn hàng" activePage="orders">
  <div class="container-fluid py-4">
    <div class="row">
      <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2><i class="fas fa-shopping-cart me-2"></i>Quản lý đơn hàng</h2>
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
          </a>
        </div>

        <c:choose>
          <c:when test="${not empty orders}">
            <div class="card shadow-sm">
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead class="table-light">
                      <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái</th>
                        <th>Tổng tiền</th>
                        <th>Phương thức TT</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="order" items="${orders}">
                        <tr>
                          <td><strong>#${order.maDonHang}</strong></td>
                          <td>${order.hoTenKhachHang}</td>
                          <td>${order.ngayDat}</td>
                          <td>
                            <span class="badge bg-${order.trangThaiDonHang == 'DA_GIAO' ? 'success' :
                                                       order.trangThaiDonHang == 'DA_HUY' ? 'danger' :
                                                       order.trangThaiDonHang == 'CHO_XAC_NHAN' ? 'warning' : 'info'}">
                              <c:choose>
                                <c:when test="${order.trangThaiDonHang == 'CHO_XAC_NHAN'}">Chờ xác nhận</c:when>
                                <c:when test="${order.trangThaiDonHang == 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                                <c:when test="${order.trangThaiDonHang == 'DANG_GIAO'}">Đang giao</c:when>
                                <c:when test="${order.trangThaiDonHang == 'DA_GIAO'}">Đã giao</c:when>
                                <c:when test="${order.trangThaiDonHang == 'DA_HUY'}">Đã hủy</c:when>
                                <c:otherwise>${order.trangThaiDonHang}</c:otherwise>
                              </c:choose>
                            </span>
                          </td>
                          <td>
                            <fmt:formatNumber value="${order.tongTien}" type="currency" currencySymbol="₫"/>
                          </td>
                          <td>
                            <c:set var="payment" value="${orderPayments[order.maDonHang]}"/>
                            <c:choose>
                              <c:when test="${not empty payment}">
                                ${payment.maPTTT == 1 ? 'COD' : payment.maPTTT == 2 ? 'Chuyển khoản' : payment.maPTTT == 3 ? 'Ví điện tử' : 'Khác'}
                              </c:when>
                              <c:otherwise>
                                <span class="text-muted">N/A</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <div class="btn-group" role="group">
                              <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.maDonHang}"
                                 class="btn btn-sm btn-primary" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                              </a>
                              <c:if test="${order.trangThaiDonHang == 'CHO_XAC_NHAN'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="action" value="updateStatus">
                                  <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                                  <input type="hidden" name="status" value="DA_XAC_NHAN">
                                  <button type="submit" class="btn btn-sm btn-success" title="Xác nhận"
                                          onclick="return confirm('Xác nhận đơn hàng #${order.maDonHang}?');">
                                    <i class="fas fa-check"></i>
                                  </button>
                                </form>
                              </c:if>
                              <c:if test="${order.trangThaiDonHang == 'DA_XAC_NHAN'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="action" value="updateStatus">
                                  <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                                  <input type="hidden" name="status" value="DANG_GIAO">
                                  <button type="submit" class="btn btn-sm btn-info" title="Đang giao"
                                          onclick="return confirm('Đánh dấu đơn #${order.maDonHang} đang giao?');">
                                    <i class="fas fa-truck"></i>
                                  </button>
                                </form>
                              </c:if>
                              <c:if test="${order.trangThaiDonHang == 'CHO_XAC_NHAN' || order.trangThaiDonHang == 'DA_XAC_NHAN'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="action" value="updateStatus">
                                  <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                                  <input type="hidden" name="status" value="DA_HUY">
                                  <button type="submit" class="btn btn-sm btn-danger" title="Hủy đơn"
                                          onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${order.maDonHang}?');">
                                    <i class="fas fa-times"></i>
                                  </button>
                                </form>
                              </c:if>
                              <c:if test="${order.trangThaiDonHang == 'DANG_GIAO'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="action" value="updateStatus">
                                  <input type="hidden" name="maDonHang" value="${order.maDonHang}">
                                  <input type="hidden" name="status" value="DA_GIAO">
                                  <button type="submit" class="btn btn-sm btn-success" title="Đã giao"
                                          onclick="return confirm('Xác nhận đã giao đơn #${order.maDonHang}?');">
                                    <i class="fas fa-check-circle"></i>
                                  </button>
                                </form>
                              </c:if>
                            </div>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="alert alert-info">
              <i class="fas fa-info-circle me-2"></i>Chưa có đơn hàng nào.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</t:admin-layout>
