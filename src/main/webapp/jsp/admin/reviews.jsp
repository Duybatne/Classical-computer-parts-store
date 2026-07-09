<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/common" %>

<admin:admin-layout title="Quản lý đánh giá" activePage="reviews">
  <jsp:body>

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-comments me-2 text-warning"></i>Quản lý đánh giá
      </h1>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.approved}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>Đã duyệt đánh giá thành công.
        <button type="button" class="close" data-dismiss="alert">&times;</button>
      </div>
    </c:if>
    <c:if test="${not empty param.rejected}">
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>Đã từ chối đánh giá.
        <button type="button" class="close" data-dismiss="alert">&times;</button>
      </div>
    </c:if>
    <c:if test="${not empty param.deleted}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-trash me-2"></i>Đã xóa đánh giá.
        <button type="button" class="close" data-dismiss="alert">&times;</button>
      </div>
    </c:if>

    <!-- Filter Bar -->
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          <i class="fas fa-filter me-2"></i>Bộ lọc
        </h6>
      </div>
      <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/reviews" method="get" class="form-inline">
          <div class="row">
            <div class="col-md-4 mb-2">
              <select name="status" class="form-control form-control-sm" onchange="this.form.submit()">
                <option value="">Tất cả trạng thái</option>
                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Từ chối</option>
              </select>
            </div>
            <div class="col-md-3 mb-2">
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-filter me-1"></i>Lọc
              </button>
              <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-secondary btn-sm">
                <i class="fas fa-redo me-1"></i>Đặt lại
              </a>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!-- Reviews Table -->
    <div class="card shadow mb-4">
      <div class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">
          <i class="fas fa-list me-2"></i>Danh sách đánh giá
        </h6>
        <span class="badge badge-primary">${not empty reviewList ? reviewList.size() : 0} đánh giá</span>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-bordered table-hover" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th style="width:40px">#</th>
                <th>Khách hàng</th>
                <th>Sản phẩm</th>
                <th style="width:100px">Số sao</th>
                <th>Nội dung</th>
                <th style="width:140px">Ngày đánh giá</th>
                <th style="width:100px">Trạng thái</th>
                <th style="width:160px">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty reviewList}">
                  <c:forEach var="r" items="${reviewList}" varStatus="st">
                    <tr>
                      <td class="text-muted">${st.index + 1}</td>
                      <td class="fw-bold">${r.tenKhachHang}</td>
                      <td>
                        <span class="text-muted">SP #${r.maSP}</span>
                      </td>
                      <td>
                        <c:forEach begin="1" end="5" var="i">
                          <c:choose>
                            <c:when test="${i <= r.soSao}">
                              <i class="fas fa-star text-warning" style="font-size:12px"></i>
                            </c:when>
                            <c:otherwise>
                              <i class="far fa-star text-muted" style="font-size:12px"></i>
                            </c:otherwise>
                          </c:choose>
                        </c:forEach>
                      </td>
                      <td>
                        <div style="max-width:300px; max-height:60px; overflow:auto;">${r.noiDung}</div>
                      </td>
                      <td>
                        <fmt:formatDate value="${r.ngayDanhGia}" pattern="dd/MM/yyyy HH:mm"/>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${r.trangThaiDuyet == 0}">
                            <span class="badge badge-warning">Chờ duyệt</span>
                          </c:when>
                          <c:when test="${r.trangThaiDuyet == 1}">
                            <span class="badge badge-success">Đã duyệt</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge badge-danger">Từ chối</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="d-flex">
                          <c:if test="${r.trangThaiDuyet == 0}">
                            <form action="${pageContext.request.contextPath}/admin/reviews/approve" method="post" style="display:inline" class="mr-1">
                              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                              <input type="hidden" name="maDanhGia" value="${r.maDanhGia}">
                              <button type="submit" class="btn btn-success btn-sm" title="Duyệt">
                                <i class="fas fa-check"></i>
                              </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/reviews/reject" method="post" style="display:inline" class="mr-1">
                              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                              <input type="hidden" name="maDanhGia" value="${r.maDanhGia}">
                              <button type="submit" class="btn btn-warning btn-sm" title="Từ chối"
                                      onclick="return confirm('Từ chối đánh giá này?')">
                                <i class="fas fa-times"></i>
                              </button>
                            </form>
                          </c:if>
                          <c:if test="${r.trangThaiDuyet == 1}">
                            <form action="${pageContext.request.contextPath}/admin/reviews/reject" method="post" style="display:inline" class="mr-1">
                              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                              <input type="hidden" name="maDanhGia" value="${r.maDanhGia}">
                              <button type="submit" class="btn btn-warning btn-sm" title="Ẩn đánh giá"
                                      onclick="return confirm('Ẩn đánh giá này?')">
                                <i class="fas fa-eye-slash"></i>
                              </button>
                            </form>
                          </c:if>
                          <form action="${pageContext.request.contextPath}/admin/reviews/delete" method="post" style="display:inline"
                                onsubmit="return confirm('Xóa đánh giá này? Hành động này không thể hoàn tác!')">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="maDanhGia" value="${r.maDanhGia}">
                            <button type="submit" class="btn btn-danger btn-sm" title="Xóa">
                              <i class="fas fa-trash"></i>
                            </button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="text-center py-5 text-muted">
                      <i class="fas fa-comments fa-3x mb-3 d-block"></i>
                      Không có đánh giá nào
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </jsp:body>
</admin:admin-layout>
