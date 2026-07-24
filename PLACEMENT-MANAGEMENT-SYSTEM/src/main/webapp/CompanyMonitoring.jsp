<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Company Monitoring</title>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="CompanyMonitoring.css">

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script src="CompanyMonitoring.js"></script>

</head>

<body>

    <!-- SIDEBAR -->
    <nav class="sidebar">

        <div class="logo">
            <h2 class="text-2xl font-bold mb-3">Company Monitoring</h2>
        </div>

        <ul class="nav-menu">
            <li><a href="AdminDashboard.jsp">Dashboard</a></li>
            <li class="active">Company Monitoring</li>
            <li><a href="StudentMonitoring.jsp">Student Monitoring</a></li>
            <li><a href="PlacementAnalysis.jsp">Placement Analysis</a></li>
        </ul>

        <form action="LogoutServlet" method="post">
            <button class="logout-btn">Logout</button>
        </form>

    </nav>

    <!-- MAIN AREA -->
    <div class="main-area">

        <div class="company-wrapper">

            <h1 class="company-heading">Company Post</h1>

            <div class="company-box">

                <!-- SEARCH -->
                <div class="search-bar">
                    <i class="fa fa-search search-icon"></i>
                    <input
                        type="text"
                        id="companySearch"
                        placeholder="Search by company name..."
                        onkeyup="searchCompany()">
                </div>

                <!-- CARD CONTAINER -->
                <div class="card-container">

<%

Connection conn = null;
Statement st = null;
ResultSet rs = null;

try{
    Class<?> dbUtilClass = Class.forName("DBUtil");
    conn = (Connection) dbUtilClass.getMethod("getConnection").invoke(null);

    st = conn.createStatement();

    rs = st.executeQuery(
        "SELECT * FROM JOB_DETAILS ORDER BY JOB_ID DESC"
    );

    while(rs.next()){

%>

                    <div class="job-card">

                        <div class="tags">

                            <h2 class="company-name">
                                <%= rs.getString("companyName") %>
                            </h2>

                            <p>
                                <strong>
                                    <%= rs.getString("jobTitle") %>
                                </strong>
                            </p>

                            <p>
                                <%= rs.getString("employmentType") %>
                            </p>

                        </div>

                        <button class="view-btn"
                                onclick="toggleCard(this)">
                            View Details
                        </button>

                        <div class="extra-details">

                            <p>
                                <strong>Department:</strong>
                                <%= rs.getString("department") %>
                            </p>

                            <p>
                                <strong>Location Type:</strong>
                                <%= rs.getString("LocationType") %>
                            </p>

                            <p>
                                <strong>Location:</strong>
                                <%= rs.getString("Location") %>
                            </p>

                            <p>
                                <strong>Salary:</strong>
                                <%= rs.getString("salary") %>
                            </p>

                            <p>
                                <strong>Deadline:</strong>
                                <%= rs.getString("applicationDeadline") %>
                            </p>

                            <button class="close-btn"
                                    onclick="toggleCard(this)">
                                Close Details
                            </button>

                        </div>

                    </div>

<%
    }
}
catch(Exception e){
    out.println("<p style='color:red'>Error : " + e.getMessage() + "</p>");
}
finally{

    try{
        if(rs != null) rs.close();
    }catch(Exception e){}

    try{
        if(st != null) st.close();
    }catch(Exception e){}

    try{
        if(conn != null) conn.close();
    }catch(Exception e){}
}
%>

                </div>

            </div>

        </div>

    </div>

</body>
</html>
