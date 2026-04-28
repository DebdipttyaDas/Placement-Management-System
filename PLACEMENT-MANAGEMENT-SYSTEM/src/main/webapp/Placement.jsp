<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Placements</title>

  <!-- CSS -->
  <link rel="stylesheet" href="Placement.css">

  <!-- ❌ REMOVE THIS (online) -->
  <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"> -->

</head>

<body>

<!-- DASHBOARD CONTAINER -->
<div class="dashboard-container">

  <!-- SIDEBAR -->
  <div class="sidebar">
    <h2>Placements</h2>

    <ul>
      <li>Dashboard</li>
      <li>Placements</li>
      <li>My Applications</li>
    </ul>
  </div>

  <!-- TOP BAR -->
  <div class="topbar">
  <div class="topbar-icons">
    <span class="icon">👤</span>
    <span class="icon">🔔</span>
  </div>
</div>

  <!-- MAIN -->
  <div class="main">

    <!-- SEARCH -->
    <div class="search-box">
      <input type="text" placeholder="Search for job titles or companies...">
    </div>

    <!-- FILTERS -->
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
          <span>Full-time</span>
        </div>

        <button>View Details</button>
      </div>
    </div>

  </div>

</div>

</body>
</html>