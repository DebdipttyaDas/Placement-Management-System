<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Company Monitoring</title>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="CompanyMonitoring.css">

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

.job-card{
    width:300px;
    background:#fff;
    border:1px solid #ddd;
    border-radius:10px;
    padding:20px;
    margin:15px;
    transition:all 0.4s ease;
}

.extra-details{
    max-height:0;
    overflow:hidden;
    opacity:0;
    transition:all 0.4s ease;
}

.job-card.active .extra-details{
    max-height:500px;
    opacity:1;
    margin-top:15px;
}

.job-card.active{
    transform:translateY(-5px);
}

.view-btn,
.apply-btn,
.close-btn{
    width:100%;
    padding:10px;
    border:none;
    border-radius:5px;
    cursor:pointer;
    margin-top:10px;
}

.view-btn,
.apply-btn{
    background:#0d5bd7;
    color:white;
}

.close-btn{
    background:#777;
    color:white;
}

.card-container{
    display:flex;
    flex-wrap:wrap;
    gap:20px;
}

</style>

<script>
function toggleCard(button){

    const card = button.closest(".job-card");
    const viewBtn = card.querySelector(".view-btn");

    card.classList.toggle("active");

    if(card.classList.contains("active")){
        viewBtn.style.display = "none";
    }else{
        viewBtn.style.display = "block";
    }
}
</script>

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
            <li><a href="#" style="text-decoration:none;color:white;">Notifications</a></li>
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

    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/placement_management",
        "root",
        "root"
    );

    st = conn.createStatement();

    rs = st.executeQuery(
        "SELECT * FROM jobs ORDER BY id DESC"
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

                            <button class="apply-btn">
                                Apply Now
                            </button>

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

</div>

<script>

function searchCompany(){

    const query =
        document.getElementById("companySearch")
        .value
        .toLowerCase();

    const cards =
        document.querySelectorAll(".job-card");

    cards.forEach(function(card){

        const company =
            card.querySelector(".company-name");

        if(company){

            card.style.display =
                company.textContent
                .toLowerCase()
                .includes(query)
                ? "block"
                : "none";
        }
    });
}

</script>

</body>
</html>