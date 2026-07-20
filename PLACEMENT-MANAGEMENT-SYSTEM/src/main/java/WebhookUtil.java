public class WebhookUtil {

    public static boolean triggerWorkflow(String companyEmail, String companyName, String companyCode) {
        String jsonInputString = String.format(
                "{\"email\": \"%s\", \"companyName\": \"%s\", \"companyCode\": \"%s\"}",
                companyEmail, companyName, companyCode);

        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/approve-company", jsonInputString);
        return result.success;
    }

    public static boolean triggerRejectionWorkflow(String email, String fullName, String jobTitle, String companyName) {
        // Escape any double quotes in parameters
        String escapedEmail = email != null ? email.replace("\"", "\\\"") : "";
        String escapedFullName = fullName != null ? fullName.replace("\"", "\\\"") : "";
        String escapedJobTitle = jobTitle != null ? jobTitle.replace("\"", "\\\"") : "";
        String escapedCompanyName = companyName != null ? companyName.replace("\"", "\\\"") : "";

        String jsonInputString = String.format(
                "{\"email\": \"%s\", \"fullName\": \"%s\", \"jobTitle\": \"%s\", \"companyName\": \"%s\"}",
                escapedEmail, escapedFullName, escapedJobTitle, escapedCompanyName);

        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/reject-student", jsonInputString);
        return result.success;
    }

    public static boolean triggerCalendarSchedulerWorkflow(String email, String name, String department) {
        String escapedEmail = email != null ? email.replace("\"", "\\\"") : "";
        String escapedName = name != null ? name.replace("\"", "\\\"") : "";
        String escapedDept = department != null ? department.replace("\"", "\\\"") : "";

        String jsonInputString = String.format(
                "{\"email\": \"%s\", \"name\": \"%s\", \"department\": \"%s\"}",
                escapedEmail, escapedName, escapedDept);

        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/calendar-schedule-interview", jsonInputString);
        return result.success;
    }
}
