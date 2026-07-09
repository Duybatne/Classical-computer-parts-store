package com.computerstore.models;

public class Category {
	private int maLoaiSP;
	private String tenLoaiSP;
	private String moTa;
	private int soLuongSP;

	public Category() {
	}

	public Category(int maLoaiSP, String tenLoaiSP, String moTa) {
		this.maLoaiSP = maLoaiSP;
		this.tenLoaiSP = tenLoaiSP;
		this.moTa = moTa;
	}

	public int getMaLoaiSP() {
		return maLoaiSP;
	}

	public void setMaLoaiSP(int maLoaiSP) {
		this.maLoaiSP = maLoaiSP;
	}

	public String getTenLoaiSP() {
		return tenLoaiSP;
	}

	public void setTenLoaiSP(String tenLoaiSP) {
		this.tenLoaiSP = tenLoaiSP;
	}

	public String getMoTa() {
		return moTa;
	}

	public void setMoTa(String moTa) {
		this.moTa = moTa;
	}

	public int getSoLuongSP() {
		return soLuongSP;
	}

	public void setSoLuongSP(int soLuongSP) {
		this.soLuongSP = soLuongSP;
	}
}
