<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/common" %>

<admin:admin-layout title="Quản lý tài khoản" activePage="accounts">
  <jsp:body>

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-user-friends me-2 text-primary"></i>Quản lý tài khoản
      </h1>
      <div>
        <button class="btn btn-success" data-toggle="modal" data-target="#createAdminModal">
          <i class="fas fa-user-plus me-1"></i>Thêm Admin
        </button>
      </div>
    </div>

    <!-- Messages -->
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

    <!-- Search & Filter -->
    <div class="filter-bar mb-4">
      <form method="get" action="${pageContext.request.contextPath}/admin/accounts" class="form-inline">
        <div class="row w-100">
          <div class="col-md-5 mb-2 mb-md-0">
            <input type="text" name="q" class="form-control w-100" placeholder="Tìm kiếm theo tên hoặc email..."
                   value="${param.q}">
          </div>
          <div class="col-md-3 mb-2 mb-md-0">
            <select name="role" class="form-control w-100">
              <option value="">Tất cả vai trò</option>
              <option value="customer" ${param.role == 'customer' ? 'selected' : ''}>Khách hàng</option>
              <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Quản trị viên</option>
            </select>
          </div>
          <div class="col-md-2 mb-2 mb-md-0">
            <button type="submit" class="btn btn-primary btn-block w-100"><i class="fas fa-search"></i> Tìm</button>
          </div>
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-secondary btn-block w-100">
              <i class="fas fa-undo"></i> Reset</a>
          </div>
        </div>
      </form>
    </div>

    <!-- Accounts Table -->
    <div class="table-card">
      <div class="table-responsive">
        <table class="table table-hover" width="100%" cellspacing="0">
          <thead>
            <tr>
              <th>ID</th>
              <th>Tên đăng nhập</th>
              <th>Họ tên</th>
              <th>Email</th>
              <th>Vai trò</th>
              <th>Trạng thái</th>
              <th>Đăng nhập cuối</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty accountList}">
                <c:forEach var="acc" items="${accountList}">
                  <tr>
                    <td class="text-muted">${acc.maTK}</td>
                    <td><strong><c:out value="${acc.tenDangNhap}"/></strong></td>
                    <td><c:out value="${acc.hoTen}"/></td>
                    <td><c:out value="${acc.email}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${acc.vaiTro == 'QUAN_TRI_VIEN'}">
                          <span class="badge badge-primary">Admin</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-info">Khách hàng</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${acc.trangThai == 1}">
                          <span class="badge badge-success">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-danger">Đã khóa</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-muted">
                      <c:if test="${not empty acc.ngayDangNhapCuoi}">
                        <fmt:formatDate value="${acc.ngayDangNhapCuoi}" pattern="dd/MM/yyyy HH:mm"/>
                      </c:if>
                      <c:if test="${empty acc.ngayDangNhapCuoi}">
                        <span class="text-muted">Chưa ĐN</span>
                      </c:if>
                    </td>
                    <td>
                      <div class="btn-group btn-group-sm" style="gap:3px">
                        <!-- Toggle Khóa/Mở khóa -->
                        <form action="${pageContext.request.contextPath}/admin/accounts/toggle" method="post"
                              style="display:inline" onsubmit="return confirmAction(this)">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="maTK" value="${acc.maTK}">
                          <input type="hidden" name="trangThai" value="${acc.trangThai == 1 ? 'banned' : 'active'}">
                          <input type="hidden" name="actionLabel" value="${acc.trangThai == 1 ? 'khóa' : 'mở khóa'}">
                          <button type="submit" class="btn ${acc.trangThai == 1 ? 'btn-danger' : 'btn-success'}"
                                  title="${acc.trangThai == 1 ? 'Khóa' : 'Mở khóa'}">
                            <i class="fas ${acc.trangThai == 1 ? 'fa-ban' : 'fa-check'}"></i>
                          </button>
                        </form>
                        <!-- Xóa vĩnh viễn khỏi CSDL -->
                        <form action="${pageContext.request.contextPath}/admin/accounts/delete" method="post"
                              style="display:inline" onsubmit="return confirm('Xóa VĨNH VIỄN tài khoản này?')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="maTK" value="${acc.maTK}">
                          <input type="hidden" name="type" value="hard">
                          <button type="submit" class="btn btn-dark btn-sm" title="Xóa vĩnh viễn">
                            <i class="fas fa-times-circle"></i>
                          </button>
                        </form>
                        <!-- Nâng cấp lên Admin (chỉ với KHACH_HANG) -->
                        <c:if test="${acc.vaiTro == 'KHACH_HANG'}">
                          <button class="btn btn-info btn-sm" title="Nâng cấp lên Admin"
                                  data-matk="${acc.maTK}" data-hoten="${acc.hoTen}" data-email="${acc.email}"
                                  onclick="showUpgradeModal(this)">
                            <i class="fas fa-arrow-up"></i>
                          </button>
                        </c:if>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="8" class="text-center py-5 text-muted">
                    <i class="fas fa-users fa-3x mb-3 d-block"></i>
                    Không có tài khoản nào
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Create Admin Modal -->
    <div class="modal fade" id="createAdminModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <form action="${pageContext.request.contextPath}/admin/accounts/create" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <div class="modal-header">
              <h5 class="modal-title"><i class="fas fa-user-shield me-2 text-success"></i>Thêm quản trị viên</h5>
              <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
              <div class="mb-3">
                <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                <input type="text" name="username" class="form-control" required pattern="[a-zA-Z0-9_]{3,20}">
              </div>
              <div class="mb-3">
                <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                <input type="text" name="fullname" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" name="email" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                <input type="password" name="password" class="form-control" required pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}">
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
              <button type="submit" class="btn btn-success"><i class="fas fa-user-plus me-1"></i>Tạo tài khoản</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Upgrade Modal -->
    <div class="modal fade" id="upgradeModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <form action="${pageContext.request.contextPath}/admin/accounts/upgrade" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="maTK" id="upgradeMaTK">
            <div class="modal-header">
              <h5 class="modal-title"><i class="fas fa-arrow-up me-2 text-info"></i>Nâng cấp lên Admin</h5>
              <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
              <p>Xác nhận nâng cấp khách hàng này lên Quản trị viên?</p>
              <div class="mb-3">
                <label class="form-label">Họ tên</label>
                <input type="text" name="fullname" id="upgradeFullname" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" id="upgradeEmail" class="form-control" required>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
              <button type="submit" class="btn btn-info"><i class="fas fa-arrow-up me-1"></i>Nâng cấp</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <script>
    function confirmAction(form) {
      var label = form.querySelector('input[name="actionLabel"]').value;
      return confirm('Bạn có chắc chắn muốn ' + label + ' tài khoản này?');
    }
    function showUpgradeModal(btn) {
      document.getElementById('upgradeMaTK').value = btn.getAttribute('data-matk');
      document.getElementById('upgradeFullname').value = btn.getAttribute('data-hoten');
      document.getElementById('upgradeEmail').value = btn.getAttribute('data-email');
      $('#upgradeModal').modal('show');
    }
    </script>

    <style>
      .filter-bar { background: #fff; border-radius: 10px; padding: 16px 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
      .table-card { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); overflow: hidden; }
      .table thead th { background: #1a1a2e; color: #fff; font-size: 13px; font-weight: 600; border: none; white-space: nowrap; padding: 12px 14px; }
      .table tbody td { vertical-align: middle; font-size: 13px; padding: 10px 14px; border-color: #f0f0f0; }
      .table tbody tr:hover { background: #f8f9fc; }
      .btn-group .btn { border-radius: 4px !important; }
      .modal-content { border-radius: 12px; border: none; }
    </style>

  </jsp:body>
</admin:admin-layout>
