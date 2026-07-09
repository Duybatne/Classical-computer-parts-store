package com.computerstore.services;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.computerstore.dao.PaymentDAO;
import com.computerstore.models.Payment;
import com.computerstore.models.PaymentMethod;

public class PaymentService {
	private PaymentDAO paymentDAO = new PaymentDAO();

	public void createPayment(int maDonHang, int maPTTT, BigDecimal soTien, Connection conn) throws SQLException {
		Payment p = new Payment();
		p.setMaDonHang(maDonHang);
		p.setMaPTTT(maPTTT);
		p.setSoTien(soTien);
		p.setTrangThaiThanhToan("CHUA_THANH_TOAN");
		paymentDAO.insert(p, conn);
	}

	public List<PaymentMethod> getPaymentMethods() {
		return paymentDAO.getAllPaymentMethods();
	}
}
