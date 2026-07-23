<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.sql.*, java.util.*" %>
<%!
    private Connection getJspConnection() throws Exception {
        Class<?> dbUtilClass = Class.forName("DBUtil");
        return (Connection) dbUtilClass.getMethod("getConnection").invoke(null);
    }
%>
<%
    HttpSession sess = request.getSession(false);
    String userEmail = (sess != null) ? (String) sess.getAttribute("studentEmail") : null;
    if (userEmail == null && sess != null) {
        userEmail = (String) sess.getAttribute("user");
    }

    if (userEmail == null) {
        response.sendRedirect("Login.jsp?role=student");
        return;
    }

    int totalApplications = 0;
    int appliedCount = 0;
    int approvedCount = 0;
    int rejectedCount = 0;
    List<Map<String, String>> appsList = new ArrayList<>();
    
    try (Connection conn = getJspConnection()) {
        Integer studentId = null;
        try (PreparedStatement ps = conn.prepareStatement("SELECT STUDENT_ID FROM STUDENT WHERE LOWER(TRIM(email)) = LOWER(TRIM(?))")) {
            ps.setString(1, userEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    studentId = rs.getInt("STUDENT_ID");
                }
            }
        }
        if (studentId != null) {
            String sql = "SELECT companyName, jobTitle, department, employmentType, LocationType, Location, salary, submitted, status FROM APPLICATION WHERE STUDENT_ID = ? ORDER BY APPLICATION_ID DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> app = new HashMap<>();
                        app.put("companyName", rs.getString("companyName"));
                        app.put("jobTitle", rs.getString("jobTitle"));
                        app.put("department", rs.getString("department"));
                        app.put("employmentType", rs.getString("employmentType"));
                        app.put("LocationType", rs.getString("LocationType"));
                        app.put("Location", rs.getString("Location"));
                        app.put("salary", rs.getString("salary"));
                        
                        String statusVal = rs.getString("status");
                        if (statusVal == null || statusVal.isEmpty()) {
                            statusVal = "Applied";
                        }
                        app.put("status", statusVal);

                        if (statusVal.equalsIgnoreCase("Approved")) {
                            approvedCount++;
                        } else if (statusVal.equalsIgnoreCase("Rejected")) {
                            rejectedCount++;
                        } else {
                            appliedCount++;
                        }
                        
                        java.sql.Timestamp ts = rs.getTimestamp("submitted");
                        String dateStr = "";
                        if (ts != null) {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy");
                            dateStr = sdf.format(ts);
                        }
                        app.put("submitted", dateStr);
                        appsList.add(app);
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    totalApplications = appsList.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Applications</title>

<link rel="stylesheet" href="MyApplication.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script src="MyApplication.js"></script>

</head>

<body>

<div class="dashboard-container">

    <!-- ===== SIDEBAR ===== -->
    <div class="sidebar" style="display:flex; flex-direction:column; justify-content:space-between; height:100vh; box-sizing:border-box; padding-bottom:20px; position:fixed; left:0; top:0;">
        <div>
            <h2>My Applications</h2>
            <ul>
                <li><a href="Student_dashboard.jsp" style="text-decoration: none; color:white;">Dashboard</a></li>
                <li><a href="Placement.jsp" style="text-decoration: none; color:white;">Placements</a></li>
                <li><a href="MyApplication.jsp" style="text-decoration: none; color:white;">My Applications</a></li>
            </ul>
        </div>
        <!-- Logout -->
        <form action="LogoutServlet" method="post" style="width:100%;">
            <button type="submit" style="width:100%; padding:10px; background:#1d6b61; color:white; border:none; border-radius:6px; font-weight:bold; cursor:pointer; font-size:16px; transition: 0.3s ease;">Logout</button>
        </form>
    </div>

    <!-- ===== MAIN AREA ===== -->
    <div class="main-area">

        <!-- ===== TOP BAR ===== -->
        <div class="top-bar" style="display:flex; justify-content:space-between; align-items:center;">
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <div class="top-icons" style="margin-left: auto;">

                <a href="StudentProfile.jsp">
                    <i class="fa fa-user-circle" style="color: white;"></i>
                </a>

                <i class="fa fa-bell" style="color: white;"></i>

            </div>
        </div>

        <!-- ===== CONTENT ===== -->
        <div class="content">

            <h1>My Applications</h1>
            <p class="subtitle">Tracking your journey to professional success...</p>

            <!-- Stats -->
             <div class="stats-container">
 
                 <div class="card">
                     <div class="icon blue"><i class="fa-solid fa-file"></i></div>
                     <div class="text">
                          <h2><%= totalApplications %></h2>
                          <p>Total Applications</p>
                     </div>
                 </div>
 
                 <div class="card">
                     <div class="icon green"><i class="fa-solid fa-paper-plane"></i></div>
                     <div class="text">
                          <h2><%= appliedCount %></h2>
                          <p>Applied</p>
                     </div>
                 </div>
 
                 <div class="card">
                     <div class="icon orange"><i class="fa-solid fa-circle-check"></i></div>
                     <div class="text">
                          <h2><%= approvedCount %></h2>
                          <p>Approved</p>
                     </div>
                 </div>
 
                 <div class="card">
                     <div class="icon purple"><i class="fa-solid fa-circle-xmark"></i></div>
                     <div class="text">
                          <h2><%= rejectedCount %></h2>
                          <p>Rejected</p>
                     </div>
                 </div>
 
             </div>

            <!-- Applications -->
            <div class="table-container">

                <div class="table-header">
                    <h2>Application History</h2>

                    <div class="controls">
                        <input type="text" placeholder="Search company or role..." size="50">
                        <select onchange="filterStatus(this.value)">
                            <option value="all">All Status</option>
                            <option value="applied">Applied</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Company</th>
                            <th>Role</th>
                            <th>Drive</th>
                            <th>Applied On</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>

                     <tbody>
                     <% if (appsList.isEmpty()) { %>
                         <tr>
                             <td colspan="6" style="text-align: center; padding: 20px; color: #64748b;">
                                 You haven't applied to any jobs yet. Go to <a href="Placement.jsp" style="color: #0d6e60; font-weight: bold; text-decoration: none;">Placements</a> to view active drives.
                             </td>
                         </tr>
                     <% } else {
                         for (Map<String, String> app : appsList) {
                     %>
                         <tr class="row <%= app.get("status").toLowerCase() %>">
                             <td class="company">
                                 <div><b><%= app.get("companyName") %></b></div>
                             </td>
                             <td><%= app.get("jobTitle") %></td>
                             <td><%= app.get("companyName") %> Campus Hiring</td>
                             <td><%= app.get("submitted") %></td>
                             <td><span class="status <%= app.get("status").toLowerCase() %>"><%= app.get("status") %></span></td>
                             <td><button class="btn" onclick="alert('Company: <%= app.get("companyName") %>\nRole: <%= app.get("jobTitle") %>\nDepartment: <%= app.get("department") %>\nSalary: <%= app.get("salary") %>\nLocation: <%= app.get("Location") %> (<%= app.get("LocationType") %>)')">View Details</button></td>
                         </tr>
                     <% 
                         } 
                     }
                     %>
                     </tbody>
                </table>

            </div>

        </div>

    </div>

</div>



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