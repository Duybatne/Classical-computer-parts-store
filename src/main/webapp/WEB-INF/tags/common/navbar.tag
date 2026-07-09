<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Navbar Start -->
<div class="container-fluid nav-bar p-0">
  <div class="container-fluid px-5">
    <nav class="navbar navbar-expand-lg navbar-dark p-0">
      <a href="${pageContext.request.contextPath}/home" class="navbar-brand d-block d-lg-none p-0">
        <h4 class="text-white m-0">
          <i class="fas fa-shopping-bag text-secondary me-2"></i>ComputerSpace
        </h4>
      </a>
      <button class="navbar-toggler border-0 ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
        <span class="fa fa-bars"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarCollapse">
        <div class="navbar-nav ms-auto py-0">
          <a href="${pageContext.request.contextPath}/home"
             class="nav-item nav-link ${activePage == 'home' ? 'active' : ''}">Home</a>
          <a href="${pageContext.request.contextPath}/products"
             class="nav-item nav-link ${activePage == 'products' ? 'active' : ''}">Shop</a>
          <div class="nav-item dropdown">
            <a href="#" class="nav-link dropdown-toggle ${activePage == 'pages' ? 'active' : ''}"
               data-bs-toggle="dropdown">Pages</a>
            <div class="dropdown-menu m-0 rounded">
              <a href="${pageContext.request.contextPath}/promotions" class="dropdown-item">Bestseller</a>
              <a href="${pageContext.request.contextPath}/builder" class="dropdown-item">Build PC</a>
              <a href="${pageContext.request.contextPath}/cart" class="dropdown-item">Cart Page</a>
              <a href="${pageContext.request.contextPath}/checkout" class="dropdown-item">Checkout</a>
              <a href="${pageContext.request.contextPath}/contact" class="dropdown-item">Contact</a>
              <a href="${pageContext.request.contextPath}/404.jsp" class="dropdown-item">404 Page</a>
            </div>
          </div>
          <a href="${pageContext.request.contextPath}/contact"
             class="nav-item nav-link ${activePage == 'contact' ? 'active' : ''}">Contact</a>
        </div>
      </div>
    </nav>
  </div>
</div>
<!-- Navbar End -->
