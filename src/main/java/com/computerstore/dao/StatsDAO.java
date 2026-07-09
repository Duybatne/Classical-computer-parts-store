package com.computerstore.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.models.Order;
import com.computerstore.utils.DBConnection;
import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;

public class StatsDAO {

	public int getTotalOrders() {
		String sql = "SELECT COUNT(*) FROM DON_HANG";
		return getIntResult(sql);
	}

	public BigDecimal getTotalRevenue() {
		String sql = "SELECT SUM(TongTien) FROM DON_HANG WHERE TrangThaiDonHang = 'DA_GIAO'";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				BigDecimal result = rs.getBigDecimal(1);
				return result != null ? result : BigDecimal.ZERO;
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi truy vấn tổng doanh thu", e);
		}
		return BigDecimal.ZERO;
	}

	public int getTotalCustomers() {
		String sql = "SELECT COUNT(*) FROM KHACH_HANG";
		return getIntResult(sql);
	}

	public int getPendingReviews() {
		String sql = "SELECT COUNT(*) FROM DANH_GIA WHERE TrangThaiDuyet = 0";
		return getIntResult(sql);
	}

	public List<Order> getRecentOrders(int limit) {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT dh.*, kh.HoTen FROM DON_HANG dh "
				+ "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
				+ "ORDER BY dh.NgayDat DESC LIMIT ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, limit);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order();
					o.setMaDonHang(rs.getInt("MaDonHang"));
					o.setMaKH(rs.getInt("MaKH"));
					o.setNgayDat(rs.getTimestamp("NgayDat"));
					o.setTrangThaiDonHang(rs.getString("TrangThaiDonHang"));
					o.setTongTien(rs.getBigDecimal("TongTien"));
					o.setDiaChiNhan(rs.getString("DiaChiNhan"));
					o.setSdtNhan(rs.getString("SDTNhan"));
					o.setGhiChu(rs.getString("GhiChu"));
					int mnv = rs.getInt("MaNV");
					o.setMaNV(rs.wasNull() ? null : mnv);
					int mkm = rs.getInt("MaKM");
					o.setMaKM(rs.wasNull() ? null : mkm);
					o.setPhiVanChuyen(rs.getBigDecimal("PhiVanChuyen"));
					o.setHoTenKhachHang(rs.getString("HoTen"));
					list.add(o);
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi truy vấn đơn hàng gần đây", e);
		}
		return list;
	}

	// ==================== Product Stats ====================

	public int getTotalProducts() {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM";
		return getIntResult(sql);
	}

	public int getActiveProducts() {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM WHERE TrangThai = 1";
		return getIntResult(sql);
	}

	public int getLowStockProducts() {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM WHERE SoLuongTon > 0 AND SoLuongTon <= 5";
		return getIntResult(sql);
	}

	public int getOutOfStockProducts() {
		String sql = "SELECT COUNT(*) FROM SAN_PHAM WHERE SoLuongTon <= 0";
		return getIntResult(sql);
	}

	private int getIntResult(String sql) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi truy vấn thống kê", e);
		}
		return 0;
	}
}
