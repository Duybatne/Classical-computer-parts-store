package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.dto.PcComponentDTO;
import com.computerstore.utils.DBConnection;

public class PcBuilderDAO {

	private PcComponentDTO mapRowToDTO(ResultSet rs) throws SQLException {
		PcComponentDTO dto = new PcComponentDTO();
		dto.setMaSP(rs.getInt("MaSP"));
		dto.setTenSP(rs.getString("TenSP"));
		dto.setGiaBan(rs.getDouble("GiaBan"));
		dto.setSoLuongTon(rs.getInt("SoLuongTon"));

		// Fetch main image (we can use subquery or join, but let's assume it's fetched
		// via JOIN here)
		dto.setAnhChinh(rs.getString("AnhChinh"));

		// Try getting socket and ramType if they exist in the ResultSet
		try {
			dto.setSocket(rs.getString("Socket"));
		} catch (SQLException e) {
			// Ignore if column not exists
		}
		try {
			dto.setRamType(rs.getString("LoaiRam"));
		} catch (SQLException e) {
			// Ignore if column not exists
		}
		return dto;
	}

	public List<PcComponentDTO> getCPUs(String socket) {
		List<PcComponentDTO> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT sp.MaSP, sp.TenSP, sp.GiaBan, sp.SoLuongTon, c.Socket, "
				+ "(SELECT DuongDanAnh FROM ANH_SAN_PHAM a WHERE a.MaSP = sp.MaSP AND a.LaAnhDaiDien = 1 LIMIT 1) AS AnhChinh "
				+ "FROM SAN_PHAM sp " + "JOIN CHI_TIET_CPU c ON sp.MaSP = c.MaSP "
				+ "WHERE sp.TrangThai = 1 AND sp.SoLuongTon > 0");

		if (socket != null && !socket.trim().isEmpty()) {
			sql.append(" AND c.Socket = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			if (socket != null && !socket.trim().isEmpty()) {
				ps.setString(1, socket);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRowToDTO(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<PcComponentDTO> getMainboards(String socket, String ramType) {
		List<PcComponentDTO> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT sp.MaSP, sp.TenSP, sp.GiaBan, sp.SoLuongTon, c.Socket, c.LoaiRam, "
						+ "(SELECT DuongDanAnh FROM ANH_SAN_PHAM a WHERE a.MaSP = sp.MaSP AND a.LaAnhDaiDien = 1 LIMIT 1) AS AnhChinh "
						+ "FROM SAN_PHAM sp " + "JOIN CHI_TIET_MAIN c ON sp.MaSP = c.MaSP "
						+ "WHERE sp.TrangThai = 1 AND sp.SoLuongTon > 0");

		int paramIndex = 1;
		if (socket != null && !socket.trim().isEmpty()) {
			sql.append(" AND c.Socket = ?");
		}
		if (ramType != null && !ramType.trim().isEmpty()) {
			sql.append(" AND c.LoaiRam = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			if (socket != null && !socket.trim().isEmpty()) {
				ps.setString(paramIndex++, socket);
			}
			if (ramType != null && !ramType.trim().isEmpty()) {
				ps.setString(paramIndex++, ramType);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRowToDTO(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<PcComponentDTO> getRAMs(String ramType) {
		List<PcComponentDTO> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT sp.MaSP, sp.TenSP, sp.GiaBan, sp.SoLuongTon, c.LoaiRam, "
				+ "(SELECT DuongDanAnh FROM ANH_SAN_PHAM a WHERE a.MaSP = sp.MaSP AND a.LaAnhDaiDien = 1 LIMIT 1) AS AnhChinh "
				+ "FROM SAN_PHAM sp " + "JOIN CHI_TIET_RAM c ON sp.MaSP = c.MaSP "
				+ "WHERE sp.TrangThai = 1 AND sp.SoLuongTon > 0");

		if (ramType != null && !ramType.trim().isEmpty()) {
			sql.append(" AND c.LoaiRam = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			if (ramType != null && !ramType.trim().isEmpty()) {
				ps.setString(1, ramType);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRowToDTO(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<PcComponentDTO> getComponentsByCategory(int categoryId) {
		List<PcComponentDTO> list = new ArrayList<>();
		String sql = "SELECT sp.MaSP, sp.TenSP, sp.GiaBan, sp.SoLuongTon, "
				+ "(SELECT DuongDanAnh FROM ANH_SAN_PHAM a WHERE a.MaSP = sp.MaSP AND a.LaAnhDaiDien = 1 LIMIT 1) AS AnhChinh "
				+ "FROM SAN_PHAM sp " + "WHERE sp.TrangThai = 1 AND sp.SoLuongTon > 0 AND sp.MaLoaiSP = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, categoryId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRowToDTO(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
}
