package com.computerstore.controllers.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

import com.computerstore.dao.PromotionDAO;
import com.computerstore.models.Promotion;
import com.computerstore.models.User;
import com.computerstore.services.PromotionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/admin/promotions", "/admin/promotions/delete" })
public class AdminPromotionServlet extends HttpServlet {
	private PromotionService promotionService = new PromotionService();
	private PromotionDAO promotionDAO = new PromotionDAO();

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
		req.setAttribute("promoList", promotionService.getAll());
		req.getRequestDispatcher("/jsp/admin/promotions.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String path = req.getServletPath();

		if ("/admin/promotions/delete".equals(path)) {
			String maVoucher = req.getParameter("maVoucher");
			if (maVoucher != null) {
				promotionDAO.deleteByName(maVoucher);
			}
		} else {
			String action = req.getParameter("action");
			if ("toggleStatus".equals(action)) {
				// Toggle promotion status
				try {
					int maKM = Integer.parseInt(req.getParameter("maKM"));
					boolean status = "true".equals(req.getParameter("status"));
					promotionService.updateStatus(maKM, status);
					req.getSession().setAttribute("successMessage",
							status ? "Kích hoạt mã thành công." : "Vô hiệu hóa mã thành công.");
				} catch (Exception e) {
					req.getSession().setAttribute("errorMessage", "Lỗi cập nhật: " + e.getMessage());
				}
			} else {
				// Create new promotion — POST /admin/promotions
				try {
					String tenKM = req.getParameter("maVoucher"); // code == tenKM
					String loaiGiam = req.getParameter("loaiGiam"); // percent | fixed → map to PHAN_TRAM | SO_TIEN
					BigDecimal gia = new BigDecimal(req.getParameter("giaTriGiam"));
					String hanStr = req.getParameter("hanSuDung");
					Date ngayKetThuc = (hanStr != null && !hanStr.isEmpty()) ? Date.valueOf(hanStr) : null;
					Date ngayBatDau = new Date(System.currentTimeMillis());

					Promotion p = new Promotion();
					p.setTenKM(tenKM.toUpperCase());
					p.setLoaiGiam("percent".equals(loaiGiam) ? "PHAN_TRAM" : "SO_TIEN");
					p.setGiaTriGiam(gia);
					p.setNgayBatDau(ngayBatDau);
					p.setNgayKetThuc(ngayKetThuc != null ? ngayKetThuc : Date.valueOf("2099-12-31"));
					p.setTrangThai(true);

					promotionDAO.insert(p);
					req.getSession().setAttribute("successMessage", "Tạo mã giảm giá thành công.");
				} catch (Exception e) {
					req.getSession().setAttribute("errorMessage", "Lỗi tạo mã: " + e.getMessage());
				}
			}
		}
		resp.sendRedirect(req.getContextPath() + "/admin/promotions");
	}
}
