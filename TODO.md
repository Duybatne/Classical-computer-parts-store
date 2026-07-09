# TODO - Kế hoạch rà soát & xử lý lỗi frontend

- [x] Bổ sung cấu hình error-page trong `src/main/webapp/WEB-INF/web.xml` cho 401/403/500 (forward về `/jsp/error.jsp`) và đồng bộ cách set request attribute

- [ ] Cập nhật `error.jsp` để hiển thị an toàn (dùng c:out cho mọi biến liên quan) và có fallback message theo `httpStatus`
- [x] Rà soát API: thay `sendError(..., "Error: " + e.getMessage())` bằng JSON error thân thiện + HTTP status phù hợp (không lộ message nhạy cảm)

- [ ] Rà soát các servlet dùng `e.printStackTrace()` (ít nhất các servlet được trỏ tới frontend) và thay bằng logger + forward qua `BaseServlet.handleError`
- [ ] Rà soát các DAO bị `e.printStackTrace()`/nuốt exception để đảm bảo wrap `AppException/DatabaseException`
- [ ] Chạy lại unit tests (`mvn test`) và đảm bảo lỗi không crash do backend DB setup (lưu ý test đang fail do thiếu table `PASSWORD_HISTORY`)
