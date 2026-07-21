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
      initRecruiterChart([9, 9, 6, 2, 1], ["TCS", "Capgemini", "INFOSYS", "ZOHO", "WIPRO"]);
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

  // 4. Recruiter Engagement & Activity (Bar Chart)
  if (data.recruiterActivity) {
    var descEl = document.getElementById("recruiter-desc");
    if (descEl) descEl.textContent = data.recruiterActivity.description;

    initRecruiterChart(data.recruiterActivity.data, data.recruiterActivity.labels);
  } else {
    initRecruiterChart([9, 9, 6, 2, 1], ["TCS", "Capgemini", "INFOSYS", "ZOHO", "WIPRO"]);
  }

  // 5. Live Placement KPI Statistics
  if (data.smallStats) {
    var studEl = document.getElementById("stat-students");
    if (studEl) studEl.textContent = data.smallStats.totalStudents;

    var placedCandidatesEl = document.getElementById("stat-placed");
    if (placedCandidatesEl) placedCandidatesEl.textContent = data.smallStats.placedStudents;

    var jobsEl = document.getElementById("stat-jobs");
    if (jobsEl) jobsEl.textContent = data.smallStats.activeJobs;

    var mockEl = document.getElementById("stat-mock");
    if (mockEl) mockEl.textContent = data.smallStats.mockInterviews;
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

// ── 2. Recruiter Bar Chart ──────────────────────────────────────
var recruiterChartInstance = null;
function initRecruiterChart(dataValues, labels) {
  var ctx = document.getElementById("recruiterBarChart");
  if (!ctx) return;

  labels = labels || ["TCS", "Capgemini", "INFOSYS", "ZOHO", "WIPRO"];

  if (recruiterChartInstance) {
    recruiterChartInstance.data.labels = labels;
    recruiterChartInstance.data.datasets[0].data = dataValues;
    recruiterChartInstance.update();
  } else {
    recruiterChartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: labels,
        datasets: [{
          label: "Applications Received",
          data: dataValues,
          backgroundColor: ["#0284c7", "#0d9488", "#4f46e5", "#ea580c", "#2563eb"],
          borderRadius: 6,
          borderWidth: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: "#475569", font: { family: "Poppins", size: 12, weight: "500" } }
          },
          y: {
            grid: { color: "#f1f5f9" },
            ticks: { color: "#64748b", stepSize: 2 }
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
