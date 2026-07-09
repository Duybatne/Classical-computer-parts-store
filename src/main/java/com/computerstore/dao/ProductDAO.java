package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;
import com.computerstore.models.Product;
import com.computerstore.utils.DBConnection;

/**
 * Data Access Object for SAN_PHAM table.
 * All queries JOIN with LOAI_SAN_PHAM to avoid N+1 problem.
 */
public class ProductDAO {

	// Shared SQL fragments to avoid duplication
	private static final String BASE_SELECT = "SELECT sp.*, lsp.TenLoaiSP, anh.DuongDanAnh AS AnhChinh ";

	private static final String BASE_FROM_JOIN = "FROM SAN_PHAM sp " +
			"JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP " +
			"LEFT JOIN ANH_SAN_PHAM anh ON sp.MaSP = anh.MaSP AND anh.LaAnhDaiDien = 1 ";

	private static final String BASE_WHERE_ACTIVE = "WHERE sp.TrangThai = 1 ";

	private static final String BASE_ORDER_DATE = "ORDER BY sp.NgayTao DESC ";

	// ==================== Stock Management ====================

	public boolean updateStock(int maSP, int quantityChange, Connection conn) throws SQLException {
		String sql = "UPDATE SAN_PHAM SET SoLuongTon = SoLuongTon + ? WHERE MaSP = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, quantityChange);
			ps.setInt(2, maSP);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean hasSufficientStock(int maSP, int quantity, Connection conn) throws SQLException {
		String sql = "SELECT SoLuongTon FROM SAN_PHAM WHERE MaSP = ? FOR UPDATE";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("SoLuongTon") >= quantity;
				}
				return false;
			}
		}
	}

	public int getStock(int maSP, Connection conn) throws SQLException {
		String sql = "SELECT SoLuongTon FROM SAN_PHAM WHERE MaSP = ? FOR UPDATE";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("SoLuongTon");
				}
				return -1;
			}
		}
	}

	public boolean updateStatus(int maSP, boolean status) {
		String sql = "UPDATE SAN_PHAM SET TrangThai = ? WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setBoolean(1, status);
			ps.setInt(2, maSP);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR,
					"Failed to update product status for ID: " + maSP, e);
		}
	}

	// ==================== GET ALL ====================

	public List<Product> getAll(int offset, int limit) {
		return getAll(offset, limit, "newest", "DESC");
	}

	public List<Product> getAll(int offset, int limit, String sortBy, String sortDir) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE + buildOrderBy(sortBy, sortDir)
				+ "LIMIT ? OFFSET ?";
		return executeQuery(sql, ps -> {
			ps.setInt(1, limit);
			ps.setInt(2, offset);
		});
	}

	public List<Product> getAllAdmin() {
		String sql = BASE_SELECT + BASE_FROM_JOIN + "ORDER BY sp.NgayTao DESC";
		return executeQuery(sql, null);
	}

	// ==================== GET BY ID ====================

	/**
	 * Get product by ID or throw ResourceNotFoundException if not found.
	 */
	public Product getById(int maSP) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + "WHERE sp.MaSP = ?";
		List<Product> result = executeQuery(sql, ps -> {
			ps.setInt(1, maSP);
		});

		if (result.isEmpty()) {
			throw new AppException(ErrorCode.RESOURCE_NOT_FOUND,
					"Không tìm thấy sản phẩm với mã: " + maSP);
		}
		return result.get(0);
	}

	/**
	 * Get product by ID, returns null if not found (legacy support).
	 */
	public Product getByIdOrNull(int maSP) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + "WHERE sp.MaSP = ?";
		List<Product> result = executeQuery(sql, ps -> {
			ps.setInt(1, maSP);
		});
		return result.isEmpty() ? null : result.get(0);
	}

	// ==================== COUNT METHODS ====================

	public int countAll() {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM WHERE TrangThai = 1";
		return executeCountQuery(sql, null);
	}

	public int countByCategoryName(String categoryName) {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM sp " +
				"JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP " +
				"WHERE sp.TrangThai = 1 AND lsp.TenLoaiSP = ?";
		return executeCountQuery(sql, ps -> {
			ps.setString(1, categoryName);
		});
	}

	public int countSearch(String keyword) {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM " +
				"WHERE TrangThai = 1 AND (TenSP LIKE ? OR ThuongHieu LIKE ?)";
		return executeCountQuery(sql, ps -> {
			String kw = "%" + keyword + "%";
			ps.setString(1, kw);
			ps.setString(2, kw);
		});
	}

	// ==================== GET BY CATEGORY ====================

	public List<Product> getByCategory(int categoryId, int offset, int limit) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE +
				"AND sp.MaLoaiSP = ? " + BASE_ORDER_DATE + "LIMIT ? OFFSET ?";
		return executeQuery(sql, ps -> {
			ps.setInt(1, categoryId);
			ps.setInt(2, limit);
			ps.setInt(3, offset);
		});
	}

	public List<Product> getByCategoryName(String categoryName, int offset, int limit) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE +
				"AND lsp.TenLoaiSP = ? " + BASE_ORDER_DATE + "LIMIT ? OFFSET ?";
		return executeQuery(sql, ps -> {
			ps.setString(1, categoryName);
			ps.setInt(2, limit);
			ps.setInt(3, offset);
		});
	}

	// ==================== FEATURED PRODUCTS ====================

	public List<Product> getFeaturedProducts(int limit) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE +
				BASE_ORDER_DATE + "LIMIT ?";
		return executeQuery(sql, ps -> {
			ps.setInt(1, limit);
		});
	}

	// ==================== BEST SELLING ====================

	public List<Product> getBestSellingByCategory(String categoryName, int limit) {
		String sql = "SELECT sp.*, lsp.TenLoaiSP, anh.DuongDanAnh AS AnhChinh, " +
				"       COALESCE(SUM(ctdh.SoLuong), 0) AS TongBan " +
				"FROM SAN_PHAM sp " +
				"JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP " +
				"LEFT JOIN ANH_SAN_PHAM anh ON sp.MaSP = anh.MaSP AND anh.LaAnhDaiDien = 1 " +
				"LEFT JOIN CHI_TIET_DON_HANG ctdh ON sp.MaSP = ctdh.MaSP " +
				"LEFT JOIN DON_HANG dh ON ctdh.MaDonHang = dh.MaDonHang AND dh.TrangThaiDonHang != 'DA_HUY' " +
				"WHERE sp.TrangThai = 1 AND lsp.TenLoaiSP = ? " +
				"GROUP BY sp.MaSP, lsp.TenLoaiSP, anh.DuongDanAnh " +
				"ORDER BY TongBan DESC, sp.NgayTao DESC " +
				"LIMIT ?";
		return executeQuery(sql, ps -> {
			ps.setString(1, categoryName);
			ps.setInt(2, limit);
		});
	}

	// ==================== SEARCH ====================

	public List<Product> search(String keyword, int offset, int limit) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE +
				"AND (MATCH(sp.TenSP) AGAINST(?) OR sp.ThuongHieu LIKE ?) " +
				BASE_ORDER_DATE + "LIMIT ? OFFSET ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, keyword);
			ps.setString(2, "%" + keyword + "%");
			ps.setInt(3, limit);
			ps.setInt(4, offset);
			try (ResultSet rs = ps.executeQuery()) {
				return mapProducts(rs);
			}
		} catch (SQLException e) {
			// Fallback to LIKE search if FULLTEXT is not available
			return searchLegacy(keyword, offset, limit);
		}
	}

	private List<Product> searchLegacy(String keyword, int offset, int limit) {
		String sql = BASE_SELECT + BASE_FROM_JOIN + BASE_WHERE_ACTIVE +
				"AND (sp.TenSP LIKE ? OR sp.ThuongHieu LIKE ?) " +
				BASE_ORDER_DATE + "LIMIT ? OFFSET ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			String kw = "%" + keyword + "%";
			ps.setString(1, kw);
			ps.setString(2, kw);
			ps.setInt(3, limit);
			ps.setInt(4, offset);
			try (ResultSet rs = ps.executeQuery()) {
				return mapProducts(rs);
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi tìm kiếm sản phẩm", e);
		}
	}

	// ==================== INSERT / UPDATE / DELETE ====================

	public int insert(Product p) {
		String sql = "INSERT INTO SAN_PHAM " +
				"(TenSP, MaLoaiSP, ThuongHieu, GiaBan, SoLuongTon, BaoHanhThang, MoTaNgan, MoTaChiTiet, TrangThai) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
			ps.setString(1, p.getTenSP());
			ps.setInt(2, p.getMaLoaiSP());
			ps.setString(3, p.getThuongHieu());
			ps.setBigDecimal(4, p.getGiaBan());
			ps.setInt(5, p.getSoLuongTon());
			ps.setInt(6, p.getBaoHanhThang());
			ps.setString(7, p.getMoTaNgan());
			ps.setString(8, p.getMoTaChiTiet());
			ps.setBoolean(9, p.isHienThi());
			ps.executeUpdate();

			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					int newId = rs.getInt(1);
					if (p.getAnhChinh() != null && !p.getAnhChinh().isBlank()) {
						insertAnhSanPham(newId, p.getAnhChinh());
					}
					return newId;
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thêm sản phẩm", e);
		}
		return -1;
	}

	public boolean update(Product p) {
		String sql = "UPDATE SAN_PHAM SET TenSP = ?, MaLoaiSP = ?, ThuongHieu = ?, " +
				"GiaBan = ?, SoLuongTon = ?, BaoHanhThang = ?, MoTaNgan = ?, MoTaChiTiet = ?, TrangThai = ? WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, p.getTenSP());
			ps.setInt(2, p.getMaLoaiSP());
			ps.setString(3, p.getThuongHieu());
			ps.setBigDecimal(4, p.getGiaBan());
			ps.setInt(5, p.getSoLuongTon());
			ps.setInt(6, p.getBaoHanhThang());
			ps.setString(7, p.getMoTaNgan());
			ps.setString(8, p.getMoTaChiTiet());
			ps.setBoolean(9, p.isHienThi());
			ps.setInt(10, p.getMaSP());

			boolean ok = ps.executeUpdate() > 0;
			if (ok && p.getAnhChinh() != null && !p.getAnhChinh().isBlank()) {
				updateAnhSanPham(p.getMaSP(), p.getAnhChinh());
			}
			return ok;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi cập nhật sản phẩm", e);
		}
	}

	public boolean delete(int maSP) {
		String sql = "DELETE FROM SAN_PHAM WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi xóa sản phẩm", e);
		}
	}

	// ==================== PRIVATE HELPERS ====================

	@FunctionalInterface
	private interface ParameterSetter {
		void set(PreparedStatement ps) throws SQLException;
	}

	private List<Product> executeQuery(String sql, ParameterSetter setter) {
		List<Product> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			if (setter != null) {
				setter.set(ps);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(extractProduct(rs));
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thao tác CSDL", e);
		}
		return list;
	}

	private int executeCountQuery(String sql, ParameterSetter setter) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			if (setter != null) {
				setter.set(ps);
			}
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thao tác CSDL", e);
		}
		return 0;
	}

	private List<Product> mapProducts(ResultSet rs) throws SQLException {
		List<Product> list = new ArrayList<>();
		while (rs.next()) {
			list.add(extractProduct(rs));
		}
		return list;
	}

	private Product extractProduct(ResultSet rs) throws SQLException {
		Product p = new Product();
		p.setMaSP(rs.getInt("MaSP"));
		p.setTenSP(rs.getString("TenSP"));
		p.setMaLoaiSP(rs.getInt("MaLoaiSP"));
		p.setTenLoaiSP(rs.getString("TenLoaiSP"));
		p.setThuongHieu(rs.getString("ThuongHieu"));
		p.setGiaBan(rs.getBigDecimal("GiaBan"));
		p.setSoLuongTon(rs.getInt("SoLuongTon"));
		p.setBaoHanhThang(rs.getInt("BaoHanhThang"));
		p.setMoTaNgan(rs.getString("MoTaNgan"));
		p.setMoTaChiTiet(rs.getString("MoTaChiTiet"));
		p.setHienThi(rs.getBoolean("TrangThai"));
		p.setNgayTao(rs.getTimestamp("NgayTao"));
		p.setAnhChinh(rs.getString("AnhChinh"));
		return p;
	}

	// ==================== SORTING HELPERS ====================

	/**
	 * Build ORDER BY clause from sort parameters.
	 * Maps user-friendly sort keys to SQL column expressions.
	 */
	public String buildOrderBy(String sortBy, String sortDir) {
		String column;
		switch (sortBy != null ? sortBy : "newest") {
			case "price_asc":
				column = "sp.GiaBan";
				sortDir = "ASC";
				break;
			case "price_desc":
				column = "sp.GiaBan";
				sortDir = "DESC";
				break;
			case "name":
				column = "sp.TenSP";
				sortDir = "ASC";
				break;
			case "name_desc":
				column = "sp.TenSP";
				sortDir = "DESC";
				break;
			case "stock_asc":
				column = "sp.SoLuongTon";
				sortDir = "ASC";
				break;
			case "stock_desc":
				column = "sp.SoLuongTon";
				sortDir = "DESC";
				break;
			default: // "newest"
				column = "sp.NgayTao";
				sortDir = "DESC";
				break;
		}
		// Validate sortDir to prevent SQL injection
		if (!"ASC".equalsIgnoreCase(sortDir) && !"DESC".equalsIgnoreCase(sortDir)) {
			sortDir = "DESC";
		}
		return "ORDER BY " + column + " " + sortDir + " ";
	}

	// ==================== IMAGE HELPERS ====================

	private void insertAnhSanPham(int maSP, String url) {
		String sql = "INSERT INTO ANH_SAN_PHAM (MaSP, DuongDanAnh, LaAnhDaiDien) VALUES (?, ?, 1)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			ps.setString(2, url);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi lưu ảnh sản phẩm", e);
		}
	}

	private void updateAnhSanPham(int maSP, String url) {
		// Check if main image already exists
		String checkSql = "SELECT COUNT(*) FROM ANH_SAN_PHAM WHERE MaSP = ? AND LaAnhDaiDien = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(checkSql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next() && rs.getInt(1) > 0) {
					// Exists → UPDATE
					String updateSql = "UPDATE ANH_SAN_PHAM SET DuongDanAnh = ? WHERE MaSP = ? AND LaAnhDaiDien = 1";
					try (Connection conn2 = DBConnection.getConnection();
							PreparedStatement ps2 = conn2.prepareStatement(updateSql)) {
						ps2.setString(1, url);
						ps2.setInt(2, maSP);
						ps2.executeUpdate();
					}
				} else {
					// Not exists → INSERT
					insertAnhSanPham(maSP, url);
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi cập nhật ảnh sản phẩm", e);
		}
	}
}
