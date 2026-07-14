public class WebhookUtil {

    public static boolean triggerWorkflow(String companyEmail, String companyName, String companyCode) {
        String jsonInputString = String.format(
                "{\"email\": \"%s\", \"companyName\": \"%s\", \"companyCode\": \"%s\"}",
                companyEmail, companyName, companyCode);

        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook-test/approve-company", jsonInputString);
        return result.success;
    }

    public static boolean triggerRejectionWorkflow(String email, String fullName, String jobTitle, String companyName) {
        // Escape any double quotes in parameters
        String escapedEmail = email.replace("\"", "\\\"");
        String escapedFullName = fullName.replace("\"", "\\\"");
        String escapedJobTitle = jobTitle.replace("\"", "\\\"");
        String escapedCompanyName = companyName.replace("\"", "\\\"");

        String jsonInputString = String.format(
                "{\"email\": \"%s\", \"fullName\": \"%s\", \"jobTitle\": \"%s\", \"companyName\": \"%s\"}",
                escapedEmail, escapedFullName, escapedJobTitle, escapedCompanyName);

        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook-test/reject-student", jsonInputString);
        return result.success;
    }
}
