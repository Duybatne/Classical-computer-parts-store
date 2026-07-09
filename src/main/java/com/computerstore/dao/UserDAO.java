package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.User;
import com.computerstore.utils.DBConnection;
import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;

public class UserDAO {

	public User getByUsername(String username) {
		String sql = "SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, u.TrangThai, u.NgayDangNhapCuoi, "
				+ "k.MaKH, k.HoTen, k.Email, k.SDT as SoDienThoai, k.DiaChi "
				+ "FROM TAI_KHOAN u "
				+ "LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK "
				+ "WHERE u.TenDangNhap = ? AND u.TrangThai = 1";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return extractUserFromResultSet(rs);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return null;
	}

	public User getByAdminUsername(String username) {
		String sql = "SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, u.TrangThai, u.NgayDangNhapCuoi, "
				+ "NULL as MaKH, q.HoTen, q.Email, NULL as SoDienThoai, NULL as DiaChi "
				+ "FROM TAI_KHOAN u "
				+ "JOIN QUAN_TRI_VIEN q ON u.MaTK = q.MaTK "
				+ "WHERE u.TenDangNhap = ? AND u.TrangThai = 1";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return extractUserFromResultSet(rs);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return null;
	}

	public User getByEmail(String email) {
		String sql = "SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, u.TrangThai, u.NgayDangNhapCuoi, "
				+ "k.MaKH, k.HoTen, k.Email, k.SDT as SoDienThoai, k.DiaChi "
				+ "FROM TAI_KHOAN u "
				+ "LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK "
				+ "WHERE k.Email = ? AND u.TrangThai = 1";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return extractUserFromResultSet(rs);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return null;
	}

	public User getById(int maTK) {
		String sql = "SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, u.TrangThai, u.NgayTao, u.NgayDangNhapCuoi, "
				+ "COALESCE(k.MaKH, 0) as MaKH, "
				+ "COALESCE(k.HoTen, q2.HoTen) as HoTen, "
				+ "COALESCE(k.Email, q2.Email) as Email, "
				+ "k.SDT as SoDienThoai, k.DiaChi "
				+ "FROM TAI_KHOAN u "
				+ "LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK "
				+ "LEFT JOIN QUAN_TRI_VIEN q2 ON u.MaTK = q2.MaTK "
				+ "WHERE u.MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maTK);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return extractUserFromResultSet(rs);
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return null;
	}

	public boolean insertCustomer(User user) {
		String sqlTK = "INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro) VALUES (?, ?, 'KHACH_HANG')";
		String sqlKH = "INSERT INTO KHACH_HANG (MaTK, HoTen, Email, SDT, DiaChi) VALUES (?, ?, ?, ?, ?)";
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			int generatedId = 0;
			try (PreparedStatement ps1 = conn.prepareStatement(sqlTK, Statement.RETURN_GENERATED_KEYS)) {
				ps1.setString(1, user.getTenDangNhap());
				ps1.setString(2, user.getMatKhauHash());
				ps1.executeUpdate();
				try (ResultSet rs = ps1.getGeneratedKeys()) {
					if (rs.next()) {
						generatedId = rs.getInt(1);
						user.setMaTK(generatedId);
					} else
						throw new SQLException("Creating user failed, no ID.");
				}
			}
			try (PreparedStatement ps2 = conn.prepareStatement(sqlKH, Statement.RETURN_GENERATED_KEYS)) {
				ps2.setInt(1, generatedId);
				ps2.setString(2, user.getHoTen());
				ps2.setString(3, user.getEmail());
				ps2.setString(4, user.getSoDienThoai());
				ps2.setString(5, user.getDiaChi());
				ps2.executeUpdate();
				try (ResultSet rs = ps2.getGeneratedKeys()) {
					if (rs.next())
						user.setMaKH(rs.getInt(1));
				}
			}
			conn.commit();
			return true;
		} catch (SQLException e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					throw new AppException(ErrorCode.DATABASE_ERROR, "Loi rollback", ex);
				}
			}
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi tao khach hang", e);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					throw new DatabaseException("Loi thao tac CSDL", e);
				}
			}
		}
	}

	public boolean insertAdmin(User user) {
		String sqlTK = "INSERT INTO TAI_KHOAN (TenDangNhap, MatKhau, VaiTro) VALUES (?, ?, 'QUAN_TRI_VIEN')";
		String sqlNV = "INSERT INTO QUAN_TRI_VIEN (MaTK, HoTen, Email) VALUES (?, ?, ?)";
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			int generatedId = 0;
			try (PreparedStatement ps1 = conn.prepareStatement(sqlTK, Statement.RETURN_GENERATED_KEYS)) {
				ps1.setString(1, user.getTenDangNhap());
				ps1.setString(2, user.getMatKhauHash());
				ps1.executeUpdate();
				try (ResultSet rs = ps1.getGeneratedKeys()) {
					if (rs.next())
						generatedId = rs.getInt(1);
					else
						throw new SQLException("Creating admin failed, no ID.");
				}
			}
			try (PreparedStatement ps2 = conn.prepareStatement(sqlNV)) {
				ps2.setInt(1, generatedId);
				ps2.setString(2, user.getHoTen());
				ps2.setString(3, user.getEmail());
				ps2.executeUpdate();
			}
			conn.commit();
			return true;
		} catch (SQLException e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					throw new AppException(ErrorCode.DATABASE_ERROR, "Loi rollback", ex);
				}
			}
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi tao quan tri vien", e);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					throw new DatabaseException("Loi thao tac CSDL", e);
				}
			}
		}
	}

	/**
	 * Xoa mem: dat TrangThai = 0 (khoa tai khoan)
	 */
	public boolean softDelete(int maTK) {
		String sql = "UPDATE TAI_KHOAN SET TrangThai = 0 WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maTK);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi xoa tai khoan", e);
		}
	}

	/**
	 * Xoa that khoi CSDL
	 */
	public boolean hardDelete(int maTK) {
		String sql = "DELETE FROM TAI_KHOAN WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maTK);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi xoa tai khoan", e);
		}
	}

	/**
	 * Nang cap tu KHACH_HANG len QUAN_TRI_VIEN
	 * Chi thuc hien neu tai khoan ton tai va dang la KHACH_HANG
	 */
	public boolean upgradeToAdmin(int maTK, String fullname, String email) {
		// Kiem tra tai khoan ton tai va la KHACH_HANG
		User user = getById(maTK);
		if (user == null || !"KHACH_HANG".equals(user.getVaiTro())) {
			return false;
		}

		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			// 1. Xoa khoi KHACH_HANG
			String delKH = "DELETE FROM KHACH_HANG WHERE MaTK = ?";
			try (PreparedStatement ps = conn.prepareStatement(delKH)) {
				ps.setInt(1, maTK);
				ps.executeUpdate();
			}
			// 2. Them vao QUAN_TRI_VIEN
			String insNV = "INSERT INTO QUAN_TRI_VIEN (MaTK, HoTen, Email) VALUES (?, ?, ?)";
			try (PreparedStatement ps = conn.prepareStatement(insNV)) {
				ps.setInt(1, maTK);
				ps.setString(2, fullname);
				ps.setString(3, email);
				ps.executeUpdate();
			}
			// 3. Cap nhat vai tro
			String updRole = "UPDATE TAI_KHOAN SET VaiTro = 'QUAN_TRI_VIEN' WHERE MaTK = ?";
			try (PreparedStatement ps = conn.prepareStatement(updRole)) {
				ps.setInt(1, maTK);
				ps.executeUpdate();
			}
			conn.commit();
			return true;
		} catch (SQLException e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					throw new AppException(ErrorCode.DATABASE_ERROR, "Loi rollback khi nang cap", ex);
				}
			}
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi nang cap tai khoan", e);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					throw new DatabaseException("Loi thao tac CSDL", e);
				}
			}
		}
	}

	public void updateLastLogin(int maTK) {
		String sql = "UPDATE TAI_KHOAN SET NgayDangNhapCuoi = CURRENT_TIMESTAMP WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maTK);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Loi cap nhat lan dang nhap cuoi", e);
		}
	}

	public boolean updateCustomerProfile(User user) {
		String sql = "UPDATE KHACH_HANG SET HoTen = ?, Email = ?, SDT = ?, DiaChi = ? WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, user.getHoTen());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getSoDienThoai());
			ps.setString(4, user.getDiaChi());
			ps.setInt(5, user.getMaTK());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi cap nhat thong tin khach hang", e);
		}
	}

	public boolean updatePassword(int maTK, String hashedPassword) {
		String sql = "UPDATE TAI_KHOAN SET MatKhau = ? WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, hashedPassword);
			ps.setInt(2, maTK);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi cap nhat mat khau", e);
		}
	}

	public List<User> getAllAccounts(String q, String role) {
		List<User> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT u.MaTK, u.TenDangNhap, u.MatKhau, u.VaiTro, u.TrangThai, u.NgayTao, u.NgayDangNhapCuoi, "
						+ "COALESCE(k.MaKH, 0) as MaKH, "
						+ "COALESCE(k.HoTen, q2.HoTen) as HoTen, "
						+ "COALESCE(k.Email, q2.Email) as Email, "
						+ "k.SDT as SoDienThoai, k.DiaChi "
						+ "FROM TAI_KHOAN u "
						+ "LEFT JOIN KHACH_HANG k ON u.MaTK = k.MaTK "
						+ "LEFT JOIN QUAN_TRI_VIEN q2 ON u.MaTK = q2.MaTK WHERE 1=1 ");
		if (q != null && !q.isBlank()) {
			sql.append("AND (COALESCE(k.HoTen, q2.HoTen) LIKE ? OR COALESCE(k.Email, q2.Email) LIKE ?) ");
		}
		if ("customer".equals(role)) {
			sql.append("AND u.VaiTro = 'KHACH_HANG' ");
		} else if ("admin".equals(role)) {
			sql.append("AND u.VaiTro = 'QUAN_TRI_VIEN' ");
		}
		sql.append("ORDER BY u.NgayTao DESC");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			int idx = 1;
			if (q != null && !q.isBlank()) {
				String like = "%" + q + "%";
				ps.setString(idx++, like);
				ps.setString(idx++, like);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(extractUserFromResultSet(rs));
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return list;
	}

	public boolean isAccountDisabled(String username) {
		String sql = "SELECT TrangThai FROM TAI_KHOAN WHERE TenDangNhap = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt("TrangThai") == 0;
			}
		} catch (SQLException e) {
			throw new DatabaseException("Loi thao tac CSDL", e);
		}
		return false;
	}

	public boolean updateAccountStatus(int maTK, int status) {
		String sql = "UPDATE TAI_KHOAN SET TrangThai = ? WHERE MaTK = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, status);
			ps.setInt(2, maTK);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Loi cap nhat trang thai tai khoan", e);
		}
	}

	private User extractUserFromResultSet(ResultSet rs) throws SQLException {
		User user = new User();
		user.setMaTK(rs.getInt("MaTK"));
		user.setTenDangNhap(rs.getString("TenDangNhap"));
		user.setMatKhauHash(rs.getString("MatKhau"));
		user.setVaiTro(rs.getString("VaiTro"));
		user.setHoTen(rs.getString("HoTen"));
		user.setEmail(rs.getString("Email"));
		user.setSoDienThoai(rs.getString("SoDienThoai"));
		user.setDiaChi(rs.getString("DiaChi"));
		user.setTrangThai(rs.getInt("TrangThai"));
		user.setNgayDangNhapCuoi(rs.getTimestamp("NgayDangNhapCuoi"));
		try {
			user.setMaKH(rs.getInt("MaKH"));
		} catch (SQLException ignored) {
		}
		return user;
	}
}
