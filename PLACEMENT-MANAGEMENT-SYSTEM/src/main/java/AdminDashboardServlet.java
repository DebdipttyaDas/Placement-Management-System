import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int studentCount = 0;
        int companyCount = 0;
        int jobCount = 0;
        int placedCount = 0;

        List<Map<String, String>> pendingCompanies = new ArrayList<>();
        List<Map<String, String>> upcomingDrives = new ArrayList<>();
        List<Map<String, String>> recentNotifications = new ArrayList<>();

        List<String> barLabels = new ArrayList<>();
        List<Integer> barData = new ArrayList<>();

        List<String> pieLabels = new ArrayList<>();
        List<Integer> pieData = new ArrayList<>();

        List<String> lineLabels = new ArrayList<>();
        List<Integer> lineData = new ArrayList<>();

        try (Connection conn = getConnection()) {
            // 1. Fetch counts
            studentCount = getTableCount(conn, "STUDENT");
            companyCount = getTableCount(conn, "BASIC_DETAILS");
            jobCount = getTableCount(conn, "JOB_DETAILS");
            placedCount = getUniqueAppliedStudentsCount(conn);

            // 2. Fetch pending company approvals
            String pendingSql = "SELECT b.COMPANY_ID AS id, b.companyName, b.industry, c.companyEmail AS email FROM BASIC_DETAILS b JOIN COMPANY_CONTACT_DETAILS c ON b.COMPANY_ID = c.COMPANY_ID WHERE b.STATUS = 'PENDING' ORDER BY b.COMPANY_ID DESC";
            try (PreparedStatement ps = conn.prepareStatement(pendingSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> company = new HashMap<>();
                    company.put("id", String.valueOf(rs.getInt("id")));
                    company.put("company_name", rs.getString("companyName"));
                    company.put("industry", rs.getString("industry"));
                    company.put("email", rs.getString("email"));
                    pendingCompanies.add(company);
                }
            }

            // 3. Fetch upcoming drives
            String drivesSql = "SELECT COMPANY_NAME, INTERVIEW_TITLE, INTERVIEW_DATE FROM INTERVIEW ORDER BY INTERVIEW_DATE DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(drivesSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> drive = new HashMap<>();
                    drive.put("company_name", rs.getString("COMPANY_NAME"));
                    drive.put("interview_round", rs.getString("INTERVIEW_TITLE"));
                    drive.put("interview_date", String.valueOf(rs.getDate("INTERVIEW_DATE")));
                    drive.put("status", "Scheduled");
                    upcomingDrives.add(drive);
                }
            }

            // 4. Notifications from database
            String notificationStudentSql = "SELECT fullName FROM STUDENT ORDER BY STUDENT_ID DESC LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(notificationStudentSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> note = new HashMap<>();
                    note.put("type", "student");
                    note.put("message", "New student registered: " + rs.getString("fullName"));
                    note.put("time", "Just now");
                    recentNotifications.add(note);
                }
            }

            String notificationJobSql = "SELECT jobTitle, department FROM JOB_DETAILS ORDER BY JOB_ID DESC LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(notificationJobSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> note = new HashMap<>();
                    note.put("type", "bell");
                    note.put("message", "New job posted: " + rs.getString("jobTitle") + " (" + rs.getString("department") + ")");
                    note.put("time", "Just now");
                    recentNotifications.add(note);
                }
            }

            String notificationCompanySql = "SELECT companyName FROM BASIC_DETAILS ORDER BY COMPANY_ID DESC LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(notificationCompanySql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> note = new HashMap<>();
                    note.put("type", "building");
                    note.put("message", "New company registered: " + rs.getString("companyName"));
                    note.put("time", "Just now");
                    recentNotifications.add(note);
                }
            }

            // 5. Dynamic Time Windows for Charts
            java.time.LocalDate today = java.time.LocalDate.now();

            // Placement Rate Bar Chart (Applications count)
            for (int i = 5; i >= 0; i--) {
                java.time.LocalDate d = today.minusMonths(i);
                String monthName = d.getMonth().getDisplayName(java.time.format.TextStyle.SHORT, java.util.Locale.ENGLISH);
                barLabels.add(monthName);
                
                int monthVal = d.getMonthValue();
                int yearVal = d.getYear();
                String appCountSql = "SELECT COUNT(*) FROM APPLICATION WHERE MONTH(submitted) = ? AND YEAR(submitted) = ?";
                try (PreparedStatement ps = conn.prepareStatement(appCountSql)) {
                    ps.setInt(1, monthVal);
                    ps.setInt(2, yearVal);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            barData.add(rs.getInt(1));
                        } else {
                            barData.add(0);
                        }
                    }
                }
            }

            // Students per Department Pie Chart
            String deptSql = "SELECT department, COUNT(*) as cnt FROM ACCADEMIC_DETAILS GROUP BY department";
            try (PreparedStatement ps = conn.prepareStatement(deptSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String dept = rs.getString("department");
                    if (dept != null && !dept.trim().isEmpty()) {
                        pieLabels.add(dept.trim().toUpperCase());
                        pieData.add(rs.getInt("cnt"));
                    }
                }
            }

            // Job Postings Line Chart (Jobs count by deadline month)
            for (int i = 5; i >= 0; i--) {
                java.time.LocalDate d = today.minusMonths(i);
                String monthName = d.getMonth().getDisplayName(java.time.format.TextStyle.SHORT, java.util.Locale.ENGLISH);
                lineLabels.add(monthName);
                
                int monthVal = d.getMonthValue();
                int yearVal = d.getYear();
                String datePrefix = String.format("%04d-%02d-%%", yearVal, monthVal);
                String jobCountSql = "SELECT COUNT(*) FROM JOB_DETAILS WHERE applicationDeadline LIKE ?";
                try (PreparedStatement ps = conn.prepareStatement(jobCountSql)) {
                    ps.setString(1, datePrefix);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            lineData.add(rs.getInt(1));
                        } else {
                            lineData.add(0);
                        }
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("AdminDashboardServlet: Database error: " + e.getMessage());
            e.printStackTrace();
        }

        String studentsTrend = "+" + studentCount + " registered";
        String companiesTrend = "+" + companyCount + " registered";
        String jobsTrend = "+" + jobCount + " active";
        String placedTrend = "+" + placedCount + " placed";

        boolean isAjax = request.getParameter("ajax") != null;

        if (isAjax) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            StringBuilder sb = new StringBuilder();
            sb.append("{")
              .append("\"totalStudents\":\"").append(formatNumber(studentCount)).append("\",")
              .append("\"totalCompanies\":\"").append(formatNumber(companyCount)).append("\",")
              .append("\"activeJobs\":\"").append(formatNumber(jobCount)).append("\",")
              .append("\"placedStudents\":\"").append(formatNumber(placedCount)).append("\",")
              .append("\"studentsTrend\":\"").append(studentsTrend).append("\",")
              .append("\"companiesTrend\":\"").append(companiesTrend).append("\",")
              .append("\"jobsTrend\":\"").append(jobsTrend).append("\",")
              .append("\"placedTrend\":\"").append(placedTrend).append("\",")
              .append("\"pendingCompanies\":").append(listToJson(pendingCompanies)).append(",")
              .append("\"upcomingDrives\":").append(listToJson(upcomingDrives)).append(",")
              .append("\"notifications\":").append(listToJson(recentNotifications)).append(",")
              .append("\"barChartLabels\":").append(toJsonArray(barLabels)).append(",")
              .append("\"barChartData\":").append(toJsonArrayOfInts(barData)).append(",")
              .append("\"pieChartLabels\":").append(toJsonArray(pieLabels)).append(",")
              .append("\"pieChartData\":").append(toJsonArrayOfInts(pieData)).append(",")
              .append("\"lineChartLabels\":").append(toJsonArray(lineLabels)).append(",")
              .append("\"lineChartData\":").append(toJsonArrayOfInts(lineData))
              .append("}");

            out.print(sb.toString());
        } else {
            // Set counts and trends as request attributes for initial render
            request.setAttribute("totalStudents", formatNumber(studentCount));
            request.setAttribute("totalCompanies", formatNumber(companyCount));
            request.setAttribute("activeJobs", formatNumber(jobCount));
            request.setAttribute("placedStudents", formatNumber(placedCount));

            request.setAttribute("studentsTrend", studentsTrend);
            request.setAttribute("companiesTrend", companiesTrend);
            request.setAttribute("jobsTrend", jobsTrend);
            request.setAttribute("placedTrend", placedTrend);

            request.setAttribute("pendingCompanies", pendingCompanies);
            request.setAttribute("upcomingDrives", upcomingDrives);
            request.setAttribute("notifications", recentNotifications);

            request.setAttribute("barChartLabels", toJsonArray(barLabels));
            request.setAttribute("barChartData", toJsonArrayOfInts(barData));
            request.setAttribute("pieChartLabels", toJsonArray(pieLabels));
            request.setAttribute("pieChartData", toJsonArrayOfInts(pieData));
            request.setAttribute("lineChartLabels", toJsonArray(lineLabels));
            request.setAttribute("lineChartData", toJsonArrayOfInts(lineData));

            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private Connection getConnection() throws Exception {
        return DBUtil.getConnection();
    }

    private int getTableCount(Connection conn, String tableName) {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Ignore (table may not exist yet)
        }
        return 0;
    }

    private int getUniqueAppliedStudentsCount(Connection conn) {
        String sql = "SELECT COUNT(DISTINCT STUDENT_ID) FROM APPLICATION";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Ignore
        }
        return 0;
    }

    private String formatNumber(int number) {
        if (number >= 1000) {
            return String.format("%,d", number);
        }
        return String.valueOf(number);
    }

    private String listToJson(List<Map<String, String>> list) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(mapToJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    private String mapToJson(Map<String, String> map) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        int count = 0;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            if (count > 0) sb.append(",");
            sb.append("\"").append(escapeJson(entry.getKey())).append("\":\"")
              .append(escapeJson(entry.getValue())).append("\"");
            count++;
        }
        sb.append("}");
        return sb.toString();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private String toJsonArray(List<String> list) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append("\"").append(list.get(i)).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonArrayOfInts(List<Integer> list) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(list.get(i));
        }
        sb.append("]");
        return sb.toString();
    }
}
