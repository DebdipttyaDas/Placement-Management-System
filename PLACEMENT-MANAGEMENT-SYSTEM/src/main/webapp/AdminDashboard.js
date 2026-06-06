document.addEventListener("DOMContentLoaded", function () {

    // =========================
    // Placement Bar Chart
    // =========================
    const barChartCanvas = document.getElementById("barChart");

    if (barChartCanvas) {

        new Chart(barChartCanvas, {

            type: "bar",

            data: {
                labels: typeof barChartLabels !== 'undefined' ? barChartLabels : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],

                datasets: [{
                    label: "Placement %",
                    data: typeof barChartData !== 'undefined' ? barChartData : [40, 55, 60, 50, 70, 80],

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
                    legend: {
                        display: true
                    }
                },

                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }


    // =========================
    // Pie Chart
    // =========================
    const pieChartCanvas = document.getElementById("pieChart");

    if (pieChartCanvas) {

        new Chart(pieChartCanvas, {

            type: "pie",

            data: {
                labels: typeof pieChartLabels !== 'undefined' ? pieChartLabels : ["CSE", "BCA", "MCA", "BBA", "MBA", "IT", "ECE"],

                datasets: [{
                    data: typeof pieChartData !== 'undefined' ? pieChartData : [40, 25, 20, 15, 10, 12, 10],

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
                    legend: {
                        position: "bottom"
                    }
                }
            }
        });
    }


    // =========================
    // Line Chart
    // =========================
    const lineChartCanvas = document.getElementById("lineChart");

    if (lineChartCanvas) {

        new Chart(lineChartCanvas, {

            type: "line",

            data: {
                labels: typeof lineChartLabels !== 'undefined' ? lineChartLabels : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],

                datasets: [{
                    label: "Jobs Posted",

                    data: typeof lineChartData !== 'undefined' ? lineChartData : [10, 20, 15, 25, 30, 35],

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
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }


    // =========================
    // Company Approval Buttons
    // =========================
    const approveButtons = document.querySelectorAll("button");

    approveButtons.forEach(button => {

        if (button.innerText.trim() === "Approve") {

            button.addEventListener("click", function () {

                button.innerText = "Approved";

                button.style.backgroundColor = "#1e7e34";

                button.disabled = true;

                alert("Company Approved Successfully");

            });

        }

    });


    // =========================
    // Notification Hover Effect
    // =========================
    const notifications = document.querySelectorAll(".notification-card");

    notifications.forEach(card => {

        card.addEventListener("mouseenter", function () {

            card.style.transform = "translateX(5px)";
            card.style.transition = "0.3s";

        });

        card.addEventListener("mouseleave", function () {

            card.style.transform = "translateX(0px)";

        });

    });


    // =========================
    // Stat Card Animation
    // =========================
    const statCards = document.querySelectorAll(".stat-card");

    statCards.forEach(card => {

        card.addEventListener("mouseenter", function () {

            card.style.transform = "translateY(-8px)";
            card.style.transition = "0.3s";

        });

        card.addEventListener("mouseleave", function () {

            card.style.transform = "translateY(0px)";

        });

    });

});