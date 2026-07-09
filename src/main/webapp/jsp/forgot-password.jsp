<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Forgot Password" activePage="login">
  <jsp:body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-5 col-md-8">
          <div class="bg-light rounded p-5">
            <h1 class="display-6 mb-4 text-center">Quên mật khẩu</h1>

            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
              <div class="alert alert-success">${success}</div>
              <c:if test="${not empty resetLink}">
                <div class="alert alert-info mt-3">
                  <strong>Liên kết đặt lại mật khẩu (Dev Mode):</strong><br>
                  <a href="${resetLink}" class="text-break">${resetLink}</a>
                </div>
              </c:if>
            </c:if>

            <c:if test="${empty success}">
              <p class="text-muted text-center mb-4">
                Nhập email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu.
              </p>

              <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <div class="mb-3">
                  <label class="form-label">Email</label>
                  <input type="email" name="email" class="form-control" value="${not empty email ? email : param.email}" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 py-3">Gửi yêu cầu</button>
              </form>
            </c:if>

            <p class="mt-3 text-center">
              <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </jsp:body>
</t:main>
