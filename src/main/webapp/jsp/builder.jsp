<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="PC Builder" activePage="builder">
  <jsp:body>
    <div class="container-fluid py-5">
      <div class="container">
        <div class="section-header text-center mb-4">
          <h2><i class="fas fa-desktop me-2"></i>PC Builder - Tự Build PC</h2>
          <p class="text-muted">Chọn linh kiện để xây dựng cấu hình PC hoàn chỉnh của bạn</p>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty sessionScope.successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
          <c:remove var="successMessage" scope="session"/>
        </c:if>

        <div class="row g-4">
          <!-- Left: Component Selection -->
          <div class="col-lg-8">
            <form action="${pageContext.request.contextPath}/builder" method="post" id="builderForm">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <div class="card shadow-sm mb-4">
                <div class="card-body">
                  <h5 class="card-title mb-3"><i class="fas fa-microchip me-2"></i>Chọn linh kiện</h5>

                  <!-- CPU -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-microchip me-2 text-primary"></i>CPU (Bộ vi xử lý)
                      <span class="badge bg-success ms-2 selected-count" id="cpu-count">0</span>
                    </h6>
                    <div class="component-list" id="cpu-list">
                      <c:forEach var="p" items="${cpus}">
                        <div class="component-item">
                          <input type="radio" name="maSP_CPU" value="${p.maSP}" id="cpu-${p.maSP}" class="component-radio">
                          <label for="cpu-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- Mainboard -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-project-diagram me-2 text-primary"></i>Mainboard (Bo mạch chủ)
                      <span class="badge bg-success ms-2 selected-count" id="mainboard-count">0</span>
                    </h6>
                    <div class="component-list" id="mainboard-list">
                      <c:forEach var="p" items="${mainboards}">
                        <div class="component-item">
                          <input type="radio" name="maSP_Mainboard" value="${p.maSP}" id="mainboard-${p.maSP}" class="component-radio">
                          <label for="mainboard-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- RAM -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-memory me-2 text-primary"></i>RAM (Bộ nhớ)
                      <span class="badge bg-success ms-2 selected-count" id="ram-count">0</span>
                    </h6>
                    <div class="component-list" id="ram-list">
                      <c:forEach var="p" items="${rams}">
                        <div class="component-item">
                          <input type="radio" name="maSP_RAM" value="${p.maSP}" id="ram-${p.maSP}" class="component-radio">
                          <label for="ram-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- VGA/GPU -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-memory me-2 text-primary"></i>VGA (Card đồ họa)
                      <span class="badge bg-success ms-2 selected-count" id="vga-count">0</span>
                    </h6>
                    <div class="component-list" id="vga-list">
                      <c:forEach var="p" items="${vgas}">
                        <div class="component-item">
                          <input type="radio" name="maSP_VGA" value="${p.maSP}" id="vga-${p.maSP}" class="component-radio">
                          <label for="vga-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- Storage -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-hdd me-2 text-primary"></i>Ổ cứng (Storage)
                      <span class="badge bg-success ms-2 selected-count" id="storage-count">0</span>
                    </h6>
                    <div class="component-list" id="storage-list">
                      <c:forEach var="p" items="${storages}">
                        <div class="component-item">
                          <input type="radio" name="maSP_Storage" value="${p.maSP}" id="storage-${p.maSP}" class="component-radio">
                          <label for="storage-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- Case -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-box-open me-2 text-primary"></i>Vỏ case
                      <span class="badge bg-success ms-2 selected-count" id="case-count">0</span>
                    </h6>
                    <div class="component-list" id="case-list">
                      <c:forEach var="p" items="${cases}">
                        <div class="component-item">
                          <input type="radio" name="maSP_Case" value="${p.maSP}" id="case-${p.maSP}" class="component-radio">
                          <label for="case-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- PSU -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-plug me-2 text-primary"></i>Nguồn (PSU)
                      <span class="badge bg-success ms-2 selected-count" id="psu-count">0</span>
                    </h6>
                    <div class="component-list" id="psu-list">
                      <c:forEach var="p" items="${psus}">
                        <div class="component-item">
                          <input type="radio" name="maSP_PSU" value="${p.maSP}" id="psu-${p.maSP}" class="component-radio">
                          <label for="psu-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>

                  <!-- Cooler -->
                  <div class="component-section mb-4">
                    <h6 class="component-title">
                      <i class="fas fa-fan me-2 text-primary"></i>Tản nhiệt (Cooler)
                      <span class="badge bg-success ms-2 selected-count" id="cooler-count">0</span>
                    </h6>
                    <div class="component-list" id="cooler-list">
                      <c:forEach var="p" items="${coolers}">
                        <div class="component-item">
                          <input type="radio" name="maSP_Cooler" value="${p.maSP}" id="cooler-${p.maSP}" class="component-radio">
                          <label for="cooler-${p.maSP}" class="component-label">
                            <span class="component-name">${p.tenSP}</span>
                            <span class="component-price">
                              <c:choose>
                                <c:when test="${not empty p.discountedPrice && p.discountedPrice < p.giaBan}">
                                  <span class="text-decoration-line-through text-muted me-2" style="font-size: 0.85em;">
                                    <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                  </span>
                                  <fmt:formatNumber value="${p.discountedPrice}" type="currency" currencySymbol="₫"/>
                                </c:when>
                                <c:otherwise>
                                  <fmt:formatNumber value="${p.giaBan}" type="currency" currencySymbol="₫"/>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </label>
                        </div>
                      </c:forEach>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>

          <!-- Right: Summary -->
          <div class="col-lg-4">
            <div class="card shadow-sm sticky-top" style="top: 20px;">
              <div class="card-body">
                <h5 class="card-title mb-3"><i class="fas fa-clipboard-list me-2"></i>Tóm tắt cấu hình</h5>

                <div id="build-summary">
                  <p class="text-muted text-center py-4">Chưa chọn linh kiện nào</p>
                </div>

                <div class="build-total mt-4 pt-3 border-top">
                  <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Tổng cộng:</span>
                    <span class="fw-bold text-primary fs-4" id="total-price">0₫</span>
                  </div>
                </div>

                <div class="d-grid gap-2 mt-4">
                  <button type="submit" form="builderForm" class="btn btn-primary rounded-pill py-3">
                    <i class="fas fa-shopping-cart me-2"></i>Thêm vào giỏ hàng
                  </button>
                  <button type="button" class="btn btn-outline-secondary rounded-pill py-3" onclick="clearBuild()">
                    <i class="fas fa-rotate-left me-2"></i>Xóa tất cả
                  </button>
                </div>

                <div class="compatibility-check mt-4 pt-3 border-top">
                  <h6><i class="fas fa-check-circle me-2 text-success"></i>Kiểm tra tương thích</h6>
                  <div id="compatibility-status" class="mt-2">
                    <p class="text-muted mb-0">Chọn ít nhất CPU và Mainboard để kiểm tra</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <style>
    .component-section {
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 16px;
      background: #f8f9fa;
    }
    .component-title {
      font-weight: 600;
      margin-bottom: 12px;
      padding-bottom: 8px;
      border-bottom: 1px solid #dee2e6;
    }
    .component-list {
      max-height: 200px;
      overflow-y: auto;
    }
    .component-item {
      margin-bottom: 8px;
    }
    .component-radio {
      display: none;
    }
    .component-label {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 12px;
      background: white;
      border: 1px solid #dee2e6;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .component-label:hover {
      border-color: #0d6efd;
      background: #f0f7ff;
    }
    .component-radio:checked + .component-label {
      border-color: #0d6efd;
      background: #0d6efd;
      color: white;
    }
    .component-radio:checked + .component-label .component-price {
      color: white;
    }
    .component-name {
      flex: 1;
      font-size: 14px;
    }
    .component-price {
      font-weight: 600;
      color: #0d6efd;
      font-size: 14px;
    }
    .selected-count {
      font-size: 12px;
    }
    .build-total {
      background: #f8f9fa;
      border-radius: 8px;
      padding: 16px;
    }
    #build-summary .summary-item {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #eee;
    }
    #build-summary .summary-item:last-child {
      border-bottom: none;
    }
    </style>

    <script>
    const componentPrices = {};
    <c:forEach var="p" items="${cpus}">
      componentPrices['cpu-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${mainboards}">
      componentPrices['mainboard-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${rams}">
      componentPrices['ram-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${vgas}">
      componentPrices['vga-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${storages}">
      componentPrices['storage-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${cases}">
      componentPrices['case-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${psus}">
      componentPrices['psu-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>
    <c:forEach var="p" items="${coolers}">
      componentPrices['cooler-${p.maSP}'] = ${not empty p.discountedPrice && p.discountedPrice < p.giaBan ? p.discountedPrice : p.giaBan};
    </c:forEach>

    const categoryNames = {
      'cpu': 'CPU',
      'mainboard': 'Mainboard',
      'ram': 'RAM',
      'vga': 'VGA',
      'storage': 'Ổ cứng',
      'case': 'Case',
      'psu': 'Nguồn',
      'cooler': 'Tản nhiệt'
    };

    function updateSummary() {
      const radios = document.querySelectorAll('.component-radio:checked');
      let total = 0;
      let summaryHtml = '';
      const counts = {};

      radios.forEach(radio => {
        const price = componentPrices[radio.id];
        total += price;
        const category = radio.id.split('-')[0];
        counts[category] = (counts[category] || 0) + 1;

        const label = document.querySelector(`label[for="${radio.id}"]`);
        const name = label.querySelector('.component-name').textContent;
        summaryHtml += `<div class="summary-item">
          <span><strong>${categoryNames[category]}:</strong> ${name}</span>
          <span>${formatCurrency(price)}</span>
        </div>`;
      });

      // Update counts
      Object.keys(categoryNames).forEach(cat => {
        const countEl = document.getElementById(`${cat}-count`);
        if (countEl) {
          countEl.textContent = counts[cat] || 0;
        }
      });

      // Update summary
      const summaryEl = document.getElementById('build-summary');
      if (radios.length === 0) {
        summaryEl.innerHTML = '<p class="text-muted text-center py-4">Chưa chọn linh kiện nào</p>';
      } else {
        summaryEl.innerHTML = summaryHtml;
      }

      // Update total
      document.getElementById('total-price').textContent = formatCurrency(total);

      // Check compatibility
      checkCompatibility();
    }

    function formatCurrency(value) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
    }

    function checkCompatibility() {
      const statusEl = document.getElementById('compatibility-status');
      const cpuRadio = document.querySelector('input[name="maSP_CPU"]:checked');
      const mainboardRadio = document.querySelector('input[name="maSP_Mainboard"]:checked');

      if (!cpuRadio || !mainboardRadio) {
        statusEl.innerHTML = '<p class="text-muted mb-0">Chọn ít nhất CPU và Mainboard để kiểm tra</p>';
        return;
      }

      // Simple compatibility check - in real app, this would be more complex
      statusEl.innerHTML = '<div class="alert alert-success mb-0"><i class="fas fa-check-circle me-2"></i>Cấu hình có vẻ tương thích!</div>';
    }

    function clearBuild() {
      document.querySelectorAll('.component-radio').forEach(radio => {
        radio.checked = false;
      });
      updateSummary();
    }

    // Add event listeners
    document.querySelectorAll('.component-radio').forEach(radio => {
      radio.addEventListener('change', updateSummary);
    });

    // Initialize
    updateSummary();
    </script>
  </jsp:body>
</t:main>
