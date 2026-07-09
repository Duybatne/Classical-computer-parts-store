<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions"  %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/common" %>

<admin:admin-layout title="Quản lý sản phẩm" activePage="products">
  <jsp:body>

    <style>
      /* Extra styles for products page */
      .stat-card {
        background   : #fff;
        border-radius: 10px;
        padding      : 18px 20px;
        box-shadow   : 0 2px 8px rgba(0,0,0,0.06);
        display      : flex;
        align-items  : center;
        gap          : 14px;
      }
      .stat-icon {
        width         : 48px;
        height        : 48px;
        border-radius : 10px;
        display       : flex;
        align-items   : center;
        justify-content: center;
        font-size     : 20px;
        color         : #fff;
        flex-shrink   : 0;
      }
      .stat-icon.red    { background: #e83e2d; }
      .stat-icon.green  { background: #28a745; }
      .stat-icon.orange { background: #fd7e14; }
      .stat-icon.blue   { background: #007bff; }
      .stat-info .number { font-size: 22px; font-weight: 700; color: #1a1a2e; }
      .stat-info .label  { font-size: 12px; color: #6b7280; }

      .filter-bar {
        background   : #fff;
        border-radius: 10px;
        padding      : 16px 20px;
        margin-bottom: 20px;
        box-shadow   : 0 2px 8px rgba(0,0,0,0.06);
      }

      .table-card {
        background   : #fff;
        border-radius: 10px;
        box-shadow   : 0 2px 8px rgba(0,0,0,0.06);
        overflow     : hidden;
      }
      .table-card .table { margin: 0; }
      .table thead th {
        background  : #1a1a2e;
        color       : #fff;
        font-size   : 13px;
        font-weight : 600;
        border      : none;
        white-space : nowrap;
        padding     : 12px 14px;
      }
      .table tbody td {
        vertical-align: middle;
        font-size     : 13px;
        padding       : 10px 14px;
        border-color  : #f0f0f0;
      }
      .product-thumb {
        width        : 52px;
        height       : 52px;
        object-fit   : contain;
        border-radius: 6px;
        border       : 1px solid #e8e8e8;
        background   : #f8f8f8;
        padding      : 2px;
      }
      .product-name-cell {
        max-width  : 200px;
        font-weight: 600;
        color      : #1a1a2e;
        white-space: nowrap;
        overflow   : hidden;
        text-overflow: ellipsis;
      }
      .badge-status {
        padding      : 4px 10px;
        border-radius: 20px;
        font-size    : 11px;
        font-weight  : 600;
      }
      .badge-active   { background: #d1fae5; color: #065f46; }
      .badge-inactive { background: #fee2e2; color: #991b1b; }
      .badge-low      { background: #fef3c7; color: #92400e; }
      .badge-out      { background: #fee2e2; color: #991b1b; }

      .btn-action {
        width        : 30px;
        height       : 30px;
        border-radius: 6px;
        border       : none;
        display      : inline-flex;
        align-items  : center;
        justify-content: center;
        font-size    : 13px;
        cursor       : pointer;
        transition   : all 0.2s;
        text-decoration: none;
      }
      .btn-edit   { background: #dbeafe; color: #1d4ed8; }
      .btn-delete { background: #fee2e2; color: #dc2626; }
      .btn-view   { background: #d1fae5; color: #065f46; }
      .btn-edit:hover   { background: #1d4ed8; color: #fff; }
      .btn-delete:hover { background: #dc2626; color: #fff; }
      .btn-view:hover   { background: #065f46; color: #fff; }

      /* Image preview modal */
      #imagePreview {
        width        : 100%;
        height       : 140px;
        object-fit   : contain;
        border       : 2px dashed #e8e8e8;
        border-radius: 8px;
        background   : #f8f8f8;
        padding      : 8px;
        display      : none;
      }
      #imagePreview.show { display: block; }
      .image-placeholder {
        width        : 100%;
        height       : 140px;
        border       : 2px dashed #e8e8e8;
        border-radius: 8px;
        background   : #f8f8f8;
        display      : flex;
        align-items  : center;
        justify-content: center;
        flex-direction: column;
        color        : #9ca3af;
        font-size    : 13px;
        cursor       : pointer;
      }
    </style>

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-box me-2 text-danger"></i>Quản lý sản phẩm
      </h1>
    </div>

    <!-- Thông báo -->
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

    <!-- ===== STAT CARDS ===== -->
    <div class="row">
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon red"><i class="fas fa-box"></i></div>
          <div class="stat-info">
            <div class="number">${totalProducts != null ? totalProducts : 0}</div>
            <div class="label">Tổng sản phẩm</div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
          <div class="stat-info">
            <div class="number">${activeProducts != null ? activeProducts : 0}</div>
            <div class="label">Đang bán</div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon orange"><i class="fas fa-exclamation-triangle"></i></div>
          <div class="stat-info">
            <div class="number">${lowStockProducts != null ? lowStockProducts : 0}</div>
            <div class="label">Sắp hết hàng</div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="stat-card">
          <div class="stat-icon blue"><i class="fas fa-times-circle"></i></div>
          <div class="stat-info">
            <div class="number">${outOfStockProducts != null ? outOfStockProducts : 0}</div>
            <div class="label">Hết hàng</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== FILTER BAR ===== -->
    <div class="filter-bar">
      <form action="${pageContext.request.contextPath}/admin/products" method="get" class="form-inline">
        <div class="row">
          <div class="col-md-3 mb-2">
            <label class="sr-only" for="keyword">Tìm kiếm</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="fas fa-search"></i></span>
              </div>
              <input type="text" id="keyword" name="keyword" class="form-control form-control-sm"
                     placeholder="Tên SP, thương hiệu..." value="${param.keyword}">
            </div>
          </div>
          <div class="col-md-2 mb-2">
            <select name="category" class="form-control form-control-sm">
              <option value="">Tất cả danh mục</option>
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.maLoaiSP}" ${param.category == cat.maLoaiSP ? 'selected' : ''}>
                  ${cat.tenLoaiSP}
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-2 mb-2">
            <select name="status" class="form-control form-control-sm">
              <option value="">Tất cả trạng thái</option>
              <option value="1" ${param.status == '1' ? 'selected' : ''}>Đang bán</option>
              <option value="0" ${param.status == '0' ? 'selected' : ''}>Ẩn</option>
            </select>
          </div>
          <div class="col-md-2 mb-2">
            <select name="stock" class="form-control form-control-sm">
              <option value="">Tất cả tồn kho</option>
              <option value="low" ${param.stock == 'low' ? 'selected' : ''}>Sắp hết (≤5)</option>
              <option value="out" ${param.stock == 'out' ? 'selected' : ''}>Hết hàng</option>
              <option value="ok"  ${param.stock == 'ok'  ? 'selected' : ''}>Còn hàng</option>
            </select>
          </div>
          <div class="col-md-2 mb-2">
            <select name="sort" class="form-control form-control-sm">
              <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
              <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
              <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
              <option value="name" ${sort == 'name' ? 'selected' : ''}>Tên A-Z</option>
              <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
              <option value="stock_asc" ${sort == 'stock_asc' ? 'selected' : ''}>Tồn: Ít → Nhiều</option>
              <option value="stock_desc" ${sort == 'stock_desc' ? 'selected' : ''}>Tồn: Nhiều → Ít</option>
            </select>
          </div>
          <div class="col-md-3 mb-2">
            <button type="submit" class="btn btn-danger btn-sm">
              <i class="fas fa-filter me-1"></i>Lọc
            </button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary btn-sm">
              <i class="fas fa-redo me-1"></i>Đặt lại
            </a>
            <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalProduct" onclick="openAddModal()">
              <i class="fas fa-plus me-1"></i>Thêm mới
            </button>
          </div>
        </div>
      </form>
    </div>

    <!-- ===== TABLE ===== -->
    <div class="table-card">
      <div class="table-responsive">
        <table class="table table-hover" width="100%" cellspacing="0">
          <thead>
            <tr>
              <th style="width:50px">#</th>
              <th style="width:60px">Ảnh</th>
              <th>Tên sản phẩm</th>
              <th>Danh mục</th>
              <th>Thương hiệu</th>
              <th>Giá bán</th>
              <th>Tồn kho</th>
              <th>Bảo hành</th>
              <th>Trạng thái</th>
              <th style="width:120px">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty products}">
                <c:forEach var="p" items="${products}" varStatus="st">
                  <tr>
                    <td class="text-muted">${st.index + 1}</td>

                    <!-- Ảnh -->
                    <td>
                      <c:choose>
                        <c:when test="${not empty p.anhChinh}">
                          <c:set var="imgSrc" value="${p.anhChinh}"/>
                          <c:if test="${not fn:startsWith(p.anhChinh, 'http://') and not fn:startsWith(p.anhChinh, 'https://')}">
                            <c:set var="imgSrc" value="${pageContext.request.contextPath}${p.anhChinh}"/>
                          </c:if>
                          <img src="${imgSrc}" alt="${p.tenSP}" class="product-thumb" loading="lazy"
                               onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/no-image.png';">
                        </c:when>
                        <c:otherwise>
                          <img src="${pageContext.request.contextPath}/img/no-image.png" alt="No image" class="product-thumb">
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <!-- Tên -->
                    <td>
                      <div class="product-name-cell" title="${p.tenSP}">${p.tenSP}</div>
                      <small class="text-muted">ID: ${p.maSP}</small>
                    </td>

                    <td><span class="badge badge-light">${p.tenLoaiSP != null ? p.tenLoaiSP : '—'}</span></td>
                    <td>${not empty p.thuongHieu ? p.thuongHieu : '—'}</td>

                    <td class="text-danger fw-bold">
                      <fmt:formatNumber value="${p.giaBan}" type="number" groupingUsed="true"/>₫
                    </td>

                    <td>
                      <c:choose>
                        <c:when test="${p.soLuongTon <= 0}">
                          <span class="badge-status badge-out">Hết hàng</span>
                        </c:when>
                        <c:when test="${p.soLuongTon <= 5}">
                          <span class="badge-status badge-low">${p.soLuongTon} – Sắp hết</span>
                        </c:when>
                        <c:otherwise>
                          <span class="text-success fw-semibold">${p.soLuongTon}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <td>${p.baoHanhThang} tháng</td>

                    <td>
                      <c:choose>
                        <c:when test="${p.hienThi}">
                          <span class="badge-status badge-active">Đang bán</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge-status badge-inactive">Đã ẩn</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <!-- Thao tác -->
                    <td>
                      <div class="d-flex">
                        <a href="${pageContext.request.contextPath}/product?id=${p.maSP}" target="_blank" class="btn-action btn-view mr-1" title="Xem">
                          <i class="fas fa-eye"></i>
                        </a>
                        <button class="btn-action btn-edit mr-1" title="Sửa"
                                onclick="openEditModal(${p.maSP},'${fn:escapeXml(p.tenSP)}',${p.maLoaiSP},'${fn:escapeXml(p.thuongHieu)}',${p.giaBan},${p.soLuongTon},${p.baoHanhThang},'${fn:escapeXml(p.moTaNgan)}','${p.anhChinh}',${p.hienThi ? 1 : 0})">
                          <i class="fas fa-edit"></i>
                        </button>
                        <form action="${pageContext.request.contextPath}/admin/products/toggle" method="post" style="display:inline" class="mr-1"
                              onsubmit="return confirm('${p.hienThi ? 'Ẩn' : 'Hiện'} sản phẩm này?')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="maSP" value="${p.maSP}">
                          <input type="hidden" name="status" value="${p.hienThi ? 0 : 1}">
                          <button type="submit" class="btn-action ${p.hienThi ? 'btn-delete' : 'btn-edit'}" title="${p.hienThi ? 'Ẩn' : 'Hiện'}">
                            <i class="fas ${p.hienThi ? 'fa-eye-slash' : 'fa-eye'}"></i>
                          </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/products/delete" method="post" style="display:inline"
                              onsubmit="return confirmDelete('${fn:escapeXml(p.tenSP)}')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="maSP" value="${p.maSP}">
                          <button type="submit" class="btn-action btn-delete" title="Xóa">
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
                  <td colspan="10" class="text-center py-5 text-muted">
                    <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                    Không có sản phẩm nào
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center px-3 py-2 border-top">
          <small class="text-muted">Hiển thị ${products.size()} / ${totalProducts} sản phẩm</small>
          <nav>
            <ul class="pagination pagination-sm mb-0">
              <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}&keyword=${param.keyword}&category=${param.category}&status=${param.status}&stock=${param.stock}&sort=${sort}">
                  <i class="fas fa-chevron-left"></i>
                </a>
              </li>
              <c:forEach begin="1" end="${totalPages}" var="pg">
                <li class="page-item ${pg == currentPage ? 'active' : ''}">
                  <a class="page-link" href="${pageContext.request.contextPath}/admin/products?page=${pg}&keyword=${param.keyword}&category=${param.category}&status=${param.status}&stock=${param.stock}&sort=${sort}">${pg}</a>
                </li>
              </c:forEach>
              <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}&keyword=${param.keyword}&category=${param.category}&status=${param.status}&stock=${param.stock}&sort=${sort}">
                  <i class="fas fa-chevron-right"></i>
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </c:if>
    </div>

    <!-- ===== MODAL THÊM / SỬA SẢN PHẨM ===== -->
    <div class="modal fade" id="modalProduct" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalTitle"><i class="fas fa-plus-circle me-2"></i>Thêm sản phẩm mới</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <form id="formProduct" action="${pageContext.request.contextPath}/admin/products/save" method="post" enctype="multipart/form-data">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" id="maSP" name="maSP" value="">
            <div class="modal-body">
              <div class="row">
                <div class="col-md-8">
                  <div class="form-group">
                    <label>Tên sản phẩm <span class="text-danger">*</span></label>
                    <input type="text" id="tenSP" name="tenSP" class="form-control" placeholder="Nhập tên SP..." required maxlength="255">
                  </div>
                  <div class="row">
                    <div class="col-6">
                      <div class="form-group">
                        <label>Danh mục <span class="text-danger">*</span></label>
                        <select id="maLoaiSP" name="maLoaiSP" class="form-control" required>
                          <option value="">-- Chọn --</option>
                          <c:forEach var="cat" items="${categories}">
                            <option value="${cat.maLoaiSP}">${cat.tenLoaiSP}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    <div class="col-6">
                      <div class="form-group">
                        <label>Thương hiệu</label>
                        <input type="text" id="thuongHieu" name="thuongHieu" class="form-control" placeholder="Intel, AMD..." maxlength="100">
                      </div>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col-4">
                      <div class="form-group">
                        <label>Giá bán (₫) <span class="text-danger">*</span></label>
                        <input type="number" id="giaBan" name="giaBan" class="form-control" placeholder="0" min="0" required>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="form-group">
                        <label>Số lượng tồn</label>
                        <input type="number" id="soLuongTon" name="soLuongTon" class="form-control" placeholder="0" min="0" value="0">
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="form-group">
                        <label>Bảo hành (tháng)</label>
                        <input type="number" id="baoHanhThang" name="baoHanhThang" class="form-control" placeholder="0" min="0" value="0">
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <label>Mô tả ngắn</label>
                    <textarea id="moTaNgan" name="moTaNgan" class="form-control" rows="3" placeholder="Mô tả ngắn..." maxlength="500"></textarea>
                  </div>
                  <div class="form-group">
                    <label>Mô tả chi tiết</label>
                    <textarea id="moTaChiTiet" name="moTaChiTiet" class="form-control" rows="6" placeholder="Mô tả chi tiết sản phẩm... (HTML hỗ trợ)" maxlength="10000"></textarea>
                  </div>
                  <div class="form-group">
                    <label>Trạng thái</label>
                    <select id="trangThai" name="trangThai" class="form-control">
                      <option value="1">Đang bán</option>
                      <option value="0">Ẩn</option>
                    </select>
                  </div>
                </div>
                <div class="col-md-4">
                  <label>Ảnh sản phẩm</label>
                  <img id="imagePreview" src="" alt="Preview">
                  <div id="imagePlaceholder" class="image-placeholder" onclick="document.getElementById('fileAnh').click()">
                    <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                    <span>Nhấn để chọn ảnh</span>
                    <small class="mt-1">PNG, JPG tối đa 5MB</small>
                  </div>
                  <div class="mt-2">
                    <label>hoặc dán link ảnh</label>
                    <input type="text" id="anhUrl" name="anhUrl" class="form-control form-control-sm" placeholder="https://..." oninput="previewFromUrl(this.value)">
                  </div>
                  <input type="file" id="fileAnh" name="fileAnh" accept="image/*" class="d-none" onchange="previewFile(this)">
                  <small class="text-muted d-block mt-1">* File upload được ưu tiên hơn URL.</small>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
              <button type="submit" class="btn btn-danger"><span id="btnSubmitText">Thêm sản phẩm</span></button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- ===== TAB: THÔNG SỐ KỸ THUẬT (theo loại SP) ===== -->
    <div class="row mt-3" id="techSpecSection" style="display:none">
      <div class="col-12">
        <h5 class="text-primary mb-3"><i class="fas fa-microchip me-2"></i>Thông số kỹ thuật</h5>
        <div class="card bg-light">
          <div class="card-body" id="techSpecFields">
            <!-- Fields will be injected by JavaScript based on category -->
          </div>
        </div>
      </div>
    </div>

    <%-- Hidden field to store tech detail JSON on edit --%>
    <input type="hidden" id="editTechDetail" value="">

  </jsp:body>
</admin:admin-layout>

<!-- Page-specific scripts -->
<script>
  /* =========================================================
     TECH SPEC FIELDS DEFINITIONS
  ========================================================= */
  const techSpecFields = {
    1: { name: 'Mainboard', icon: 'fa-microchip', fields: [ // Mainboard
      { id: 'mainChipset', label: 'Chipset', type: 'text', placeholder: 'VD: Intel B760' },
      { id: 'mainSocket', label: 'Socket', type: 'text', placeholder: 'VD: LGA1700' },
      { id: 'mainKichThuoc', label: 'Kích thước main', type: 'text', placeholder: 'VD: mATX, ATX, E-ATX' },
      { id: 'mainHoTroCPU', label: 'Hỗ trợ CPU', type: 'text', placeholder: 'VD: Intel 12th/13th Gen' },
      { id: 'mainSoKheRam', label: 'Số khe RAM', type: 'number', placeholder: 'VD: 4' },
      { id: 'mainLoaiRam', label: 'Loại RAM', type: 'text', placeholder: 'VD: DDR5' },
      { id: 'mainRamToiDa', label: 'RAM tối đa', type: 'text', placeholder: 'VD: 192GB' },
      { id: 'mainKhePCIe', label: 'Khe PCIe', type: 'text', placeholder: 'VD: PCIe 5.0 x16, PCIe 4.0 x1' },
      { id: 'mainSoSATA', label: 'Số cổng SATA', type: 'number', placeholder: 'VD: 6' },
      { id: 'mainSoM2', label: 'Số khe M.2', type: 'number', placeholder: 'VD: 5' },
      { id: 'mainCongXuatHinh', label: 'Cổng xuất hình', type: 'text', placeholder: 'VD: HDMI 2.1, DP 1.4' },
    ]},
    2: { name: 'CPU', icon: 'fa-cpu', fields: [
      { id: 'cpuHang', label: 'Hãng CPU', type: 'text', placeholder: 'VD: Intel, AMD' },
      { id: 'cpuDong', label: 'Dòng CPU', type: 'text', placeholder: 'VD: Core i7-13700K' },
      { id: 'cpuSocket', label: 'Socket', type: 'text', placeholder: 'VD: LGA1700, AM5' },
      { id: 'cpuSoNhan', label: 'Số nhân', type: 'number', placeholder: 'VD: 16' },
      { id: 'cpuSoLuong', label: 'Số luồng', type: 'number', placeholder: 'VD: 24' },
      { id: 'cpuXungCoBan', label: 'Xung nhịp cơ bản', type: 'text', placeholder: 'VD: 3.4 GHz' },
      { id: 'cpuXungTurbo', label: 'Xung nhịp Turbo', type: 'text', placeholder: 'VD: 5.4 GHz' },
      { id: 'cpuCacheL1', label: 'Cache L1', type: 'text', placeholder: 'VD: 80KB' },
      { id: 'cpuCacheL2', label: 'Cache L2', type: 'text', placeholder: 'VD: 24MB' },
      { id: 'cpuTDP', label: 'TDP', type: 'text', placeholder: 'VD: 125W' },
      { id: 'cpuCoGPU', label: 'Có GPU tích hợp', type: 'select', options: [['true','Có'],['false','Không']] },
    ]},
    3: { name: 'VGA', icon: 'fa-film', fields: [
      { id: 'vgaHang', label: 'Hãng GPU', type: 'text', placeholder: 'VD: NVIDIA, AMD' },
      { id: 'vgaVRAM', label: 'Dung lượng VRAM', type: 'text', placeholder: 'VD: 16GB GDDR6X' },
      { id: 'vgaKieuBoNho', label: 'Kiểu bộ nhớ', type: 'text', placeholder: 'VD: GDDR6X' },
      { id: 'vgaBus', label: 'Bus bộ nhớ', type: 'text', placeholder: 'VD: 256-bit' },
      { id: 'vgaXungNhip', label: 'Xung nhịp', type: 'text', placeholder: 'VD: 2550 MHz Boost' },
      { id: 'vgaTDP', label: 'TDP', type: 'text', placeholder: 'VD: 320W' },
      { id: 'vgaCongKetNoi', label: 'Cổng kết nối', type: 'text', placeholder: 'VD: HDMI 2.1 x1, DP 1.4a x3' },
      { id: 'vgaSoQuat', label: 'Số quạt', type: 'number', placeholder: 'VD: 3' },
      { id: 'vgaKichThuoc', label: 'Kích thước', type: 'text', placeholder: 'VD: 304 x 137 x 61 mm' },
      { id: 'vgaDauCapNguon', label: 'Đầu cáp nguồn', type: 'text', placeholder: 'VD: 16-pin PCIe 5.0 x1' },
    ]},
    4: { name: 'Case', icon: 'fa-server', fields: [
      { id: 'caseHoTroMain', label: 'Hỗ trợ main', type: 'text', placeholder: 'VD: ATX, mATX, ITX' },
      { id: 'caseMauSac', label: 'Màu sắc', type: 'text', placeholder: 'VD: Đen, Trắng' },
      { id: 'caseChatLieu', label: 'Chất liệu', type: 'text', placeholder: 'VD: Thép + Kính cường lực' },
      { id: 'caseKichThuoc', label: 'Kích thước', type: 'text', placeholder: 'VD: 453 x 230 x 466 mm' },
      { id: 'caseHoTroNguon', label: 'Hỗ trợ nguồn', type: 'text', placeholder: 'VD: ATX (≤180mm)' },
      { id: 'caseSoQuat', label: 'Số quạt hỗ trợ', type: 'number', placeholder: 'VD: 6' },
      { id: 'caseCoKinh', label: 'Có kính cường lực', type: 'select', options: [['true','Có'],['false','Không']] },
      { id: 'caseCongTruoc', label: 'Cổng trước case', type: 'text', placeholder: 'VD: USB-A 3.0 x2, USB-C x1' },
    ]},
    5: { name: 'Nguồn', icon: 'fa-bolt', fields: [
      { id: 'psuCongSuat', label: 'Công suất', type: 'text', placeholder: 'VD: 850W' },
      { id: 'psuChuan', label: 'Chuẩn 80 Plus', type: 'text', placeholder: 'VD: 80+ Gold, Titanium' },
      { id: 'psuCongKetNoi', label: 'Kiểu kết nối', type: 'text', placeholder: 'VD: Fully Modular' },
      { id: 'psuKichThuoc', label: 'Kích thước', type: 'text', placeholder: 'VD: 150 x 86 x 140 mm' },
      { id: 'psuDienAp', label: 'Điện áp vào', type: 'text', placeholder: 'VD: 100-240V ~ 50/60Hz' },
      { id: 'psuDauCap', label: 'Đầu cáp nguồn', type: 'text', placeholder: 'VD: 24-pin ATX x1, EPS 8-pin x2' },
    ]},
    6: { name: 'Tản nhiệt', icon: 'fa-fan', fields: [
      { id: 'coolerLoai', label: 'Loại tản nhiệt', type: 'text', placeholder: 'VD: AIO Liquid Cooler' },
      { id: 'coolerTuongThich', label: 'Tương thích CPU', type: 'text', placeholder: 'VD: LGA1700, AM5' },
      { id: 'coolerRadiator', label: 'Kích thước Radiator', type: 'text', placeholder: 'VD: 360mm' },
      { id: 'coolerSoQuat', label: 'Số quạt', type: 'number', placeholder: 'VD: 3' },
      { id: 'coolerTocDo', label: 'Tốc độ quạt', type: 'text', placeholder: 'VD: 500 - 1850 RPM' },
      { id: 'coolerDoOn', label: 'Độ ồn', type: 'text', placeholder: 'VD: ≤28 dB(A)' },
      { id: 'coolerLED', label: 'LED', type: 'text', placeholder: 'VD: ARGB, Không LED' },
      { id: 'coolerKichThuoc', label: 'Kích thước', type: 'text', placeholder: 'VD: 129 x 138 x 160 mm' },
    ]},
    7: { name: 'Ổ cứng', icon: 'fa-hdd', fields: [
      { id: 'storageLoai', label: 'Loại ổ cứng', type: 'text', placeholder: 'VD: SSD, HDD' },
      { id: 'storageDungLuong', label: 'Dung lượng', type: 'text', placeholder: 'VD: 2TB, 500GB' },
      { id: 'storageChuan', label: 'Chuẩn kết nối', type: 'text', placeholder: 'VD: NVMe PCIe 4.0, SATA III' },
      { id: 'storageKichCo', label: 'Kích cỡ', type: 'text', placeholder: 'VD: M.2 2280, 2.5 inch' },
      { id: 'storageTocDo', label: 'Tốc độ đọc/ghi', type: 'text', placeholder: 'VD: Đọc 7450 MB/s, Ghi 6900 MB/s' },
    ]},
    8: { name: 'RAM', icon: 'fa-memory', fields: [
      { id: 'ramLoai', label: 'Loại RAM', type: 'text', placeholder: 'VD: DDR5' },
      { id: 'ramDungLuong', label: 'Dung lượng', type: 'text', placeholder: 'VD: 32GB (2x16GB)' },
      { id: 'ramBus', label: 'Bus RAM', type: 'text', placeholder: 'VD: 6000 MHz' },
      { id: 'ramDienAp', label: 'Điện áp', type: 'text', placeholder: 'VD: 1.35V' },
      { id: 'ramSoThanh', label: 'Số thanh', type: 'number', placeholder: 'VD: 2' },
    ]}
  };

  /* =========================================================
     SHOW/HIDE TECH SPEC FIELDS BASED ON CATEGORY
  ========================================================= */
  document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('maLoaiSP').addEventListener('change', function() {
      renderTechSpecFields(this.value);
    });
  });

  function renderTechSpecFields(categoryId) {
    const section = document.getElementById('techSpecSection');
    const container = document.getElementById('techSpecFields');

    if (!categoryId || !techSpecFields[categoryId]) {
      section.style.display = 'none';
      return;
    }

    const spec = techSpecFields[categoryId];
    let html = '';
    for (const f of spec.fields) {
      html += '<div class="form-group mb-2">';
      html += '<label class="form-label small mb-1">' + f.label + '</label>';
      if (f.type === 'select') {
        html += '<select id="' + f.id + '" name="' + f.id + '" class="form-control form-control-sm">';
        for (const opt of f.options) {
          html += '<option value="' + opt[0] + '">' + opt[1] + '</option>';
        }
        html += '</select>';
      } else {
        html += '<input type="' + f.type + '" id="' + f.id + '" name="' + f.id + '" class="form-control form-control-sm" placeholder="' + (f.placeholder || '') + '">';
      }
      html += '</div>';
    }
    container.innerHTML = html;
    section.style.display = 'block';

    // If editing, load existing values from editTechDetail
    const editData = document.getElementById('editTechDetail').value;
    if (editData) {
      try {
        const data = JSON.parse(editData);
        for (const f of spec.fields) {
          const el = document.getElementById(f.id);
          if (el && data[f.id] !== undefined) {
            el.value = data[f.id];
          }
        }
      } catch(e) {}
    }
  }

  /* =========================================================
     MODAL: MỞ THÊM MỚI
  ========================================================= */
  function openAddModal() {
    document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle me-2"></i>Thêm sản phẩm mới';
    document.getElementById('btnSubmitText').textContent = 'Thêm sản phẩm';
    document.getElementById('formProduct').reset();
    document.getElementById('maSP').value = '';
    document.getElementById('editTechDetail').value = '';
    document.getElementById('techSpecSection').style.display = 'none';
    resetImagePreview();
  }

  /* =========================================================
     MODAL: MỞ CHỈNH SỬA
  ========================================================= */
  function openEditModal(maSP, tenSP, maLoaiSP, thuongHieu, giaBan, soLuongTon, baoHanhThang, moTaNgan, anhUrl, trangThai) {
    document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit me-2"></i>Chỉnh sửa sản phẩm';
    document.getElementById('btnSubmitText').textContent = 'Lưu thay đổi';
    document.getElementById('maSP').value = maSP;
    document.getElementById('tenSP').value = tenSP;
    document.getElementById('maLoaiSP').value = maLoaiSP;
    document.getElementById('thuongHieu').value = thuongHieu;
    document.getElementById('giaBan').value = giaBan;
    document.getElementById('soLuongTon').value = soLuongTon;
    document.getElementById('baoHanhThang').value = baoHanhThang;
    document.getElementById('moTaNgan').value = moTaNgan;
    document.getElementById('trangThai').value = trangThai;
    document.getElementById('anhUrl').value = anhUrl;
    if (anhUrl && anhUrl.trim() !== '') {
      showImagePreview(anhUrl);
    } else {
      resetImagePreview();
    }
    document.getElementById('editTechDetail').value = '';

    // Load tech specs via AJAX
    fetch('${pageContext.request.contextPath}/admin/products/techspec?id=' + maSP)
      .then(r => r.json())
      .then(data => {
        if (data && data.categoryId) {
          document.getElementById('editTechDetail').value = JSON.stringify(data.fields);
          renderTechSpecFields(data.categoryId);
        }
      })
      .catch(() => {});

    $('#modalProduct').modal('show');
  }

  function previewFile(input) {
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = e => showImagePreview(e.target.result);
      reader.readAsDataURL(input.files[0]);
    }
  }

  function previewFromUrl(url) {
    if (url && url.trim().startsWith('http')) {
      showImagePreview(url);
    } else {
      resetImagePreview();
    }
  }

  function showImagePreview(src) {
    const preview = document.getElementById('imagePreview');
    const placeholder = document.getElementById('imagePlaceholder');
    preview.src = src;
    preview.classList.add('show');
    placeholder.style.display = 'none';
  }

  function resetImagePreview() {
    const preview = document.getElementById('imagePreview');
    const placeholder = document.getElementById('imagePlaceholder');
    preview.src = '';
    preview.classList.remove('show');
    placeholder.style.display = 'flex';
  }

  function confirmDelete(tenSP) {
    return confirm('Bạn có chắc muốn xóa sản phẩm:\n"' + tenSP + '"?\nHành động này không thể hoàn tác!');
  }

  // Auto-close alerts after 4s
  setTimeout(() => {
    document.querySelectorAll('.alert').forEach(el => {
      $(el).alert('close');
    });
  }, 4000);
</script>
