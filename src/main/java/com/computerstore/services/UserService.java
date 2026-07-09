package com.computerstore.services;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.computerstore.dao.UserDAO;
import com.computerstore.models.User;

public class UserService {
	private UserDAO userDAO = new UserDAO();

	public User authenticate(String username, String password) {
		User user = userDAO.getByUsername(username);
		if (user != null && BCrypt.checkpw(password, user.getMatKhauHash())) {
			userDAO.updateLastLogin(user.getMaTK());
			return user;
		}
		return null;
	}

	public User authenticateAdmin(String username, String password) {
		User user = userDAO.getByAdminUsername(username);
		if (user != null && BCrypt.checkpw(password, user.getMatKhauHash())) {
			userDAO.updateLastLogin(user.getMaTK());
			return user;
		}
		return null;
	}

	public User getByEmail(String email) {
		return userDAO.getByEmail(email);
	}

	public User getById(int maTK) {
		return userDAO.getById(maTK);
	}

	public boolean registerCustomer(String username, String password, String fullname, String email, String phone,
			String address) {
		if (userDAO.getByUsername(username) != null)
			return false;
		String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
		User u = new User(0, username, hashed, "KHACH_HANG", fullname, email, phone, address, null);
		return userDAO.insertCustomer(u);
	}

	public boolean updateCustomerProfile(User user) {
		return userDAO.updateCustomerProfile(user);
	}

	public boolean isAccountDisabled(String username) {
		return userDAO.isAccountDisabled(username);
	}

	public boolean updatePassword(int maTK, String hashedPassword) {
		return userDAO.updatePassword(maTK, hashedPassword);
	}

	public boolean createAdminUser(String username, String password, String fullname, String email) {
		if (userDAO.getByUsername(username) != null)
			return false;
		String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
		User u = new User(0, username, hashed, "QUAN_TRI_VIEN", fullname, email, null, null, null);
		return userDAO.insertAdmin(u);
	}

	public List<User> getAllAccounts(String q, String role) {
		return userDAO.getAllAccounts(q, role);
	}

	public boolean updateAccountStatus(int maTK, int status) {
		return userDAO.updateAccountStatus(maTK, status);
	}

	public boolean softDeleteAccount(int maTK) {
		return userDAO.softDelete(maTK);
	}

	public boolean hardDeleteAccount(int maTK) {
		return userDAO.hardDelete(maTK);
	}

	public boolean upgradeToAdmin(int maTK, String fullname, String email) {
		return userDAO.upgradeToAdmin(maTK, fullname, email);
	}
}
