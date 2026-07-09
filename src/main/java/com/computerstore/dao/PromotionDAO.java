package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.Promotion;
import com.computerstore.utils.DBConnection;
import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;

public class PromotionDAO {

	public List<Promotion> getActivePromotions() {
		List<Promotion> list = new ArrayList<>();
		String sql = "SELECT * FROM KHUYEN_MAI WHERE TrangThai = 1 AND NgayBatDau <= NOW() AND NgayKetThuc >= NOW()";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(extractPromotion(rs));
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public List<Promotion> getAll() {
		List<Promotion> list = new ArrayList<>();
		String sql = "SELECT * FROM KHUYEN_MAI ORDER BY NgayBatDau DESC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(extractPromotion(rs));
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public Promotion getById(int maKM) {
		String sql = "SELECT * FROM KHUYEN_MAI WHERE MaKM = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maKM);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return extractPromotion(rs);
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return null;
	}

	private Promotion extractPromotion(ResultSet rs) throws SQLException {
		Promotion p = new Promotion();
		p.setMaKM(rs.getInt("MaKM"));
		p.setTenKM(rs.getString("TenKM"));
		p.setLoaiGiam(rs.getString("LoaiGiam"));
		p.setGiaTriGiam(rs.getBigDecimal("GiaTriGiam"));
		p.setNgayBatDau(rs.getDate("NgayBatDau"));
		p.setNgayKetThuc(rs.getDate("NgayKetThuc"));
		p.setTrangThai(rs.getBoolean("TrangThai"));
		int mnv = rs.getInt("MaNV");
		p.setMaNV(rs.wasNull() ? null : mnv);
		return p;
	}

	public boolean updateStatus(int maKM, boolean status) {
		String sql = "UPDATE KHUYEN_MAI SET TrangThai = ? WHERE MaKM = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setBoolean(1, status);
			ps.setInt(2, maKM);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi cập nhật trạng thái khuyến mãi", e);
		}
	}

	public boolean insert(Promotion p) {
		String sql = "INSERT INTO KHUYEN_MAI (TenKM, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, TrangThai) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, p.getTenKM());
			ps.setString(2, p.getLoaiGiam());
			ps.setBigDecimal(3, p.getGiaTriGiam());
			ps.setDate(4, p.getNgayBatDau());
			ps.setDate(5, p.getNgayKetThuc());
			ps.setBoolean(6, p.isTrangThai());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thêm khuyến mãi", e);
		}
	}

	public boolean deleteByName(String tenKM) {
		String sql = "DELETE FROM KHUYEN_MAI WHERE TenKM = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, tenKM);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi xóa khuyến mãi", e);
		}
	}
}
