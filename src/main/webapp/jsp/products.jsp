<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="${not empty param.category ? param.category : (not empty param.q ? 'Search: '.concat(param.q) : 'Products')}" activePage="products">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">
        <c:choose>
          <c:when test="${not empty param.category}">
            <i class="fas fa-tag me-2"></i>${param.category}
          </c:when>
          <c:when test="${not empty param.q}">
            <i class="fas fa-search me-2"></i>Tìm kiếm: "${param.q}"
          </c:when>
          <c:otherwise>
            <i class="fas fa-store me-2"></i>All Products
          </c:otherwise>
        </c:choose>
      </h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item active text-white">
          <c:choose>
            <c:when test="${not empty param.category}">
              <a href="${pageContext.request.contextPath}/products" class="text-white-50">Products</a>
            </c:when>
            <c:otherwise>Products</c:otherwise>
          </c:choose>
        </li>
        <c:if test="${not empty param.category}">
          <li class="breadcrumb-item active text-white">${param.category}</li>
        </c:if>
        <c:if test="${not empty param.q}">
          <li class="breadcrumb-item active text-white">Search: "${param.q}"</li>
        </c:if>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Shop Page Start -->
    <div class="container-fluid shop py-5">
      <div class="container py-5">
        <div class="row g-4">

          <!-- Sidebar Start -->
          <div class="col-lg-3 wow fadeInUp" data-wow-delay="0.1s">

            <!-- Categories -->
            <div class="product-categories mb-4">
              <h4><i class="fas fa-list me-2 text-primary"></i>Categories</h4>
              <ul class="list-unstyled">
                <c:set var="isAll" value="${empty param.category and empty param.q}"/>
                <li>
                  <div class="categories-item ${isAll ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/products${not empty sort ? '?sort='.concat(sort) : ''}" class="${isAll ? 'text-danger fw-bold' : 'text-dark'}">
                      <i class="fas fa-th-large me-2"></i> All Products
                    </a>
                    <span class="badge badge-primary badge-pill">${totalProducts}</span>
                  </div>
                </li>
                <c:forEach var="cat" items="${categories}">
                  <c:set var="isActive" value="${param.category == cat.tenLoaiSP}"/>
                  <li>
                    <div class="categories-item ${isActive ? 'active' : ''}">
                      <a href="${pageContext.request.contextPath}/products?category=${cat.tenLoaiSP}${not empty sort ? '&sort='.concat(sort) : ''}"
                         class="${isActive ? 'text-danger fw-bold' : 'text-dark'}">
                        <i class="fas fa-chevron-right me-2 text-secondary"></i> ${cat.tenLoaiSP}
                      </a>
                      <span class="badge badge-primary badge-pill">${cat.soLuongSP}</span>
                    </div>
                  </li>
                </c:forEach>
              </ul>
            </div>

            <!-- Brands / Popular Tags -->
            <div class="product-tags py-4">
              <h4 class="mb-3"><i class="fas fa-tags me-2 text-primary"></i>Brands</h4>
              <div class="product-tags-items bg-light rounded p-3">
                <c:set var="brands" value="Intel,AMD,ASUS,MSI,Gigabyte,NVIDIA,Corsair,Samsung,Sapphire,DeepCool,Seasonic,Cooler Master"/>
                <c:forTokens var="brand" items="${brands}" delims=",">
                  <a href="${pageContext.request.contextPath}/products?q=${brand}"
                     class="border rounded py-1 px-2 mb-2 d-inline-block ${param.q == brand ? 'bg-primary text-white' : ''}">
                    ${brand}
                  </a>
                </c:forTokens>
              </div>
            </div>

          </div>
          <!-- Sidebar End -->

          <!-- Products Grid Start -->
          <div class="col-lg-9 wow fadeInUp" data-wow-delay="0.1s">

            <!-- Banner -->
            <div class="rounded mb-4 position-relative">
              <img src="${pageContext.request.contextPath}/img/product-banner-3.jpg"
                   class="img-fluid rounded w-100" style="height: 250px; object-fit: cover;" alt="Banner">
              <div class="position-absolute rounded d-flex flex-column align-items-center justify-content-center text-center"
                   style="width: 100%; height: 250px; top: 0; left: 0; background: rgba(218, 37, 29, 0.3);">
                <h4 class="display-5 text-primary">SALE</h4>
                <h3 class="display-4 text-white mb-4">Get UP To 50% Off</h3>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill">Shop Now</a>
              </div>
            </div>

            <!-- Toolbar: Search + Sort + Info -->
            <div class="row g-4 mb-4">
              <div class="col-xl-5">
                <form action="${pageContext.request.contextPath}/products" method="get" class="input-group w-100 mx-auto d-flex">
                  <input type="search" class="form-control p-3" name="q" placeholder="Search products, brands..."
                         value="${param.q}" aria-describedby="search-icon-1">
                  <c:if test="${not empty param.category}">
                    <input type="hidden" name="category" value="${param.category}">
                  </c:if>
                  <c:if test="${not empty sort}">
                    <input type="hidden" name="sort" value="${sort}">
                  </c:if>
                  <button type="submit" id="search-icon-1" class="input-group-text p-3"><i class="fa fa-search"></i></button>
                </form>
              </div>
              <div class="col-xl-4 d-flex align-items-center">
                <c:if test="${not empty products}">
                  <small class="text-muted">
                    <i class="fas fa-eye me-1"></i>
                    Showing <fmt:formatNumber value="${(currentPage - 1) * fn:length(products) + 1}"/>–
                    <fmt:formatNumber value="${(currentPage - 1) * fn:length(products) + fn:length(products)}"/>
                    of <fmt:formatNumber value="${totalProducts}"/> products
                  </small>
                </c:if>
              </div>
              <div class="col-xl-3 text-end">
                <div class="bg-light ps-3 py-3 rounded d-flex justify-content-between">
                  <label for="sort" class="mb-0"><i class="fas fa-sort me-1"></i>Sort:</label>
                  <select id="sort" name="sort" class="border-0 form-select-sm bg-light me-3"
                          onchange="window.location.href='${pageContext.request.contextPath}/products?sort='+this.value
                            + '${not empty param.category ? '&category='.concat(param.category) : ''}'
                            + '${not empty param.q ? '&q='.concat(param.q) : ''}'">
                    <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Newest</option>
                    <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                    <option value="name" ${sort == 'name' ? 'selected' : ''}>Name A-Z</option>
                    <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Name Z-A</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Active Filters Bar -->
            <c:if test="${not empty param.category or not empty param.q}">
              <div class="mb-3 d-flex align-items-center gap-2">
                <small class="text-muted me-2"><i class="fas fa-filter me-1"></i>Active filters:</small>
                <c:if test="${not empty param.category}">
                  <span class="badge bg-primary p-2">
                    <i class="fas fa-tag me-1"></i>${param.category}
                    <a href="${pageContext.request.contextPath}/products${not empty param.q ? '?q='.concat(param.q) : ''}${not empty sort ? (empty param.q ? '?sort=' : '&sort=').concat(sort) : ''}"
                       class="text-white ms-1 text-decoration-none"><i class="fas fa-times"></i></a>
                  </span>
                </c:if>
                <c:if test="${not empty param.q}">
                  <span class="badge bg-info p-2">
                    <i class="fas fa-search me-1"></i>"${param.q}"
                    <a href="${pageContext.request.contextPath}/products${not empty param.category ? '?category='.concat(param.category) : ''}${not empty sort ? (empty param.category ? '?sort=' : '&sort=').concat(sort) : ''}"
                       class="text-white ms-1 text-decoration-none"><i class="fas fa-times"></i></a>
                  </span>
                </c:if>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-outline-secondary">
                  <i class="fas fa-redo me-1"></i>Clear all
                </a>
              </div>
            </c:if>

            <!-- Product Grid -->
            <div class="row g-3">
              <c:choose>
                <c:when test="${not empty products}">
                  <c:forEach var="p" items="${products}" varStatus="loop">
                    <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <div class="col-12 text-center py-5">
                    <i class="fas fa-box-open fa-4x text-muted mb-3 d-block"></i>
                    <h4 class="text-muted">No products found</h4>
                    <p class="text-muted">
                      <c:choose>
                        <c:when test="${not empty param.q}">
                          No results for "<strong>${param.q}</strong>". Try a different keyword.
                        </c:when>
                        <c:when test="${not empty param.category}">
                          No products in category "<strong>${param.category}</strong>" yet.
                        </c:when>
                        <c:otherwise>No products available.</c:otherwise>
                      </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill py-2 px-4 mt-2">
                      <i class="fas fa-th-large me-1"></i>View All Products
                    </a>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
              <div class="col-12 wow fadeInUp" data-wow-delay="0.1s">
                <nav>
                  <ul class="pagination justify-content-center mt-5">
                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                      <a class="page-link rounded"
                         href="${pageContext.request.contextPath}/products?page=${currentPage - 1}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.q ? '&q='.concat(param.q) : ''}${not empty sort ? '&sort='.concat(sort) : ''}">
                        <i class="fas fa-chevron-left"></i>
                      </a>
                    </li>

                    <%-- Calculate page range to show --%>
                    <c:set var="startPage" value="${currentPage - 2}"/>
                    <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>
                    <c:set var="endPage" value="${startPage + 4}"/>
                    <c:if test="${endPage > totalPages}"><c:set var="endPage" value="${totalPages}"/></c:if>
                    <c:if test="${endPage - startPage < 4}"><c:set var="startPage" value="${endPage - 4}"/></c:if>
                    <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>

                    <c:if test="${startPage > 1}">
                      <li class="page-item">
                        <a class="page-link rounded" href="${pageContext.request.contextPath}/products?page=1${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.q ? '&q='.concat(param.q) : ''}${not empty sort ? '&sort='.concat(sort) : ''}">1</a>
                      </li>
                      <li class="page-item disabled"><span class="page-link rounded">...</span></li>
                    </c:if>

                    <c:forEach begin="${startPage}" end="${endPage}" var="pg">
                      <li class="page-item ${pg == currentPage ? 'active' : ''}">
                        <a class="page-link rounded"
                           href="${pageContext.request.contextPath}/products?page=${pg}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.q ? '&q='.concat(param.q) : ''}${not empty sort ? '&sort='.concat(sort) : ''}">${pg}</a>
                      </li>
                    </c:forEach>

                    <c:if test="${endPage < totalPages}">
                      <li class="page-item disabled"><span class="page-link rounded">...</span></li>
                      <li class="page-item">
                        <a class="page-link rounded" href="${pageContext.request.contextPath}/products?page=${totalPages}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.q ? '&q='.concat(param.q) : ''}${not empty sort ? '&sort='.concat(sort) : ''}">${totalPages}</a>
                      </li>
                    </c:if>

                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                      <a class="page-link rounded"
                         href="${pageContext.request.contextPath}/products?page=${currentPage + 1}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.q ? '&q='.concat(param.q) : ''}${not empty sort ? '&sort='.concat(sort) : ''}">
                        <i class="fas fa-chevron-right"></i>
                      </a>
                    </li>
                  </ul>
                </nav>
              </div>
            </c:if>

          </div>
          <!-- Products Grid End -->

        </div>
      </div>
    </div>
    <!-- Shop Page End -->

  </jsp:body>
</t:main>

<!-- Extra CSS for categories active state -->
<style>
  .categories-item {
    padding: 8px 12px;
    border-radius: 6px;
    transition: all 0.2s;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .categories-item:hover { background: #f8f9fa; }
  .categories-item.active { background: #fff3f3; }
  .categories-item a { text-decoration: none; flex: 1; font-size: 14px; }
  .categories-item .badge { font-size: 11px; }
</style>
