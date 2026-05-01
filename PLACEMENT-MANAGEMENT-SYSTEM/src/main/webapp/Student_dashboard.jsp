<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Dashboard</title>

  <link rel="stylesheet" href="Student_dashboard.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<%
    // OPTIONAL: Session check (recommended)
    String user = (String) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<body>

<!-- DASHBOARD CONTAINER -->
<div class="dashboard-container">

  <!-- LEFT SIDEBAR -->
  <div class="sidebar">
    <h2>Student Dashboard</h2>

    <ul>
      <li>Dashboard</li>
      <li>Placements</li>
      <li>My Applications</li>
    </ul>
  </div>

  <!-- MAIN AREA -->
  <div class="main-area">

    <!-- TOP BAR -->
    <div style="display:flex; justify-content:flex-end; padding:15px; background:#03352f; color:white;">
      <div style="display:flex; align-items:center; gap:30px;">
        <i class="fa fa-user-circle" style="font-size:25px;"></i>

        <!-- SHOW USER EMAIL -->
        <span><%= user %></span>

        <i class="fa fa-bell" style="font-size:25px;"></i>

        <!-- LOGOUT -->
        <form action="LogoutServlet" method="post" style="display:inline;">
          <button style="background:none; border:none; color:white; cursor:pointer;">
            Logout
          </button>
        </form>

      </div>
    </div>

    <!-- BODY CONTENT -->
    <div class="content">

      <!-- WELCOME BOX -->
      <div class="welcome-box">
        <h1>WELCOME BACK !</h1>
        <p>Explore placements, apply for jobs, and build your career</p>
      </div>

      <!-- STATS -->
      <div class="stats">

        <div class="card"><b>Applied Jobs:</b> 5</div>
        <div class="card"><b>Shortlisted:</b> 2</div>
        <div class="card"><b>Open Jobs:</b> 12</div>

      </div>

      <!-- COMPANY INSIGHTS -->
      <section class="insights-container">
        <h1>COMPANY INSIGHTS</h1>

        <div class="insights-grid">
          <div class="company-card">
            <div class="company-icon color-google">G</div>
            <div class="company-info">
              <h3 class="company-header">Google: 25+ LPA</h3>
              <p class="detail-text"><strong>Focus:</strong> Algorithms & Systems</p>
            </div>
          </div>

          <div class="company-card">
            <div class="company-icon color-microsoft">M</div>
            <div class="company-info">
              <h3 class="company-header">Microsoft: 22+ LPA</h3>
              <p class="detail-text"><strong>Focus:</strong> Project Experience</p>
            </div>
          </div>
        </div>

        <div class="insights-grid">
          <div class="company-card">
            <div class="company-icon color-amazon">A</div>
            <div class="company-info">
              <h3 class="company-header">Amazon: 20+ LPA</h3>
              <p class="detail-text"><strong>Focus:</strong> Problem Solving</p>
            </div>
          </div>

          <div class="company-card">
            <div class="company-icon color-Deloitte">D</div>
            <div class="company-info">
              <h3 class="company-header">Deloitte: 18+ LPA</h3>
              <p class="detail-text"><strong>Focus:</strong> Problem Solving</p>
            </div>
          </div>
        </div>
      </section>

      <!-- PLACEMENTS -->
      <div class="list-box">
        <h1>LATEST PLACEMENTS OPPORTUNITIES</h1>
        <ul>
          <li>TCS - Software Engineer</li>
          <li>Infosys - Analyst</li>
          <li>Wipro - Developer</li>
          <li>Accenture - Consultant</li>
          <li>Cognizant - Engineer</li>
          <li>HCL - Specialist</li>
        </ul>
      </div>

    </div>

  </div>

</div>

</body>
</html>