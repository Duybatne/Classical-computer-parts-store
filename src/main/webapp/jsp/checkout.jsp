<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Checkout" activePage="pages">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">Checkout</h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item"><a href="#">Pages</a></li>
        <li class="breadcrumb-item active text-white">Checkout</li>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Checkout Page Start -->
    <div class="container-fluid py-5">
      <div class="container py-5">
        <h1 class="display-6 mb-4">Billing Details</h1>

        <c:if test="${not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <div class="row g-4">
            <div class="col-md-8">
              <div class="row g-4">
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="name" placeholder="Full Name"
                           value="${sessionScope.user.hoTen}" readonly>
                    <label for="name">Full Name</label>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="email" class="form-control" id="email" placeholder="Email"
                           value="${sessionScope.user.email}" readonly>
                    <label for="email">Email</label>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="phone" name="phone"
                           placeholder="Phone Number" value="${sessionScope.user.soDienThoai}">
                    <label for="phone">Phone Number</label>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="address" name="address"
                           placeholder="Address" value="${sessionScope.user.diaChi}">
                    <label for="address">Address</label>
                  </div>
                </div>
                <div class="col-12">
                  <div class="form-floating">
                    <textarea class="form-control" placeholder="Order Notes" id="note" name="note"
                              style="height: 100px">${param.note}</textarea>
                    <label for="note">Order Notes</label>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="bg-light rounded p-4">
                <h4 class="mb-4">Payment Method</h4>
                <c:if test="${not empty paymentMethods}">
                  <c:forEach var="pm" items="${paymentMethods}" varStatus="loop">
                    <div class="form-check mb-3">
                      <input class="form-check-input" type="radio" name="maPTTT"
                             id="payment-${pm.maPTTT}" value="${pm.maPTTT}"
                             ${loop.first ? 'checked' : ''}>
                      <label class="form-check-label" for="payment-${pm.maPTTT}">
                        ${pm.tenPTTT}
                      </label>
                    </div>
                  </c:forEach>
                </c:if>
                <button type="submit" class="btn btn-primary w-100 py-3 mt-3">Place Order</button>
              </div>

              <!-- Order Summary -->
              <div class="bg-light rounded p-4 mt-4">
                <h4 class="mb-4">Order Summary</h4>
                <c:if test="${not empty cartItems}">
                  <div class="table-responsive mb-3">
                    <table class="table table-sm">
                      <thead>
                        <tr>
                          <th>Sản phẩm</th>
                          <th class="text-end">SL</th>
                          <th class="text-end">Đơn giá</th>
                          <th class="text-end">Thành tiền</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="item" items="${cartItems}">
                          <tr>
                            <td>${item.tenSP}</td>
                            <td class="text-end">${item.soLuong}</td>
                            <td class="text-end">
                              <fmt:formatNumber value="${item.giaBan}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td class="text-end fw-bold">
                              <fmt:formatNumber value="${item.thanhTien}" type="currency" currencySymbol="₫"/>
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>
                  <div class="border-top pt-3">
                    <div class="d-flex justify-content-between mb-2">
                      <span>Subtotal:</span>
                      <fmt:formatNumber value="${cartSubtotal}" type="currency" currencySymbol="₫"/>
                    </div>
                    <c:if test="${not empty voucherCode}">
                      <div class="d-flex justify-content-between mb-2 text-success">
                        <span>Discount (${voucherCode}):</span>
                        -<fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol="₫"/>
                      </div>
                    </c:if>
                    <div class="d-flex justify-content-between mb-2">
                      <span>Shipping:</span>
                      <fmt:formatNumber value="${shippingAmount}" type="currency" currencySymbol="₫"/>
                      <span class="text-muted ms-2">
                        ${shippingAmount == 0 ? '(Miễn phí)' : ''}
                      </span>
                    </div>
                    <div class="d-flex justify-content-between fw-bold fs-5 border-top pt-2 mt-2">
                      <span>Tổng cộng:</span>
                      <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫"/>
                    </div>
                  </div>
                </c:if>
                <c:if test="${empty cartItems}">
                  <div class="alert alert-warning mb-0">
                    <i class="fa fa-exclamation-triangle me-2"></i>
                    Giỏ hàng của bạn đang trống.
                    <a href="${pageContext.request.contextPath}/products" class="alert-link">Mua sắm ngay</a>
                  </div>
                </c:if>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
    <!-- Checkout Page End -->

  </jsp:body>
</t:main>
