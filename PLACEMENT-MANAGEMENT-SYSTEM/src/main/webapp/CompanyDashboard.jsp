<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Company Dashboard</title>
<link rel="stylesheet" href="CompanyDashboard.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h2>Company Portal</h2>
        <br><br>
        <ul class="menu">
            <li class="active">Dashboard</li>
            <li><a href="JobPost.jsp" style="text-decoration:none;color:white;">Job Post</a></li>
            <li><a href="Interviews.jsp" style="text-decoration:none;color:white;">Interviews</a></li>
            <li><a href="PlacementAnalysis.jsp" style="text-decoration:none;color:white;">Placement Analysis</a></li>
        </ul>
        <div class="logout">
            <button>Logout</button>
        </div>
    </div>
    <!-- END SIDEBAR -->

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- TOPBAR -->
        <div class="topbar">
            <h2>Company Dashboard</h2>
            <div class="user-profile">
                <a href="CompanyProfileServlet">
                    <i class="fa fa-user-circle"></i>
                </a>
                <i class="fa fa-bell bell"></i>
            </div>
        </div>
        <!-- END TOPBAR -->

        <!-- PAGE (scrollable) -->
        <div class="page">

            <!-- Hero -->
            <div class="hero">
                <span class="particle"></span>
                <span class="particle"></span>
                <span class="particle"></span>
                <div>
                    <div class="hero-label">Company Dashboard</div>
                    <h1>Hello, Google Recruiting</h1>
                    <p>Here is your recruitment overview for the current placement season.</p>
                </div>
                <div class="hero-content">
                    <button class="btn btn-white" onclick="window.location.href='JobPost.jsp'">+ Post new jobs</button>
                </div>
                <div class="hero-actions">
                    <button class="btn btn-white">Review Applications</button>
                </div>
            </div>
            <!-- END Hero -->

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <svg width="22" height="22" fill="none" stroke="#2251d3" stroke-width="2" viewBox="0 0 24 24">
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
                        <svg width="22" height="22" fill="none" stroke="#7c3aed" stroke-width="2" viewBox="0 0 24 24">
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
                        <svg width="22" height="22" fill="none" stroke="#db2777" stroke-width="2" viewBox="0 0 24 24">
                            <circle cx="9" cy="7" r="4"/>
                        </svg>
                    </div>
                    <div>
                        <div class="stat-label">Hires This Season</div>
                        <div class="stat-value">42</div>
                    </div>
                </div>
            </div>
            <!-- END Stats -->

            <!-- Main Grid -->
            <div class="main-grid">

                <!-- LEFT: Drive Cards -->
                <div>
                    <div class="section-header">
                        <span class="section-title">Active Drives</span>
                        <div class="view-actions">
                            <button class="view-btn" onclick="showDrives()">View All</button>
                            <button class="view-btn" onclick="hideDrives()">Hide All</button>
                        </div>
                    </div>

                    <!-- Drive Card 1 -->
                    <div class="drive-card">
                        <div class="drive-top">
                            <div class="drive-title">Software Engineer – New Grad</div>
                            <span class="badge badge-active">Active</span>
                        </div>
                        <div class="drive-meta">Bangalore, India • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 2 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">Data Analyst Intern</div>
                            <span class="badge badge-active">Active</span>
                        </div>
                        <div class="drive-meta">Hyderabad, India • Internship</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 3 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">UI/UX Designer</div>
                            <span class="badge badge-closing">Closing Soon</span>
                        </div>
                        <div class="drive-meta">Pune, India • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 4 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">Cyber Security Analyst</div>
                            <span class="badge badge-active">Active</span>
                        </div>
                        <div class="drive-meta">Kolkata, India • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 5 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">Cloud Engineer</div>
                            <span class="badge badge-active">Active</span>
                        </div>
                        <div class="drive-meta">Chennai, India • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 6 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">AI/ML Engineer</div>
                            <span class="badge badge-closing">Closing Soon</span>
                        </div>
                        <div class="drive-meta">Bengaluru, India • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                    <!-- Drive Card 7 -->
                    <div class="drive-card extra-drive">
                        <div class="drive-top">
                            <div class="drive-title">Frontend Developer</div>
                            <span class="badge badge-active">Active</span>
                        </div>
                        <div class="drive-meta">Remote • Full-time</div>
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
                        <div class="drive-footer"><a class="manage-link" href="#">Manage Drive</a></div>
                    </div>

                </div>
                <!-- END LEFT -->

                <!-- RIGHT: Interviews -->
                <div>
                    <div class="section-header">
                        <span class="section-title">Today's Interviews</span>
                        <div class="view-actions">
                            <button class="view-btn" onclick="showInterviews()">View All</button>
                            <button class="view-btn" onclick="hideInterviews()">Hide All</button>
                        </div>
                    </div>

                    <div class="interviews-panel">
                        <div id="companyInterviewsPanel">
                            <div style="padding:12px 0;color:#64748b;font-size:14px;">
                                Loading scheduled interviews...
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END RIGHT -->

            </div>
            <!-- END Main Grid -->

        </div>
        <!-- END PAGE -->

    </div>
    <!-- END MAIN CONTENT -->

</div>
<!-- END CONTAINER -->

<script src="CompanyDashboard.js"></script>

<!-- Chatbot -->
<link rel="stylesheet" href="chatbot.css">
<div id="chatbot-toggle"><i class="fas fa-robot"></i></div>
<div id="chatbot-container">
    <div class="chatbot-header">
        <h3>AI Assistant</h3>
        <button class="chatbot-close">&times;</button>
    </div>
    <div class="chatbot-messages"></div>
    <div class="chatbot-input-area">
        <input type="text" class="chatbot-input" placeholder="Type your message...">
        <button class="chatbot-send"><i class="fas fa-paper-plane"></i></button>
    </div>
</div>
<script src="chatbot.js"></script>

</body>
</html>
