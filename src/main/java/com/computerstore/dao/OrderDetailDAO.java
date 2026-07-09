package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.OrderDetail;
import com.computerstore.utils.DBConnection;

public class OrderDetailDAO {

	public void insertBatch(List<OrderDetail> details, Connection conn) throws SQLException {
		String sql = "INSERT INTO CHI_TIET_DON_HANG (MaDonHang, MaSP, SoLuong, DonGia, ThanhTien) VALUES (?, ?, ?, ?, ?)";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			for (OrderDetail od : details) {
				ps.setInt(1, od.getMaDonHang());
				ps.setInt(2, od.getMaSP());
				ps.setInt(3, od.getSoLuong());
				ps.setBigDecimal(4, od.getDonGia());
				ps.setBigDecimal(5, od.getThanhTien());
				ps.addBatch();
			}
			ps.executeBatch();
		}
	}

	public List<OrderDetail> getByOrderId(int maDonHang) {
		List<OrderDetail> list = new ArrayList<>();
		String sql = "SELECT ct.*, sp.TenSP FROM CHI_TIET_DON_HANG ct " + "JOIN SAN_PHAM sp ON ct.MaSP = sp.MaSP "
				+ "WHERE ct.MaDonHang = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, maDonHang);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(new OrderDetail(rs.getInt("MaDonHang"), rs.getInt("MaSP"), rs.getString("TenSP"),
							rs.getInt("SoLuong"), rs.getBigDecimal("DonGia"), rs.getBigDecimal("ThanhTien")));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác CSDL", e);
		}
		return list;
	}
}
