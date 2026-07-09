package com.computerstore.controllers;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.computerstore.services.PromotionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/promotions")
public class PromotionServlet extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(PromotionServlet.class);
	private PromotionService promotionService = new PromotionService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			req.setAttribute("promotions", promotionService.getActivePromotions());
		} catch (Exception e) {
			logger.error("Error loading promotions: {}", e.getMessage(), e);
			req.setAttribute("error", "Không thể tải danh sách khuyến mãi. Vui lòng thử lại sau.");
		}
		req.getRequestDispatcher("/jsp/promotions.jsp").forward(req, resp);
	}
}
