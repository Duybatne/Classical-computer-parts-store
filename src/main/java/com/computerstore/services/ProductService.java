package com.computerstore.services;

import java.util.List;

import com.computerstore.dao.ProductDAO;
import com.computerstore.models.Product;

public class ProductService {
	private ProductDAO productDAO = new ProductDAO();

	public List<Product> getAllProducts(int page, int limit) {
		return getAllProducts(page, limit, "newest");
	}

	public List<Product> getAllProducts(int page, int limit, String sortBy) {
		int offset = (page - 1) * limit;
		return productDAO.getAll(offset, limit, sortBy, "DESC");
	}

	public List<Product> getAllAdmin() {
		return productDAO.getAllAdmin();
	}

	public boolean updateStatus(int maSP, boolean status) {
		return productDAO.updateStatus(maSP, status);
	}

	public List<Product> getProductsByCategory(int categoryId, int page, int limit) {
		int offset = (page - 1) * limit;
		return productDAO.getByCategory(categoryId, offset, limit);
	}

	public List<Product> getProductsByCategoryName(String categoryName, int page, int limit) {
		return getProductsByCategoryName(categoryName, page, limit, "newest");
	}

	public List<Product> getProductsByCategoryName(String categoryName, int page, int limit, String sortBy) {
		int offset = (page - 1) * limit;
		return productDAO.getByCategoryName(categoryName, offset, limit);
	}

	public List<Product> searchProducts(String keyword, int page, int limit) {
		return searchProducts(keyword, page, limit, "newest");
	}

	public List<Product> searchProducts(String keyword, int page, int limit, String sortBy) {
		int offset = (page - 1) * limit;
		return productDAO.search(keyword, offset, limit);
	}

	public Product getProductDetail(int maSP) {
		return productDAO.getById(maSP);
	}

	public int getTotalProducts() {
		return productDAO.countAll();
	}

	public int getTotalProductsByCategoryName(String categoryName) {
		return productDAO.countByCategoryName(categoryName);
	}

	public int getTotalSearchResults(String keyword) {
		return productDAO.countSearch(keyword);
	}

	public int getTotalPages(int limit) {
		return (int) Math.ceil((double) getTotalProducts() / limit);
	}

	public int getTotalPagesByCategory(String categoryName, int limit) {
		return (int) Math.ceil((double) getTotalProductsByCategoryName(categoryName) / limit);
	}

	public int getTotalSearchPages(String keyword, int limit) {
		return (int) Math.ceil((double) getTotalSearchResults(keyword) / limit);
	}
}
