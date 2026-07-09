package com.computerstore.controllers.admin;

import java.io.IOException;
import java.util.List;

import com.computerstore.dao.ReviewDAO;
import com.computerstore.models.Review;
import com.computerstore.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/admin/reviews", "/admin/reviews/approve", "/admin/reviews/reject",
		"/admin/reviews/delete" })
public class AdminReviewServlet extends HttpServlet {
	private ReviewDAO reviewDAO = new ReviewDAO();

	private boolean isAdmin(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("user");
		return user != null && "QUAN_TRI_VIEN".equals(user.getVaiTro());
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String status = req.getParameter("status");
		List<Review> reviews = reviewDAO.getAll(status);
		req.setAttribute("reviewList", reviews);
		req.getRequestDispatcher("/jsp/admin/reviews.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String path = req.getServletPath();
		String msg = "";
		try {
			int maDanhGia = Integer.parseInt(req.getParameter("maDanhGia"));
			switch (path) {
				case "/admin/reviews/approve":
					reviewDAO.approve(maDanhGia);
					msg = "?approved=1";
					break;
				case "/admin/reviews/reject":
					reviewDAO.reject(maDanhGia);
					msg = "?rejected=1";
					break;
				case "/admin/reviews/delete":
					reviewDAO.delete(maDanhGia);
					msg = "?deleted=1";
					break;
			}
		} catch (NumberFormatException e) {
			msg = "?error=1";
		} catch (Exception e) {
			msg = "?error=1";
		}
		resp.sendRedirect(req.getContextPath() + "/admin/reviews" + msg);
	}
}
