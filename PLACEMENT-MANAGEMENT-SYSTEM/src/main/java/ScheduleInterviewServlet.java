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

    private static final String N8N_WEBHOOK_URL = "http://localhost:5678/webhook/schedule-interview";

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

            if (studentEmail == null || studentEmail.trim().isEmpty()) {
                studentEmail = lookupStudentEmailByName(studentName);
            }

            if (meetLink == null || meetLink.trim().isEmpty()) {
                meetLink = "https://meet.google.com/" + generateRandomString(3) + "-"
                        + generateRandomString(4) + "-" + generateRandomString(3);
            }

            insertInterviewSlot(companyName, studentName, studentEmail, interviewerName,
                    interviewDate, interviewTime, duration, interviewRound, meetLink);

            notifyN8n(requestBody);

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

    private void insertInterviewSlot(String companyName, String studentName, String studentEmail,
            String interviewerName, String interviewDate, String interviewTime, int duration,
            String interviewRound, String meetLink) throws Exception {
    	
    	try (Connection conn = DBUtil.getConnection()) {
            Integer companyId = null;
            try (PreparedStatement ps = conn.prepareStatement("SELECT COMPANY_ID FROM BASIC_DETAILS WHERE companyName = ? LIMIT 1")) {
                ps.setString(1, companyName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        companyId = rs.getInt("COMPANY_ID");
                    }
                }
            }
            if (companyId == null) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT COMPANY_ID FROM BASIC_DETAILS LIMIT 1");
                     ResultSet rs = ps.executeQuery()) {
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
    }

    private void notifyN8n(String requestBody) {
        try {
            URL url = new URL(N8N_WEBHOOK_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            conn.getResponseCode();
        } catch (Exception e) {
            System.out.println("n8n webhook notification skipped: " + e.getMessage());
        }
    }

    private String lookupStudentEmailByName(String studentName) {
        if (studentName == null || studentName.trim().isEmpty()) {
            return "";
        }
        try {
        	try (Connection conn = DBUtil.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
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