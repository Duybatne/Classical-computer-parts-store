<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/common" %>

<t:admin-layout title="Quản lý khuyến mãi" activePage="promotions">
  <div class="container-fluid py-4">
    <div class="row">
      <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2><i class="fas fa-tags me-2"></i>Quản lý Khuyến mãi / Voucher</h2>
          <button class="btn btn-primary" data-toggle="modal" data-target="#addPromotionModal">
            <i class="fas fa-plus me-2"></i>Thêm mới
          </button>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
          <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
          <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:choose>
          <c:when test="${not empty promoList}">
            <div class="card shadow-sm">
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead class="table-light">
                      <tr>
                        <th>Mã Voucher</th>
                        <th>Loại giảm</th>
                        <th>Giá trị</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Trạng thái</th>
                        <th>Sản phẩm áp dụng</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="promo" items="${promoList}">
                        <tr>
                          <td><strong>${promo.tenKM}</strong></td>
                          <td>
                            <span class="badge ${promo.loaiGiam == 'PHAN_TRAM' ? 'bg-info' : 'bg-warning'}">
                              ${promo.loaiGiam == 'PHAN_TRAM' ? 'Phần trăm' : 'Số tiền'}
                            </span>
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${promo.loaiGiam == 'PHAN_TRAM'}">
                                ${promo.giaTriGiam}%
                              </c:when>
                              <c:otherwise>
                                <fmt:formatNumber value="${promo.giaTriGiam}" type="currency" currencySymbol="₫"/>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>${promo.ngayBatDau}</td>
                          <td>${promo.ngayKetThuc}</td>
                          <td>
                            <c:choose>
                              <c:when test="${promo.trangThai && promo.ngayBatDau.time <= System.currentTimeMillis() && promo.ngayKetThuc.time >= System.currentTimeMillis()}">
                                <span class="badge bg-success">Đang hoạt động</span>
                              </c:when>
                              <c:when test="${!promo.trangThai}">
                                <span class="badge bg-danger">Vô hiệu</span>
                              </c:when>
                              <c:otherwise>
                                <span class="badge bg-secondary">Chưa đến hạn</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary"
                                    onclick="viewProducts(${promo.maKM}, '${promo.tenKM}')"
                                    title="Xem sản phẩm áp dụng">
                              <i class="fas fa-list"></i> Xem
                            </button>
                          </td>
                          <td>
                            <div class="btn-group" role="group">
                              <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="d-inline">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="maVoucher" value="${promo.tenKM}">
                                <button type="submit" class="btn btn-sm btn-danger"
                                        onclick="return confirm('Xóa mã giảm giá ${promo.tenKM}?');"
                                        formaction="${pageContext.request.contextPath}/admin/promotions/delete"
                                        title="Xóa">
                                  <i class="fas fa-trash"></i>
                                </button>
                              </form>
                              <c:if test="${promo.trangThai}">
                                <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="maKM" value="${promo.maKM}">
                                  <input type="hidden" name="action" value="toggleStatus">
                                  <input type="hidden" name="status" value="false">
                                  <button type="submit" class="btn btn-sm btn-warning"
                                          onclick="return confirm('Vô hiệu hóa mã ${promo.tenKM}?');"
                                          title="Vô hiệu">
                                    <i class="fas fa-ban"></i>
                                  </button>
                                </form>
                              </c:if>
                              <c:if test="${!promo.trangThai}">
                                <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="d-inline">
                                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                  <input type="hidden" name="maKM" value="${promo.maKM}">
                                  <input type="hidden" name="action" value="toggleStatus">
                                  <input type="hidden" name="status" value="true">
                                  <button type="submit" class="btn btn-sm btn-success"
                                          onclick="return confirm('Kích hoạt mã ${promo.tenKM}?');"
                                          title="Kích hoạt">
                                    <i class="fas fa-check"></i>
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
              <i class="fas fa-info-circle me-2"></i>Chưa có chương trình khuyến mãi nào.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- Add Promotion Modal -->
  <div class="modal fade" id="addPromotionModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/admin/promotions" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="modal-header">
            <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Thêm Khuyến mãi / Voucher</h5>
            <button type="button" class="btn-close" data-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="maVoucher" placeholder="VD: SUMMER20, FREESHIP" required>
              <div class="form-text">Viết hoa, không dấu, không khoảng trắng</div>
            </div>
            <div class="mb-3">
              <label class="form-label">Loại giảm <span class="text-danger">*</span></label>
              <select class="form-select" name="loaiGiam" required>
                <option value="percent">Giảm theo phần trăm (%)</option>
                <option value="fixed">Giảm theo số tiền (₫)</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
              <input type="number" class="form-control" name="giaTriGiam" min="1" required>
              <div class="form-text">Nhập số (không cần ký hiệu % hay ₫)</div>
            </div>
            <div class="mb-3">
              <label class="form-label">Đơn hàng tối thiểu (₫)</label>
              <input type="number" class="form-control" name="donToiThieu" min="0" value="0">
              <div class="form-text">Để 0 nếu không yêu cầu</div>
            </div>
            <div class="mb-3">
              <label class="form-label">Hạn sử dụng</label>
              <input type="date" class="form-control" name="hanSuDung">
              <div class="form-text">Để trống nếu không giới hạn</div>
            </div>
            <div class="alert alert-info">
              <i class="fas fa-info-circle me-2"></i>
              <strong>Lưu ý:</strong> Sau khi tạo, bạn cần thêm sản phẩm áp dụng cho khuyến mãi này.
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Tạo mới</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Products Modal (select + save) -->
  <div class="modal fade" id="productsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/admin/promotions/products" method="post" id="productsForm">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="modal-header">
            <h5 class="modal-title"><i class="fas fa-list me-2"></i>Gán sản phẩm cho khuyến mãi: <span id="promoName"></span></h5>
            <button type="button" class="btn-close" data-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" name="maKM" id="promoId" value=""/>
            <div class="text-muted mb-3">Chọn các sản phẩm áp dụng sau đó bấm "Lưu gán".</div>

            <div id="productsContent" class="text-center">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-save me-2"></i>Lưu gán
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function viewProducts(maKM, tenKM) {
      document.getElementById('promoName').textContent = tenKM;
      document.getElementById('promoId').value = maKM;
      var modal = new bootstrap.Modal(document.getElementById('productsModal'));
      modal.show();

      // Load ALL products via AJAX (with checked status)
      fetch('${pageContext.request.contextPath}/api/promotions/' + maKM + '/products?all=true')
        .then(response => response.json())
        .then(data => {
          var content = document.getElementById('productsContent');

          if (data.length === 0) {
            content.innerHTML = '<p class="text-muted">Không có sản phẩm nào.</p>';
            return;
          }

          var html = '<div class="list-group">';
          data.forEach(function(product) {
            var checked = product.checked ? 'checked' : '';
            html += '<label class="list-group-item d-flex justify-content-between align-items-center gap-3">' +
                    '  <div class="d-flex flex-column">' +
                    '    <div><input class="form-check-input me-2" type="checkbox" name="maSP" value="' + product.maSP + '" ' + checked + ' />' +
                    '      <span>' + product.tenSP + '</span></div>' +
                    '  </div>' +
                    '  <span class="badge bg-primary rounded-pill">' +
                    '    ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(product.giaBan) +
                    '  </span>' +
                    '</label>';
          });
          html += '</div>';
          content.innerHTML = html;
        })
        .catch(error => {
          document.getElementById('productsContent').innerHTML =
            '<p class="text-danger">Lỗi tải dữ liệu: ' + error + '</p>';
        });
    }
  </script>
</t:admin-layout>
