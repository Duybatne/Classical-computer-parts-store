<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="404 - Page Not Found">
  <jsp:body>
    <div class="container-fluid py-5">
      <div class="container py-5 text-center">
        <div class="row justify-content-center">
          <div class="col-lg-6">
            <h1 class="display-1 text-primary mb-4">404</h1>
            <h1 class="mb-4">Page Not Found</h1>
            <p class="mb-4">
              The page you are looking for might have been removed, had its name
              changed, or is temporarily unavailable.
            </p>
            <a
              href="${pageContext.request.contextPath}/"
              class="btn btn-primary rounded-pill py-3 px-5"
            >
              <i class="fas fa-home me-2"></i> Back to Home
            </a>
          </div>
        </div>
      </div>
    </div>
  </jsp:body>
</t:main>
