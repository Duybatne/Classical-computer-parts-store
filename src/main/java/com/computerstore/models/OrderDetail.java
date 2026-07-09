package com.computerstore.models;

import java.math.BigDecimal;

public class OrderDetail {
	private int maDonHang;
	private int maSP;
	private String tenSP; // Tiện ích để show ra giao diện
	private int soLuong;
	private BigDecimal donGia; // Giá tại thời điểm đặt hàng
	private BigDecimal thanhTien;

	public OrderDetail() {
	}

	public OrderDetail(int maDonHang, int maSP, String tenSP, int soLuong, BigDecimal donGia, BigDecimal thanhTien) {
		this.maDonHang = maDonHang;
		this.maSP = maSP;
		this.tenSP = tenSP;
		this.soLuong = soLuong;
		this.donGia = donGia;
		this.thanhTien = thanhTien;
	}

	public int getMaDonHang() {
		return maDonHang;
	}

	public void setMaDonHang(int maDonHang) {
		this.maDonHang = maDonHang;
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

	public int getSoLuong() {
		return soLuong;
	}

	public void setSoLuong(int soLuong) {
		this.soLuong = soLuong;
	}

	public BigDecimal getDonGia() {
		return donGia;
	}

	public void setDonGia(BigDecimal donGia) {
		this.donGia = donGia;
	}

	public BigDecimal getThanhTien() {
		return thanhTien;
	}

	public void setThanhTien(BigDecimal thanhTien) {
		this.thanhTien = thanhTien;
	}
}
