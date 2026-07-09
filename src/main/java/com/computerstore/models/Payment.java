package com.computerstore.models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
	private int maThanhToan;
	private int maDonHang;
	private int maPTTT;
	private BigDecimal soTien;
	private Timestamp thoiGianThanhToan;
	private String trangThaiThanhToan;
	private String maGiaoDich;
	private String tenNganHang;

	public int getMaThanhToan() {
		return maThanhToan;
	}

	public void setMaThanhToan(int maThanhToan) {
		this.maThanhToan = maThanhToan;
	}

	public int getMaDonHang() {
		return maDonHang;
	}

	public void setMaDonHang(int maDonHang) {
		this.maDonHang = maDonHang;
	}

	public int getMaPTTT() {
		return maPTTT;
	}

	public void setMaPTTT(int maPTTT) {
		this.maPTTT = maPTTT;
	}

	public BigDecimal getSoTien() {
		return soTien;
	}

	public void setSoTien(BigDecimal soTien) {
		this.soTien = soTien;
	}

	public Timestamp getThoiGianThanhToan() {
		return thoiGianThanhToan;
	}

	public void setThoiGianThanhToan(Timestamp thoiGianThanhToan) {
		this.thoiGianThanhToan = thoiGianThanhToan;
	}

	public String getTrangThaiThanhToan() {
		return trangThaiThanhToan;
	}

	public void setTrangThaiThanhToan(String trangThaiThanhToan) {
		this.trangThaiThanhToan = trangThaiThanhToan;
	}

	public String getMaGiaoDich() {
		return maGiaoDich;
	}

	public void setMaGiaoDich(String maGiaoDich) {
		this.maGiaoDich = maGiaoDich;
	}

	public String getTenNganHang() {
		return tenNganHang;
	}

	public void setTenNganHang(String tenNganHang) {
		this.tenNganHang = tenNganHang;
	}
}
