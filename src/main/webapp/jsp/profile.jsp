<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Profile" activePage="profile">
  <jsp:body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <div class="bg-light rounded p-5">
            <h1 class="display-6 mb-4">My Profile</h1>

            <c:if test="${not empty infoSuccess}">
              <div class="alert alert-success">${infoSuccess}</div>
            </c:if>
            <c:if test="${not empty infoError}">
              <div class="alert alert-danger">${infoError}</div>
            </c:if>
            <c:if test="${not empty pwSuccess}">
              <div class="alert alert-success">${pwSuccess}</div>
            </c:if>
            <c:if test="${not empty pwError}">
              <div class="alert alert-danger">${pwError}</div>
            </c:if>

            <!-- Profile Info -->
            <form action="${pageContext.request.contextPath}/profile" method="post" class="mb-5" id="infoForm">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="updateInfo">
              <h4>Personal Information</h4>
              <div class="row g-3 mb-4">
                <div class="col-md-6">
                  <label class="form-label">Username</label>
                  <input type="text" class="form-control" value="${sessionScope.user.tenDangNhap}" readonly>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Email <span class="text-danger">*</span></label>
                  <input type="email" name="email" class="form-control" value="${sessionScope.user.email}" required
                         id="emailInput">
                  <div class="invalid-feedback">Vui long nhap email hop le.</div>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Full Name <span class="text-danger">*</span></label>
                  <input type="text" name="hoTen" class="form-control" value="${sessionScope.user.hoTen}" required>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Phone</label>
                  <input type="text" name="soDienThoai" class="form-control" value="${sessionScope.user.soDienThoai}"
                         id="phoneInput">
                  <div class="invalid-feedback">So dien thoai khong hop le.</div>
                </div>
                <div class="col-12">
                  <label class="form-label">Address</label>
                  <textarea name="diaChi" class="form-control" rows="2">${sessionScope.user.diaChi}</textarea>
                </div>
              </div>
              <button type="submit" class="btn btn-primary">Update Profile</button>
            </form>

            <!-- Change Password -->
            <form action="${pageContext.request.contextPath}/profile" method="post" id="pwForm">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="changePassword">
              <h4>Change Password</h4>
              <div class="row g-3">
                <div class="col-md-4">
                  <label class="form-label">Current Password</label>
                  <input type="password" name="currentPassword" class="form-control" required>
                </div>
                <div class="col-md-4">
                  <label class="form-label">New Password</label>
                  <input type="password" name="newPassword" class="form-control" required
                         pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}"
                         id="newPasswordInput">
                  <div class="invalid-feedback">
                    Mat khau phai co it nhat 8 ky tu, gom chu hoa, chu thuong va chu so.
                  </div>
                </div>
                <div class="col-md-4">
                  <label class="form-label">Confirm Password</label>
                  <input type="password" name="confirmPassword" class="form-control" required id="confirmPwInput">
                  <div class="invalid-feedback">Mat khau xac nhan khong khop.</div>
                </div>
              </div>
              <button type="submit" class="btn btn-warning mt-3">Change Password</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <script>
    document.getElementById('infoForm').addEventListener('submit', function(e) {
      const email = document.getElementById('emailInput');
      const phone = document.getElementById('phoneInput');
      let valid = true;
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!emailPattern.test(email.value)) { email.classList.add('is-invalid'); valid = false; }
      else { email.classList.remove('is-invalid'); }
      if (phone.value.trim() !== '') {
        const phonePattern = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
        if (!phonePattern.test(phone.value)) { phone.classList.add('is-invalid'); valid = false; }
        else { phone.classList.remove('is-invalid'); }
      } else { phone.classList.remove('is-invalid'); }
      if (!valid) e.preventDefault();
    });
    document.getElementById('pwForm').addEventListener('submit', function(e) {
      const newPw = document.getElementById('newPasswordInput');
      const confirmPw = document.getElementById('confirmPwInput');
      let valid = true;
      const pwPattern = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}/;
      if (!pwPattern.test(newPw.value)) { newPw.classList.add('is-invalid'); valid = false; }
      else { newPw.classList.remove('is-invalid'); }
      if (newPw.value !== confirmPw.value) { confirmPw.classList.add('is-invalid'); valid = false; }
      else { confirmPw.classList.remove('is-invalid'); }
      if (!valid) e.preventDefault();
    });
    document.getElementById('confirmPwInput').addEventListener('input', function() {
      const newPw = document.getElementById('newPasswordInput').value;
      if (this.value !== '' && this.value !== newPw) { this.classList.add('is-invalid'); }
      else { this.classList.remove('is-invalid'); }
    });
    </script>
  </jsp:body>
</t:main>
