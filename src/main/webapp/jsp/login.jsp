<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Login" activePage="login">
  <jsp:body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-5 col-md-8">
          <div class="bg-light rounded p-5">
            <h1 class="display-6 mb-4 text-center">Login</h1>

            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${param.registered == 'true'}">
              <div class="alert alert-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
              <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" value="${not empty username ? username : param.username}" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required>
              </div>
              <button type="submit" class="btn btn-primary w-100 py-3">Login</button>
            </form>
            <p class="mt-3 text-center">
              Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
            </p>
            <p class="text-center">
              <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </jsp:body>
</t:main>
