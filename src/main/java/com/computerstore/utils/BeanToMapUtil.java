package com.computerstore.utils;

import java.lang.reflect.Method;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Utility to convert Java Beans to Map for JSP display.
 * Handles component detail objects (CpuDetail, VgaDetail, etc.)
 */
public final class BeanToMapUtil {

    private BeanToMapUtil() {
        // Prevent instantiation
    }

    /**
     * Convert a Java Bean to a Map of property names (in Vietnamese) to values.
     * Uses reflection to call all getter methods.
     */
    public static Map<String, String> toMap(Object bean) {
        Map<String, String> result = new LinkedHashMap<>();
        if (bean == null)
            return result;

        Method[] methods = bean.getClass().getMethods();
        for (Method method : methods) {
            String name = method.getName();
            // Skip: getClass(), getMaSP(), and non-getter methods
            if (name.equals("getClass") || name.equals("getMaSP"))
                continue;

            if (name.startsWith("get") && method.getParameterCount() == 0) {
                String propertyName = getDisplayName(name, bean.getClass().getSimpleName());
                try {
                    Object value = method.invoke(bean);
                    if (value != null) {
                        result.put(propertyName, value.toString());
                    }
                } catch (Exception e) {
                    // Skip if error
                }
            }

            // Handle boolean "is" prefix
            if (name.startsWith("is") && method.getParameterCount() == 0 &&
                    (method.getReturnType() == boolean.class || method.getReturnType() == Boolean.class)) {
                String propertyName = getDisplayName(name, bean.getClass().getSimpleName());
                try {
                    Object value = method.invoke(bean);
                    if (value != null) {
                        result.put(propertyName, (Boolean) value ? "Có" : "Không");
                    }
                } catch (Exception e) {
                    // Skip if error
                }
            }
        }

        return result;
    }

    /**
     * Map Java getter name to Vietnamese display name
     */
    private static String getDisplayName(String methodName, String className) {
        // Remove "get" or "is" prefix
        String prop;
        if (methodName.startsWith("get")) {
            prop = methodName.substring(3);
        } else if (methodName.startsWith("is")) {
            prop = methodName.substring(2);
        } else {
            return methodName;
        }

        // Check known property names for translation
        switch (prop) {
            // CPU
            case "HangCPU":
                return "Hãng CPU";
            case "DongCPU":
                return "Dòng CPU";
            case "Socket":
                return "Socket";
            case "SoNhan":
                return "Số nhân";
            case "SoLuongLuong":
                return "Số luồng";
            case "XungNhipCoBan":
                return "Xung nhịp cơ bản";
            case "XungNhipTurbo":
                return "Xung nhịp Turbo";
            case "XungNhip":
                return "Xung nhịp";
            case "CacheL1":
                return "Cache L1";
            case "CacheL2":
                return "Cache L2";
            case "Tdp":
                return "TDP (W)";
            case "CoGPU":
                return "Tích hợp GPU";

            // VGA
            case "HangGPU":
                return "Hãng GPU";
            case "DungLuongVRAM":
                return "Dung lượng VRAM";
            case "KieuBoNho":
                return "Kiểu bộ nhớ";
            case "BusBoNho":
                return "Bus bộ nhớ";
            case "CongKetNoi":
                return "Cổng kết nối";
            case "SoQuat":
                return "Số quạt";
            case "KichThuocCard":
                return "Kích thước card";
            case "DauCapNguon":
                return "Đầu cấp nguồn";

            // Mainboard
            case "Chipset":
                return "Chipset";
            case "KichThuocMain":
                return "Kích thước mainboard";
            case "HoTroCPU":
                return "Hỗ trợ CPU";
            case "SoKheRam":
                return "Số khe RAM";
            case "LoaiRam":
                return "Loại RAM";
            case "DungLuongRamToiDa":
                return "Dung lượng RAM tối đa";
            case "KhePCIe":
                return "Khe PCIe";
            case "SoCongSATA":
                return "Số cổng SATA";
            case "SoKheM2":
                return "Số khe M.2";
            case "CongXuatHinh":
                return "Cổng xuất hình";

            // RAM
            case "BusRam":
                return "Bus RAM";
            case "DienAp":
                return "Điện áp";
            case "DungLuong":
                return "Dung lượng";
            case "SoThanh":
                return "Số thanh";

            // Storage
            case "LoaiOCung":
                return "Loại ổ cứng";
            case "ChuanKetNoi":
                return "Chuẩn kết nối";
            case "KichCo":
                return "Kích cỡ";
            case "TocDoDocGhi":
                return "Tốc độ đọc/ghi";

            // Case
            case "HoTroMain":
                return "Hỗ trợ mainboard";
            case "MauSac":
                return "Màu sắc";
            case "ChatLieu":
                return "Chất liệu";
            case "KichThuoc":
                return "Kích thước";
            case "HoTroNguon":
                return "Hỗ trợ nguồn";
            case "SoLuongQuatHoTro":
                return "Số lượng quạt hỗ trợ";
            case "CoKinhCuongLuc":
                return "Kính cường lực";
            case "CongTruocCase":
                return "Cổng trước case";

            // PSU
            case "CongSuat":
                return "Công suất";
            case "Chuan80Plus":
                return "Chuẩn 80 Plus";
            case "KichThuocNguon":
                return "Kích thước nguồn";
            case "DienApVao":
                return "Điện áp vào";

            // Cooler
            case "LoaiTanNhiet":
                return "Loại tản nhiệt";
            case "TuongThichCPU":
                return "Tương thích CPU";
            case "KichThuocRadiator":
                return "Kích thước Radiator";
            case "TocDoQuat":
                return "Tốc độ quạt";
            case "DoOn":
                return "Độ ồn";
            case "Led":
                return "LED";
            case "KichThuocTan":
                return "Kích thước tản";

            default:
                // Split camelCase to readable text
                return prop.replaceAll("([a-z])([A-Z])", "$1 $2");
        }
    }
}
