package com.computerstore.controllers;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.computerstore.models.User;
import com.computerstore.services.UserService;
import com.computerstore.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(ProfileServlet.class);
	private UserService userService = new UserService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (req.getSession().getAttribute("user") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User user = (User) req.getSession().getAttribute("user");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		String action = req.getParameter("action");

		if ("updateInfo".equals(action)) {
			handleUpdateInfo(req, resp, user);
		} else if ("changePassword".equals(action)) {
			handleChangePassword(req, resp, user);
		} else {
			resp.sendRedirect(req.getContextPath() + "/profile");
		}
	}

	private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp, User user)
			throws ServletException, IOException {
		String hoTen = ValidationUtil.sanitize(req.getParameter("hoTen"));
		String email = ValidationUtil.sanitize(req.getParameter("email"));
		String soDienThoai = ValidationUtil.sanitize(req.getParameter("soDienThoai"));
		String diaChi = ValidationUtil.sanitize(req.getParameter("diaChi"));

		if (hoTen == null || hoTen.isBlank()) {
			req.setAttribute("infoError", "Ho ten khong duoc de trong.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}
		if (email == null || !ValidationUtil.isValidEmail(email)) {
			req.setAttribute("infoError", "Email khong hop le.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}
		if (!email.equals(user.getEmail())) {
			User existing = userService.getByEmail(email);
			if (existing != null && existing.getMaTK() != user.getMaTK()) {
				req.setAttribute("infoError", "Email nay da duoc su dung boi tai khoan khac.");
				req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
				return;
			}
		}
		if (soDienThoai != null && !soDienThoai.isBlank() && !ValidationUtil.isValidPhone(soDienThoai)) {
			req.setAttribute("infoError", "So dien thoai khong hop le.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}

		user.setHoTen(hoTen);
		user.setEmail(email);
		user.setSoDienThoai(soDienThoai);
		user.setDiaChi(diaChi);

		try {
			if (userService.updateCustomerProfile(user)) {
				req.getSession().setAttribute("user", user);
				req.setAttribute("infoSuccess", "Cap nhat thong tin thanh cong.");
				logger.info("User {} updated profile", user.getTenDangNhap());
			} else {
				req.setAttribute("infoError", "Cap nhat that bai.");
			}
		} catch (Exception e) {
			logger.error("Error updating profile: {}", e.getMessage(), e);
			req.setAttribute("infoError", "He thong dang gap su co.");
		}
		req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
	}

	private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User user)
			throws ServletException, IOException {
		String currentPw = req.getParameter("currentPassword");
		String newPw = req.getParameter("newPassword");
		String confirmPw = req.getParameter("confirmPassword");

		if (!BCrypt.checkpw(currentPw, user.getMatKhauHash())) {
			req.setAttribute("pwError", "Mat khau hien tai khong dung.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}
		if (!ValidationUtil.isValidPassword(newPw)) {
			req.setAttribute("pwError", "Mat khau moi phai co it nhat 8 ky tu.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}
		if (BCrypt.checkpw(newPw, user.getMatKhauHash())) {
			req.setAttribute("pwError", "Mat khau moi khong duoc giong mat khau hien tai.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}
		if (!newPw.equals(confirmPw)) {
			req.setAttribute("pwError", "Mat khau xac nhan khong khop.");
			req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
			return;
		}

		try {
			String hashed = BCrypt.hashpw(newPw, BCrypt.gensalt());
			if (userService.updatePassword(user.getMaTK(), hashed)) {
				user.setMatKhauHash(hashed);
				req.getSession().setAttribute("user", user);
				req.setAttribute("pwSuccess", "Doi mat khau thanh cong.");
				logger.info("User {} changed password", user.getTenDangNhap());
			} else {
				req.setAttribute("pwError", "Doi mat khau that bai.");
			}
		} catch (Exception e) {
			logger.error("Error changing password: {}", e.getMessage(), e);
			req.setAttribute("pwError", "He thong dang gap su co.");
		}
		req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
	}
}
