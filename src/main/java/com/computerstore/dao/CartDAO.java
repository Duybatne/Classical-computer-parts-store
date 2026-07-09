package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;
import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.CartItem;
import com.computerstore.utils.DBConnection;

public class CartDAO {

	public int getQuantityInCart(int maGH, int maSP) {
		String sql = "SELECT SoLuong FROM CHI_TIET_GIO_HANG WHERE MaGioHang = ? AND MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maGH);
			ps.setInt(2, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("SoLuong");
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi truy vấn số lượng sản phẩm trong giỏ hàng", e);
		}
		return 0;
	}

	public int getCartIdByCustomerId(int maKH) {
		String sql = "SELECT MaGioHang FROM GIO_HANG WHERE MaKH = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maKH);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("MaGioHang");
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return -1;
	}

	public int createCart(int maKH) {
		String sql = "INSERT INTO GIO_HANG (MaKH) VALUES (?)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setInt(1, maKH);
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return -1;
	}

	public List<CartItem> getItems(int maGH) {
		List<CartItem> list = new ArrayList<>();
		String sql = "SELECT ct.MaSP, ct.SoLuong, sp.TenSP, sp.GiaBan, anh.DuongDanAnh as AnhChinh "
				+ "FROM CHI_TIET_GIO_HANG ct " + "JOIN SAN_PHAM sp ON ct.MaSP = sp.MaSP "
				+ "LEFT JOIN ANH_SAN_PHAM anh ON sp.MaSP = anh.MaSP AND anh.LaAnhDaiDien = 1 "
				+ "WHERE ct.MaGioHang = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maGH);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CartItem item = new CartItem(
							rs.getInt("MaSP"),
							rs.getString("TenSP"),
							rs.getBigDecimal("GiaBan"),
							rs.getInt("SoLuong"),
							rs.getString("AnhChinh"));
					// thanhTien được CartItem.getThanhTien() tính từ giaBan * soLuong
					list.add(item);
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public boolean addItem(int maGH, int maSP, int soLuong) {
		String sql = "INSERT INTO CHI_TIET_GIO_HANG (MaGioHang, MaSP, SoLuong) VALUES (?, ?, ?) "
				+ "ON DUPLICATE KEY UPDATE SoLuong = SoLuong + ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maGH);
			ps.setInt(2, maSP);
			ps.setInt(3, soLuong);
			ps.setInt(4, soLuong); // Parameter for ON DUPLICATE KEY UPDATE clause
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi thêm sản phẩm vào giỏ hàng", e);
		}
	}

	public boolean removeItem(int maGH, int maSP) {
		String sql = "DELETE FROM CHI_TIET_GIO_HANG WHERE MaGioHang = ? AND MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maGH);
			ps.setInt(2, maSP);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi xóa sản phẩm khỏi giỏ hàng", e);
		}
	}

	public boolean updateItem(int maGH, int maSP, int soLuong) {
		String sql = "UPDATE CHI_TIET_GIO_HANG SET SoLuong = ? WHERE MaGioHang = ? AND MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, soLuong);
			ps.setInt(2, maGH);
			ps.setInt(3, maSP);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi cập nhật số lượng sản phẩm trong giỏ hàng", e);
		}
	}

	public boolean clearCart(int maGH) {
		String sql = "DELETE FROM CHI_TIET_GIO_HANG WHERE MaGioHang = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maGH);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi xóa giỏ hàng", e);
		}
	}
}
