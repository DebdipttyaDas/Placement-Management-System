<%@ page language="java" contentType="text/html; charset=UTF-8"
               pageEncoding="UTF-8" import="java.sql.*"  %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
                
                <div style="display:flex; align-items:center; gap:25px;">
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