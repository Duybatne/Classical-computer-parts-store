package com.computerstore;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.computerstore.dao.ProductDAO;

class ProductDAOTest {

    private ProductDAO productDAO;

    @BeforeEach
    void setUp() {
        productDAO = new ProductDAO();
    }

    @Test
    void testBuildOrderByDefault() {
        String orderBy = productDAO.buildOrderBy(null, "DESC");
        assertEquals("ORDER BY sp.NgayTao DESC ", orderBy);
    }

    @Test
    void testBuildOrderByNewest() {
        String orderBy = productDAO.buildOrderBy("newest", "DESC");
        assertEquals("ORDER BY sp.NgayTao DESC ", orderBy);
    }

    @Test
    void testBuildOrderByPriceAsc() {
        String orderBy = productDAO.buildOrderBy("price_asc", "ASC");
        assertEquals("ORDER BY sp.GiaBan ASC ", orderBy);
    }

    @Test
    void testBuildOrderByPriceDesc() {
        String orderBy = productDAO.buildOrderBy("price_desc", "DESC");
        assertEquals("ORDER BY sp.GiaBan DESC ", orderBy);
    }

    @Test
    void testBuildOrderByName() {
        String orderBy = productDAO.buildOrderBy("name", "ASC");
        assertEquals("ORDER BY sp.TenSP ASC ", orderBy);
    }

    @Test
    void testBuildOrderByNameDesc() {
        String orderBy = productDAO.buildOrderBy("name_desc", "DESC");
        assertEquals("ORDER BY sp.TenSP DESC ", orderBy);
    }

    @Test
    void testBuildOrderByStockAsc() {
        String orderBy = productDAO.buildOrderBy("stock_asc", "ASC");
        assertEquals("ORDER BY sp.SoLuongTon ASC ", orderBy);
    }

    @Test
    void testBuildOrderByStockDesc() {
        String orderBy = productDAO.buildOrderBy("stock_desc", "DESC");
        assertEquals("ORDER BY sp.SoLuongTon DESC ", orderBy);
    }

    @Test
    void testBuildOrderByInvalidSortDir() {
        String orderBy = productDAO.buildOrderBy("price_asc", "INVALID_DIR");
        assertEquals("ORDER BY sp.GiaBan ASC ", orderBy);
    }
}
