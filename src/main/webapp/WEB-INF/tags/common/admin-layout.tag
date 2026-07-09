<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="title" required="true" rtexprvalue="true" %>
<%@ attribute name="activePage" required="true" rtexprvalue="true" %>
<%@ attribute name="extraCSS" required="false" rtexprvalue="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <base href="${pageContext.request.contextPath}/"/>
  <title>${title} - Admin</title>

  <!-- SB Admin 2 base CSS -->
  <link href="admin-asset/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
  <link href="admin-asset/css/sb-admin-2.min.css" rel="stylesheet">

  <!-- Extra page-specific CSS -->
  <c:if test="${not empty extraCSS}">
    ${extraCSS}
  </c:if>
</head>
<body id="page-top">

<div id="wrapper">

  <!-- ===================== SIDEBAR ===================== -->
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${pageContext.request.contextPath}/admin/dashboard">
      <div class="sidebar-brand-icon rotate-n-15">
        <i class="fas fa-laugh-wink"></i>
      </div>
      <div class="sidebar-brand-text mx-3">ComputerSpace</div>
    </a>

    <hr class="sidebar-divider my-0">

    <li class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fas fa-fw fa-tachometer-alt"></i>
        <span>Dashboard</span>
      </a>
    </li>

    <hr class="sidebar-divider">

    <div class="sidebar-heading">Manage</div>

    <li class="nav-item ${activePage == 'products' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
        <i class="fas fa-fw fa-store"></i>
        <span>Sản phẩm</span>
      </a>
    </li>

    <li class="nav-item ${activePage == 'orders' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
        <i class="fas fa-fw fa-shopping-cart"></i>
        <span>Đơn hàng</span>
      </a>
    </li>

    <li class="nav-item ${activePage == 'promotions' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/promotions">
        <i class="fas fa-fw fa-tags"></i>
        <span>Khuyến mãi</span>
      </a>
    </li>

    <li class="nav-item ${activePage == 'accounts' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/accounts">
        <i class="fas fa-fw fa-user-friends"></i>
        <span>Tài khoản</span>
      </a>
    </li>

    <li class="nav-item ${activePage == 'reviews' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/reviews">
        <i class="fas fa-fw fa-comments"></i>
        <span>Đánh giá</span>
      </a>
    </li>

    <li class="nav-item ${activePage == 'reports' ? 'active' : ''}">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
        <i class="fas fa-fw fa-chart-bar"></i>
        <span>Báo cáo & Thống kê</span>
      </a>
    </li>

    <hr class="sidebar-divider d-none d-md-block">

    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

  </ul>
  <!-- =================== END SIDEBAR =================== -->

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">

      <!-- ===================== TOPBAR ===================== -->
      <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3" type="button">
          <i class="fa fa-bars"></i>
        </button>
        <ul class="navbar-nav ml-auto">
          <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                ${sessionScope.adminName != null ? sessionScope.adminName : 'Admin'}
              </span>
              <img class="img-profile rounded-circle" src="admin-asset/img/undraw_profile.svg" />
            </a>
            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
              <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-tachometer-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                Dashboard
              </a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                Logout
              </a>
            </div>
          </li>
        </ul>
      </nav>
      <!-- =================== END TOPBAR =================== -->

      <div class="container-fluid">
        <jsp:doBody/>
      </div>

    </div>

    <!-- Footer -->
    <footer class="sticky-footer bg-white">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>Copyright &copy; ComputerSpace</span>
        </div>
      </div>
    </footer>

  </div>

</div>

<a class="scroll-to-top rounded" href="#page-top">
  <i class="fas fa-angle-up"></i>
</a>

<script src="admin-asset/vendor/jquery/jquery.min.js"></script>
<script src="admin-asset/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="admin-asset/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="admin-asset/js/sb-admin-2.min.js"></script>

</body>
</html>
