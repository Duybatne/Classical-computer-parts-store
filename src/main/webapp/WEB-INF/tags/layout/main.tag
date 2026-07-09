<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ attribute name="title" type="java.lang.String" required="true" %>
<%@ attribute name="activePage" type="java.lang.String" required="false" %>
<%@ attribute name="keywords" type="java.lang.String" required="false" %>
<%@ attribute name="description" type="java.lang.String" required="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>${title} - ComputerSpace</title>
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <meta content="${keywords != null ? keywords : ''}" name="keywords">
  <meta content="${description != null ? description : ''}" name="description">
  <base href="${pageContext.request.contextPath}/">

  <!-- Google Web Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

  <!-- Icon Font Stylesheet -->
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

  <!-- Libraries Stylesheet -->
  <link href="lib/animate/animate.min.css" rel="stylesheet">
  <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
  <link href="lib/lightbox/css/lightbox.min.css" rel="stylesheet">

  <!-- Customized Bootstrap Stylesheet -->
  <link href="css/bootstrap.min.css" rel="stylesheet">

  <!-- Template Stylesheet -->
  <link href="css/style.css" rel="stylesheet">
</head>
<body>

  <!-- Toast Messages -->
  <c:if test="${not empty sessionScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-5"
         style="z-index: 9999;" role="alert">
      <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="successMessage" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-5"
         style="z-index: 9999;" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="errorMessage" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.cartError}">
    <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-5"
         style="z-index: 9999;" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.cartError}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="cartError" scope="session"/>
  </c:if>

  <%@ include file="/WEB-INF/tags/common/spinner.tag" %>
  <%@ include file="/WEB-INF/tags/common/topbar.tag" %>
  <%@ include file="/WEB-INF/tags/common/navbar.tag" %>

  <!-- Page Content -->
  <jsp:doBody/>

  <%@ include file="/WEB-INF/tags/common/footer.tag" %>
  <%@ include file="/WEB-INF/tags/common/bottom-nav.tag" %>
  <%@ include file="/WEB-INF/tags/common/scripts.tag" %>
</body>
</html>
