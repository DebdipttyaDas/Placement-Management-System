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
        <button class="nav-btn"><a href="AdminDashboard.jsp" class="nav-btn" style="text-decoration:none;">Back to dashboard</a></button>
         <button class="save-btn">Save Profile</button>
    </div>
</header>

<!-- Profile Container -->
<div class="profile-container">

    <div class="profile-card">

        <h2>Edit Profile</h2>

        <form>

            <label>Admin ID</label>
            <input type="text" placeholder="Enter Admin ID">


            <label>Username</label>
            <input type="text" placeholder="Enter Username">

            <label>Email</label>
            <input type="email" placeholder="Enter Email">

            <label>Password</label>
            <input type="password" placeholder="Enter Password">

            <label>Phone Number</label>
            <input type="number" placeholder="Enter Phone Number">


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