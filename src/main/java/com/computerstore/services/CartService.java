package com.computerstore.services;

import java.util.List;

import com.computerstore.dao.CartDAO;
import com.computerstore.dao.ProductDAO;
import com.computerstore.models.CartItem;
import com.computerstore.models.Product;

public class CartService {
	private CartDAO cartDAO = new CartDAO();
	private ProductDAO productDAO = new ProductDAO();

	public int getOrCreateCart(int maKH) {
		int cartId = cartDAO.getCartIdByCustomerId(maKH);
		if (cartId == -1) {
			cartId = cartDAO.createCart(maKH);
		}
		return cartId;
	}

	public List<CartItem> getCartItems(int maKH) {
		int cartId = getOrCreateCart(maKH);
		List<CartItem> items = cartDAO.getItems(cartId);
		PromotionService promotionService = new PromotionService();
		if (items != null) {
			for (CartItem item : items) {
				java.math.BigDecimal discounted = promotionService.getDiscountedPrice(item.getMaSP());
				if (discounted.compareTo(item.getGiaBan()) < 0) {
					item.setGiaBan(discounted);
				}
			}
		}
		return items;
	}

	public boolean addToCart(int maKH, int maSP, int soLuong) throws Exception {
		int cartId = getOrCreateCart(maKH);
		int currentQty = cartDAO.getQuantityInCart(cartId, maSP);
		Product p = productDAO.getById(maSP);
		if (p == null)
			throw new Exception("Sản phẩm không tồn tại");
		if (currentQty + soLuong > p.getSoLuongTon()) {
			throw new Exception("Vượt quá số lượng tồn kho (" + p.getSoLuongTon() + " sản phẩm)");
		}
		return cartDAO.addItem(cartId, maSP, soLuong);
	}

	public boolean removeItem(int maKH, int maSP) {
		int cartId = cartDAO.getCartIdByCustomerId(maKH);
		if (cartId != -1) {
			return cartDAO.removeItem(cartId, maSP);
		}
		return false;
	}

	public boolean updateQuantity(int maKH, int maSP, int soLuong) throws Exception {
		int cartId = cartDAO.getCartIdByCustomerId(maKH);
		if (cartId != -1) {
			Product p = productDAO.getById(maSP);
			if (p == null)
				throw new Exception("Sản phẩm không tồn tại");
			if (soLuong > p.getSoLuongTon()) {
				throw new Exception("Vượt quá số lượng tồn kho (" + p.getSoLuongTon() + " sản phẩm)");
			}
			return cartDAO.updateItem(cartId, maSP, soLuong);
		}
		return false;
	}

	public boolean clearCart(int maKH) {
		int cartId = cartDAO.getCartIdByCustomerId(maKH);
		if (cartId != -1) {
			return cartDAO.clearCart(cartId);
		}
		return false;
	}
}
