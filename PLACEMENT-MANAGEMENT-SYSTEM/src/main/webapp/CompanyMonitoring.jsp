<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.List, java.util.Map" %>
<%
    if (request.getAttribute("jobsList") == null) {
        request.getRequestDispatcher("CompanyMonitoringServlet").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Company Monitoring</title>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="CompanyMonitoring.css">

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script src="CompanyMonitoring.js"></script>

</head>

<body>

    <!-- SIDEBAR -->
    <nav class="sidebar">

        <div class="logo">
            <h2 class="text-2xl font-bold mb-3">Company Monitoring</h2>
        </div>

        <ul class="nav-menu">
            <li><a href="AdminDashboard.jsp">Dashboard</a></li>
            <li class="active">Company Monitoring</li>
            <li><a href="StudentMonitoring.jsp">Student Monitoring</a></li>
            <li><a href="#" style="text-decoration:none;color:white;">Notifications</a></li>
        </ul>

        <form action="LogoutServlet" method="post">
            <button class="logout-btn">Logout</button>
        </form>

    </nav>

    <!-- MAIN AREA -->
    <div class="main-area">
        <header class="mobile-header" style="display:none; align-items:center; background:#06473e; padding:15px; position:sticky; top:0; z-index:100;">
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <h2 class="mobile-logo" style="color:white; font-size:18px; font-weight:bold; margin-left: 10px;">Company Monitoring</h2>
        </header>

        <div class="company-wrapper">

            <h1 class="company-heading">Company Post</h1>

            <div class="company-box">

                <!-- SEARCH -->
                <div class="search-bar">
                    <i class="fa fa-search search-icon"></i>
                    <input
                        type="text"
                        id="companySearch"
                        placeholder="Search by company name..."
                        onkeyup="searchCompany()">
                </div>

                <!-- CARD CONTAINER -->
                <div class="card-container">

<%
    List<Map<String, String>> jobsList = (List<Map<String, String>>) request.getAttribute("jobsList");
    if (jobsList != null && !jobsList.isEmpty()) {
        for (Map<String, String> job : jobsList) {
%>
                    <div class="job-card">
                        <h3 style="font-size: 1rem; font-weight: bold; margin-bottom: 8px; color: #000;"><%= job.get("jobTitle") %></h3>
                        <p class="company-name" style="margin-bottom: 6px; color: #333; font-size: 0.95rem;"><%= job.get("companyName") %></p>

                        <div class="tags">
                            <span style="margin-right: 10px; color: #555; font-size: 0.9rem;"><i class="fa fa-map-marker-alt"></i> <%= job.get("location") %></span>
                            <span style="color: #555; font-size: 0.9rem;"><i class="fa fa-briefcase"></i> <%= job.get("employmentType") %></span>
                        </div>

                        <button class="view-btn" onclick="toggleCard(this)">
                            View Details
                        </button>

                        <div class="extra-details">
                            <p><strong>Department:</strong> <%= job.get("department") %></p>
                            <p><strong>Location Type:</strong> <%= job.get("locationType") %></p>
                            <p><strong>Salary:</strong> <%= job.get("salary") %></p>
                            <p><strong>Deadline:</strong> <%= job.get("applicationDeadline") %></p>
                            
                            <div class="job-desc-section" style="margin-top: 10px; margin-bottom: 15px; border-top: 1px solid #eee; padding-top: 10px;">
                                <strong>Job Description:</strong>
                                <div class="job-desc-content" style="font-size: 0.85rem; color: #555; margin-top: 5px; line-height: 1.4; max-height: 150px; overflow-y: auto;">
                                    <%= job.get("jobDescription") %>
                                </div>
                            </div>

                            <button class="close-btn" onclick="toggleCard(this)">
                                Close Details
                            </button>
                        </div>
                    </div>
<%
        }
    } else {
%>
                    <div class="empty-box col-span-3">
                        <p style="color: #666; font-size: 1.1rem;">No job postings available at this time.</p>
                    </div>
<%
    }
%>

                </div>

            </div>

        </div>

    </div>
    

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
