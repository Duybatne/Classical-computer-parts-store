package com.computerstore;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import com.computerstore.utils.ValidationUtil;

/**
 * Unit tests for ValidationUtil utility class.
 */
class ValidationUtilTest {

    // ── Email Validation ──
    @ParameterizedTest
    @ValueSource(strings = {
            "user@example.com",
            "test.user@domain.co",
            "user+tag@example.org",
            "user_name@domain.com",
            "a@b.cd"
    })
    void testValidEmails(String email) {
        assertTrue(ValidationUtil.isValidEmail(email), email + " should be valid");
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "",
            "not-an-email",
            "@example.com",
            "user@",
            "user@.com",
            "user@domain",
            "user domain.com"
    })
    void testInvalidEmails(String email) {
        assertFalse(ValidationUtil.isValidEmail(email), email + " should be invalid");
    }

    // ── Phone Validation ──
    @ParameterizedTest
    @CsvSource({
            "0912345678, true",
            "+84912345678, true",
            "0987654321, true",
            "0356789123, true",
            "0791234567, true",
            "0891234567, true",
            "0123456789, false",
            "091234567, false",
            "09123456789, false",
            "1234567890, false",
            "'' , false"
    })
    void testPhoneValidation(String phone, boolean expected) {
        String testPhone = phone.equals("''") ? "" : phone;
        assertEquals(expected, ValidationUtil.isValidPhone(testPhone),
                "Phone " + phone + " should be " + (expected ? "valid" : "invalid"));
    }

    // ── Username Validation ──
    @ParameterizedTest
    @ValueSource(strings = {
            "user123",
            "admin_user",
            "john_doe",
            "abc",
            "aaaaaaaaaaaaaaaaaaaa"
    })
    void testValidUsernames(String username) {
        assertTrue(ValidationUtil.isValidUsername(username), username + " should be valid");
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "",
            "ab",
            "aaaaaaaaaaaaaaaaaaaaa",
            "user name",
            "user-name",
            "user.name"
    })
    void testInvalidUsernames(String username) {
        assertFalse(ValidationUtil.isValidUsername(username), username + " should be invalid");
    }

    // ── Password Validation ──
    @ParameterizedTest
    @ValueSource(strings = {
            "Password1",
            "MyPassword123",
            "Abcdefg1",
            "Test1234",
            "Long_Password1"
    })
    void testValidPasswords(String password) {
        assertTrue(ValidationUtil.isValidPassword(password), password + " should be valid");
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "",
            "short1A",
            "nouppercase1",
            "NOLOWERCASE1",
            "NoDigitABC",
            "12345678",
            "lowercase1"
    })
    void testInvalidPasswords(String password) {
        assertFalse(ValidationUtil.isValidPassword(password), password + " should be invalid");
    }

    // ── Product ID Validation ──
    @ParameterizedTest
    @CsvSource({
            "1, true",
            "100, true",
            "99999, true",
            "0, false",
            "-1, false",
            "'', false",
            "abc, false"
    })
    void testProductIdValidation(String id, boolean expected) {
        assertEquals(expected, ValidationUtil.isValidProductId(id),
                "Product ID " + id + " should be " + (expected ? "valid" : "invalid"));
    }

    // ── Quantity Validation ──
    @ParameterizedTest
    @CsvSource({
            "1, true",
            "100, true",
            "999, true",
            "0, false",
            "1000, false",
            "'', false",
            "-1, false",
            "abc, false"
    })
    void testQuantityValidation(String qty, boolean expected) {
        assertEquals(expected, ValidationUtil.isValidQuantity(qty),
                "Quantity " + qty + " should be " + (expected ? "valid" : "invalid"));
    }

    // ── Sanitize Input ──
    @Test
    void testSanitizeRemovesScriptTags() {
        String input = "<script>alert('XSS')</script>Hello";
        String result = ValidationUtil.sanitize(input);
        assertFalse(result.contains("<script>"), "Script tags should be removed");
        assertEquals("Hello", result);
    }

    @Test
    void testSanitizeRemovesHtmlTags() {
        String input = "<p>Hello <b>World</b></p>";
        String result = ValidationUtil.sanitize(input);
        assertFalse(result.contains("<"), "HTML tags should be removed");
        assertEquals("Hello World", result);
    }

    @Test
    void testSanitizeRemovesXssPatterns() {
        String input = "javascript:alert(1)";
        String result = ValidationUtil.sanitize(input);
        assertFalse(result.contains("javascript:"), "XSS patterns should be removed");
    }

    @Test
    void testSanitizeTrimsWhitespace() {
        String input = "  hello world  ";
        String result = ValidationUtil.sanitize(input);
        assertEquals("hello world", result);
    }

    @Test
    void testSanitizeNullReturnsNull() {
        assertNull(ValidationUtil.sanitize(null));
    }

    // ── Search Keyword Validation ──
    @Test
    void testValidateSearchKeywordTrimsAndSizes() {
        String longInput = "a".repeat(150);
        String result = ValidationUtil.validateSearchKeyword(longInput);
        assertNotNull(result);
        assertTrue(result.length() <= 100, "Search keyword should be truncated to 100 chars");
    }

    @Test
    void testValidateSearchKeywordRemovesSqlInjection() {
        String input = "test; DROP TABLE users; --";
        String result = ValidationUtil.validateSearchKeyword(input);
        assertNotNull(result);
        assertFalse(result.contains(";"), "SQL injection patterns should be removed");
    }

    @Test
    void testValidateSearchKeywordNullReturnsNull() {
        assertNull(ValidationUtil.validateSearchKeyword(null));
    }

    // ── Redirect URL Validation ──
    @Test
    void testValidRelativeRedirectUrl() {
        assertTrue(ValidationUtil.isValidRedirectUrl("/home", null));
        assertTrue(ValidationUtil.isValidRedirectUrl("/products?page=1", null));
    }

    @Test
    void testInvalidRedirectUrl() {
        assertFalse(ValidationUtil.isValidRedirectUrl("http://evil.com", null));
        assertFalse(ValidationUtil.isValidRedirectUrl("//evil.com", null));
        assertFalse(ValidationUtil.isValidRedirectUrl("", null));
        assertFalse(ValidationUtil.isValidRedirectUrl(null, null));
    }

    // ── Page Number Validation ──
    @Test
    void testValidatePageNumber() {
        assertEquals(1, ValidationUtil.validatePageNumber(null, 1));
        assertEquals(1, ValidationUtil.validatePageNumber("", 1));
        assertEquals(1, ValidationUtil.validatePageNumber("1", 1));
        assertEquals(5, ValidationUtil.validatePageNumber("5", 1));
        assertEquals(1, ValidationUtil.validatePageNumber("0", 1));
        assertEquals(1, ValidationUtil.validatePageNumber("-1", 1));
        assertEquals(1, ValidationUtil.validatePageNumber("abc", 1));
    }

    // ── Limit Validation ──
    @Test
    void testValidateLimit() {
        assertEquals(10, ValidationUtil.validateLimit(null, 10, 100));
        assertEquals(10, ValidationUtil.validateLimit("", 10, 100));
        assertEquals(10, ValidationUtil.validateLimit("10", 10, 100));
        assertEquals(100, ValidationUtil.validateLimit("200", 10, 100));
        assertEquals(1, ValidationUtil.validateLimit("0", 10, 100));
        assertEquals(10, ValidationUtil.validateLimit("abc", 10, 100));
    }

    // ── Price Validation ──
    @Test
    void testValidPrice() {
        assertTrue(ValidationUtil.isValidPrice("0"));
        assertTrue(ValidationUtil.isValidPrice("100000"));
        assertTrue(ValidationUtil.isValidPrice("999999999"));
    }

    @Test
    void testInvalidPrice() {
        assertFalse(ValidationUtil.isValidPrice(""));
        assertFalse(ValidationUtil.isValidPrice("-1"));
        assertFalse(ValidationUtil.isValidPrice("abc"));
    }

    // ── SQL Injection Detection ──
    @Test
    void testContainsSqlInjection() {
        assertTrue(ValidationUtil.containsSqlInjection("' OR 1=1 --"));
        assertTrue(ValidationUtil.containsSqlInjection("SELECT * FROM users"));
        assertFalse(ValidationUtil.containsSqlInjection("Hello World"));
        assertFalse(ValidationUtil.containsSqlInjection(null));
    }

    // ── XSS Detection ──
    @Test
    void testContainsXss() {
        assertTrue(ValidationUtil.containsXss("javascript:alert(1)"));
        assertTrue(ValidationUtil.containsXss("onclick=alert(1)"));
        assertFalse(ValidationUtil.containsXss("Hello World"));
        assertFalse(ValidationUtil.containsXss(null));
    }
}
