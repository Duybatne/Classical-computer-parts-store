package com.computerstore.services;

import java.util.List;

import com.computerstore.dao.OrderDAO;
import com.computerstore.dao.ReviewDAO;
import com.computerstore.models.Review;

public class ReviewService {
	private ReviewDAO reviewDAO = new ReviewDAO();
	private OrderDAO orderDAO = new OrderDAO();

	public List<Review> getApprovedReviews(int maSP) {
		return reviewDAO.getByProductId(maSP);
	}

	public boolean submitReview(int maKH, int maSP, int rating, String comment) throws Exception {
		if (!orderDAO.hasPurchasedProduct(maKH, maSP)) {
			throw new Exception("Bạn cần mua sản phẩm này và đơn hàng đã giao thành công trước khi có thể đánh giá!");
		}

		Review r = new Review();
		r.setMaKH(maKH);
		r.setMaSP(maSP);
		r.setSoSao(rating);
		r.setNoiDung(comment);
		return reviewDAO.insert(r);
	}
}
