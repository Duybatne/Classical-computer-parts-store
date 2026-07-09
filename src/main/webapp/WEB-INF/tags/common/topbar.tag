<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- GEARVN Topbar Start -->
<div class="gearvn-topbar d-none d-lg-block">
  <div class="container-fluid px-5">
    <div class="row gx-0 align-items-center">
      <div class="col-lg-8 topbar-left">
        <a href="${pageContext.request.contextPath}/home"><i class="fa fa-home me-1"></i> Trang chủ</a>
        <a href="${pageContext.request.contextPath}/products"><i class="fa fa-th-list me-1"></i> Danh mục</a>
        <a href="${pageContext.request.contextPath}/builder"><i class="fa fa-desktop me-1"></i> Build PC</a>
        <a href="${pageContext.request.contextPath}/contact"><i class="fa fa-comments me-1"></i> Tư vấn</a>
      </div>
      <div class="col-lg-4 topbar-right">
        <div class="user-dropdown">
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <div class="dropdown">
                <button class="dropdown-toggle" data-bs-toggle="dropdown">
                  <i class="fa fa-user me-1"></i> ${sessionScope.user.hoTen}
                </button>
                <div class="dropdown-menu dropdown-menu-end rounded">
                  <a href="${pageContext.request.contextPath}/profile" class="dropdown-item"><i class="fa fa-user me-2"></i>My Account</a>
                  <a href="${pageContext.request.contextPath}/orders" class="dropdown-item"><i class="fa fa-history me-2"></i>Orders</a>
                  <c:if test="${sessionScope.user.vaiTro == 'QUAN_TRI_VIEN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="dropdown-item"><i class="fa fa-shield me-2"></i>Admin</a>
                  </c:if>
                  <div class="dropdown-divider"></div>
                  <a href="${pageContext.request.contextPath}/logout" class="dropdown-item"><i class="fa fa-sign-out me-2"></i>Log Out</a>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="dropdown">
                <button class="dropdown-toggle" data-bs-toggle="dropdown">
                  <i class="fa fa-user me-1"></i> Tài khoản
                </button>
                <div class="dropdown-menu dropdown-menu-end rounded">
                  <a href="${pageContext.request.contextPath}/login" class="dropdown-item"><i class="fa fa-sign-in me-2"></i>Login</a>
                  <a href="${pageContext.request.contextPath}/register" class="dropdown-item"><i class="fa fa-user-plus me-2"></i>Register</a>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- GEARVN Topbar End -->

<!-- GEARVN Header/Middle Start -->
<div class="gearvn-header">
  <div class="container-fluid px-5">
    <div class="row align-items-center">
      <div class="col-lg-3 col-md-4 col-6 logo">
        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
          <h1 class="display-6 m-0">
            <i class="fas fa-shopping-bag me-2"></i><span>Computer</span>Space
          </h1>
        </a>
      </div>
      <div class="col-lg-6 col-md-4 d-none d-md-block search-box">
        <form action="${pageContext.request.contextPath}/products" method="get">
          <input type="text" name="q" placeholder="Bạn cần tìm gì?" value="${param.q}">
          <button type="submit"><i class="fas fa-search"></i></button>
        </form>
      </div>
      <div class="col-lg-3 col-md-4 col-6 header-actions">
        <a href="${pageContext.request.contextPath}/cart" class="action-item">
          <i class="fas fa-shopping-cart"></i>
          <c:if test="${not empty cartCount && cartCount > 0}">
            <span class="cart-badge">${cartCount}</span>
          </c:if>
          <div class="action-text d-none d-xl-flex">
            <small>Giỏ hàng</small>
            <strong>
              <c:choose>
                <c:when test="${not empty cartTotal}">
                  <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫" />
                </c:when>
                <c:otherwise>0₫</c:otherwise>
              </c:choose>
            </strong>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>
<!-- GEARVN Header/Middle End -->
