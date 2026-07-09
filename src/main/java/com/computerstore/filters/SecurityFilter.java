package com.computerstore.filters;

import java.io.IOException;

import com.computerstore.models.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = { "/admin/*", "*.jsp" })
public class SecurityFilter extends HttpFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getServletPath();

        // ── Set security headers ──
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("X-Frame-Options", "DENY");
        resp.setHeader("X-XSS-Protection", "1; mode=block");
        resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");
        resp.setHeader("Content-Security-Policy",
                "default-src 'self'; " +
                        "script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; " +
                        "style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://fonts.googleapis.com; " +
                        "font-src 'self' https://cdnjs.cloudflare.com https://fonts.gstatic.com; " +
                        "img-src 'self' data:; " +
                        "frame-ancestors 'none'");
        resp.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        resp.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");

        // ── Prevent direct JSP access (except root-level public pages) ──
        if (path.endsWith(".jsp") && !path.startsWith("/jsp/")
                && !"/404.jsp".equals(path)
                && !"/index.jsp".equals(path)) {
            req.setAttribute("errorMessage", "Trang khong ton tai.");
            req.setAttribute("httpStatus", 404);
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
            return;
        }

        // ── Admin area protection ──
        if (path.startsWith("/admin")) {
            // Allow static resources
            if (path.startsWith("/admin-asset/")) {
                chain.doFilter(request, response);
                return;
            }

            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                // Not logged in - redirect to login
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"QUAN_TRI_VIEN".equals(user.getVaiTro())) {
                // Logged in but not admin - forbidden
                req.setAttribute("errorMessage", "Ban khong co quyen truy cap trang quan tri.");
                req.setAttribute("httpStatus", 403);
                req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
