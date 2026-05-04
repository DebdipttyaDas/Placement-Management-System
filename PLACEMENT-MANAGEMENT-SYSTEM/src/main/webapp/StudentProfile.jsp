<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Profile Settings</title>
  <link rel="stylesheet" href="StudentProfile.css">
</head>

<body>

<div class="container">

  <!-- Sidebar -->
  <div class="sidebar-card">
    <h2>Student Profile</h2>

    <ul>
       <li><a href="Student_dashboard.jsp" style="color: white;text-decoration: none;">Dashboard</a></li>
        <li><a href="Placement.jsp" style="color: white;text-decoration: none;">Placement</a></li>
        <li><a href="MyApplications.jsp" style="color: white;text-decoration: none;">My Applications</a></li>
    </ul>

    <!-- Logout -->
    <form action="LogoutServlet" method="post">
      <button class="logout-btn">Logout</button>
    </form>
  </div>

  <!-- Main Content -->
  <div class="main-content">

    <!-- HEADER CARD -->
    <div class="header-card">
      <div class="header-left">
        <h1>Profile Settings</h1>
      </div>

      <div class="btn-group">
        <!-- FIXED BUTTON -->
        <a href="Student_dashboard.jsp" class="nav-btn">Back to Dashboard</a>

        <!-- Save Button connected to form -->
        <button type="submit" form="profileForm">Save Profile</button>
      </div>
    </div>

    <!-- FORM START -->
    <form id="profileForm" action="UpdateProfileServlet" method="post" enctype="multipart/form-data">

      <!-- AVATAR CARD -->
      <div class="card avatar-card">
        <h2>Profile Picture</h2>
        <p>JPG or PNG. Max size 2MB</p>

        <div class="avatar-box">

          <!-- <img src="uploads/profile.jpg"> -->
        </div>

        <input type="file" name="photo" class="upload-btn">
      </div>

      <!-- PERSONAL INFO -->
      <div class="card">
        <h2>Personal Information</h2>

        <input type="text" name="name" placeholder="Your name">
        <input type="email" name="email" placeholder="Your email">
        <input type="password" name="password" placeholder="Your password">
        <input type="password" name="confirmPassword" placeholder="Confirm password">
      </div>

      <!-- ACADEMIC -->
      <div class="card">
        <h2>Academic Records</h2>

        <input type="text" name="department" placeholder="Department">
        <input type="text" name="cgpa" placeholder="CGPA">
      </div>

      <!-- LANGUAGES -->
      <div class="card">
        <h2>Languages Known</h2>

        <input type="text" name="languages" placeholder="English, Bengali, Hindi">
      </div>

      <!-- SKILLS -->
      <div class="card">
        <h2>Professional Skills</h2>

        <input type="text" name="skill1" placeholder="Skill 1">
        <input type="text" name="skill2" placeholder="Skill 2">
        <input type="text" name="skill3" placeholder="Skill 3">
        <input type="text" name="skill4" placeholder="Skill 4">
        <input type="text" name="otherSkills" placeholder="Other skills">
      </div>

    </form>
    <!-- FORM END -->

  </div>
</div>

</body>
</html>