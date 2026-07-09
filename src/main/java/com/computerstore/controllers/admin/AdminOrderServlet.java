package com.computerstore.controllers.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.computerstore.dao.PaymentDAO;
import com.computerstore.models.Order;
import com.computerstore.models.Payment;
import com.computerstore.models.User;
import com.computerstore.services.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
	private OrderService orderService = new OrderService();
	private PaymentDAO paymentDAO = new PaymentDAO();

	// Order status state machine: valid transitions
	private static final Map<String, Set<String>> VALID_TRANSITIONS = new HashMap<>();
	static {
		VALID_TRANSITIONS.put("CHO_XAC_NHAN", Set.of("DA_XAC_NHAN", "DA_HUY"));
		VALID_TRANSITIONS.put("DA_XAC_NHAN", Set.of("DANG_GIAO", "DA_HUY"));
		VALID_TRANSITIONS.put("DANG_GIAO", Set.of("DA_GIAO"));
		VALID_TRANSITIONS.put("DA_GIAO", Set.of());
		VALID_TRANSITIONS.put("DA_HUY", Set.of());
	}

	private boolean isAdmin(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("user");
		return user != null && "QUAN_TRI_VIEN".equals(user.getVaiTro());
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String action = req.getParameter("action");
		if ("view".equals(action)) {
			try {
				int maDonHang = Integer.parseInt(req.getParameter("id"));
				Order order = orderService.getOrderById(maDonHang);
				if (order != null) {
					req.setAttribute("order", order);
					req.setAttribute("details", orderService.getOrderDetails(maDonHang));
					req.setAttribute("payment", paymentDAO.getByOrderId(maDonHang));
					req.getRequestDispatcher("/jsp/admin/order-detail.jsp").forward(req, resp);
					return;
				}
			} catch (NumberFormatException e) {
				// Invalid ID
			}
			resp.sendRedirect(req.getContextPath() + "/admin/orders");
			return;
		}

		List<Order> orders = orderService.getAllOrders();
		req.setAttribute("orders", orders);

		// Fetch payment info for each order to display payment method
		Map<Integer, Payment> orderPayments = new HashMap<>();
		for (Order order : orders) {
			Payment payment = paymentDAO.getByOrderId(order.getMaDonHang());
			if (payment != null) {
				orderPayments.put(order.getMaDonHang(), payment);
			}
		}
		req.setAttribute("orderPayments", orderPayments);

		req.getRequestDispatcher("/jsp/admin/orders.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String action = req.getParameter("action");
		if ("updateStatus".equals(action)) {
			try {
				int maDonHang = Integer.parseInt(req.getParameter("maDonHang"));
				String newStatus = req.getParameter("status");
				if (newStatus != null && !newStatus.isEmpty()) {
					Order order = orderService.getOrderById(maDonHang);
					if (order != null) {
						String currentStatus = order.getTrangThaiDonHang();
						Set<String> allowed = VALID_TRANSITIONS.getOrDefault(currentStatus, Set.of());
						if (allowed.contains(newStatus)) {
							orderService.updateOrderStatus(maDonHang, newStatus);
							req.getSession().setAttribute("successMessage",
									"Cập nhật trạng thái đơn hàng #" + maDonHang + " thành công.");
						} else {
							req.getSession().setAttribute("errorMessage",
									"Không thể chuyển trạng thái từ '" + currentStatus + "' sang '" + newStatus + "'.");
						}
					}
				}
			} catch (NumberFormatException e) {
				req.getSession().setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
			}
		}
		resp.sendRedirect(req.getContextPath() + "/admin/orders");
	}
}
