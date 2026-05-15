<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="UTF-8">

        <title>Interview Scheduling</title>

        <link rel="stylesheet" href="Interviews.css">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    </head>

    <body>

        <div class="container">

            <!-- SIDEBAR -->
            <aside class="sidebar">

                <br><br><br>

                <ul class="menu">

                    <li>
                        <a href="CompanyDashboard.jsp" style="text-decoration:none;color:white;">
                            Dashboard
                        </a>
                    </li>

                    <li>
                        <a href="JobPost.jsp" style="text-decoration:none;color:white;">
                            Job Post
                        </a>
                    </li>

                    <li class="active">
                        Interviews
                    </li>

                    <li>
                        <a href="PlacementAnalysis.jsp" style="text-decoration:none;color:white;">
                            Placement Analysis
                        </a>
                    </li>

                </ul>
                
                <!-- LOGOUT -->
    <div class="logout">

        <button>
            Logout
        </button>

    </div>
                

            </aside>

            <!-- MAIN CONTENT -->
            <main class="main-content">

                <!-- TOPBAR -->
                <div class="topbar">

                    <h2>Interviews</h2>

                    <div class="top-links">

                        <a href="#">

                            <i class="fa fa-user-circle" style="font-size:25px;color:white;"></i>

                        </a>

                    </div>

                </div>

                <!-- PAGE HEADER -->
                <div class="page-header">

                    <h1>Interview Scheduling</h1>

                    <p>
                        Coordinate upcoming placement rounds by mapping panel
                        availability to shortlisted candidates.
                    </p>

                </div>

                <!-- TOOLBAR -->
                <div class="toolbar">

                    <div class="left-group">
                        <h2 style="margin: 0; color: #1e293b;">Upcoming Interviews</h2>
                    </div>

                    <div class="right-actions">

                        <button class="create-btn" id="openSlotModalBtn">

                            Create New Slot

                        </button>

                    </div>

                </div>

                <!-- CONTENT -->
                <div class="content">

                    <!-- LEFT -->
                    <div class="schedule" id="adminScheduleContainer">

                        <div class="loading-text">
                            Loading scheduled interviews...
                        </div>

                    </div>

                    <!-- RIGHT -->
                    <div class="sidebar-right">

                        <!-- STATS -->
                        <div class="stats">

                            <div class="box" style="width: 100%;">
                                <p>Total Rounds</p>
                                <h2 id="totalRoundsCount" style="color: #1e293b;">0</h2>
                            </div>

                        </div>

                        <!-- PENDING -->
                        <div class="pending">

                            <h3>Scheduled Students</h3>

                            <div id="dynamicStudentsList">
                                <div style="color: #64748b; font-size: 14px; margin-top: 10px;">Loading...</div>
                            </div>

                            <button class="view-btn">
                                View All Shortlisted
                            </button>

                        </div>

                        <!-- PANEL -->
                        <div class="panel-load">

                            <h3>Panelist Load</h3>

                            <div id="dynamicPanelistList">
                                <div style="color: #64748b; font-size: 14px; margin-top: 10px;">Loading...</div>
                            </div>

                        </div>

                    </div>

                </div>

            </main>

        </div>

        <!-- =========================================================
     MODAL
========================================================= -->

        <div class="interview-modal-overlay" id="slotModal">

            <div class="interview-modal">

                <!-- HEADER -->
                <div class="interview-modal-header">

                    <div>

                        <h2>Schedule Interview</h2>

                        <p>
                            Set up a new interaction between company and candidate.
                        </p>

                    </div>

                    <button class="close-modal-btn" id="closeSlotModalBtn">

                        <i class="fa-solid fa-xmark"></i>

                    </button>

                </div>

                <!-- FORM -->
                <form id="scheduleInterviewForm">

                    <!-- TITLE -->
                    <div class="modern-form-group">

                        <label>Interview Title</label>

                        <input type="text" id="interviewRound" placeholder="e.g. Technical Round 1" required>

                    </div>

                    <!-- COMPANY + STUDENT -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Select Company</label>

                            <select id="companyName" required>

                                <option value="">
                                    Choose Company
                                </option>

                                <option value="CloudScale Solutions">
                                    CloudScale Solutions
                                </option>

                                <option value="Infosys">
                                    Infosys
                                </option>

                                <option value="TCS">
                                    TCS
                                </option>

                                <option value="Wipro">
                                    Wipro
                                </option>

                            </select>

                        </div>

                        <div class="modern-form-group">

                            <label>Select Student</label>

                            <input type="text" id="studentName" placeholder="Search by name or ID" required>

                        </div>

                    </div>

                    <!-- DATE + TIME -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Date</label>

                            <input type="date" id="interviewDate" required>

                        </div>

                        <div class="modern-form-group">

                            <label>Time</label>

                            <input type="time" id="interviewTime" required>

                        </div>

                    </div>

                    <!-- PANEL + TYPE -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Interviewer / Panelist</label>

                            <input type="text" id="interviewerName" placeholder="Full Name" required>

                        </div>

                        <div class="modern-form-group">

                            <label>Interview Type</label>

                            <div class="interview-type-selector">

                                <button type="button" class="type-btn active" data-type="Virtual">

                                    Virtual

                                </button>

                                <button type="button" class="type-btn" data-type="In-person">

                                    In-person

                                </button>

                                <button type="button" class="type-btn" data-type="Phone">

                                    Phone

                                </button>

                            </div>

                        </div>

                    </div>

                    <!-- LINK -->
                    <div class="modern-form-group">

                        <label>Meeting Link / Location</label>

                        <input type="text" id="meetLink" placeholder="https://meet.google.com/abc-defg-hij">

                    </div>

                    <small class="virtual-note">
                        AUTO-GENERATED FOR VIRTUAL INTERVIEWS
                    </small>

                    <!-- FOOTER -->
                    <div class="modal-footer">

                        <button type="button" class="cancel-btn" id="cancelModalBtn">

                            Cancel

                        </button>

                        <button type="submit" class="create-slot-btn">

                            <span id="btnText">
                                Create Slot
                            </span>

                            <div class="loader" id="slotLoader"></div>

                        </button>

                    </div>

                </form>

            </div>

        </div>

        <!-- TOAST -->
        <div class="toast" id="toast"></div>

        <!-- =========================================================
     JAVASCRIPT
========================================================= -->

        <script src="interviews.js"></script>

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