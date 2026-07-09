<%@ page language="java" contentType="text/html; charset=UTF-8"
               pageEncoding="UTF-8" import="java.sql.*"  %>
<%!
    private Connection getJspConnection() throws Exception {
        java.util.Properties prop = new java.util.Properties();
        try (java.io.InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) prop.load(input);
        }
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(prop.getProperty("url"), prop.getProperty("username"), prop.getProperty("password"));
    }
%>

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
            <div class="sidebar" style="display:flex; flex-direction:column; justify-content:space-between; height:100vh; box-sizing:border-box; padding-bottom:20px; position:fixed; left:0; top:0;">
                <div>
                    <h2>Placements</h2>
                    <ul>
                        <li><a href="Student_dashboard.jsp" style="text-decoration:none; color:white">Dashboard</a></li>
                        <li><a href="Placement.jsp" style="text-decoration:none; color:white">Placements</a></li>
                        <li><a href="MyApplication.jsp" style="text-decoration:none; color:white">My Applications</a></li>
                    </ul>
                </div>
                <!-- Logout -->
                <form action="LogoutServlet" method="post" style="width:100%;">
                    <button type="submit" style="width:100%; padding:10px; background:#1d6b61; color:white; border:none; border-radius:6px; font-weight:bold; cursor:pointer; font-size:16px; transition: 0.3s ease;">Logout</button>
                </form>
            </div>

            <!-- TOP BAR -->
           <div class="topbar" style="display:flex; justify-content:space-between; align-items:center;">
                <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                    &#9776;
                </button>
                <div style="display:flex; align-items:center; gap:25px; margin-left: auto;">
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

	conn = getJspConnection();

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

                            <form action="ApplyJobServlet" method="post" style="margin-top: 10px; display: inline-block;">
                                <input type="hidden" name="companyName" value="<%= rs.getString("companyName") %>">
                                <input type="hidden" name="jobTitle" value="<%= rs.getString("jobTitle") %>">
                                <input type="hidden" name="department" value="<%= rs.getString("department") %>">
                                <input type="hidden" name="employmentType" value="<%= rs.getString("employmentType") %>">
                                <input type="hidden" name="locationType" value="<%= rs.getString("LocationType") %>">
                                <input type="hidden" name="location" value="<%= rs.getString("Location") %>">
                                <input type="hidden" name="salary" value="<%= rs.getString("salary") %>">
                                <button type="submit" style="padding: 8px 15px; background-color: #06473e; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 14px; transition: 0.3s; margin-right: 10px;">Apply Now</button>
                            </form>

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



        <script src="Placement.js"></script>

        <script>
          (function() {
            const toggleBtn = document.getElementById('sidebar-toggle');
            const sidebar = document.querySelector('.sidebar');
            if (toggleBtn && sidebar) {
              toggleBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                sidebar.classList.toggle('active');
              });
              document.addEventListener('click', function(e) {
                if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                  sidebar.classList.remove('active');
                }
              });
            }
          })();
        </script>

    </body>
    </html>