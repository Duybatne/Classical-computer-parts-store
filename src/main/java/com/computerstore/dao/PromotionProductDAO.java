package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.utils.DBConnection;

public class PromotionProductDAO {

	public List<Integer> getProductsByPromotion(int maKM) {
		List<Integer> productIds = new ArrayList<>();
		String sql = "SELECT MaSP FROM KHUYEN_MAI_SAN_PHAM WHERE MaKM = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maKM);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					productIds.add(rs.getInt("MaSP"));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi lấy sản phẩm theo khuyến mãi", e);
		}
		return productIds;
	}

	public List<Integer> getPromotionsByProduct(int maSP) {
		List<Integer> promoIds = new ArrayList<>();
		String sql = "SELECT MaKM FROM KHUYEN_MAI_SAN_PHAM WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					promoIds.add(rs.getInt("MaKM"));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi lấy khuyến mãi theo sản phẩm", e);
		}
		return promoIds;
	}

	/**
	 * REPLACE mapping: delete all current rows for maKM and insert new rows from
	 * maSPList.
	 */
	public boolean replaceProductsByPromotion(int maKM, List<Integer> maSPList) {
		String deleteSql = "DELETE FROM KHUYEN_MAI_SAN_PHAM WHERE MaKM = ?";
		String insertSql = "INSERT INTO KHUYEN_MAI_SAN_PHAM (MaKM, MaSP) VALUES (?, ?)";

		try (Connection conn = DBConnection.getConnection()) {
			boolean oldAutoCommit = conn.getAutoCommit();
			conn.setAutoCommit(false);

			try (PreparedStatement del = conn.prepareStatement(deleteSql)) {
				del.setInt(1, maKM);
				del.executeUpdate();
			}

			if (maSPList != null && !maSPList.isEmpty()) {
				try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
					for (Integer maSP : maSPList) {
						if (maSP == null) {
							continue;
						}
						ins.setInt(1, maKM);
						ins.setInt(2, maSP);
						ins.addBatch();
					}
					ins.executeBatch();
				}
			}

			conn.commit();
			conn.setAutoCommit(oldAutoCommit);
			return true;
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật sản phẩm áp dụng cho khuyến mãi mới", e);
		}
	}
}
