<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%
    // Lay status code tu request attributes (Tomcat set cac attribute nay khi co error)
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    if (statusCode == null) {
        statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    }
    if (statusCode == null) {
        statusCode = 500;
    }
    request.setAttribute("httpStatus", statusCode);

    // Lay error message
    String errorMsg = (String) request.getAttribute("errorMessage");
    if (errorMsg == null || errorMsg.isEmpty()) {
        Throwable exc = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
        if (exc == null) {
            exc = (Throwable) request.getAttribute("javax.servlet.error.exception");
        }
        if (exc != null && exc.getMessage() != null) {
            errorMsg = exc.getMessage();
        }
    }
    if (errorMsg == null || errorMsg.isEmpty()) {
        switch (statusCode) {
            case 403: errorMsg = "Ban khong co quyen truy cap trang nay."; break;
            case 404: errorMsg = "Trang ban tim khong ton tai."; break;
            case 500: errorMsg = "May chu dang gap su co. Vui long thu lai sau."; break;
            default: errorMsg = "Da xay ra loi. Vui long thu lai sau.";
        }
    }
    request.setAttribute("errorMessage", errorMsg);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loi - ComputerStore</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .error-box {
            background: white;
            border-radius: 15px;
            padding: 50px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 500px;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #667eea;
            margin: 0;
            line-height: 1;
        }
        .error-message {
            color: #666;
            margin: 20px 0;
            font-size: 16px;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-home:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-box">
            <div class="error-code"><c:out value="${httpStatus}"/></div>
            <c:choose>
                <c:when test="${httpStatus == 404}">
                    <h2>Khong tim thay trang</h2>
                </c:when>
                <c:when test="${httpStatus == 403}">
                    <h2>Truy cap bi tu choi</h2>
                </c:when>
                <c:when test="${httpStatus == 500}">
                    <h2>Loi may chu</h2>
                </c:when>
                <c:otherwise>
                    <h2>Co loi xay ra</h2>
                </c:otherwise>
            </c:choose>
            <p class="error-message"><c:out value="${errorMessage}"/></p>
            <a href="${pageContext.request.contextPath}/" class="btn-home">Ve trang chu</a>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/contact" class="text-muted">Lien he ho tro</a>
            </div>
        </div>
    </div>
</body>
</html>
