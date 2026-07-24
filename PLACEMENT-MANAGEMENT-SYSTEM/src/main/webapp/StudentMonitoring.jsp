<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.*" %>
<%!
    private Connection getJspConnection() throws Exception {
        Class<?> dbUtilClass = Class.forName("DBUtil");
        return (Connection) dbUtilClass.getMethod("getConnection").invoke(null);
    }
    
    private String getInitials(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "ST";
        }
        String[] parts = name.trim().split("\\s+");
        if (parts.length >= 2) {
            return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
        }
        return name.substring(0, Math.min(2, name.length())).toUpperCase();
    }
%>
<%
    int totalStudents = 0;
    int pendingReviews = 0;
    List<Map<String, String>> studentList = new ArrayList<>();
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = getJspConnection();
        
        // Fetch total student count
        try (Statement st = conn.createStatement();
             ResultSet rsTotal = st.executeQuery("SELECT COUNT(*) FROM STUDENT")) {
            if (rsTotal.next()) {
                totalStudents = rsTotal.getInt(1);
            }
        }
        
        // Fetch pending reviews count
        try (Statement st = conn.createStatement();
             ResultSet rsPending = st.executeQuery("SELECT COUNT(*) FROM APPLICATION WHERE status IS NULL OR status = '' OR status = 'Applied'")) {
            if (rsPending.next()) {
                pendingReviews = rsPending.getInt(1);
            }
        }
        
        // Fetch all students with academic details
        String sql = "SELECT s.STUDENT_ID, s.fullName, s.email, s.phone, a.department, a.dgpa "
                   + "FROM STUDENT s "
                   + "LEFT JOIN ACCADEMIC_DETAILS a ON s.STUDENT_ID = a.STUDENT_ID "
                   + "ORDER BY s.STUDENT_ID DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, String> stud = new HashMap<>();
            stud.put("id", String.valueOf(rs.getInt("STUDENT_ID")));
            stud.put("fullName", rs.getString("fullName") != null ? rs.getString("fullName") : "Unknown");
            stud.put("email", rs.getString("email") != null ? rs.getString("email") : "N/A");
            stud.put("phone", rs.getString("phone") != null ? rs.getString("phone") : "N/A");
            
            String dept = rs.getString("department");
            stud.put("department", dept != null ? dept : "N/A");
            
            double gpaVal = rs.getDouble("dgpa");
            stud.put("gpa", rs.wasNull() ? "N/A" : String.format("%.2f", gpaVal));
            
            studentList.add(stud);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Monitoring</title>

<link rel="stylesheet" href="StudentMonitoring.css">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="container">

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Student Monitoring</h2>
        
        <ul class="menu">
            <li><a href="AdminDashboard.jsp" style="text-decoration: none; color: white;">Dashboard</a></li>
            <li><a href="CompanyMonitoring.jsp" style="text-decoration: none; color: white;">Company Monitoring</a></li>
            <li class="active">Student Monitoring</li>
            <li><a href="PlacementAnalysis.jsp">Placement Analysis</a></li>
        </ul>
    </div>

   
    <!-- Main Content -->

    <div class="main-content">
        <header class="mobile-header" style="display:none; align-items:center; background:#06473e; padding:15px; position:sticky; top:0; z-index:100;">
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <h2 class="mobile-logo" style="color:white; font-size:18px; font-weight:bold; margin-left: 10px;">Student Monitoring</h2>
        </header>

        <!-- Stats Cards -->

        <div class="stats">

            <div class="card">
                <h5>TOTAL STUDENTS</h5>
                <h2><%= totalStudents %></h2>
            </div>

            <div class="card blue">
                <h5>PLACEMENT RATE</h5>
                <h2>92%</h2>
                <p>Goal: 95%</p>
            </div>

            <div class="card">
                <h5>PENDING REVIEWS</h5>
                <h2><%= pendingReviews %> <span style="color:#d97706;">Priority</span></h2>
            </div>

        </div>


        <!-- Header -->

<div class="header">

            <div class="title">
                <h3>
                    Track, Analyze & Improve Student Performance
                </h3>
            </div>
    <div class="filters">

    <input type="text" placeholder="Search students,departments...">

    <select>

        <option selected disabled hidden>ALL DEPARTMENTS</option>

        <option>Computer Science</option>

        <option>BCA</option>

        <option>MCA</option>

        <option>BBA</option>

        <option>MBA</option>

        <option>ECE</option>

        <option>EEE</option>

    </select>

</div>

</div>

        <!-- Table -->

       <div class="table-container">
    <table>
        <thead>
            <tr>
                <th>Student Name</th>
                <th>Department</th>
                <th>GPA</th>
                <th>Email</th>
                <th>Phone</th>
            </tr>
        </thead>
        <tbody>
            <% if (studentList.isEmpty()) { %>
                <tr>
                    <td colspan="5" style="text-align: center; padding: 20px; color: #64748b;">
                        No registered students found in the database.
                    </td>
                </tr>
            <% } else {
                for (Map<String, String> stud : studentList) {
                    String initials = getInitials(stud.get("fullName"));
            %>
                <tr>
                    <td>
                        <div class="student">
                            <div class="student-avatar"><%= initials %></div>
                            <div>
                                <h4><%= stud.get("fullName") %></h4>
                                <p>Student ID: <%= stud.get("id") %></p>
                            </div>
                        </div>
                    </td>
                    <td><%= stud.get("department") %></td>
                    <td><span class="gpa"><%= stud.get("gpa") %></span></td>
                    <td><span style="color: #64748b; font-weight: 500;"><%= stud.get("email") %></span></td>
                    <td style="color: #64748b; font-weight: 500;"><%= stud.get("phone") %></td>
                </tr>
            <% 
                } 
            }
            %>
        </tbody>
    </table>

    <!-- Footer is now safely outside the table tag, but inside the main container -->
    <div class="table-footer">
        <p>Showing <strong><%= Math.min(1, studentList.size()) %>-<%= studentList.size() %></strong> of <strong><%= totalStudents %></strong> students</p>
        <div class="pagination">
            <button class="btn-page" type="button" onclick="alert('First Page')">&lt;</button>
            <button class="btn-page" type="button" onclick="alert('Last Page')">&gt;</button>
        </div>
    </div>
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