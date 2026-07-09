<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Cart" activePage="pages">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">Cart Page</h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item"><a href="#">Pages</a></li>
        <li class="breadcrumb-item active text-white">Cart</li>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Cart Page Start -->
    <div class="container-fluid py-5">
      <div class="container py-5">
        <!-- Error Messages -->
        <c:if test="${not empty sessionScope.cartError}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa fa-exclamation-circle me-2"></i>${sessionScope.cartError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
          <c:remove var="cartError" scope="session"/>
        </c:if>

        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th scope="col">Product</th>
                <th scope="col">Price</th>
                <th scope="col">Quantity</th>
                <th scope="col">Total</th>
                <th scope="col">Handle</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty cartItems}">
                  <c:forEach var="item" items="${cartItems}">
                    <tr>
                      <th scope="row">
                        <p class="mb-0 py-4">${item.tenSP}</p>
                      </th>
                      <td>
                        <p class="mb-0 py-4">
                          <fmt:formatNumber value="${item.giaBan}" type="currency" currencySymbol="₫" />
                        </p>
                      </td>
                      <td>
                        <div class="input-group quantity py-4" style="width: 100px;">
                          <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="productId" value="${item.maSP}">
                            <button type="submit" name="action" value="decrease"
                                    class="btn btn-sm btn-minus rounded-circle bg-light border">
                              <i class="fa fa-minus"></i>
                            </button>
                          </form>
                          <input type="text" class="form-control form-control-sm text-center border-0"
                                 value="${item.soLuong}" readonly>
                          <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="productId" value="${item.maSP}">
                            <button type="submit" name="action" value="increase"
                                    class="btn btn-sm btn-plus rounded-circle bg-light border">
                              <i class="fa fa-plus"></i>
                            </button>
                          </form>
                        </div>
                      </td>
                      <td>
                        <p class="mb-0 py-4">
                          <fmt:formatNumber value="${item.thanhTien}" type="currency" currencySymbol="₫" />
                        </p>
                      </td>
                      <td class="py-4">
                        <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                          <input type="hidden" name="productId" value="${item.maSP}">
                          <button class="btn btn-md rounded-circle bg-light border" type="submit">
                            <i class="fa fa-times text-danger"></i>
                          </button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="5" class="text-center py-5">
                      <h4>Your cart is empty</h4>
                      <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill mt-3">
                        Continue Shopping
                      </a>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <c:if test="${not empty cartItems}">
          <!-- Voucher -->
          <div class="mt-5">
            <form action="${pageContext.request.contextPath}/cart/voucher" method="post" class="row g-3 align-items-center">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <div class="col-auto">
                <input type="text" class="border-0 border-bottom rounded me-2 py-3"
                       name="voucherCode" placeholder="Coupon Code" value="${voucherCode}">
              </div>
              <div class="col-auto">
                <button class="btn btn-primary rounded-pill px-4 py-3" type="submit">Apply Coupon</button>
              </div>
              <c:if test="${not empty sessionScope.voucherMsg}">
                <div class="col-12">
                  <div class="alert alert-success py-2 mb-0">${sessionScope.voucherMsg}</div>
                  <c:remove var="voucherMsg" scope="session"/>
                </div>
              </c:if>
              <c:if test="${not empty sessionScope.voucherError}">
                <div class="col-12">
                  <div class="alert alert-danger py-2 mb-0">${sessionScope.voucherError}</div>
                  <c:remove var="voucherError" scope="session"/>
                </div>
              </c:if>
            </form>
          </div>

          <div class="row g-4 justify-content-end">
            <div class="col-8"></div>
            <div class="col-sm-8 col-md-7 col-lg-6 col-xl-4">
              <div class="bg-light rounded">
                <div class="p-4">
                  <h1 class="display-6 mb-4">Cart <span class="fw-normal">Total</span></h1>
                  <div class="d-flex justify-content-between mb-4">
                    <h5 class="mb-0 me-4">Subtotal:</h5>
                    <p class="mb-0">
                      <fmt:formatNumber value="${cartSubtotal}" type="currency" currencySymbol="₫"/>
                    </p>
                  </div>
                  <c:if test="${not empty voucherCode}">
                    <div class="d-flex justify-content-between mb-4">
                      <h5 class="mb-0 me-4">Discount:</h5>
                      <p class="mb-0 text-success">
                        -<fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol="₫" />
                      </p>
                    </div>
                  </c:if>
                  <div class="d-flex justify-content-between">
                    <h5 class="mb-0 me-4">Shipping</h5>
                    <div>
                      <p class="mb-0">Phí vận chuyển: 30.000₫</p>
                    </div>
                  </div>
                  <p class="mb-0 text-end">Free shipping</p>
                </div>
                <div class="py-4 mb-4 border-top border-bottom d-flex justify-content-between">
                  <h5 class="mb-0 ps-4 me-4">Total</h5>
                  <p class="mb-0 pe-4">
                    <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫" />
                  </p>
                </div>
                <a href="${pageContext.request.contextPath}/checkout"
                   class="btn btn-primary rounded-pill px-4 py-3 text-uppercase mb-4 ms-4">
                  Proceed Checkout
                </a>
              </div>
            </div>
          </div>
        </c:if>
      </div>
    </div>
    <!-- Cart Page End -->

  </jsp:body>
</t:main>
