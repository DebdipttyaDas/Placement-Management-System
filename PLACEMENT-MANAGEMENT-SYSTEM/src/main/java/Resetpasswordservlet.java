import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Resetpasswordservlet")
public class Resetpasswordservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Boolean verified = (Boolean) session.getAttribute("resetVerified");
        String email = (String) session.getAttribute("resetEmail");
        String role = (String) session.getAttribute("resetRole");

        // Guard: someone trying to hit this servlet directly without going
        // through the email + code steps first.
        if (verified == null || !verified || email == null || role == null) {
            response.sendRedirect("Forgetpassword.jsp");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("Resetpassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("Resetpassword.jsp").forward(request, response);
            return;
        }

        boolean updated = updatePassword(role, email, newPassword);

        if (!updated) {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.setAttribute("showAlert", true);
            request.getRequestDispatcher("Resetpassword.jsp").forward(request, response);
            return;
        }

        // Clear the reset-related session data - the flow is complete
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetRole");
        session.removeAttribute("resetVerified");

        // Forward back to ResetPassword.jsp with a success flag. The page's
        // own JS will show the popup and then redirect to Login.jsp itself.
        request.setAttribute("showSuccess", true);
        request.getRequestDispatcher("Resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Forgetpassword.jsp");
    }

    /**
     * Updates the password column for the given role's table, matched by email.
     *
     * NOTE (matches the assumption in ForgotPasswordServlet): this updates by
     * `email`. Confirm with your DB teammate that `admin` and `companies`
     * tables have an `email` column - if not, this UPDATE will affect 0 rows
     * even though the role lookup succeeded, which would need a fix here.
     *
     * IMPORTANT: this stores the password as plain text, matching how
     * LoginServlet currently checks passwords. If your team switches to
     * hashed passwords (recommended), this line needs to hash newPassword
     * the same way before storing it.
     */
    private boolean updatePassword(String role, String email, String newPassword) {
        String table;
        switch (role) {
            case "student":
                table = "students";
                break;
            case "company":
                table = "companies";
                break;
            case "admin":
                table = "admin";
                break;
            default:
                return false;
        }

        String query = "UPDATE " + table + " SET password = ? WHERE email = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, newPassword);
                ps.setString(2, email);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            System.err.println("Error updating password for role '" + role + "': " + e.getMessage());
            return false;
        }
    }
}
