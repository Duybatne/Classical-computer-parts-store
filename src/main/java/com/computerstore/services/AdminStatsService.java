package com.computerstore.services;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.computerstore.dao.AdminStatsDAO;

public class AdminStatsService {
    private AdminStatsDAO statsDAO = new AdminStatsDAO();

    public Map<String, BigDecimal> getRevenueByDay(int days) {
        validateDays(days);
        return statsDAO.getRevenueByDay(days);
    }

    public Map<String, BigDecimal> getRevenueByDay(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getRevenueByDay(startDate, endDate);
    }

    public Map<String, Integer> getOrdersByStatus(int days) {
        validateDays(days);
        return statsDAO.getOrdersByStatus(days);
    }

    public Map<String, Integer> getOrdersByStatus(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getOrdersByStatus(startDate, endDate);
    }

    public List<Map<String, Object>> getTopProducts(int limit, int days) {
        validateDays(days);
        validateLimit(limit);
        return statsDAO.getTopProducts(limit, days);
    }

    public List<Map<String, Object>> getTopProducts(int limit, LocalDate startDate, LocalDate endDate) {
        validateLimit(limit);
        return statsDAO.getTopProducts(limit, startDate, endDate);
    }

    public List<Map<String, Object>> getTopCustomers(int limit, int days) {
        validateDays(days);
        validateLimit(limit);
        return statsDAO.getTopCustomers(limit, days);
    }

    public List<Map<String, Object>> getTopCustomers(int limit, LocalDate startDate, LocalDate endDate) {
        validateLimit(limit);
        return statsDAO.getTopCustomers(limit, startDate, endDate);
    }

    public List<Map<String, Object>> getRevenueByCategory(int days) {
        validateDays(days);
        return statsDAO.getRevenueByCategory(days);
    }

    public List<Map<String, Object>> getRevenueByCategory(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getRevenueByCategory(startDate, endDate);
    }

    public List<Map<String, Object>> getPaymentMethodStats(int days) {
        validateDays(days);
        return statsDAO.getPaymentMethodStats(days);
    }

    public List<Map<String, Object>> getPaymentMethodStats(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getPaymentMethodStats(startDate, endDate);
    }

    public Map<String, Object> getKPISummary(int days) {
        validateDays(days);
        return statsDAO.getKPISummary(days);
    }

    public Map<String, Object> getKPISummary(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getKPISummary(startDate, endDate);
    }

    // ===== DETAILED REPORTS =====
    public List<Map<String, Object>> getRevenueDetails(int days, Integer categoryId, Integer staffId, int page,
            int pageSize) {
        validateDays(days);
        validatePage(page);
        validatePageSize(pageSize);
        return statsDAO.getRevenueDetails(days, categoryId, staffId, page, pageSize);
    }

    public List<Map<String, Object>> getRevenueDetails(LocalDate startDate, LocalDate endDate, Integer categoryId, Integer staffId, int page,
            int pageSize) {
        validatePage(page);
        validatePageSize(pageSize);
        return statsDAO.getRevenueDetails(startDate, endDate, categoryId, staffId, page, pageSize);
    }

    public int countRevenueDetails(int days, Integer categoryId, Integer staffId) {
        validateDays(days);
        return statsDAO.countRevenueDetails(days, categoryId, staffId);
    }

    public int countRevenueDetails(LocalDate startDate, LocalDate endDate, Integer categoryId, Integer staffId) {
        return statsDAO.countRevenueDetails(startDate, endDate, categoryId, staffId);
    }

    public List<Map<String, Object>> getStockReport(int page, int pageSize, String stockFilter) {
        validatePage(page);
        validatePageSize(pageSize);
        return statsDAO.getStockReport(page, pageSize, stockFilter);
    }

    public int countStockReport(String stockFilter) {
        return statsDAO.countStockReport(stockFilter);
    }

    public List<Map<String, Object>> getCustomerReport(int days, int page, int pageSize) {
        validateDays(days);
        validatePage(page);
        validatePageSize(pageSize);
        return statsDAO.getCustomerReport(days, page, pageSize);
    }

    public List<Map<String, Object>> getCustomerReport(LocalDate startDate, LocalDate endDate, int page, int pageSize) {
        validatePage(page);
        validatePageSize(pageSize);
        return statsDAO.getCustomerReport(startDate, endDate, page, pageSize);
    }

    public int countCustomerReport(int days) {
        validateDays(days);
        return statsDAO.countCustomerReport(days);
    }

    public int countCustomerReport(LocalDate startDate, LocalDate endDate) {
        return statsDAO.countCustomerReport(startDate, endDate);
    }

    public List<Map<String, Object>> getPromotionReport(int days) {
        validateDays(days);
        return statsDAO.getPromotionReport(days);
    }

    public List<Map<String, Object>> getPromotionReport(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getPromotionReport(startDate, endDate);
    }

    public Map<String, Object> getOrderAnalysis(int days) {
        validateDays(days);
        return statsDAO.getOrderAnalysis(days);
    }

    public Map<String, Object> getOrderAnalysis(LocalDate startDate, LocalDate endDate) {
        return statsDAO.getOrderAnalysis(startDate, endDate);
    }

    private void validateDays(int days) {
        if (days <= 0 || days > 365) {
            throw new IllegalArgumentException("Khoảng thời gian phải từ 1-365 ngày");
        }
    }

    private void validateLimit(int limit) {
        if (limit <= 0 || limit > 100) {
            throw new IllegalArgumentException("Giới hạn phải từ 1-100");
        }
    }

    private void validatePage(int page) {
        if (page < 0) {
            throw new IllegalArgumentException("Trang phải >= 0");
        }
    }

    private void validatePageSize(int pageSize) {
        if (pageSize <= 0 || pageSize > 100000) {
            throw new IllegalArgumentException("Kích thước trang phải từ 1-100000");
        }
    }
}
