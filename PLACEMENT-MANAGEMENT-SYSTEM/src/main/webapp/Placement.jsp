<%@ page language="java" contentType="text/html; charset=UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Placements</title>
        <link rel="stylesheet" href="Placement.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body>

        <div class="dashboard-container">

            <!-- LEFT SIDEBAR -->
            <div class="sidebar">
                <h2>Placements</h2>

                <ul>
                    <li><a href="Student_dashboard.jsp" style="text-decoration:none; color:white">Dashboard</a></li>
                    <li><a href="Placement.jsp" style="text-decoration:none; color:white">Placements</a></li>
                    <li><a href="MyApplication.jsp" style="text-decoration:none; color:white">My Applications</a></li>
                </ul>
            </div>

            <!-- TOP BAR -->
           <div class="topbar">
                
                <div style="display:flex; align-items:center; gap:30px;">
                    <i class="fa fa-user-circle" style="font-size:25px;"></i>
                    <i class="fa fa-bell" style="font-size:25px;"></i>
                </div>
            </div>

            <!-- MAIN CONTENT -->
            <div class="main">
            
            <div class="top-search-section">
            
                <!-- SEARCH BAR -->
                <div class="search-box">
                    <input type="text" placeholder="Search for job titles or companies...">
                </div>

                <!-- FILTER BUTTONS -->
                <div class="job-filters">
                    <button>All</button>
                    <button>IT</button>
                    <button>Engineering</button>
                    <button>Marketing</button>
                    <button>Medical</button>
                    <button>HR</button>
                </div>

                <!-- JOB CARDS -->
                <div class="job-cards" id="job-cards-container">
                 
                    <div style="color: #333; text-align: center; width: 100%;">Loading jobs...</div>
                </div>
                
             </div>   

            </div>

        </div>

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

        <script src="Placement.js"></script>

    </body>
    </html>