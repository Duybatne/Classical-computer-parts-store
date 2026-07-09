package com.computerstore.controllers.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.computerstore.models.CartItem;
import com.computerstore.models.User;
import com.computerstore.services.CartService;
import com.computerstore.services.PromotionService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = { "/api/cart/update", "/api/cart/remove", "/api/cart/voucher" })
public class CartApiServlet extends HttpServlet {

    private static final Gson gson = new Gson();

    private final CartService cartService = new CartService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        User u = (User) req.getSession().getAttribute("user");
        if (u == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(Map.of("ok", false, "message", "Vui long dang nhap.")));
            out.flush();
            return;
        }

        String path = req.getServletPath();
        HttpSession session = req.getSession();

        try {
            switch (path) {
                case "/api/cart/update": {
                    int maSP = Integer.parseInt(req.getParameter("productId"));
                    String action = req.getParameter("action");
                    if (action == null) {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        PrintWriter out = resp.getWriter();
                        out.print(gson.toJson(Map.of("ok", false, "message", "Thieu tham so action")));
                        out.flush();
                        return;
                    }

                    List<CartItem> items = cartService.getCartItems(u.getMaKH());
                    int current = items.stream().filter(i -> i.getMaSP() == maSP).mapToInt(CartItem::getSoLuong)
                            .findFirst()
                            .orElse(0);

                    if ("increase".equals(action)) {
                        cartService.updateQuantity(u.getMaKH(), maSP, current + 1);
                    } else if ("decrease".equals(action)) {
                        if (current <= 1) {
                            cartService.removeItem(u.getMaKH(), maSP);
                        } else {
                            cartService.updateQuantity(u.getMaKH(), maSP, current - 1);
                        }
                    } else {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        PrintWriter out = resp.getWriter();
                        out.print(gson.toJson(Map.of("ok", false, "message", "Hanh dong khong hop le")));
                        out.flush();
                        return;
                    }
                    break;
                }
                case "/api/cart/remove": {
                    int maSP = Integer.parseInt(req.getParameter("productId"));
                    cartService.removeItem(u.getMaKH(), maSP);
                    break;
                }
                case "/api/cart/voucher": {
                    String code = req.getParameter("voucherCode");
                    if (code == null || code.isBlank()) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing voucherCode");
                        return;
                    }

                    BigDecimal subtotal = cartService.getCartItems(u.getMaKH()).stream().map(CartItem::getThanhTien)
                            .reduce(BigDecimal.ZERO, BigDecimal::add);
                    var promos = promotionService.getActivePromotions();
                    var match = promos.stream().filter(p -> code.trim().equalsIgnoreCase(p.getTenKM())).findFirst();

                    if (match.isPresent()) {
                        int maKM = match.get().getMaKM();
                        List<CartItem> items = cartService.getCartItems(u.getMaKH());
                        BigDecimal discount = promotionService.applyVoucherToCart(maKM, items);

                        session.setAttribute("voucher", code.trim().toUpperCase());
                        session.setAttribute("discount", discount);
                        session.setAttribute("voucherMsg",
                                "Áp dụng mã thành công! Giảm " + discount.toPlainString() + "₫");
                        // Clear error if previously existed
                        session.removeAttribute("voucherError");
                    } else {
                        session.setAttribute("voucherError", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
                        session.removeAttribute("voucher");
                        session.removeAttribute("discount");
                    }
                    break;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown endpoint");
                    return;
            }

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(Map.of(
                    "ok", false,
                    "message", "Yêu cầu không hợp lệ. Vui lòng thử lại")));
            out.flush();
            return;
        }

        // Build cart response using same rule as CartServlet.populateCartAttributes
        List<CartItem> items = cartService.getCartItems(u.getMaKH());
        BigDecimal subtotal = items.stream().map(CartItem::getThanhTien).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) >= 0 ? BigDecimal.ZERO
                : new BigDecimal("30000");
        BigDecimal discount = (BigDecimal) session.getAttribute("discount");
        if (discount == null) {
            discount = BigDecimal.ZERO;
        }
        BigDecimal total = subtotal.add(shipping).subtract(discount).max(BigDecimal.ZERO);

        Object voucherCode = session.getAttribute("voucher");

        Map<String, Object> respObj = new HashMap<>();
        respObj.put("ok", true);
        respObj.put("items", items);
        respObj.put("cartSubtotal", subtotal);
        respObj.put("shippingAmount", shipping);
        respObj.put("discountAmount", discount);
        respObj.put("cartTotal", total);
        respObj.put("voucherCode", voucherCode);

        Object voucherMsg = session.getAttribute("voucherMsg");
        Object voucherError = session.getAttribute("voucherError");
        if (voucherMsg != null) {
            respObj.put("voucherMsg", voucherMsg);
        }
        if (voucherError != null) {
            respObj.put("voucherError", voucherError);
        }

        // Do not remove messages here; cart.jsp can decide.

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(respObj));
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST only");
    }
}
