package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.Category;
import com.computerstore.utils.DBConnection;

public class CategoryDAO {

	public List<Category> getAll() {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT lsp.*, (SELECT COUNT(*) FROM SAN_PHAM sp WHERE sp.MaLoaiSP = lsp.MaLoaiSP AND sp.TrangThai = 1) AS SoLuongSP "
				+ "FROM LOAI_SAN_PHAM lsp ORDER BY lsp.TenLoaiSP";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Category cat = new Category(rs.getInt("MaLoaiSP"), rs.getString("TenLoaiSP"), rs.getString("MoTa"));
				cat.setSoLuongSP(rs.getInt("SoLuongSP"));
				list.add(cat);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public Category getById(int id) {
		String sql = "SELECT lsp.*, (SELECT COUNT(*) FROM SAN_PHAM sp WHERE sp.MaLoaiSP = lsp.MaLoaiSP AND sp.TrangThai = 1) AS SoLuongSP "
				+ "FROM LOAI_SAN_PHAM lsp WHERE lsp.MaLoaiSP = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new Category(rs.getInt("MaLoaiSP"), rs.getString("TenLoaiSP"), rs.getString("MoTa"));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return null;
	}
}
