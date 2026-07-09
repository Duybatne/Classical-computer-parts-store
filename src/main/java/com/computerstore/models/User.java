package com.computerstore.models;

import java.sql.Timestamp;

public class User {
	private int maTK;
	private int maKH;
	private String tenDangNhap;
	private String matKhauHash;
	private String vaiTro;
	private String hoTen;
	private String email;
	private String soDienThoai;
	private String diaChi;
	private int trangThai;
	private Timestamp ngayDangNhapCuoi;

	public User() {
	}

	public User(int maTK, String tenDangNhap, String matKhauHash, String vaiTro, String hoTen, String email,
			String soDienThoai, String diaChi, Timestamp ngayDangNhapCuoi) {
		this.maTK = maTK;
		this.tenDangNhap = tenDangNhap;
		this.matKhauHash = matKhauHash;
		this.vaiTro = vaiTro;
		this.hoTen = hoTen;
		this.email = email;
		this.soDienThoai = soDienThoai;
		this.diaChi = diaChi;
		this.ngayDangNhapCuoi = ngayDangNhapCuoi;
	}

	public int getMaTK() {
		return maTK;
	}

	public void setMaTK(int maTK) {
		this.maTK = maTK;
	}

	public int getMaKH() {
		return maKH;
	}

	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}

	public String getTenDangNhap() {
		return tenDangNhap;
	}

	public void setTenDangNhap(String tenDangNhap) {
		this.tenDangNhap = tenDangNhap;
	}

	public String getMatKhauHash() {
		return matKhauHash;
	}

	public void setMatKhauHash(String matKhauHash) {
		this.matKhauHash = matKhauHash;
	}

	public String getVaiTro() {
		return vaiTro;
	}

	public void setVaiTro(String vaiTro) {
		this.vaiTro = vaiTro;
	}

	public String getHoTen() {
		return hoTen;
	}

	public void setHoTen(String hoTen) {
		this.hoTen = hoTen;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSoDienThoai() {
		return soDienThoai;
	}

	public void setSoDienThoai(String soDienThoai) {
		this.soDienThoai = soDienThoai;
	}

	public String getDiaChi() {
		return diaChi;
	}

	public void setDiaChi(String diaChi) {
		this.diaChi = diaChi;
	}

	public int getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(int trangThai) {
		this.trangThai = trangThai;
	}

	public Timestamp getNgayDangNhapCuoi() {
		return ngayDangNhapCuoi;
	}

	public void setNgayDangNhapCuoi(Timestamp ngayDangNhapCuoi) {
		this.ngayDangNhapCuoi = ngayDangNhapCuoi;
	}

	public boolean isCustomer() {
		return "KHACH_HANG".equals(vaiTro);
	}

	public boolean isAdmin() {
		return "QUAN_TRI_VIEN".equals(vaiTro);
	}
}
