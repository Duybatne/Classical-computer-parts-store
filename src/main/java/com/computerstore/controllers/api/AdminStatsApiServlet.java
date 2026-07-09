package com.computerstore.controllers.api;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

import com.computerstore.models.User;
import com.computerstore.services.AdminStatsService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {
        "/admin/api/stats/revenue",
        "/admin/api/stats/orders",
        "/admin/api/stats/top-products",
        "/admin/api/stats/top-customers",
        "/admin/api/stats/category-revenue",
        "/admin/api/stats/payment-methods",
        "/admin/api/stats/kpi"
})
public class AdminStatsApiServlet extends HttpServlet {
    private AdminStatsService statsService = new AdminStatsService();
    private Gson gson = new GsonBuilder().serializeNulls().create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"QUAN_TRI_VIEN".equals(user.getVaiTro())) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.setContentType("application/json;charset=UTF-8");
            gson.toJson(Map.of("error", "Unauthorized"), resp.getWriter());
            return;
        }

        String path = req.getServletPath();
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        LocalDate startDate = null;
        LocalDate endDate = null;

        if (startDateStr != null && !startDateStr.isBlank() && endDateStr != null && !endDateStr.isBlank()) {
            try {
                startDate = LocalDate.parse(startDateStr);
                endDate = LocalDate.parse(endDateStr);
            } catch (Exception e) {
                // Ignore parsing errors
            }
        }

        if (startDate == null || endDate == null) {
            int days = parseDays(req.getParameter("days"));
            endDate = LocalDate.now();
            startDate = endDate.minusDays(days - 1);
        }

        try {
            Object result = null;
            switch (path) {
                case "/admin/api/stats/revenue":
                    result = statsService.getRevenueByDay(startDate, endDate);
                    break;
                case "/admin/api/stats/orders":
                    result = statsService.getOrdersByStatus(startDate, endDate);
                    break;
                case "/admin/api/stats/top-products":
                    int limitProducts = parseLimit(req.getParameter("limit"), 10);
                    result = statsService.getTopProducts(limitProducts, startDate, endDate);
                    break;
                case "/admin/api/stats/top-customers":
                    int limitCustomers = parseLimit(req.getParameter("limit"), 10);
                    result = statsService.getTopCustomers(limitCustomers, startDate, endDate);
                    break;
                case "/admin/api/stats/category-revenue":
                    result = statsService.getRevenueByCategory(startDate, endDate);
                    break;
                case "/admin/api/stats/payment-methods":
                    result = statsService.getPaymentMethodStats(startDate, endDate);
                    break;
                case "/admin/api/stats/kpi":
                    result = statsService.getKPISummary(startDate, endDate);
                    break;
            }

            resp.setContentType("application/json;charset=UTF-8");
            gson.toJson(result, resp.getWriter());

        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json;charset=UTF-8");
            gson.toJson(Map.of("error", e.getMessage()), resp.getWriter());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json;charset=UTF-8");
            gson.toJson(Map.of("error", "Lỗi server: " + e.getMessage()), resp.getWriter());
        }
    }

    private int parseDays(String daysParam) {
        if (daysParam == null || daysParam.isBlank())
            return 30;
        try {
            int days = Integer.parseInt(daysParam);
            return Math.max(1, Math.min(days, 365));
        } catch (NumberFormatException e) {
            return 30;
        }
    }

    private int parseLimit(String limitParam, int defaultVal) {
        if (limitParam == null || limitParam.isBlank())
            return defaultVal;
        try {
            int limit = Integer.parseInt(limitParam);
            return Math.max(1, Math.min(limit, 100));
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
