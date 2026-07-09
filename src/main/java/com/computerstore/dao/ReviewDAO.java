package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.Review;
import com.computerstore.utils.DBConnection;
import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;

public class ReviewDAO {

	public List<Review> getByProductId(int maSP) {
		List<Review> list = new ArrayList<>();
		String sql = "SELECT dg.*, kh.HoTen FROM DANH_GIA dg " + "JOIN KHACH_HANG kh ON dg.MaKH = kh.MaKH "
				+ "WHERE dg.MaSP = ? AND dg.TrangThaiDuyet = 1 ORDER BY dg.NgayDanhGia DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Review r = new Review(rs.getInt("MaDG"), rs.getInt("MaKH"), rs.getInt("MaSP"), rs.getInt("SoSao"),
							rs.getString("NoiDung"), rs.getTimestamp("NgayDanhGia"), rs.getInt("TrangThaiDuyet"));
					r.setTenKhachHang(rs.getString("HoTen"));
					list.add(r);
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public List<Review> getAll() {
		return getAll(null);
	}

	public List<Review> getAll(String status) {
		List<Review> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT dg.*, kh.HoTen FROM DANH_GIA dg " + "JOIN KHACH_HANG kh ON dg.MaKH = kh.MaKH WHERE 1=1 ");
		if ("pending".equals(status)) {
			sql.append("AND dg.TrangThaiDuyet = 0 ");
		} else if ("approved".equals(status)) {
			sql.append("AND dg.TrangThaiDuyet = 1 ");
		} else if ("rejected".equals(status)) {
			sql.append("AND dg.TrangThaiDuyet = 2 ");
		}
		sql.append("ORDER BY dg.NgayDanhGia DESC");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString());
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Review r = new Review(rs.getInt("MaDG"), rs.getInt("MaKH"), rs.getInt("MaSP"), rs.getInt("SoSao"),
						rs.getString("NoiDung"), rs.getTimestamp("NgayDanhGia"), rs.getInt("TrangThaiDuyet"));
				r.setTenKhachHang(rs.getString("HoTen"));
				list.add(r);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public boolean insert(Review review) {
		String sql = "INSERT INTO DANH_GIA (MaKH, MaSP, SoSao, NoiDung) VALUES (?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, review.getMaKH());
			ps.setInt(2, review.getMaSP());
			ps.setInt(3, review.getSoSao());
			ps.setString(4, review.getNoiDung());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thêm đánh giá", e);
		}
	}

	public boolean approve(int maDanhGia) {
		return updateStatus(maDanhGia, 1);
	}

	public boolean reject(int maDanhGia) {
		return updateStatus(maDanhGia, 2);
	}

	public boolean delete(int maDanhGia) {
		String sql = "DELETE FROM DANH_GIA WHERE MaDG = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maDanhGia);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi xóa đánh giá", e);
		}
	}

	public boolean updateStatus(int maDanhGia, int status) {
		String sql = "UPDATE DANH_GIA SET TrangThaiDuyet = ? WHERE MaDG = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, status);
			ps.setInt(2, maDanhGia);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi cập nhật trạng thái đánh giá", e);
		}
	}
}
