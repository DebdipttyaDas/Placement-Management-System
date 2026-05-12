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

@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Webhook URL of the n8n workflow for chatbot
    private static final String N8N_WEBHOOK_URL = "http://localhost:5678/webhook/chatbot";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read JSON payload from request
            String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

            // Minimal validation
            if (requestBody == null || requestBody.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Empty request\"}");
                return;
            }

            // Send payload to n8n Webhook
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

            // Parse the n8n response
            BufferedReader br;
            if (responseCode >= 200 && responseCode <= 299) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
            }

            String n8nResponse = br.lines().collect(Collectors.joining(System.lineSeparator()));

            // Return JSON to frontend
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