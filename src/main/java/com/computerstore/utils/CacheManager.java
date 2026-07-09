package com.computerstore.utils;

import java.util.List;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * Redis Cache Manager for improving application performance
 * Provides caching for products, categories, and other frequently accessed data
 */
public class CacheManager {
    private static JedisPool jedisPool;
    private static final Gson gson = new Gson();

    // Cache key prefixes
    public static final String PRODUCT_KEY_PREFIX = "product:";
    public static final String CATEGORY_KEY_PREFIX = "category:";
    public static final String BEST_SELLER_KEY_PREFIX = "bestseller:";
    public static final String SEARCH_KEY_PREFIX = "search:";

    // Default TTL values
    private static final long PRODUCT_TTL = 1; // 1 hour
    private static final long CATEGORY_TTL = 30; // 30 minutes
    private static final long BEST_SELLER_TTL = 1; // 1 hour
    private static final long SEARCH_TTL = 10; // 10 minutes

    static {
        try {
            String redisHost = getEnvVar("REDIS_HOST", "localhost");
            String redisPort = getEnvVar("REDIS_PORT", "6379");
            String redisPassword = getEnvVar("REDIS_PASSWORD", "");

            int port = Integer.parseInt(redisPort);

            // Khởi tạo config để hỗ trợ truyền password và timeout trong Jedis 4.x
            JedisPoolConfig poolConfig = new JedisPoolConfig();
            poolConfig.setMaxTotal(128);
            poolConfig.setMaxIdle(128);

            if (redisPassword != null && !redisPassword.isEmpty()) {
                // Constructor cho Jedis 4.x: Config, Host, Port, Timeout, Password
                jedisPool = new JedisPool(poolConfig, redisHost, port, 2000, redisPassword);
            } else {
                jedisPool = new JedisPool(poolConfig, redisHost, port, 2000);
            }

            System.out.println("Redis Cache Manager initialized: " + redisHost + ":" + redisPort);
        } catch (Exception e) {
            System.err.println("Failed to initialize Redis Cache Manager: " + e.getMessage());
            // In stack trace để debug kỹ hơn nếu cần
            // e.printStackTrace();
            System.err.println("Caching will be disabled until Redis is available");
        }
    }

    private static String getEnvVar(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        return defaultValue;
    }

    /**
     * Cache an object with default TTL
     */
    public static void cacheObject(String key, Object object, long ttl, TimeUnit unit) {
        if (jedisPool == null)
            return;

        try (Jedis jedis = jedisPool.getResource()) {
            String json = gson.toJson(object);
            jedis.setex(key, unit.toSeconds(ttl), json);
        } catch (Exception e) {
            System.err.println("Error caching object: " + e.getMessage());
        }
    }

    /**
     * Get cached object by key
     */
    @SuppressWarnings("unchecked")
    public static <T> T getCachedObject(String key, Class<T> clazz) {
        if (jedisPool == null)
            return null;

        try (Jedis jedis = jedisPool.getResource()) {
            String json = jedis.get(key);
            if (json != null) {
                return gson.fromJson(json, clazz);
            }
        } catch (Exception e) {
            System.err.println("Error getting cached object: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get cached list by key
     */
    @SuppressWarnings("unchecked")
    public static <T> List<T> getCachedList(String key, Class<T> clazz) {
        if (jedisPool == null)
            return null;

        try (Jedis jedis = jedisPool.getResource()) {
            String json = jedis.get(key);
            if (json != null) {
                return gson.fromJson(json, new TypeToken<List<T>>() {
                }.getType());
            }
        } catch (Exception e) {
            System.err.println("Error getting cached list: " + e.getMessage());
        }
        return null;
    }

    /**
     * Invalidate cache by pattern
     */
    public static void invalidateCache(String pattern) {
        if (jedisPool == null)
            return;

        try (Jedis jedis = jedisPool.getResource()) {
            jedis.keys(pattern).forEach(jedis::del);
        } catch (Exception e) {
            System.err.println("Error invalidating cache: " + e.getMessage());
        }
    }

    // ==================== Product Caching ====================

    /**
     * Cache a product
     */
    public static void cacheProduct(int productId, Object product) {
        String key = PRODUCT_KEY_PREFIX + productId;
        cacheObject(key, product, PRODUCT_TTL, TimeUnit.HOURS);
    }

    /**
     * Get cached product
     */
    public static Object getCachedProduct(int productId) {
        String key = PRODUCT_KEY_PREFIX + productId;
        return getCachedObject(key, Object.class);
    }

    /**
     * Invalidate product cache
     */
    public static void invalidateProductCache(int productId) {
        String key = PRODUCT_KEY_PREFIX + productId;
        try (Jedis jedis = jedisPool.getResource()) {
            jedis.del(key);
        } catch (Exception e) {
            System.err.println("Error invalidating product cache: " + e.getMessage());
        }
    }

    // ==================== Category Caching ====================

    /**
     * Cache category products
     */
    public static void cacheCategoryProducts(String categoryName, int page, int limit, Object products) {
        String key = CATEGORY_KEY_PREFIX + categoryName + ":page:" + page + ":limit:" + limit;
        cacheObject(key, products, CATEGORY_TTL, TimeUnit.MINUTES);
    }

    /**
     * Get cached category products
     */
    @SuppressWarnings("unchecked")
    public static List<Object> getCachedCategoryProducts(String categoryName, int page, int limit) {
        String key = CATEGORY_KEY_PREFIX + categoryName + ":page:" + page + ":limit:" + limit;
        return getCachedList(key, Object.class);
    }

    /**
     * Invalidate category cache
     */
    public static void invalidateCategoryCache(String categoryName) {
        String pattern = CATEGORY_KEY_PREFIX + categoryName + "*";
        invalidateCache(pattern);
    }

    // ==================== Best Seller Caching ====================

    /**
     * Cache best sellers by category
     */
    public static void cacheBestSellers(String category, int limit, Object products) {
        String key = BEST_SELLER_KEY_PREFIX + category + ":limit:" + limit;
        cacheObject(key, products, BEST_SELLER_TTL, TimeUnit.HOURS);
    }

    /**
     * Get cached best sellers
     */
    @SuppressWarnings("unchecked")
    public static List<Object> getCachedBestSellers(String category, int limit) {
        String key = BEST_SELLER_KEY_PREFIX + category + ":limit:" + limit;
        return getCachedList(key, Object.class);
    }

    // ==================== Search Caching ====================

    /**
     * Cache search results
     */
    public static void cacheSearchResults(String keyword, int page, int limit, Object products) {
        String key = SEARCH_KEY_PREFIX + keyword.hashCode() + ":page:" + page + ":limit:" + limit;
        cacheObject(key, products, SEARCH_TTL, TimeUnit.MINUTES);
    }

    /**
     * Get cached search results
     */
    @SuppressWarnings("unchecked")
    public static List<Object> getCachedSearchResults(String keyword, int page, int limit) {
        String key = SEARCH_KEY_PREFIX + keyword.hashCode() + ":page:" + page + ":limit:" + limit;
        return getCachedList(key, Object.class);
    }

    // ==================== Utility Methods ====================

    /**
     * Check if cache is available
     */
    public static boolean isCacheAvailable() {
        if (jedisPool == null)
            return false;

        try (Jedis jedis = jedisPool.getResource()) {
            return jedis.ping().equals("PONG");
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Get cache statistics
     */
    public static String getCacheStats() {
        if (jedisPool == null)
            return "Cache not initialized";

        try (Jedis jedis = jedisPool.getResource()) {
            return String.format("Redis Cache Stats - Connected: %s, DB Size: %d keys",
                    jedis.ping(), jedis.dbSize());
        } catch (Exception e) {
            return "Error getting cache stats: " + e.getMessage();
        }
    }

    /**
     * Clear all cache (use with caution)
     */
    public static void clearAllCache() {
        if (jedisPool == null)
            return;

        try (Jedis jedis = jedisPool.getResource()) {
            jedis.flushDB();
            System.out.println("Cache cleared successfully");
        } catch (Exception e) {
            System.err.println("Error clearing cache: " + e.getMessage());
        }
    }

    /**
     * Shutdown cache manager
     */
    public static void shutdown() {
        if (jedisPool != null) {
            jedisPool.close();
            System.out.println("Redis Cache Manager shutdown complete");
        }
    }
}
