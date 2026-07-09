<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/common" %>

<admin:admin-layout title="Báo cáo & Thống kê" activePage="reports">
  <jsp:body>

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-chart-bar me-2 text-primary"></i>Báo cáo & Thống kê
      </h1>
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

    <!-- ===== BỘ LỌC THỜI GIAN DÙNG CHUNG ===== -->
    <div class="card shadow-sm mb-4 border-0 bg-white">
      <div class="card-body py-3">
        <div class="row align-items-end g-3">
          <div class="col-md-3">
            <label class="form-label small fw-bold text-muted mb-1">Khoảng thời gian</label>
            <select id="commonDays" class="form-select form-select-sm" onchange="toggleCustomDates()">
              <option value="7" ${days == 7 && empty param.startDate ? 'selected' : ''}>7 ngày</option>
              <option value="30" ${days == 30 && empty param.startDate ? 'selected' : ''}>30 ngày</option>
              <option value="90" ${days == 90 && empty param.startDate ? 'selected' : ''}>90 ngày</option>
              <option value="365" ${days == 365 && empty param.startDate ? 'selected' : ''}>1 năm</option>
              <option value="custom" ${not empty param.startDate || (days != 7 && days != 30 && days != 90 && days != 365) ? 'selected' : ''}>Tùy chỉnh...</option>
            </select>
          </div>
          <div class="col-md-3 custom-date-inputs" style="display: ${not empty param.startDate || (days != 7 && days != 30 && days != 90 && days != 365) ? 'block' : 'none'};">
            <label class="form-label small fw-bold text-muted mb-1">Từ ngày</label>
            <input type="date" id="commonStartDate" class="form-control form-control-sm" value="${startDate}">
          </div>
          <div class="col-md-3 custom-date-inputs" style="display: ${not empty param.startDate || (days != 7 && days != 30 && days != 90 && days != 365) ? 'block' : 'none'};">
            <label class="form-label small fw-bold text-muted mb-1">Đến ngày</label>
            <input type="date" id="commonEndDate" class="form-control form-control-sm" value="${endDate}">
          </div>
          <div class="col-md-3 custom-date-inputs" style="display: ${not empty param.startDate || (days != 7 && days != 30 && days != 90 && days != 365) ? 'block' : 'none'};">
            <button class="btn btn-primary btn-sm w-100" onclick="applyFilters()">
              <i class="fas fa-filter me-1"></i>Áp dụng
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== TABS ===== -->
    <ul class="nav nav-tabs mb-4" id="reportTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'overview' ? 'active' : ''}" id="tab-overview" onclick="reloadTab('overview')" type="button" role="tab">
          <i class="fas fa-tachometer-alt me-1"></i>Tổng quan
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'revenue' ? 'active' : ''}" id="tab-revenue" onclick="reloadTab('revenue')" type="button" role="tab">
          <i class="fas fa-dollar-sign me-1"></i>Doanh thu
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'products' ? 'active' : ''}" id="tab-products" onclick="reloadTab('products')" type="button" role="tab">
          <i class="fas fa-boxes me-1"></i>Sản phẩm
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'customers' ? 'active' : ''}" id="tab-customers" onclick="reloadTab('customers')" type="button" role="tab">
          <i class="fas fa-users me-1"></i>Khách hàng
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'orders' ? 'active' : ''}" id="tab-orders" onclick="reloadTab('orders')" type="button" role="tab">
          <i class="fas fa-shopping-cart me-1"></i>Đơn hàng
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'promotions' ? 'active' : ''}" id="tab-promotions" onclick="reloadTab('promotions')" type="button" role="tab">
          <i class="fas fa-tags me-1"></i>Khuyến mãi
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link ${activeTab == 'payments' ? 'active' : ''}" id="tab-payments" onclick="reloadTab('payments')" type="button" role="tab">
          <i class="fas fa-credit-card me-1"></i>Thanh toán
        </button>
      </li>
    </ul>

    <!-- ===== TAB CONTENT ===== -->
    <div class="tab-content" id="reportTabContent">

      <!-- TAB: TỔNG QUAN -->
      <div class="tab-pane fade ${activeTab == 'overview' ? 'show active' : ''}" id="panel-overview" role="tabpanel">
        <div class="row mb-4 justify-content-end">
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=overview&days=${days}&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export/pdf?tab=overview&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-danger w-100 btn-sm">
              <i class="fas fa-file-pdf me-1"></i>Xuất PDF
            </a>
          </div>
        </div>

        <!-- KPI Cards -->
        <c:if test="${not empty kpi}">
          <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-info">
                  <div class="number">${kpi.tongDon}</div>
                  <div class="label">Tổng đơn hàng</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                  <div class="number">${kpi.daGiao}</div>
                  <div class="label">Đã giao</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon red"><i class="fas fa-times-circle"></i></div>
                <div class="stat-info">
                  <div class="number">${kpi.daHuy}</div>
                  <div class="label">Đã hủy</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-clock"></i></div>
                <div class="stat-info">
                  <div class="number">${kpi.choXuLy}</div>
                  <div class="label">Chờ xử lý</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-dollar-sign"></i></div>
                <div class="stat-info">
                  <div class="number"><fmt:formatNumber value="${kpi.doanhThu}" type="currency" currencySymbol="₫" /></div>
                  <div class="label">Doanh thu</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-chart-line"></i></div>
                <div class="stat-info">
                  <div class="number"><fmt:formatNumber value="${kpi.aov}" type="currency" currencySymbol="₫" /></div>
                  <div class="label">AOV</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon red"><i class="fas fa-percentage"></i></div>
                <div class="stat-info">
                  <div class="number"><fmt:formatNumber value="${kpi.tyLeHuy}" pattern="#0.0"/>%</div>
                  <div class="label">Tỷ lệ hủy</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
              <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-users"></i></div>
                <div class="stat-info">
                  <div class="number">${fn:length(topCustomers)}</div>
                  <div class="label">Top khách</div>
                </div>
              </div>
            </div>
          </div>
        </c:if>

        <!-- Charts Row -->
        <div class="row">
          <div class="col-lg-8 mb-4">
            <div class="table-card">
              <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                <h6 class="mb-0 text-primary"><i class="fas fa-chart-line me-2"></i>Doanh thu theo ngày</h6>
              </div>
              <div class="p-3" style="height:300px;"><canvas id="overviewRevenueChart"></canvas></div>
            </div>
          </div>
          <div class="col-lg-4 mb-4">
            <div class="table-card">
              <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                <h6 class="mb-0 text-primary"><i class="fas fa-chart-pie me-2"></i>Đơn hàng theo trạng thái</h6>
              </div>
              <div class="p-3" style="height:300px;"><canvas id="overviewOrdersChart"></canvas></div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-lg-8 mb-4">
            <div class="table-card">
              <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                <h6 class="mb-0 text-primary"><i class="fas fa-trophy me-2"></i>Top 5 sản phẩm</h6>
              </div>
              <div class="p-3" style="height:300px;"><canvas id="overviewTopProductsChart"></canvas></div>
            </div>
          </div>
          <div class="col-lg-4 mb-4">
            <div class="table-card">
              <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                <h6 class="mb-0 text-primary"><i class="fas fa-layer-group me-2"></i>Doanh thu theo danh mục</h6>
              </div>
              <div class="p-3" style="height:300px;"><canvas id="overviewCategoryChart"></canvas></div>
            </div>
          </div>
        </div>
      </div>

      <!-- TAB: DOANH THU CHI TIẾT -->
      <div class="tab-pane fade ${activeTab == 'revenue' ? 'show active' : ''}" id="panel-revenue" role="tabpanel">
        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label small fw-bold text-muted">Danh mục</label>
            <select id="revenueCategory" class="form-select form-select-sm" onchange="reloadTab('revenue')">
              <option value="">Tất cả</option>
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.maLoaiSP}" ${categoryId == cat.maLoaiSP ? 'selected' : ''}>${cat.tenLoaiSP}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label small fw-bold text-muted">Nhân viên</label>
            <select id="revenueStaff" class="form-select form-select-sm" onchange="reloadTab('revenue')">
              <option value="">Tất cả</option>
              <c:forEach var="staff" items="${staffList}">
                <option value="${staff.maNV}" ${staffId == staff.maNV ? 'selected' : ''}>${staff.hoTen}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label small fw-bold text-muted">Số dòng/trang</label>
            <select id="revenuePageSize" class="form-select form-select-sm" onchange="reloadTab('revenue')">
              <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
              <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
              <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=revenue&days=${days}&startDate=${startDate}&endDate=${endDate}&categoryId=${categoryId}&staffId=${staffId}&pageSize=10000" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export/pdf?tab=revenue&startDate=${startDate}&endDate=${endDate}&categoryId=${categoryId}&staffId=${staffId}" class="btn btn-outline-danger w-100 btn-sm">
              <i class="fas fa-file-pdf me-1"></i>Xuất PDF
            </a>
          </div>
        </div>

        <div class="table-card">
          <div class="table-responsive">
            <table class="table table-hover" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th style="width:80px">Mã ĐH</th>
                  <th style="width:150px">Ngày đặt</th>
                  <th>Khách hàng</th>
                  <th>Nhân viên</th>
                  <th style="width:140px">Tổng tiền</th>
                  <th style="width:120px">Trạng thái</th>
                  <th>Sản phẩm</th>
                  <th style="width:140px">Thanh toán</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty revenueDetails}">
                    <c:forEach var="r" items="${revenueDetails}">
                      <tr>
                        <td class="text-muted fw-bold">#${r.maDonHang}</td>
                        <td class="small"><fmt:formatDate value="${r.ngayDat}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>${r.khachHang}</td>
                        <td>${r.nhanVien}</td>
                        <td class="text-danger fw-bold"><fmt:formatNumber value="${r.tongTien}" type="currency" currencySymbol="₫" /></td>
                        <td><span class="badge-status badge-active">${r.trangThai}</span></td>
                        <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${r.sanPham}</td>
                        <td>${r.phuongThuc}</td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="8" class="text-center py-5 text-muted">Không có dữ liệu</td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

          <c:if test="${totalPages > 1}">
            <nav aria-label="Pagination" class="px-3 py-2">
              <ul class="pagination pagination-sm justify-content-center mb-0">
                <li class="page-item ${page == 0 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('revenue', ${page - 1}); return false;">&laquo;</a>
                </li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                  <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="goToPage('revenue', ${i}); return false;">${i + 1}</a>
                  </li>
                </c:forEach>
                <li class="page-item ${page == totalPages - 1 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('revenue', ${page + 1}); return false;">&raquo;</a>
                </li>
              </ul>
            </nav>
          </c:if>
        </div>
      </div>

      <!-- TAB: SẢN PHẨM & TỒN KHO -->
      <div class="tab-pane fade ${activeTab == 'products' ? 'show active' : ''}" id="panel-products" role="tabpanel">
        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label small">Lọc tồn kho</label>
            <select id="stockFilter" class="form-select form-select-sm" onchange="reloadTab('products')">
              <option value="all" ${stockFilter == 'all' ? 'selected' : ''}>Tất cả</option>
              <option value="low" ${stockFilter == 'low' ? 'selected' : ''}>Sắp hết (≤10)</option>
              <option value="out" ${stockFilter == 'out' ? 'selected' : ''}>Hết hàng</option>
              <option value="slow" ${stockFilter == 'slow' ? 'selected' : ''}>Chậm bán (30 ngày)</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label small">Số dòng/trang</label>
            <select id="productsPageSize" class="form-select form-select-sm" onchange="reloadTab('products')">
              <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
              <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
              <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=products&stockFilter=${stockFilter}&pageSize=10000" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export/pdf?tab=inventory&startDate=${startDate}&endDate=${endDate}&stockFilter=${stockFilter}" class="btn btn-outline-danger w-100 btn-sm">
              <i class="fas fa-file-pdf me-1"></i>Xuất PDF
            </a>
          </div>
        </div>

        <div class="table-card">
          <div class="table-responsive">
            <table class="table table-hover" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th style="width:70px">Mã SP</th>
                  <th>Tên sản phẩm</th>
                  <th style="width:150px">Danh mục</th>
                  <th style="width:130px">Giá bán</th>
                  <th style="width:80px">Tồn kho</th>
                  <th style="width:100px">Bán 30 ngày</th>
                  <th style="width:150px">Lần bán cuối</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty stockReport}">
                    <c:forEach var="p" items="${stockReport}">
                      <tr>
                        <td class="text-muted fw-bold">#${p.maSP}</td>
                        <td>${p.tenSP}</td>
                        <td>${p.tenLoai}</td>
                        <td class="text-danger"><fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫" /></td>
                        <td>
                          <c:choose>
                            <c:when test="${p.soLuongTon == 0}"><span class="badge bg-danger">${p.soLuongTon}</span></c:when>
                            <c:when test="${p.soLuongTon <= 10}"><span class="badge bg-warning text-dark">${p.soLuongTon}</span></c:when>
                            <c:otherwise><span class="badge bg-success">${p.soLuongTon}</span></c:otherwise>
                          </c:choose>
                        </td>
                        <td>${p.ban30Ngay}</td>
                        <td class="small text-muted">
                          <c:choose>
                            <c:when test="${p.lanBanCuoi != null}"><fmt:formatDate value="${p.lanBanCuoi}" pattern="dd/MM/yyyy" /></c:when>
                            <c:otherwise>Chưa bán</c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="7" class="text-center py-5 text-muted">Không có dữ liệu</td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

          <c:if test="${totalPages > 1}">
            <nav aria-label="Pagination" class="px-3 py-2">
              <ul class="pagination pagination-sm justify-content-center mb-0">
                <li class="page-item ${page == 0 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('products', ${page - 1}); return false;">&laquo;</a>
                </li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                  <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="goToPage('products', ${i}); return false;">${i + 1}</a>
                  </li>
                </c:forEach>
                <li class="page-item ${page == totalPages - 1 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('products', ${page + 1}); return false;">&raquo;</a>
                </li>
              </ul>
            </nav>
          </c:if>
        </div>
      </div>

      <!-- TAB: KHÁCH HÀNG -->
      <div class="tab-pane fade ${activeTab == 'customers' ? 'show active' : ''}" id="panel-customers" role="tabpanel">
        <div class="row mb-3 justify-content-end">
          <div class="col-md-2 me-auto">
            <label class="form-label small fw-bold text-muted">Số dòng/trang</label>
            <select id="customerPageSize" class="form-select form-select-sm" onchange="reloadTab('customers')">
              <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
              <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
              <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=customers&days=${days}&startDate=${startDate}&endDate=${endDate}&pageSize=10000" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
          <div class="col-md-2">
            <label class="form-label small">&nbsp;</label>
            <a href="${pageContext.request.contextPath}/admin/reports/export/pdf?tab=customers&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-danger w-100 btn-sm">
              <i class="fas fa-file-pdf me-1"></i>Xuất PDF
            </a>
          </div>
        </div>

        <div class="table-card">
          <div class="table-responsive">
            <table class="table table-hover" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th style="width:70px">Mã KH</th>
                  <th>Họ tên</th>
                  <th style="width:200px">Email</th>
                  <th style="width:120px">SĐT</th>
                  <th style="width:80px">Tổng đơn</th>
                  <th style="width:140px">Tổng tiền</th>
                  <th style="width:120px">Đơn đầu</th>
                  <th style="width:120px">Đơn cuối</th>
                  <th style="width:80px">Đã hủy</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty customerReport}">
                    <c:forEach var="c" items="${customerReport}">
                      <tr>
                        <td class="text-muted fw-bold">#${c.maKH}</td>
                        <td>${c.hoTen}</td>
                        <td>${c.email}</td>
                        <td>${c.sdt}</td>
                        <td>${c.tongDon}</td>
                        <td class="text-danger fw-bold"><fmt:formatNumber value="${c.tongTien}" type="currency" currencySymbol="₫" /></td>
                        <td class="small"><fmt:formatDate value="${c.donDau}" pattern="dd/MM/yyyy" /></td>
                        <td class="small"><fmt:formatDate value="${c.donCuoi}" pattern="dd/MM/yyyy" /></td>
                        <td><span class="badge ${c.soDonHuy > 0 ? 'bg-danger' : 'bg-success'}">${c.soDonHuy}</span></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="9" class="text-center py-5 text-muted">Không có dữ liệu</td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

          <c:if test="${totalPages > 1}">
            <nav aria-label="Pagination" class="px-3 py-2">
              <ul class="pagination pagination-sm justify-content-center mb-0">
                <li class="page-item ${page == 0 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('customers', ${page - 1}); return false;">&laquo;</a>
                </li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                  <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="goToPage('customers', ${i}); return false;">${i + 1}</a>
                  </li>
                </c:forEach>
                <li class="page-item ${page == totalPages - 1 ? 'disabled' : ''}">
                  <a class="page-link" href="#" onclick="goToPage('customers', ${page + 1}); return false;">&raquo;</a>
                </li>
              </ul>
            </nav>
          </c:if>
        </div>
      </div>

      <!-- TAB: ĐƠN HÀNG -->
      <div class="tab-pane fade ${activeTab == 'orders' ? 'show active' : ''}" id="panel-orders" role="tabpanel">
        <div class="row mb-3 justify-content-end">
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=orders&days=${days}&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
        </div>

        <c:if test="${not empty orderAnalysis}">
          <div class="row mb-4">
            <div class="col-lg-8 mb-4">
              <div class="table-card">
                <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                  <h6 class="mb-0 text-primary"><i class="fas fa-clock me-2"></i>Đơn hàng theo giờ trong ngày</h6>
                </div>
                <div class="p-3" style="height:300px;"><canvas id="orderHourChart"></canvas></div>
              </div>
            </div>
            <div class="col-lg-4 mb-4">
              <div class="table-card">
                <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                  <h6 class="mb-0 text-primary"><i class="fas fa-exclamation-triangle me-2"></i>Top lý do hủy</h6>
                </div>
                <div class="p-3" style="height:300px;">
                  <c:choose>
                    <c:when test="${not empty orderAnalysis.cancelReasons}">
                      <ul class="list-group list-group-flush">
                        <c:forEach var="cr" items="${orderAnalysis.cancelReasons}">
                          <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                            <span>${cr.lyDo}</span>
                            <span class="badge bg-danger rounded-pill">${cr.soLuong}</span>
                          </li>
                        </c:forEach>
                      </ul>
                    </c:when>
                    <c:otherwise>
                      <div class="text-center text-muted py-5">Không có dữ liệu hủy đơn</div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </c:if>
      </div>

      <!-- TAB: KHUYẾN MÃI -->
      <div class="tab-pane fade ${activeTab == 'promotions' ? 'show active' : ''}" id="panel-promotions" role="tabpanel">
        <div class="row mb-3 justify-content-end">
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=promotions&days=${days}&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export/pdf?tab=promotions&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-danger w-100 btn-sm">
              <i class="fas fa-file-pdf me-1"></i>Xuất PDF
            </a>
          </div>
        </div>

        <div class="table-card">
          <div class="table-responsive">
            <table class="table table-hover" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th style="width:70px">Mã KM</th>
                  <th>Tên khuyến mãi</th>
                  <th style="width:100px">Loại giảm</th>
                  <th style="width:120px">Giá trị giảm</th>
                  <th style="width:120px">Ngày bắt đầu</th>
                  <th style="width:120px">Ngày kết thúc</th>
                  <th style="width:80px">Trạng thái</th>
                  <th style="width:100px">Số đơn dùng</th>
                  <th style="width:150px">Tổng giá trị đơn</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty promotionReport}">
                    <c:forEach var="p" items="${promotionReport}">
                      <tr>
                        <td class="text-muted fw-bold">#${p.maKM}</td>
                        <td>${p.tenKM}</td>
                        <td>${p.loaiGiam}</td>
                        <td>
                          <c:choose>
                            <c:when test="${p.loaiGiam == 'PHAN_TRAM'}">${p.giaTriGiam}%</c:when>
                            <c:otherwise><fmt:formatNumber value="${p.giaTriGiam}" type="currency" currencySymbol="₫" /></c:otherwise>
                          </c:choose>
                        </td>
                        <td class="small"><fmt:formatDate value="${p.ngayBatDau}" pattern="dd/MM/yyyy" /></td>
                        <td class="small"><fmt:formatDate value="${p.ngayKetThuc}" pattern="dd/MM/yyyy" /></td>
                        <td>
                          <c:choose>
                            <c:when test="${p.trangThai == 1}"><span class="badge bg-success">Đang chạy</span></c:when>
                            <c:when test="${p.trangThai == 2}"><span class="badge bg-secondary">Hết hạn</span></c:when>
                            <c:otherwise><span class="badge bg-warning text-dark">Chờ chạy</span></c:otherwise>
                          </c:choose>
                        </td>
                        <td>${p.soDonSuDung}</td>
                        <td class="text-danger"><fmt:formatNumber value="${p.tongGiaTriDon}" type="currency" currencySymbol="₫" /></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="9" class="text-center py-5 text-muted">Không có dữ liệu</td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- TAB: THANH TOÁN -->
      <div class="tab-pane fade ${activeTab == 'payments' ? 'show active' : ''}" id="panel-payments" role="tabpanel">
        <div class="row mb-3 justify-content-end">
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/reports/export?tab=payments&days=${days}&startDate=${startDate}&endDate=${endDate}" class="btn btn-outline-success w-100 btn-sm">
              <i class="fas fa-file-excel me-1"></i>Xuất Excel
            </a>
          </div>
        </div>

        <div class="row">
          <div class="col-lg-6 mb-4">
            <div class="table-card">
              <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
                <h6 class="mb-0 text-primary"><i class="fas fa-chart-pie me-2"></i>Phương thức thanh toán</h6>
              </div>
              <div class="p-3" style="height:300px;"><canvas id="paymentMethodChart"></canvas></div>
            </div>
          </div>
          <div class="col-lg-6 mb-4">
            <div class="table-card">
              <div class="table-responsive">
                <table class="table table-hover" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>Phương thức</th>
                      <th style="width:100px">Số lượng</th>
                      <th style="width:150px">Tổng tiền</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:choose>
                      <c:when test="${not empty paymentMethods}">
                        <c:forEach var="pm" items="${paymentMethods}">
                          <tr>
                            <td>${pm.tenPTTT}</td>
                            <td>${pm.soLuong}</td>
                            <td class="text-danger"><fmt:formatNumber value="${pm.tongTien}" type="currency" currencySymbol="₫" /></td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr><td colspan="3" class="text-center py-5 text-muted">Không có dữ liệu</td></tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- Load Chart.js and admin-charts.js -->
    <script src="${pageContext.request.contextPath}/admin-asset/vendor/chart.js/Chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin-asset/js/admin-charts.js"></script>

    <script>
      // Initialize overview charts (reuse AdminCharts)
      document.addEventListener('DOMContentLoaded', function() {
        if (document.getElementById('overviewRevenueChart')) {
          const queryParams = `days=${days}&startDate=${startDate}&endDate=${endDate}`;

          // Revenue chart
          fetch('${pageContext.request.contextPath}/admin/api/stats/revenue?' + queryParams).then(r => r.json()).then(data => {
            const ctx = document.getElementById('overviewRevenueChart');
            new Chart(ctx, {
              type: 'line',
              data: {
                labels: Object.keys(data),
                datasets: [{
                  label: 'Doanh thu (VNĐ)',
                  data: Object.values(data).map(v => parseFloat(v)),
                  borderColor: '#4e73df',
                  backgroundColor: 'rgba(78, 115, 223, 0.05)',
                  lineTension: 0.3
                }]
              },
              options: { maintainAspectRatio: false, plugins: { legend: { display: false } } }
            });
          });

          // Orders chart
          fetch('${pageContext.request.contextPath}/admin/api/stats/orders?' + queryParams).then(r => r.json()).then(data => {
            const ctx = document.getElementById('overviewOrdersChart');
            new Chart(ctx, {
              type: 'doughnut',
              data: {
                labels: Object.keys(data),
                datasets: [{
                  data: Object.values(data),
                  backgroundColor: ['#f6c23e', '#36b9cc', '#4e73df', '#1cc88a', '#e74a3b']
                }]
              },
              options: { maintainAspectRatio: false, cutoutPercentage: 65 }
            });
          });

          // Top products
          fetch('${pageContext.request.contextPath}/admin/api/stats/top-products?limit=5&' + queryParams).then(r => r.json()).then(data => {
            const ctx = document.getElementById('overviewTopProductsChart');
            new Chart(ctx, {
              type: 'horizontalBar',
              data: {
                labels: data.map(d => d.tenSP).reverse(),
                datasets: [{
                  label: 'Số lượng bán',
                  data: data.map(d => d.soLuongBan).reverse(),
                  backgroundColor: 'rgba(28, 200, 138, 0.8)',
                  borderColor: '#1cc88a'
                }]
              },
              options: { maintainAspectRatio: false, indexAxis: 'y' }
            });
          });

          // Category
          fetch('${pageContext.request.contextPath}/admin/api/stats/category-revenue?' + queryParams).then(r => r.json()).then(data => {
            const ctx = document.getElementById('overviewCategoryChart');
            new Chart(ctx, {
              type: 'pie',
              data: {
                labels: data.map(d => d.tenLoai),
                datasets: [{
                  data: data.map(d => parseFloat(d.doanhThu)),
                  backgroundColor: ['#4e73df','#1cc88a','#e74a3b','#f6c23e','#36b9cc']
                }]
              },
              options: { maintainAspectRatio: false }
            });
          });
        }

        // Order hour chart
        if (document.getElementById('orderHourChart')) {
          const hourData = {
            <c:forEach var="entry" items="${orderAnalysis.byHour}" varStatus="status">
              "${entry.key}": ${entry.value}${not status.last ? ',' : ''}
            </c:forEach>
          };

          const labels = Array.from({length: 24}, (_, i) => i + 'h');
          const dataset = Array.from({length: 24}, (_, i) => hourData[i] || 0);

          const ctx = document.getElementById('orderHourChart');
          new Chart(ctx, {
            type: 'bar',
            data: {
              labels: labels,
              datasets: [{
                label: 'Số lượng đơn',
                data: dataset,
                backgroundColor: '#4e73df',
                borderColor: '#4e73df',
                borderWidth: 1
              }]
            },
            options: {
              maintainAspectRatio: false,
              legend: { display: false },
              scales: {
                yAxes: [{
                  ticks: {
                    beginAtZero: true,
                    precision: 0
                  }
                }]
              }
            }
          });
        }


        // Payment method chart
        if (document.getElementById('paymentMethodChart')) {
          const queryParams = `days=${days}&startDate=${startDate}&endDate=${endDate}`;
          fetch('${pageContext.request.contextPath}/admin/api/stats/payment-methods?' + queryParams).then(r => r.json()).then(data => {
            const ctx = document.getElementById('paymentMethodChart');
            new Chart(ctx, {
              type: 'doughnut',
              data: {
                labels: data.map(d => d.tenPTTT),
                datasets: [{
                  data: data.map(d => d.soLuong),
                  backgroundColor: ['#4e73df','#1cc88a','#e74a3b','#f6c23e','#36b9cc']
                }]
              },
              options: { maintainAspectRatio: false, cutoutPercentage: 65 }
            });
          });
        }
      });

      function toggleCustomDates() {
        const select = document.getElementById('commonDays');
        const customInputs = document.querySelectorAll('.custom-date-inputs');
        if (select.value === 'custom') {
          customInputs.forEach(el => el.style.display = 'block');
        } else {
          customInputs.forEach(el => el.style.display = 'none');
          applyFilters();
        }
      }

      function applyFilters() {
        const tab = new URL(window.location.href).searchParams.get('tab') || 'overview';
        reloadTab(tab);
      }

      function reloadTab(tab) {
        const url = new URL(window.location.href);
        url.searchParams.set('tab', tab);

        const commonDays = document.getElementById('commonDays').value;
        if (commonDays === 'custom') {
          const startVal = document.getElementById('commonStartDate').value;
          const endVal = document.getElementById('commonEndDate').value;
          if (startVal && endVal) {
            url.searchParams.set('startDate', startVal);
            url.searchParams.set('endDate', endVal);
            url.searchParams.delete('days');
          } else {
            alert('Vui lòng chọn đầy đủ Từ ngày và Đến ngày.');
            return;
          }
        } else {
          url.searchParams.set('days', commonDays);
          url.searchParams.delete('startDate');
          url.searchParams.delete('endDate');
        }

        if (tab === 'revenue') {
          url.searchParams.set('categoryId', document.getElementById('revenueCategory').value);
          url.searchParams.set('staffId', document.getElementById('revenueStaff').value);
          url.searchParams.set('pageSize', document.getElementById('revenuePageSize').value);
        } else if (tab === 'products') {
          url.searchParams.set('stockFilter', document.getElementById('stockFilter').value);
          url.searchParams.set('pageSize', document.getElementById('productsPageSize').value);
        } else if (tab === 'customers') {
          url.searchParams.set('pageSize', document.getElementById('customerPageSize').value);
        }

        url.searchParams.set('page', '0');
        window.location.href = url.toString();
      }

      function goToPage(tab, pageNum) {
        const url = new URL(window.location.href);
        url.searchParams.set('page', pageNum);
        window.location.href = url.toString();
      }

      // Dynamic badge styling on DOM load
      document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.badge-status').forEach(badge => {
          const text = badge.textContent.trim().toLowerCase();
          if (text.includes('hủy') || text.includes('cancelled') || text.includes('hết hạn')) {
            badge.className = 'badge-status badge-cancelled';
          } else if (text.includes('xử lý') || text.includes('chờ') || text.includes('pending') || text.includes('process')) {
            badge.className = 'badge-status badge-pending';
          } else if (text.includes('giao') || text.includes('hoàn') || text.includes('deliver') || text.includes('success') || text.includes('chạy') || text.includes('hoạt động')) {
            badge.className = 'badge-status badge-delivered';
          } else {
            badge.className = 'badge-status badge-info';
          }
        });
      });
    </script>

    <style>
      .stat-card {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        border: 1px solid #f1f5f9;
        display: flex;
        align-items: center;
        gap: 16px;
        transition: transform 0.22s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.22s cubic-bezier(0.4, 0, 0.2, 1);
      }
      .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.03);
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
        transition: transform 0.22s ease;
      }
      .stat-card:hover .stat-icon {
        transform: scale(1.05);
      }
      .stat-icon.blue { background: linear-gradient(135deg, #2563eb, #1d4ed8); }
      .stat-icon.green { background: linear-gradient(135deg, #10b981, #047857); }
      .stat-icon.red { background: linear-gradient(135deg, #ef4444, #b91c1c); }
      .stat-icon.orange { background: linear-gradient(135deg, #f59e0b, #b45309); }
      .stat-icon.purple { background: linear-gradient(135deg, #8b5cf6, #6d28d9); }
      .stat-info .number { font-size: 22px; font-weight: 700; color: #0f172a; }
      .stat-info .label { font-size: 12px; color: #64748b; font-weight: 500; }

      .table-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        border: 1px solid #e2e8f0;
        overflow: hidden;
      }

      .table thead th {
        background: #f8fafc;
        color: #475569;
        font-size: 12px;
        font-weight: 600;
        border-bottom: 2px solid #e2e8f0;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        white-space: nowrap;
        padding: 14px 16px;
      }
      .table tbody td {
        vertical-align: middle;
        font-size: 13px;
        padding: 12px 16px;
        border: none;
        border-bottom: 1px solid #f1f5f9;
        color: #334155;
      }
      .table tbody tr:hover {
        background-color: #f8fafc;
      }

      .badge-status {
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 600;
        white-space: nowrap;
        display: inline-block;
      }
      .badge-delivered { background-color: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
      .badge-pending { background-color: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
      .badge-cancelled { background-color: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
      .badge-info { background-color: #e0f2fe; color: #075985; border: 1px solid #bae6fd; }

      .nav-tabs {
        border-bottom: 1px solid #e2e8f0;
      }
      .nav-tabs .nav-link {
        color: #64748b;
        font-weight: 600;
        padding: 12px 20px;
        border: none;
        border-bottom: 2px solid transparent;
        transition: all 0.2s ease;
      }
      .nav-tabs .nav-link:hover {
        color: #0284c7;
        border-bottom: 2px solid #e2e8f0;
      }
      .nav-tabs .nav-link.active {
        color: #0284c7;
        background: transparent;
        border: none;
        border-bottom: 2px solid #0284c7;
      }
    </style>

  </jsp:body>
</admin:admin-layout>
