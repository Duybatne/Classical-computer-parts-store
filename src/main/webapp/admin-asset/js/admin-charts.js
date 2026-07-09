// Admin Dashboard Charts - Chart.js v2 (compatible with sb-admin-2)
(function () {
  "use strict";

  // Format number with VND currency
  function formatVND(value) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(value);
  }

  function formatNumber(value) {
    return new Intl.NumberFormat("vi-VN").format(value);
  }

  // Color palette
  const COLORS = {
    primary: "#4e73df",
    success: "#1cc88a",
    danger: "#e74a3b",
    warning: "#f6c23e",
    info: "#36b9cc",
    secondary: "#858796",
  };

  const CHART_DEFAULTS = {
    maintainAspectRatio: false,
    responsive: true,
    legend: {
      display: true,
      position: "bottom",
      labels: {
        fontColor: "#858796",
        fontSize: 12,
        padding: 15,
        usePointStyle: true,
      },
    },
    tooltips: {
      backgroundColor: "rgba(255,255,255,0.95)",
      bodyFontColor: "#858796",
      titleFontColor: "#6e707e",
      titleFontSize: 13,
      borderColor: "#dddfeb",
      borderWidth: 1,
      xPadding: 12,
      yPadding: 12,
      displayColors: true,
      intersect: false,
      mode: "index",
      caretPadding: 8,
    },
    scales: {
      xAxes: [
        {
          gridLines: {
            display: false,
            drawBorder: false,
          },
          ticks: {
            maxTicksLimit: 10,
            fontColor: "#858796",
            fontSize: 11,
          },
        },
      ],
      yAxes: [
        {
          gridLines: {
            color: "rgb(234, 236, 244)",
            zeroLineColor: "rgb(234, 236, 244)",
            drawBorder: false,
            borderDash: [2],
            zeroLineBorderDash: [2],
          },
          ticks: {
            maxTicksLimit: 5,
            padding: 10,
            fontColor: "#858796",
            fontSize: 11,
            callback: function (value) {
              return formatVND(value);
            },
          },
        },
      ],
    },
  };

  // ===== 1. DOANH THU - LINE CHART =====
  function initRevenueChart(data) {
    const ctx = document.getElementById("revenueChart");
    if (!ctx) return;

    const labels = Object.keys(data);
    const values = Object.values(data).map((v) => parseFloat(v));

    new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        datasets: [
          {
            label: "Doanh thu (VNĐ)",
            lineTension: 0.3,
            backgroundColor: "rgba(78, 115, 223, 0.05)",
            borderColor: COLORS.primary,
            pointRadius: 3,
            pointBackgroundColor: COLORS.primary,
            pointBorderColor: "#fff",
            pointBorderWidth: 2,
            pointHoverRadius: 4,
            pointHoverBackgroundColor: COLORS.primary,
            pointHoverBorderColor: "#fff",
            pointHitRadius: 10,
            data: values,
          },
        ],
      },
      options: Object.assign({}, CHART_DEFAULTS, {
        legend: { display: false },
        tooltips: {
          callbacks: {
            label: function (tooltipItem) {
              return "Doanh thu: " + formatVND(tooltipItem.yLabel);
            },
          },
        },
      }),
    });
  }

  // ===== 2. ĐƠN HÀNG THEO TRẠNG THÁI - DOUGHNUT CHART =====
  function initOrdersChart(data) {
    const ctx = document.getElementById("ordersChart");
    if (!ctx) return;

    const labels = Object.keys(data);
    const values = Object.values(data);
    const total = values.reduce((a, b) => a + b, 0);

    const statusColors = {
      "CHỜ XÁC NHẬN": COLORS.warning,
      "ĐÃ XÁC NHẬN": COLORS.info,
      "ĐANG GIAO": COLORS.primary,
      "ĐÃ GIAO": COLORS.success,
      "ĐÃ HỦY": COLORS.danger,
    };

    const bgColors = labels.map((l) => statusColors[l] || COLORS.secondary);

    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: labels,
        datasets: [
          {
            data: values,
            backgroundColor: bgColors,
            borderColor: "#fff",
            borderWidth: 2,
            hoverBorderColor: "#fff",
            hoverBorderWidth: 3,
          },
        ],
      },
      options: {
        maintainAspectRatio: false,
        responsive: true,
        cutoutPercentage: 65,
        legend: {
          display: true,
          position: "bottom",
          labels: {
            fontColor: "#858796",
            fontSize: 11,
            padding: 12,
            usePointStyle: true,
          },
        },
        tooltips: {
          callbacks: {
            label: function (tooltipItem, chart) {
              const label = chart.labels[tooltipItem.index];
              const value = chart.datasets[0].data[tooltipItem.index];
              const percent =
                total > 0 ? ((value / total) * 100).toFixed(1) : 0;
              return (
                label + ": " + formatNumber(value) + " đơn (" + percent + "%)"
              );
            },
          },
        },
      },
    });

    // Update summary text
    const summaryEl = document.getElementById("ordersSummary");
    if (summaryEl && total > 0) {
      const delivered = data["ĐÃ GIAO"] || 0;
      const cancelled = data["ĐÃ HỦY"] || 0;
      const rate = ((delivered / total) * 100).toFixed(1);
      summaryEl.innerHTML =
        "<strong>Tổng:</strong> " +
        formatNumber(total) +
        " đơn | " +
        '<span class="text-success"><strong>Giao thành công:</strong> ' +
        formatNumber(delivered) +
        " (" +
        rate +
        "%)</span> | " +
        '<span class="text-danger"><strong>Hủy:</strong> ' +
        formatNumber(cancelled) +
        "</span>";
    }
  }

  // ===== 3. TOP SẢN PHẨM - HORIZONTAL BAR CHART =====
  function initTopProductsChart(data) {
    const ctx = document.getElementById("topProductsChart");
    if (!ctx) return;

    // Reverse for horizontal bar (top at top)
    const labels = data
      .map((d) =>
        d.tenSP.length > 25 ? d.tenSP.substring(0, 25) + "..." : d.tenSP,
      )
      .reverse();
    const values = data.map((d) => d.soLuongBan).reverse();
    const revenues = data.map((d) => d.doanhThu).reverse();

    new Chart(ctx, {
      type: "horizontalBar",
      data: {
        labels: labels,
        datasets: [
          {
            label: "Số lượng bán",
            backgroundColor: "rgba(28, 200, 138, 0.8)",
            borderColor: COLORS.success,
            borderWidth: 1,
            data: values,
          },
        ],
      },
      options: Object.assign({}, CHART_DEFAULTS, {
        legend: { display: false },
        scales: {
          xAxes: [
            {
              gridLines: { color: "rgb(234, 236, 244)" },
              ticks: {
                fontColor: "#858796",
                fontSize: 11,
                callback: function (value) {
                  return formatNumber(value);
                },
              },
            },
          ],
          yAxes: [
            {
              gridLines: { display: false },
              ticks: { fontColor: "#858796", fontSize: 11 },
            },
          ],
        },
        tooltips: {
          callbacks: {
            label: function (tooltipItem, chart) {
              const idx = chart.data.labels.length - 1 - tooltipItem.index;
              return [
                "Số lượng: " + formatNumber(values[idx]),
                "Doanh thu: " + formatVND(revenues[idx]),
              ];
            },
          },
        },
      }),
    });
  }

  // ===== 4. DOANH THU THEO DANH MỤC - PIE CHART =====
  function initCategoryChart(data) {
    const ctx = document.getElementById("categoryChart");
    if (!ctx) return;

    const labels = data.map((d) => d.tenLoai);
    const values = data.map((d) => parseFloat(d.doanhThu));

    const pieColors = [
      "rgba(78, 115, 223, 0.8)",
      "rgba(28, 200, 138, 0.8)",
      "rgba(231, 74, 59, 0.8)",
      "rgba(246, 194, 62, 0.8)",
      "rgba(54, 185, 204, 0.8)",
      "rgba(133, 135, 150, 0.8)",
      "rgba(255, 99, 132, 0.8)",
      "rgba(153, 102, 255, 0.8)",
    ];

    new Chart(ctx, {
      type: "pie",
      data: {
        labels: labels,
        datasets: [
          {
            data: values,
            backgroundColor: pieColors.slice(0, labels.length),
            borderColor: "#fff",
            borderWidth: 2,
            hoverBorderColor: "#fff",
            hoverBorderWidth: 3,
          },
        ],
      },
      options: {
        maintainAspectRatio: false,
        responsive: true,
        legend: {
          display: true,
          position: "right",
          labels: {
            fontColor: "#858796",
            fontSize: 11,
            padding: 10,
            usePointStyle: true,
            boxWidth: 10,
          },
        },
        tooltips: {
          callbacks: {
            label: function (tooltipItem, chart) {
              const label = chart.labels[tooltipItem.index];
              const value = chart.datasets[0].data[tooltipItem.index];
              const total = chart.datasets[0].data.reduce((a, b) => a + b, 0);
              const percent =
                total > 0 ? ((value / total) * 100).toFixed(1) : 0;
              return label + ": " + formatVND(value) + " (" + percent + "%)";
            },
          },
        },
      },
    });
  }

  // ===== MAIN INIT FUNCTION =====
  window.AdminCharts = {
    init: function (days) {
      days = days || 30;
      const baseUrl =
        window.location.pathname.replace(/\/admin.*/, "") + "/admin/api/stats";

      // Load all charts in parallel
      Promise.all([
        fetch(baseUrl + "/revenue?days=" + days).then((r) => r.json()),
        fetch(baseUrl + "/orders?days=" + days).then((r) => r.json()),
        fetch(baseUrl + "/top-products?days=" + days + "&limit=5").then((r) =>
          r.json(),
        ),
        fetch(baseUrl + "/category-revenue?days=" + days).then((r) => r.json()),
      ])
        .then(function (results) {
          initRevenueChart(results[0]);
          initOrdersChart(results[1]);
          initTopProductsChart(results[2]);
          initCategoryChart(results[3]);
        })
        .catch(function (err) {
          console.error("Lỗi tải biểu đồ:", err);
        });
    },

    // Refresh specific chart
    refreshRevenue: function (days) {
      const baseUrl =
        window.location.pathname.replace(/\/admin.*/, "") + "/admin/api/stats";
      fetch(baseUrl + "/revenue?days=" + days)
        .then((r) => r.json())
        .then(initRevenueChart);
    },
    refreshOrders: function (days) {
      const baseUrl =
        window.location.pathname.replace(/\/admin.*/, "") + "/admin/api/stats";
      fetch(baseUrl + "/orders?days=" + days)
        .then((r) => r.json())
        .then(initOrdersChart);
    },
  };

  // Auto-init on DOM ready
  document.addEventListener("DOMContentLoaded", function () {
    // Get days from dropdown if exists
    const periodSelect = document.getElementById("chartPeriod");
    const days = periodSelect ? parseInt(periodSelect.value) : 30;
    window.AdminCharts.init(days);

    // Re-init on period change
    if (periodSelect) {
      periodSelect.addEventListener("change", function () {
        window.AdminCharts.init(parseInt(this.value));
      });
    }
  });
})();
