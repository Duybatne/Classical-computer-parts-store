package com.computerstore.controllers.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.computerstore.dao.PromotionProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/admin/promotions/products" })
public class AdminPromotionProductsServlet extends HttpServlet {

    private PromotionProductDAO promotionProductDAO = new PromotionProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String maKMStr = req.getParameter("maKM");
        if (maKMStr == null || maKMStr.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing maKM");
            return;
        }

        int maKM;
        try {
            maKM = Integer.parseInt(maKMStr);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid maKM");
            return;
        }

        String[] maSPs = req.getParameterValues("maSP");
        List<Integer> maSPList = new ArrayList<>();
        if (maSPs != null) {
            for (String s : maSPs) {
                if (s == null || s.isBlank()) {
                    continue;
                }
                try {
                    maSPList.add(Integer.parseInt(s));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        boolean ok = promotionProductDAO.replaceProductsByPromotion(maKM, maSPList);
        if (!ok) {
            req.getSession().setAttribute("errorMsg", "Không thể cập nhật sản phẩm áp dụng cho khuyến mãi.");
        } else {
            req.getSession().setAttribute("successMsg", "Cập nhật sản phẩm áp dụng thành công.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }
}
