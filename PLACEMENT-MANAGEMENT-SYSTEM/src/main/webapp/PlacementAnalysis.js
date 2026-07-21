/* =============================================================
   PlacementAnalysis.js  —  All JS for PlacementAnalysis.jsp
   ============================================================= */

document.addEventListener("DOMContentLoaded", function() {
  fetchAnalyticsData();
  // Continuously update from database every 5 seconds
  setInterval(fetchAnalyticsData, 5000);
});

function fetchAnalyticsData() {
  fetch("PlacementAnalysisServlet")
    .then(function(response) {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(function(data) {
      updateDashboardData(data);
    })
    .catch(function(error) {
      console.error("Error fetching placement analysis data:", error);
      // Fallback defaults if servlet fails
      initPieChart([45, 30, 15, 10]);
      initLineChart([25, 48, 40, 84, 70]);
    });
}

function updateDashboardData(data) {
  // 1. Global Performance
  if (data.globalPerformance) {
    var rateEl = document.getElementById("global-success-rate");
    if (rateEl) rateEl.textContent = data.globalPerformance.successRate + "%";
  }

  // 2. Department Performance
  if (data.departmentPerformance) {
    var deptContainer = document.getElementById("department-list");
    if (deptContainer) {
      deptContainer.innerHTML = "";
      data.departmentPerformance.forEach(function(dept) {
        var progressItem = document.createElement("div");
        progressItem.className = "progress-item";
        progressItem.innerHTML = 
          "<p>" + esc(dept.name) + " <span>" + dept.rate + "%</span></p>" +
          "<div class='bar'>" +
            "<div style='width:" + dept.rate + "%'></div>" +
          "</div>";
        deptContainer.appendChild(progressItem);
      });
    }
  }

  // 3. Sector Distribution
  if (data.sectorDistribution) {
    var placedEl = document.getElementById("placed-count");
    if (placedEl) placedEl.textContent = data.sectorDistribution.placedCountText;

    var sectorTextEl = document.getElementById("sector-text");
    if (sectorTextEl) {
      var sectors = [];
      data.sectorDistribution.labels.forEach(function(label, index) {
        sectors.push(label.toUpperCase() + " " + data.sectorDistribution.data[index] + "%");
      });
      sectorTextEl.textContent = sectors.join(" • ");
    }

    initPieChart(data.sectorDistribution.data, data.sectorDistribution.labels);
  } else {
    initPieChart([45, 30, 15, 10]);
  }

  // 4. Salary Package Trends
  if (data.salaryPackageTrends) {
    var growthEl = document.getElementById("salary-growth");
    if (growthEl) growthEl.textContent = data.salaryPackageTrends.growthRate;

    initLineChart(data.salaryPackageTrends.data, data.salaryPackageTrends.labels);
  } else {
    initLineChart([25, 48, 40, 84, 70]);
  }

  // 5. Small Stats
  if (data.smallStats) {
    var highestCtcEl = document.getElementById("highest-ctc");
    if (highestCtcEl) highestCtcEl.textContent = data.smallStats.highestCtc;

    var pendingOffersEl = document.getElementById("pending-offers");
    if (pendingOffersEl) pendingOffersEl.textContent = data.smallStats.pendingOffers;

    var newCompaniesEl = document.getElementById("new-companies");
    if (newCompaniesEl) newCompaniesEl.textContent = data.smallStats.newCompanies;

    var recruiterRatingEl = document.getElementById("recruiter-rating");
    if (recruiterRatingEl) recruiterRatingEl.textContent = data.smallStats.recruiterRating;
  }
}

// ── 1. Pie / Doughnut Chart ────────────────────────────────────
var pieChartInstance = null;
function initPieChart(dataValues, labels) {
  var ctx = document.getElementById("pieChart");
  if (!ctx) return;

  labels = labels || ["Tech", "Finance", "Edu", "Other"];

  if (pieChartInstance) {
    pieChartInstance.data.labels = labels;
    pieChartInstance.data.datasets[0].data = dataValues;
    pieChartInstance.update();
  } else {
    pieChartInstance = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: labels,
        datasets: [{
          data: dataValues,
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
}

// ── 2. Line Chart ──────────────────────────────────────────────
var lineChartInstance = null;
function initLineChart(dataValues, labels) {
  var ctx = document.getElementById("lineChart");
  if (!ctx) return;

  labels = labels || ["Q1\n23", "Q2\n23", "Q3\n23", "Q4\n23", "Q1\n24"];

  if (lineChartInstance) {
    lineChartInstance.data.labels = labels;
    lineChartInstance.data.datasets[0].data = dataValues;
    lineChartInstance.update();
  } else {
    lineChartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        datasets: [{
          data: dataValues,
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
}

function esc(str) {
  return String(str === null || str === undefined ? "" : str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
