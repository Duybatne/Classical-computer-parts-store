package com.computerstore.controllers.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.computerstore.dao.CategoryDAO;
import com.computerstore.dao.ComponentDetailDAO;
import com.computerstore.dao.ProductDAO;
import com.computerstore.exceptions.AppException;
import com.computerstore.exceptions.AppException.ErrorCode;
import com.computerstore.models.CaseDetail;
import com.computerstore.models.Category;
import com.computerstore.models.CoolerDetail;
import com.computerstore.models.CpuDetail;
import com.computerstore.models.MainboardDetail;
import com.computerstore.models.Product;
import com.computerstore.models.PsuDetail;
import com.computerstore.models.RamDetail;
import com.computerstore.models.StorageDetail;
import com.computerstore.models.User;
import com.computerstore.models.VgaDetail;
import com.computerstore.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 5, // 5MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(urlPatterns = { "/admin/products", "/admin/products/save", "/admin/products/delete",
		"/admin/products/toggle", "/admin/products/techspec" })
public class AdminProductServlet extends HttpServlet {

	private final ProductDAO productDAO = new ProductDAO();
	private final CategoryDAO categoryDAO = new CategoryDAO();
	private final ComponentDetailDAO detailDAO = new ComponentDetailDAO();

	private static final int PAGE_SIZE = 15;

	// Image upload directory relative to webapp
	private static final String IMAGE_UPLOAD_DIR = "images/products";

	/*
	 * ========================================================= GET
	 * =========================================================
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String path = req.getServletPath();
		if ("/admin/products".equals(path)) {
			showList(req, resp);
		} else if ("/admin/products/techspec".equals(path)) {
			getTechSpec(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	/*
	 * ========================================================= POST
	 * =========================================================
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!isAdmin(req)) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		req.setCharacterEncoding("UTF-8");
		String path = req.getServletPath();

		switch (path) {
			case "/admin/products/save":
				saveProduct(req, resp);
				break;
			case "/admin/products/delete":
				deleteProduct(req, resp);
				break;
			case "/admin/products/toggle":
				toggleProduct(req, resp);
				break;
			case "/admin/products/techspec":
				getTechSpec(req, resp);
				break;
			default:
				resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	/*
	 * ========================================================= HIỆN DANH SÁCH
	 * (Filter/Search/Pagination server-side)
	 * =========================================================
	 */
	private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// ── Read filter params ──
		String keyword = req.getParameter("keyword");
		String categoryStr = req.getParameter("category");
		String statusStr = req.getParameter("status");
		String stockStr = req.getParameter("stock");
		String sort = req.getParameter("sort");
		if (sort == null || sort.isBlank())
			sort = "newest";

		Integer categoryId = null;
		try {
			if (categoryStr != null && !categoryStr.isBlank()) {
				categoryId = Integer.parseInt(categoryStr);
			}
		} catch (NumberFormatException ignored) {
		}

		Boolean statusFilter = null;
		if ("1".equals(statusStr))
			statusFilter = true;
		else if ("0".equals(statusStr))
			statusFilter = false;

		// ── Pagination ──
		int page = 1;
		try {
			page = Integer.parseInt(req.getParameter("page"));
		} catch (Exception ignored) {
		}
		if (page < 1)
			page = 1;
		int offset = (page - 1) * PAGE_SIZE;

		// ── Build dynamic SQL ──
		List<Object> params = new ArrayList<>();
		StringBuilder where = new StringBuilder("WHERE 1=1 ");

		// Keyword search
		if (keyword != null && !keyword.isBlank()) {
			where.append(" AND (sp.TenSP LIKE ? OR sp.ThuongHieu LIKE ?)");
			String kw = "%" + keyword.trim() + "%";
			params.add(kw);
			params.add(kw);
		}

		// Category filter
		if (categoryId != null) {
			where.append(" AND sp.MaLoaiSP = ?");
			params.add(categoryId);
		}

		// Status filter
		if (statusFilter != null) {
			where.append(" AND sp.TrangThai = ?");
			params.add(statusFilter ? 1 : 0);
		}

		// Stock filter
		if ("low".equals(stockStr)) {
			where.append(" AND sp.SoLuongTon > 0 AND sp.SoLuongTon <= 5");
		} else if ("out".equals(stockStr)) {
			where.append(" AND sp.SoLuongTon <= 0");
		} else if ("ok".equals(stockStr)) {
			where.append(" AND sp.SoLuongTon > 5");
		}

		// ── Count total ──
		String countSql = "SELECT COUNT(*) FROM SAN_PHAM sp " + where;
		int total = executeCountQuery(countSql, params);

		int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
		if (page > totalPages && totalPages > 0) {
			page = totalPages;
			offset = (page - 1) * PAGE_SIZE;
		}

		// ── Fetch page data ──
		String orderBy = productDAO.buildOrderBy(sort, "DESC");
		String selectSql = "SELECT sp.*, lsp.TenLoaiSP, anh.DuongDanAnh AS AnhChinh "
				+ "FROM SAN_PHAM sp "
				+ "JOIN LOAI_SAN_PHAM lsp ON sp.MaLoaiSP = lsp.MaLoaiSP "
				+ "LEFT JOIN ANH_SAN_PHAM anh ON sp.MaSP = anh.MaSP AND anh.LaAnhDaiDien = 1 "
				+ where + " "
				+ orderBy
				+ " LIMIT ? OFFSET ?";

		List<Product> products = executeProductQuery(selectSql, params, PAGE_SIZE, offset);

		// ── Compute stats (from total count query for accuracy) ──
		long activeCount = executeCountQuery(
				"SELECT COUNT(*) FROM SAN_PHAM WHERE TrangThai = 1", null);
		long lowStockCount = executeCountQuery(
				"SELECT COUNT(*) FROM SAN_PHAM WHERE SoLuongTon > 0 AND SoLuongTon <= 5", null);
		long outStockCount = executeCountQuery(
				"SELECT COUNT(*) FROM SAN_PHAM WHERE SoLuongTon <= 0", null);

		// ── Message handling ──
		String msg = req.getParameter("msg");
		if ("added".equals(msg))
			req.setAttribute("successMessage", "✅ Thêm sản phẩm thành công!");
		else if ("updated".equals(msg))
			req.setAttribute("successMessage", "✅ Cập nhật sản phẩm thành công!");
		else if ("deleted".equals(msg))
			req.setAttribute("successMessage", "✅ Xóa sản phẩm thành công!");
		else if ("toggled".equals(msg))
			req.setAttribute("successMessage", "✅ Cập nhật trạng thái thành công!");
		else if ("error".equals(msg))
			req.setAttribute("errorMessage", "❌ Có lỗi xảy ra, vui lòng thử lại!");

		// ── Categories (for filter dropdown) ──
		List<Category> categories = categoryDAO.getAll();

		// ── Set attributes ──
		req.setAttribute("products", products);
		req.setAttribute("categories", categories);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPages", totalPages);
		req.setAttribute("totalProducts", total);
		req.setAttribute("activeProducts", activeCount);
		req.setAttribute("lowStockProducts", lowStockCount);
		req.setAttribute("outOfStockProducts", outStockCount);
		req.setAttribute("sort", sort);

		req.getRequestDispatcher("/jsp/admin/products.jsp").forward(req, resp);
	}

	/*
	 * ========================================================= LƯU SẢN PHẨM
	 * (thêm mới + sửa, có validate + upload ảnh)
	 * =========================================================
	 */
	private void saveProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			String maSPStr = req.getParameter("maSP");
			boolean isEdit = (maSPStr != null && !maSPStr.isBlank());

			// ── Validate ──
			String tenSP = req.getParameter("tenSP");
			if (tenSP == null || tenSP.isBlank()) {
				resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
				return;
			}

			int maLoaiSP;
			try {
				maLoaiSP = Integer.parseInt(req.getParameter("maLoaiSP"));
			} catch (Exception e) {
				resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
				return;
			}

			String thuongHieu = req.getParameter("thuongHieu");

			BigDecimal giaBan;
			try {
				giaBan = new BigDecimal(req.getParameter("giaBan"));
				if (giaBan.compareTo(BigDecimal.ZERO) < 0) {
					resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
					return;
				}
			} catch (Exception e) {
				resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
				return;
			}

			int soLuongTon = 0;
			try {
				soLuongTon = Integer.parseInt(req.getParameter("soLuongTon"));
				if (soLuongTon < 0)
					soLuongTon = 0;
			} catch (Exception ignored) {
			}

			int baoHanhThang = 0;
			try {
				baoHanhThang = Integer.parseInt(req.getParameter("baoHanhThang"));
				if (baoHanhThang < 0)
					baoHanhThang = 0;
			} catch (Exception ignored) {
			}

			String moTaNgan = req.getParameter("moTaNgan");
			String moTaChiTiet = req.getParameter("moTaChiTiet");
			boolean trangThai = "1".equals(req.getParameter("trangThai"));

			// ── Handle image ──
			String anhUrl = null;

			// Priority 1: File upload
			Part filePart = req.getPart("fileAnh");
			if (filePart != null && filePart.getSize() > 0) {
				String contentType = filePart.getContentType();
				boolean validMime = contentType != null && (
						contentType.startsWith("image/jpeg") ||
						contentType.startsWith("image/png") ||
						contentType.startsWith("image/gif") ||
						contentType.startsWith("image/webp")
				);
				if (!validMime) {
					resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
					return;
				}
				String fileName = extractFileName(filePart);
				if (fileName != null && !fileName.isBlank()) {
					// Generate unique filename
					String uniqueName = System.currentTimeMillis() + "_" + fileName;
					String uploadPath = getServletContext().getRealPath("") + IMAGE_UPLOAD_DIR;
					java.io.File uploadDir = new java.io.File(uploadPath);
					if (!uploadDir.exists())
						uploadDir.mkdirs();

					filePart.write(uploadPath + java.io.File.separator + uniqueName);
					anhUrl = "/" + IMAGE_UPLOAD_DIR + "/" + uniqueName;
				}
			}

			// Priority 2: URL from text input
			if (anhUrl == null || anhUrl.isBlank()) {
				anhUrl = req.getParameter("anhUrl");
				if (anhUrl != null && anhUrl.isBlank())
					anhUrl = null;
			}

			// ── Build product object ──
			Product p = new Product();
			p.setTenSP(tenSP.trim());
			p.setMaLoaiSP(maLoaiSP);
			p.setThuongHieu(thuongHieu != null ? thuongHieu.trim() : null);
			p.setGiaBan(giaBan);
			p.setSoLuongTon(soLuongTon);
			p.setBaoHanhThang(baoHanhThang);
			p.setMoTaNgan(moTaNgan);
			p.setMoTaChiTiet(moTaChiTiet);
			p.setHienThi(trangThai);
			p.setAnhChinh(anhUrl);

			if (isEdit) {
				p.setMaSP(Integer.parseInt(maSPStr));
				productDAO.update(p);
				saveTechSpecs(req, p.getMaSP(), maLoaiSP);
				resp.sendRedirect(req.getContextPath() + "/admin/products?msg=updated");
			} else {
				int newId = productDAO.insert(p);
				saveTechSpecs(req, newId, maLoaiSP);
				resp.sendRedirect(req.getContextPath() + "/admin/products?msg=added");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
		}
	}

	/*
	 * ========================================================= XÓA SẢN PHẨM
	 * =========================================================
	 */
	private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			int maSP = Integer.parseInt(req.getParameter("maSP"));
			productDAO.delete(maSP);
			resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
		} catch (Exception e) {
			e.printStackTrace();
			resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
		}
	}

	/*
	 * ========================================================= TOGGLE TRẠNG THÁI
	 * =========================================================
	 */
	private void toggleProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			int maSP = Integer.parseInt(req.getParameter("maSP"));
			boolean status = "1".equals(req.getParameter("status"));
			productDAO.updateStatus(maSP, status);
			resp.sendRedirect(req.getContextPath() + "/admin/products?msg=toggled");
		} catch (Exception e) {
			e.printStackTrace();
			resp.sendRedirect(req.getContextPath() + "/admin/products?msg=error");
		}
	}

	// ==================== TECH SPEC HELPERS ====================

	/**
	 * Load tech specs for a product and return as JSON for the edit modal.
	 */
	private void getTechSpec(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.setContentType("application/json");
		resp.setCharacterEncoding("UTF-8");

		try {
			int maSP = Integer.parseInt(req.getParameter("id"));
			Product p = productDAO.getByIdOrNull(maSP);
			if (p == null) {
				resp.getWriter().write("{}");
				return;
			}

			int categoryId = p.getMaLoaiSP();
			Map<String, Object> result = new HashMap<>();
			result.put("categoryId", categoryId);

			Map<String, String> fields = new HashMap<>();
			switch (categoryId) {
				case 1: { // Mainboard
					MainboardDetail d = detailDAO.getMainboardDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "mainChipset", d.getChipset());
						putIfNotNull(fields, "mainSocket", d.getSocket());
						putIfNotNull(fields, "mainKichThuoc", d.getKichThuocMain());
						putIfNotNull(fields, "mainHoTroCPU", d.getHoTroCPU());
						putIfNotNull(fields, "mainSoKheRam", String.valueOf(d.getSoKheRam()));
						putIfNotNull(fields, "mainLoaiRam", d.getLoaiRam());
						putIfNotNull(fields, "mainRamToiDa", d.getDungLuongRamToiDa());
						putIfNotNull(fields, "mainKhePCIe", d.getKhePCIe());
						putIfNotNull(fields, "mainSoSATA", String.valueOf(d.getSoCongSATA()));
						putIfNotNull(fields, "mainSoM2", String.valueOf(d.getSoKheM2()));
						putIfNotNull(fields, "mainCongXuatHinh", d.getCongXuatHinh());
					}
					break;
				}
				case 2: { // CPU
					CpuDetail d = detailDAO.getCpuDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "cpuHang", d.getHangCPU());
						putIfNotNull(fields, "cpuDong", d.getDongCPU());
						putIfNotNull(fields, "cpuSocket", d.getSocket());
						putIfNotNull(fields, "cpuSoNhan", String.valueOf(d.getSoNhan()));
						putIfNotNull(fields, "cpuSoLuong", String.valueOf(d.getSoLuongLuong()));
						putIfNotNull(fields, "cpuXungCoBan", d.getXungNhipCoBan());
						putIfNotNull(fields, "cpuXungTurbo", d.getXungNhipTurbo());
						putIfNotNull(fields, "cpuCacheL1", d.getCacheL1());
						putIfNotNull(fields, "cpuCacheL2", d.getCacheL2());
						putIfNotNull(fields, "cpuTDP", d.getTdp());
						putIfNotNull(fields, "cpuCoGPU", String.valueOf(d.isCoGPU()));
					}
					break;
				}
				case 3: { // VGA
					VgaDetail d = detailDAO.getVgaDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "vgaHang", d.getHangGPU());
						putIfNotNull(fields, "vgaVRAM", d.getDungLuongVRAM());
						putIfNotNull(fields, "vgaKieuBoNho", d.getKieuBoNho());
						putIfNotNull(fields, "vgaBus", d.getBusBoNho());
						putIfNotNull(fields, "vgaXungNhip", d.getXungNhip());
						putIfNotNull(fields, "vgaTDP", d.getTdp());
						putIfNotNull(fields, "vgaCongKetNoi", d.getCongKetNoi());
						putIfNotNull(fields, "vgaSoQuat", String.valueOf(d.getSoQuat()));
						putIfNotNull(fields, "vgaKichThuoc", d.getKichThuocCard());
						putIfNotNull(fields, "vgaDauCapNguon", d.getDauCapNguon());
					}
					break;
				}
				case 4: { // Case
					CaseDetail d = detailDAO.getCaseDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "caseHoTroMain", d.getHoTroMain());
						putIfNotNull(fields, "caseMauSac", d.getMauSac());
						putIfNotNull(fields, "caseChatLieu", d.getChatLieu());
						putIfNotNull(fields, "caseKichThuoc", d.getKichThuoc());
						putIfNotNull(fields, "caseHoTroNguon", d.getHoTroNguon());
						putIfNotNull(fields, "caseSoQuat", String.valueOf(d.getSoLuongQuatHoTro()));
						putIfNotNull(fields, "caseCoKinh", String.valueOf(d.isCoKinhCuongLuc()));
						putIfNotNull(fields, "caseCongTruoc", d.getCongTruocCase());
					}
					break;
				}
				case 5: { // Nguồn
					PsuDetail d = detailDAO.getPsuDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "psuCongSuat", d.getCongSuat());
						putIfNotNull(fields, "psuChuan", d.getChuan80Plus());
						putIfNotNull(fields, "psuCongKetNoi", d.getCongKetNoi());
						putIfNotNull(fields, "psuKichThuoc", d.getKichThuocNguon());
						putIfNotNull(fields, "psuDienAp", d.getDienApVao());
						putIfNotNull(fields, "psuDauCap", d.getDauCapNguon());
					}
					break;
				}
				case 6: { // Tản nhiệt
					CoolerDetail d = detailDAO.getCoolerDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "coolerLoai", d.getLoaiTanNhiet());
						putIfNotNull(fields, "coolerTuongThich", d.getTuongThichCPU());
						putIfNotNull(fields, "coolerRadiator", d.getKichThuocRadiator());
						putIfNotNull(fields, "coolerSoQuat", String.valueOf(d.getSoQuat()));
						putIfNotNull(fields, "coolerTocDo", d.getTocDoQuat());
						putIfNotNull(fields, "coolerDoOn", d.getDoOn());
						putIfNotNull(fields, "coolerLED", d.getLed());
						putIfNotNull(fields, "coolerKichThuoc", d.getKichThuocTan());
					}
					break;
				}
				case 7: { // Ổ cứng
					StorageDetail d = detailDAO.getStorageDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "storageLoai", d.getLoaiOCung());
						putIfNotNull(fields, "storageDungLuong", d.getDungLuong());
						putIfNotNull(fields, "storageChuan", d.getChuanKetNoi());
						putIfNotNull(fields, "storageKichCo", d.getKichCo());
						putIfNotNull(fields, "storageTocDo", d.getTocDoDocGhi());
					}
					break;
				}
				case 8: { // RAM
					RamDetail d = detailDAO.getRamDetail(maSP);
					if (d != null) {
						putIfNotNull(fields, "ramLoai", d.getLoaiRam());
						putIfNotNull(fields, "ramDungLuong", d.getDungLuong());
						putIfNotNull(fields, "ramBus", d.getBusRam());
						putIfNotNull(fields, "ramDienAp", d.getDienAp());
						putIfNotNull(fields, "ramSoThanh", String.valueOf(d.getSoThanh()));
					}
					break;
				}
			}
			result.put("fields", fields);

			String json = "{";
			json += "\"categoryId\":" + categoryId + ",";
			json += "\"fields\":{";
			boolean first = true;
			for (Map.Entry<String, String> e : fields.entrySet()) {
				if (!first)
					json += ",";
				String safeVal = e.getValue() != null
						? e.getValue().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r")
						: "";
				json += "\"" + e.getKey() + "\":\"" + safeVal + "\"";
				first = false;
			}
			json += "}}";

			resp.getWriter().write(json);

		} catch (Exception e) {
			resp.getWriter().write("{}");
		}
	}

	private boolean isAdmin(HttpServletRequest req) {
		User user = (User) req.getSession().getAttribute("user");
		return user != null && "QUAN_TRI_VIEN".equals(user.getVaiTro());
	}

	private void putIfNotNull(Map<String, String> map, String key, String value) {
		if (value != null) {
			map.put(key, value);
		}
	}

	/**
	 * Save tech specs from form parameters to database based on category.
	 */
	private void saveTechSpecs(HttpServletRequest req, int maSP, int maLoaiSP) {
		switch (maLoaiSP) {
			case 1: { // Mainboard
				MainboardDetail d = new MainboardDetail();
				d.setMaSP(maSP);
				d.setChipset(req.getParameter("mainChipset"));
				d.setSocket(req.getParameter("mainSocket"));
				d.setKichThuocMain(req.getParameter("mainKichThuoc"));
				d.setHoTroCPU(req.getParameter("mainHoTroCPU"));
				d.setSoKheRam(parseInt(req.getParameter("mainSoKheRam")));
				d.setLoaiRam(req.getParameter("mainLoaiRam"));
				d.setDungLuongRamToiDa(req.getParameter("mainRamToiDa"));
				d.setKhePCIe(req.getParameter("mainKhePCIe"));
				d.setSoCongSATA(parseInt(req.getParameter("mainSoSATA")));
				d.setSoKheM2(parseInt(req.getParameter("mainSoM2")));
				d.setCongXuatHinh(req.getParameter("mainCongXuatHinh"));
				detailDAO.upsertMainboardDetail(d);
				break;
			}
			case 2: { // CPU
				CpuDetail d = new CpuDetail();
				d.setMaSP(maSP);
				d.setHangCPU(req.getParameter("cpuHang"));
				d.setDongCPU(req.getParameter("cpuDong"));
				d.setSocket(req.getParameter("cpuSocket"));
				d.setSoNhan(parseInt(req.getParameter("cpuSoNhan")));
				d.setSoLuongLuong(parseInt(req.getParameter("cpuSoLuong")));
				d.setXungNhipCoBan(req.getParameter("cpuXungCoBan"));
				d.setXungNhipTurbo(req.getParameter("cpuXungTurbo"));
				d.setCacheL1(req.getParameter("cpuCacheL1"));
				d.setCacheL2(req.getParameter("cpuCacheL2"));
				d.setTdp(req.getParameter("cpuTDP"));
				d.setCoGPU("true".equals(req.getParameter("cpuCoGPU")));
				detailDAO.upsertCpuDetail(d);
				break;
			}
			case 3: { // VGA
				VgaDetail d = new VgaDetail();
				d.setMaSP(maSP);
				d.setHangGPU(req.getParameter("vgaHang"));
				d.setDungLuongVRAM(req.getParameter("vgaVRAM"));
				d.setKieuBoNho(req.getParameter("vgaKieuBoNho"));
				d.setBusBoNho(req.getParameter("vgaBus"));
				d.setXungNhip(req.getParameter("vgaXungNhip"));
				d.setTdp(req.getParameter("vgaTDP"));
				d.setCongKetNoi(req.getParameter("vgaCongKetNoi"));
				d.setSoQuat(parseInt(req.getParameter("vgaSoQuat")));
				d.setKichThuocCard(req.getParameter("vgaKichThuoc"));
				d.setDauCapNguon(req.getParameter("vgaDauCapNguon"));
				detailDAO.upsertVgaDetail(d);
				break;
			}
			case 4: { // Case
				CaseDetail d = new CaseDetail();
				d.setMaSP(maSP);
				d.setHoTroMain(req.getParameter("caseHoTroMain"));
				d.setMauSac(req.getParameter("caseMauSac"));
				d.setChatLieu(req.getParameter("caseChatLieu"));
				d.setKichThuoc(req.getParameter("caseKichThuoc"));
				d.setHoTroNguon(req.getParameter("caseHoTroNguon"));
				d.setSoLuongQuatHoTro(parseInt(req.getParameter("caseSoQuat")));
				d.setCoKinhCuongLuc("true".equals(req.getParameter("caseCoKinh")));
				d.setCongTruocCase(req.getParameter("caseCongTruoc"));
				detailDAO.upsertCaseDetail(d);
				break;
			}
			case 5: { // Nguồn
				PsuDetail d = new PsuDetail();
				d.setMaSP(maSP);
				d.setCongSuat(req.getParameter("psuCongSuat"));
				d.setChuan80Plus(req.getParameter("psuChuan"));
				d.setCongKetNoi(req.getParameter("psuCongKetNoi"));
				d.setKichThuocNguon(req.getParameter("psuKichThuoc"));
				d.setDienApVao(req.getParameter("psuDienAp"));
				d.setDauCapNguon(req.getParameter("psuDauCap"));
				detailDAO.upsertPsuDetail(d);
				break;
			}
			case 6: { // Tản nhiệt
				CoolerDetail d = new CoolerDetail();
				d.setMaSP(maSP);
				d.setLoaiTanNhiet(req.getParameter("coolerLoai"));
				d.setTuongThichCPU(req.getParameter("coolerTuongThich"));
				d.setKichThuocRadiator(req.getParameter("coolerRadiator"));
				d.setSoQuat(parseInt(req.getParameter("coolerSoQuat")));
				d.setTocDoQuat(req.getParameter("coolerTocDo"));
				d.setDoOn(req.getParameter("coolerDoOn"));
				d.setLed(req.getParameter("coolerLED"));
				d.setKichThuocTan(req.getParameter("coolerKichThuoc"));
				detailDAO.upsertCoolerDetail(d);
				break;
			}
			case 7: { // Ổ cứng
				StorageDetail d = new StorageDetail();
				d.setMaSP(maSP);
				d.setLoaiOCung(req.getParameter("storageLoai"));
				d.setDungLuong(req.getParameter("storageDungLuong"));
				d.setChuanKetNoi(req.getParameter("storageChuan"));
				d.setKichCo(req.getParameter("storageKichCo"));
				d.setTocDoDocGhi(req.getParameter("storageTocDo"));
				detailDAO.upsertStorageDetail(d);
				break;
			}
			case 8: { // RAM
				RamDetail d = new RamDetail();
				d.setMaSP(maSP);
				d.setLoaiRam(req.getParameter("ramLoai"));
				d.setDungLuong(req.getParameter("ramDungLuong"));
				d.setBusRam(req.getParameter("ramBus"));
				d.setDienAp(req.getParameter("ramDienAp"));
				d.setSoThanh(parseInt(req.getParameter("ramSoThanh")));
				detailDAO.upsertRamDetail(d);
				break;
			}
		}
	}

	private int parseInt(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			return 0;
		}
	}

	// ==================== HELPERS ====================

	/**
	 * Extract filename from Part header
	 */
	private String extractFileName(Part part) {
		String contentDisp = part.getHeader("content-disposition");
		for (String cd : contentDisp.split(";")) {
			if (cd.trim().startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
				// Keep only the last part (some browsers send full path)
				int lastSlash = fileName.lastIndexOf(java.io.File.separator);
				if (lastSlash >= 0)
					fileName = fileName.substring(lastSlash + 1);
				// Sanitize: remove spaces, special chars
				fileName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
				return fileName;
			}
		}
		return null;
	}

	/**
	 * Execute count query with dynamic params
	 */
	private int executeCountQuery(String sql, List<Object> params) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			if (params != null) {
				for (int i = 0; i < params.size(); i++) {
					ps.setObject(i + 1, params.get(i));
				}
			}
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt(1);
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi đếm sản phẩm", e);
		}
		return 0;
	}

	/**
	 * Execute product select query with dynamic params + pagination
	 */
	private List<Product> executeProductQuery(String sql, List<Object> params, int limit, int offset) {
		List<Product> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			int idx = 1;
			if (params != null) {
				for (Object param : params) {
					ps.setObject(idx++, param);
				}
			}
			ps.setInt(idx++, limit);
			ps.setInt(idx, offset);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Product p = new Product();
					p.setMaSP(rs.getInt("MaSP"));
					p.setTenSP(rs.getString("TenSP"));
					p.setMaLoaiSP(rs.getInt("MaLoaiSP"));
					p.setTenLoaiSP(rs.getString("TenLoaiSP"));
					p.setThuongHieu(rs.getString("ThuongHieu"));
					p.setGiaBan(rs.getBigDecimal("GiaBan"));
					p.setSoLuongTon(rs.getInt("SoLuongTon"));
					p.setBaoHanhThang(rs.getInt("BaoHanhThang"));
					p.setMoTaNgan(rs.getString("MoTaNgan"));
					p.setMoTaChiTiet(rs.getString("MoTaChiTiet"));
					p.setHienThi(rs.getBoolean("TrangThai"));
					p.setNgayTao(rs.getTimestamp("NgayTao"));
					p.setAnhChinh(rs.getString("AnhChinh"));
					list.add(p);
				}
			}
		} catch (SQLException e) {
			throw new AppException(ErrorCode.DATABASE_ERROR, "Lỗi truy vấn sản phẩm", e);
		}
		return list;
	}
}
