package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.Payment;
import com.computerstore.models.PaymentMethod;
import com.computerstore.utils.DBConnection;

public class PaymentDAO {

	public void insert(Payment payment, Connection conn) throws SQLException {
		String sql = "INSERT INTO THANH_TOAN (MaDonHang, MaPTTT, SoTien, TrangThaiThanhToan) VALUES (?, ?, ?, ?)";
		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, payment.getMaDonHang());
			ps.setInt(2, payment.getMaPTTT());
			ps.setBigDecimal(3, payment.getSoTien());
			ps.setString(4, payment.getTrangThaiThanhToan());
			ps.executeUpdate();

			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					payment.setMaThanhToan(rs.getInt(1));
				}
			}
		}
	}

	public Payment getByOrderId(int maDonHang) {
		String sql = "SELECT * FROM THANH_TOAN WHERE MaDonHang = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maDonHang);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Payment p = new Payment();
					p.setMaThanhToan(rs.getInt("MaThanhToan"));
					p.setMaDonHang(rs.getInt("MaDonHang"));
					p.setMaPTTT(rs.getInt("MaPTTT"));
					p.setSoTien(rs.getBigDecimal("SoTien"));
					p.setThoiGianThanhToan(rs.getTimestamp("ThoiGianThanhToan"));
					p.setTrangThaiThanhToan(rs.getString("TrangThaiThanhToan"));
					p.setMaGiaoDich(rs.getString("MaGiaoDich"));
					p.setTenNganHang(rs.getString("TenNganHang"));
					return p;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi lấy thông tin thanh toán", e);
		}
		return null;
	}

	public boolean updateStatus(int maThanhToan, String status) {
		String sql = "UPDATE THANH_TOAN SET TrangThaiThanhToan = ? WHERE MaThanhToan = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, maThanhToan);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật trạng thái thanh toán", e);
		}
	}

	public List<PaymentMethod> getAllPaymentMethods() {
		List<PaymentMethod> methods = new ArrayList<>();
		String sql = "SELECT * FROM PHUONG_THUC_THANH_TOAN WHERE TrangThai = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				PaymentMethod pm = new PaymentMethod();
				pm.setMaPTTT(rs.getInt("MaPTTT"));
				pm.setTenPTTT(rs.getString("TenPTTT"));
				pm.setMoTa(rs.getString("MoTa"));
				pm.setTrangThai(rs.getInt("TrangThai"));
				methods.add(pm);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi lấy danh sách PTTT", e);
		}
		return methods;
	}
}
