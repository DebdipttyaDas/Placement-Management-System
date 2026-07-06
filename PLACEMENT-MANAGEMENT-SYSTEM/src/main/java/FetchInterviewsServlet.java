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

            if (fetchAll) {
                appendInterviews(json,
                        "SELECT * FROM interview_slots ORDER BY interview_date ASC, interview_time ASC",
                        null, null, null);
            } else if ("student".equals(role)) {
                String studentEmail = getStudentEmail(session);
                String studentFullName = getStudentFullName(session, studentEmail);
                if (studentEmail == null || studentEmail.isEmpty()) {
                    json.append("]");
                    response.getWriter().print(json.toString());
                    return;
                }
                appendInterviews(json,
                        "SELECT * FROM interview_slots WHERE student_email = ? "
                                + "OR LOWER(TRIM(student_name)) = LOWER(TRIM(?)) "
                                + "ORDER BY interview_date ASC, interview_time ASC LIMIT " + STUDENT_LIMIT,
                        studentEmail, studentFullName, null);
            } else if ("company".equals(role)) {
                String companyName = getCompanyName(session);
                if (companyName == null || companyName.isEmpty()) {
                    json.append("]");
                    response.getWriter().print(json.toString());
                    return;
                }
                appendInterviews(json,
                        "SELECT * FROM interview_slots WHERE company_name = ? "
                                + "ORDER BY interview_date ASC, interview_time ASC",
                        null, null, companyName);
            } else {
                json.append("]");
                response.getWriter().print(json.toString());
                return;
            }

            json.append("]");
            response.getWriter().print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("[]");
        }
    }

    private void appendInterviews(StringBuilder json, String sql, String studentEmail,
            String studentFullName, String companyName) throws Exception {
        boolean first = true;

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (studentEmail != null && studentFullName != null) {
                ps.setString(1, studentEmail);
                ps.setString(2, studentFullName);
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
                .append("\"company_name\":\"").append(escapeJson(rs.getString("company_name"))).append("\",")
                .append("\"interview_date\":\"").append(escapeJson(rs.getString("interview_date"))).append("\",")
                .append("\"interview_time\":\"").append(escapeJson(rs.getString("interview_time"))).append("\",")
                .append("\"interview_round\":\"").append(escapeJson(rs.getString("interview_round"))).append("\",")
                .append("\"meet_link\":\"").append(escapeJson(
                        rs.getString("meet_link") != null ? rs.getString("meet_link") : "#")).append("\",")
                .append("\"student_name\":\"").append(escapeJson(rs.getString("student_name"))).append("\",")
                .append("\"student_email\":\"").append(escapeJson(
                        rs.getString("student_email") != null ? rs.getString("student_email") : "")).append("\",")
                .append("\"interviewer_name\":\"").append(escapeJson(rs.getString("interviewer_name"))).append("\"")
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

    private String getStudentFullName(HttpSession session, String studentEmail) {
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
            
            try (Connection conn = DBUtil.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "SELECT full_name FROM students WHERE email = ?")) {
                ps.setString(1, studentEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getString("full_name") != null) {
                        return rs.getString("full_name").trim();
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error resolving student full name: " + e.getMessage());
        }
        return "";
    }

    private String getCompanyName(HttpSession session) {
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

            try (Connection conn = DBUtil.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "SELECT company_name FROM companies WHERE company_code = ?")) {
                ps.setString(1, companyCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getString("company_name") != null) {
                        return rs.getString("company_name").trim();
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