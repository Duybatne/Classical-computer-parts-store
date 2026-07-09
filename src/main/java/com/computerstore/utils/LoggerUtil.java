package com.computerstore.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Centralized logging utility.
 * Replaces all System.out.println() and printStackTrace() calls.
 */
public final class LoggerUtil {

    private LoggerUtil() {
        // Prevent instantiation
    }

    /**
     * Get a logger for the given class
     */
    public static Logger getLogger(Class<?> clazz) {
        return LoggerFactory.getLogger(clazz);
    }

    /**
     * Log an error with exception
     */
    public static void error(Class<?> clazz, String message, Throwable e) {
        Logger logger = getLogger(clazz);
        logger.error(message, e);
    }

    /**
     * Log a warning message
     */
    public static void warn(Class<?> clazz, String message) {
        Logger logger = getLogger(clazz);
        logger.warn(message);
    }

    /**
     * Log an info message
     */
    public static void info(Class<?> clazz, String message) {
        Logger logger = getLogger(clazz);
        logger.info(message);
    }

    /**
     * Log a debug message
     */
    public static void debug(Class<?> clazz, String message) {
        Logger logger = getLogger(clazz);
        logger.debug(message);
    }
}
