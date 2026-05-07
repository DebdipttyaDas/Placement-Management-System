document.addEventListener("DOMContentLoaded", function () {
    // Bar Chart - Placement Rate
    const barChartCanvas = document.getElementById("barChart");
    if (barChartCanvas) {
        new Chart(barChartCanvas, {
            type: "bar",
            data: {
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                datasets: [{
                    label: "Placement %",
                    data: [40, 55, 60, 50, 70, 80],
                    backgroundColor: "rgba(54, 162, 235, 0.6)",
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }

    // Pie Chart - Students per Department
    const pieChartCanvas = document.getElementById("pieChart");
    if (pieChartCanvas) {
        new Chart(pieChartCanvas, {
            type: "pie",
            data: {
                labels: ["CSE", "BCA", "MCA", "BBA", "MBA", "IT", "ECE"],
                datasets: [{
                    data: [40, 25, 20, 15, 10, 12, 10],
                    backgroundColor: [
                        "#FF6384", "#36A2EB", "#FFCE56",
                        "#4BC0C0", "#9966FF", "#FF9F40", "#C9CBCF"
                    ]
                }]
            },
            options: {
                responsive: true
            }
        });
    }

    // Line Chart - Job Postings (Monthly)
    const lineChartCanvas = document.getElementById("lineChart");
    if (lineChartCanvas) {
        new Chart(lineChartCanvas, {
            type: "line",
            data: {
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                datasets: [{
                    label: "Jobs Posted",
                    data: [10, 20, 15, 25, 30, 35],
                    fill: false,
                    borderColor: "rgba(75, 192, 192, 1)",
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }
});
