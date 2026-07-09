package com.computerstore.models;

public class ProductImage {
	private int maAnh;
	private int maSP;
	private String duongDanAnh;
	private boolean laAnhDaiDien;

	public ProductImage() {
	}

	public ProductImage(int maAnh, int maSP, String duongDanAnh, boolean laAnhDaiDien) {
		this.maAnh = maAnh;
		this.maSP = maSP;
		this.duongDanAnh = duongDanAnh;
		this.laAnhDaiDien = laAnhDaiDien;
	}

	public int getMaAnh() {
		return maAnh;
	}

	public void setMaAnh(int maAnh) {
		this.maAnh = maAnh;
	}

	public int getMaSP() {
		return maSP;
	}

	public void setMaSP(int maSP) {
		this.maSP = maSP;
	}

	public String getDuongDanAnh() {
		return duongDanAnh;
	}

	public void setDuongDanAnh(String duongDanAnh) {
		this.duongDanAnh = duongDanAnh;
	}

	public boolean isLaAnhDaiDien() {
		return laAnhDaiDien;
	}

	public void setLaAnhDaiDien(boolean laAnhDaiDien) {
		this.laAnhDaiDien = laAnhDaiDien;
	}
}
