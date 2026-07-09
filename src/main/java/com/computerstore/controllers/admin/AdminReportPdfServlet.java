package com.computerstore.controllers.admin;

import com.computerstore.models.User;
import com.computerstore.services.AdminStatsService;
import com.computerstore.services.ReportGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports/export/pdf")
public class AdminReportPdfServlet extends HttpServlet {

    private AdminStatsService statsService;
    private ReportGeneratorService reportGenerator;

    @Override
    public void init() throws ServletException {
        statsService = new AdminStatsService();
        reportGenerator = new ReportGeneratorService();
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && "QUAN_TRI_VIEN".equals(user.getVaiTro());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String tab = req.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "overview";
        }

        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");

        // Default to last 30 days if not provided
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now().minusDays(30).format(fmt);
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().format(fmt);
        }

        // Calculate days from start/end date
        long days = java.time.temporal.ChronoUnit.DAYS.between(
                LocalDate.parse(startDate, fmt), LocalDate.parse(endDate, fmt)) + 1;
        if (days < 1)
            days = 30;
        if (days > 365)
            days = 365;

        String categoryId = req.getParameter("categoryId");
        String staffId = req.getParameter("staffId");
        String stockFilter = req.getParameter("stockFilter");

        try {
            byte[] pdfBytes = null;
            String filename = "bao-cao-" + tab + "-" + startDate + "-den-" + endDate + ".pdf";

            Integer catId = (categoryId != null && !categoryId.isEmpty()) ? Integer.parseInt(categoryId) : null;
            Integer stfId = (staffId != null && !staffId.isEmpty()) ? Integer.parseInt(staffId) : null;

            switch (tab) {
                case "overview":
                    Map<String, Object> kpi = statsService.getKPISummary((int) days);
                    pdfBytes = reportGenerator.generateOverviewReportPdf(kpi, startDate, endDate);
                    break;

                case "revenue":
                    List<Map<String, Object>> revenueData = statsService.getRevenueDetails((int) days, catId, stfId, 0,
                            100000);
                    pdfBytes = reportGenerator.generateRevenueReportPdf(revenueData, startDate, endDate, categoryId,
                            staffId);
                    break;

                case "inventory":
                    List<Map<String, Object>> inventoryData = statsService.getStockReport(0, 100000,
                            stockFilter);
                    pdfBytes = reportGenerator.generateInventoryReportPdf(inventoryData, stockFilter);
                    break;

                case "customers":
                    List<Map<String, Object>> customerData = statsService.getCustomerReport((int) days, 0,
                            100000);
                    pdfBytes = reportGenerator.generateCustomerReportPdf(customerData, startDate, endDate);
                    break;

                case "orders":
                    Map<String, Object> orderAnalysis = statsService.getOrderAnalysis((int) days);
                    @SuppressWarnings("unchecked")
                    Map<Integer, Integer> hourlyData = (Map<Integer, Integer>) orderAnalysis.get("byHour");
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> cancelReasons = (List<Map<String, Object>>) orderAnalysis
                            .get("cancelReasons");
                    pdfBytes = reportGenerator.generateOrderAnalysisReportPdf(hourlyData, cancelReasons);
                    break;

                case "promotions":
                    List<Map<String, Object>> promotionData = statsService.getPromotionReport((int) days);
                    pdfBytes = reportGenerator.generatePromotionReportPdf(promotionData, startDate, endDate);
                    break;

                case "payments":
                    List<Map<String, Object>> paymentData = statsService.getPaymentMethodStats((int) days);
                    pdfBytes = reportGenerator.generatePaymentReportPdf(paymentData);
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid tab: " + tab);
                    return;
            }

            if (pdfBytes == null) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate PDF");
                return;
            }

            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            resp.setContentLength(pdfBytes.length);
            resp.getOutputStream().write(pdfBytes);
            resp.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF: " + e.getMessage());
        }
    }
}
