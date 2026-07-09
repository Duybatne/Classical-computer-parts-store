package com.computerstore.services;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class ReportGeneratorService {

        private static final NumberFormat VND_FORMAT = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        private static final DateTimeFormatter DATE_ONLY_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Professional Corporate Color Palette
        private static final DeviceRgb PRIMARY_COLOR = new DeviceRgb(26, 82, 118);   // Steel Blue #1A5276
        private static final DeviceRgb SECONDARY_COLOR = new DeviceRgb(52, 73, 94);   // Dark Slate #34495E
        private static final DeviceRgb BORDER_COLOR = new DeviceRgb(226, 232, 240);   // Slate 200 #E2E8F0
        private static final DeviceRgb BG_LIGHT = new DeviceRgb(248, 250, 252);       // Slate 50 #F8FAFC
        private static final DeviceRgb TEXT_MUTED = new DeviceRgb(100, 116, 139);     // Slate 500 #64748B
        private static final DeviceRgb ALERT_BG = new DeviceRgb(254, 226, 226);       // Red 100 #FEE2E2
        private static final DeviceRgb ALERT_TEXT = new DeviceRgb(185, 28, 28);       // Red 700 #B91C1C

        // System Font paths for full Vietnamese Unicode support
        private static final String FONT_PATH = "/usr/share/fonts/truetype/msttcorefonts/Arial.ttf";
        private static final String FONT_BOLD_PATH = "/usr/share/fonts/truetype/msttcorefonts/Arial_Bold.ttf";

        private PdfFont getRegularFont() throws IOException {
                return PdfFontFactory.createFont(FONT_PATH, PdfEncodings.IDENTITY_H);
        }

        private PdfFont getBoldFont() throws IOException {
                return PdfFontFactory.createFont(FONT_BOLD_PATH, PdfEncodings.IDENTITY_H);
        }

        /**
         * Adds a professional, consistent header banner to the report document.
         */
        private void addStoreHeader(Document document, PdfFont font, PdfFont fontBold, String reportTitle) throws IOException {
                Table headerTable = new Table(UnitValue.createPercentArray(new float[]{6, 4})).useAllAvailableWidth().setMarginBottom(10);
                
                // Left side: Store Branding Info
                Cell leftCell = new Cell().setBorder(Border.NO_BORDER);
                leftCell.add(new Paragraph("COMPUTER STORE")
                        .setFont(fontBold).setFontSize(14).setFontColor(PRIMARY_COLOR));
                leftCell.add(new Paragraph("Hệ thống bán lẻ linh kiện & máy tính chính hãng")
                        .setFont(font).setFontSize(8).setFontColor(TEXT_MUTED));
                leftCell.add(new Paragraph("Địa chỉ: 123 Đường Cầu Giấy, Hà Nội | Hotline: 1900 1234")
                        .setFont(font).setFontSize(8).setFontColor(TEXT_MUTED));
                headerTable.addCell(leftCell);
                
                // Right side: Document Metadata & Title
                Cell rightCell = new Cell().setBorder(Border.NO_BORDER);
                rightCell.add(new Paragraph(reportTitle.toUpperCase())
                        .setFont(fontBold).setFontSize(11).setFontColor(SECONDARY_COLOR).setTextAlignment(TextAlignment.RIGHT));
                rightCell.add(new Paragraph("Ngày xuất: " + LocalDateTime.now().format(DATE_FORMAT))
                        .setFont(font).setFontSize(8).setFontColor(TEXT_MUTED).setTextAlignment(TextAlignment.RIGHT));
                headerTable.addCell(rightCell);
                
                document.add(headerTable);
                
                // Decorative Accent Bar (Top Border)
                Table accentBar = new Table(1).useAllAvailableWidth().setMarginBottom(15);
                Cell barCell = new Cell().setBorder(Border.NO_BORDER).setHeight(3f).setBackgroundColor(PRIMARY_COLOR);
                accentBar.addCell(barCell);
                document.add(accentBar);
        }

        public byte[] generateRevenueReportPdf(List<Map<String, Object>> data, String startDate, String endDate,
                        String categoryId, String staffId) throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4.rotate());
                pdf.setDefaultPageSize(PageSize.A4.rotate());

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO DOANH THU CHI TIẾT");

                Paragraph subtitle = new Paragraph("Thời gian: từ " + startDate + " đến " + endDate +
                                (categoryId != null && !categoryId.isEmpty() ? " | Danh mục: " + categoryId : "") +
                                (staffId != null && !staffId.isEmpty() ? " | Nhân viên: " + staffId : ""))
                                .setFont(font).setFontSize(9).setFontColor(SECONDARY_COLOR)
                                .setMarginBottom(15);
                document.add(subtitle);

                float[] columnWidths = { 1, 2, 3, 3, 3, 6, 3, 3 };
                Table table = new Table(UnitValue.createPercentArray(columnWidths)).useAllAvailableWidth();

                String[] headers = { "STT", "Mã đơn", "Ngày đặt", "Khách hàng", "Nhân viên", "Sản phẩm",
                                "Thanh toán", "Tổng tiền" };
                for (String h : headers) {
                        Cell cell = new Cell()
                                        .setBackgroundColor(PRIMARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        table.addHeaderCell(cell);
                }

                int stt = 1;
                BigDecimal totalRevenue = BigDecimal.ZERO;
                for (Map<String, Object> row : data) {
                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        
                        Cell cellId = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("maDonHang") != null ? "#" + row.get("maDonHang").toString() : "")
                                                        .setFont(fontBold).setFontSize(8f).setFontColor(SECONDARY_COLOR));

                        Object ngayDatObj = row.get("ngayDat");
                        String ngayDatStr = "";
                        if (ngayDatObj instanceof java.sql.Timestamp) {
                            ngayDatStr = ((java.sql.Timestamp) ngayDatObj).toLocalDateTime().format(DATE_FORMAT);
                        } else if (ngayDatObj != null) {
                            ngayDatStr = ngayDatObj.toString();
                        }
                        Cell cellNgay = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(ngayDatStr).setFont(font).setFontSize(8f)
                                                        .setTextAlignment(TextAlignment.CENTER));

                        Cell cellKh = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("khachHang") != null ? row.get("khachHang").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellNv = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("nhanVien") != null ? row.get("nhanVien").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellSp = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("sanPham") != null ? row.get("sanPham").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellPt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("phuongThuc") != null ? row.get("phuongThuc").toString() : "")
                                                        .setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        BigDecimal tongTien = row.get("tongTien") != null ? new BigDecimal(row.get("tongTien").toString()) : BigDecimal.ZERO;
                        Cell cellTien = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(VND_FORMAT.format(tongTien)).setFont(fontBold).setFontSize(8f)
                                                         .setTextAlignment(TextAlignment.RIGHT));

                        // Zebra striping
                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellId.setBackgroundColor(BG_LIGHT);
                                cellNgay.setBackgroundColor(BG_LIGHT);
                                cellKh.setBackgroundColor(BG_LIGHT);
                                cellNv.setBackgroundColor(BG_LIGHT);
                                cellSp.setBackgroundColor(BG_LIGHT);
                                cellPt.setBackgroundColor(BG_LIGHT);
                                cellTien.setBackgroundColor(BG_LIGHT);
                        }

                        table.addCell(cellStt);
                        table.addCell(cellId);
                        table.addCell(cellNgay);
                        table.addCell(cellKh);
                        table.addCell(cellNv);
                        table.addCell(cellSp);
                        table.addCell(cellPt);
                        table.addCell(cellTien);
                        
                        totalRevenue = totalRevenue.add(tongTien);
                }

                document.add(table);

                Table totalTable = new Table(1).useAllAvailableWidth().setMarginTop(15);
                Cell totalCell = new Cell().setBorder(Border.NO_BORDER);
                totalCell.add(new Paragraph("TỔNG DOANH THU:  " + VND_FORMAT.format(totalRevenue))
                                .setFont(fontBold).setFontSize(11).setFontColor(PRIMARY_COLOR).setTextAlignment(TextAlignment.RIGHT));
                totalTable.addCell(totalCell);
                document.add(totalTable);

                document.close();
                return baos.toByteArray();
        }

        public byte[] generateInventoryReportPdf(List<Map<String, Object>> data, String filterType) throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4.rotate());

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO TỒN KHO SẢN PHẨM");

                String filterLabel = switch (filterType != null ? filterType : "all") {
                        case "low" -> "Sắp hết hàng (tồn <= 10)";
                        case "out" -> "Đã hết hàng (tồn = 0)";
                        case "slow" -> "Chậm bán (30 ngày không có đơn)";
                        default -> "Tất cả sản phẩm";
                };
                Paragraph subtitle = new Paragraph("Bộ lọc hoạt động: " + filterLabel)
                                .setFont(font).setFontSize(9).setFontColor(SECONDARY_COLOR)
                                .setMarginBottom(15);
                document.add(subtitle);

                float[] columnWidths = { 1, 2, 4, 3, 3, 2, 3, 3 };
                Table table = new Table(UnitValue.createPercentArray(columnWidths)).useAllAvailableWidth();

                String[] headers = { "STT", "Mã SP", "Tên sản phẩm", "Danh mục", "Giá bán", "Tồn kho",
                                "Bán 30 ngày", "Lần bán cuối" };
                for (String h : headers) {
                        Cell cell = new Cell()
                                        .setBackgroundColor(PRIMARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        table.addHeaderCell(cell);
                }

                int stt = 1;
                for (Map<String, Object> row : data) {
                        int stock = row.get("soLuongTon") != null ? Integer.parseInt(row.get("soLuongTon").toString()) : 0;
                        boolean isLowStock = stock <= 10;

                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        
                        Cell cellId = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("maSP") != null ? "#" + row.get("maSP").toString() : "")
                                                        .setFont(fontBold).setFontSize(8f).setFontColor(SECONDARY_COLOR));
                        
                        Cell cellTen = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("tenSP") != null ? row.get("tenSP").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellLoai = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("tenLoai") != null ? row.get("tenLoai").toString() : "")
                                                        .setFont(font).setFontSize(8f));

                        BigDecimal giaBan = row.get("giaBan") != null ? new BigDecimal(row.get("giaBan").toString()) : BigDecimal.ZERO;
                        Cell cellGia = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(VND_FORMAT.format(giaBan)).setFont(font).setFontSize(8f)
                                                         .setTextAlignment(TextAlignment.RIGHT));

                        // Cảnh báo tồn kho: Tô màu ALERT_BG và ALERT_TEXT nếu tồn kho thấp/hết hàng để nổi bật tình trạng của shop
                        Cell cellTon = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6);
                        Paragraph tonPara = new Paragraph(String.valueOf(stock)).setFont(fontBold).setFontSize(8f).setTextAlignment(TextAlignment.CENTER);
                        if (isLowStock) {
                                cellTon.setBackgroundColor(ALERT_BG);
                                tonPara.setFontColor(ALERT_TEXT);
                        }
                        cellTon.add(tonPara);

                        int ban30Ngay = row.get("ban30Ngay") != null ? Integer.parseInt(row.get("ban30Ngay").toString()) : 0;
                        Cell cellBan = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(ban30Ngay)).setFont(font).setFontSize(8f)
                                                         .setTextAlignment(TextAlignment.CENTER));

                        Object lanBanCuoiObj = row.get("lanBanCuoi");
                        String lanBanCuoiStr = "Chưa bán";
                        if (lanBanCuoiObj instanceof java.sql.Timestamp) {
                            lanBanCuoiStr = ((java.sql.Timestamp) lanBanCuoiObj).toLocalDateTime().format(DATE_ONLY_FORMAT);
                        } else if (lanBanCuoiObj != null) {
                            lanBanCuoiStr = lanBanCuoiObj.toString();
                        }
                        Cell cellCuoi = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(lanBanCuoiStr).setFont(font).setFontSize(8f)
                                                         .setTextAlignment(TextAlignment.CENTER));

                        // Zebra striping for non-alert cells
                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellId.setBackgroundColor(BG_LIGHT);
                                cellTen.setBackgroundColor(BG_LIGHT);
                                cellLoai.setBackgroundColor(BG_LIGHT);
                                cellGia.setBackgroundColor(BG_LIGHT);
                                cellBan.setBackgroundColor(BG_LIGHT);
                                cellCuoi.setBackgroundColor(BG_LIGHT);
                        }

                        table.addCell(cellStt);
                        table.addCell(cellId);
                        table.addCell(cellTen);
                        table.addCell(cellLoai);
                        table.addCell(cellGia);
                        table.addCell(cellTon);
                        table.addCell(cellBan);
                        table.addCell(cellCuoi);
                }

                document.add(table);
                document.close();
                return baos.toByteArray();
        }

        public byte[] generateCustomerReportPdf(List<Map<String, Object>> data, String startDate, String endDate)
                        throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4.rotate());

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO PHÂN TÍCH KHÁCH HÀNG");

                Paragraph subtitle = new Paragraph("Khoảng thời gian khảo sát đơn hàng: từ " + startDate + " đến " + endDate)
                                .setFont(font).setFontSize(9).setFontColor(SECONDARY_COLOR)
                                .setMarginBottom(15);
                document.add(subtitle);

                float[] columnWidths = { 1, 3, 3, 2, 3, 3, 3, 2 };
                Table table = new Table(UnitValue.createPercentArray(columnWidths)).useAllAvailableWidth();

                String[] headers = { "STT", "Mã KH", "Họ tên", "Số điện thoại", "Tổng đơn", "Tổng chi tiêu", "Đơn đầu tiên",
                                "Đơn đã hủy" };
                for (String h : headers) {
                        Cell cell = new Cell()
                                        .setBackgroundColor(PRIMARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        table.addHeaderCell(cell);
                }

                int stt = 1;
                for (Map<String, Object> row : data) {
                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f)
                                                        .setTextAlignment(TextAlignment.CENTER));
                        
                        Cell cellId = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("userId") != null ? "#" + row.get("userId").toString() : "")
                                                        .setFont(fontBold).setFontSize(8f).setFontColor(SECONDARY_COLOR));
                        
                        Cell cellTen = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("fullName") != null ? row.get("fullName").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellSdt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("phone") != null ? row.get("phone").toString() : "")
                                                        .setFont(font).setFontSize(8f));
                        
                        Cell cellDon = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("totalOrders") != null ? row.get("totalOrders").toString() : "0")
                                                        .setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        BigDecimal totalSpent = row.get("totalSpent") != null ? new BigDecimal(row.get("totalSpent").toString()) : BigDecimal.ZERO;
                        Cell cellTieu = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(VND_FORMAT.format(totalSpent)).setFont(fontBold).setFontSize(8f)
                                                        .setTextAlignment(TextAlignment.RIGHT));
                        
                        Cell cellDau = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("firstOrderDate") != null ? row.get("firstOrderDate").toString() : "")
                                                        .setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        
                        Cell cellHuy = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("cancelledOrders") != null ? row.get("cancelledOrders").toString() : "0")
                                                        .setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellId.setBackgroundColor(BG_LIGHT);
                                cellTen.setBackgroundColor(BG_LIGHT);
                                cellSdt.setBackgroundColor(BG_LIGHT);
                                cellDon.setBackgroundColor(BG_LIGHT);
                                cellTieu.setBackgroundColor(BG_LIGHT);
                                cellDau.setBackgroundColor(BG_LIGHT);
                                cellHuy.setBackgroundColor(BG_LIGHT);
                        }

                        table.addCell(cellStt);
                        table.addCell(cellId);
                        table.addCell(cellTen);
                        table.addCell(cellSdt);
                        table.addCell(cellDon);
                        table.addCell(cellTieu);
                        table.addCell(cellDau);
                        table.addCell(cellHuy);
                }

                document.add(table);
                document.close();
                return baos.toByteArray();
        }

        public byte[] generateOrderAnalysisReportPdf(Map<Integer, Integer> hourlyData,
                        List<Map<String, Object>> cancelReasons) throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4);

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO PHÂN TÍCH ĐƠN HÀNG");

                Paragraph section1 = new Paragraph("1. Phân bổ đơn hàng theo giờ trong ngày")
                                .setFont(fontBold).setFontSize(11).setFontColor(PRIMARY_COLOR).setMarginBottom(8);
                document.add(section1);

                Table table1 = new Table(UnitValue.createPercentArray(new float[] { 2, 3, 2 })).useAllAvailableWidth().setMarginBottom(15);
                String[] headers1 = { "Giờ", "Số đơn hàng", "Tỷ lệ (%)" };
                for (String h : headers1) {
                        table1.addHeaderCell(new Cell()
                                        .setBackgroundColor(SECONDARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER)));
                }

                int totalOrders = hourlyData.values().stream().mapToInt(Integer::intValue).sum();
                int idx1 = 0;
                for (int hour = 0; hour < 24; hour++) {
                        int count = hourlyData.getOrDefault(hour, 0);
                        double pct = totalOrders > 0 ? (count * 100.0 / totalOrders) : 0;
                        
                        Cell cellGio = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(hour + ":00").setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellDon = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(count)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellPct = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.format("%.1f%%", pct)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        if (idx1++ % 2 == 0) {
                                cellGio.setBackgroundColor(BG_LIGHT);
                                cellDon.setBackgroundColor(BG_LIGHT);
                                cellPct.setBackgroundColor(BG_LIGHT);
                        }
                        table1.addCell(cellGio);
                        table1.addCell(cellDon);
                        table1.addCell(cellPct);
                }
                document.add(table1);

                Paragraph section2 = new Paragraph("2. Top lý do hủy đơn hàng")
                                .setFont(fontBold).setFontSize(11).setFontColor(PRIMARY_COLOR).setMarginBottom(8).setMarginTop(10);
                document.add(section2);

                Table table2 = new Table(UnitValue.createPercentArray(new float[] { 1, 5, 2, 2 })).useAllAvailableWidth();
                String[] headers2 = { "STT", "Lý do hủy", "Số đơn", "Tỷ lệ (%)" };
                for (String h : headers2) {
                        table2.addHeaderCell(new Cell()
                                        .setBackgroundColor(SECONDARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER)));
                }

                int totalCancel = cancelReasons.stream()
                                .mapToInt(r -> r.get("soLuong") != null ? Integer.parseInt(r.get("soLuong").toString()) : 0)
                                .sum();
                int stt = 1;
                for (Map<String, Object> row : cancelReasons) {
                        int count = row.get("soLuong") != null ? Integer.parseInt(row.get("soLuong").toString()) : 0;
                        double pct = totalCancel > 0 ? (count * 100.0 / totalCancel) : 0;
                        
                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellLyDo = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("lyDo") != null ? row.get("lyDo").toString() : "Không rõ lý do").setFont(font).setFontSize(8f));
                        Cell cellSoDon = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(count)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellPct = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.format("%.1f%%", pct)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellLyDo.setBackgroundColor(BG_LIGHT);
                                cellSoDon.setBackgroundColor(BG_LIGHT);
                                cellPct.setBackgroundColor(BG_LIGHT);
                        }
                        table2.addCell(cellStt);
                        table2.addCell(cellLyDo);
                        table2.addCell(cellSoDon);
                        table2.addCell(cellPct);
                }
                document.add(table2);

                document.close();
                return baos.toByteArray();
        }

        public byte[] generatePromotionReportPdf(List<Map<String, Object>> data, String startDate, String endDate)
                        throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4.rotate());

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO HIỆU QUẢ CHƯƠNG TRÌNH KHUYẾN MÃI");

                Paragraph subtitle = new Paragraph("Thời gian thống kê: từ " + startDate + " đến " + endDate)
                                .setFont(font).setFontSize(9).setFontColor(SECONDARY_COLOR)
                                .setMarginBottom(15);
                document.add(subtitle);

                float[] columnWidths = { 1, 2, 2, 2, 2, 3, 3 };
                Table table = new Table(UnitValue.createPercentArray(columnWidths)).useAllAvailableWidth();

                String[] headers = { "STT", "Mã KM", "Loại KM", "Giá trị giảm", "Min đơn hàng", "Số đơn áp dụng",
                                "Tổng doanh số áp dụng" };
                for (String h : headers) {
                        table.addHeaderCell(new Cell()
                                        .setBackgroundColor(PRIMARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER)));
                }

                int stt = 1;
                for (Map<String, Object> row : data) {
                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellCode = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("promotionCode") != null ? row.get("promotionCode").toString() : "").setFont(fontBold).setFontSize(8f).setFontColor(SECONDARY_COLOR));
                        Cell cellLoai = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("discountType") != null ? row.get("discountType").toString() : "").setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellGiaTri = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("discountValue") != null ? row.get("discountValue").toString() + "%" : "").setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellMin = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("minOrderValue") != null ? VND_FORMAT.format(row.get("minOrderValue")) : "").setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.RIGHT));
                        Cell cellCount = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("usedCount") != null ? row.get("usedCount").toString() : "0").setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        BigDecimal totalOrderValue = row.get("totalOrderValue") != null ? new BigDecimal(row.get("totalOrderValue").toString()) : BigDecimal.ZERO;
                        Cell cellTong = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(VND_FORMAT.format(totalOrderValue)).setFont(fontBold).setFontSize(8f).setTextAlignment(TextAlignment.RIGHT));

                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellCode.setBackgroundColor(BG_LIGHT);
                                cellLoai.setBackgroundColor(BG_LIGHT);
                                cellGiaTri.setBackgroundColor(BG_LIGHT);
                                cellMin.setBackgroundColor(BG_LIGHT);
                                cellCount.setBackgroundColor(BG_LIGHT);
                                cellTong.setBackgroundColor(BG_LIGHT);
                        }

                        table.addCell(cellStt);
                        table.addCell(cellCode);
                        table.addCell(cellLoai);
                        table.addCell(cellGiaTri);
                        table.addCell(cellMin);
                        table.addCell(cellCount);
                        table.addCell(cellTong);
                }

                document.add(table);
                document.close();
                return baos.toByteArray();
        }

        public byte[] generatePaymentReportPdf(List<Map<String, Object>> data) throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4);

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO PHÂN BỔ PHƯƠNG THỨC THANH TOÁN");

                Table table = new Table(UnitValue.createPercentArray(new float[] { 1, 3, 2, 3, 3 })).useAllAvailableWidth();

                String[] headers = { "STT", "Phương thức thanh toán", "Số đơn", "Tổng tiền", "Tỷ lệ (Đơn / Doanh số)" };
                for (String h : headers) {
                        table.addHeaderCell(new Cell()
                                        .setBackgroundColor(PRIMARY_COLOR)
                                        .setBorder(Border.NO_BORDER)
                                        .setPadding(6)
                                        .add(new Paragraph(h).setFont(fontBold).setFontSize(8.5f).setFontColor(ColorConstants.WHITE)
                                                        .setTextAlignment(TextAlignment.CENTER)));
                }

                int totalCount = data.stream()
                                .mapToInt(r -> r.get("soLuong") != null ? Integer.parseInt(r.get("soLuong").toString()) : 0)
                                .sum();
                BigDecimal totalAmount = data.stream()
                                .map(r -> r.get("tongTien") != null ? new BigDecimal(r.get("tongTien").toString()) : BigDecimal.ZERO)
                                .reduce(BigDecimal.ZERO, BigDecimal::add);

                int stt = 1;
                for (Map<String, Object> row : data) {
                        int count = row.get("soLuong") != null ? Integer.parseInt(row.get("soLuong").toString()) : 0;
                        BigDecimal amount = row.get("tongTien") != null ? new BigDecimal(row.get("tongTien").toString()) : BigDecimal.ZERO;
                        double pctCount = totalCount > 0 ? (count * 100.0 / totalCount) : 0;
                        double pctAmount = totalAmount.compareTo(BigDecimal.ZERO) > 0
                                        ? (amount.multiply(new BigDecimal("100")).divide(totalAmount, 2, BigDecimal.ROUND_HALF_UP).doubleValue()) : 0;

                        Cell cellStt = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(stt++)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellTen = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(row.get("tenPTTT") != null ? row.get("tenPTTT").toString() : "").setFont(fontBold).setFontSize(8f).setFontColor(SECONDARY_COLOR));
                        Cell cellSo = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.valueOf(count)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));
                        Cell cellTien = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(VND_FORMAT.format(amount)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.RIGHT));
                        Cell cellPct = new Cell().setBorder(Border.NO_BORDER).setBorderBottom(new SolidBorder(BORDER_COLOR, 0.5f)).setPadding(6)
                                        .add(new Paragraph(String.format("%.1f%% / %.1f%%", pctCount, pctAmount)).setFont(font).setFontSize(8f).setTextAlignment(TextAlignment.CENTER));

                        if ((stt - 1) % 2 == 0) {
                                cellStt.setBackgroundColor(BG_LIGHT);
                                cellTen.setBackgroundColor(BG_LIGHT);
                                cellSo.setBackgroundColor(BG_LIGHT);
                                cellTien.setBackgroundColor(BG_LIGHT);
                                cellPct.setBackgroundColor(BG_LIGHT);
                        }

                        table.addCell(cellStt);
                        table.addCell(cellTen);
                        table.addCell(cellSo);
                        table.addCell(cellTien);
                        table.addCell(cellPct);
                }

                document.add(table);

                Table summaryTable = new Table(1).useAllAvailableWidth().setMarginTop(15);
                Cell sumCell = new Cell().setBorder(Border.NO_BORDER);
                sumCell.add(new Paragraph("TỔNG CỘNG:  " + totalCount + " đơn hàng | " + VND_FORMAT.format(totalAmount))
                                .setFont(fontBold).setFontSize(10).setFontColor(PRIMARY_COLOR).setTextAlignment(TextAlignment.RIGHT));
                summaryTable.addCell(sumCell);
                document.add(summaryTable);

                document.close();
                return baos.toByteArray();
        }

        public byte[] generateOverviewReportPdf(Map<String, Object> kpi, String startDate, String endDate)
                        throws IOException {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf, PageSize.A4);

                PdfFont font = getRegularFont();
                PdfFont fontBold = getBoldFont();

                addStoreHeader(document, font, fontBold, "BÁO CÁO TỔNG QUAN HOẠT ĐỘNG");

                Paragraph subtitle = new Paragraph("Chu kỳ báo cáo: từ " + startDate + " đến " + endDate)
                                .setFont(font).setFontSize(9.5f).setFontColor(SECONDARY_COLOR)
                                .setMarginBottom(20);
                document.add(subtitle);

                // Premium Card Grid Layout (2x2 grid structure using a table with large spacing)
                Table kpiGrid = new Table(UnitValue.createPercentArray(new float[] { 5, 5 })).useAllAvailableWidth();
                kpiGrid.setMarginBottom(20);

                String[][] kpiDefinitions = {
                                { "DOANH THU HỆ THỐNG",
                                                 VND_FORMAT.format(kpi.get("totalRevenue") != null ? new BigDecimal(kpi.get("totalRevenue").toString()) : BigDecimal.ZERO),
                                                 "Tổng giá trị của tất cả các đơn hàng hoàn tất trong chu kỳ." },
                                { "SỐ LƯỢNG ĐƠN HÀNG", 
                                                 kpi.get("totalOrders") != null ? kpi.get("totalOrders").toString() + " đơn" : "0 đơn",
                                                 "Tổng số lượng đơn hàng được tiếp nhận và xử lý." },
                                { "KHÁCH HÀNG MỚI",
                                                 kpi.get("newCustomers") != null ? kpi.get("newCustomers").toString() + " khách hàng" : "0 khách hàng",
                                                 "Số lượng tài khoản khách hàng mới đăng ký trong chu kỳ." },
                                { "TỶ LỆ CHUYỂN ĐỔI",
                                                 kpi.get("conversionRate") != null ? String.format("%.2f%%", kpi.get("conversionRate")) : "0.00%",
                                                 "Tỷ lệ giữa đơn hàng hoàn tất trên lượt tương tác khách hàng." }
                };

                for (int i = 0; i < kpiDefinitions.length; i++) {
                        String[] item = kpiDefinitions[i];
                        
                        // Create a nested table representing a clean visual Card
                        Table cardTable = new Table(1).useAllAvailableWidth();
                        cardTable.setBackgroundColor(BG_LIGHT);
                        cardTable.setBorder(new SolidBorder(BORDER_COLOR, 0.5f));
                        
                        Cell cardCell = new Cell().setBorder(Border.NO_BORDER).setPadding(12);
                        
                        // Card Label
                        cardCell.add(new Paragraph(item[0])
                                         .setFont(fontBold).setFontSize(8.5f).setFontColor(TEXT_MUTED).setMarginBottom(4));
                        
                        // Card Value (large and highlighted)
                        cardCell.add(new Paragraph(item[1])
                                         .setFont(fontBold).setFontSize(16f).setFontColor(PRIMARY_COLOR).setMarginBottom(6));
                        
                        // Card Description
                        cardCell.add(new Paragraph(item[2])
                                         .setFont(font).setFontSize(8f).setFontColor(TEXT_MUTED));
                                        
                        cardTable.addCell(cardCell);
                        
                        // Wrap the Card into the outer Grid Cell
                        Cell gridCell = new Cell().setBorder(Border.NO_BORDER).setPadding(8);
                        gridCell.add(cardTable);
                        
                        kpiGrid.addCell(gridCell);
                }
                document.add(kpiGrid);

                // Add Shop Health Commentary
                Table summaryTable = new Table(1).useAllAvailableWidth().setMarginTop(15);
                Cell commentaryCell = new Cell()
                        .setBackgroundColor(BG_LIGHT)
                        .setBorder(new SolidBorder(PRIMARY_COLOR, 1f))
                        .setPadding(12);
                
                commentaryCell.add(new Paragraph("ĐÁNH GIÁ CHUNG VỀ TÌNH TRẠNG KINH DOANH")
                        .setFont(fontBold).setFontSize(9.5f).setFontColor(PRIMARY_COLOR).setMarginBottom(5));
                
                commentaryCell.add(new Paragraph("Hệ thống Computer Store hoạt động ổn định trong chu kỳ báo cáo. Mọi giao dịch tài chính, quản lý tồn kho và thanh toán được tự động hóa chính xác, đảm bảo độ tin cậy và tuân thủ các quy tắc bảo mật hệ thống.")
                        .setFont(font).setFontSize(8.5f).setFontColor(SECONDARY_COLOR));
                        
                summaryTable.addCell(commentaryCell);
                document.add(summaryTable);

                document.close();
                return baos.toByteArray();
        }
}
