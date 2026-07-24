<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Placement Analysis</title>

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
<h2>Placement  Analysis </h2>
    <ul class="menu">
        
        <li><a href="AdminDashboard.jsp">Dashboard</a></li>
        <li><a href="CompanyMonitoring.jsp">Company Monitoring</a></li>
        <li><a href="StudentMonitoring.jsp">Student Monitoring</a></li> 
        <li class="active">Placement Analysis</li>
        
    </ul>
<!-- LOGOUT -->
    <div class="logout">
        <form action="LogoutServlet" method="post" style="width: 100%;">
            <button type="submit" style="width: 100%;">
                Logout
            </button>
        </form>
    </div>
    
</div>

<!-- MAIN -->
<div class="main">

<!-- HEADER -->

    
    <div class="topbar" style="display:flex; align-items:center; padding-left:15px;">
        <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
            &#9776;
        </button>
    </div>
    
<div class="page-content">
    <!-- PERFORMANCE -->
    <div class="performance">
<h2>Analytics Dashboard</h2>
        <p>GLOBAL PERFORMANCE</p>

        <h2 id="global-success-rate">98.4%</h2>

        <span>
            Placement success rate across all vertical disciplines for 2026.
        </span>

    </div>

    <!-- GRID -->
    <div class="grid grid-cols-2 gap-6 mt-5">

        <!-- LEFT CARD -->
        <div class="card">

            <h3 class="text-2xl font-semibold mb-6">
                Department Performance
            </h3>

            <div id="department-list">
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

        </div>

        <!-- PIE CARD -->
        <div class="card">

            <h3 class="text-2xl font-semibold mb-4">
                Sector Distribution
            </h3>

            <div class="pie-wrapper">

                   <canvas id="pieChart"></canvas>

                   <div class="center-text">

                       <h2 id="placed-count">1.2k</h2>

                       <p>Placed</p>

                   </div>

            </div>

            <p class="sector-text" id="sector-text">
                TECH 45% • FIN 30% • EDU 15% • OTHER 10%
            </p>

        </div>

    </div>

    <!-- RECRUITER ACTIVITY BAR CHART -->
    <div class="card mt-6">

        <div class="flex justify-between items-center w-full">

            <div>

                <h3 class="text-2xl font-semibold">
                    Recruiter Engagement & Interest
                </h3>

                <p class="text-gray-500 text-sm mt-1" id="recruiter-desc">
                    Application volumes received by top recruiting companies
                </p>

            </div>

            <span class="growth" id="recruiter-growth" style="color:#06473e; font-weight:600;">
                Active Placements
            </span>

        </div>

        <div class="line-wrapper">

            <canvas id="recruiterBarChart"></canvas>

        </div>

    </div>

    <!-- PLACEMENT STATISTICS METRICS -->
    <div class="grid grid-cols-4 gap-4 mt-6">

        <div class="small-card">

            <p class="text-sm text-gray-500">Registered Students</p>

            <h2 class="text-4xl font-bold mt-2" id="stat-students">0</h2>

        </div>

        <div class="small-card orange">

            <p class="text-sm text-gray-500">Selected Candidates</p>

            <h2 class="text-4xl font-bold mt-2" id="stat-placed">0</h2>

        </div>

        <div class="small-card blue">

            <p class="text-sm text-gray-500">Active Job Drives</p>

            <h2 class="text-4xl font-bold mt-2" id="stat-jobs">0</h2>

        </div>

        <div class="small-card">

            <p class="text-sm text-gray-500">AI Prep Sessions</p>

            <h2 class="text-4xl font-bold mt-2" id="stat-mock">0</h2>

        </div>

    </div>

</div>
</div>
</div>

<!-- CHART SCRIPT -->

<script src="PlacementAnalysis.js"></script>
         


<script>
  (function() {
    const toggleBtn = document.getElementById('sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');
    if (toggleBtn && sidebar) {
      toggleBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        sidebar.classList.toggle('active');
      });
      document.addEventListener('click', function(e) {
        if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
          sidebar.classList.remove('active');
        }
      });
    }
  })();
</script>

</body>
</html>