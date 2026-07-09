package com.computerstore.controllers;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

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
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = { "/login", "/register", "/logout", "/forgot-password" })
public class AuthServlet extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(AuthServlet.class);
	private UserService userService = new UserService();

	private static final int MAX_FAILED_ATTEMPTS = 5;
	private static final long LOCKOUT_DURATION_MS = 15 * 60 * 1000;
	private static final Map<String, LoginAttempt> failedAttempts = new ConcurrentHashMap<>();

	private static class LoginAttempt {
		AtomicInteger count = new AtomicInteger(0);
		long firstFailedTime = 0;
	}

	private boolean isRateLimited(String username) {
		LoginAttempt attempt = failedAttempts.get(username);
		if (attempt == null)
			return false;
		if (System.currentTimeMillis() - attempt.firstFailedTime > LOCKOUT_DURATION_MS) {
			failedAttempts.remove(username);
			return false;
		}
		return attempt.count.get() >= MAX_FAILED_ATTEMPTS;
	}

	private void recordFailedAttempt(String username) {
		LoginAttempt attempt = failedAttempts.computeIfAbsent(username, k -> new LoginAttempt());
		if (attempt.count.getAndIncrement() == 0) {
			attempt.firstFailedTime = System.currentTimeMillis();
		}
		if (failedAttempts.size() > 10000) {
			failedAttempts.entrySet()
					.removeIf(e -> System.currentTimeMillis() - e.getValue().firstFailedTime > LOCKOUT_DURATION_MS);
		}
	}

	private void resetFailedAttempts(String username) {
		failedAttempts.remove(username);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();

		if ("/logout".equals(path)) {
			HttpSession session = req.getSession(false);
			if (session != null) {
				session.invalidate();
			}
			resp.sendRedirect(req.getContextPath() + "/");
			return;
		}

		if ("/login".equals(path)) {
			req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
		} else if ("/register".equals(path)) {
			req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
		} else if ("/forgot-password".equals(path)) {
			req.getRequestDispatcher("/jsp/forgot-password.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();

		if ("/login".equals(path)) {
			handleLogin(req, resp);
		} else if ("/register".equals(path)) {
			handleRegister(req, resp);
		} else if ("/forgot-password".equals(path)) {
			handleForgotPassword(req, resp);
		}
	}

	private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String u = req.getParameter("username");
		String p = req.getParameter("password");
		u = ValidationUtil.sanitize(u);

		if (u != null && isRateLimited(u)) {
			logger.warn("Rate-limited login attempt for username: {}", u);
			req.setAttribute("error", "Tai khoan tam thoi bi khoa do dang nhap sai qua nhieu lan.");
			req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
			return;
		}

		try {
			User user = userService.authenticate(u, p);
			if (user != null) {
				logger.info("Login successful: username={}, role={}", u, user.getVaiTro());
				if (u != null)
					resetFailedAttempts(u);
				HttpSession oldSession = req.getSession(false);
				if (oldSession != null)
					oldSession.invalidate();
				HttpSession newSession = req.getSession(true);
				newSession.setAttribute("user", user);
				if ("QUAN_TRI_VIEN".equals(user.getVaiTro())) {
					resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
				} else {
					resp.sendRedirect(req.getContextPath() + "/");
				}
			} else {
				logger.warn("Login failed: username={}", u);
				if (u != null)
					recordFailedAttempt(u);
				boolean accountDisabled = false;
				try {
					accountDisabled = userService.isAccountDisabled(u);
				} catch (Exception ignored) {
				}
				if (accountDisabled) {
					req.setAttribute("error", "Tai khoan cua ban da bi vo hieu hoa.");
				} else {
					req.setAttribute("error", "Sai ten dang nhap hoac mat khau!");
				}
				req.setAttribute("username", u);
				req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
			}
		} catch (Exception e) {
			logger.error("Login error for username={}: {}", u, e.getMessage(), e);
			req.setAttribute("error", "He thong dang gap su co, vui long thu lai sau.");
			req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
		}
	}

	private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String uname = req.getParameter("username");
		String pass = req.getParameter("password");
		String confirmPass = req.getParameter("confirmPassword");
		String name = req.getParameter("fullname");
		String email = req.getParameter("email");
		String phone = req.getParameter("phone");
		String address = req.getParameter("address");

		uname = ValidationUtil.sanitize(uname);
		name = ValidationUtil.sanitize(name);
		email = ValidationUtil.sanitize(email);
		phone = ValidationUtil.sanitize(phone);
		address = ValidationUtil.sanitize(address);

		if (uname != null)
			uname = uname.trim().length() > 50 ? uname.trim().substring(0, 50) : uname.trim();
		if (name != null)
			name = name.trim().length() > 100 ? name.trim().substring(0, 100) : name.trim();
		if (email != null)
			email = email.trim().length() > 100 ? email.trim().substring(0, 100) : email.trim();
		if (phone != null)
			phone = phone.trim().length() > 20 ? phone.trim().substring(0, 20) : phone.trim();
		if (address != null)
			address = address.trim().length() > 255 ? address.trim().substring(0, 255) : address.trim();

		String validationError = null;
		if (uname == null || uname.isEmpty()) {
			validationError = "Vui long nhap ten dang nhap";
		} else if (!ValidationUtil.isValidUsername(uname)) {
			validationError = "Ten dang nhap phai tu 3-20 ky tu";
		} else if (pass == null || pass.isEmpty()) {
			validationError = "Vui long nhap mat khau";
		} else if (!ValidationUtil.isValidPassword(pass)) {
			validationError = "Mat khau phai co it nhat 8 ky tu, gom chu hoa, chu thuong va so";
		} else if (confirmPass == null || !confirmPass.equals(pass)) {
			validationError = "Mat khau xac nhan khong khop";
		} else if (email == null || email.isEmpty()) {
			validationError = "Vui long nhap email";
		} else if (!ValidationUtil.isValidEmail(email)) {
			validationError = "Email khong dung dinh dang";
		} else if (phone != null && !phone.isEmpty() && !ValidationUtil.isValidPhone(phone)) {
			validationError = "So dien thoai khong dung dinh dang";
		} else if (userService.getByEmail(email) != null) {
			validationError = "Email da duoc su dung boi tai khoan khac!";
		}

		if (validationError != null) {
			logger.warn("Registration validation failed: {}", validationError);
			req.setAttribute("error", validationError);
			req.setAttribute("username", uname);
			req.setAttribute("fullname", name);
			req.setAttribute("email", email);
			req.setAttribute("phone", phone);
			req.setAttribute("address", address);
			req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
			return;
		}

		try {
			if (userService.registerCustomer(uname, pass, name, email, phone, address != null ? address : "")) {
				logger.info("Registration successful: username={}", uname);
				resp.sendRedirect(req.getContextPath() + "/login?registered=true");
			} else {
				logger.warn("Registration failed - username exists: {}", uname);
				req.setAttribute("error", "Ten dang nhap da ton tai!");
				req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
			}
		} catch (Exception e) {
			logger.error("Registration error: {}", e.getMessage(), e);
			req.setAttribute("error", "He thong dang gap su co, vui long thu lai sau.");
			req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
		}
	}

	private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String email = req.getParameter("email");
		String sanitizedEmail = ValidationUtil.sanitize(email);
		if (sanitizedEmail == null || sanitizedEmail.isBlank()) {
			req.setAttribute("error", "Vui long nhap email.");
			req.getRequestDispatcher("/jsp/forgot-password.jsp").forward(req, resp);
			return;
		}
		// Always show generic message to prevent user enumeration
		req.setAttribute("success", "Neu email ton tai trong he thong, chung toi da gui huong dan dat lai mat khau.");
		req.setAttribute("email", sanitizedEmail);
		req.getRequestDispatcher("/jsp/forgot-password.jsp").forward(req, resp);
	}
}
