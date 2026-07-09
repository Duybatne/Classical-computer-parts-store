package com.computerstore.utils;

import java.util.regex.Pattern;

/**
 * Input validation and sanitization utility
 */
public class ValidationUtil {

	// Email pattern (RFC 5322 compliant)
	private static final Pattern EMAIL_PATTERN = Pattern.compile(
			"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");

	// Vietnamese phone pattern
	private static final Pattern PHONE_PATTERN = Pattern.compile(
			"^(0|\\+84)[3|5|7|8|9][0-9]{8}$");

	// Username pattern (3-20 alphanumeric characters and underscores)
	private static final Pattern USERNAME_PATTERN = Pattern.compile(
			"^[a-zA-Z0-9_]{3,20}$");

	// Password pattern (min 8 chars, at least one uppercase, one lowercase, one
	// digit)
	private static final Pattern PASSWORD_PATTERN = Pattern.compile(
			"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");

	// HTML tag pattern
	private static final Pattern HTML_PATTERN = Pattern.compile(
			"<[^>]*>");

	// Script pattern
	private static final Pattern SCRIPT_PATTERN = Pattern.compile(
			"<script.*?>.*?</script>",
			Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

	// SQL injection pattern
	private static final Pattern SQL_INJECTION_PATTERN = Pattern.compile(
			"('|\")?\\s*(or|and|select|insert|update|delete|drop|create|alter|exec|execute|union|into|from)\\s+('|\")?",
			Pattern.CASE_INSENSITIVE);

	// XSS pattern
	private static final Pattern XSS_PATTERN = Pattern.compile(
			"(javascript:|on\\w+\\s*=|data:text/html)",
			Pattern.CASE_INSENSITIVE);

	/**
	 * Validate email format
	 */
	public static boolean isValidEmail(String email) {
		if (email == null || email.isEmpty()) {
			return false;
		}
		return EMAIL_PATTERN.matcher(email).matches();
	}

	/**
	 * Validate Vietnamese phone number
	 */
	public static boolean isValidPhone(String phone) {
		if (phone == null || phone.isEmpty()) {
			return false;
		}
		return PHONE_PATTERN.matcher(phone).matches();
	}

	/**
	 * Validate username format
	 */
	public static boolean isValidUsername(String username) {
		if (username == null || username.isEmpty()) {
			return false;
		}
		return USERNAME_PATTERN.matcher(username).matches();
	}

	/**
	 * Validate password strength
	 * Minimum 8 characters, at least one uppercase, one lowercase, one digit
	 */
	public static boolean isValidPassword(String password) {
		if (password == null || password.length() < 8) {
			return false;
		}
		return PASSWORD_PATTERN.matcher(password).matches();
	}

	/**
	 * Validate product ID
	 */
	public static boolean isValidProductId(String id) {
		if (id == null || id.isEmpty()) {
			return false;
		}
		try {
			int productId = Integer.parseInt(id);
			return productId > 0;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/**
	 * Validate quantity
	 */
	public static boolean isValidQuantity(String quantity) {
		if (quantity == null || quantity.isEmpty()) {
			return false;
		}
		try {
			int qty = Integer.parseInt(quantity);
			return qty > 0 && qty <= 999;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/**
	 * Sanitize input string
	 * Removes HTML tags, script tags, and potential SQL injection patterns
	 */
	public static String sanitize(String input) {
		return sanitizeInput(input);
	}

	/**
	 * Sanitize input string
	 * Removes HTML tags, script tags, and potential SQL injection patterns
	 */
	public static String sanitizeInput(String input) {
		if (input == null) {
			return null;
		}

		// Trim whitespace
		String sanitized = input.trim();

		// Remove script tags
		sanitized = SCRIPT_PATTERN.matcher(sanitized).replaceAll("");

		// Remove HTML tags
		sanitized = HTML_PATTERN.matcher(sanitized).replaceAll("");

		// Remove potential SQL injection patterns
		sanitized = SQL_INJECTION_PATTERN.matcher(sanitized).replaceAll("");

		// Remove potential XSS patterns
		sanitized = XSS_PATTERN.matcher(sanitized).replaceAll("");

		return sanitized;
	}

	/**
	 * Check if input contains SQL injection patterns
	 */
	public static boolean containsSqlInjection(String input) {
		if (input == null) {
			return false;
		}
		return SQL_INJECTION_PATTERN.matcher(input).find();
	}

	/**
	 * Check if input contains XSS patterns
	 */
	public static boolean containsXss(String input) {
		if (input == null) {
			return false;
		}
		return XSS_PATTERN.matcher(input).find();
	}

	/**
	 * Escape HTML special characters to prevent XSS attacks
	 */
	public static String escapeHtml(String input) {
		if (input == null) {
			return null;
		}
		StringBuilder escaped = new StringBuilder(input.length());
		for (int i = 0; i < input.length(); i++) {
			char c = input.charAt(i);
			switch (c) {
				case '&':
					escaped.append("&").append("amp;");
					break;
				case '<':
					escaped.append("&").append("lt;");
					break;
				case '>':
					escaped.append("&").append("gt;");
					break;
				case '"':
					escaped.append("&").append("#34;");
					break;
				case '\'':
					escaped.append("&").append("#39;");
					break;
				case '/':
					escaped.append("&").append("#47;");
					break;
				default:
					escaped.append(c);
					break;
			}
		}
		return escaped.toString();
	}

	/**
	 * Unescape HTML entities back to original characters
	 */
	public static String unescapeHtml(String input) {
		if (input == null) {
			return null;
		}
		String result = input;
		result = result.replace("&", "&");
		result = result.replace("<", "<");
		result = result.replace(">", ">");
		result = result.replace("&#34;", "\"");
		result = result.replace("&#39;", "'");
		result = result.replace("&#47;", "/");
		result = result.replace("&#x27;", "'");
		result = result.replace("&#x2F;", "/");
		return result;
	}

	/**
	 * Validate and sanitize search keyword
	 */
	public static String validateSearchKeyword(String keyword) {
		if (keyword == null || keyword.trim().isEmpty()) {
			return null;
		}

		String sanitized = keyword.trim();

		// Limit length
		if (sanitized.length() > 100) {
			sanitized = sanitized.substring(0, 100);
		}

		// Remove special characters that could be used for SQL injection
		sanitized = sanitized.replaceAll("[;\\-\\-]", "");

		return sanitized;
	}

	/**
	 * Validate page number for pagination
	 */
	public static int validatePageNumber(String pageParam, int defaultValue) {
		if (pageParam == null || pageParam.isEmpty()) {
			return defaultValue;
		}
		try {
			int page = Integer.parseInt(pageParam);
			return Math.max(1, page);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	/**
	 * Validate limit for pagination
	 */
	public static int validateLimit(String limitParam, int defaultValue, int maxLimit) {
		if (limitParam == null || limitParam.isEmpty()) {
			return defaultValue;
		}
		try {
			int limit = Integer.parseInt(limitParam);
			return Math.min(Math.max(1, limit), maxLimit);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	/**
	 * Validate price range
	 */
	public static boolean isValidPrice(String price) {
		if (price == null || price.isEmpty()) {
			return false;
		}
		try {
			double p = Double.parseDouble(price);
			return p >= 0 && p <= 1_000_000_000; // Max 1 billion
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/**
	 * Validate redirect URL (prevent open redirect)
	 */
	public static boolean isValidRedirectUrl(String url, String baseUrl) {
		if (url == null || url.isEmpty()) {
			return false;
		}

		// Only allow relative URLs or URLs that start with baseUrl
		if (url.startsWith("/") && !url.startsWith("//")) {
			return true;
		}

		if (baseUrl != null && url.startsWith(baseUrl)) {
			return true;
		}

		return false;
	}

	/**
	 * Generate validation error message
	 */
	public static String getValidationError(String field, String value) {
		if (value == null || value.isEmpty()) {
			return field + " is required";
		}

		switch (field.toLowerCase()) {
			case "email":
				return "Invalid email format";
			case "phone":
				return "Invalid phone number format";
			case "username":
				return "Username must be 3-20 characters (letters, numbers, underscores)";
			case "password":
				return "Password must be at least 8 characters with uppercase, lowercase, and digit";
			default:
				return "Invalid " + field;
		}
	}
}
