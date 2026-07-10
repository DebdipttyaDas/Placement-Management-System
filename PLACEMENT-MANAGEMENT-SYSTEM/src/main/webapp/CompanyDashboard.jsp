<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Company Dashboard</title>
<link rel="stylesheet" href="CompanyDashboard.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h2>Company Portal</h2>
        <br><br>
        <ul class="menu">
            <li class="active">Dashboard</li>
            <li><a href="JobPost.jsp" style="text-decoration:none;color:white;">Job Post</a></li>
            <li><a href="Interviews.jsp" style="text-decoration:none;color:white;">Interviews</a></li>
            <li><a href="PlacementAnalysis.jsp" style="text-decoration:none;color:white;">Placement Analysis</a></li>
        </ul>
        <div class="logout">
            <form action="LogoutServlet" method="post" style="width: 100%;">
                <button type="submit" style="width: 100%;">Logout</button>
            </form>
        </div>
    </div>
    <!-- END SIDEBAR -->

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- TOPBAR -->
        <div class="topbar">
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <h2 class="topbar-title">Company Dashboard</h2>
            <div class="user-profile">
                <a href="CompanyProfileServlet">
                    <i class="fa fa-user-circle"></i>
                </a>
                <i class="fa fa-bell bell"></i>
            </div>
        </div>
        <!-- END TOPBAR -->

        <!-- PAGE (scrollable) -->
        <div class="page">

            <!-- Hero -->
            <div class="hero">
                <span class="particle"></span>
                <span class="particle"></span>
                <span class="particle"></span>
                <div>
                    <div class="hero-label">Company Dashboard</div>
                    <h1>Hello, <%= session.getAttribute("companyName") != null ? session.getAttribute("companyName") : "Recruiting Partner" %></h1>
                    <p>Here is your recruitment overview for the current placement season.</p>
                </div>
                <div class="hero-content">
                    <button class="btn btn-white" onclick="window.location.href='JobPost.jsp'">+ Post new jobs</button>
                </div>
                <div class="hero-actions">
                    <button class="btn btn-white" id="reviewApplicationsBtn">Review Applications</button>
                </div>
            </div>
            <!-- END Hero -->

            <!-- Main Grid -->
            <div class="main-grid">

                <!-- LEFT: Drive Cards -->
                <div>
                    <div class="section-header">
                        <span class="section-title">Active Drives</span>
                        <div class="view-actions">
                            <button class="view-btn" onclick="showDrives()">View All</button>
                            <button class="view-btn" onclick="hideDrives()">Hide All</button>
                        </div>
                    </div>
                    <div id="activeDrivesContainer">
                        <div style="padding: 20px; text-align: center; color: #64748b;">
                            <i class="fa fa-spinner fa-spin" style="font-size:24px; color:#06473e;"></i> Loading active drives...
                        </div>
                    </div>
                </div>
                <!-- END LEFT -->

                <!-- RIGHT: Interviews -->
                <div>
                    <div class="section-header">
                        <span class="section-title">Today's Interviews</span>
                        <div class="view-actions">
                            <button class="view-btn" onclick="showInterviews()">View All</button>
                            <button class="view-btn" onclick="hideInterviews()">Hide All</button>
                        </div>
                    </div>

                    <div class="interviews-panel">
                        <div id="companyInterviewsPanel">
                            <div style="padding:12px 0;color:#64748b;font-size:14px;">
                                Loading scheduled interviews...
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END RIGHT -->

            </div>
            <!-- END Main Grid -->

        </div>
        <!-- END PAGE -->

    </div>
    <!-- END MAIN CONTENT -->

</div>
<!-- END CONTAINER -->

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

<!-- REVIEW APPLICATIONS MODAL -->
<div class="review-modal-overlay" id="reviewApplicationsModal">
    <div class="review-modal">
        <div class="review-modal-header">
            <h2>Review Job Applications</h2>
            <button class="close-review-modal-btn" id="closeReviewModalBtn">&times;</button>
        </div>
        <div class="review-modal-body">
            <div id="applicationsLoader" style="display:none; text-align:center; padding:20px;">
                <i class="fa fa-spinner fa-spin" style="font-size:24px; color:#06473e;"></i> Loading applications...
            </div>
            <div id="applicationsContainer">
                <!-- Dynamically loaded table will be here -->
            </div>
        </div>
    </div>
</div>

<script src="CompanyDashboard.js"></script>
</body>
</html>
