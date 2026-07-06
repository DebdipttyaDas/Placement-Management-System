import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
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

    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

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
        String role = findRoleForEmail(email);

        HttpSession session = request.getSession();

        if (role != null) {
            String code = generateCode();
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetRole", role);
            session.setAttribute("resetCode", code);
            session.setAttribute("resetCodeExpiry", System.currentTimeMillis() + CODE_VALID_MILLIS);

            try {
                EmailUtil.sendVerificationCode(email, code);
            } catch (MessagingException e) {
                System.err.println("Failed to send verification email: " + e.getMessage());
                request.setAttribute("error", "Could not send the email right now. Please try again shortly.");
                request.getRequestDispatcher("Forgetpassword.jsp").forward(request, response);
                return;
            }
        }
        // If role == null (email not found in any table), we deliberately do NOT
        // reveal that. No code is generated/sent, so the verify step will simply
        // fail for anyone trying random emails - this avoids leaking which
        // addresses are registered.

        request.setAttribute("successMessage",
                "If an account exists for " + email + ", a verification code has been sent.");
        request.getRequestDispatcher("VerifyCode.jsp").forward(request, response);
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
        String[][] tables = {
            {"students", "email", "student"},
            {"companies", "email", "company"},
            {"admin", "email", "admin"}
        };

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                for (String[] t : tables) {
                    String table = t[0];
                    String column = t[1];
                    String roleName = t[2];
                    String query = "SELECT 1 FROM " + table + " WHERE " + column + " = ?";
                    try (PreparedStatement ps = conn.prepareStatement(query)) {
                        ps.setString(1, email);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                return roleName;
                            }
                        }
                    } catch (Exception tableIssue) {
                        // Table might not have an `email` column yet - skip and try the next one
                        System.err.println("Skipping table '" + table + "': " + tableIssue.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error checking email across tables: " + e.getMessage());
        }
        return null;
    }
}
