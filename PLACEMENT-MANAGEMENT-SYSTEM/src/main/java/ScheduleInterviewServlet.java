import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
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

            // 3. Send payload to n8n Webhook
            URL url = new URL(N8N_WEBHOOK_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();

            // 4. Parse the n8n response
            BufferedReader br;
            if (responseCode >= 200 && responseCode <= 299) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
            }

            String n8nResponse = br.lines().collect(Collectors.joining(System.lineSeparator()));

            // 5. Return JSON to frontend
            response.setStatus(responseCode);
            response.getWriter().write(n8nResponse);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter()
                    .write("{\"success\": false, \"message\": \"Internal Server Error: " + e.getMessage() + "\"}");
        }
    }
}
