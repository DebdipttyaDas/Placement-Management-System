import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/FetchInterviewsServlet")
public class FetchInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        String url = "jdbc:mysql://localhost:3306/placement_management";
        try {
            return DriverManager.getConnection(url, "root", "root");
        } catch (SQLException e) {
            return DriverManager.getConnection(url, "root", "password");
        }
    }

    private static final int STUDENT_LIMIT = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String se = (String) session.getAttribute("studentEmail");
        if (se == null) {
            se = (String) session.getAttribute("user");
        }
        // Fallback to example if not logged in for testing
        String studentEmail = se != null ? se : "student@example.com";

        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        boolean fetchAll = "true".equals(request.getParameter("all"));

        StringBuilder json = new StringBuilder();
        json.append("[");

        try (Connection conn = getConnection()) {
            // Ensure table exists
            String createTableSql = "CREATE TABLE IF NOT EXISTS interview_slots ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "company_name VARCHAR(255) NOT NULL,"
                    + "interview_date DATE NOT NULL,"
                    + "interview_time TIME NOT NULL,"
                    + "interview_round VARCHAR(255) NOT NULL,"
                    + "meet_link VARCHAR(255),"
                    + "student_name VARCHAR(255) NOT NULL,"
                    + "student_email VARCHAR(255) NOT NULL,"
                    + "interviewer_name VARCHAR(255) NOT NULL"
                    + ")";
            try (PreparedStatement psTable = conn.prepareStatement(createTableSql)) {
                psTable.executeUpdate();
            }

            String sql;
            PreparedStatement ps;

            if (fetchAll) {
                sql = "SELECT * FROM interview_slots ORDER BY interview_date ASC, interview_time ASC";
                ps = conn.prepareStatement(sql);
            } else {
                sql = "SELECT * FROM interview_slots WHERE student_email=? ORDER BY interview_date ASC, interview_time ASC LIMIT 3";
                ps = conn.prepareStatement(sql);
        try {
            try (Connection conn = DBUtil.getConnection()) {
                if ("company".equals(role)) {
                    String companyName = getCompanyName(conn, session);
                    if (companyName == null || companyName.isEmpty()) {
                        json.append("]");
                        response.getWriter().print(json.toString());
                        return;
                    }
                    appendInterviews(conn, json,
                            "SELECT * FROM INTERVIEW WHERE LOWER(TRIM(COMPANY_NAME)) = LOWER(TRIM(?)) AND INTERVIEW_DATE >= CURDATE() "
                                    + "ORDER BY INTERVIEW_DATE ASC, INTERVIEW_TIME ASC",
                            null, null, companyName);
                } else if ("student".equals(role)) {
                    String studentEmail = getStudentEmail(session);
                    String studentFullName = getStudentFullName(conn, session, studentEmail);
                    if (studentFullName == null || studentFullName.isEmpty()) {
                        json.append("]");
                        response.getWriter().print(json.toString());
                        return;
                    }
                    appendInterviews(conn, json,
                            "SELECT * FROM INTERVIEW WHERE LOWER(TRIM(STUDENT_NAME)) = LOWER(TRIM(?)) "
                                    + "AND INTERVIEW_DATE >= CURDATE() ORDER BY INTERVIEW_DATE ASC, INTERVIEW_TIME ASC LIMIT " + STUDENT_LIMIT,
                            null, studentFullName, null);
                } else if (fetchAll || "admin".equals(role)) {
                    appendInterviews(conn, json,
                            "SELECT * FROM INTERVIEW WHERE INTERVIEW_DATE >= CURDATE() ORDER BY INTERVIEW_DATE ASC, INTERVIEW_TIME ASC",
                            null, null, null);
                } else {
                    json.append("]");
                    response.getWriter().print(json.toString());
                    return;
                }
            }
            json.append("]");
            response.getWriter().print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("[]");
        }
    }

    private void appendInterviews(Connection conn, StringBuilder json, String sql, String studentEmail,
            String studentFullName, String companyName) throws Exception {
        boolean first = true;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            if (studentFullName != null) {
                ps.setString(1, studentFullName);
            } else if (companyName != null) {
                ps.setString(1, companyName);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (!first) {
                        json.append(",");
                    }
                    first = false;
                    appendInterviewObject(json, rs);
                }
            }
        }
    }

    private void appendInterviewObject(StringBuilder json, ResultSet rs) throws Exception {
        json.append("{")
                .append("\"company_name\":\"").append(escapeJson(rs.getString("COMPANY_NAME"))).append("\",")
                .append("\"interview_date\":\"").append(escapeJson(rs.getString("INTERVIEW_DATE"))).append("\",")
                .append("\"interview_time\":\"").append(escapeJson(rs.getString("INTERVIEW_TIME"))).append("\",")
                .append("\"interview_round\":\"").append(escapeJson(rs.getString("INTERVIEW_TITLE"))).append("\",")
                .append("\"meet_link\":\"").append(escapeJson(
                        rs.getString("MEETING_LINK") != null ? rs.getString("MEETING_LINK") : "#")).append("\",")
                .append("\"student_name\":\"").append(escapeJson(rs.getString("STUDENT_NAME"))).append("\",")
                .append("\"student_email\":\"").append("").append("\",")
                .append("\"interviewer_name\":\"").append(escapeJson(rs.getString("INTERVIEWER_NAME"))).append("\"")
                .append("}");
    }

    private String getStudentEmail(HttpSession session) {
        if (session == null) {
            return null;
        }
        String email = (String) session.getAttribute("studentEmail");
        if (email == null || email.isEmpty()) {
            email = (String) session.getAttribute("user");
        }
        return email;
    }

    private String getStudentFullName(Connection conn, HttpSession session, String studentEmail) {
        if (session == null) {
            return "";
        }
        String fullName = (String) session.getAttribute("studentFullName");
        if (fullName != null && !fullName.trim().isEmpty()) {
            return fullName.trim();
        }
        if (studentEmail == null || studentEmail.isEmpty()) {
            return "";
        }
        try {
            
            try (PreparedStatement ps = conn.prepareStatement(
                            "SELECT fullName FROM STUDENT WHERE email = ?")) {
                ps.setString(1, studentEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getString("fullName") != null) {
                        return rs.getString("fullName").trim();
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error resolving student full name: " + e.getMessage());
        }
        return "";
    }

    private String getCompanyName(Connection conn, HttpSession session) {
        if (session == null) {
            return null;
        }
        String companyName = (String) session.getAttribute("companyName");
        if (companyName != null && !companyName.trim().isEmpty()) {
            return companyName.trim();
        }
        String companyCode = (String) session.getAttribute("user");
        if (companyCode == null || companyCode.isEmpty()) {
            return null;
        }
        try {

            try (PreparedStatement ps = conn.prepareStatement(
                            "SELECT companyName FROM BASIC_DETAILS WHERE companyCode = ?")) {
                ps.setString(1, companyCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getString("companyName") != null) {
                        return rs.getString("companyName").trim();
                    }
                }
            }
            rs.close();
            ps.close();
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            System.err.println("Error resolving company name: " + e.getMessage());
        }
        return null;
    }

    private String escapeJson(String data) {
        if (data == null) {
            return "";
        }
        return data.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

}
