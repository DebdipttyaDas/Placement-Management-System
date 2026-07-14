import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;

public class WebhookService {

    private static String n8nBaseUrl = "http://localhost:5678"; // fallback default

    static {
        try {
            Properties prop = new Properties();
            java.io.InputStream input = WebhookService.class.getClassLoader()
                    .getResourceAsStream("config.properties");
            if (input != null) {
                prop.load(input);
                String baseUrl = prop.getProperty("N8N_BASE_URL");
                if (baseUrl != null && !baseUrl.trim().isEmpty()) {
                    n8nBaseUrl = baseUrl.trim();
                    // Strip trailing slash if present
                    if (n8nBaseUrl.endsWith("/")) {
                        n8nBaseUrl = n8nBaseUrl.substring(0, n8nBaseUrl.length() - 1);
                    }
                }
            } else {
                System.err.println("WebhookService: config.properties not found, using default fallback base URL.");
            }
        } catch (Exception e) {
            System.err.println("WebhookService: Error reading config.properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static class WebhookResult {
        public final boolean success;
        public final int statusCode;
        public final String responseBody;
        public final String errorMessage;

        public WebhookResult(boolean success, int statusCode, String responseBody, String errorMessage) {
            this.success = success;
            this.statusCode = statusCode;
            this.responseBody = responseBody;
            this.errorMessage = errorMessage;
        }
    }

    public static WebhookResult sendPost(String endpointPath, String jsonPayload) {
        String fullUrl = n8nBaseUrl + (endpointPath.startsWith("/") ? endpointPath : "/" + endpointPath);
        long timestamp = System.currentTimeMillis();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        String formattedTimestamp = sdf.format(new java.util.Date(timestamp));

        System.out.println(String.format("[%s] Webhook Request Initiated -> URL: %s", formattedTimestamp, fullUrl));
        System.out.println("Payload: " + jsonPayload);

        HttpURLConnection conn = null;
        try {
            URL url = new URL(fullUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000); // 5 seconds connect timeout
            conn.setReadTimeout(5000);    // 5 seconds read timeout
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            String responseBody = "";

            if (responseCode >= 200 && responseCode < 300) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder responseBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBuilder.append(responseLine.trim());
                    }
                    responseBody = responseBuilder.toString();
                }
                System.out.println(String.format("[%s] Webhook Response Status: %d. Body: %s", 
                        sdf.format(new java.util.Date()), responseCode, responseBody));
                return new WebhookResult(true, responseCode, responseBody, null);
            } else {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream() != null ? conn.getErrorStream() : conn.getInputStream(), "utf-8"))) {
                    StringBuilder errorBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        errorBuilder.append(responseLine.trim());
                    }
                    responseBody = errorBuilder.toString();
                }
                String errMsg = "HTTP error response code: " + responseCode;
                System.err.println(String.format("[%s] Webhook Error Response Status: %d. Body: %s", 
                        sdf.format(new java.util.Date()), responseCode, responseBody));
                return new WebhookResult(false, responseCode, responseBody, errMsg);
            }
        } catch (java.net.SocketTimeoutException e) {
            String errMsg = "Connection timed out connecting to n8n server.";
            System.err.println(String.format("[%s] Webhook Connection Timeout: %s", 
                    sdf.format(new java.util.Date()), e.getMessage()));
            return new WebhookResult(false, -1, null, errMsg);
        } catch (Exception e) {
            String errMsg = "Connection error: " + e.getMessage();
            System.err.println(String.format("[%s] Webhook Connection Error: %s", 
                    sdf.format(new java.util.Date()), e.getMessage()));
            e.printStackTrace();
            return new WebhookResult(false, -1, null, errMsg);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}
