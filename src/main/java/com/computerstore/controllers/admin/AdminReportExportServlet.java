package com.computerstore.controllers.admin;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
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

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.DefaultIndexedColorMap;

@WebServlet("/admin/reports/export")
public class AdminReportExportServlet extends HttpServlet {
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

        if ("revenue".equals(tab)) pageSize = 10000;
        else if ("products".equals(tab)) pageSize = 10000;
        else if ("customers".equals(tab)) pageSize = 10000;

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(getSheetName(tab));
            createStyles(workbook);

            int startRow = writeTitleBlock(sheet, getSheetName(tab), startDate, endDate);
            int headerRowIndex = startRow;

            switch (tab) {
                case "overview": exportOverview(sheet, startDate, endDate, startRow); break;
                case "revenue": exportRevenueDetails(sheet, startDate, endDate, page, pageSize, startRow); break;
                case "products": exportProducts(sheet, page, pageSize, startRow); break;
                case "customers": exportCustomers(sheet, startDate, endDate, page, pageSize, startRow); break;
                case "orders": exportOrderAnalysis(sheet, startDate, endDate, startRow); break;
                case "promotions": exportPromotions(sheet, startDate, endDate, startRow); break;
                case "payments": exportPayments(sheet, startDate, endDate, startRow); break;
            }

            Row headerRow = sheet.getRow(headerRowIndex);
            if (headerRow != null) {
                for (int i = 0; i < headerRow.getLastCellNum(); i++) {
                    sheet.autoSizeColumn(i);
                    int currentWidth = sheet.getColumnWidth(i);
                    sheet.setColumnWidth(i, currentWidth + 2000);
                }
            } else {
                for (int i = 0; i < 15; i++) sheet.autoSizeColumn(i);
            }

            String filename = "bao-cao-" + tab + "-" + java.time.LocalDate.now() + ".xlsx";
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            try (OutputStream out = resp.getOutputStream()) { workbook.write(out); }
        } catch (IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private String getSheetName(String tab) {
        return switch (tab) {
            case "overview" -> "Tổng quan"; case "revenue" -> "Doanh thu chi tiết";
            case "products" -> "Sản phẩm & Tồn kho"; case "customers" -> "Khách hàng";
            case "orders" -> "Phân tích đơn hàng"; case "promotions" -> "Khuyến mãi";
            case "payments" -> "Thanh toán"; default -> "Báo cáo";
        };
    }

    private CellStyle headerStyle, dataStyle, dataStyleZebra, currencyStyle, currencyStyleZebra, dateStyle, dateStyleZebra;
    private CellStyle centerStyle, centerStyleZebra, idStyle, idStyleZebra, alertStyle, alertStyleZebra;
    private CellStyle warningStyle, warningStyleZebra;
    private CellStyle statusGreenStyle, statusGreenStyleZebra;
    private CellStyle statusRedStyle, statusRedStyleZebra;
    private CellStyle statusOrangeStyle, statusOrangeStyleZebra;
    private CellStyle summaryStyle, summaryCurrencyStyle;

    private void createStyles(Workbook wb) {
        Font fontRegular = wb.createFont(); fontRegular.setFontName("Segoe UI"); fontRegular.setFontHeightInPoints((short) 10);
        Font fontBold = wb.createFont(); fontBold.setFontName("Segoe UI"); fontBold.setFontHeightInPoints((short) 10); fontBold.setBold(true);
        Font fontHeader = wb.createFont(); fontHeader.setFontName("Segoe UI"); fontHeader.setFontHeightInPoints((short) 11); fontHeader.setBold(true); fontHeader.setColor(IndexedColors.WHITE.getIndex());
        
        Font fontId = wb.createFont(); fontId.setFontName("Segoe UI"); fontId.setFontHeightInPoints((short) 10); fontId.setBold(true);
        if (fontId instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(52, 73, 94), new DefaultIndexedColorMap()));

        Font fontAlert = wb.createFont(); fontAlert.setFontName("Segoe UI"); fontAlert.setFontHeightInPoints((short) 10); fontAlert.setBold(true);
        if (fontAlert instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(185, 28, 28), new DefaultIndexedColorMap()));

        Font fontOrange = wb.createFont(); fontOrange.setFontName("Segoe UI"); fontOrange.setFontHeightInPoints((short) 10); fontOrange.setBold(true);
        if (fontOrange instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(180, 83, 9), new DefaultIndexedColorMap()));

        Font fontGreen = wb.createFont(); fontGreen.setFontName("Segoe UI"); fontGreen.setFontHeightInPoints((short) 10); fontGreen.setBold(true);
        if (fontGreen instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(21, 128, 61), new DefaultIndexedColorMap()));

        java.awt.Color primaryBg = new java.awt.Color(26, 82, 118);
        java.awt.Color zebraBg = new java.awt.Color(248, 250, 252);
        java.awt.Color alertBg = new java.awt.Color(254, 226, 226);
        java.awt.Color borderCol = new java.awt.Color(226, 232, 240);
        java.awt.Color summaryBg = new java.awt.Color(236, 244, 250);
        java.awt.Color lightGreen = new java.awt.Color(220, 252, 231);
        java.awt.Color lightOrange = new java.awt.Color(254, 243, 199);

        headerStyle = createStyle(wb, fontHeader, HorizontalAlignment.CENTER, primaryBg, borderCol, BorderStyle.THIN);
        dataStyle = createStyle(wb, fontRegular, HorizontalAlignment.LEFT, null, borderCol, BorderStyle.THIN);
        dataStyleZebra = createStyle(wb, fontRegular, HorizontalAlignment.LEFT, zebraBg, borderCol, BorderStyle.THIN);

        centerStyle = createStyle(wb, fontRegular, HorizontalAlignment.CENTER, null, borderCol, BorderStyle.THIN);
        centerStyleZebra = createStyle(wb, fontRegular, HorizontalAlignment.CENTER, zebraBg, borderCol, BorderStyle.THIN);

        idStyle = createStyle(wb, fontId, HorizontalAlignment.CENTER, null, borderCol, BorderStyle.THIN);
        idStyleZebra = createStyle(wb, fontId, HorizontalAlignment.CENTER, zebraBg, borderCol, BorderStyle.THIN);

        alertStyle = createStyle(wb, fontAlert, HorizontalAlignment.CENTER, alertBg, borderCol, BorderStyle.THIN);
        alertStyleZebra = alertStyle;

        warningStyle = createStyle(wb, fontOrange, HorizontalAlignment.CENTER, lightOrange, borderCol, BorderStyle.THIN);
        warningStyleZebra = warningStyle;

        statusGreenStyle = createStyle(wb, fontGreen, HorizontalAlignment.CENTER, lightGreen, borderCol, BorderStyle.THIN);
        statusGreenStyleZebra = statusGreenStyle;

        statusRedStyle = createStyle(wb, fontAlert, HorizontalAlignment.CENTER, alertBg, borderCol, BorderStyle.THIN);
        statusRedStyleZebra = statusRedStyle;

        statusOrangeStyle = createStyle(wb, fontOrange, HorizontalAlignment.CENTER, lightOrange, borderCol, BorderStyle.THIN);
        statusOrangeStyleZebra = statusOrangeStyle;

        currencyStyle = createStyle(wb, fontBold, HorizontalAlignment.RIGHT, null, borderCol, BorderStyle.THIN);
        currencyStyle.setDataFormat(wb.createDataFormat().getFormat("#,##0"));

        currencyStyleZebra = createStyle(wb, fontBold, HorizontalAlignment.RIGHT, zebraBg, borderCol, BorderStyle.THIN);
        currencyStyleZebra.setDataFormat(wb.createDataFormat().getFormat("#,##0"));

        dateStyle = createStyle(wb, fontRegular, HorizontalAlignment.CENTER, null, borderCol, BorderStyle.THIN);
        dateStyle.setDataFormat(wb.createDataFormat().getFormat("dd/MM/yyyy HH:mm"));

        dateStyleZebra = createStyle(wb, fontRegular, HorizontalAlignment.CENTER, zebraBg, borderCol, BorderStyle.THIN);
        dateStyleZebra.setDataFormat(wb.createDataFormat().getFormat("dd/MM/yyyy HH:mm"));

        summaryStyle = wb.createCellStyle();
        summaryStyle.setFont(fontBold);
        summaryStyle.setAlignment(HorizontalAlignment.LEFT);
        summaryStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        if (summaryStyle instanceof XSSFCellStyle xssfStyle) {
            xssfStyle.setFillForegroundColor(new XSSFColor(summaryBg, new DefaultIndexedColorMap()));
            xssfStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            XSSFColor xssfBorder = new XSSFColor(borderCol, new DefaultIndexedColorMap());
            xssfStyle.setBorderTop(BorderStyle.THIN);
            xssfStyle.setBorderBottom(BorderStyle.DOUBLE);
            xssfStyle.setTopBorderColor(xssfBorder);
            xssfStyle.setBottomBorderColor(xssfBorder);
        }

        summaryCurrencyStyle = wb.createCellStyle();
        summaryCurrencyStyle.cloneStyleFrom(summaryStyle);
        summaryCurrencyStyle.setAlignment(HorizontalAlignment.RIGHT);
        summaryCurrencyStyle.setDataFormat(wb.createDataFormat().getFormat("#,##0"));
    }

    private CellStyle createStyle(Workbook wb, Font font, HorizontalAlignment align, java.awt.Color bg, java.awt.Color border, BorderStyle borderStyle) {
        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        style.setAlignment(align);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        if (style instanceof XSSFCellStyle xssfStyle) {
            if (bg != null) {
                XSSFColor xssfBg = new XSSFColor(bg, new DefaultIndexedColorMap());
                xssfStyle.setFillForegroundColor(xssfBg);
                xssfStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            }
            if (border != null && borderStyle != null) {
                XSSFColor xssfBorder = new XSSFColor(border, new DefaultIndexedColorMap());
                xssfStyle.setBorderBottom(borderStyle);
                xssfStyle.setBorderTop(borderStyle);
                xssfStyle.setBorderLeft(borderStyle);
                xssfStyle.setBorderRight(borderStyle);
                xssfStyle.setBottomBorderColor(xssfBorder);
                xssfStyle.setTopBorderColor(xssfBorder);
                xssfStyle.setLeftBorderColor(xssfBorder);
                xssfStyle.setRightBorderColor(xssfBorder);
            }
        }
        return style;
    }

    private int writeTitleBlock(Sheet sheet, String title, LocalDate startDate, LocalDate endDate) {
        Workbook wb = sheet.getWorkbook();
        
        Font titleFont = wb.createFont(); titleFont.setBold(true); titleFont.setFontHeightInPoints((short) 14); titleFont.setFontName("Segoe UI");
        if (titleFont instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(26, 82, 118), new DefaultIndexedColorMap()));
        CellStyle titleStyle = wb.createCellStyle(); titleStyle.setFont(titleFont);
        
        Font subFont = wb.createFont(); subFont.setBold(true); subFont.setFontHeightInPoints((short) 12); subFont.setFontName("Segoe UI");
        if (subFont instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(52, 73, 94), new DefaultIndexedColorMap()));
        CellStyle subStyle = wb.createCellStyle(); subStyle.setFont(subFont);
        
        Font metaFont = wb.createFont(); metaFont.setItalic(true); metaFont.setFontHeightInPoints((short) 9); metaFont.setFontName("Segoe UI");
        if (metaFont instanceof XSSFFont xf) xf.setColor(new XSSFColor(new java.awt.Color(100, 116, 139), new DefaultIndexedColorMap()));
        CellStyle metaStyle = wb.createCellStyle(); metaStyle.setFont(metaFont);
        
        Row row0 = sheet.createRow(0);
        Cell cell0 = row0.createCell(0);
        cell0.setCellValue("COMPUTER STORE - HỆ THỐNG MÁY TÍNH & LINH KIỆN CHÍNH HÃNG");
        cell0.setCellStyle(titleStyle);
        
        Row row1 = sheet.createRow(1);
        Cell cell1 = row1.createCell(0);
        cell1.setCellValue("BÁO CÁO: " + title.toUpperCase());
        cell1.setCellStyle(subStyle);
        
        Row row2 = sheet.createRow(2);
        Cell cell2 = row2.createCell(0);
        String metadata = "Khoảng thời gian: ";
        if (startDate != null && endDate != null) {
            metadata += startDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " - " + endDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        } else {
            metadata += "Tất cả";
        }
        metadata += " | Ngày xuất: " + java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        cell2.setCellValue(metadata);
        cell2.setCellStyle(metaStyle);
        
        return 4;
    }

    private void writeHeader(Sheet sheet, int rowNum, String... headers) {
        Row row = sheet.createRow(rowNum);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = row.createCell(i); cell.setCellValue(headers[i]); cell.setCellStyle(headerStyle);
        }
    }

    private void writeRow(Sheet sheet, int rowNum, Object... values) {
        Row row = sheet.createRow(rowNum);
        boolean isZebra = (rowNum % 2 == 0);
        for (int i = 0; i < values.length; i++) {
            Cell cell = row.createCell(i); Object val = values[i];
            
            if (val instanceof String strVal) {
                CellStyle statusStyle = getStatusStyle(strVal);
                if (statusStyle != null) {
                    cell.setCellValue(strVal);
                    cell.setCellStyle(statusStyle);
                    continue;
                }
            }

            if (val instanceof BigDecimal || (val instanceof Number && isCurrencyRowOrCol(sheet, i, values))) {
                cell.setCellValue(val != null ? ((Number) val).doubleValue() : 0.0);
                cell.setCellStyle(isZebra ? currencyStyleZebra : currencyStyle);
            } else if (val instanceof Number) {
                cell.setCellValue(val != null ? ((Number) val).doubleValue() : 0.0);
                CellStyle s = isZebra ? centerStyleZebra : centerStyle;
                if (i == 4 && isStockColumn(sheet, i)) {
                    double stockVal = ((Number) val).doubleValue();
                    if (stockVal == 0) s = alertStyle;
                    else if (stockVal <= 10) s = warningStyle;
                } else if (i == 8 && isCancelColumn(sheet, i)) {
                    double cancelVal = ((Number) val).doubleValue();
                    if (cancelVal > 0) s = warningStyle;
                }
                cell.setCellStyle(s);
            } else if (val instanceof java.sql.Timestamp) {
                cell.setCellValue((java.sql.Timestamp) val);
                cell.setCellStyle(isZebra ? dateStyleZebra : dateStyle);
            } else if (val instanceof java.time.LocalDate) {
                cell.setCellValue(java.sql.Date.valueOf((java.time.LocalDate) val));
                cell.setCellStyle(isZebra ? dateStyleZebra : dateStyle);
            } else {
                cell.setCellValue(val != null ? val.toString() : "");
                if (i == 0 && val != null && (val.toString().startsWith("#") || val.toString().matches("\\d+"))) {
                    cell.setCellStyle(isZebra ? idStyleZebra : idStyle);
                } else {
                    cell.setCellStyle(isZebra ? dataStyleZebra : dataStyle);
                }
            }
        }
    }

    private CellStyle getStatusStyle(String val) {
        if (val == null) return null;
        String s = val.trim().toLowerCase();
        if (s.equals("đã giao") || s.equals("đang chạy")) return statusGreenStyle;
        if (s.equals("đã hủy") || s.equals("hết hạn")) return statusRedStyle;
        if (s.equals("chờ xử lý") || s.equals("chờ chạy")) return statusOrangeStyle;
        return null;
    }

    private boolean isCurrencyRowOrCol(Sheet sheet, int colIndex, Object[] values) {
        if (values.length > 0 && values[0] != null) {
            String label = values[0].toString().toLowerCase();
            if (colIndex == 1 && (label.contains("doanh thu") || label.contains("aov") || label.contains("tiền"))) {
                return true;
            }
        }
        return isCurrencyColumn(sheet, colIndex);
    }

    private boolean isCurrencyColumn(Sheet sheet, int colIndex) {
        for (int r = sheet.getLastRowNum(); r >= 0; r--) {
            Row row = sheet.getRow(r);
            if (row != null) {
                Cell cell = row.getCell(colIndex);
                if (cell != null && cell.getCellStyle() == headerStyle) {
                    String headerVal = cell.getStringCellValue().toLowerCase();
                    return headerVal.contains("tiền") || headerVal.contains("giá") || headerVal.contains("doanh") || headerVal.contains("aov") || headerVal.contains("chi tiêu") || headerVal.contains("giảm");
                }
            }
        }
        return false;
    }

    private boolean isStockColumn(Sheet sheet, int colIndex) {
        for (int r = sheet.getLastRowNum(); r >= 0; r--) {
            Row row = sheet.getRow(r);
            if (row != null) {
                Cell cell = row.getCell(colIndex);
                if (cell != null && cell.getCellStyle() == headerStyle) {
                    return cell.getStringCellValue().toLowerCase().contains("tồn kho");
                }
            }
        }
        return false;
    }

    private boolean isCancelColumn(Sheet sheet, int colIndex) {
        for (int r = sheet.getLastRowNum(); r >= 0; r--) {
            Row row = sheet.getRow(r);
            if (row != null) {
                Cell cell = row.getCell(colIndex);
                if (cell != null && cell.getCellStyle() == headerStyle) {
                    return cell.getStringCellValue().toLowerCase().contains("hủy");
                }
            }
        }
        return false;
    }

    private void exportOverview(Sheet sheet, LocalDate startDate, LocalDate endDate, int rowNum) {
        Map<String, Object> kpi = statsService.getKPISummary(startDate, endDate);
        writeHeader(sheet, rowNum++, "Chỉ số", "Giá trị");
        writeRow(sheet, rowNum++, "Tổng đơn hàng", kpi.get("tongDon"));
        writeRow(sheet, rowNum++, "Đã giao", kpi.get("daGiao"));
        writeRow(sheet, rowNum++, "Đã hủy", kpi.get("daHuy"));
        writeRow(sheet, rowNum++, "Chờ xử lý", kpi.get("choXuLy"));
        writeRow(sheet, rowNum++, "Doanh thu (VNĐ)", kpi.get("doanhThu"));
        writeRow(sheet, rowNum++, "AOV (VNĐ)", kpi.get("aov"));
        writeRow(sheet, rowNum++, "Tỷ lệ hủy (%)", kpi.get("tyLeHuy"));
    }

    private void exportRevenueDetails(Sheet sheet, LocalDate startDate, LocalDate endDate, int page, int pageSize, int rowNum) {
        List<Map<String, Object>> data = statsService.getRevenueDetails(startDate, endDate, null, null, page, pageSize);
        writeHeader(sheet, rowNum++, "Mã ĐH", "Ngày đặt", "Khách hàng", "Nhân viên", "Tổng tiền (VNĐ)", "Trạng thái", "Sản phẩm", "Phương thức TT");
        for (Map<String, Object> item : data) {
            writeRow(sheet, rowNum++, item.get("maDonHang"), item.get("ngayDat"), item.get("khachHang"), item.get("nhanVien"), item.get("tongTien"), item.get("trangThai"), item.get("sanPham"), item.get("phuongThuc"));
        }
        
        double totalRevenue = data.stream()
            .mapToDouble(item -> item.get("tongTien") != null ? ((Number) item.get("tongTien")).doubleValue() : 0.0)
            .sum();
        
        Row summaryRow = sheet.createRow(rowNum++);
        for (int i = 0; i < 8; i++) {
            Cell cell = summaryRow.createCell(i);
            cell.setCellStyle(summaryStyle);
        }
        summaryRow.getCell(0).setCellValue("TỔNG CỘNG");
        summaryRow.getCell(4).setCellValue(totalRevenue);
        summaryRow.getCell(4).setCellStyle(summaryCurrencyStyle);
    }

    private void exportProducts(Sheet sheet, int page, int pageSize, int rowNum) {
        List<Map<String, Object>> data = statsService.getStockReport(page, pageSize, "all");
        writeHeader(sheet, rowNum++, "Mã SP", "Tên sản phẩm", "Danh mục", "Giá bán (VNĐ)", "Tồn kho", "Bán 30 ngày", "Lần bán cuối");
        for (Map<String, Object> item : data) {
            writeRow(sheet, rowNum++, item.get("maSP"), item.get("tenSP"), item.get("tenLoai"), item.get("giaBan"), item.get("soLuongTon"), item.get("ban30Ngay"), item.get("lanBanCuoi"));
        }

        int totalStock = data.stream()
            .mapToInt(item -> item.get("soLuongTon") != null ? ((Number) item.get("soLuongTon")).intValue() : 0)
            .sum();

        Row summaryRow = sheet.createRow(rowNum++);
        for (int i = 0; i < 7; i++) {
            Cell cell = summaryRow.createCell(i);
            cell.setCellStyle(summaryStyle);
        }
        summaryRow.getCell(0).setCellValue("TỔNG CỘNG");
        summaryRow.getCell(4).setCellValue(totalStock);
        
        CellStyle summaryCenter = sheet.getWorkbook().createCellStyle();
        summaryCenter.cloneStyleFrom(summaryStyle);
        summaryCenter.setAlignment(HorizontalAlignment.CENTER);
        summaryRow.getCell(4).setCellStyle(summaryCenter);
    }

    private void exportCustomers(Sheet sheet, LocalDate startDate, LocalDate endDate, int page, int pageSize, int rowNum) {
        List<Map<String, Object>> data = statsService.getCustomerReport(startDate, endDate, page, pageSize);
        writeHeader(sheet, rowNum++, "Mã KH", "Họ tên", "Email", "SĐT", "Tổng đơn", "Tổng tiền (VNĐ)", "Đơn đầu", "Đơn cuối", "Số đơn hủy");
        for (Map<String, Object> item : data) {
            writeRow(sheet, rowNum++, item.get("maKH"), item.get("hoTen"), item.get("email"), item.get("sdt"), item.get("tongDon"), item.get("tongTien"), item.get("donDau"), item.get("donCuoi"), item.get("soDonHuy"));
        }

        int totalOrders = data.stream()
            .mapToInt(item -> item.get("tongDon") != null ? ((Number) item.get("tongDon")).intValue() : 0)
            .sum();
        double totalSpent = data.stream()
            .mapToDouble(item -> item.get("tongTien") != null ? ((Number) item.get("tongTien")).doubleValue() : 0.0)
            .sum();
        int totalCancelled = data.stream()
            .mapToInt(item -> item.get("soDonHuy") != null ? ((Number) item.get("soDonHuy")).intValue() : 0)
            .sum();

        Row summaryRow = sheet.createRow(rowNum++);
        for (int i = 0; i < 9; i++) {
            Cell cell = summaryRow.createCell(i);
            cell.setCellStyle(summaryStyle);
        }
        summaryRow.getCell(0).setCellValue("TỔNG CỘNG");
        summaryRow.getCell(4).setCellValue(totalOrders);
        summaryRow.getCell(5).setCellValue(totalSpent);
        summaryRow.getCell(5).setCellStyle(summaryCurrencyStyle);
        summaryRow.getCell(8).setCellValue(totalCancelled);

        CellStyle summaryCenter = sheet.getWorkbook().createCellStyle();
        summaryCenter.cloneStyleFrom(summaryStyle);
        summaryCenter.setAlignment(HorizontalAlignment.CENTER);
        summaryRow.getCell(4).setCellStyle(summaryCenter);
        summaryRow.getCell(8).setCellStyle(summaryCenter);
    }

    private void exportOrderAnalysis(Sheet sheet, LocalDate startDate, LocalDate endDate, int rowNum) {
        Map<String, Object> analysis = statsService.getOrderAnalysis(startDate, endDate);
        writeHeader(sheet, rowNum++, "Giờ trong ngày", "Số đơn hàng");
        @SuppressWarnings("unchecked") Map<Integer, Integer> byHour = (Map<Integer, Integer>) analysis.get("byHour");
        if (byHour != null) for (Map.Entry<Integer, Integer> e : byHour.entrySet()) writeRow(sheet, rowNum++, e.getKey() + ":00", e.getValue());
        rowNum++;
        writeHeader(sheet, rowNum++, "Lý do hủy", "Số lượng");
        @SuppressWarnings("unchecked") List<Map<String, Object>> cancelReasons = (List<Map<String, Object>>) analysis.get("cancelReasons");
        if (cancelReasons != null) for (Map<String, Object> item : cancelReasons) writeRow(sheet, rowNum++, item.get("lyDo"), item.get("soLuong"));
    }

    private void exportPromotions(Sheet sheet, LocalDate startDate, LocalDate endDate, int rowNum) {
        List<Map<String, Object>> data = statsService.getPromotionReport(startDate, endDate);
        writeHeader(sheet, rowNum++, "Mã KM", "Tên KM", "Loại giảm", "Giá trị giảm", "Ngày bắt đầu", "Ngày kết thúc", "Trạng thái", "Số đơn dùng", "Tổng giá trị đơn (VNĐ)");
        for (Map<String, Object> item : data) {
            Object statusObj = item.get("trangThai");
            String statusStr = "Chờ chạy";
            if (statusObj instanceof Number num) {
                int status = num.intValue();
                if (status == 1) statusStr = "Đang chạy";
                else if (status == 2) statusStr = "Hết hạn";
            }
            writeRow(sheet, rowNum++, item.get("maKM"), item.get("tenKM"), item.get("loaiGiam"), item.get("giaTriGiam"), item.get("ngayBatDau"), item.get("ngayKetThuc"), statusStr, item.get("soDonSuDung"), item.get("tongGiaTriDon"));
        }

        int totalUsed = data.stream()
            .mapToInt(item -> item.get("soDonSuDung") != null ? ((Number) item.get("soDonSuDung")).intValue() : 0)
            .sum();
        double totalValue = data.stream()
            .mapToDouble(item -> item.get("tongGiaTriDon") != null ? ((Number) item.get("tongGiaTriDon")).doubleValue() : 0.0)
            .sum();

        Row summaryRow = sheet.createRow(rowNum++);
        for (int i = 0; i < 9; i++) {
            Cell cell = summaryRow.createCell(i);
            cell.setCellStyle(summaryStyle);
        }
        summaryRow.getCell(0).setCellValue("TỔNG CỘNG");
        summaryRow.getCell(7).setCellValue(totalUsed);
        summaryRow.getCell(8).setCellValue(totalValue);
        summaryRow.getCell(8).setCellStyle(summaryCurrencyStyle);

        CellStyle summaryCenter = sheet.getWorkbook().createCellStyle();
        summaryCenter.cloneStyleFrom(summaryStyle);
        summaryCenter.setAlignment(HorizontalAlignment.CENTER);
        summaryRow.getCell(7).setCellStyle(summaryCenter);
    }

    private void exportPayments(Sheet sheet, LocalDate startDate, LocalDate endDate, int rowNum) {
        List<Map<String, Object>> data = statsService.getPaymentMethodStats(startDate, endDate);
        writeHeader(sheet, rowNum++, "Phương thức", "Số lượng", "Tổng tiền (VNĐ)");
        for (Map<String, Object> item : data) writeRow(sheet, rowNum++, item.get("tenPTTT"), item.get("soLuong"), item.get("tongTien"));

        int totalOrders = data.stream()
            .mapToInt(item -> item.get("soLuong") != null ? ((Number) item.get("soLuong")).intValue() : 0)
            .sum();
        double totalAmount = data.stream()
            .mapToDouble(item -> item.get("tongTien") != null ? ((Number) item.get("tongTien")).doubleValue() : 0.0)
            .sum();

        Row summaryRow = sheet.createRow(rowNum++);
        for (int i = 0; i < 3; i++) {
            Cell cell = summaryRow.createCell(i);
            cell.setCellStyle(summaryStyle);
        }
        summaryRow.getCell(0).setCellValue("TỔNG CỘNG");
        summaryRow.getCell(1).setCellValue(totalOrders);
        summaryRow.getCell(2).setCellValue(totalAmount);
        summaryRow.getCell(2).setCellStyle(summaryCurrencyStyle);

        CellStyle summaryCenter = sheet.getWorkbook().createCellStyle();
        summaryCenter.cloneStyleFrom(summaryStyle);
        summaryCenter.setAlignment(HorizontalAlignment.CENTER);
        summaryRow.getCell(1).setCellStyle(summaryCenter);
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
}
