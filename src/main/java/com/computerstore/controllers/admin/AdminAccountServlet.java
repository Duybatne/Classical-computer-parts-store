package com.computerstore.controllers.admin;

import java.io.IOException;
import java.util.List;

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

@WebServlet(urlPatterns = { "/admin/accounts", "/admin/accounts/toggle",
		"/admin/accounts/create", "/admin/accounts/delete", "/admin/accounts/upgrade" })
public class AdminAccountServlet extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(AdminAccountServlet.class);
	private UserService userService = new UserService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		try {
			String q = req.getParameter("q");
			String role = req.getParameter("role");
			List<User> accounts = userService.getAllAccounts(q, role);
			req.setAttribute("accountList", accounts);
		} catch (Exception e) {
			logger.error("Error loading accounts: {}", e.getMessage(), e);
			req.setAttribute("errorMessage", "Khong the tai danh sach tai khoan.");
		}
		req.getRequestDispatcher("/jsp/admin/accounts.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String path = req.getServletPath();

		switch (path) {
			case "/admin/accounts/toggle":
				handleToggle(req, resp);
				break;
			case "/admin/accounts/create":
				handleCreate(req, resp);
				break;
			case "/admin/accounts/delete":
				handleDelete(req, resp);
				break;
			case "/admin/accounts/upgrade":
				handleUpgrade(req, resp);
				break;
			default:
				resp.sendRedirect(req.getContextPath() + "/admin/accounts");
		}
	}

	private void handleToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		User admin = (User) req.getSession().getAttribute("user");
		try {
			int maTK = Integer.parseInt(req.getParameter("maTK"));
			if (maTK == admin.getMaTK()) {
				req.getSession().setAttribute("errorMessage", "Ban khong the tu vo hieu hoa tai khoan cua minh.");
				resp.sendRedirect(req.getContextPath() + "/admin/accounts");
				return;
			}
			String trangThai = req.getParameter("trangThai");
			int status = "active".equals(trangThai) ? 1 : 0;
			userService.updateAccountStatus(maTK, status);
			req.getSession().setAttribute("successMessage", "Cap nhat trang thai tai khoan thanh cong.");
		} catch (NumberFormatException e) {
			req.getSession().setAttribute("errorMessage", "Ma tai khoan khong hop le.");
		} catch (Exception e) {
			logger.error("Error toggling account: {}", e.getMessage(), e);
			req.getSession().setAttribute("errorMessage", "Loi khi cap nhat trang thai.");
		}
		resp.sendRedirect(req.getContextPath() + "/admin/accounts");
	}

	private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String username = ValidationUtil.sanitize(req.getParameter("username"));
		String password = req.getParameter("password");
		String fullname = ValidationUtil.sanitize(req.getParameter("fullname"));
		String email = ValidationUtil.sanitize(req.getParameter("email"));

		String error = null;
		if (username == null || username.isBlank())
			error = "Vui long nhap ten dang nhap.";
		else if (!ValidationUtil.isValidUsername(username))
			error = "Ten dang nhap phai tu 3-20 ky tu.";
		else if (password == null || password.isEmpty())
			error = "Vui long nhap mat khau.";
		else if (!ValidationUtil.isValidPassword(password))
			error = "Mat khau phai co it nhat 8 ky tu.";
		else if (fullname == null || fullname.isBlank())
			error = "Vui long nhap ho ten.";
		else if (email == null || !ValidationUtil.isValidEmail(email))
			error = "Email khong hop le.";

		if (error != null) {
			req.getSession().setAttribute("errorMessage", error);
		} else {
			try {
				if (userService.createAdminUser(username, password, fullname, email)) {
					req.getSession().setAttribute("successMessage", "Tao tai khoan admin thanh cong!");
				} else {
					req.getSession().setAttribute("errorMessage", "Ten dang nhap da ton tai.");
				}
			} catch (Exception e) {
				logger.error("Error creating admin: {}", e.getMessage(), e);
				req.getSession().setAttribute("errorMessage", "Loi khi tao tai khoan.");
			}
		}
		resp.sendRedirect(req.getContextPath() + "/admin/accounts");
	}

	private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		User admin = (User) req.getSession().getAttribute("user");
		try {
			int maTK = Integer.parseInt(req.getParameter("maTK"));
			if (maTK == admin.getMaTK()) {
				req.getSession().setAttribute("errorMessage", "Ban khong the tu xoa tai khoan cua minh.");
				resp.sendRedirect(req.getContextPath() + "/admin/accounts");
				return;
			}
			String type = req.getParameter("type"); // "soft" or "hard"
			boolean ok;
			if ("hard".equals(type)) {
				ok = userService.hardDeleteAccount(maTK);
			} else {
				ok = userService.softDeleteAccount(maTK);
			}
			if (ok) {
				req.getSession().setAttribute("successMessage", "Xoa tai khoan thanh cong.");
			} else {
				req.getSession().setAttribute("errorMessage", "Khong tim thay tai khoan.");
			}
		} catch (NumberFormatException e) {
			req.getSession().setAttribute("errorMessage", "Ma tai khoan khong hop le.");
		} catch (Exception e) {
			logger.error("Error deleting account: {}", e.getMessage(), e);
			req.getSession().setAttribute("errorMessage", "Loi khi xoa tai khoan.");
		}
		resp.sendRedirect(req.getContextPath() + "/admin/accounts");
	}

	private void handleUpgrade(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			int maTK = Integer.parseInt(req.getParameter("maTK"));
			String fullname = ValidationUtil.sanitize(req.getParameter("fullname"));
			String email = ValidationUtil.sanitize(req.getParameter("email"));
			if (userService.upgradeToAdmin(maTK, fullname, email)) {
				req.getSession().setAttribute("successMessage", "Nang cap len Admin thanh cong!");
			} else {
				req.getSession().setAttribute("errorMessage", "Nang cap that bai.");
			}
		} catch (NumberFormatException e) {
			req.getSession().setAttribute("errorMessage", "Ma tai khoan khong hop le.");
		} catch (Exception e) {
			logger.error("Error upgrading account: {}", e.getMessage(), e);
			req.getSession().setAttribute("errorMessage", "Loi khi nang cap tai khoan.");
		}
		resp.sendRedirect(req.getContextPath() + "/admin/accounts");
	}

	private boolean isAdmin(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("user");
		return user != null && "QUAN_TRI_VIEN".equals(user.getVaiTro());
	}
}
