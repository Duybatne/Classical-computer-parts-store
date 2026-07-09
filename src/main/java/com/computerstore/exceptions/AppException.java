package com.computerstore.exceptions;

/**
 * Base application exception class
 * Provides standardized error handling across the application
 */
public class AppException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    private final ErrorCode errorCode;
    private final String userMessage;

    public AppException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.userMessage = message;
    }

    public AppException(ErrorCode errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.userMessage = message;
    }

    public ErrorCode getErrorCode() {
        return errorCode;
    }

    public String getUserMessage() {
        return userMessage;
    }

    public int getHttpStatus() {
        return errorCode.getHttpStatus();
    }

    /**
     * Error codes enum for standardized error handling
     */
    public enum ErrorCode {
        // Client errors (4xx)
        VALIDATION_ERROR(400, "Lỗi xác thực dữ liệu"),
        AUTHENTICATION_FAILED(401, "Xác thực thất bại"),
        AUTHORIZATION_FAILED(403, "Không có quyền truy cập"),
        RESOURCE_NOT_FOUND(404, "Không tìm thấy tài nguyên"),
        METHOD_NOT_ALLOWED(405, "Phương thức không được phép"),
        CONFLICT(409, "Xung đột dữ liệu"),

        // Server errors (5xx)
        INTERNAL_SERVER_ERROR(500, "Lỗi máy chủ nội bộ"),
        SERVICE_UNAVAILABLE(503, "Dịch vụ không khả dụng"),
        DATABASE_ERROR(500, "Lỗi cơ sở dữ liệu"),
        EXTERNAL_SERVICE_ERROR(502, "Lỗi dịch vụ bên ngoài");

        private final int httpStatus;
        private final String defaultMessage;

        ErrorCode(int httpStatus, String defaultMessage) {
            this.httpStatus = httpStatus;
            this.defaultMessage = defaultMessage;
        }

        public int getHttpStatus() {
            return httpStatus;
        }

        public String getDefaultMessage() {
            return defaultMessage;
        }
    }
}
