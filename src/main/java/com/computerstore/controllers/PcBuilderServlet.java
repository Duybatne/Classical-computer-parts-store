package com.computerstore.controllers;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.computerstore.dao.ProductDAO;
import com.computerstore.models.Product;
import com.computerstore.models.User;
import com.computerstore.services.CartService;
import com.computerstore.services.PromotionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/builder")
public class PcBuilderServlet extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(PcBuilderServlet.class);
	private CartService cartService = new CartService();
	private ProductDAO productDAO = new ProductDAO();
	private PromotionService promotionService = new PromotionService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			// Load products by category for builder
			List<Product> cpus = productDAO.getBestSellingByCategory("CPU", 10);
			promotionService.populateDiscountedPrices(cpus);
			req.setAttribute("cpus", cpus);

			List<Product> mainboards = productDAO.getBestSellingByCategory("Mainboard", 10);
			promotionService.populateDiscountedPrices(mainboards);
			req.setAttribute("mainboards", mainboards);

			List<Product> rams = productDAO.getBestSellingByCategory("RAM", 10);
			promotionService.populateDiscountedPrices(rams);
			req.setAttribute("rams", rams);

			List<Product> vgas = productDAO.getBestSellingByCategory("VGA", 10);
			promotionService.populateDiscountedPrices(vgas);
			req.setAttribute("vgas", vgas);

			List<Product> storages = productDAO.getBestSellingByCategory("Ổ cứng", 10);
			promotionService.populateDiscountedPrices(storages);
			req.setAttribute("storages", storages);

			List<Product> cases = productDAO.getBestSellingByCategory("Case", 10);
			promotionService.populateDiscountedPrices(cases);
			req.setAttribute("cases", cases);

			List<Product> psus = productDAO.getBestSellingByCategory("Nguồn", 10);
			promotionService.populateDiscountedPrices(psus);
			req.setAttribute("psus", psus);

			List<Product> coolers = productDAO.getBestSellingByCategory("Tản nhiệt", 10);
			promotionService.populateDiscountedPrices(coolers);
			req.setAttribute("coolers", coolers);
		} catch (Exception e) {
			logger.error("Error loading PC builder products: {}", e.getMessage(), e);
			req.setAttribute("error", "Không thể tải danh sách linh kiện. Vui lòng thử lại sau.");
		}
		req.getRequestDispatcher("/jsp/builder.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		User user = (User) session.getAttribute("user");
		if (user == null || !"KHACH_HANG".equals(user.getVaiTro())) {
			session.setAttribute("error", "Vui lòng đăng nhập với tư cách khách hàng để mua hàng.");
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		// Collect all selected component IDs
		String[] paramNames = { "maSP_CPU", "maSP_Mainboard", "maSP_RAM", "maSP_VGA",
				"maSP_Storage", "maSP_Case", "maSP_PSU", "maSP_Cooler" };
		boolean hasItems = false;
		boolean hasError = false;

		for (String paramName : paramNames) {
			String maSPStr = req.getParameter(paramName);
			if (maSPStr != null && !maSPStr.isEmpty()) {
				try {
					int maSP = Integer.parseInt(maSPStr);
					cartService.addToCart(user.getMaKH(), maSP, 1);
					hasItems = true;
				} catch (NumberFormatException e) {
					logger.warn("Invalid maSP format: {} for param {}", maSPStr, paramName);
				} catch (Exception e) {
					logger.error("Error adding product {} to cart: {}", maSPStr, e.getMessage(), e);
					hasError = true;
				}
			}
		}

		if (hasError) {
			session.setAttribute("error", "Một số linh kiện không thể thêm vào giỏ hàng. Vui lòng thử lại.");
		} else if (hasItems) {
			session.setAttribute("successMessage", "Đã thêm toàn bộ cấu hình vào giỏ hàng.");
		} else {
			session.setAttribute("error", "Vui lòng chọn ít nhất một linh kiện.");
		}
		resp.sendRedirect(req.getContextPath() + "/cart");
	}
}
