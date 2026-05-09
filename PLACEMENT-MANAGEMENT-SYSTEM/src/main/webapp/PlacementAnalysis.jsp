<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Analytics Dashboard</title>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- External CSS -->
<link rel="stylesheet" href="PlacementAnalysis.css">

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="container">

<!-- SIDEBAR -->
<div class="sidebar">

    <h2>Company Portal</h2>
<br><br>
    <ul class="menu">
        <li>
            <a href="CompanyDashboard.jsp">Dashboard</a>
        </li>

        <li >
            <a href="#">Job Posting</a>
        </li>

        <li class="active">
            Placement Management
        </li>

        <li>
            <a href="Interviews.jsp">Interview Scheduling</a>
        </li>
    </ul>

    
</div>

<!-- MAIN -->
<div class="main">

    <!-- TOPBAR -->
    <div class="topbar">

            <h2>Analytics Dashboard</h2>

            <div class="top-icons">
                <i class="fa fa-user-circle profile"></i>
                <i class="fa fa-bell bell"></i>
            </div>

        </div>
    

    <!-- PERFORMANCE -->
    <div class="performance">

        <p>GLOBAL PERFORMANCE</p>

        <h2>98.4%</h2>

        <span>
            Placement success rate across all vertical disciplines for 2024.
        </span>

    </div>

    <!-- GRID -->
    <div class="grid grid-cols-2 gap-6 mt-5">

        <!-- LEFT CARD -->
        <div class="card">

            <h3 class="text-2xl font-semibold mb-6">
                Department Performance
            </h3>

            <!-- ITEM -->
            <div class="progress-item">

                <p>
                    Computer Science & IT
                    <span>96%</span>
                </p>

                <div class="bar">
                    <div style="width:96%"></div>
                </div>

            </div>

            <!-- ITEM -->
            <div class="progress-item">

                <p>
                    Business Management
                    <span>88%</span>
                </p>

                <div class="bar">
                    <div style="width:88%"></div>
                </div>

            </div>

            <!-- ITEM -->
            <div class="progress-item">

                <p>
                    Architecture & Design
                    <span>92%</span>
                </p>

                <div class="bar">
                    <div style="width:92%"></div>
                </div>

            </div>

            <!-- ITEM -->
            <div class="progress-item">

                <p>
                    Social Sciences
                    <span>74%</span>
                </p>

                <div class="bar">
                    <div style="width:74%"></div>
                </div>

            </div>

        </div>

        <!-- PIE CARD -->
        <div class="card center">

            <h3 class="text-2xl font-semibold mb-4">
                Sector Distribution
            </h3>

            <div class="pie-wrapper">

                <canvas id="pieChart"></canvas>

                <div class="center-text">

                    <h2>1.2k</h2>

                    <p>Placed</p>

                </div>

            </div>

            <p class="sector-text">
                TECH 45% • FIN 30% • EDU 15% • OTHER 10%
            </p>

        </div>

    </div>

    <!-- LINE GRAPH -->
    <div class="card mt-6">

        <div class="flex justify-between items-center">

            <div>

                <h3 class="text-2xl font-semibold">
                    Salary Package Trends
                </h3>

                <p class="text-gray-500 text-sm mt-1">
                    Growth in median CTC (Cost to Company) over 5 quarters
                </p>

            </div>

            <span class="growth">
                +12.4% Annual Growth
            </span>

        </div>

        <div class="line-wrapper">

            <canvas id="lineChart"></canvas>

        </div>

    </div>

    <!-- SMALL STATS -->
    <div class="grid grid-cols-4 gap-4 mt-6">

        <div class="small-card">

            <p class="text-sm text-gray-500">Highest CTC</p>

            <h2 class="text-4xl font-bold mt-2">$194k</h2>

        </div>

        <div class="small-card orange">

            <p class="text-sm text-gray-500">Pending Offers</p>

            <h2 class="text-4xl font-bold mt-2">142</h2>

        </div>

        <div class="small-card blue">

            <p class="text-sm text-gray-500">New Companies</p>

            <h2 class="text-4xl font-bold mt-2">+48</h2>

        </div>

        <div class="small-card">

            <p class="text-sm text-gray-500">Recruiter Rating</p>

            <h2 class="text-4xl font-bold mt-2">4.9</h2>

        </div>

    </div>

</div>

</div>
<!-- CHART SCRIPT -->
<script>

// PIE CHART
new Chart(document.getElementById("pieChart"), {

    type: "doughnut",

    data: {

        labels: ["Tech","Finance","Edu","Other"],

        datasets: [{

            data: [45,30,15,10],

            backgroundColor: [
                "#123D8D",
                "#E16B6B",
                "#D48A3B",
                "#E5E7EB"
            ],

            borderWidth: 0

        }]
    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        cutout: "72%",

        plugins: {

            legend: {
                display: false
            }

        }
    }
});


// LINE CHART
new Chart(document.getElementById("lineChart"), {

    type: "line",

    data: {

        labels: ["Q1\n23","Q2\n23","Q3\n23","Q4\n23","Q1\n24"],

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

        responsive: true,

        maintainAspectRatio: false,

        plugins: {

            legend: {
                display: false
            }

        },

        scales: {

            x: {

                grid: {

                    color: "#EAEAEA",

                    drawBorder: false
                },

                ticks: {

                    color: "#666",

                    font: {
                        size: 11
                    }
                },

                border: {
                    display: false
                }
            },

            y: {

                display: false,

                grid: {
                    display: false
                },

                border: {
                    display: false
                }
            }
        }
    }
});

</script>

</body>
</html>