<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Company Monitoring</title>

    <!-- Tailwind External CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- External CSS -->
    <link rel="stylesheet" href="CompanyMonitoring.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body >

<div class="page-container">

    <!-- SIDEBAR -->
    
    <nav class="sidebar">
    <div class="logo">
        <h2 class="text-2xl font-bold mb-3">Company Monitoring</h2>        
    </div>
    <ul class="nav-menu">
        <li ><a href ="AdminDashboard.jsp">Dashboard</a></li>
        <li class="active">Company Monitoring</li>
        <li><a href="StudentMonitoring.html">Student Monitoring</a></li>
        <li>Notifications</li>
    </ul>       
       <!-- Logout -->
    <form action="LogoutServlet" method="post">
        <button class="logout-btn">Logout</button>
    </form>
</nav>
       
    <!-- MAIN AREA -->
    <div class="main-area flex-1">

<div class="company-wrapper">

<h1 class="company-heading">
                        Company Post
                    </h1>

        <!-- CONTENT -->
        

            <!-- GREEN BOX -->
            <div class="company-box">

                <!-- JOBS -->
                <div class="space-y-6">

                    <%
                        java.util.ArrayList<java.util.HashMap<String, String>> jobs =
                        (java.util.ArrayList<java.util.HashMap<String, String>>)
                        request.getAttribute("jobs");

                        if(jobs != null && jobs.size() > 0){

                            for(java.util.HashMap<String, String> job : jobs){
                    %>

                    <!-- JOB CARD -->
                    <div class="job-card">

                        <div class="flex justify-between items-center">

                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    <%= job.get("job_title") %>
                                </h2>

                                <p class="text-gray-600 mt-1">
                                    <%= job.get("department") %>
                                </p>
                            </div>

                            <span class="job-type">
                                <%= job.get("employment_type") %>
                            </span>

                        </div>

                        <div class="grid grid-cols-2 gap-6 mt-6">

                            <div>
                                <p class="label">Location</p>
                                <p class="value">
                                    <%= job.get("location") %>
                                </p>
                            </div>

                            <div>
                                <p class="label">Work Type</p>
                                <p class="value">
                                    <%= job.get("location_type") %>
                                </p>
                            </div>

                            <div>
                                <p class="label">Salary</p>
                                <p class="value">
                                    ₹ <%= job.get("salary") %>
                                </p>
                            </div>

                        </div>

                    </div>

                    <%
                            }

                        } else {
                    %>

                    <div class="empty-box">                      

                    </div>

                    <%
                        }
                    %>

                </div>

            </div>


    </div>

</div>
</div>
</body>
</html>