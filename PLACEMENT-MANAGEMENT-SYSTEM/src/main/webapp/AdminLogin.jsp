<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Admin Login</title>

<link rel="stylesheet" href="AdminLogin.css">

<script src="Login.js"></script>

</head>

<body class="login-body">

<div class="page-container">
<div class="main-wrapper">

    <!-- Navbar -->
    <header class="navbar">

        <h1 class="logo">CampusConnect</h1>

        <div class="nav-link">
            <a href="Login.jsp">Back to home</a>
        </div>

    </header>

    <!-- Main -->
    <main class="main-container">

        <div class="content-box">

            <h1 class="heading">Welcome Admin !</h1>

            <p class="subtext">
                <b>Secure Access for Administration Panel</b>
            </p>

            <!-- Login Form -->
            <form action="LoginServlet" method="post">

                <!-- Card -->
                <div class="glass-card card">

                    <!-- Hidden Role -->
                    <input type="hidden" name="role" value="admin">

                    <!-- Admin ID -->
                    <div class="input-group">

                        <label>USERNAME</label>

                        <input 
                            type="text"
                            name="userName"
                            placeholder="Enter Username"
                            required
                            style="color: white;"
                        >

                    </div>

                    <!-- Password -->
                    <div class="input-group">

                        <div class="password-header">

                            <label>PASSWORD</label>

                            <a href="#">Forgot?</a>

                        </div>

                        <input 
                            type="password"
                            name="password"
                            placeholder="Enter password"
                            required
                        >

                    </div>

                    <!-- Error Message -->
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>

                        <p style="color:#ffb3b3; font-size:13px; margin-top:8px;">
                            <%= error %>
                        </p>

                    <%
                        }
                    %>

                    <!-- Button -->
                    <button type="submit" class="login-btn">
                        Access Portal
                    </button>

                </div>

            </form>

        </div>

    </main>

</div>
</div>

</body>
</html>