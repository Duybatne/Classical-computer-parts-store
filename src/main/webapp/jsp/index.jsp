<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="256kb" autoFlush="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Home" activePage="home">
  <jsp:attribute name="keywords">computer, laptop, hardware, electronics, gearvn</jsp:attribute>
  <jsp:attribute name="description">ComputerSpace - Your trusted store for computer hardware and electronics</jsp:attribute>
  <jsp:body>

    <!-- Countdown Banner Section Start -->
    <div class="countdown-banner">
      <div class="container">
        <div class="banner-tag"><i class="fas fa-bolt me-1"></i> Xem thêm khuyến mãi</div>
        <h2>Săn vé phá đảo - Deal không hề ảo</h2>
        <div class="countdown-timer" id="countdownTimer">
          <div class="time-block">
            <span class="num" id="days">09</span>
            <span class="label">Ngày</span>
          </div>
          <span class="time-sep">:</span>
          <div class="time-block">
            <span class="num" id="hours">10</span>
            <span class="label">Giờ</span>
          </div>
          <span class="time-sep">:</span>
          <div class="time-block">
            <span class="num" id="minutes">22</span>
            <span class="label">Phút</span>
          </div>
          <span class="time-sep">:</span>
          <div class="time-block">
            <span class="num" id="seconds">50</span>
            <span class="label">Giây</span>
          </div>
        </div>
        <div class="deal-tabs">
          <a href="${pageContext.request.contextPath}/products" class="deal-tab active">Đảo đa Deal</a>
          <a href="${pageContext.request.contextPath}/products?category=CPU" class="deal-tab">Deal CPU</a>
          <a href="${pageContext.request.contextPath}/products?category=VGA" class="deal-tab">Deal GPU</a>
          <a href="${pageContext.request.contextPath}/products?category=Case" class="deal-tab">Deal Ổ Cứng</a>
          <a href="${pageContext.request.contextPath}/products?category=RAM" class="deal-tab">Deal RAM</a>
        </div>
      </div>
    </div>
    <!-- Countdown Banner Section End -->

    <!-- Carousel Start -->
    <div class="container-fluid carousel bg-light px-0">
      <div class="row g-0 justify-content-end">
        <div class="col-12 col-lg-7 col-xl-9">
          <div class="header-carousel owl-carousel bg-light py-5">
            <div class="row g-0 header-carousel-item align-items-center">
              <div class="col-xl-6 carousel-img wow fadeInLeft" data-wow-delay="0.1s">
                <img src="img/CHIP.jpg" class="img-fluid w-100" alt="Image">
              </div>
              <div class="col-xl-6 carousel-content p-4">
                <h4 class="text-uppercase fw-bold mb-4 wow fadeInRight" data-wow-delay="0.1s"
                    style="letter-spacing: 3px;">Tiết kiệm đến 2.000.000 Đ</h4>
                <h1 class="display-3 text-capitalize mb-4 wow fadeInRight" data-wow-delay="0.3s">KHI LỰA CHỌN
                  BỘ XỬ LÝ INTEL ĐỜI MỚI  </h1>
                <p class="text-dark wow fadeInRight" data-wow-delay="0.5s">Terms and Condition Apply</p>
                <a class="btn btn-primary rounded-pill py-3 px-5 wow fadeInRight" data-wow-delay="0.7s"
                   href="${pageContext.request.contextPath}/products?category=CPU">MUA NGAY</a>
              </div>
            </div>
            <div class="row g-0 header-carousel-item align-items-center">
              <div class="col-xl-6 carousel-img wow fadeInLeft" data-wow-delay="0.1s">
                <img src="img/ocung.png" class="img-fluid w-100" alt="Image">
              </div>
              <div class="col-xl-6 carousel-content p-4">
                <h4 class="text-uppercase fw-bold mb-4 wow fadeInRight" data-wow-delay="0.1s"
                    style="letter-spacing: 3px;">Tiết kiệm đến 1.000.000 Đ</h4>
                <h1 class="display-3 text-capitalize mb-4 wow fadeInRight" data-wow-delay="0.3s">LỰA CHỌN MUA
                  RAM từ 16G và Ổ CỨNG từ 256GB </h1>
                <p class="text-dark wow fadeInRight" data-wow-delay="0.5s">Terms and Condition Apply</p>
                <a class="btn btn-primary rounded-pill py-3 px-5 wow fadeInRight" data-wow-delay="0.7s"
                   href="${pageContext.request.contextPath}/products">Mua Ngay</a>
              </div>
            </div>
          </div>
        </div>
        <div class="col-12 col-lg-5 col-xl-3 wow fadeInRight" data-wow-delay="0.1s">
          <div class="carousel-header-banner h-100">
            <img src="img/GPU.jpg" class="img-fluid w-100 h-100" style="object-fit: cover;" alt="Image">
            <div class="carousel-banner-offer">
              <p class="bg-primary text-white rounded fs-5 py-2 px-4 mb-0 me-3">Tiết kiệm 9.400.000Đ</p>
              <p class="text-primary fs-5 fw-bold mb-0">Special Offer</p>
            </div>
            <div class="carousel-banner">
              <div class="carousel-banner-content text-center p-4">
                <a href="#" class="d-block mb-2">GPU</a>
                <a href="#" class="d-block text-white fs-3">GEFORCE RTX 4090 <br>24GB G6X</a>
                <del class="me-2 text-white fs-5">35.900.000Đ</del>
                <span class="text-primary fs-5">26.500.000Đ</span>
              </div>
              <a href="#" class="btn btn-primary rounded-pill py-2 px-4">
                <i class="fas fa-shopping-cart me-2"></i> Add To Cart
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Carousel End -->

    <!-- Services Start -->
    <div class="container-fluid px-0">
      <div class="row g-0">
        <div class="col-6 col-md-4 col-lg-2 border-start border-end wow fadeInUp" data-wow-delay="0.1s">
          <div class="p-4">
            <div class="d-inline-flex align-items-center">
              <i class="fa fa-sync-alt fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Miễn Phí Đổi Trả</h6>
                <p class="mb-0">Đảm bảo hoàn trả tiền trong 30 ngày!</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.2s">
          <div class="p-4">
            <div class="d-flex align-items-center">
              <i class="fab fa-telegram-plane fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Miễn Phí Vận Chuyển</h6>
                <p class="mb-0">Miễn phí vận chuyển toàn quốc</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.3s">
          <div class="p-4">
            <div class="d-flex align-items-center">
              <i class="fas fa-life-ring fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Hỗ Trợ 24/7</h6>
                <p class="mb-0">Chung tôi hỗ trợ online 24 giờ trên ngày</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.4s">
          <div class="p-4">
            <div class="d-flex align-items-center">
              <i class="fas fa-credit-card fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Nhận các phần quà</h6>
                <p class="mb-0">Nhận các phần quà lên đến 50.000₫</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.5s">
          <div class="p-4">
            <div class="d-flex align-items-center">
              <i class="fas fa-lock fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Thanh toán bảo mật</h6>
                <p class="mb-0">Ưu tiên bảo mật</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.6s">
          <div class="p-4">
            <div class="d-flex align-items-center">
              <i class="fas fa-blog fa-2x text-primary"></i>
              <div class="ms-4">
                <h6 class="text-uppercase mb-2">Dịch vụ trực tuyến </h6>
                <p class="mb-0">Miễn phí trả sản phẩm trong vòng 30 ngày</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Services End -->

    <!-- Category Grid Icons Start -->
<div class="container-fluid py-4">
  <div class="container">
    <div class="section-header">
      <h2>Danh mục sản phẩm</h2>
    </div>
    <div class="category-grid">
      <!-- Thay fa-CPU bằng fa-microchip -->
      <a href="${pageContext.request.contextPath}/products?category=CPU" class="cat-item">
        <span class="cat-icon"><i class="fas fa-microchip"></i></span>
        <span>CPU</span>
      </a>
      <!-- Thay fa-GPU bằng fa-memory hoặc fa-vr-cardboard -->
      <a href="${pageContext.request.contextPath}/products?category=GPU" class="cat-item">
        <span class="cat-icon"><i class="fas fa-memory"></i></span>
        <span>GPU</span>
      </a>
      <!-- RAM có thể dùng fa-sd-card hoặc fa-memory -->
      <a href="${pageContext.request.contextPath}/products?category=RAM" class="cat-item">
        <span class="cat-icon"><i class="far fa-window-maximize"></i></span>
        <span>RAM</span>
      </a>
      <!-- Case dùng fa-hdd hoặc fa-box -->
      <a href="${pageContext.request.contextPath}/products?category=Case" class="cat-item">
        <span class="cat-icon"><i class="fas fa-box-open"></i></span>
        <span>Case</span>
      </a>
      <!-- Nguồn dùng fa-plug hoặc fa-bolt -->
      <a href="${pageContext.request.contextPath}/products?category=Nguồn" class="cat-item">
        <span class="cat-icon"><i class="fas fa-bolt"></i></span>
        <span>Nguồn</span>
      </a>
      <!-- Mainboard dùng fa-project-diagram hoặc fa-layer-group -->
      <a href="${pageContext.request.contextPath}/products?category=Mainboard" class="cat-item">
        <span class="cat-icon"><i class="fas fa-project-diagram"></i></span>
        <span>Mainboard</span>
      </a>
    </div>
  </div>
</div>

    <!-- Category Grid Icons End -->

    <!-- Featured Products Start -->
    <div class="container-fluid bg-light py-4">
      <div class="container">
        <div class="section-header">
          <h2>Sản phẩm nổi bật</h2>
          <a href="${pageContext.request.contextPath}/products" class="view-all">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
        </div>
        <div class="row g-3">
          <c:choose>
            <c:when test="${not empty featuredProducts}">
              <c:forEach var="p" items="${featuredProducts}" varStatus="loop">
                <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="col-12">
                <p class="text-muted mb-0">Hiện chưa có sản phẩm nổi bật.</p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
    <!-- Featured Products End -->
<!-- CPU Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>CPU bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=CPU" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingCPUs}">
          <c:forEach var="p" items="${bestSellingCPUs}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu CPU bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- CPU Best Seller End -->
<!-- GPU Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>GPU bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=VGA" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingGPUs}">
          <c:forEach var="p" items="${bestSellingGPUs}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu GPU bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- GPU Best Seller End -->
<!-- RAM Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>RAM bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=RAM" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingRAMs}">
          <c:forEach var="p" items="${bestSellingRAMs}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu RAM bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- RAM Best Seller End -->
<!-- Case Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>Case bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=Case" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingCases}">
          <c:forEach var="p" items="${bestSellingCases}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu Case bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- Case Best Seller End -->
<!-- PSU Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>Nguồn bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=Nguồn" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingPSUs}">
          <c:forEach var="p" items="${bestSellingPSUs}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu Nguồn bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- PSU Best Seller End -->
<!-- Mainboard Best Seller Start -->
<div class="container-fluid bg-light py-4">
  <div class="container">
    <div class="section-header">
      <h2>Mainboard bán chạy</h2>
      <a href="${pageContext.request.contextPath}/products?category=Mainboard" class="view-all">
        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-3">
      <c:choose>
        <c:when test="${not empty bestSellingMainboards}">
          <c:forEach var="p" items="${bestSellingMainboards}" varStatus="loop">
            <%@ include file="/WEB-INF/tags/components/product-card-direct.jspf" %>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <p class="text-muted mb-0">Hiện chưa có dữ liệu Mainboard bán chạy.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
<!-- Mainboard Best Seller End -->
  </jsp:body>
</t:main>
