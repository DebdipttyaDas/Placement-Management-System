import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // For company form submission
        String companyCode = request.getParameter("companyCode");
        String companyPassword = request.getParameter("companyPassword");

        if ("company".equals(role)) {
            // Use company specific fields if provided
            if (companyCode != null && !companyCode.trim().isEmpty()) {
                email = companyCode;
                password = companyPassword;
            }
        }

        // ----------------------------------------------------------------
        // ADMIN LOGIN
        // ----------------------------------------------------------------
        if ("admin".equals(role)) {
            if (isValidUser("admin", email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("AdminDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid admin credentials");
                request.getRequestDispatcher("Login.jsp?role=admin").forward(request, response);
            }
        }

        // ----------------------------------------------------------------
        // STUDENT LOGIN
        // ----------------------------------------------------------------
        else if ("student".equals(role)) {
            if (isValidUser("student", email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("Student_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid student credentials");
                request.getRequestDispatcher("Login.jsp?role=student").forward(request, response);
            }
        }

        // ----------------------------------------------------------------
        // COMPANY LOGIN
        // ----------------------------------------------------------------
        else if ("company".equals(role)) {
            if (isValidUser("company", email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("role", role);
                response.sendRedirect("CompanyDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid company credentials");
                request.getRequestDispatcher("Login.jsp?role=company").forward(request, response);
            }
        } else {
            // Default fallback
            request.setAttribute("error", "Invalid role specified");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    // ----------------------------------------------------------------
    // Database Validation Method
    // ----------------------------------------------------------------
    private boolean isValidUser(String role, String identifier, String password) {
        boolean isValid = false;
        String query = "";

        // Determine the query based on the role
        switch (role) {
            case "admin":
                query = "SELECT * FROM admin WHERE username = ? AND password = ?";
                break;
            case "student":
                query = "SELECT * FROM students WHERE email = ? AND password = ?";
                break;
            case "company":
                query = "SELECT * FROM companies WHERE company_code = ? AND password = ?";
                break;
            default:
                return false;
        }

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    PreparedStatement ps = conn.prepareStatement(query)) {

                ps.setString(1, identifier);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        isValid = true;
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
        }

        // Fallback for hardcoded admin if DB fails or is not setup yet
        if (!isValid && "admin".equals(role) && "admin".equals(identifier) && "admin".equals(password)) {
            return true;
        }

        return isValid;
    }
}
