package com.computerstore.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.utils.DBConnection;

public class AdminStatsDAO {

    // ===== HELPER: Build WHERE clause for date range + filters =====
    private void appendDateFilter(StringBuilder sql, List<Object> params, LocalDate startDate, LocalDate endDate) {
        sql.append(" AND dh.NgayDat >= ? AND dh.NgayDat <= ?");
        params.add(java.sql.Date.valueOf(startDate));
        params.add(java.sql.Date.valueOf(endDate.plusDays(1)));
    }

    private void appendCategoryFilter(StringBuilder sql, List<Object> params, Integer categoryId) {
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND sp.MaLoaiSP = ?");
            params.add(categoryId);
        }
    }

    private void appendStaffFilter(StringBuilder sql, List<Object> params, Integer staffId) {
        if (staffId != null && staffId > 0) {
            sql.append(" AND dh.MaNV = ?");
            params.add(staffId);
        }
    }

    // ===== DOANH THU THEO NGÀY =====
    public Map<String, BigDecimal> getRevenueByDay(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getRevenueByDay(startDate, endDate);
    }

    public Map<String, BigDecimal> getRevenueByDay(LocalDate startDate, LocalDate endDate) {
        Map<String, BigDecimal> result = new LinkedHashMap<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");

        // Khởi tạo tất cả ngày trong khoảng với 0
        for (LocalDate d = startDate; !d.isAfter(endDate); d = d.plusDays(1)) {
            result.put(d.format(fmt), BigDecimal.ZERO);
        }

        String sql = "SELECT DATE(dh.NgayDat) as ngay, COALESCE(SUM(dh.TongTien), 0) as doanhThu "
                + "FROM DON_HANG dh "
                + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' "
                + "  AND dh.NgayDat >= ? "
                + "  AND dh.NgayDat <= ? "
                + "GROUP BY DATE(dh.NgayDat) "
                + "ORDER BY DATE(dh.NgayDat)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ngay = rs.getDate("ngay").toLocalDate().format(fmt);
                    result.put(ngay, rs.getBigDecimal("doanhThu"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy doanh thu theo ngày", e);
        }
        return result;
    }

    // ===== ĐƠN HÀNG THEO TRẠNG THÁI =====
    public Map<String, Integer> getOrdersByStatus(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getOrdersByStatus(startDate, endDate);
    }

    private String normalizeStatus(String status) {
        if (status == null) return "CHỜ XÁC NHẬN";
        String upper = status.trim().toUpperCase();
        switch (upper) {
            case "CHO_XAC_NHAN":
            case "CHỜ XÁC NHẬN":
                return "CHỜ XÁC NHẬN";
            case "DA_XAC_NHAN":
            case "ĐÃ XÁC NHẬN":
                return "ĐÃ XÁC NHẬN";
            case "DANG_GIAO":
            case "ĐANG GIAO":
                return "ĐANG GIAO";
            case "DA_GIAO":
            case "ĐÃ GIAO":
                return "ĐÃ GIAO";
            case "DA_HUY":
            case "ĐÃ HỦY":
                return "ĐÃ HỦY";
            default:
                return upper;
        }
    }

    public Map<String, Integer> getOrdersByStatus(LocalDate startDate, LocalDate endDate) {
        Map<String, Integer> result = new LinkedHashMap<>();
        result.put("CHỜ XÁC NHẬN", 0);
        result.put("ĐÃ XÁC NHẬN", 0);
        result.put("ĐANG GIAO", 0);
        result.put("ĐÃ GIAO", 0);
        result.put("ĐÃ HỦY", 0);

        String sql = "SELECT TrangThaiDonHang, COUNT(*) as soLuong "
                + "FROM DON_HANG "
                + "WHERE NgayDat >= ? AND NgayDat <= ? "
                + "GROUP BY TrangThaiDonHang";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("TrangThaiDonHang");
                    String normStatus = normalizeStatus(status);
                    int count = rs.getInt("soLuong");
                    result.put(normStatus, result.getOrDefault(normStatus, 0) + count);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy đơn hàng theo trạng thái", e);
        }
        return result;
    }

    // ===== TOP SẢN PHẨM BÁN CHẠY =====
    public List<Map<String, Object>> getTopProducts(int limit, int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getTopProducts(limit, startDate, endDate);
    }

    public List<Map<String, Object>> getTopProducts(int limit, LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sp.TenSP, lsp.TenLoaiSP, SUM(ctdh.SoLuong) as soLuongBan, "
                + "SUM(ctdh.ThanhTien) as doanhThu "
                + "FROM CHI_TIET_DON_HANG ctdh "
                + "JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                + "JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP "
                + "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP "
                + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' "
                + "  AND dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "GROUP BY sp.MaSP, sp.TenSP, lsp.TenLoaiSP "
                + "ORDER BY soLuongBan DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("tenSP", rs.getString("TenSP"));
                    item.put("tenLoai", rs.getString("TenLoaiSP"));
                    item.put("soLuongBan", rs.getInt("soLuongBan"));
                    item.put("doanhThu", rs.getBigDecimal("doanhThu"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy top sản phẩm", e);
        }
        return list;
    }

    // ===== TOP KHÁCH HÀNG =====
    public List<Map<String, Object>> getTopCustomers(int limit, int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getTopCustomers(limit, startDate, endDate);
    }

    public List<Map<String, Object>> getTopCustomers(int limit, LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT kh.HoTen, kh.Email, COUNT(dh.MaDonHang) as soDon, "
                + "COALESCE(SUM(dh.TongTien), 0) as tongTien "
                + "FROM DON_HANG dh "
                + "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
                + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' "
                + "  AND dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "GROUP BY kh.MaKH, kh.HoTen, kh.Email "
                + "ORDER BY tongTien DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("hoTen", rs.getString("HoTen"));
                    item.put("email", rs.getString("Email"));
                    item.put("soDon", rs.getInt("soDon"));
                    item.put("tongTien", rs.getBigDecimal("tongTien"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy top khách hàng", e);
        }
        return list;
    }

    // ===== DOANH THU THEO DANH MỤC =====
    public List<Map<String, Object>> getRevenueByCategory(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getRevenueByCategory(startDate, endDate);
    }

    public List<Map<String, Object>> getRevenueByCategory(LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT lsp.TenLoaiSP, COALESCE(SUM(ctdh.ThanhTien), 0) as doanhThu, "
                + "SUM(ctdh.SoLuong) as soLuongBan "
                + "FROM CHI_TIET_DON_HANG ctdh "
                + "JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                + "JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP "
                + "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP "
                + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' "
                + "  AND dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "GROUP BY lsp.MaLoaiSP, lsp.TenLoaiSP "
                + "ORDER BY doanhThu DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("tenLoai", rs.getString("TenLoaiSP"));
                    item.put("doanhThu", rs.getBigDecimal("doanhThu"));
                    item.put("soLuongBan", rs.getInt("soLuongBan"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy doanh thu theo danh mục", e);
        }
        return list;
    }

    // ===== PHÂN BỐ PHƯƠNG THỨC THANH TOÁN =====
    public List<Map<String, Object>> getPaymentMethodStats(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getPaymentMethodStats(startDate, endDate);
    }

    public List<Map<String, Object>> getPaymentMethodStats(LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT pttt.TenPTTT, COUNT(tt.MaThanhToan) as soLuong, "
                + "COALESCE(SUM(tt.SoTien), 0) as tongTien "
                + "FROM THANH_TOAN tt "
                + "JOIN PHUONG_THUC_THANH_TOAN pttt ON tt.MaPTTT = pttt.MaPTTT "
                + "JOIN DON_HANG dh ON tt.MaDonHang = dh.MaDonHang "
                + "WHERE dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "  AND tt.TrangThaiThanhToan = 'DA_THANH_TOAN' "
                + "GROUP BY pttt.MaPTTT, pttt.TenPTTT "
                + "ORDER BY soLuong DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("tenPTTT", rs.getString("TenPTTT"));
                    item.put("soLuong", rs.getInt("soLuong"));
                    item.put("tongTien", rs.getBigDecimal("tongTien"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy thống kê thanh toán", e);
        }
        return list;
    }

    // ===== TỔNG QUAN KPI =====
    public Map<String, Object> getKPISummary(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getKPISummary(startDate, endDate);
    }

    public Map<String, Object> getKPISummary(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> kpi = new LinkedHashMap<>();

        String sql = "SELECT "
                + "COUNT(*) as tongDon, "
                + "SUM(CASE WHEN TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') THEN 1 ELSE 0 END) as daGiao, "
                + "SUM(CASE WHEN TrangThaiDonHang IN ('DA_HUY', 'ĐÃ HỦY') THEN 1 ELSE 0 END) as daHuy, "
                + "SUM(CASE WHEN TrangThaiDonHang IN ('CHO_XAC_NHAN', 'CHỜ XÁC NHẬN') THEN 1 ELSE 0 END) as choXuLy, "
                + "COALESCE(SUM(CASE WHEN TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') THEN TongTien ELSE 0 END), 0) as doanhThu, "
                + "COALESCE(AVG(CASE WHEN TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') THEN TongTien END), 0) as aov "
                + "FROM DON_HANG "
                + "WHERE NgayDat >= ? AND NgayDat <= ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    kpi.put("tongDon", rs.getInt("tongDon"));
                    kpi.put("daGiao", rs.getInt("daGiao"));
                    kpi.put("daHuy", rs.getInt("daHuy"));
                    kpi.put("choXuLy", rs.getInt("choXuLy"));
                    kpi.put("doanhThu", rs.getBigDecimal("doanhThu"));
                    kpi.put("aov", rs.getBigDecimal("aov"));
                    int tong = rs.getInt("tongDon");
                    int huy = rs.getInt("daHuy");
                    kpi.put("tyLeHuy", tong > 0 ? (huy * 100.0 / tong) : 0.0);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy KPI tổng quan", e);
        }
        return kpi;
    }

    // ===== CHI TIẾT DOANH THU (cho tab Doanh thu) =====
    public List<Map<String, Object>> getRevenueDetails(int days, Integer categoryId, Integer staffId, int page,
            int pageSize) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getRevenueDetails(startDate, endDate, categoryId, staffId, page, pageSize);
    }

    public List<Map<String, Object>> getRevenueDetails(LocalDate startDate, LocalDate endDate, Integer categoryId, Integer staffId, int page,
            int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT dh.MaDonHang, dh.NgayDat, kh.HoTen as khachHang, "
                        + "nv.HoTen as nhanVien, dh.TongTien, dh.TrangThaiDonHang, "
                        + "GROUP_CONCAT(sp.TenSP SEPARATOR ', ') as sanPham, "
                        + "pttt.TenPTTT as phuongThuc "
                        + "FROM DON_HANG dh "
                        + "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
                        + "LEFT JOIN QUAN_TRI_VIEN nv ON dh.MaNV = nv.MaNV "
                        + "LEFT JOIN THANH_TOAN tt ON dh.MaDonHang = tt.MaDonHang AND tt.TrangThaiThanhToan = 'DA_THANH_TOAN' "
                        + "LEFT JOIN PHUONG_THUC_THANH_TOAN pttt ON tt.MaPTTT = pttt.MaPTTT "
                        + "LEFT JOIN CHI_TIET_DON_HANG ctdh ON dh.MaDonHang = ctdh.MaDonHang "
                        + "LEFT JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP "
                        + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' ");

        List<Object> params = new ArrayList<>();
        appendDateFilter(sql, params, startDate, endDate);
        appendCategoryFilter(sql, params, categoryId);
        appendStaffFilter(sql, params, staffId);

        sql.append(
                " GROUP BY dh.MaDonHang, dh.NgayDat, kh.HoTen, nv.HoTen, dh.TongTien, dh.TrangThaiDonHang, pttt.TenPTTT ")
                .append(" ORDER BY dh.NgayDat DESC ")
                .append(" LIMIT ? OFFSET ?");

        params.add(pageSize);
        params.add(page * pageSize);

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("maDonHang", rs.getInt("MaDonHang"));
                    item.put("ngayDat", rs.getTimestamp("NgayDat"));
                    item.put("khachHang", rs.getString("khachHang"));
                    item.put("nhanVien", rs.getString("nhanVien"));
                    item.put("tongTien", rs.getBigDecimal("TongTien"));
                    item.put("trangThai", rs.getString("TrangThaiDonHang"));
                    item.put("sanPham", rs.getString("sanPham"));
                    item.put("phuongThuc", rs.getString("phuongThuc"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy chi tiết doanh thu", e);
        }
        return list;
    }

    public int countRevenueDetails(int days, Integer categoryId, Integer staffId) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return countRevenueDetails(startDate, endDate, categoryId, staffId);
    }

    public int countRevenueDetails(LocalDate startDate, LocalDate endDate, Integer categoryId, Integer staffId) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT dh.MaDonHang) "
                        + "FROM DON_HANG dh "
                        + "JOIN CHI_TIET_DON_HANG ctdh ON dh.MaDonHang = ctdh.MaDonHang "
                        + "JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP "
                        + "WHERE dh.TrangThaiDonHang = 'DA_GIAO' ");

        List<Object> params = new ArrayList<>();
        appendDateFilter(sql, params, startDate, endDate);
        appendCategoryFilter(sql, params, categoryId);
        appendStaffFilter(sql, params, staffId);

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi đếm chi tiết doanh thu", e);
        }
        return 0;
    }

    // ===== TỒN KHO & SẢN PHẨM CHẬM BÁN (cho tab Sản phẩm) =====
    public List<Map<String, Object>> getStockReport(int page, int pageSize, String stockFilter) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT sp.MaSP, sp.TenSP, lsp.TenLoaiSP, sp.GiaBan, sp.SoLuongTon, "
                        + "(SELECT COALESCE(SUM(ctdh.SoLuong), 0) "
                        + "  FROM CHI_TIET_DON_HANG ctdh "
                        + "  JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                        + "  WHERE dh.TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') "
                        + "    AND ctdh.MaSP = sp.MaSP "
                        + "    AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 30 DAY)) as ban30Ngay, "
                        + "(SELECT MAX(dh.NgayDat) "
                        + "  FROM CHI_TIET_DON_HANG ctdh "
                        + "  JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                        + "  WHERE dh.TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') "
                        + "    AND ctdh.MaSP = sp.MaSP) as lanBanCuoi "
                        + "FROM SAN_PHAM sp "
                        + "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP "
                        + "WHERE sp.TrangThai = 1 ");

        if ("low".equals(stockFilter)) {
            sql.append(" AND sp.SoLuongTon <= 10 ");
        } else if ("out".equals(stockFilter)) {
            sql.append(" AND sp.SoLuongTon = 0 ");
        } else if ("slow".equals(stockFilter)) {
            sql.append(" AND NOT EXISTS ( "
                    + "  SELECT 1 FROM CHI_TIET_DON_HANG ctdh "
                    + "  JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                    + "  WHERE dh.TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') "
                    + "    AND ctdh.MaSP = sp.MaSP "
                    + "    AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 30 DAY)) ");
        }

        sql.append(" ORDER BY sp.SoLuongTon ASC, sp.TenSP LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, pageSize);
            ps.setInt(2, page * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("maSP", rs.getInt("MaSP"));
                    item.put("tenSP", rs.getString("TenSP"));
                    item.put("tenLoai", rs.getString("TenLoaiSP"));
                    item.put("giaBan", rs.getBigDecimal("GiaBan"));
                    item.put("soLuongTon", rs.getInt("SoLuongTon"));
                    item.put("ban30Ngay", rs.getInt("ban30Ngay"));
                    item.put("lanBanCuoi", rs.getTimestamp("lanBanCuoi"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy báo cáo tồn kho", e);
        }
        return list;
    }

    public int countStockReport(String stockFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM SAN_PHAM sp WHERE sp.TrangThai = 1 ");
        if ("low".equals(stockFilter))
            sql.append(" AND sp.SoLuongTon <= 10 ");
        else if ("out".equals(stockFilter))
            sql.append(" AND sp.SoLuongTon = 0 ");
        else if ("slow".equals(stockFilter)) {
            sql.append(" AND NOT EXISTS ( "
                    + "  SELECT 1 FROM CHI_TIET_DON_HANG ctdh "
                    + "  JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang "
                    + "  WHERE dh.TrangThaiDonHang = 'DA_GIAO' "
                    + "    AND ctdh.MaSP = sp.MaSP "
                    + "    AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 30 DAY)) ");
        }
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi đếm báo cáo tồn kho", e);
        }
        return 0;
    }

    // ===== KHÁCH HÀNG MỚI / QUAY LẠI (cho tab Khách hàng) =====
    public List<Map<String, Object>> getCustomerReport(int days, int page, int pageSize) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getCustomerReport(startDate, endDate, page, pageSize);
    }

    public List<Map<String, Object>> getCustomerReport(LocalDate startDate, LocalDate endDate, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT kh.MaKH, kh.HoTen, kh.Email, kh.SDT, "
                + "COUNT(dh.MaDonHang) as tongDon, "
                + "COALESCE(SUM(CASE WHEN dh.TrangThaiDonHang = 'DA_GIAO' THEN dh.TongTien END), 0) as tongTien, "
                + "MIN(dh.NgayDat) as donDau, MAX(dh.NgayDat) as donCuoi, "
                + "SUM(CASE WHEN dh.TrangThaiDonHang = 'DA_HUY' THEN 1 ELSE 0 END) as soDonHuy "
                + "FROM KHACH_HANG kh "
                + "LEFT JOIN DON_HANG dh ON kh.MaKH = dh.MaKH AND dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "GROUP BY kh.MaKH, kh.HoTen, kh.Email, kh.SDT "
                + "HAVING tongDon > 0 "
                + "ORDER BY tongTien DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            ps.setInt(3, pageSize);
            ps.setInt(4, page * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("maKH", rs.getInt("MaKH"));
                    item.put("hoTen", rs.getString("HoTen"));
                    item.put("email", rs.getString("Email"));
                    item.put("sdt", rs.getString("SDT"));
                    item.put("tongDon", rs.getInt("tongDon"));
                    item.put("tongTien", rs.getBigDecimal("tongTien"));
                    item.put("donDau", rs.getTimestamp("donDau"));
                    item.put("donCuoi", rs.getTimestamp("donCuoi"));
                    item.put("soDonHuy", rs.getInt("soDonHuy"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy báo cáo khách hàng", e);
        }
        return list;
    }

    public int countCustomerReport(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return countCustomerReport(startDate, endDate);
    }

    public int countCustomerReport(LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT COUNT(DISTINCT kh.MaKH) "
                + "FROM KHACH_HANG kh "
                + "JOIN DON_HANG dh ON kh.MaKH = dh.MaKH "
                + "WHERE dh.NgayDat >= ? AND dh.NgayDat <= ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi đếm báo cáo khách hàng", e);
        }
        return 0;
    }

    // ===== KHUYẾN MÃI (cho tab Khuyến mãi) =====
    public List<Map<String, Object>> getPromotionReport(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getPromotionReport(startDate, endDate);
    }

    public List<Map<String, Object>> getPromotionReport(LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT km.MaKM, km.TenKM, km.LoaiGiam, km.GiaTriGiam, "
                + "km.NgayBatDau, km.NgayKetThuc, km.TrangThai, "
                + "COUNT(dh.MaDonHang) as soDonSuDung, "
                + "COALESCE(SUM(dh.TongTien), 0) as tongGiaTriDon "
                + "FROM KHUYEN_MAI km "
                + "LEFT JOIN DON_HANG dh ON km.MaKM = dh.MaKM AND dh.NgayDat >= ? AND dh.NgayDat <= ? "
                + "WHERE km.NgayBatDau >= ? OR km.NgayKetThuc >= ? "
                + "GROUP BY km.MaKM, km.TenKM, km.LoaiGiam, km.GiaTriGiam, km.NgayBatDau, km.NgayKetThuc, km.TrangThai "
                + "ORDER BY soDonSuDung DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            ps.setDate(3, java.sql.Date.valueOf(startDate));
            ps.setDate(4, java.sql.Date.valueOf(startDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("maKM", rs.getInt("MaKM"));
                    item.put("tenKM", rs.getString("TenKM"));
                    item.put("loaiGiam", rs.getString("LoaiGiam"));
                    item.put("giaTriGiam", rs.getBigDecimal("GiaTriGiam"));
                    item.put("ngayBatDau", rs.getTimestamp("NgayBatDau"));
                    item.put("ngayKetThuc", rs.getTimestamp("NgayKetThuc"));
                    item.put("trangThai", rs.getInt("TrangThai"));
                    item.put("soDonSuDung", rs.getInt("soDonSuDung"));
                    item.put("tongGiaTriDon", rs.getBigDecimal("tongGiaTriDon"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi lấy báo cáo khuyến mãi", e);
        }
        return list;
    }

    // ===== PHÂN TÍCH ĐƠN HÀNG (cho tab Đơn hàng) =====
    public Map<String, Object> getOrderAnalysis(int days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        return getOrderAnalysis(startDate, endDate);
    }

    public Map<String, Object> getOrderAnalysis(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> result = new LinkedHashMap<>();

        // 1. Phân bố theo giờ trong ngày
        String sqlHour = "SELECT HOUR(NgayDat) as gio, COUNT(*) as soLuong "
                + "FROM DON_HANG WHERE NgayDat >= ? AND NgayDat <= ? GROUP BY HOUR(NgayDat) ORDER BY gio";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlHour)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            Map<Integer, Integer> byHour = new LinkedHashMap<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    byHour.put(rs.getInt("gio"), rs.getInt("soLuong"));
            }
            result.put("byHour", byHour);
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi phân tích theo giờ", e);
        }

        // 2. Lý do hủy (từ GhiChu)
        String sqlCancel = "SELECT GhiChu, COUNT(*) as soLuong "
                + "FROM DON_HANG WHERE TrangThaiDonHang IN ('DA_HUY', 'ĐÃ HỦY') AND NgayDat >= ? AND NgayDat <= ? AND GhiChu IS NOT NULL AND GhiChu != '' "
                + "GROUP BY GhiChu ORDER BY soLuong DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlCancel)) {
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate.plusDays(1)));
            List<Map<String, Object>> cancelReasons = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("lyDo", rs.getString("GhiChu"));
                    item.put("soLuong", rs.getInt("soLuong"));
                    cancelReasons.add(item);
                }
            }
            result.put("cancelReasons", cancelReasons);
        } catch (SQLException e) {
            throw new DatabaseException("Lỗi phân tích lý do hủy", e);
        }

        // 3. Thời gian xử lý trung bình (từ CHO_XAC_NHAN -> DA_GIAO)
        String sqlTime = "SELECT AVG(TIMESTAMPDIFF(HOUR, dh.NgayDat, dh.NgayDat)) as tbGio "
                + "FROM DON_HANG dh WHERE dh.TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO') AND dh.NgayDat >= ? AND dh.NgayDat <= ?";
        // Note: Simplified - would need audit log for accurate processing time
        result.put("avgProcessHours", 24.0); // Placeholder

        return result;
    }
}
