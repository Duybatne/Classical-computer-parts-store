package com.computerstore.services;

import java.math.BigDecimal;
import java.util.List;

import com.computerstore.dao.ProductDAO;
import com.computerstore.dao.PromotionDAO;
import com.computerstore.dao.PromotionProductDAO;
import java.util.HashSet;
import java.util.Set;

import com.computerstore.models.CartItem;
import com.computerstore.models.Product;
import com.computerstore.models.Promotion;

public class PromotionService {
	private PromotionDAO promotionDAO = new PromotionDAO();
	private PromotionProductDAO promotionProductDAO = new PromotionProductDAO();
	private ProductDAO productDAO = new ProductDAO();

	public List<Promotion> getActivePromotions() {
		return promotionDAO.getActivePromotions();
	}

	public List<Promotion> getAll() {
		return promotionDAO.getAll();
	}

	public boolean updateStatus(int maKM, boolean status) {
		return promotionDAO.updateStatus(maKM, status);
	}

	public BigDecimal applyVoucher(int maKM, BigDecimal totalAmount) {
		// Legacy: apply voucher discount to whole amount
		return applyVoucherToEligibleSubtotal(maKM, totalAmount, null);
	}

	/**
	 * Apply voucher discount to only eligible items.
	 *
	 * Rule: eligible items are those product IDs returned by
	 * PromotionProductDAO.getProductsByPromotion(maKM).
	 *
	 * @param maKM  promotion id
	 * @param items cart items
	 */
	public BigDecimal applyVoucherToCart(int maKM, List<CartItem> items) {
		Promotion p = promotionDAO.getById(maKM);
		if (p == null || !p.isTrangThai()) {
			return BigDecimal.ZERO;
		}

		long now = System.currentTimeMillis();
		if (p.getNgayBatDau().getTime() > now || p.getNgayKetThuc().getTime() < now) {
			return BigDecimal.ZERO;
		}

		Set<Integer> eligibleProductIds = new HashSet<>(promotionProductDAO.getProductsByPromotion(maKM));
		BigDecimal eligibleSubtotal = BigDecimal.ZERO;
		if (items != null) {
			for (CartItem item : items) {
				if (item != null && eligibleProductIds.contains(item.getMaSP())) {
					eligibleSubtotal = eligibleSubtotal.add(item.getThanhTien());
				}
			}
		}

		return applyVoucherDiscountFromPromotion(p, eligibleSubtotal);
	}

	private BigDecimal applyVoucherToEligibleSubtotal(int maKM, BigDecimal totalAmount, Set<Integer> ignored) {
		Promotion p = promotionDAO.getById(maKM);
		if (p == null || !p.isTrangThai())
			return BigDecimal.ZERO;

		long now = System.currentTimeMillis();
		if (p.getNgayBatDau().getTime() > now || p.getNgayKetThuc().getTime() < now) {
			return BigDecimal.ZERO;
		}

		return applyVoucherDiscountFromPromotion(p, totalAmount);
	}

	private BigDecimal applyVoucherDiscountFromPromotion(Promotion p, BigDecimal eligibleSubtotal) {
		if (eligibleSubtotal == null) {
			eligibleSubtotal = BigDecimal.ZERO;
		}

		if ("PHAN_TRAM".equals(p.getLoaiGiam())) {
			BigDecimal discount = eligibleSubtotal.multiply(p.getGiaTriGiam()).divide(new BigDecimal(100));
			return discount.max(BigDecimal.ZERO);
		} else if ("SO_TIEN".equals(p.getLoaiGiam())) {
			return p.getGiaTriGiam().min(eligibleSubtotal).max(BigDecimal.ZERO);
		}
		return BigDecimal.ZERO;
	}

	public BigDecimal getDiscountedPrice(int maSP) {
		Product p = productDAO.getById(maSP);
		if (p == null)
			return BigDecimal.ZERO;

		List<Integer> promoIds = promotionProductDAO.getPromotionsByProduct(maSP);
		BigDecimal lowestPrice = p.getGiaBan();

		for (int promoId : promoIds) {
			Promotion promo = promotionDAO.getById(promoId);
			if (promo != null && promo.isTrangThai()) {
				long now = System.currentTimeMillis();
				if (promo.getNgayBatDau().getTime() <= now && promo.getNgayKetThuc().getTime() >= now) {
					BigDecimal currentPrice = p.getGiaBan();
					BigDecimal discount = BigDecimal.ZERO;
					if ("PHAN_TRAM".equals(promo.getLoaiGiam())) {
						discount = currentPrice.multiply(promo.getGiaTriGiam()).divide(new BigDecimal(100));
					} else if ("SO_TIEN".equals(promo.getLoaiGiam())) {
						discount = promo.getGiaTriGiam();
					}
					BigDecimal newPrice = currentPrice.subtract(discount);
					if (newPrice.compareTo(lowestPrice) < 0) {
						lowestPrice = newPrice.max(BigDecimal.ZERO);
					}
				}
			}
		}
		return lowestPrice;
	}

	public void populateDiscountedPrices(List<Product> products) {
		if (products == null)
			return;
		for (Product p : products) {
			if (p != null) {
				try {
					p.setDiscountedPrice(getDiscountedPrice(p.getMaSP()));
				} catch (Exception e) {
					// Ignore
				}
			}
		}
	}
}
