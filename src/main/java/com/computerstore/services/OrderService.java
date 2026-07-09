package com.computerstore.services;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.dao.CartDAO;
import com.computerstore.dao.OrderDAO;
import com.computerstore.dao.OrderDetailDAO;
import com.computerstore.dao.PaymentDAO;
import com.computerstore.dao.ProductDAO;
import com.computerstore.models.CartItem;
import com.computerstore.models.Order;
import com.computerstore.models.OrderDetail;
import com.computerstore.models.Payment;
import com.computerstore.utils.AppConstants;
import com.computerstore.utils.DBConnection;

public class OrderService {
	private OrderDAO orderDAO = new OrderDAO();
	private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
	private CartDAO cartDAO = new CartDAO();
	private ProductDAO productDAO = new ProductDAO();
	private PaymentDAO paymentDAO = new PaymentDAO();
	private PromotionService promotionService = new PromotionService();
	private CartService cartService = new CartService();

	public boolean placeOrder(int maKH, String address, String phone, String note, Integer maKM, int maPTTT) {
		int cartId = cartDAO.getCartIdByCustomerId(maKH);
		if (cartId == -1)
			return false;

		List<CartItem> items = cartService.getCartItems(maKH);
		if (items.isEmpty())
			return false;

		BigDecimal subtotal = BigDecimal.ZERO;
		for (CartItem item : items) {
			subtotal = subtotal.add(item.getThanhTien());
		}

		// Shipping rule must match CartServlet.populateCartAttributes()
		BigDecimal shipping = subtotal.compareTo(AppConstants.FREE_SHIPPING_THRESHOLD) >= 0 ? BigDecimal.ZERO
				: AppConstants.STANDARD_SHIPPING_FEE;

		BigDecimal total = subtotal.add(shipping);

		if (maKM != null) {
			BigDecimal discount = promotionService.applyVoucherToCart(maKM, items);
			total = total.subtract(discount).max(BigDecimal.ZERO);
		}

		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			Order order = new Order(0, maKH, new Timestamp(System.currentTimeMillis()), "CHO_XAC_NHAN", total, address,
					phone, note, maKM);
			order.setPhiVanChuyen(shipping);
			int newOrderId = orderDAO.insert(order, conn);

			if (newOrderId == -1)
				throw new SQLException("Failed to insert Order");

			// Kiểm tra tồn kho cho tất cả sản phẩm
			for (CartItem item : items) {
				if (!productDAO.hasSufficientStock(item.getMaSP(), item.getSoLuong(), conn)) {
					throw new SQLException("Sản phẩm " + item.getTenSP() + " không đủ hàng trong kho. Tồn kho: "
							+ productDAO.getStock(item.getMaSP(), conn) + ", yêu cầu: " + item.getSoLuong());
				}
			}

			List<OrderDetail> details = new ArrayList<>();
			for (CartItem item : items) {
				details.add(new OrderDetail(newOrderId, item.getMaSP(), null, item.getSoLuong(), item.getGiaBan(),
						item.getThanhTien()));
				// Trừ tồn kho (đã kiểm tra đủ hàng ở trên)
				productDAO.updateStock(item.getMaSP(), -item.getSoLuong(), conn);
			}
			orderDetailDAO.insertBatch(details, conn);

			// Tao thanh toan
			Payment payment = new Payment();
			payment.setMaDonHang(newOrderId);
			payment.setMaPTTT(maPTTT);
			payment.setSoTien(total);
			payment.setTrangThaiThanhToan("CHUA_THANH_TOAN");
			paymentDAO.insert(payment, conn);

			// clear cart within transaction
			String clearCartSql = "DELETE FROM CHI_TIET_GIO_HANG WHERE MaGioHang = ?";
			try (java.sql.PreparedStatement ps = conn.prepareStatement(clearCartSql)) {
				ps.setInt(1, cartId);
				ps.executeUpdate();
			}

			conn.commit();
			return true;
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			e.printStackTrace();
			return false;
		} finally {
			if (conn != null)
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}

	public List<Order> getOrdersByCustomer(int maKH) {
		return orderDAO.getByCustomerId(maKH);
	}

	public List<Order> getAllOrders() {
		return orderDAO.getAll();
	}

	public Order getOrderById(int maDonHang) {
		return orderDAO.getById(maDonHang);
	}

	public List<OrderDetail> getOrderDetails(int maDonHang) {
		return orderDetailDAO.getByOrderId(maDonHang);
	}

	public boolean cancelOrder(int maDonHang) {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			Order order = orderDAO.getById(maDonHang);
			if (order == null || !"CHO_XAC_NHAN".equals(order.getTrangThaiDonHang())) {
				return false;
			}

			boolean updated = orderDAO.updateStatus(maDonHang, "DA_HUY", conn);
			if (!updated)
				throw new SQLException("Update status failed");

			List<OrderDetail> details = orderDetailDAO.getByOrderId(maDonHang);
			for (OrderDetail detail : details) {
				productDAO.updateStock(detail.getMaSP(), detail.getSoLuong(), conn);
			}

			conn.commit();
			return true;
		} catch (SQLException e) {
			if (conn != null)
				try {
					conn.rollback();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			e.printStackTrace();
			return false;
		} finally {
			if (conn != null)
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}

	public boolean updateOrderStatus(int maDonHang, String status) {
		if ("DA_HUY".equals(status)) {
			Connection conn = null;
			try {
				conn = DBConnection.getConnection();
				conn.setAutoCommit(false);

				boolean updated = orderDAO.updateStatus(maDonHang, "DA_HUY", conn);
				if (!updated)
					throw new SQLException("Update status failed");

				List<OrderDetail> details = orderDetailDAO.getByOrderId(maDonHang);
				for (OrderDetail detail : details) {
					productDAO.updateStock(detail.getMaSP(), detail.getSoLuong(), conn);
				}

				conn.commit();
				return true;
			} catch (SQLException e) {
				if (conn != null) {
					try {
						conn.rollback();
					} catch (SQLException ex) {
						ex.printStackTrace();
					}
				}
				e.printStackTrace();
				return false;
			} finally {
				if (conn != null) {
					try {
						conn.setAutoCommit(true);
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		} else {
			return orderDAO.updateStatus(maDonHang, status);
		}
	}
}
