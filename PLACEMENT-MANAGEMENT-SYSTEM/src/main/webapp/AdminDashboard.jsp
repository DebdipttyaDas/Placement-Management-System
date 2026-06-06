<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    if (request.getAttribute("totalStudents") == null) {
        request.getRequestDispatcher("AdminDashboardServlet").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin dashboard</title>

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
        <li><a href="CompanyMonitoring.jsp">Company Monitoring</a></li>
        <li><a href="StudentMonitoring.jsp">Student Monitoring</a></li>
        <li><a href="#" style="text-decoration: none; color: white;">Notifications</a></li>
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
        </div>
    </header>

    <!-- Stats -->
    <section class="stats-container">
        <div class="stat-card">
            <h3>Total Students</h3>
            <p class="count"><%= request.getAttribute("totalStudents") %></p>
            <span class="trend"><%= request.getAttribute("studentsTrend") %></span>
        </div>

        <div class="stat-card">
            <h3>Total Companies</h3>
            <p class="count"><%= request.getAttribute("totalCompanies") %></p>
            <span class="trend"><%= request.getAttribute("companiesTrend") %></span>
        </div>

        <div class="stat-card">
            <h3>Active Jobs</h3>
            <p class="count"><%= request.getAttribute("activeJobs") %></p>
            <span class="trend"><%= request.getAttribute("jobsTrend") %></span>
        </div>

        <div class="stat-card">
            <h3>Placed Students</h3>
            <p class="count"><%= request.getAttribute("placedStudents") %></p>
            <span class="trend"><%= request.getAttribute("placedTrend") %></span>
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
                    List<Map<String, String>> pendingCompanies = (List<Map<String, String>>) request.getAttribute("pendingCompanies");
                    boolean hasPending = false;
                    if (pendingCompanies != null && !pendingCompanies.isEmpty()) {
                        for (Map<String, String> company : pendingCompanies) {
                            hasPending = true;
                %>
                <tr>
                    <td><%= company.get("company_name") %></td>
                    <td><%= company.get("industry") %></td>
                    <td><%= company.get("email") %></td>
                    <td>
                        <form action="ApproveCompanyServlet" method="post" style="display:inline;">
                            <input type="hidden" name="companyId" value="<%= company.get("id") %>">
                            <button type="submit" style="padding:5px 10px; background-color:#28a745; color:white; border:none; border-radius:3px; cursor:pointer;">Approve</button>
                        </form>
                    </td>
                </tr>
                <%      }
                    }
                    if (!hasPending) {
                %>
                <tr>
                    <td colspan="4" style="text-align:center;">No pending approvals</td>
                </tr>
                <%
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
                <%
                    List<Map<String, String>> upcomingDrives = (List<Map<String, String>>) request.getAttribute("upcomingDrives");
                    if (upcomingDrives != null && !upcomingDrives.isEmpty()) {
                        for (Map<String, String> drive : upcomingDrives) {
                            String statusClass = "SCHEDULED".equalsIgnoreCase(drive.get("status")) ? "status-scheduled" : "status-upcoming";
                %>
                <tr>
                    <td><%= drive.get("company_name") %></td>
                    <td><%= drive.get("interview_round") %></td>
                    <td><%= drive.get("interview_date") %></td>
                    <td><span class="<%= statusClass %>"><%= drive.get("status") %></span></td>
                </tr>
                <%
                        }
                    } else {
                %>
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
                <%
                    }
                %>
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
            <%
                List<Map<String, String>> notifications = (List<Map<String, String>>) request.getAttribute("notifications");
                if (notifications != null && !notifications.isEmpty()) {
                    for (Map<String, String> note : notifications) {
                        String iconClass = "fa fa-bell";
                        if ("student".equals(note.get("type"))) {
                            iconClass = "fa fa-user";
                        } else if ("building".equals(note.get("type"))) {
                            iconClass = "fa fa-building";
                        }
            %>
            <div class="notification-card">
                <i class="<%= iconClass %>"></i>
                <div>
                    <p><%= note.get("message") %></p>
                    <span><%= note.get("time") %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
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
            <%
                }
            %>
        </div>

    </section>

</main>

<!-- Chart JS -->
<script>
    var barChartLabels = <%= request.getAttribute("barChartLabels") %>;
    var barChartData = <%= request.getAttribute("barChartData") %>;
    var pieChartLabels = <%= request.getAttribute("pieChartLabels") %>;
    var pieChartData = <%= request.getAttribute("pieChartData") %>;
    var lineChartLabels = <%= request.getAttribute("lineChartLabels") %>;
    var lineChartData = <%= request.getAttribute("lineChartData") %>;
</script>
<script src="AdminDashboard.js"></script>

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