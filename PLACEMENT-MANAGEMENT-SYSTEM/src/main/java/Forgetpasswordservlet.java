import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * MOCK / TEST servlet for the Forgot Password form.
 * This does NOT connect to a database or send real emails.
 * It only validates the email format and shows a success/error message,
 * so you can confirm your JSP + CSS + JS are working correctly.
 *
 * Replace the logic inside doPost() with real DB lookup + email sending
 * once that part of the project is ready — the JSP doesn't need to change.
 */
@WebServlet("/ForgotPasswordServlet")
public class Forgetpasswordservlet extends HttpServlet {

    private static final String EMAIL_REGEX = "^[^ ]+@[^ ]+\\.[a-zA-Z]{2,}$";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        String errorMessage = null;
        String successMessage = null;

        if (email == null || email.trim().isEmpty()) {
            errorMessage = "Please enter your email address.";
        } else if (!email.trim().matches(EMAIL_REGEX)) {
            errorMessage = "Enter a valid email address.";
        } else {
            // ---- MOCK BEHAVIOR ----
            // In the real version, someone will:
            //   1. Look up this email in the database
            //   2. If it exists, generate a reset token and store it
            //   3. Send an email with a reset link containing the token
            //   4. If it doesn't exist, still show a generic success message
            //      (so people can't guess which emails are registered)
            //
            // For now, we just pretend it worked:
            successMessage = "If an account exists for " + email + ", a reset link has been sent (mock response).";
        }

        request.setAttribute("error", errorMessage);
        request.setAttribute("successMessage", successMessage);

        RequestDispatcher dispatcher = request.getRequestDispatcher("Forgetpassword.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Allow direct navigation to the page without a POST
        response.sendRedirect("Forgetpassword.jsp");
    }
}
