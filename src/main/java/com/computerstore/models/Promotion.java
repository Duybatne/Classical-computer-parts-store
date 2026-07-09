package com.computerstore.models;

import java.math.BigDecimal;
import java.sql.Date;

public class Promotion {
	private int maKM;
	private String tenKM;
	private String loaiGiam; // PHAN_TRAM, SO_TIEN
	private BigDecimal giaTriGiam;
	private Date ngayBatDau;
	private Date ngayKetThuc;
	private boolean trangThai;
	private Integer maNV; // Người tạo khuyến mãi

	public Promotion() {
	}

	public Promotion(int maKM, String tenKM, String loaiGiam, BigDecimal giaTriGiam, Date ngayBatDau, Date ngayKetThuc,
			boolean trangThai) {
		this.maKM = maKM;
		this.tenKM = tenKM;
		this.loaiGiam = loaiGiam;
		this.giaTriGiam = giaTriGiam;
		this.ngayBatDau = ngayBatDau;
		this.ngayKetThuc = ngayKetThuc;
		this.trangThai = trangThai;
	}

	public int getMaKM() {
		return maKM;
	}

	public void setMaKM(int maKM) {
		this.maKM = maKM;
	}

	public String getTenKM() {
		return tenKM;
	}

	public void setTenKM(String tenKM) {
		this.tenKM = tenKM;
	}

	public String getLoaiGiam() {
		return loaiGiam;
	}

	public void setLoaiGiam(String loaiGiam) {
		this.loaiGiam = loaiGiam;
	}

	public BigDecimal getGiaTriGiam() {
		return giaTriGiam;
	}

	public void setGiaTriGiam(BigDecimal giaTriGiam) {
		this.giaTriGiam = giaTriGiam;
	}

	public Date getNgayBatDau() {
		return ngayBatDau;
	}

	public void setNgayBatDau(Date ngayBatDau) {
		this.ngayBatDau = ngayBatDau;
	}

	public Date getNgayKetThuc() {
		return ngayKetThuc;
	}

	public void setNgayKetThuc(Date ngayKetThuc) {
		this.ngayKetThuc = ngayKetThuc;
	}

	public boolean isTrangThai() {
		return trangThai;
	}

	public void setTrangThai(boolean trangThai) {
		this.trangThai = trangThai;
	}

	public Integer getMaNV() {
		return maNV;
	}

	public void setMaNV(Integer maNV) {
		this.maNV = maNV;
	}
}
