package com.computerstore.models;

import java.math.BigDecimal;

public class CartItem {
	private int maSP;
	private String tenSP;
	private BigDecimal giaBan;
	private int soLuong;
	private String anhChinh;

	public CartItem() {
	}

	public CartItem(int maSP, String tenSP, BigDecimal giaBan, int soLuong, String anhChinh) {
		this.maSP = maSP;
		this.tenSP = tenSP;
		this.giaBan = giaBan;
		this.soLuong = soLuong;
		this.anhChinh = anhChinh;
	}

	public int getMaSP() {
		return maSP;
	}

	public void setMaSP(int maSP) {
		this.maSP = maSP;
	}

	public String getTenSP() {
		return tenSP;
	}

	public void setTenSP(String tenSP) {
		this.tenSP = tenSP;
	}

	public BigDecimal getGiaBan() {
		return giaBan;
	}

	public void setGiaBan(BigDecimal giaBan) {
		this.giaBan = giaBan;
	}

	public int getSoLuong() {
		return soLuong;
	}

	public void setSoLuong(int soLuong) {
		this.soLuong = soLuong;
	}

	public String getAnhChinh() {
		return anhChinh;
	}

	public void setAnhChinh(String anhChinh) {
		this.anhChinh = anhChinh;
	}

	public BigDecimal getThanhTien() {
		return this.giaBan.multiply(new BigDecimal(this.soLuong));
	}
}
