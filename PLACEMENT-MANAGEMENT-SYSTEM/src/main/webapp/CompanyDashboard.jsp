<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Company Dashboard</title>

<link rel="stylesheet" href="CompanyDashboard.css">

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="container">

    <!-- Side bar -->
    <div class="sidebar">

        <h2>Company Portal</h2>

        <br><br>

        <ul class="menu">
            <li class="active">
            
            Dashboard
        </li>

        <li >
            <a href="JobPost.jsp"
            style="text-decoration: none; color: white;"> Job Post</a>
        </li>

        <li>
            <a href="Interviews.jsp"
            style="text-decoration: none; color: white;">Interviews</a>
        </li>
        
        <li >
        <a href="PlacementAnalysis.jsp" 
        	style="text-decoration: none; color: white;">Placement Analysis </a>
                        
           
        </li>
        </ul>
<!-- LOGOUT -->
    <div class="logout">

        <button>
            Logout
        </button>

    </div>


    </div>

    <!-- Main Content -->
    <div class="main-content">

        <!-- Topbar -->
        <div class="topbar">

            <h2>Company Dashboard</h2>

            <div class="top-icons">
                <i class="fa fa-user-circle profile"></i>
                <i class="fa fa-bell bell"></i>
            </div>

        </div>

        <!-- CENTER BODY CONTENT START -->
        <div class="page">

            <!-- Hero Section -->
            <div class="hero">

                <div class="hero">
                    <span class="particle"></span>
                    <span class="particle"></span>
                    <span class="particle"></span>
                </div>

                <div>
                    <div class="hero-label">Company Dashboard</div>

                    <h1>Hello, Google Recruiting</h1>

                    <p>
                        Here is your recruitment overview for the current placement season.
                    </p>
                </div>

                <div class="hero-content">
                    <button class="btn btn-white">
                        + Post new jobs
                    </button>
                </div>

                <div class="hero-actions">
                    <button class="btn btn-white">
                        Review Applications
                    </button>
                </div>

            </div>

            <!-- Stats -->
            <div class="stats-row">

                <div class="stat-card">

                    <div class="stat-icon blue">
                        <svg width="22" height="22" fill="none"
                            stroke="#2251d3" stroke-width="2"
                            viewBox="0 0 24 24">

                            <rect x="2" y="7" width="20" height="14" rx="2"/>
                            <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>

                        </svg>
                    </div>

                    <div>
                        <div class="stat-label">Active Drives</div>
                        <div class="stat-value">3</div>
                    </div>

                </div>

                <div class="stat-card">

                    <div class="stat-icon indigo">
                        <svg width="22" height="22" fill="none"
                            stroke="#7c3aed" stroke-width="2"
                            viewBox="0 0 24 24">

                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>

                        </svg>
                    </div>

                    <div>
                        <div class="stat-label">Total Applicants</div>
                        <div class="stat-value">1,248</div>
                    </div>

                </div>

                <div class="stat-card">

                    <div class="stat-icon pink">
                        <svg width="22" height="22" fill="none"
                            stroke="#db2777" stroke-width="2"
                            viewBox="0 0 24 24">

                            <circle cx="9" cy="7" r="4"/>

                        </svg>
                    </div>

                    <div>
                        <div class="stat-label">Hires This Season</div>
                        <div class="stat-value">42</div>
                    </div>

                </div>

            </div>

            <!-- Main Grid -->
            <div class="main-grid">

                <!-- Left -->
                 <!--Drive card 1-->
                <div>

                    <div class="section-header">
                        <span class="section-title">Active Drives</span>
                        <div class="view-actions">

                    <button class="view-btn" onclick="showDrives()">
                         View All
                        </button>

                        <button class="view-btn" onclick="hideDrives()">
                            Hide All
                        </button>

                    </div>
                    </div>
                    <div class="drive-card">
                        <div class="drive-top">
                            <div class="drive-title">Software Engineer – New Grad</div>
                            <span class="badge badge-active">Active</span>
                        </div>

                        <div class="drive-meta">
                            Bangalore, India • Full-time
                        </div>

                        <div class="pipeline-header">
                            <span class="pipeline-label">Pipeline Progress</span>
                            <span class="pipeline-total">850 Total Applicants</span>
                        </div>

                        <div class="pipeline-bar">
                            <div class="seg-applied" style="width:40%"></div>
                            <div class="seg-tech" style="width:30%"></div>
                            <div class="seg-hr" style="width:20%"></div>
                            <div class="seg-offers" style="width:10%"></div>
                        </div>

                        <div class="drive-footer">
                            <a class="manage-link" href="#">Manage Drive</a>
                        </div>
                    </div>
                    
         <!-- Drive Card 2 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">Data Analyst Intern</div>
        <span class="badge badge-active">Active</span>
    </div>

    <div class="drive-meta">
        Hyderabad, India • Internship
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">520 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:45%"></div>
        <div class="seg-tech" style="width:25%"></div>
        <div class="seg-hr" style="width:20%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

</div>


<!-- Drive Card 3 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">UI/UX Designer</div>
        <span class="badge badge-closing">Closing Soon</span>
    </div>

    <div class="drive-meta">
        Pune, India • Full-time
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">310 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:50%"></div>
        <div class="seg-tech" style="width:20%"></div>
        <div class="seg-hr" style="width:20%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

    <!-- Drive Card 4 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">Cyber Security Analyst</div>
        <span class="badge badge-active">Active</span>
    </div>

    <div class="drive-meta">
        Kolkata, India • Full-time
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">640 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:42%"></div>
        <div class="seg-tech" style="width:30%"></div>
        <div class="seg-hr" style="width:18%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

</div>


<!-- Drive Card 5 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">Cloud Engineer</div>
        <span class="badge badge-active">Active</span>
    </div>

    <div class="drive-meta">
        Chennai, India • Full-time
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">780 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:38%"></div>
        <div class="seg-tech" style="width:32%"></div>
        <div class="seg-hr" style="width:20%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

</div>


<!-- Drive Card 6 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">AI/ML Engineer</div>
        <span class="badge badge-closing">Closing Soon</span>
    </div>

    <div class="drive-meta">
        Bengaluru, India • Full-time
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">1,120 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:48%"></div>
        <div class="seg-tech" style="width:26%"></div>
        <div class="seg-hr" style="width:16%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

</div>


<!-- Drive Card 7 -->
<div class="drive-card extra-drive">

    <div class="drive-top">
        <div class="drive-title">Frontend Developer</div>
        <span class="badge badge-active">Active</span>
    </div>

    <div class="drive-meta">
        Remote • Full-time
    </div>

    <div class="pipeline-header">
        <span class="pipeline-label">Pipeline Progress</span>
        <span class="pipeline-total">460 Total Applicants</span>
    </div>

    <div class="pipeline-bar">
        <div class="seg-applied" style="width:44%"></div>
        <div class="seg-tech" style="width:29%"></div>
        <div class="seg-hr" style="width:17%"></div>
        <div class="seg-offers" style="width:10%"></div>
    </div>

    <div class="drive-footer">
        <a class="manage-link" href="#">Manage Drive</a>
    </div>

</div>
</div>
</div>
  <!-- Right -->
            <div>

              <div class="section-header">

    <span class="section-title">Today's Interviews</span>

    <div class="view-actions">

        <button class="view-btn" onclick="showInterviews()">
        View All
    </button>

    <button class="view-btn" onclick="hideInterviews()">
        Hide All
    </button>


                </div>

            </div>

                        <div class="interviews-panel">

                            <div class="interview-item">

                            <div class="avatar av-as">AS</div>

                            <div class="interview-info">
                                <div class="interview-name">Alice Smith</div>
                                <div class="interview-role">Tech Round 1 • SWE</div>
                                <div class="interview-time">
                                    10:00 AM – 11:00 AM
                                </div>
                            </div>

                            <button class="video-btn">
                                <i class="fa fa-video"></i>
                            </button>

                        </div>

                        <div class="interview-item extra-interview">

                            <div class="avatar av-bj">BJ</div>

                            <div class="interview-info">
                                <div class="interview-name">Bob Jones</div>
                                <div class="interview-role">HR Round • PM Intern</div>
                                <div class="interview-time">
                                    11:30 AM – 12:00 PM
                                </div>
                            </div>

                            <button class="video-btn">
                                <i class="fa fa-video"></i>
                            </button>

                        </div>

                    <!-- Interview 3 -->
                    <div class="interview-item extra-interview">

                        <div class="avatar av-rk">RK</div>

                        <div class="interview-info">
                            <div class="interview-name">Rahul Kumar</div>
                            <div class="interview-role">Technical Round • Backend Developer</div>

                            <div class="interview-time">
                                1:00 PM – 1:45 PM
                            </div>
                        </div>

                        <button class="video-btn">
                            <i class="fa fa-video"></i>
                        </button>

                    </div>


                    <!-- Interview 4 -->
                    <div class="interview-item extra-interview">

                        <div class="avatar av-sn">SN</div>

                        <div class="interview-info">
                            <div class="interview-name">Sneha Nair</div>
                            <div class="interview-role">HR Interview • UI/UX Designer</div>

                            <div class="interview-time">
                                2:30 PM – 3:00 PM
                            </div>
                        </div>

                        <button class="video-btn">
                            <i class="fa fa-video"></i>
                        </button>

                    </div>


                    <!-- Interview 5 -->
                    <div class="interview-item extra-interview">

                        <div class="avatar av-ap">AP</div>

                        <div class="interview-info">
                            <div class="interview-name">Arjun Patel</div>
                            <div class="interview-role">Final Round • Data Analyst</div>

                            <div class="interview-time">
                                3:30 PM – 4:15 PM
                            </div>
                        </div>

                        <button class="video-btn">
                            <i class="fa fa-video"></i>
                        </button>

                    </div>


                    <!-- Interview 6 -->
                    <div class="interview-item extra-interview">

                        <div class="avatar av-ms">MS</div>

                        <div class="interview-info">
                            <div class="interview-name">Meera Sharma</div>
                            <div class="interview-role">Technical Round • Cloud Engineer</div>

                            <div class="interview-time">
                                4:30 PM – 5:15 PM
                            </div>
                        </div>

                        <button class="video-btn">
                            <i class="fa fa-video"></i>
                        </button>

                    </div>


                    <!-- Interview 7 -->
                    <div class="interview-item extra-interview">

                        <div class="avatar av-dp">DP</div>

                        <div class="interview-info">
                            <div class="interview-name">Dev Prakash</div>
                            <div class="interview-role">Machine Learning Round • AI Engineer</div>

                            <div class="interview-time">
                                5:30 PM – 6:15 PM
                            </div>
                        </div>

                        <button class="video-btn">
                            <i class="fa fa-video"></i>
                        </button>

                    </div>

                    </div>

                </div>

            </div>
                    
                    
                    
                    

        </div>
        <!-- CENTER BODY CONTENT END -->

    </div>

</div>

<!-- JavaScript -->

<script>

function showDrives() {

    let hiddenDrives = document.querySelectorAll(".extra-drive");

    hiddenDrives.forEach(function(card) {
        card.style.display = "block";
    });

}

function hideDrives() {

    let hiddenDrives = document.querySelectorAll(".extra-drive");

    hiddenDrives.forEach(function(card) {
        card.style.display = "none";
    });

}

function showInterviews() {

    let hiddenInterviews = document.querySelectorAll(".extra-interview");

    hiddenInterviews.forEach(function(item) {
        item.style.display = "flex";
    });

}

function hideInterviews() {

    let hiddenInterviews = document.querySelectorAll(".extra-interview");

    hiddenInterviews.forEach(function(item) {
        item.style.display = "none";
    });

}


</script>

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