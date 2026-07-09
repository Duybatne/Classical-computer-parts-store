package com.computerstore.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.Order;
import com.computerstore.utils.DBConnection;

public class OrderDAO {

	public int insert(Order order, Connection conn) throws SQLException {
		String sql = "INSERT INTO DON_HANG (MaKH, TrangThaiDonHang, TongTien, DiaChiNhan, SDTNhan, GhiChu, MaKM, PhiVanChuyen) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, order.getMaKH());
			ps.setString(2, order.getTrangThaiDonHang());
			ps.setBigDecimal(3, order.getTongTien());
			ps.setString(4, order.getDiaChiNhan());
			ps.setString(5, order.getSdtNhan());
			ps.setString(6, order.getGhiChu());
			if (order.getMaKM() != null) {
				ps.setInt(7, order.getMaKM());
			} else {
				ps.setNull(7, Types.INTEGER);
			}
			if (order.getPhiVanChuyen() != null) {
				ps.setBigDecimal(8, order.getPhiVanChuyen());
			} else {
				ps.setBigDecimal(8, BigDecimal.ZERO);
			}

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		return -1;
	}

	public List<Order> getByCustomerId(int maKH) {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT dh.*, kh.HoTen FROM DON_HANG dh " + "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
				+ "WHERE dh.MaKH = ? ORDER BY dh.NgayDat DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maKH);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(extractOrder(rs));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public List<Order> getAll() {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT dh.*, kh.HoTen FROM DON_HANG dh " + "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
				+ "ORDER BY dh.NgayDat DESC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(extractOrder(rs));
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public boolean hasPurchasedProduct(int maKH, int maSP) {
		String sql = "SELECT 1 FROM DON_HANG dh " + "JOIN CHI_TIET_DON_HANG ct ON dh.MaDonHang = ct.MaDonHang "
				+ "WHERE dh.MaKH = ? AND ct.MaSP = ? AND dh.TrangThaiDonHang IN ('DA_GIAO', 'ĐÃ GIAO')";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maKH);
			ps.setInt(2, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public Order getById(int maDonHang) {
		String sql = "SELECT dh.*, kh.HoTen FROM DON_HANG dh " + "JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH "
				+ "WHERE dh.MaDonHang = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maDonHang);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return extractOrder(rs);
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return null;
	}

	public boolean updateStatus(int maDonHang, String status) {
		try (Connection conn = DBConnection.getConnection()) {
			return updateStatus(maDonHang, status, conn);
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateStatus(int maDonHang, String status, Connection conn) throws SQLException {
		String sql = "UPDATE DON_HANG SET TrangThaiDonHang = ? WHERE MaDonHang = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, maDonHang);
			return ps.executeUpdate() > 0;
		}
	}

	private Order extractOrder(ResultSet rs) throws SQLException {
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
		return o;
	}
}
