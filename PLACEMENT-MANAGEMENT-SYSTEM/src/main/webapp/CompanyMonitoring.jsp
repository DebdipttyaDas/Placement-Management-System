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

<body>

<div class="page-container">

    <!-- SIDEBAR -->
    <nav class="sidebar">
        <div class="logo">
            <h2 class="text-2xl font-bold mb-3">Company Monitoring</h2>
        </div>
        <ul class="nav-menu">
            <li><a href="AdminDashboard.jsp">Dashboard</a></li>
            <li class="active">Company Monitoring</li>
            <li><a href="StudentMonitoring.jsp">Student Monitoring</a></li>
            <li><a href="#" style="text-decoration: none; color: white;">Notifications</a></li>
        </ul>
        <!-- Logout -->
        <form action="LogoutServlet" method="post">
            <button class="logout-btn">Logout</button>
        </form>
    </nav>

    <!-- MAIN AREA -->
    <div class="main-area">

        <div class="company-wrapper">

            <h1 class="company-heading">Company Post</h1>

            <!-- CONTENT -->

            <!-- GREEN BOX -->
            <div class="company-box">

                <!-- SEARCH BAR -->
                <div class="search-bar">
                    <i class="fa fa-search search-icon"></i>
                    <input type="text" id="companySearch" placeholder="Search by company name..." onkeyup="searchCompany()">
                </div>

            </div>

        </div>

    </div>

</div>

<script>
function searchCompany() {
    const query = document.getElementById("companySearch").value.toLowerCase();
    const cards = document.querySelectorAll(".job-card");
    cards.forEach(function(card) {
        const name = card.querySelector(".company-name");
        if (name) {
            card.style.display = name.textContent.toLowerCase().includes(query) ? "" : "none";
        }
    });
}
</script>

</body>
</html>
