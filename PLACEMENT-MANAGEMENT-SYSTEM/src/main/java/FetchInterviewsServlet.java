import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/FetchInterviewsServlet")
public class FetchInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int STUDENT_LIMIT = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        boolean fetchAll = "true".equals(request.getParameter("all"));

        StringBuilder json = new StringBuilder();
        json.append("[");

        try {
            try (Connection conn = DBUtil.getConnection()) {
                if (fetchAll) {
                    appendInterviews(conn, json,
                            "SELECT * FROM INTERVIEW WHERE INTERVIEW_DATE >= CURDATE() ORDER BY INTERVIEW_DATE ASC, INTERVIEW_TIME ASC",
                            null, null, null);
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
                } else if ("company".equals(role)) {
                    String companyName = getCompanyName(conn, session);
                    if (companyName == null || companyName.isEmpty()) {
                        json.append("]");
                        response.getWriter().print(json.toString());
                        return;
                    }
                    appendInterviews(conn, json,
                            "SELECT * FROM INTERVIEW WHERE COMPANY_NAME = ? AND INTERVIEW_DATE >= CURDATE() "
                                    + "ORDER BY INTERVIEW_DATE ASC, INTERVIEW_TIME ASC",
                            null, null, companyName);
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