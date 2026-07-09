-- =============================================
-- Migration: v3-add-indexes.sql
-- Description: Add missing indexes for performance optimization
-- Date: 2026-05-09
-- =============================================

USE ComputerSpace;

-- =============================================
-- Indexes for DON_HANG table
-- =============================================

-- Index for order date queries (for reporting and admin views)
CREATE INDEX IDX_DON_HANG_NgayDat ON DON_HANG(NgayDat);

-- Index for order status queries (for order management)
CREATE INDEX IDX_DON_HANG_TrangThai ON DON_HANG(TrangThaiDonHang);

-- Index for promotion-related queries
CREATE INDEX IDX_DON_HANG_MaKM ON DON_HANG(MaKM);

-- Composite index for customer order history
CREATE INDEX IDX_DON_HANG_KH_TrangThai ON DON_HANG(MaKH, TrangThaiDonHang);

-- =============================================
-- Indexes for CHI_TIET_DON_HANG table
-- =============================================

-- Index for order detail queries by product
CREATE INDEX IDX_CTDH_ThanhTien ON CHI_TIET_DON_HANG(ThanhTien);

-- =============================================
-- Indexes for SAN_PHAM table
-- =============================================

-- Index for price range queries
CREATE INDEX IDX_SAN_PHAM_GiaBan ON SAN_PHAM(GiaBan);

-- Composite index for active products sorted by date
CREATE INDEX IDX_SAN_PHAM_TrangThai_NgayTao ON SAN_PHAM(TrangThai, NgayTao);

-- Composite index for category filtering with status
CREATE INDEX IDX_SAN_PHAM_Loai_TrangThai ON SAN_PHAM(MaLoaiSP, TrangThai);

-- Full-text index for product search (if not already created)
-- Note: MySQL 5.6+ supports full-text indexes on InnoDB tables
-- CREATE FULLTEXT INDEX IDX_SAN_PHAM_TenSP ON SAN_PHAM(TenSP);

-- =============================================
-- Indexes for DANH_GIA table
-- =============================================

-- Index for approval status queries
CREATE INDEX IDX_DANH_GIA_TrangThaiDuyet ON DANH_GIA(TrangThaiDuyet);

-- Index for product rating queries
CREATE INDEX IDX_DANH_GIA_Sao ON DANH_GIA(SoSao);

-- =============================================
-- Indexes for KHUYEN_MAI table
-- =============================================

-- Index for active promotion queries
CREATE INDEX IDX_KHUYEN_MAI_TrangThai ON KHUYEN_MAI(TrangThai);

-- Composite index for date range queries
CREATE INDEX IDX_KHUYEN_MAI_Ngay ON KHUYEN_MAI(NgayBatDau, NgayKetThuc);

-- =============================================
-- Indexes for GIO_HANG table
-- =============================================

-- Index for cart update queries
CREATE INDEX IDX_GIO_HANG_NgayCapNhat ON GIO_HANG(NgayCapNhat);

-- =============================================
-- Indexes for THANH_TOAN table
-- =============================================

-- Index for payment status queries
CREATE INDEX IDX_THANH_TOAN_TrangThai ON THANH_TOAN(TrangThaiThanhToan);

-- Index for payment date queries
CREATE INDEX IDX_THANH_TOAN_ThoiGian ON THANH_TOAN(ThoiGianThanhToan);

-- =============================================
-- Update statistics for query optimizer
-- =============================================

ANALYZE TABLE SAN_PHAM;
ANALYZE TABLE DON_HANG;
ANALYZE TABLE CHI_TIET_DON_HANG;
ANALYZE TABLE DANH_GIA;
ANALYZE TABLE KHUYEN_MAI;
ANALYZE TABLE GIO_HANG;
ANALYZE TABLE THANH_TOAN;

-- =============================================
-- Verification query
-- =============================================

-- Show all indexes for key tables
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE,
    INDEX_TYPE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'ComputerSpace'
AND TABLE_NAME IN ('SAN_PHAM', 'DON_HANG', 'CHI_TIET_DON_HANG', 'DANH_GIA', 'KHUYEN_MAI')
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- =============================================
-- Performance notes
-- =============================================

-- These indexes will improve:
-- 1. Product listing queries (by category, brand, price range)
-- 2. Order management queries (by status, date, customer)
-- 3. Reporting queries (sales by date, product performance)
-- 4. Search queries (full-text search on product names)
-- 5. Review management (pending reviews, product ratings)

-- Trade-offs:
-- - Indexes improve read performance but may slow down writes slightly
-- - Indexes consume additional disk space
-- - Regular maintenance (ANALYZE TABLE) helps optimizer make better decisions

-- Recommended maintenance:
-- - Run ANALYZE TABLE monthly or after large data changes
-- - Monitor slow query log to identify additional optimization opportunities
-- - Consider partitioning large tables (DON_HANG, CHI_TIET_DON_HANG) if they grow significantly
