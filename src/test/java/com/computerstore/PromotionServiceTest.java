package com.computerstore;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.computerstore.dao.ProductDAO;
import com.computerstore.dao.PromotionDAO;
import com.computerstore.dao.PromotionProductDAO;
import com.computerstore.models.CartItem;
import com.computerstore.models.Product;
import com.computerstore.models.Promotion;
import com.computerstore.services.PromotionService;

/**
 * Unit tests for PromotionService using Mockito.
 */
@ExtendWith(MockitoExtension.class)
class PromotionServiceTest {

    @Mock
    private PromotionDAO promotionDAO;

    @Mock
    private PromotionProductDAO promotionProductDAO;

    @Mock
    private ProductDAO productDAO;

    private PromotionService promotionService;

    @BeforeEach
    void setUp() {
        // Use reflection to inject mocks
        promotionService = new PromotionService();
        setField(promotionService, "promotionDAO", promotionDAO);
        setField(promotionService, "promotionProductDAO", promotionProductDAO);
        setField(promotionService, "productDAO", productDAO);
    }

    private void setField(Object target, String fieldName, Object value) {
        try {
            var field = target.getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(target, value);
        } catch (Exception e) {
            throw new RuntimeException("Failed to set field " + fieldName, e);
        }
    }

    // ── Helper to create a Promotion object ──
    private Promotion createPromotion(int id, String type, BigDecimal value, boolean active,
            int daysFromNowStart, int daysFromNowEnd) {
        Promotion p = new Promotion();
        p.setMaKM(id);
        p.setLoaiGiam(type);
        p.setGiaTriGiam(value);
        p.setTrangThai(active);
        p.setTenKM("Test Promotion " + id);
        p.setMaNV(1);

        long now = System.currentTimeMillis();
        long dayMs = 24 * 60 * 60 * 1000L;
        p.setNgayBatDau(new Date(now + daysFromNowStart * dayMs));
        p.setNgayKetThuc(new Date(now + daysFromNowEnd * dayMs));

        return p;
    }

    private CartItem createCartItem(int maSP, BigDecimal price, int quantity) {
        CartItem item = new CartItem();
        item.setMaSP(maSP);
        item.setGiaBan(price);
        item.setSoLuong(quantity);
        // getThanhTien() is computed: giaBan * soLuong
        return item;
    }

    // ── getActivePromotions ──
    @Test
    void testGetActivePromotionsReturnsList() {
        List<Promotion> mockList = new ArrayList<>();
        mockList.add(createPromotion(1, "PHAN_TRAM", new BigDecimal("10"), true, -1, 1));
        when(promotionDAO.getActivePromotions()).thenReturn(mockList);

        List<Promotion> result = promotionService.getActivePromotions();
        assertNotNull(result);
        assertEquals(1, result.size());
        verify(promotionDAO).getActivePromotions();
    }

    // ── applyVoucherToCart ── Percentage Discount
    @Test
    void testApplyVoucherToCartPercentageDiscount() {
        Promotion promo = createPromotion(1, "PHAN_TRAM", new BigDecimal("10"), true, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);
        when(promotionProductDAO.getProductsByPromotion(1)).thenReturn(Arrays.asList(100, 101));

        List<CartItem> items = Arrays.asList(
                createCartItem(100, new BigDecimal("100000"), 2),
                createCartItem(101, new BigDecimal("50000"), 1),
                createCartItem(200, new BigDecimal("200000"), 1)); // Not eligible

        BigDecimal result = promotionService.applyVoucherToCart(1, items);
        // Eligible: 100000*2 = 200000 + 50000*1 = 50000 => 250000
        // Discount: 250000 * 10% = 25000
        assertEquals(0, new BigDecimal("25000").compareTo(result),
                "Discount should be 25000");
    }

    // ── applyVoucherToCart ── Fixed Amount Discount
    @Test
    void testApplyVoucherToCartFixedDiscount() {
        Promotion promo = createPromotion(1, "SO_TIEN", new BigDecimal("50000"), true, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);
        when(promotionProductDAO.getProductsByPromotion(1)).thenReturn(Arrays.asList(100));

        List<CartItem> items = Arrays.asList(
                createCartItem(100, new BigDecimal("100000"), 1));

        BigDecimal result = promotionService.applyVoucherToCart(1, items);
        assertEquals(0, new BigDecimal("50000").compareTo(result),
                "Fixed discount should be 50000");
    }

    // ── applyVoucherToCart ── Discount capped by eligible subtotal
    @Test
    void testApplyVoucherToCartFixedDiscountCappedByEligible() {
        Promotion promo = createPromotion(1, "SO_TIEN", new BigDecimal("1000000"), true, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);
        when(promotionProductDAO.getProductsByPromotion(1)).thenReturn(Arrays.asList(100));

        List<CartItem> items = Arrays.asList(
                createCartItem(100, new BigDecimal("50000"), 1));

        BigDecimal result = promotionService.applyVoucherToCart(1, items);
        // Discount should be capped at eligible subtotal (50000), not the full 1000000
        assertEquals(0, new BigDecimal("50000").compareTo(result),
                "Discount should be capped at eligible subtotal (50000)");
    }

    // ── applyVoucherToCart ── Inactive Promotion
    @Test
    void testApplyVoucherToCartInactivePromotion() {
        Promotion promo = createPromotion(1, "PHAN_TRAM", new BigDecimal("10"), false, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);

        List<CartItem> items = Arrays.asList(
                createCartItem(100, new BigDecimal("100000"), 1));

        BigDecimal result = promotionService.applyVoucherToCart(1, items);
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
                "Inactive promotion should return zero discount");
    }

    // ── applyVoucherToCart ── Expired Promotion
    @Test
    void testApplyVoucherToCartExpiredPromotion() {
        // Promotion ended 5 days ago
        Promotion promo = createPromotion(1, "PHAN_TRAM", new BigDecimal("10"), true, -10, -5);
        when(promotionDAO.getById(1)).thenReturn(promo);

        List<CartItem> items = Arrays.asList(
                createCartItem(100, new BigDecimal("100000"), 1));

        BigDecimal result = promotionService.applyVoucherToCart(1, items);
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
                "Expired promotion should return zero discount");
    }

    // ── applyVoucherToCart ── Null items
    @Test
    void testApplyVoucherToCartNullItems() {
        Promotion promo = createPromotion(1, "SO_TIEN", new BigDecimal("50000"), true, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);
        when(promotionProductDAO.getProductsByPromotion(1)).thenReturn(Arrays.asList(100));

        BigDecimal result = promotionService.applyVoucherToCart(1, null);
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
                "Null items should return zero discount");
    }

    // ── applyVoucherToCart ── Null Promotion
    @Test
    void testApplyVoucherToCartNullPromotion() {
        when(promotionDAO.getById(999)).thenReturn(null);

        BigDecimal result = promotionService.applyVoucherToCart(999, new ArrayList<>());
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
                "Null promotion should return zero discount");
    }

    // ── getDiscountedPrice ── Single Active Promotion
    @Test
    void testGetDiscountedPriceWithActivePromotion() {
        Product product = new Product();
        product.setMaSP(1);
        product.setGiaBan(new BigDecimal("1000000"));
        when(productDAO.getById(1)).thenReturn(product);
        when(promotionProductDAO.getPromotionsByProduct(1)).thenReturn(Arrays.asList(1));

        Promotion promo = createPromotion(1, "PHAN_TRAM", new BigDecimal("20"), true, -1, 1);
        when(promotionDAO.getById(1)).thenReturn(promo);

        BigDecimal result = promotionService.getDiscountedPrice(1);
        // 1000000 - 20% = 800000
        assertEquals(0, new BigDecimal("800000").compareTo(result),
                "Discounted price should be 800000");
    }

    // ── getDiscountedPrice ── No Promotion
    @Test
    void testGetDiscountedPriceNoPromotion() {
        Product product = new Product();
        product.setMaSP(1);
        product.setGiaBan(new BigDecimal("1000000"));
        when(productDAO.getById(1)).thenReturn(product);
        when(promotionProductDAO.getPromotionsByProduct(1)).thenReturn(new ArrayList<>());

        BigDecimal result = promotionService.getDiscountedPrice(1);
        assertEquals(0, new BigDecimal("1000000").compareTo(result),
                "No promotion should return original price");
    }

    // ── getDiscountedPrice ── Null Product
    @Test
    void testGetDiscountedPriceNullProduct() {
        when(productDAO.getById(999)).thenReturn(null);

        BigDecimal result = promotionService.getDiscountedPrice(999);
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
                "Null product should return zero");
    }

    // ── updateStatus ──
    @Test
    void testUpdateStatusCallsDAO() {
        when(promotionDAO.updateStatus(1, true)).thenReturn(true);

        boolean result = promotionService.updateStatus(1, true);
        assertTrue(result);
        verify(promotionDAO).updateStatus(1, true);
    }

    // ── getAll ──
    @Test
    void testGetAllReturnsList() {
        List<Promotion> mockList = new ArrayList<>();
        mockList.add(createPromotion(1, "PHAN_TRAM", new BigDecimal("10"), true, -1, 1));
        when(promotionDAO.getAll()).thenReturn(mockList);

        List<Promotion> result = promotionService.getAll();
        assertNotNull(result);
        assertEquals(1, result.size());
        verify(promotionDAO).getAll();
    }
}
