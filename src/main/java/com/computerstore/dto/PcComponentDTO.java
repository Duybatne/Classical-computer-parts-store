package com.computerstore.dto;

public class PcComponentDTO {
	private int maSP;
	private String tenSP;
	private String anhChinh;
	private double giaBan;
	private String socket;
	private String ramType;
	private int soLuongTon;

	public PcComponentDTO() {
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

	public String getAnhChinh() {
		return anhChinh;
	}

	public void setAnhChinh(String anhChinh) {
		this.anhChinh = anhChinh;
	}

	public double getGiaBan() {
		return giaBan;
	}

	public void setGiaBan(double giaBan) {
		this.giaBan = giaBan;
	}

	public String getSocket() {
		return socket;
	}

	public void setSocket(String socket) {
		this.socket = socket;
	}

	public String getRamType() {
		return ramType;
	}

	public void setRamType(String ramType) {
		this.ramType = ramType;
	}

	public int getSoLuongTon() {
		return soLuongTon;
	}

	public void setSoLuongTon(int soLuongTon) {
		this.soLuongTon = soLuongTon;
	}
}
