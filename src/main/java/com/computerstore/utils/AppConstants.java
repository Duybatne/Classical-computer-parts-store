package com.computerstore.utils;

import java.math.BigDecimal;

/**
 * Central constants for the application.
 * All magic numbers and strings should be defined here.
 */
public final class AppConstants {

    private AppConstants() {
        // Prevent instantiation
    }

    // ==================== Pagination ====================
    public static final int DEFAULT_PAGE_SIZE = 12;
    public static final int MAX_PAGE_SIZE = 100;
    public static final int DEFAULT_PAGE = 1;

    // ==================== Products ====================
    public static final int FEATURED_PRODUCTS_LIMIT = 8;
    public static final int BEST_SELLING_LIMIT = 6;

    // ==================== Shipping ====================
    public static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("500000");
    public static final BigDecimal STANDARD_SHIPPING_FEE = new BigDecimal("30000");

    // ==================== Validation ====================
    public static final int MIN_PASSWORD_LENGTH = 8;
    public static final int MIN_USERNAME_LENGTH = 3;
    public static final int MAX_USERNAME_LENGTH = 20;
    public static final int MIN_PRODUCT_ID = 1;
    public static final int MAX_QUANTITY = 999;

    // ==================== Session ====================
    public static final int SESSION_TIMEOUT_SECONDS = 1800; // 30 minutes

    // ==================== Cache ====================
    public static final long PRODUCT_CACHE_TTL_HOURS = 1;
    public static final long CATEGORY_CACHE_TTL_MINUTES = 30;
    public static final long SEARCH_CACHE_TTL_MINUTES = 10;

    // ==================== Error Messages ====================
    public static final String ERROR_REQUIRED_FIELD = "Vui lòng nhập %s";
    public static final String ERROR_INVALID_EMAIL = "Email không đúng định dạng";
    public static final String ERROR_INVALID_PHONE = "Số điện thoại không đúng định dạng (VD: 0912345678 hoặc +84912345678)";
    public static final String ERROR_INVALID_USERNAME = "Tên đăng nhập phải từ %d-%d ký tự (chữ, số, dấu gạch dưới)";
    public static final String ERROR_WEAK_PASSWORD = "Mật khẩu phải có ít nhất %d ký tự, gồm chữ hoa, chữ thường và số";
    public static final String ERROR_LOGIN_FAILED = "Sai tên đăng nhập hoặc mật khẩu!";
    public static final String ERROR_USERNAME_EXISTS = "Tên đăng nhập đã tồn tại!";

    // ==================== URL Patterns ====================
    public static final String URL_HOME = "/home";
    public static final String URL_LOGIN = "/login";
    public static final String URL_REGISTER = "/register";
    public static final String URL_LOGOUT = "/logout";
    public static final String URL_CART = "/cart";
    public static final String URL_CHECKOUT = "/checkout";
    public static final String URL_ORDERS = "/orders";
    public static final String URL_PROFILE = "/profile";
    public static final String URL_ADMIN = "/admin/";
    public static final String URL_BUILDER = "/builder";
}
