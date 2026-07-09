<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/common" %>

<admin:admin-layout title="Dashboard" activePage="dashboard">
  <jsp:body>

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-tachometer-alt me-2 text-primary"></i>Dashboard
      </h1>
      <div>
        <select id="chartPeriod" class="form-control form-control-sm d-inline-block w-auto" style="min-width:140px;">
          <option value="7">7 ngày gần đây</option>
          <option value="30" selected>30 ngày gần đây</option>
          <option value="90">90 ngày gần đây</option>
          <option value="365">1 năm</option>
        </select>
      </div>
    </div>

    <c:if test="${not empty successMessage}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>${successMessage}
        <button type="button" class="close" data-dismiss="alert">&times;</button>
      </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
        <button type="button" class="close" data-dismiss="alert">&times;</button>
      </div>
    </c:if>

    <!-- ===== KPI CARDS ===== -->
    <h5 class="text-primary mb-3"><i class="fas fa-chart-line me-2"></i>Chỉ số tổng quan</h5>
    <div class="row">
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon blue"><i class="fas fa-shopping-cart"></i></div>
          <div class="stat-info">
            <div class="number" id="kpiTotalOrders">${totalOrders != null ? totalOrders : 0}</div>
            <div class="label">Tổng đơn hàng</div>
          </div>
        </div>
      </div>

      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon green"><i class="fas fa-dollar-sign"></i></div>
          <div class="stat-info">
            <div class="number" id="kpiRevenue">
              <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="₫" />
            </div>
            <div class="label">Doanh thu (đã giao)</div>
          </div>
        </div>
      </div>

      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon orange"><i class="fas fa-users"></i></div>
          <div class="stat-info">
            <div class="number" id="kpiCustomers">${totalCustomers != null ? totalCustomers : 0}</div>
            <div class="label">Tổng khách hàng</div>
          </div>
        </div>
      </div>

      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon red"><i class="fas fa-percentage"></i></div>
          <div class="stat-info">
            <div class="number" id="kpiCancelRate">0%</div>
            <div class="label">Tỷ lệ hủy đơn</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== CHARTS ROW 1: REVENUE + ORDERS ===== -->
    <div class="row mt-4">
      <div class="col-lg-8 mb-4">
        <div class="table-card">
          <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
            <h6 class="mb-0 text-primary"><i class="fas fa-chart-line me-2"></i>Doanh thu theo ngày</h6>
          </div>
          <div class="p-3" style="height:300px;">
            <canvas id="revenueChart"></canvas>
          </div>
        </div>
      </div>

      <div class="col-lg-4 mb-4">
        <div class="table-card">
          <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
            <h6 class="mb-0 text-primary"><i class="fas fa-chart-pie me-2"></i>Đơn hàng theo trạng thái</h6>
          </div>
          <div class="p-3" style="height:300px;">
            <canvas id="ordersChart"></canvas>
          </div>
          <div class="px-3 pb-3" id="ordersSummary" style="font-size:12px; color:#6b7280;"></div>
        </div>
      </div>
    </div>

    <!-- ===== CHARTS ROW 2: TOP PRODUCTS + CATEGORY ===== -->
    <div class="row">
      <div class="col-lg-8 mb-4">
        <div class="table-card">
          <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
            <h6 class="mb-0 text-primary"><i class="fas fa-trophy me-2"></i>Top 5 sản phẩm bán chạy</h6>
          </div>
          <div class="p-3" style="height:300px;">
            <canvas id="topProductsChart"></canvas>
          </div>
        </div>
      </div>

      <div class="col-lg-4 mb-4">
        <div class="table-card">
          <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
            <h6 class="mb-0 text-primary"><i class="fas fa-layer-group me-2"></i>Doanh thu theo danh mục</h6>
          </div>
          <div class="p-3" style="height:300px;">
            <canvas id="categoryChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Recent Orders + Quick Links ===== -->
    <div class="row mt-3">
      <div class="col-lg-8 mb-4">
        <div class="table-card">
          <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
            <h6 class="mb-0 text-primary"><i class="fas fa-clock me-2"></i>Đơn hàng gần đây</h6>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
          </div>
          <div class="table-responsive">
            <table class="table table-hover" width="100" cellspacing="0">
              <thead>
                <tr>
                  <th style="width:90px">Mã ĐH</th>
                  <th>Khách hàng</th>
                  <th style="width:140px">Trạng thái</th>
                  <th style="width:130px">Tổng tiền</th>
                  <th>Địa chỉ</th>
                  <th style="width:100px">Ngày đặt</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty recentOrders}">
                    <c:forEach var="o" items="${recentOrders}">
                      <tr>
                        <td class="text-muted fw-bold">#${o.maDonHang}</td>
                        <td>${o.hoTenKhachHang}</td>
                        <td>
                          <span class="badge-status
                            ${o.trangThaiDonHang == 'DA_GIAO' ? 'badge-active' :
                              o.trangThaiDonHang == 'DA_HUY' ? 'badge-inactive' :
                              o.trangThaiDonHang == 'CHO_XAC_NHAN' ? 'badge-low' : 'badge-info'}">
                            ${o.trangThaiDonHang}
                          </span>
                        </td>
                        <td class="text-danger fw-bold">
                          <fmt:formatNumber value="${o.tongTien}" type="currency" currencySymbol="₫"/>
                        </td>
                        <td style="max-width:150px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${o.diaChiNhan}</td>
                        <td class="text-muted small">
                          <fmt:formatDate value="${o.ngayDat}" pattern="dd/MM/yyyy" />
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="6" class="text-center py-5 text-muted">
                        <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                        Chưa có dữ liệu đơn hàng
                      </td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="col-lg-4 mb-4">
        <div class="filter-bar">
          <h5 class="text-primary mb-3"><i class="fas fa-link me-2"></i>Quick Links</h5>
          <div class="list-group">
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/reports">
              <i class="fas fa-chart-bar me-2 text-purple" style="color: #6f42c1;"></i>Báo cáo & Thống kê
            </a>
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/orders">
              <i class="fas fa-truck me-2 text-danger"></i>Quản lý đơn hàng
            </a>
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/products">
              <i class="fas fa-box me-2 text-primary"></i>Quản lý sản phẩm
            </a>
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/promotions">
              <i class="fas fa-tags me-2 text-success"></i>Quản lý khuyến mãi
            </a>
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/reviews">
              <i class="fas fa-comments me-2 text-warning"></i>Quản lý đánh giá
            </a>
            <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/admin/accounts">
              <i class="fas fa-users me-2 text-info"></i>Quản lý tài khoản
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Load Chart.js and admin-charts.js -->
    <script src="${pageContext.request.contextPath}/admin-asset/vendor/chart.js/Chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin-asset/js/admin-charts.js"></script>

    <style>
      .stat-card {
        background: #fff;
        border-radius: 10px;
        padding: 18px 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        display: flex;
        align-items: center;
        gap: 14px;
      }
      .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: #fff;
        flex-shrink: 0;
      }
      .stat-icon.red { background: #e83e2d; }
      .stat-icon.green { background: #28a745; }
      .stat-icon.orange { background: #fd7e14; }
      .stat-icon.blue { background: #007bff; }
      .stat-info .number { font-size: 22px; font-weight: 700; color: #1a1a2e; }
      .stat-info .label { font-size: 12px; color: #6b7280; }

      .filter-bar {
        background: #fff;
        border-radius: 10px;
        padding: 16px 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      }

      .table-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        overflow: hidden;
      }

      .table thead th {
        background: #1a1a2e;
        color: #fff;
        font-size: 13px;
        font-weight: 600;
        border: none;
        white-space: nowrap;
        padding: 12px 14px;
      }
      .table tbody td {
        vertical-align: middle;
        font-size: 13px;
        padding: 10px 14px;
        border-color: #f0f0f0;
      }

      .badge-status {
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
        white-space: nowrap;
      }
      .badge-active   { background: #d1fae5; color: #065f46; }
      .badge-inactive { background: #fee2e2; color: #991b1b; }
      .badge-low      { background: #fef3c7; color: #92400e; }
      .badge-info     { background: #dbeafe; color: #1d4ed8; }

      .list-group-item {
        border: none;
        border-radius: 8px !important;
        margin-bottom: 4px;
        padding: 10px 14px;
        font-size: 14px;
        transition: all 0.2s;
      }
      .list-group-item:hover {
        background: #f0f4ff;
        transform: translateX(4px);
      }
    </style>

  </jsp:body>
</admin:admin-layout>
