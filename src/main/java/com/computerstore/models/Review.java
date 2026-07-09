package com.computerstore.models;

import java.sql.Timestamp;

public class Review {
	private int maDanhGia;
	private int maKH;
	private String tenKhachHang; // Thuộc tính phụ hiển thị trên UI
	private int maSP;
	private int soSao;
	private String noiDung;
	private Timestamp ngayDanhGia;
	private int trangThaiDuyet; // 0: Chờ duyệt, 1: Đã duyệt, 2: Đã ẩn

	public Review() {
	}

	public Review(int maDanhGia, int maKH, int maSP, int soSao, String noiDung, Timestamp ngayDanhGia,
			int trangThaiDuyet) {
		this.maDanhGia = maDanhGia;
		this.maKH = maKH;
		this.maSP = maSP;
		this.soSao = soSao;
		this.noiDung = noiDung;
		this.ngayDanhGia = ngayDanhGia;
		this.trangThaiDuyet = trangThaiDuyet;
	}

	public int getMaDanhGia() {
		return maDanhGia;
	}

	public void setMaDanhGia(int maDanhGia) {
		this.maDanhGia = maDanhGia;
	}

	public int getMaKH() {
		return maKH;
	}

	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}

	public String getTenKhachHang() {
		return tenKhachHang;
	}

	public void setTenKhachHang(String tenKhachHang) {
		this.tenKhachHang = tenKhachHang;
	}

	public int getMaSP() {
		return maSP;
	}

	public void setMaSP(int maSP) {
		this.maSP = maSP;
	}

	public int getSoSao() {
		return soSao;
	}

	public void setSoSao(int soSao) {
		this.soSao = soSao;
	}

	public String getNoiDung() {
		return noiDung;
	}

	public void setNoiDung(String noiDung) {
		this.noiDung = noiDung;
	}

	public Timestamp getNgayDanhGia() {
		return ngayDanhGia;
	}

	public void setNgayDanhGia(Timestamp ngayDanhGia) {
		this.ngayDanhGia = ngayDanhGia;
	}

	public int getTrangThaiDuyet() {
		return trangThaiDuyet;
	}

	public void setTrangThaiDuyet(int trangThaiDuyet) {
		this.trangThaiDuyet = trangThaiDuyet;
	}
}
