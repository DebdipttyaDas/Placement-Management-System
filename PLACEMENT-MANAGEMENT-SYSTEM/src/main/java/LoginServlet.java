import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // ----------------------------------------------------------------
        // ADMIN LOGIN
        // ----------------------------------------------------------------
        if ("admin".equals(role)) {

            if ("admin".equals(email) && "admin".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid admin credentials");
                request.getRequestDispatcher("login.jsp?role=admin").forward(request, response);
            }

        }

        // ----------------------------------------------------------------
        // STUDENT LOGIN
        // ----------------------------------------------------------------
        else if ("student".equals(role)) {

            if (isValidStudent(email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("student_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid student credentials");
                request.getRequestDispatcher("login.jsp?role=student").forward(request, response);
            }
        }

        // ----------------------------------------------------------------
        // COMPANY LOGIN
        // ----------------------------------------------------------------
        else if ("company".equals(role)) {

            if (isValidCompany(email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("company_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid company credentials");
                request.getRequestDispatcher("login.jsp?role=company").forward(request, response);
            }
        }
    }

    // ----------------------------------------------------------------
    // Dummy Validation Methods (Replace with Database later)
    // ----------------------------------------------------------------

    private boolean isValidStudent(String email, String password) {
        // TODO: Connect to database
        return "student".equals(email) && "student".equals(password);
    }

    private boolean isValidCompany(String email, String password) {
        // TODO: Connect to database
        return "company".equals(email) && "company".equals(password);
    }
}
