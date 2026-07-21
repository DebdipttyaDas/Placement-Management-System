var barChartInstance = null;
var pieChartInstance = null;
var lineChartInstance = null;

document.addEventListener("DOMContentLoaded", function () {

    // Initialize charts with JSP variables if available
    initBarChart(
        typeof barChartLabels !== 'undefined' ? barChartLabels : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        typeof barChartData !== 'undefined' ? barChartData : [40, 55, 60, 50, 70, 80]
    );

    initPieChart(
        typeof pieChartLabels !== 'undefined' ? pieChartLabels : ["CSE", "BCA", "MCA", "BBA", "MBA", "IT", "ECE"],
        typeof pieChartData !== 'undefined' ? pieChartData : [40, 25, 20, 15, 10, 12, 10]
    );

    initLineChart(
        typeof lineChartLabels !== 'undefined' ? lineChartLabels : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        typeof lineChartData !== 'undefined' ? lineChartData : [10, 20, 15, 25, 30, 35]
    );

    // Attach listeners for interactive elements
    attachApprovalListeners();
    attachNotificationHoverEffects();
    attachStatCardHoverEffects();

    // Start polling every 5 seconds
    setInterval(fetchDashboardUpdates, 5000);
});

// =========================
// Chart Initializers
// =========================
function initBarChart(labels, dataValues) {
    const barChartCanvas = document.getElementById("barChart");
    if (!barChartCanvas) return;

    if (barChartInstance) {
        barChartInstance.data.labels = labels;
        barChartInstance.data.datasets[0].data = dataValues;
        barChartInstance.update();
    } else {
        barChartInstance = new Chart(barChartCanvas, {
            type: "bar",
            data: {
                labels: labels,
                datasets: [{
                    label: "Placement %",
                    data: dataValues,
                    backgroundColor: [
                        "rgba(54,162,235,0.7)",
                        "rgba(75,192,192,0.7)",
                        "rgba(255,99,132,0.7)",
                        "rgba(255,206,86,0.7)",
                        "rgba(153,102,255,0.7)",
                        "rgba(40,167,69,0.7)"
                    ],
                    borderRadius: 6,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }
}

function initPieChart(labels, dataValues) {
    const pieChartCanvas = document.getElementById("pieChart");
    if (!pieChartCanvas) return;

    if (pieChartInstance) {
        pieChartInstance.data.labels = labels;
        pieChartInstance.data.datasets[0].data = dataValues;
        pieChartInstance.update();
    } else {
        pieChartInstance = new Chart(pieChartCanvas, {
            type: "pie",
            data: {
                labels: labels,
                datasets: [{
                    data: dataValues,
                    backgroundColor: [
                        "#FF6384",
                        "#36A2EB",
                        "#FFCE56",
                        "#4BC0C0",
                        "#9966FF",
                        "#FF9F40",
                        "#8BC34A"
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: "bottom" }
                }
            }
        });
    }
}

function initLineChart(labels, dataValues) {
    const lineChartCanvas = document.getElementById("lineChart");
    if (!lineChartCanvas) return;

    if (lineChartInstance) {
        lineChartInstance.data.labels = labels;
        lineChartInstance.data.datasets[0].data = dataValues;
        lineChartInstance.update();
    } else {
        lineChartInstance = new Chart(lineChartCanvas, {
            type: "line",
            data: {
                labels: labels,
                datasets: [{
                    label: "Jobs Posted",
                    data: dataValues,
                    borderColor: "rgba(75,192,192,1)",
                    backgroundColor: "rgba(75,192,192,0.2)",
                    fill: true,
                    tension: 0.4,
                    pointRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }
}

// =========================
// Dynamic updates polling
// =========================
function fetchDashboardUpdates() {
    fetch("AdminDashboardServlet?ajax=true")
        .then(function (response) {
            if (!response.ok) {
                throw new Error("Network response error");
            }
            return response.json();
        })
        .then(function (data) {
            // Update Stats count values
            var totalStuds = document.getElementById("total-students");
            if (totalStuds) totalStuds.textContent = data.totalStudents;
            var studsTrend = document.getElementById("students-trend");
            if (studsTrend) studsTrend.textContent = data.studentsTrend;

            var totalComps = document.getElementById("total-companies");
            if (totalComps) totalComps.textContent = data.totalCompanies;
            var compsTrend = document.getElementById("companies-trend");
            if (compsTrend) compsTrend.textContent = data.companiesTrend;

            var actJobs = document.getElementById("active-jobs");
            if (actJobs) actJobs.textContent = data.activeJobs;
            var jbTrend = document.getElementById("jobs-trend");
            if (jbTrend) jbTrend.textContent = data.jobsTrend;

            var placedStuds = document.getElementById("placed-students");
            if (placedStuds) placedStuds.textContent = data.placedStudents;
            var plTrend = document.getElementById("placed-trend");
            if (plTrend) plTrend.textContent = data.placedTrend;

            // Update Pending Company Approvals
            var pendingBody = document.getElementById("pending-companies-tbody");
            if (pendingBody) {
                if (data.pendingCompanies && data.pendingCompanies.length > 0) {
                    var html = "";
                    data.pendingCompanies.forEach(function (company) {
                        html += "<tr>" +
                                    "<td>" + esc(company.company_name) + "</td>" +
                                    "<td>" + esc(company.industry) + "</td>" +
                                    "<td>" + esc(company.email) + "</td>" +
                                    "<td>" +
                                        "<form action='ApproveCompanyServlet' method='post' style='display:inline;'>" +
                                            "<input type='hidden' name='companyId' value='" + esc(company.id) + "'>" +
                                            "<button type='submit' style='padding:5px 10px; background-color:#28a745; color:white; border:none; border-radius:3px; cursor:pointer;'>Approve</button>" +
                                        "</form>" +
                                    "</td>" +
                                "</tr>";
                    });
                    pendingBody.innerHTML = html;
                    attachApprovalListeners();
                } else {
                    pendingBody.innerHTML = "<tr><td colspan='4' style='text-align:center;'>No pending approvals</td></tr>";
                }
            }

            // Update Upcoming Drives
            var drivesBody = document.getElementById("upcoming-drives-tbody");
            if (drivesBody) {
                if (data.upcomingDrives && data.upcomingDrives.length > 0) {
                    var html = "";
                    data.upcomingDrives.forEach(function (drive) {
                        html += "<tr>" +
                                    "<td>" + esc(drive.company_name) + "</td>" +
                                    "<td>" + esc(drive.interview_round) + "</td>" +
                                    "<td>" + esc(drive.interview_date) + "</td>" +
                                    "<td><span class='status-scheduled'>" + esc(drive.status) + "</span></td>" +
                                "</tr>";
                    });
                    drivesBody.innerHTML = html;
                } else {
                    drivesBody.innerHTML = "<tr><td colspan='4' style='text-align:center;'>No upcoming drives scheduled</td></tr>";
                }
            }

            // Update Notifications
            var notesList = document.getElementById("notifications-list");
            if (notesList) {
                if (data.notifications && data.notifications.length > 0) {
                    var html = "";
                    data.notifications.forEach(function (note) {
                        var iconClass = "fa fa-bell";
                        if (note.type === "student") {
                            iconClass = "fa fa-user";
                        } else if (note.type === "building") {
                            iconClass = "fa fa-building";
                        }
                        html += "<div class='notification-card'>" +
                                    "<i class='" + iconClass + "'></i>" +
                                    "<div>" +
                                        "<p>" + esc(note.message) + "</p>" +
                                        "<span>" + esc(note.time) + "</span>" +
                                    "</div>" +
                                "</div>";
                    });
                    notesList.innerHTML = html;
                    attachNotificationHoverEffects();
                }
            }

            // Update Charts
            initBarChart(data.barChartLabels, data.barChartData);
            initPieChart(data.pieChartLabels, data.pieChartData);
            initLineChart(data.lineChartLabels, data.lineChartData);
        })
        .catch(function (error) {
            console.error("Error fetching dashboard updates:", error);
        });
}

// =========================
// UI Animation Listeners
// =========================
/*function attachApprovalListeners() {
    const approveButtons = document.querySelectorAll("#pending-companies-tbody button");
    approveButtons.forEach(button => {
        if (!button.dataset.listenerAttached) {
            button.dataset.listenerAttached = "true";
            button.addEventListener("click", function () {
                button.innerText = "Approved";
                button.style.backgroundColor = "#1e7e34";
                button.disabled = true;
                alert("Company Approved Successfully");
            });
        }
    });
}*/

function attachNotificationHoverEffects() {
    const notifications = document.querySelectorAll(".notification-card");
    notifications.forEach(card => {
        if (!card.dataset.listenerAttached) {
            card.dataset.listenerAttached = "true";
            card.addEventListener("mouseenter", function () {
                card.style.transform = "translateX(5px)";
                card.style.transition = "0.3s";
            });
            card.addEventListener("mouseleave", function () {
                card.style.transform = "translateX(0px)";
            });
        }
    });
}

function attachStatCardHoverEffects() {
    const statCards = document.querySelectorAll(".stat-card");
    statCards.forEach(card => {
        if (!card.dataset.listenerAttached) {
            card.dataset.listenerAttached = "true";
            card.addEventListener("mouseenter", function () {
                card.style.transform = "translateY(-8px)";
                card.style.transition = "0.3s";
            });
            card.addEventListener("mouseleave", function () {
                card.style.transform = "translateY(0px)";
            });
        }
    });
}

function esc(str) {
    return String(str === null || str === undefined ? "" : str)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}