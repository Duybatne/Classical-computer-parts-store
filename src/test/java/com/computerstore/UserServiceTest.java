package com.computerstore;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mindrot.jbcrypt.BCrypt;

import com.computerstore.dao.UserDAO;
import com.computerstore.models.User;
import com.computerstore.services.UserService;

/**
 * Unit tests for UserService using Mockito.
 */
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserDAO userDAO;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService();
        setField(userService, "userDAO", userDAO);
    }

    private void setField(Object target, String fieldName, Object value) {
        try {
            var field = target.getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(target, value);
        } catch (Exception e) {
            throw new RuntimeException("Failed to set field " + fieldName, e);
        }
    }

    private User createUser(int maTK, String username, String password, String role, String name, String email) {
        User user = new User();
        user.setMaTK(maTK);
        user.setTenDangNhap(username);
        user.setMatKhauHash(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setVaiTro(role);
        user.setHoTen(name);
        user.setEmail(email);
        user.setSoDienThoai("0912345678");
        user.setDiaChi("Test Address");
        return user;
    }

    // ── authenticate ── Success
    @Test
    void testAuthenticateSuccess() {
        String password = "Password123";
        User mockUser = createUser(1, "testuser", password, "KHACH_HANG", "Test User", "test@example.com");
        when(userDAO.getByUsername("testuser")).thenReturn(mockUser);

        User result = userService.authenticate("testuser", password);
        assertNotNull(result, "Should authenticate successfully");
        assertEquals("testuser", result.getTenDangNhap());
        verify(userDAO).updateLastLogin(1);
    }

    // ── authenticate ── Wrong password
    @Test
    void testAuthenticateWrongPassword() {
        User mockUser = createUser(1, "testuser", "Password123", "KHACH_HANG", "Test User", "test@example.com");
        when(userDAO.getByUsername("testuser")).thenReturn(mockUser);

        User result = userService.authenticate("testuser", "WrongPassword1");
        assertNull(result, "Should return null for wrong password");
        verify(userDAO, never()).updateLastLogin(anyInt());
    }

    // ── authenticate ── User not found
    @Test
    void testAuthenticateUserNotFound() {
        when(userDAO.getByUsername("nonexistent")).thenReturn(null);

        User result = userService.authenticate("nonexistent", "Password123");
        assertNull(result, "Should return null for non-existent user");
        verify(userDAO, never()).updateLastLogin(anyInt());
    }

    // ── authenticateAdmin ── Success
    @Test
    void testAuthenticateAdminSuccess() {
        String password = "AdminPass1";
        User mockAdmin = createUser(2, "admin", password, "QUAN_TRI_VIEN", "Admin", "admin@example.com");
        when(userDAO.getByAdminUsername("admin")).thenReturn(mockAdmin);

        User result = userService.authenticateAdmin("admin", password);
        assertNotNull(result, "Should authenticate admin successfully");
        assertEquals("QUAN_TRI_VIEN", result.getVaiTro());
        verify(userDAO).updateLastLogin(2);
    }

    // ── authenticateAdmin ── Wrong password
    @Test
    void testAuthenticateAdminWrongPassword() {
        User mockAdmin = createUser(2, "admin", "AdminPass1", "QUAN_TRI_VIEN", "Admin", "admin@example.com");
        when(userDAO.getByAdminUsername("admin")).thenReturn(mockAdmin);

        User result = userService.authenticateAdmin("admin", "WrongPass1");
        assertNull(result, "Should return null for wrong admin password");
        verify(userDAO, never()).updateLastLogin(anyInt());
    }

    // ── registerCustomer ── Success
    @Test
    void testRegisterCustomerSuccess() {
        when(userDAO.getByUsername("newuser")).thenReturn(null);
        when(userDAO.insertCustomer(any(User.class))).thenReturn(true);

        boolean result = userService.registerCustomer("newuser", "Password123", "New User",
                "new@example.com", "0912345678", "Address");
        assertTrue(result, "Registration should succeed");
        verify(userDAO).insertCustomer(argThat(user -> "newuser".equals(user.getTenDangNhap()) &&
                "KHACH_HANG".equals(user.getVaiTro()) &&
                "New User".equals(user.getHoTen())));
    }

    // ── registerCustomer ── Username exists
    @Test
    void testRegisterCustomerUsernameExists() {
        User existingUser = createUser(1, "existing", "Password123", "KHACH_HANG", "Existing", "existing@example.com");
        when(userDAO.getByUsername("existing")).thenReturn(existingUser);

        boolean result = userService.registerCustomer("existing", "Password123", "Test",
                "test@example.com", "0912345678", "");
        assertFalse(result, "Registration should fail when username exists");
        verify(userDAO, never()).insertCustomer(any(User.class));
    }

    // ── registerCustomer ── Password is hashed
    @Test
    void testRegisterCustomerPasswordIsHashed() {
        when(userDAO.getByUsername("newuser")).thenReturn(null);
        when(userDAO.insertCustomer(any(User.class))).thenReturn(true);

        boolean result = userService.registerCustomer("newuser", "MyPassword123", "New User",
                "new@example.com", "0912345678", "Address");
        assertTrue(result);
        verify(userDAO).insertCustomer(argThat(user -> {
            // Verify the stored hash matches the password
            return BCrypt.checkpw("MyPassword123", user.getMatKhauHash());
        }));
    }

    // ── getByEmail ──
    @Test
    void testGetByEmail() {
        User mockUser = createUser(1, "testuser", "Password123", "KHACH_HANG", "Test User", "test@example.com");
        when(userDAO.getByEmail("test@example.com")).thenReturn(mockUser);

        User result = userService.getByEmail("test@example.com");
        assertNotNull(result);
        assertEquals("test@example.com", result.getEmail());
    }

    // ── getByEmail ── Not found
    @Test
    void testGetByEmailNotFound() {
        when(userDAO.getByEmail("notfound@example.com")).thenReturn(null);

        User result = userService.getByEmail("notfound@example.com");
        assertNull(result);
    }

    // ── updatePassword ──
    @Test
    void testUpdatePassword() {
        when(userDAO.updatePassword(eq(1), anyString())).thenReturn(true);

        boolean result = userService.updatePassword(1, BCrypt.hashpw("NewPass123", BCrypt.gensalt()));
        assertTrue(result);
        verify(userDAO).updatePassword(eq(1), anyString());
    }

    // ── updateCustomerProfile ──
    @Test
    void testUpdateCustomerProfile() {
        User user = createUser(1, "testuser", "Password123", "KHACH_HANG", "Updated Name", "updated@example.com");
        when(userDAO.updateCustomerProfile(user)).thenReturn(true);

        boolean result = userService.updateCustomerProfile(user);
        assertTrue(result);
        verify(userDAO).updateCustomerProfile(user);
    }
}
