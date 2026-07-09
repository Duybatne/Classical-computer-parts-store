<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Mobile Bottom Navigation Start -->
<div class="mobile-bottom-nav">
  <div class="nav-items">
    <a href="${pageContext.request.contextPath}/home"
       class="nav-item ${activePage == 'home' ? 'active' : ''}">
      <i class="fas fa-home"></i>
      <span>Trang chủ</span>
    </a>
    <a href="${pageContext.request.contextPath}/products"
       class="nav-item ${activePage == 'products' ? 'active' : ''}">
      <i class="fas fa-th-list"></i>
      <span>Danh mục</span>
    </a>
    <a href="${pageContext.request.contextPath}/builder"
       class="nav-item ${activePage == 'builder' ? 'active' : ''}">
      <i class="fas fa-desktop"></i>
      <span>Build PC</span>
    </a>
    <a href="${pageContext.request.contextPath}/contact"
       class="nav-item ${activePage == 'contact' ? 'active' : ''}">
      <i class="fas fa-comments"></i>
      <span>Tư vấn</span>
    </a>
    <c:choose>
      <c:when test="${not empty sessionScope.user}">
        <a href="${pageContext.request.contextPath}/profile"
           class="nav-item ${activePage == 'profile' ? 'active' : ''}">
          <i class="fas fa-user"></i>
          <span>Tài khoản</span>
        </a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login"
           class="nav-item ${activePage == 'login' ? 'active' : ''}">
          <i class="fas fa-user"></i>
          <span>Tài khoản</span>
        </a>
      </c:otherwise>
    </c:choose>
  </div>
</div>
<!-- Mobile Bottom Navigation End -->
