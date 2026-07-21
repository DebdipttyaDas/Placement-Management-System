import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ScheduleInterviewServlet")
public class ScheduleInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Webhook URL of the n8n workflow we created
    private static final String N8N_WEBHOOK_URL = "http://localhost:5678/webhook/schedule-interview";

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
            // 1. Read JSON payload from AJAX request
            String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

            // 2. Validate input minimally
            if (requestBody == null || requestBody.trim().isEmpty() || !requestBody.contains("company_name")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter()
                    .write("{\"success\": false, \"message\": \"Internal Server Error: " + e.getMessage() + "\"}");
        }
    }
}

