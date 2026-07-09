package com.computerstore.services;

import java.math.BigDecimal;

import com.computerstore.utils.AppConstants;

/**
 * Base service class providing common functionality for all services
 */
public abstract class BaseService {

    // Shipping configuration - using AppConstants
    protected static final BigDecimal SHIPPING_FEE = AppConstants.STANDARD_SHIPPING_FEE;
    protected static final BigDecimal FREE_SHIPPING_THRESHOLD = AppConstants.FREE_SHIPPING_THRESHOLD;

    // Pagination defaults - using AppConstants
    protected static final int DEFAULT_PAGE_SIZE = AppConstants.DEFAULT_PAGE_SIZE;
    protected static final int MAX_PAGE_SIZE = AppConstants.MAX_PAGE_SIZE;

    /**
     * Calculate shipping fee based on order subtotal
     * Free shipping for orders >= 500,000 VND
     */
    public BigDecimal calculateShipping(BigDecimal subtotal) {
        if (subtotal == null) {
            return SHIPPING_FEE;
        }
        return subtotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0
                ? BigDecimal.ZERO
                : SHIPPING_FEE;
    }

    /**
     * Calculate total amount including shipping and discount
     */
    public BigDecimal calculateTotal(BigDecimal subtotal, BigDecimal discount, BigDecimal shipping) {
        if (subtotal == null) {
            return BigDecimal.ZERO;
        }
        if (discount == null) {
            discount = BigDecimal.ZERO;
        }
        if (shipping == null) {
            shipping = calculateShipping(subtotal);
        }

        BigDecimal total = subtotal.add(shipping).subtract(discount);
        return total.max(BigDecimal.ZERO);
    }

    /**
     * Calculate total amount with automatic shipping calculation
     */
    public BigDecimal calculateTotal(BigDecimal subtotal, BigDecimal discount) {
        BigDecimal shipping = calculateShipping(subtotal);
        return calculateTotal(subtotal, discount, shipping);
    }

    /**
     * Calculate page offset for pagination
     */
    public int calculateOffset(int page, int limit) {
        if (page < 1)
            page = 1;
        if (limit < 1)
            limit = DEFAULT_PAGE_SIZE;
        if (limit > MAX_PAGE_SIZE)
            limit = MAX_PAGE_SIZE;
        return (page - 1) * limit;
    }

    /**
     * Calculate total pages
     */
    public int calculateTotalPages(long totalItems, int pageSize) {
        if (pageSize <= 0) {
            pageSize = DEFAULT_PAGE_SIZE;
        }
        return (int) Math.ceil((double) totalItems / pageSize);
    }

    /**
     * Validate page number
     */
    public int validatePage(int page) {
        return Math.max(1, page);
    }

    /**
     * Validate page size
     */
    public int validatePageSize(int size) {
        if (size < 1)
            size = DEFAULT_PAGE_SIZE;
        if (size > MAX_PAGE_SIZE)
            size = MAX_PAGE_SIZE;
        return size;
    }

    /**
     * Sanitize price value
     */
    public BigDecimal sanitizePrice(BigDecimal price) {
        if (price == null || price.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }
        return price.setScale(0, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * Format price for display (Vietnamese Dong)
     */
    public String formatPrice(BigDecimal price) {
        if (price == null) {
            return "0 ₫";
        }
        return price.setScale(0, BigDecimal.ROUND_HALF_UP).toString() + " ₫";
    }
}
