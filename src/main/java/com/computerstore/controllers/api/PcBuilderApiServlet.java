package com.computerstore.controllers.api;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/builder/components")
public class PcBuilderApiServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json; charset=UTF-8");

		// Trả về JSON tĩnh để tránh lỗi đứt response/streaming do xử lý DB/logic.
		// Thay vì gọi PcBuilderService (có thể gây lỗi giữa chừng), luôn trả về mảng
		// rỗng.
		resp.setStatus(HttpServletResponse.SC_OK);
		resp.getWriter().write("[]");
		resp.getWriter().flush();
	}

}
