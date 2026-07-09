package com.computerstore.controllers;

import java.io.IOException;
import java.util.List;

import com.computerstore.dao.CategoryDAO;
import com.computerstore.dao.ProductDAO;
import com.computerstore.models.Category;
import com.computerstore.models.Product;
import com.computerstore.services.ProductService;
import com.computerstore.services.PromotionService;
import com.computerstore.utils.AppConstants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/home" })
public class HomeServlet extends HttpServlet {
	private ProductService productService = new ProductService();
	private CategoryDAO categoryDAO = new CategoryDAO();
	private ProductDAO productDAO = new ProductDAO();
	private PromotionService promotionService = new PromotionService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Featured products - chỉ lấy 1 lần, tránh ghi đè
		List<Product> featuredProducts = productDAO.getFeaturedProducts(AppConstants.FEATURED_PRODUCTS_LIMIT);
		promotionService.populateDiscountedPrices(featuredProducts);
		req.setAttribute("featuredProducts", featuredProducts);

		// Danh mục
		List<Category> categories = categoryDAO.getAll();
		req.setAttribute("categories", categories);

		// Sản phẩm bán chạy theo danh mục
		List<Product> cpus = productDAO.getBestSellingByCategory("CPU", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(cpus);
		req.setAttribute("bestSellingCPUs", cpus);

		List<Product> gpus = productDAO.getBestSellingByCategory("VGA", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(gpus);
		req.setAttribute("bestSellingGPUs", gpus);

		List<Product> rams = productDAO.getBestSellingByCategory("RAM", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(rams);
		req.setAttribute("bestSellingRAMs", rams);

		List<Product> cases = productDAO.getBestSellingByCategory("Case", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(cases);
		req.setAttribute("bestSellingCases", cases);

		List<Product> psus = productDAO.getBestSellingByCategory("Nguồn", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(psus);
		req.setAttribute("bestSellingPSUs", psus);

		List<Product> mainboards = productDAO.getBestSellingByCategory("Mainboard", AppConstants.BEST_SELLING_LIMIT);
		promotionService.populateDiscountedPrices(mainboards);
		req.setAttribute("bestSellingMainboards", mainboards);

		req.setAttribute("currentPage", "home");
		req.getRequestDispatcher("/jsp/index.jsp").forward(req, resp);
	}
}
