package com.computerstore.controllers.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.computerstore.models.User;
import com.computerstore.services.AdminStatsService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private AdminStatsService statsService = new AdminStatsService();

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

        String tab = req.getParameter("tab");
        if (tab == null) tab = "overview";

        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        LocalDate startDate = null;
        LocalDate endDate = null;
        if (startDateStr != null && !startDateStr.isBlank() && endDateStr != null && !endDateStr.isBlank()) {
            try {
                startDate = LocalDate.parse(startDateStr);
                endDate = LocalDate.parse(endDateStr);
            } catch (Exception e) {
                // Ignore
            }
        }

        int days = parseDays(req.getParameter("days"));
        if (startDate == null || endDate == null) {
            endDate = LocalDate.now();
            startDate = endDate.minusDays(days - 1);
        } else {
            days = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
        }

        int page = parsePage(req.getParameter("page"));
        int pageSize = parsePageSize(req.getParameter("pageSize"));

        try {
            switch (tab) {
                case "overview":
                    loadOverview(req, startDate, endDate);
                    break;
                case "revenue":
                    loadRevenueDetails(req, startDate, endDate, page, pageSize);
                    break;
                case "products":
                    loadProducts(req, page, pageSize);
                    break;
                case "customers":
                    loadCustomers(req, startDate, endDate, page, pageSize);
                    break;
                case "orders":
                    loadOrderAnalysis(req, startDate, endDate);
                    break;
                case "promotions":
                    loadPromotions(req, startDate, endDate);
                    break;
                case "payments":
                    loadPayments(req, startDate, endDate);
                    break;
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
        }

        req.setAttribute("activeTab", tab);
        req.setAttribute("days", days);
        req.setAttribute("startDate", startDate.toString());
        req.setAttribute("endDate", endDate.toString());
        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);
    }

    private void loadOverview(HttpServletRequest req, LocalDate startDate, LocalDate endDate) {
        req.setAttribute("kpi", statsService.getKPISummary(startDate, endDate));
        req.setAttribute("revenueByDay", statsService.getRevenueByDay(startDate, endDate));
        req.setAttribute("ordersByStatus", statsService.getOrdersByStatus(startDate, endDate));
        req.setAttribute("topProducts", statsService.getTopProducts(5, startDate, endDate));
        req.setAttribute("topCustomers", statsService.getTopCustomers(5, startDate, endDate));
        req.setAttribute("revenueByCategory", statsService.getRevenueByCategory(startDate, endDate));
        req.setAttribute("paymentMethods", statsService.getPaymentMethodStats(startDate, endDate));
    }

    private void loadRevenueDetails(HttpServletRequest req, LocalDate startDate, LocalDate endDate, int page, int pageSize) {
        Integer categoryId = parseIntOrNull(req.getParameter("categoryId"));
        Integer staffId = parseIntOrNull(req.getParameter("staffId"));

        List<Map<String, Object>> data = statsService.getRevenueDetails(startDate, endDate, categoryId, staffId, page, pageSize);
        int total = statsService.countRevenueDetails(startDate, endDate, categoryId, staffId);

        req.setAttribute("revenueDetails", data);
        req.setAttribute("totalRecords", total);
        req.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("staffId", staffId);
    }

    private void loadProducts(HttpServletRequest req, int page, int pageSize) {
        String stockFilter = req.getParameter("stockFilter");
        if (stockFilter == null) stockFilter = "all";

        List<Map<String, Object>> data = statsService.getStockReport(page, pageSize, stockFilter);
        int total = statsService.countStockReport(stockFilter);

        req.setAttribute("stockReport", data);
        req.setAttribute("totalRecords", total);
        req.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
        req.setAttribute("stockFilter", stockFilter);
    }

    private void loadCustomers(HttpServletRequest req, LocalDate startDate, LocalDate endDate, int page, int pageSize) {
        List<Map<String, Object>> data = statsService.getCustomerReport(startDate, endDate, page, pageSize);
        int total = statsService.countCustomerReport(startDate, endDate);

        req.setAttribute("customerReport", data);
        req.setAttribute("totalRecords", total);
        req.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
    }

    private void loadOrderAnalysis(HttpServletRequest req, LocalDate startDate, LocalDate endDate) {
        req.setAttribute("orderAnalysis", statsService.getOrderAnalysis(startDate, endDate));
    }

    private void loadPromotions(HttpServletRequest req, LocalDate startDate, LocalDate endDate) {
        req.setAttribute("promotionReport", statsService.getPromotionReport(startDate, endDate));
    }

    private void loadPayments(HttpServletRequest req, LocalDate startDate, LocalDate endDate) {
        req.setAttribute("paymentMethods", statsService.getPaymentMethodStats(startDate, endDate));
    }

    private int parseDays(String param) {
        if (param == null || param.isBlank()) return 30;
        try {
            int d = Integer.parseInt(param);
            return Math.max(1, Math.min(d, 365));
        } catch (NumberFormatException e) {
            return 30;
        }
    }

    private int parsePage(String param) {
        if (param == null || param.isBlank()) return 0;
        try {
            int p = Integer.parseInt(param);
            return Math.max(0, p);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private int parsePageSize(String param) {
        if (param == null || param.isBlank()) return 20;
        try {
            int ps = Integer.parseInt(param);
            return Math.max(1, Math.min(ps, 100));
        } catch (NumberFormatException e) {
            return 20;
        }
    }

    private Integer parseIntOrNull(String param) {
        if (param == null || param.isBlank()) return null;
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
