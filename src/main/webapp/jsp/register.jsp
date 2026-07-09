<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Register" activePage="register">
  <jsp:body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
          <div class="bg-light rounded p-5">
            <h1 class="display-6 mb-4 text-center">Đăng ký</h1>

            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty successWithVerify}">
              <div class="alert alert-success">${successWithVerify}</div>
              <c:if test="${not empty verifyLink}">
                <div class="alert alert-info">
                  <strong>Liên kết xác thực (Dev Mode):</strong><br>
                  <a href="${verifyLink}" class="text-break">${verifyLink}</a>
                </div>
              </c:if>
            </c:if>

            <c:if test="${empty successWithVerify}">
              <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <div class="mb-3">
                  <label class="form-label">Tên đăng nhập</label>
                  <input type="text" name="username" class="form-control" value="${not empty username ? username : param.username}" required
                         pattern="[a-zA-Z0-9_]{3,20}"
                         title="3-20 ký tự (chữ, số, dấu gạch dưới)">
                </div>
                <div class="mb-3">
                  <label class="form-label">Họ và tên</label>
                  <input type="text" name="fullname" class="form-control" value="${not empty fullname ? fullname : param.fullname}" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Email</label>
                  <input type="email" name="email" class="form-control" value="${not empty email ? email : param.email}" required id="emailInput">
                  <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
                </div>
                <div class="mb-3">
                  <label class="form-label">Số điện thoại</label>
                  <input type="text" name="phone" class="form-control" value="${not empty phone ? phone : param.phone}" id="phoneInput">
                  <div class="invalid-feedback">Số điện thoại không hợp lệ (VD: 0912345678).</div>
                </div>
                <div class="mb-3">
                  <label class="form-label">Địa chỉ</label>
                  <textarea name="address" class="form-control" rows="2">${not empty address ? address : param.address}</textarea>
                </div>
                <div class="mb-3">
                  <label class="form-label">Mật khẩu</label>
                  <input type="password" name="password" class="form-control" minlength="8" required
                         pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}"
                         id="passwordInput">
                  <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.</div>
                </div>
                <div class="mb-3">
                  <label class="form-label">Xác nhận mật khẩu</label>
                  <input type="password" name="confirmPassword" class="form-control" minlength="8" required id="confirmPwInput">
                  <div class="invalid-feedback" id="confirmPwError">Mật khẩu xác nhận không khớp.</div>
                </div>
                <button type="submit" class="btn btn-primary w-100 py-3">Đăng ký</button>
              </form>
              <p class="mt-3 text-center">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
              </p>
            </c:if>
          </div>
        </div>
      </div>
    </div>

    <script>
    document.getElementById('registerForm')?.addEventListener('submit', function(e) {
      const email = document.getElementById('emailInput');
      const phone = document.getElementById('phoneInput');
      const newPw = document.getElementById('passwordInput');
      const confirmPw = document.getElementById('confirmPwInput');
      const confirmError = document.getElementById('confirmPwError');
      let valid = true;

      // Email validation
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!emailPattern.test(email.value)) {
        email.classList.add('is-invalid');
        valid = false;
      } else {
        email.classList.remove('is-invalid');
      }

      // Phone validation (optional)
      if (phone.value.trim() !== '') {
        const phonePattern = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
        if (!phonePattern.test(phone.value)) {
          phone.classList.add('is-invalid');
          valid = false;
        } else {
          phone.classList.remove('is-invalid');
        }
      } else {
        phone.classList.remove('is-invalid');
      }

      // Password pattern
      const pwPattern = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}/;
      if (!pwPattern.test(newPw.value)) {
        newPw.classList.add('is-invalid');
        valid = false;
      } else {
        newPw.classList.remove('is-invalid');
      }

      // Confirm password
      if (newPw.value !== confirmPw.value) {
        confirmPw.classList.add('is-invalid');
        confirmError.textContent = 'Mật khẩu xác nhận không khớp.';
        valid = false;
      } else {
        confirmPw.classList.remove('is-invalid');
      }

      if (!valid) e.preventDefault();
    });

    document.getElementById('confirmPwInput')?.addEventListener('input', function() {
      const newPw = document.getElementById('passwordInput').value;
      if (this.value !== '' && this.value !== newPw) {
        this.classList.add('is-invalid');
        document.getElementById('confirmPwError').textContent = 'Mật khẩu xác nhận không khớp.';
      } else {
        this.classList.remove('is-invalid');
      }
    });
    </script>
  </jsp:body>
</t:main>
