import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyCodeServlet")
public class Verifycodeservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String enteredCode = request.getParameter("code");

        String actualCode = (String) session.getAttribute("resetCode");
        String resetEmail = (String) session.getAttribute("resetEmail");
        Long expiry = (Long) session.getAttribute("resetCodeExpiry");

        // No code was ever issued for this session (e.g. email not found, or
        // session expired/was never set) - treat any entry as invalid.
        if (actualCode == null || resetEmail == null || expiry == null) {
            request.setAttribute("error", "Invalid or expired code. Please request a new one.");
            request.getRequestDispatcher("Verifycode.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiry) {
            clearResetSession(session);
            request.setAttribute("error", "This code has expired. Please request a new one.");
            request.getRequestDispatcher("Verifycode.jsp").forward(request, response);
            return;
        }

        if (enteredCode == null || !enteredCode.trim().equals(actualCode)) {
            request.setAttribute("error", "Incorrect code. Please try again.");
            request.getRequestDispatcher("Verifycode.jsp").forward(request, response);
            return;
        }

        // Code is correct - mark this session as allowed to reset the password,
        // and drop the code itself so it can't be reused.
        session.setAttribute("resetVerified", true);
        session.removeAttribute("resetCode");
        session.removeAttribute("resetCodeExpiry");

        request.getRequestDispatcher("Resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Forgetpassword.jsp");
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetRole");
        session.removeAttribute("resetCode");
        session.removeAttribute("resetCodeExpiry");
        session.removeAttribute("resetVerified");
    }
}
