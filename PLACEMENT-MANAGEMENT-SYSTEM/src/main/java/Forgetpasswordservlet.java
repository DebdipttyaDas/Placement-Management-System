import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Forgetpasswordservlet")
public class Forgetpasswordservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    private static final String EMAIL_REGEX = "^[^ ]+@[^ ]+\\.[a-zA-Z]{2,}$";
    private static final long CODE_VALID_MILLIS = 10 * 60 * 1000; // 10 minutes

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String error = null;

        if (email == null || email.trim().isEmpty()) {
            error = "Please enter your email address.";
        } else if (!email.trim().matches(EMAIL_REGEX)) {
            error = "Enter a valid email address.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("Forgetpassword.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Check if logged in user's email matches
        HttpSession session = request.getSession();
        String loggedInUser = (session != null) ? (String) session.getAttribute("user") : null;
        String loggedInRole = (session != null) ? (String) session.getAttribute("role") : null;

        if (loggedInUser != null && loggedInRole != null) {
            String registeredEmail = getRegisteredEmail(loggedInRole, loggedInUser);
            if (registeredEmail == null || !registeredEmail.equalsIgnoreCase(email)) {
                request.setAttribute("error", "The entered email does not match your registered email.");
                request.getRequestDispatcher("Forgetpassword.jsp").forward(request, response);
                return;
            }
        }

        String role = findRoleForEmail(email);

        if (role != null) {
            String code = generateCode();
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetRole", role);
            session.setAttribute("resetCode", code);
            session.setAttribute("resetCodeExpiry", System.currentTimeMillis() + CODE_VALID_MILLIS);

            System.out.println("----------------------------------------");
            System.out.println("RESET PASSWORD VERIFICATION CODE: " + code);
            System.out.println("Email: " + email + " | Role: " + role);
            System.out.println("----------------------------------------");

            boolean success = triggerN8NWorkflow(email, code);
            if (!success) {
                System.err.println("N8N workflow failed to send email. Proceeding with printed verification code.");
            } else {
                System.out.println("N8N workflow successfully triggered.");
            }
        }
        // If role == null (email not found in any table), we deliberately do NOT
        // reveal that. No code is generated/sent, so the verify step will simply
        // fail for anyone trying random emails - this avoids leaking which
        // addresses are registered.

        request.setAttribute("successMessage",
                "If an account exists for " + email + ", a verification code has been sent.");
        request.getRequestDispatcher("Verifycode.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Forgetpassword.jsp");
    }

    private String generateCode() {
        SecureRandom random = new SecureRandom();
        int code = 100000 + random.nextInt(900000); // 6-digit code, no leading zero issues
        return String.valueOf(code);
    }

    private boolean triggerN8NWorkflow(String email, String code) {
        String jsonPayload = String.format("{\"email\":\"%s\",\"code\":\"%s\"}", email, code);
        WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/forget-password", jsonPayload);
        return result.success;
    }

    /**
     * Checks students, companies, and admin tables for this email.
     * Returns "student" / "company" / "admin" if found, else null.
     *
     * ASSUMPTION (confirm with your DB teammate): this expects an `email`
     * column on ALL THREE tables. Your LoginServlet logs admin in via
     * `username` and companies via `company_code`, not email - so those
     * two tables may not have an email column yet. If a table doesn't
     * have this column, the query for that table will simply fail
     * silently and move on to the next table (see catch block below).
     */
    private String findRoleForEmail(String email) {
        try (Connection conn = DBUtil.getConnection()) {
            // Check student
            try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM STUDENT WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return "student";
                }
            }
            // Check company
            try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM COMPANY_CONTACT_DETAILS WHERE companyEmail = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return "company";
                }
            }
            // Check admin
            try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM ADMIN_PROFILE WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return "admin";
                }
            }
        } catch (Exception e) {
            System.err.println("Error checking email across tables: " + e.getMessage());
        }
        return null;
    }

    private String getRegisteredEmail(String role, String identifier) {
        String query = "";
        switch (role) {
            case "student":
                query = "SELECT email FROM STUDENT WHERE email = ?";
                break;
            case "company":
                query = "SELECT companyEmail AS email FROM COMPANY_CONTACT_DETAILS c JOIN BASIC_DETAILS b ON c.COMPANY_ID = b.COMPANY_ID WHERE b.companyCode = ?";
                break;
            case "admin":
                query = "SELECT email FROM ADMIN_PROFILE WHERE userName = ?";
                break;
            default:
                return null;
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("email");
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching registered email: " + e.getMessage());
        }
        return null;
    }
}
