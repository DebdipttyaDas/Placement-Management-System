import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("checkApplication".equalsIgnoreCase(action)) {
            String companyName = request.getParameter("companyName");
            String studentName = request.getParameter("studentName");

            if (companyName == null || studentName == null || companyName.trim().isEmpty() || studentName.trim().isEmpty()) {
                response.getWriter().write("{\"applied\": false, \"message\": \"Missing parameters\"}");
                return;
            }

            try (Connection conn = DBUtil.getConnection()) {
                boolean applied = verifyStudentHasApplied(conn, studentName.trim(), companyName.trim());
                String email = lookupStudentEmailByName(conn, studentName.trim());
                if (applied) {
                    response.getWriter().write("{\"applied\": true, \"email\": \"" + escapeJson(email) + "\", \"message\": \"Matching application found\"}");
                } else {
                    response.getWriter().write("{\"applied\": false, \"email\": \"" + escapeJson(email) + "\", \"message\": \"Student has not applied to this company previously\"}");
                }
            } catch (Exception e) {
                response.getWriter().write("{\"applied\": false, \"message\": \"Error: " + escapeJson(e.getMessage()) + "\"}");
            }
            return;
        }

        response.getWriter().write("{\"status\": \"active\"}");
    }

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

    private String getJsonValue(String json, String key) {
        String pattern = "\"" + key + "\"\\s*:\\s*\"([^\"]*)\"";
        java.util.regex.Pattern r = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher m = r.matcher(json);
        if (m.find()) {
            return m.group(1);
        }
        return "";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

            if (requestBody == null || requestBody.trim().isEmpty() || !requestBody.contains("company_name")) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required fields\"}");
                return;
            }

            // Extract fields for DB insertion
            String companyName = getJsonValue(requestBody, "company_name");
            String interviewDate = getJsonValue(requestBody, "interview_date");
            String interviewTime = getJsonValue(requestBody, "interview_time");
            String interviewRound = getJsonValue(requestBody, "interview_round");
            String meetLink = getJsonValue(requestBody, "meet_link");
            String studentName = getJsonValue(requestBody, "student_name");
            String studentEmail = getJsonValue(requestBody, "student_email");
            String interviewerName = getJsonValue(requestBody, "interviewer_name");

            if (meetLink.isEmpty()) {
                meetLink = "#";
            }

            // 3. Save to database
            boolean dbSuccess = false;
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
                try (PreparedStatement ps = conn.prepareStatement(createTableSql)) {
                    ps.executeUpdate();
                }

                // Insert slot
                String insertSql = "INSERT INTO interview_slots (company_name, interview_date, interview_time, interview_round, meet_link, student_name, student_email, interviewer_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, companyName);
                    ps.setString(2, interviewDate);
                    ps.setString(3, interviewTime);
                    ps.setString(4, interviewRound);
                    ps.setString(5, meetLink);
                    ps.setString(6, studentName);
                    ps.setString(7, studentEmail);
                    ps.setString(8, interviewerName);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        dbSuccess = true;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Database Error: " + e.getMessage() + "\"}");
                return;
            }

            if (!dbSuccess) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to save interview to database.\"}");
                return;
            }

            // 4. Send payload to n8n Webhook (safely, so failure doesn't block response)
            boolean webhookTriggered = false;
            String n8nResponse = "";
            int responseCode = 200;
            try {
                URL url = new URL(N8N_WEBHOOK_URL);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json; utf-8");
                conn.setRequestProperty("Accept", "application/json");
                conn.setDoOutput(true);
                conn.setConnectTimeout(2000); // 2 seconds timeout
                conn.setReadTimeout(2000);

                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = requestBody.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }

                responseCode = conn.getResponseCode();

                BufferedReader br;
                if (responseCode >= 200 && responseCode <= 299) {
                    br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                } else {
                    br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
                }

                n8nResponse = br.lines().collect(Collectors.joining(System.lineSeparator()));
                webhookTriggered = true;
            } catch (Exception e) {
                System.err.println("n8n Webhook failed to trigger: " + e.getMessage());
                // Non-fatal error, we already saved to the database successfully
            }

            // 5. Return JSON to frontend
            if (webhookTriggered) {
                response.setStatus(responseCode);
                response.getWriter().write(n8nResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true, \"message\": \"Interview scheduled successfully (local database updated).\"}");
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
                // Check whether student has applied to company previously
                boolean hasApplied = verifyStudentHasApplied(conn, studentName, companyName);
                if (!hasApplied) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Validation Failed: Student '" + escapeJson(studentName) + "' has not applied to company '" + escapeJson(companyName) + "' previously.\"}");
                    return;
                }

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

    private boolean verifyStudentHasApplied(Connection conn, String studentName, String companyName) {
        if (studentName == null || companyName == null || studentName.trim().isEmpty() || companyName.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM APPLICATION a "
                   + "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID "
                   + "WHERE (LOWER(TRIM(a.companyName)) = LOWER(TRIM(?)) OR LOWER(TRIM(a.companyName)) LIKE CONCAT('%', LOWER(TRIM(?)), '%')) "
                   + "AND LOWER(TRIM(s.fullName)) = LOWER(TRIM(?))";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyName.trim());
            ps.setString(2, companyName.trim());
            ps.setString(3, studentName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error verifying student application: " + e.getMessage());
        }
        return false;
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

}
