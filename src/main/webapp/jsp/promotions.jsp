<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Promotions" activePage="pages">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">Bestseller & Promotions</h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item"><a href="#">Pages</a></li>
        <li class="breadcrumb-item active text-white">Promotions</li>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Promotions Start -->
    <div class="container-fluid product py-5">
      <div class="container py-5">
        <c:if test="${not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:choose>
          <c:when test="${not empty promotions}">
            <div class="row g-4">
              <c:forEach var="promo" items="${promotions}" varStatus="loop">
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="${0.1 + (loop.index * 0.1)}s">
                  <div class="bg-light rounded p-4 h-100">
                    <div class="d-flex justify-content-between mb-3">
                      <h4 class="text-primary">${promo.tenKM}</h4>
                      <c:choose>
                        <c:when test="${promo.loaiGiam == 'PHAN_TRAM'}">
                          <span class="badge bg-danger fs-6">-${promo.giaTriGiam}%</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-danger fs-6">-<fmt:formatNumber value="${promo.giaTriGiam}" type="currency" currencySymbol="₫"/></span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <p class="text-muted mb-2">
                      Valid: <fmt:formatDate value="${promo.ngayBatDau}" pattern="MMM dd, yyyy" />
                      - <fmt:formatDate value="${promo.ngayKetThuc}" pattern="MMM dd, yyyy" />
                    </p>
                    <c:if test="${promo.trangThai}">
                      <span class="badge bg-success">Active</span>
                    </c:if>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-5">
              <h4>No promotions available</h4>
              <p class="text-muted">Check back later for new deals and discounts!</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <!-- Promotions End -->

  </jsp:body>
</t:main>
