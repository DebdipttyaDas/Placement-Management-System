<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%!
    private Connection getJspConnection() throws Exception {
        java.util.Properties prop = new java.util.Properties();
        try (java.io.InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) prop.load(input);
        }
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(prop.getProperty("url"), prop.getProperty("username"), prop.getProperty("password"));
    }
%>
<%
    HttpSession sess = request.getSession(false);
    String sessionUser = (sess != null) ? (String) sess.getAttribute("user") : null;
    if (sessionUser == null) {
        response.sendRedirect("Login.jsp?role=admin");
        return;
    }

    String dbAdminName = "";
    String dbUserName = sessionUser;
    String dbEmail = "";
    String dbPhone = "";

    try (Connection conn = getJspConnection()) {
        String sql = "SELECT adminName, userName, email, phone FROM ADMIN_PROFILE WHERE userName = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionUser);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dbAdminName = rs.getString("adminName");
                    dbUserName = rs.getString("userName");
                    dbEmail = rs.getString("email");
                    dbPhone = rs.getString("phone");
                }
            }
        }
    } catch (Exception e) {
        System.err.println("Error loading admin profile: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Profile</title>

<link rel="stylesheet" href="AdminProfile.css">

</head>

<body>

<!-- Navbar -->
<header class="navbar">
    <h2>Admin Profile</h2>

    <div class="nav-buttons">
        <button class="nav-btn"><a href="AdminDashboard.jsp" class="nav-btn" style="text-decoration:none;">Back to dashboard</a></button>
         <button class="save-btn" onclick="document.getElementById('adminProfileForm').submit();">Save Profile</button>
    </div>
</header>

<!-- Profile Container -->
<div class="profile-container">

    <div class="profile-card">

        <h2>Edit Profile</h2>

        <form id="adminProfileForm" action="AdminProfileServlet" method="post">

            <label>Admin Name</label>
            <input type="text" name="adminName" placeholder="Enter Admin Name" value="<%= dbAdminName %>" required>

            <label>Username</label>
            <input type="text" name="userName" placeholder="Enter Username" value="<%= dbUserName %>" required>

            <label>Email</label>
            <input type="email" name="email" placeholder="Enter Email" value="<%= dbEmail %>" required>

            <label>Password</label>
            <input type="password" name="password" placeholder="Enter Password">

            <label>Phone Number</label>
            <input type="text" name="phone" placeholder="Enter Phone Number" value="<%= dbPhone %>">

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

<script src="AdminProfile.js"></script>

</body>
</html>
