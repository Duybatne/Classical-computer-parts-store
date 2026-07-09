<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="${product.tenSP}" activePage="product">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">${product.tenSP}</h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Products</a></li>
        <li class="breadcrumb-item active text-white">${product.tenSP}</li>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Single Product Start -->
    <div class="container-fluid py-5">
      <div class="container py-5">
        <c:choose>
          <c:when test="${not empty product}">
            <div class="row g-4">
              <!-- Left Column: Product Image -->
              <div class="col-lg-5">
                <div class="border rounded p-3">
                  <c:choose>
                    <c:when test="${not empty product.anhChinh}">
                      <img src="${pageContext.request.contextPath}${fn:startsWith(product.anhChinh, '/') ? '' : '/'}${product.anhChinh}"
                           class="img-fluid w-100 rounded"
                           alt="${product.tenSP}"
                           onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/no-image.png';">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/img/product-3.png"
                           class="img-fluid w-100 rounded"
                           alt="${product.tenSP}"
                           onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/no-image.png';">
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- Right Column: Product Info -->
              <div class="col-lg-7">
                <h1 class="display-6 mb-2">${product.tenSP}</h1>

                <!-- Badges -->
                <div class="mb-3">
                  <c:if test="${not empty product.thuongHieu}">
                    <span class="badge bg-secondary me-1">${product.thuongHieu}</span>
                  </c:if>
                  <c:if test="${not empty categoryName}">
                    <span class="badge bg-info me-1">${categoryName}</span>
                  </c:if>
                  <span class="badge bg-${product.soLuongTon > 0 ? 'success' : 'danger'}">
                    <c:choose>
                      <c:when test="${product.soLuongTon > 0}">In Stock (${product.soLuongTon})</c:when>
                      <c:otherwise>Out of Stock</c:otherwise>
                    </c:choose>
                  </span>
                </div>

                <!-- Price & Promotion -->
                <c:choose>
                  <c:when test="${not empty discountedPrice && discountedPrice < product.giaBan}">
                    <div class="mb-3">
                      <span class="text-decoration-line-through text-muted me-2">
                        <fmt:formatNumber value="${product.giaBan}" type="currency" currencySymbol="₫" />
                      </span>
                      <span class="badge bg-danger fs-6">
                        <fmt:formatNumber value="${((product.giaBan - discountedPrice) / product.giaBan * 100)}" type="number" maxFractionDigits="0"/>% OFF
                      </span>
                    </div>
                    <h2 class="fw-bold text-danger mb-3">
                      <fmt:formatNumber value="${discountedPrice}" type="currency" currencySymbol="₫" />
                    </h2>
                  </c:when>
                  <c:otherwise>
                    <h2 class="fw-bold text-primary mb-3">
                      <fmt:formatNumber value="${product.giaBan}" type="currency" currencySymbol="₫" />
                    </h2>
                  </c:otherwise>
                </c:choose>

                <!-- Rating -->
                <div class="d-flex align-items-center mb-3">
                  <div class="text-warning me-2">
                    <c:forEach begin="1" end="5" var="i">
                      <c:choose>
                        <c:when test="${i <= fn:substringBefore(avgRating, '.')}">
                          <i class="fas fa-star"></i>
                        </c:when>
                        <c:when test="${i - fn:substringBefore(avgRating, '.') == 1 && fn:substringAfter(avgRating, '.') >= '5'}">
                          <i class="fas fa-star-half-alt"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="far fa-star"></i>
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                  </div>
                  <span class="text-muted">(${totalReviews} reviews)</span>
                </div>

                <!-- Short Description -->
                <p class="mb-3">${product.moTaNgan}</p>

                <!-- Warranty & Stock -->
                <p class="mb-1"><strong>Warranty:</strong> ${product.baoHanhThang} months</p>

                <!-- Add to Cart -->
                <div class="d-flex gap-3 mt-4 flex-wrap">
                  <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center gap-2">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="maSP" value="${product.maSP}">
                    <input type="number" name="quantity" value="1" min="1" max="${product.soLuongTon}" class="form-control" style="width: 80px;">
                    <button type="submit" class="btn btn-primary rounded-pill py-3 px-5" ${product.soLuongTon <= 0 ? 'disabled' : ''}>
                      <i class="fas fa-shopping-cart me-2"></i> Thêm vào giỏ
                    </button>
                  </form>
                </div>
              </div>
            </div>

            <!-- Product Tabs -->
            <div class="row mt-5">
              <div class="col-12">
                <ul class="nav nav-tabs" id="productTabs" role="tablist">
                  <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab">
                      <i class="fas fa-align-left me-1"></i> Description
                    </button>
                  </li>
                  <li class="nav-item" role="presentation">
                    <button class="nav-link" id="specs-tab" data-bs-toggle="tab" data-bs-target="#specs" type="button" role="tab">
                      <i class="fas fa-microchip me-1"></i> Technical Specs
                    </button>
                  </li>
                  <li class="nav-item" role="presentation">
                    <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab">
                      <i class="fas fa-star me-1"></i> Reviews (${totalReviews})
                    </button>
                  </li>
                </ul>

                <div class="tab-content p-4 border border-top-0 rounded-bottom" id="productTabsContent">
                  <!-- Tab 1: Description -->
                  <div class="tab-pane fade show active" id="description" role="tabpanel">
                    <div class="mt-2">
                      <p>${product.moTaChiTiet}</p>
                    </div>
                  </div>

                  <!-- Tab 2: Technical Specs -->
                  <div class="tab-pane fade" id="specs" role="tabpanel">
                    <c:choose>
                      <c:when test="${not empty techDetail}">
                        <div class="table-responsive">
                          <table class="table table-striped table-hover">
                            <tbody>
                              <c:forEach items="${techDetail}" var="entry">
                                <tr>
                                  <td class="fw-bold" style="width: 200px;">${entry.key}</td>
                                  <td>${entry.value}</td>
                                </tr>
                              </c:forEach>
                            </tbody>
                          </table>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <p class="text-muted">No technical specifications available.</p>
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <!-- Tab 3: Reviews -->
                  <div class="tab-pane fade" id="reviews" role="tabpanel">
                    <!-- Rating Summary -->
                    <div class="row mb-4">
                      <div class="col-md-4 text-center">
                        <h1 class="display-4 text-warning">${avgRating}</h1>
                        <div class="text-warning mb-1">
                          <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                              <c:when test="${i <= fn:substringBefore(avgRating, '.')}">
                                <i class="fas fa-star"></i>
                              </c:when>
                              <c:when test="${i - fn:substringBefore(avgRating, '.') == 1 && fn:substringAfter(avgRating, '.') >= '5'}">
                                <i class="fas fa-star-half-alt"></i>
                              </c:when>
                              <c:otherwise>
                                <i class="far fa-star"></i>
                              </c:otherwise>
                            </c:choose>
                          </c:forEach>
                        </div>
                        <p class="text-muted">${totalReviews} reviews</p>
                      </div>
                    </div>

                    <!-- Review List -->
                    <c:choose>
                      <c:when test="${not empty reviews}">
                        <c:forEach items="${reviews}" var="review">
                          <div class="card mb-3 border-0 shadow-sm">
                            <div class="card-body">
                              <div class="d-flex justify-content-between">
                                <div>
                                  <strong>${review.tenKhachHang}</strong>
                                  <div class="text-warning">
                                    <c:forEach begin="1" end="${review.soSao}">
                                      <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:forEach begin="${review.soSao + 1}" end="5">
                                      <i class="far fa-star"></i>
                                    </c:forEach>
                                  </div>
                                </div>
                                <small class="text-muted">${review.ngayDanhGia}</small>
                              </div>
                              <p class="mt-2 mb-0">${review.noiDung}</p>
                            </div>
                          </div>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <div class="text-center py-4">
                          <p class="text-muted">No reviews yet. Be the first to review this product!</p>
                        </div>
                      </c:otherwise>
                    </c:choose>

                    <!-- Review Messages -->
                    <c:if test="${not empty sessionScope.reviewSuccess}">
                      <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.reviewSuccess}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                      </div>
                      <c:remove var="reviewSuccess" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.reviewError}">
                      <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.reviewError}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                      </div>
                      <c:remove var="reviewError" scope="session"/>
                    </c:if>

                    <!-- Write Review Form -->
                    <c:if test="${not empty sessionScope.user}">
                      <div class="mt-4 p-4 bg-light rounded">
                        <h5><i class="fas fa-pen me-2"></i>Write a Review</h5>
                        <form action="${pageContext.request.contextPath}/review" method="post">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="action" value="add">
                          <input type="hidden" name="maSP" value="${product.maSP}">
                          <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="rating-stars">
                              <c:forEach begin="1" end="5" var="i">
                                <span class="star-rating" data-value="${i}" style="cursor:pointer; font-size:24px; color:#ddd;">
                                  <i class="fas fa-star"></i>
                                </span>
                              </c:forEach>
                              <input type="hidden" name="rating" id="ratingValue" value="5">
                            </div>
                          </div>
                          <div class="mb-3">
                            <label class="form-label">Your Review</label>
<textarea name="comment" class="form-control" rows="3" placeholder="Share your thoughts about this product..." required></textarea>
                          </div>
                          <button type="submit" class="btn btn-primary rounded-pill px-4">
                            <i class="fas fa-paper-plane me-1"></i> Submit Review
                          </button>
                        </form>
                      </div>
                    </c:if>
                    <c:if test="${empty sessionScope.user}">
                      <div class="mt-4 p-4 bg-light rounded text-center">
                        <p>Please <a href="${pageContext.request.contextPath}/login">login</a> to write a review.</p>
                      </div>
                    </c:if>
                  </div>
                </div>
              </div>
            </div>

            <!-- Related Products -->
            <c:if test="${not empty relatedProducts}">
              <div class="mt-5">
                <h3 class="mb-4"><i class="fas fa-tags me-2"></i>Related Products</h3>
                <div class="row g-4">
                  <c:forEach items="${relatedProducts}" var="rp">
                    <div class="col-md-6 col-lg-4 col-xl-2">
                      <div class="card h-100 border-0 shadow-sm">
                        <a href="${pageContext.request.contextPath}/product?id=${rp.maSP}">
                          <img src="${not empty rp.anhChinh ? pageContext.request.contextPath.concat(fn:startsWith(rp.anhChinh, '/') ? '' : '/').concat(rp.anhChinh) : pageContext.request.contextPath.concat('/img/product-3.png')}"
                               class="card-img-top p-3"
                               alt="${rp.tenSP}"
                               style="height: 150px; object-fit: contain;"
                               onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/no-image.png';">
                        </a>
                        <div class="card-body text-center">
                          <a href="${pageContext.request.contextPath}/product?id=${rp.maSP}" class="text-decoration-none">
                            <h6 class="card-title text-dark text-truncate">${rp.tenSP}</h6>
                          </a>
                          <p class="text-primary fw-bold mb-0">
                            <fmt:formatNumber value="${rp.giaBan}" type="currency" currencySymbol="₫" />
                          </p>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </c:if>

          </c:when>
          <c:otherwise>
            <div class="text-center py-5">
              <h2>Product not found</h2>
              <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill mt-3">
                Back to Products
              </a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <!-- Single Product End -->

    <!-- Star Rating JavaScript -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
      const stars = document.querySelectorAll('.star-rating');
      const ratingInput = document.getElementById('ratingValue');

      stars.forEach(function(star) {
        star.addEventListener('click', function() {
          const value = this.getAttribute('data-value');
          ratingInput.value = value;

          // Update visual
          stars.forEach(function(s, index) {
            if (index < value) {
              s.style.color = '#ffc107';
            } else {
              s.style.color = '#ddd';
            }
          });
        });

        // Hover effect
        star.addEventListener('mouseenter', function() {
          const value = this.getAttribute('data-value');
          stars.forEach(function(s, index) {
            if (index < value) {
              s.style.color = '#ffc107';
            } else {
              s.style.color = '#ddd';
            }
          });
        });

        star.addEventListener('mouseleave', function() {
          const currentValue = ratingInput.value;
          stars.forEach(function(s, index) {
            if (index < currentValue) {
              s.style.color = '#ffc107';
            } else {
              s.style.color = '#ddd';
            }
          });
        });
      });
    });
    </script>

  </jsp:body>
</t:main>
