package com.computerstore.controllers.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.computerstore.dao.ProductDAO;
import com.computerstore.dao.PromotionProductDAO;
import com.computerstore.models.Product;
import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/promotions/*")
public class PromotionProductApiServlet extends HttpServlet {
    private PromotionProductDAO promotionProductDAO = new PromotionProductDAO();
    private ProductDAO productDAO = new ProductDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Extract path info: /api/promotions/{maKM}/products...
        // getPathInfo() returns /{maKM}/products
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing promotion ID");
            return;
        }

        String[] parts = pathInfo.split("/");
        // parts[0] = "" (empty), parts[1] = maKM, parts[2] = "products"
        if (parts.length < 3 || !"products".equals(parts[2])) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path: " + pathInfo);
            return;
        }

        try {
            int maKM = Integer.parseInt(parts[1]);
            String allParam = req.getParameter("all");

            if ("true".equals(allParam)) {
                // Return ALL products with a "checked" flag indicating if assigned to this
                // promotion
                Set<Integer> assignedProductIds = new HashSet<>(promotionProductDAO.getProductsByPromotion(maKM));
                List<Product> allProducts = productDAO.getAllAdmin();

                java.util.List<java.util.Map<String, Object>> result = new java.util.ArrayList<>();
                for (Product p : allProducts) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("maSP", p.getMaSP());
                    map.put("tenSP", p.getTenSP());
                    map.put("giaBan", p.getGiaBan());
                    map.put("anhChinh", p.getAnhChinh());
                    map.put("checked", assignedProductIds.contains(p.getMaSP()));
                    result.add(map);
                }

                PrintWriter out = resp.getWriter();
                out.print(gson.toJson(result));
                out.flush();
            } else {
                // Return only assigned products (original behavior)
                List<Integer> productIds = promotionProductDAO.getProductsByPromotion(maKM);

                java.util.List<java.util.Map<String, Object>> products = new java.util.ArrayList<>();
                for (int maSP : productIds) {
                    Product p = productDAO.getById(maSP);
                    if (p != null) {
                        java.util.Map<String, Object> map = new java.util.HashMap<>();
                        map.put("maSP", p.getMaSP());
                        map.put("tenSP", p.getTenSP());
                        map.put("giaBan", p.getGiaBan());
                        map.put("anhChinh", p.getAnhChinh());
                        products.add(map);
                    }
                }

                PrintWriter out = resp.getWriter();
                out.print(gson.toJson(products));
                out.flush();
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(java.util.Map.of(
                    "ok", false,
                    "message", "Tham số promotion ID không hợp lệ")));
            out.flush();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(java.util.Map.of(
                    "ok", false,
                    "message", "Có lỗi xảy ra. Vui lòng thử lại sau")));
            out.flush();
        }
    }
}
