package com.computerstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.computerstore.exceptions.DatabaseException;
import com.computerstore.models.CaseDetail;
import com.computerstore.models.CoolerDetail;
import com.computerstore.models.CpuDetail;
import com.computerstore.models.MainboardDetail;
import com.computerstore.models.PsuDetail;
import com.computerstore.models.RamDetail;
import com.computerstore.models.StorageDetail;
import com.computerstore.models.VgaDetail;
import com.computerstore.utils.DBConnection;

public class ComponentDetailDAO {

	// =========================================================
	// GET
	// =========================================================

	public MainboardDetail getMainboardDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_MAIN WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					MainboardDetail d = new MainboardDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setChipset(rs.getString("Chipset"));
					d.setSocket(rs.getString("Socket"));
					d.setKichThuocMain(rs.getString("KichThuocMain"));
					d.setHoTroCPU(rs.getString("HoTroCPU"));
					d.setSoKheRam(rs.getInt("SoKheRam"));
					d.setLoaiRam(rs.getString("LoaiRam"));
					d.setDungLuongRamToiDa(rs.getString("DungLuongRamToiDa"));
					d.setKhePCIe(rs.getString("KhePCIe"));
					d.setSoCongSATA(rs.getInt("SoCongSATA"));
					d.setSoKheM2(rs.getInt("SoKheM2"));
					d.setCongXuatHinh(rs.getString("CongXuatHinh"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_MAIN", e);
		}
		return null;
	}

	public CpuDetail getCpuDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_CPU WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					CpuDetail d = new CpuDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setHangCPU(rs.getString("HangCPU"));
					d.setDongCPU(rs.getString("DongCPU"));
					d.setSocket(rs.getString("Socket"));
					d.setSoNhan(rs.getInt("SoNhan"));
					d.setSoLuongLuong(rs.getInt("SoLuongLuong"));
					d.setXungNhipCoBan(rs.getString("XungNhipCoBan"));
					d.setXungNhipTurbo(rs.getString("XungNhipTurbo"));
					d.setCacheL1(rs.getString("CacheL1"));
					d.setCacheL2(rs.getString("CacheL2"));
					d.setTdp(rs.getString("TDP"));
					d.setCoGPU(rs.getBoolean("CoGPU"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_CPU", e);
		}
		return null;
	}

	public VgaDetail getVgaDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_VGA WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					VgaDetail d = new VgaDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setHangGPU(rs.getString("HangGPU"));
					d.setDungLuongVRAM(rs.getString("DungLuongVRAM"));
					d.setKieuBoNho(rs.getString("KieuBoNho"));
					d.setBusBoNho(rs.getString("BusBoNho"));
					d.setXungNhip(rs.getString("XungNhip"));
					d.setTdp(rs.getString("TDP"));
					d.setCongKetNoi(rs.getString("CongKetNoi"));
					d.setSoQuat(rs.getInt("SoQuat"));
					d.setKichThuocCard(rs.getString("KichThuocCard"));
					d.setDauCapNguon(rs.getString("DauCapNguon"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_VGA", e);
		}
		return null;
	}

	public CaseDetail getCaseDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_CASE WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					CaseDetail d = new CaseDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setHoTroMain(rs.getString("HoTroMain"));
					d.setMauSac(rs.getString("MauSac"));
					d.setChatLieu(rs.getString("ChatLieu"));
					d.setKichThuoc(rs.getString("KichThuoc"));
					d.setHoTroNguon(rs.getString("HoTroNguon"));
					d.setSoLuongQuatHoTro(rs.getInt("SoLuongQuatHoTro"));
					d.setCoKinhCuongLuc(rs.getBoolean("CoKinhCuongLuc"));
					d.setCongTruocCase(rs.getString("CongTruocCase"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_CASE", e);
		}
		return null;
	}

	public PsuDetail getPsuDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_NGUON WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					PsuDetail d = new PsuDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setCongSuat(rs.getString("CongSuat"));
					d.setChuan80Plus(rs.getString("Chuan80Plus"));
					d.setCongKetNoi(rs.getString("CongKetNoi"));
					d.setKichThuocNguon(rs.getString("KichThuocNguon"));
					d.setDienApVao(rs.getString("DienApVao"));
					d.setDauCapNguon(rs.getString("DauCapNguon"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_NGUON", e);
		}
		return null;
	}

	public CoolerDetail getCoolerDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_TAN_NHIET WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					CoolerDetail d = new CoolerDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setLoaiTanNhiet(rs.getString("LoaiTanNhiet"));
					d.setTuongThichCPU(rs.getString("TuongThichCPU"));
					d.setKichThuocRadiator(rs.getString("KichThuocRadiator"));
					d.setSoQuat(rs.getInt("SoQuat"));
					d.setTocDoQuat(rs.getString("TocDoQuat"));
					d.setDoOn(rs.getString("DoOn"));
					d.setLed(rs.getString("LED"));
					d.setKichThuocTan(rs.getString("KichThuocTan"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_TAN_NHIET", e);
		}
		return null;
	}

	public StorageDetail getStorageDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_O_CUNG WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					StorageDetail d = new StorageDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setLoaiOCung(rs.getString("LoaiOCung"));
					d.setDungLuong(rs.getString("DungLuong"));
					d.setChuanKetNoi(rs.getString("ChuanKetNoi"));
					d.setKichCo(rs.getString("KichCo"));
					d.setTocDoDocGhi(rs.getString("TocDoDocGhi"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_O_CUNG", e);
		}
		return null;
	}

	public RamDetail getRamDetail(int maSP) {
		String sql = "SELECT * FROM CHI_TIET_RAM WHERE MaSP = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					RamDetail d = new RamDetail();
					d.setMaSP(rs.getInt("MaSP"));
					d.setLoaiRam(rs.getString("LoaiRam"));
					d.setDungLuong(rs.getString("DungLuong"));
					d.setBusRam(rs.getString("BusRam"));
					d.setDienAp(rs.getString("DienAp"));
					d.setSoThanh(rs.getInt("SoThanh"));
					return d;
				}
			}
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi truy vấn CHI_TIET_RAM", e);
		}
		return null;
	}

	// =========================================================
	// DELETE (xóa tất cả detail của 1 SP)
	// =========================================================
	public void deleteByProductId(int maSP) {
		String[] tables = { "CHI_TIET_MAIN", "CHI_TIET_CPU", "CHI_TIET_VGA", "CHI_TIET_CASE",
				"CHI_TIET_NGUON", "CHI_TIET_TAN_NHIET", "CHI_TIET_O_CUNG", "CHI_TIET_RAM" };
		for (String table : tables) {
			String sql = "DELETE FROM " + table + " WHERE MaSP = ?";
			try (Connection conn = DBConnection.getConnection();
					PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setInt(1, maSP);
				ps.executeUpdate();
			} catch (SQLException e) {
				// ignore if table doesn't have this SP
			}
		}
	}

	// =========================================================
	// INSERT
	// =========================================================
	public void insertMainboardDetail(MainboardDetail d) {
		String sql = "INSERT INTO CHI_TIET_MAIN (MaSP, Chipset, Socket, KichThuocMain, HoTroCPU, "
				+ "SoKheRam, LoaiRam, DungLuongRamToiDa, KhePCIe, SoCongSATA, SoKheM2, CongXuatHinh) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getChipset());
			ps.setString(3, d.getSocket());
			ps.setString(4, d.getKichThuocMain());
			ps.setString(5, d.getHoTroCPU());
			ps.setInt(6, d.getSoKheRam());
			ps.setString(7, d.getLoaiRam());
			ps.setString(8, d.getDungLuongRamToiDa());
			ps.setString(9, d.getKhePCIe());
			ps.setInt(10, d.getSoCongSATA());
			ps.setInt(11, d.getSoKheM2());
			ps.setString(12, d.getCongXuatHinh());
		});
	}

	public void insertCpuDetail(CpuDetail d) {
		String sql = "INSERT INTO CHI_TIET_CPU (MaSP, HangCPU, DongCPU, Socket, SoNhan, SoLuongLuong, "
				+ "XungNhipCoBan, XungNhipTurbo, CacheL1, CacheL2, TDP, CoGPU) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getHangCPU());
			ps.setString(3, d.getDongCPU());
			ps.setString(4, d.getSocket());
			ps.setInt(5, d.getSoNhan());
			ps.setInt(6, d.getSoLuongLuong());
			ps.setString(7, d.getXungNhipCoBan());
			ps.setString(8, d.getXungNhipTurbo());
			ps.setString(9, d.getCacheL1());
			ps.setString(10, d.getCacheL2());
			ps.setString(11, d.getTdp());
			ps.setBoolean(12, d.isCoGPU());
		});
	}

	public void insertVgaDetail(VgaDetail d) {
		String sql = "INSERT INTO CHI_TIET_VGA (MaSP, HangGPU, DungLuongVRAM, KieuBoNho, BusBoNho, "
				+ "XungNhip, TDP, CongKetNoi, SoQuat, KichThuocCard, DauCapNguon) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getHangGPU());
			ps.setString(3, d.getDungLuongVRAM());
			ps.setString(4, d.getKieuBoNho());
			ps.setString(5, d.getBusBoNho());
			ps.setString(6, d.getXungNhip());
			ps.setString(7, d.getTdp());
			ps.setString(8, d.getCongKetNoi());
			ps.setInt(9, d.getSoQuat());
			ps.setString(10, d.getKichThuocCard());
			ps.setString(11, d.getDauCapNguon());
		});
	}

	public void insertCaseDetail(CaseDetail d) {
		String sql = "INSERT INTO CHI_TIET_CASE (MaSP, HoTroMain, MauSac, ChatLieu, KichThuoc, "
				+ "HoTroNguon, SoLuongQuatHoTro, CoKinhCuongLuc, CongTruocCase) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getHoTroMain());
			ps.setString(3, d.getMauSac());
			ps.setString(4, d.getChatLieu());
			ps.setString(5, d.getKichThuoc());
			ps.setString(6, d.getHoTroNguon());
			ps.setInt(7, d.getSoLuongQuatHoTro());
			ps.setBoolean(8, d.isCoKinhCuongLuc());
			ps.setString(9, d.getCongTruocCase());
		});
	}

	public void insertPsuDetail(PsuDetail d) {
		String sql = "INSERT INTO CHI_TIET_NGUON (MaSP, CongSuat, Chuan80Plus, CongKetNoi, "
				+ "KichThuocNguon, DienApVao, DauCapNguon) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getCongSuat());
			ps.setString(3, d.getChuan80Plus());
			ps.setString(4, d.getCongKetNoi());
			ps.setString(5, d.getKichThuocNguon());
			ps.setString(6, d.getDienApVao());
			ps.setString(7, d.getDauCapNguon());
		});
	}

	public void insertCoolerDetail(CoolerDetail d) {
		String sql = "INSERT INTO CHI_TIET_TAN_NHIET (MaSP, LoaiTanNhiet, TuongThichCPU, KichThuocRadiator, "
				+ "SoQuat, TocDoQuat, DoOn, LED, KichThuocTan) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getLoaiTanNhiet());
			ps.setString(3, d.getTuongThichCPU());
			ps.setString(4, d.getKichThuocRadiator());
			ps.setInt(5, d.getSoQuat());
			ps.setString(6, d.getTocDoQuat());
			ps.setString(7, d.getDoOn());
			ps.setString(8, d.getLed());
			ps.setString(9, d.getKichThuocTan());
		});
	}

	public void insertStorageDetail(StorageDetail d) {
		String sql = "INSERT INTO CHI_TIET_O_CUNG (MaSP, LoaiOCung, DungLuong, ChuanKetNoi, KichCo, TocDoDocGhi) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getLoaiOCung());
			ps.setString(3, d.getDungLuong());
			ps.setString(4, d.getChuanKetNoi());
			ps.setString(5, d.getKichCo());
			ps.setString(6, d.getTocDoDocGhi());
		});
	}

	public void insertRamDetail(RamDetail d) {
		String sql = "INSERT INTO CHI_TIET_RAM (MaSP, LoaiRam, DungLuong, BusRam, DienAp, SoThanh) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		executeDetailUpdate(sql, d.getMaSP(), ps -> {
			ps.setString(2, d.getLoaiRam());
			ps.setString(3, d.getDungLuong());
			ps.setString(4, d.getBusRam());
			ps.setString(5, d.getDienAp());
			ps.setInt(6, d.getSoThanh());
		});
	}

	// =========================================================
	// UPSERT (insert nếu chưa có, update nếu đã có)
	// =========================================================
	public void upsertMainboardDetail(MainboardDetail d) {
		if (getMainboardDetail(d.getMaSP()) != null) {
			updateMainboardDetail(d);
		} else {
			insertMainboardDetail(d);
		}
	}

	public void upsertCpuDetail(CpuDetail d) {
		if (getCpuDetail(d.getMaSP()) != null) {
			updateCpuDetail(d);
		} else {
			insertCpuDetail(d);
		}
	}

	public void upsertVgaDetail(VgaDetail d) {
		if (getVgaDetail(d.getMaSP()) != null) {
			updateVgaDetail(d);
		} else {
			insertVgaDetail(d);
		}
	}

	public void upsertCaseDetail(CaseDetail d) {
		if (getCaseDetail(d.getMaSP()) != null) {
			updateCaseDetail(d);
		} else {
			insertCaseDetail(d);
		}
	}

	public void upsertPsuDetail(PsuDetail d) {
		if (getPsuDetail(d.getMaSP()) != null) {
			updatePsuDetail(d);
		} else {
			insertPsuDetail(d);
		}
	}

	public void upsertCoolerDetail(CoolerDetail d) {
		if (getCoolerDetail(d.getMaSP()) != null) {
			updateCoolerDetail(d);
		} else {
			insertCoolerDetail(d);
		}
	}

	public void upsertStorageDetail(StorageDetail d) {
		if (getStorageDetail(d.getMaSP()) != null) {
			updateStorageDetail(d);
		} else {
			insertStorageDetail(d);
		}
	}

	public void upsertRamDetail(RamDetail d) {
		if (getRamDetail(d.getMaSP()) != null) {
			updateRamDetail(d);
		} else {
			insertRamDetail(d);
		}
	}

	// =========================================================
	// UPDATE
	// =========================================================
	public void updateMainboardDetail(MainboardDetail d) {
		String sql = "UPDATE CHI_TIET_MAIN SET Chipset=?, Socket=?, KichThuocMain=?, HoTroCPU=?, "
				+ "SoKheRam=?, LoaiRam=?, DungLuongRamToiDa=?, KhePCIe=?, SoCongSATA=?, SoKheM2=?, CongXuatHinh=? "
				+ "WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getChipset());
			ps.setString(2, d.getSocket());
			ps.setString(3, d.getKichThuocMain());
			ps.setString(4, d.getHoTroCPU());
			ps.setInt(5, d.getSoKheRam());
			ps.setString(6, d.getLoaiRam());
			ps.setString(7, d.getDungLuongRamToiDa());
			ps.setString(8, d.getKhePCIe());
			ps.setInt(9, d.getSoCongSATA());
			ps.setInt(10, d.getSoKheM2());
			ps.setString(11, d.getCongXuatHinh());
			ps.setInt(12, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_MAIN", e);
		}
	}

	public void updateCpuDetail(CpuDetail d) {
		String sql = "UPDATE CHI_TIET_CPU SET HangCPU=?, DongCPU=?, Socket=?, SoNhan=?, SoLuongLuong=?, "
				+ "XungNhipCoBan=?, XungNhipTurbo=?, CacheL1=?, CacheL2=?, TDP=?, CoGPU=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getHangCPU());
			ps.setString(2, d.getDongCPU());
			ps.setString(3, d.getSocket());
			ps.setInt(4, d.getSoNhan());
			ps.setInt(5, d.getSoLuongLuong());
			ps.setString(6, d.getXungNhipCoBan());
			ps.setString(7, d.getXungNhipTurbo());
			ps.setString(8, d.getCacheL1());
			ps.setString(9, d.getCacheL2());
			ps.setString(10, d.getTdp());
			ps.setBoolean(11, d.isCoGPU());
			ps.setInt(12, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_CPU", e);
		}
	}

	public void updateVgaDetail(VgaDetail d) {
		String sql = "UPDATE CHI_TIET_VGA SET HangGPU=?, DungLuongVRAM=?, KieuBoNho=?, BusBoNho=?, "
				+ "XungNhip=?, TDP=?, CongKetNoi=?, SoQuat=?, KichThuocCard=?, DauCapNguon=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getHangGPU());
			ps.setString(2, d.getDungLuongVRAM());
			ps.setString(3, d.getKieuBoNho());
			ps.setString(4, d.getBusBoNho());
			ps.setString(5, d.getXungNhip());
			ps.setString(6, d.getTdp());
			ps.setString(7, d.getCongKetNoi());
			ps.setInt(8, d.getSoQuat());
			ps.setString(9, d.getKichThuocCard());
			ps.setString(10, d.getDauCapNguon());
			ps.setInt(11, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_VGA", e);
		}
	}

	public void updateCaseDetail(CaseDetail d) {
		String sql = "UPDATE CHI_TIET_CASE SET HoTroMain=?, MauSac=?, ChatLieu=?, KichThuoc=?, "
				+ "HoTroNguon=?, SoLuongQuatHoTro=?, CoKinhCuongLuc=?, CongTruocCase=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getHoTroMain());
			ps.setString(2, d.getMauSac());
			ps.setString(3, d.getChatLieu());
			ps.setString(4, d.getKichThuoc());
			ps.setString(5, d.getHoTroNguon());
			ps.setInt(6, d.getSoLuongQuatHoTro());
			ps.setBoolean(7, d.isCoKinhCuongLuc());
			ps.setString(8, d.getCongTruocCase());
			ps.setInt(9, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_CASE", e);
		}
	}

	public void updatePsuDetail(PsuDetail d) {
		String sql = "UPDATE CHI_TIET_NGUON SET CongSuat=?, Chuan80Plus=?, CongKetNoi=?, "
				+ "KichThuocNguon=?, DienApVao=?, DauCapNguon=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getCongSuat());
			ps.setString(2, d.getChuan80Plus());
			ps.setString(3, d.getCongKetNoi());
			ps.setString(4, d.getKichThuocNguon());
			ps.setString(5, d.getDienApVao());
			ps.setString(6, d.getDauCapNguon());
			ps.setInt(7, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_NGUON", e);
		}
	}

	public void updateCoolerDetail(CoolerDetail d) {
		String sql = "UPDATE CHI_TIET_TAN_NHIET SET LoaiTanNhiet=?, TuongThichCPU=?, KichThuocRadiator=?, "
				+ "SoQuat=?, TocDoQuat=?, DoOn=?, LED=?, KichThuocTan=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getLoaiTanNhiet());
			ps.setString(2, d.getTuongThichCPU());
			ps.setString(3, d.getKichThuocRadiator());
			ps.setInt(4, d.getSoQuat());
			ps.setString(5, d.getTocDoQuat());
			ps.setString(6, d.getDoOn());
			ps.setString(7, d.getLed());
			ps.setString(8, d.getKichThuocTan());
			ps.setInt(9, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_TAN_NHIET", e);
		}
	}

	public void updateStorageDetail(StorageDetail d) {
		String sql = "UPDATE CHI_TIET_O_CUNG SET LoaiOCung=?, DungLuong=?, ChuanKetNoi=?, KichCo=?, TocDoDocGhi=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getLoaiOCung());
			ps.setString(2, d.getDungLuong());
			ps.setString(3, d.getChuanKetNoi());
			ps.setString(4, d.getKichCo());
			ps.setString(5, d.getTocDoDocGhi());
			ps.setInt(6, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_O_CUNG", e);
		}
	}

	public void updateRamDetail(RamDetail d) {
		String sql = "UPDATE CHI_TIET_RAM SET LoaiRam=?, DungLuong=?, BusRam=?, DienAp=?, SoThanh=? WHERE MaSP=?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, d.getLoaiRam());
			ps.setString(2, d.getDungLuong());
			ps.setString(3, d.getBusRam());
			ps.setString(4, d.getDienAp());
			ps.setInt(5, d.getSoThanh());
			ps.setInt(6, d.getMaSP());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi cập nhật CHI_TIET_RAM", e);
		}
	}

	// =========================================================
	// PRIVATE HELPERS
	// =========================================================

	@FunctionalInterface
	private interface DetailParamSetter {
		void set(PreparedStatement ps) throws SQLException;
	}

	private void executeDetailUpdate(String sql, int maSP, DetailParamSetter setter) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, maSP);
			setter.set(ps);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new DatabaseException("Lỗi thao tác chi tiết sản phẩm: " + sql.substring(0, 40) + "...", e);
		}
	}
}
