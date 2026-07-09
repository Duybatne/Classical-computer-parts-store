package com.computerstore.models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
	private int maSP;
	private String tenSP;
	private int maLoaiSP;
	private String tenLoaiSP;
	private String thuongHieu;
	private BigDecimal giaBan;
	private int soLuongTon;
	private int baoHanhThang;
	private String moTaNgan;
	private String moTaChiTiet;
	private boolean hienThi;
	private Timestamp ngayTao;
	private String anhChinh;
	private BigDecimal discountedPrice;

	public Product() {
	}

	public Product(int maSP, String tenSP, int maLoaiSP, String thuongHieu, BigDecimal giaBan, int soLuongTon,
			int baoHanhThang, String moTaNgan, String moTaChiTiet, boolean hienThi, Timestamp ngayTao) {
		this.maSP = maSP;
		this.tenSP = tenSP;
		this.maLoaiSP = maLoaiSP;
		this.thuongHieu = thuongHieu;
		this.giaBan = giaBan;
		this.soLuongTon = soLuongTon;
		this.baoHanhThang = baoHanhThang;
		this.moTaNgan = moTaNgan;
		this.moTaChiTiet = moTaChiTiet;
		this.hienThi = hienThi;
		this.ngayTao = ngayTao;
	}

	// ── Getters & Setters ──────────────────────────────────────
	public int getMaSP() {
		return maSP;
	}

	public void setMaSP(int v) {
		this.maSP = v;
	}

	public String getTenSP() {
		return tenSP;
	}

	public void setTenSP(String v) {
		this.tenSP = v;
	}

	public int getMaLoaiSP() {
		return maLoaiSP;
	}

	public void setMaLoaiSP(int v) {
		this.maLoaiSP = v;
	}

	public String getTenLoaiSP() {
		return tenLoaiSP;
	}

	public void setTenLoaiSP(String v) {
		this.tenLoaiSP = v;
	}

	public String getThuongHieu() {
		return thuongHieu;
	}

	public void setThuongHieu(String v) {
		this.thuongHieu = v;
	}

	public BigDecimal getGiaBan() {
		return giaBan;
	}

	public void setGiaBan(BigDecimal v) {
		this.giaBan = v;
	}

	public int getSoLuongTon() {
		return soLuongTon;
	}

	public void setSoLuongTon(int v) {
		this.soLuongTon = v;
	}

	public int getBaoHanhThang() {
		return baoHanhThang;
	}

	public void setBaoHanhThang(int v) {
		this.baoHanhThang = v;
	}

	public String getMoTaNgan() {
		return moTaNgan;
	}

	public void setMoTaNgan(String v) {
		this.moTaNgan = v;
	}

	public String getMoTaChiTiet() {
		return moTaChiTiet;
	}

	public void setMoTaChiTiet(String v) {
		this.moTaChiTiet = v;
	}

	public boolean isHienThi() {
		return hienThi;
	}

	public void setHienThi(boolean v) {
		this.hienThi = v;
	}

	public Timestamp getNgayTao() {
		return ngayTao;
	}

	public void setNgayTao(Timestamp v) {
		this.ngayTao = v;
	}

	public String getAnhChinh() {
		return anhChinh;
	}

	public void setAnhChinh(String v) {
		this.anhChinh = v;
	}

	public BigDecimal getDiscountedPrice() {
		return discountedPrice;
	}

	public void setDiscountedPrice(BigDecimal v) {
		this.discountedPrice = v;
	}
}
