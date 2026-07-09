package com.computerstore.filters;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

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

/**
 * CSRF Protection Filter.
 *
 * - Generates CSRF token and stores in session for GET requests
 * - Validates CSRF token for POST/PUT/DELETE requests
 * - Excludes public endpoints and static resources
 */
@WebFilter(urlPatterns = { "/*" })
public class CSRFFilter extends HttpFilter implements Filter {

    private static final String CSRF_TOKEN_SESSION_ATTR = "csrfToken";
    private static final String CSRF_TOKEN_REQUEST_PARAM = "csrfToken";
    private static final String[] EXCLUDED_PATHS = {
            "/login", "/register", "/logout", "/forgot-password", "/reset-password", "/verify-email",
            "/api/", "/admin-asset/", "/css/", "/js/", "/images/", "/img/", "/lib/"
    };

    private SecureRandom secureRandom = new SecureRandom();

    @Override
    public void init(FilterConfig config) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getServletPath();

        // Skip CSRF check for excluded paths
        if (isExcludedPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession();

        // For GET requests: ensure CSRF token exists in session
        if ("GET".equalsIgnoreCase(req.getMethod())) {
            if (session.getAttribute(CSRF_TOKEN_SESSION_ATTR) == null) {
                String token = generateToken();
                session.setAttribute(CSRF_TOKEN_SESSION_ATTR, token);
            }
            chain.doFilter(request, response);
            return;
        }

        // For state-changing methods (POST, PUT, DELETE): validate CSRF token
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        String requestToken = req.getParameter(CSRF_TOKEN_REQUEST_PARAM);

        if (requestToken == null) {
            // Try reading from header (for AJAX requests)
            requestToken = req.getHeader("X-CSRF-Token");
        }

        if (sessionToken == null || requestToken == null || !sessionToken.equals(requestToken)) {
            req.setAttribute("errorMessage", "Phien lam viec het han. Vui long gui lai yeu cau.");
            req.setAttribute("httpStatus", 403);
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * Generate a new CSRF token
     */
    private String generateToken() {
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }

    /**
     * Check if the request path should be excluded from CSRF protection
     */
    private boolean isExcludedPath(String path) {
        if (path == null || path.isEmpty()) {
            return true;
        }
        for (String excluded : EXCLUDED_PATHS) {
            if (path.startsWith(excluded)) {
                return true;
            }
        }
        // Exclude static resource extensions
        if (path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png")
                || path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".gif")
                || path.endsWith(".svg") || path.endsWith(".ico") || path.endsWith(".woff")
                || path.endsWith(".woff2") || path.endsWith(".ttf")) {
            return true;
        }
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }

    /**
     * Static helper method for JSP pages to get the current CSRF token
     */
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        return token != null ? token : "";
    }
}
