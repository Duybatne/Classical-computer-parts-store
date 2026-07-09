<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Orders" activePage="orders">
  <jsp:body>
    <div class="container py-5">
      <div class="bg-light rounded p-5">
        <h1 class="display-6 mb-4">My Orders</h1>

        <c:if test="${param.success == 'true'}">
          <div class="alert alert-success">Order placed successfully!</div>
        </c:if>

        <c:choose>
          <c:when test="${not empty orders}">
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th>Order ID</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="order" items="${orders}">
                    <tr>
                      <td>#${order.maDonHang}</td>
                      <td>${order.ngayDat}</td>
                      <td>
                        <span class="badge bg-${order.trangThaiDonHang == 'DA_GIAO' ? 'success' :
                                                   order.trangThaiDonHang == 'DA_HUY' ? 'danger' :
                                                   order.trangThaiDonHang == 'CHO_XAC_NHAN' ? 'warning' : 'info'}">
                          ${order.trangThaiDonHang}
                        </span>
                      </td>
                      <td><fmt:formatNumber value="${order.tongTien}" type="currency" currencySymbol="₫"/></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/orders?action=detail&id=${order.maDonHang}"
                           class="btn btn-sm btn-primary">Xem chi tiết</a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-muted">You have no orders yet.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill">
              Start Shopping
            </a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </jsp:body>
</t:main>
