import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class WebhookUtil {
    // Replace with actual n8n webhook URL
    private static final String WEBHOOK_URL = "http://localhost:5678/webhook-test/approve-company";

    public static boolean triggerWorkflow(String companyEmail, String companyName, String companyCode) {
        try {
            URL url = new URL(WEBHOOK_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            String jsonInputString = String.format(
                    "{\"email\": \"%s\", \"companyName\": \"%s\", \"companyCode\": \"%s\"}",
                    companyEmail, companyName, companyCode);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            return code >= 200 && code < 300;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
