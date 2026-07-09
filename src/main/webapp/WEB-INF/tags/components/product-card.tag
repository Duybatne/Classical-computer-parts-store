<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ attribute name="product" type="com.computerstore.models.Product" required="true" rtexprvalue="true" %>

<div class="col-md-6 col-lg-4 col-xl-3">
  <div class="product-item rounded">
    <div class="product-item-inner border rounded">
      <div class="product-item-inner-item">
        <c:choose>
          <c:when test="${not empty product.anhChinh}">
            <img src="${pageContext.request.contextPath}${product.anhChinh}" class="img-fluid w-100 rounded-top" alt="${product.tenSP}">
          </c:when>
          <c:otherwise>
            <img src="${pageContext.request.contextPath}/img/product-3.png" class="img-fluid w-100 rounded-top" alt="${product.tenSP}">
          </c:otherwise>
        </c:choose>
        <c:if test="${product.soLuongTon > 10}">
          <div class="product-new">New</div>
        </c:if>
        <div class="product-details">
          <a href="${pageContext.request.contextPath}/product?id=${product.maSP}"><i class="fa fa-eye fa-1x"></i></a>
        </div>
      </div>
      <div class="text-center rounded-bottom p-4">
        <a href="${pageContext.request.contextPath}/products?category=${product.maLoaiSP}" class="d-block mb-2">
          ${product.thuongHieu != null ? product.thuongHieu : 'SmartPhone'}
        </a>
        <a href="${pageContext.request.contextPath}/product?id=${product.maSP}" class="d-block h4">
          ${product.tenSP}
        </a>
        <span class="text-primary fs-5">
          <fmt:formatNumber value="${product.giaBan}" type="currency" currencySymbol="$" />
        </span>
      </div>
    </div>
    <div class="product-item-add border border-top-0 rounded-bottom text-center p-4 pt-0">
      <form action="${pageContext.request.contextPath}/cart" method="post">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="maSP" value="${product.maSP}">
        <input type="hidden" name="quantity" value="1">
        <button type="submit" class="btn btn-primary border-secondary rounded-pill py-2 px-4 mb-4">
          <i class="fas fa-shopping-cart me-2"></i> Add To Cart
        </button>
      </form>
      <div class="d-flex justify-content-between align-items-center">
        <div class="d-flex">
          <i class="fas fa-star text-primary"></i>
          <i class="fas fa-star text-primary"></i>
          <i class="fas fa-star text-primary"></i>
          <i class="fas fa-star text-primary"></i>
          <i class="fas fa-star"></i>
        </div>
        <div class="d-flex">
          <a href="#" class="text-primary d-flex align-items-center justify-content-center me-3">
            <span class="rounded-circle btn-sm-square border"><i class="fas fa-random"></i></span>
          </a>
          <a href="#" class="text-primary d-flex align-items-center justify-content-center me-0">
            <span class="rounded-circle btn-sm-square border"><i class="fas fa-heart"></i></span>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>
