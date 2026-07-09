package com.computerstore.filters;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Performance monitoring filter.
 * Logs request processing time and provides performance stats.
 * Uses SLF4J Logger instead of System.out for production-ready logging.
 */
@WebFilter(urlPatterns = { "/*" })
public class PerformanceFilter extends HttpFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(PerformanceFilter.class);

    private long requestCount = 0;
    private long totalTime = 0;
    private long maxTime = 0;
    private String slowestPath = "";
    private static final long SLOW_THRESHOLD_MS = 500;

    @Override
    public void init(FilterConfig config) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        String path = req.getServletPath();

        // Skip static resources
        if (path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png")
                || path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".gif")
                || path.endsWith(".svg") || path.endsWith(".ico") || path.endsWith(".woff")
                || path.endsWith(".woff2") || path.endsWith(".ttf")) {
            chain.doFilter(request, response);
            return;
        }

        long start = System.currentTimeMillis();

        try {
            chain.doFilter(request, response);
        } finally {
            long elapsed = System.currentTimeMillis() - start;
            requestCount++;
            totalTime += elapsed;

            if (elapsed > SLOW_THRESHOLD_MS) {
                log.warn("SLOW request [{}] took {}ms", path, elapsed);
            }

            if (elapsed > maxTime) {
                maxTime = elapsed;
                slowestPath = path;
            }

            // Log every 100 requests
            if (requestCount % 100 == 0) {
                double avg = (double) totalTime / requestCount;
                log.info("Stats - Requests: {}, Avg: {}ms, Max: {}ms ({})",
                        requestCount, String.format("%.1f", avg), maxTime, slowestPath);
            }
        }
    }

    @Override
    public void destroy() {
        if (requestCount > 0) {
            double avg = (double) totalTime / requestCount;
            log.info("FINAL Stats - Requests: {}, Avg: {}ms, Max: {}ms ({})",
                    requestCount, String.format("%.1f", avg), maxTime, slowestPath);
        }
    }
}
