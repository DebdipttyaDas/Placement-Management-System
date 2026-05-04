<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Placement Management System</title>

    <link rel="stylesheet" href="AdminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<!-- Sidebar -->
<nav class="sidebar">
    <div class="logo">
        <h2>Admin Dashboard</h2>
        <br>
    </div>

    <ul class="nav-menu">
        <li class="active">Dashboard</li>
        <li>Students</li>
        <li>Companies</li>
        <li>Placements</li>
        <li>Applications</li>
        <li>Interviews</li>
    </ul>

    <!-- Logout -->
    <form action="LogoutServlet" method="post">
        <button class="logout-btn">Logout</button>
    </form>
</nav>

<!-- Main Content -->
<main class="main-content">

    <!-- Top Bar -->
    <header class="top-bar">
        <h1>Welcome Admin!</h1>

        <div class="user-profile">
            <a href="AdminProfile.jsp">
                <i class="fa fa-user-circle" style="font-size:25px; color:black;"></i>
            </a>
            <i class="fa fa-bell" style="font-size:25px;"></i>
        </div>
    </header>

    <!-- Stats -->
    <section class="stats-container">
        <div class="stat-card">
            <h3>Total Students</h3>
            <p class="count">1,200</p>
            <span class="trend">+120 this month</span>
        </div>

        <div class="stat-card">
            <h3>Total Companies</h3>
            <p class="count">45</p>
            <span class="trend">+6 this month</span>
        </div>

        <div class="stat-card">
            <h3>Active Jobs</h3>
            <p class="count">120</p>
            <span class="trend">+15 this month</span>
        </div>

        <div class="stat-card">
            <h3>Placed Students</h3>
            <p class="count">300</p>
            <span class="trend">+40 this month</span>
        </div>
    </section>

    <!-- Charts -->
    <section class="charts-container">

        <div class="chart-box">
            <h3>Placement Rate</h3>
            <br><br><br>
            <canvas id="barChart"></canvas>
        </div>

        <div class="chart-box">
            <h3>Students per Department</h3>
            <br><br><br>
            <canvas id="pieChart"></canvas>
        </div>

        <div class="chart-box">
            <h3>Job Postings (Monthly)</h3>
            <br><br><br>
            <canvas id="lineChart"></canvas>
        </div>

    </section>

    <!-- Pending Companies Approvals -->
    <section class="drives-container">
        <div class="section-header">
            <h3>Pending Company Approvals</h3>
        </div>
        
        <%
            String msgSuccess = request.getParameter("success");
            String msgError = request.getParameter("error");
            if (msgSuccess != null) { out.println("<p style='color:green; padding:10px;'>" + msgSuccess + "</p>"); }
            if (msgError != null) { out.println("<p style='color:red; padding:10px;'>" + msgError + "</p>"); }
        %>

        <table style="margin-bottom: 20px;">
            <thead>
                <tr>
                    <th>Company Name</th>
                    <th>Industry</th>
                    <th>Email</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/placement_management", "root", "root");
                        PreparedStatement ps = conn.prepareStatement("SELECT id, company_name, industry, email FROM companies WHERE status = 'PENDING'");
                        ResultSet rs = ps.executeQuery();
                        boolean hasPending = false;
                        while(rs.next()) {
                            hasPending = true;
                %>
                <tr>
                    <td><%= rs.getString("company_name") %></td>
                    <td><%= rs.getString("industry") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td>
                        <form action="ApproveCompanyServlet" method="post" style="display:inline;">
                            <input type="hidden" name="companyId" value="<%= rs.getInt("id") %>">
                            <button type="submit" style="padding:5px 10px; background-color:#28a745; color:white; border:none; border-radius:3px; cursor:pointer;">Approve</button>
                        </form>
                    </td>
                </tr>
                <%      }
                        if (!hasPending) {
                %>
                <tr>
                    <td colspan="4" style="text-align:center;">No pending approvals</td>
                </tr>
                <%
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='4'>Error loading pending companies: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </section>

    <!-- Drives -->
    <section class="drives-container">
        <div class="section-header">
            <h3>Upcoming Drives</h3>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Company</th>
                    <th>Role</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
                <tr>
                    <td>TCS</td>
                    <td>Software Engineer</td>
                    <td>20 May, 2024</td>
                    <td><span class="status-scheduled">Scheduled</span></td>
                </tr>

                <tr>
                    <td>Microsoft</td>
                    <td>SDE Intern</td>
                    <td>28 May, 2024</td>
                    <td><span class="status-scheduled">Scheduled</span></td>
                </tr>      
                <tr>
                        <td>Infosys</td>
                        <td>System Engineer</td>
                        <td>05 Jun, 2024</td>
                        <td><span class="status-scheduled">Scheduled</span></td>
                    </tr>
                    <tr>
                        <td>Wipro</td>
                        <td>Project Engineer</td>
                        <td>12 Jun, 2024</td>
                        <td><span class="status-upcoming">Upcoming</span></td>
                    </tr>
                    <tr>
                        <td>Accenture</td>
                        <td>Software Developer</td>
                        <td>15 Jun, 2024</td>
                        <td><span class="status-upcoming">Upcoming</span></td>
                    </tr>
                    <tr>
                        <td>Cognizant</td>
                        <td>Junior Developer</td>
                        <td>20 Jun, 2024</td>
                        <td><span class="status-upcoming">Upcoming</span></td>
                    </tr>
            </tbody>
        </table>
    </section>

    <!-- Notifications -->
    <section class="notifications-container">

        <div class="section-header">
            <h3>Notifications</h3>
            <button>View All</button>
        </div>

        <div class="notification-list">

            <div class="notification-card">
                <i class="fa fa-bell"></i>
                <div>
                    <p>New job posted by TCS</p>
                    <span>2 hours ago</span>
                </div>
            </div>

            <div class="notification-card">
                <i class="fa fa-user"></i>
                <div>
                    <p>New student registered</p>
                    <span>5 hours ago</span>
                </div>
            </div>

<div class="notification-card">
            <i class="fa fa-building"></i>
            <div>
                <p>Microsoft scheduled a drive</p>
                <span>Yesterday</span>
            </div>
        </div>

        </div>

    </section>

</main>

<!-- Chart JS -->
<script>
new Chart(document.getElementById("barChart"), {
    type: "bar",
    data: {
        labels: ["Jan","Feb","Mar","Apr","May","Jun"],
        datasets: [{
            label: "Placement %",
            data: [40, 55, 60, 50, 70, 80]
        }]
    }
});

new Chart(document.getElementById("pieChart"), {
    type: "pie",
    data: {
        labels: ["CSE","BCA","MCA","BBA","MBA","IT","ECE"],
        datasets: [{
            data: [40, 25, 20, 15, 10, 12,10]
        }]
    }
});

new Chart(document.getElementById("lineChart"), {
    type: "line",
    data: {
        labels: ["Jan","Feb","Mar","Apr","May","Jun"],
        datasets: [{
            label: "Jobs Posted",
            data: [10, 20, 15, 25, 30, 35],
            fill: false
        }]
    }
});
</script>

</body>
</html>