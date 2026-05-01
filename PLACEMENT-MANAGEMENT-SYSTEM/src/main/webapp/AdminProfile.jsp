<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Profile</title>

<link rel="stylesheet" href="AdminProfile.css">

</head>

<body>

<!-- Navbar -->
<header class="navbar">
    <h2>Admin Profile</h2>

    <div class="nav-buttons">
        <!-- FIXED: anchor as button -->
        <a href="AdminDashboard.html" class="nav-btn">Back to Dashboard</a>
        
    </div>
</header>

<!-- Profile Container -->
<div class="profile-container">

    <div class="profile-card">

        <h2>Edit Profile</h2>

        <!-- FORM START -->
        <form action="AdminProfileServlet" method="post">

            <label>Admin ID</label>
            <input type="text" name="adminId" placeholder="Enter Admin ID" required>

            <label>Username</label>
            <input type="text" name="username" placeholder="Enter Username" required>

            <label>Email</label>
            <input type="email" name="email" placeholder="Enter Email" required>

            <label>Password</label>
            <input type="password" name="password" placeholder="Enter Password" required>

            <label>Phone Number</label>
            <input type="text" name="phone" placeholder="Enter Phone Number">

            <!-- SAVE BUTTON -->
            <button type="submit" class="save-btn">Save Profile</button>

        </form>
        <!-- FORM END -->

        <!-- ERROR / SUCCESS MESSAGE -->
        <%
            String msg = (String) request.getAttribute("message");
            if(msg != null){
        %>
            <p style="color: green; text-align:center; margin-top:10px;"><%= msg %></p>
        <%
            }
        %>

    </div>

</div>

</body>
</html>