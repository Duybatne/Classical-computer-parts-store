package com.computerstore.services;

import java.util.List;

import com.computerstore.dao.PcBuilderDAO;
import com.computerstore.dto.PcComponentDTO;

public class PcBuilderService {
	private PcBuilderDAO pcBuilderDAO = new PcBuilderDAO();

	public List<PcComponentDTO> getComponents(int categoryId, String socket, String ramType) {
		// Categories based on LOAI_SAN_PHAM
		// 1: Mainboard, 2: CPU, 8: RAM
		if (categoryId == 2) {
			return pcBuilderDAO.getCPUs(socket);
		} else if (categoryId == 1) {
			return pcBuilderDAO.getMainboards(socket, ramType);
		} else if (categoryId == 8) {
			return pcBuilderDAO.getRAMs(ramType);
		} else {
			// Other components
			return pcBuilderDAO.getComponentsByCategory(categoryId);
		}
	}
}
