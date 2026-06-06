/* =============================================================
   PlacementAnalysis.js  —  All JS for PlacementAnalysis.jsp
   ============================================================= */

document.addEventListener("DOMContentLoaded", function() {
  initPieChart();
  initLineChart();
});

// ── 1. Pie / Doughnut Chart ────────────────────────────────────
function initPieChart() {
  var ctx = document.getElementById("pieChart");
  if (!ctx) return;

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: ["Tech", "Finance", "Edu", "Other"],
      datasets: [{
        data: [45, 30, 15, 10],
        backgroundColor: ["#123D8D", "#E16B6B", "#D48A3B", "#E5E7EB"],
        borderWidth: 0
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: "72%",
      plugins: {
        legend: { display: false }
      }
    }
  });
}

// ── 2. Line Chart ──────────────────────────────────────────────
function initLineChart() {
  var ctx = document.getElementById("lineChart");
  if (!ctx) return;

  new Chart(ctx, {
    type: "line",
    data: {
      labels: ["Q1\n23", "Q2\n23", "Q3\n23", "Q4\n23", "Q1\n24"],
      datasets: [{
        data: [25, 48, 40, 84, 70],
        borderColor: "#8AA0C8",
        backgroundColor: "rgba(138,160,200,0.08)",
        fill: true,
        tension: 0.5,
        pointRadius: 0,
        borderWidth: 3
      }]
    },
    options: {
      responsive: false,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      },
      scales: {
        x: {
          grid: { color: "#EAEAEA", drawBorder: false },
          ticks: { color: "#666", font: { size: 11 } },
          border: { display: false }
        },
        y: {
          display: false,
          grid: { display: false },
          border: { display: false }
        }
      }
    }
  });
}
