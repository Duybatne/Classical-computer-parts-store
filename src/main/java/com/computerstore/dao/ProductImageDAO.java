package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.ProductImage;
import com.computerstore.utils.DBConnection;

public class ProductImageDAO {

	public List<ProductImage> getByProductId(int maSP) {
		List<ProductImage> list = new ArrayList<>();
		String sql = "SELECT * FROM ANH_SAN_PHAM WHERE MaSP = ? ORDER BY LaAnhDaiDien DESC, MaAnh ASC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(new ProductImage(rs.getInt("MaAnh"), rs.getInt("MaSP"), rs.getString("DuongDanAnh"),
							rs.getBoolean("LaAnhDaiDien")));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}

	public boolean insert(ProductImage img) {
		String sql = "INSERT INTO ANH_SAN_PHAM (MaSP, DuongDanAnh, LaAnhDaiDien) VALUES (?, ?, ?)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, img.getMaSP());
			ps.setString(2, img.getDuongDanAnh());
			ps.setBoolean(3, img.isLaAnhDaiDien());

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
