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
        <li><a href="Student_dashboard.jsp" style="text-decoration:none; color:white">Dashboard</a></li>
        <li><a href="#" style="text-decoration:none; color:white">Placements</a></li>
        <li><a href="MyApplication.jsp" style="text-decoration:none; color:white">My Applications</a></li>
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

<!-- Chatbot -->
<link rel="stylesheet" href="chatbot.css">

<div id="chatbot-toggle">
    <i class="fas fa-robot"></i>
</div>

<div id="chatbot-container">
    <div class="chatbot-header">
        <h3>AI Assistant</h3>
        <button class="chatbot-close">&times;</button>
    </div>
    <div class="chatbot-messages">
        <!-- Messages will be added here -->
    </div>
    <div class="chatbot-input-area">
        <input type="text" class="chatbot-input" placeholder="Type your message...">
        <button class="chatbot-send">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
</div>

<script src="chatbot.js"></script>

</body>
</html>