<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Placements</title>
  <link rel="stylesheet" href="Placement.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="dashboard-container">

    <!-- LEFT SIDEBAR -->
    <div class="sidebar">
      <h2>Placements</h2>

      <ul>
        <li><a href="Student_dashboard.jsp">Dashboard</a></li>
        <li><a href="Placement.jsp">Placements</a></li>
        <li><a href="MyApplication.jsp">My Applications</a></li>
      </ul>
    </div>

    <!-- TOP BAR -->
    <div style="display:flex; justify-content:flex-end; padding:15px;width:98%; background:#06352f; color:white;">
      <div style="display:flex; align-items:center; gap:30px;">
        <i class="fa fa-user-circle" style="font-size:25px;"></i>
        <i class="fa fa-bell" style="font-size:25px;"></i>
      </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">

        <!-- SEARCH BAR -->
        <div class="search-box">
            <input type="text" placeholder="Search for job titles or companies...">
        </div>

        <!-- FILTER BUTTONS -->
        <div class="job-filters">
            <button>All</button>
            <button>IT</button>
            <button>Engineering</button>
            <button>Marketing</button>
            <button>Medical</button>
            <button>HR</button>
        </div>

        <!-- JOB CARDS -->
        <div class="job-cards">
            <div class="job-card">
                <h3>Job Title</h3>
                <p><b style="color: black;">Company Name</b></p>

                <div>
                    <span>Location</span>
                    <span>Part-time/Full-time</span>
                </div>

                <button>View Details</button>
            </div>
        </div>

    </div>

</div>

</body>
</html>