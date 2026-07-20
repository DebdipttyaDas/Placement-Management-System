import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ScheduleInterviewServlet")
public class ScheduleInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

            if (requestBody == null || requestBody.trim().isEmpty() || !requestBody.contains("company_name")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required fields\"}");
                return;
            }

            String companyName = getJsonField(requestBody, "company_name");
            String studentName = getJsonField(requestBody, "student_name");
            String studentEmail = getJsonField(requestBody, "student_email");
            String interviewerName = getJsonField(requestBody, "interviewer_name");
            String interviewDate = getJsonField(requestBody, "interview_date");
            String interviewTime = getJsonField(requestBody, "interview_time");
            String durationStr = getJsonField(requestBody, "duration");
            int duration = durationStr.isEmpty() ? 60 : Integer.parseInt(durationStr);
            String interviewRound = getJsonField(requestBody, "interview_round");
            String meetLink = getJsonField(requestBody, "meet_link");

            if (meetLink == null || meetLink.trim().isEmpty()) {
                meetLink = "https://meet.google.com/" + generateRandomString(3) + "-"
                        + generateRandomString(4) + "-" + generateRandomString(3);
            }

            try (Connection conn = DBUtil.getConnection()) {
                if (studentEmail == null || studentEmail.trim().isEmpty()) {
                    studentEmail = lookupStudentEmailByName(conn, studentName);
                }

                insertInterviewSlot(conn, companyName, studentName, studentEmail, interviewerName,
                        interviewDate, interviewTime, duration, interviewRound, meetLink);
            }

            String n8nPayload = requestBody.trim();
            if (n8nPayload.endsWith("}")) {
                n8nPayload = n8nPayload.substring(0, n8nPayload.length() - 1) + ", \"meet_link\": \"" + escapeJson(meetLink) + "\"}";
            }
            notifyN8n(n8nPayload);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true, \"message\": \"Interview slot scheduled successfully.\", "
                    + "\"meet_link\": \"" + escapeJson(meetLink) + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"success\": false, \"message\": \"Internal Server Error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void insertInterviewSlot(Connection conn, String companyName, String studentName, String studentEmail,
            String interviewerName, String interviewDate, String interviewTime, int duration,
            String interviewRound, String meetLink) throws Exception {

        Integer companyId = null;
        try (PreparedStatement ps = conn.prepareStatement("SELECT COMPANY_ID FROM BASIC_DETAILS WHERE companyName = ? LIMIT 1")) {
            ps.setString(1, companyName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    companyId = rs.getInt("COMPANY_ID");
                }
            }
        }

        String sql = "INSERT INTO INTERVIEW (COMPANY_ID, INTERVIEW_TITLE, COMPANY_NAME, STUDENT_NAME, INTERVIEW_DATE, INTERVIEW_TIME, INTERVIEWER_NAME, MEETING_LINK) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (companyId != null) ps.setInt(1, companyId); else ps.setNull(1, java.sql.Types.INTEGER);
            ps.setString(2, interviewRound);
            ps.setString(3, companyName);
            ps.setString(4, studentName);
            ps.setString(5, interviewDate);
            ps.setString(6, interviewTime);
            ps.setString(7, interviewerName);
            ps.setString(8, meetLink);
            ps.executeUpdate();
        }
    }

    private void notifyN8n(String requestBody) {
        // Trigger Interview Slot Scheduling Workflow
        WebhookService.sendPost("/webhook/schedule-interview", requestBody);
        
        // Trigger Google Calendar Interview Scheduler Workflow
        try {
            String name = getJsonField(requestBody, "student_name");
            String email = getJsonField(requestBody, "student_email");
            String department = getJsonField(requestBody, "interview_round");
            if (email == null || email.trim().isEmpty()) {
                email = getJsonField(requestBody, "email");
            }
            
            String calendarPayload = String.format(
                "{\"email\":\"%s\",\"name\":\"%s\",\"department\":\"%s\"}",
                escapeJson(email), escapeJson(name), escapeJson(department)
            );
            WebhookService.sendPost("/webhook/calendar-schedule-interview", calendarPayload);
        } catch (Exception e) {
            System.err.println("Error notifying calendar schedule workflow: " + e.getMessage());
        }
    }

    private String lookupStudentEmailByName(Connection conn, String studentName) {
        if (studentName == null || studentName.trim().isEmpty()) {
            return "";
        }
        try {
            try (PreparedStatement ps = conn.prepareStatement(
                            "SELECT email FROM STUDENT WHERE LOWER(TRIM(fullName)) = LOWER(TRIM(?))")) {
                ps.setString(1, studentName.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String email = rs.getString("email");
                        if (email != null) {
                            return email;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error looking up student email: " + e.getMessage());
        }
        return "";
    }

    private String getJsonField(String json, String field) {
        String pattern = "\"" + field + "\"\\s*:\\s*\"([^\"]*)\"";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher m = p.matcher(json);
        if (m.find()) {
            return m.group(1);
        }
        String numPattern = "\"" + field + "\"\\s*:\\s*([0-9]+)";
        java.util.regex.Pattern pNum = java.util.regex.Pattern.compile(numPattern);
        java.util.regex.Matcher mNum = pNum.matcher(json);
        if (mNum.find()) {
            return mNum.group(1);
        }
        return "";
    }

    private String generateRandomString(int length) {
        String chars = "abcdefghijklmnopqrstuvwxyz";
        StringBuilder sb = new StringBuilder();
        java.util.Random rnd = new java.util.Random();
        while (sb.length() < length) {
            int index = (int) (rnd.nextFloat() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    private String escapeJson(String data) {
        if (data == null) {
            return "";
        }
        return data.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}