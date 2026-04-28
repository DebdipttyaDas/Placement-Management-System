import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CompanyRegisterServlet")
public class CompanyRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String companyName = request.getParameter("companyName");
        String companyCode = request.getParameter("companyCode");
        String industry = request.getParameter("industry");
        String companyType = request.getParameter("companyType");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        boolean isRegistered = false;

        // Perform Database Insertion
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String insertQuery = "INSERT INTO companies (company_name, company_code, industry, company_type, email, phone, password) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    PreparedStatement ps = conn.prepareStatement(insertQuery)) {

                ps.setString(1, companyName);
                ps.setString(2, companyCode);
                ps.setString(3, industry);
                ps.setString(4, companyType);
                ps.setString(5, email);
                ps.setString(6, phone);
                ps.setString(7, password);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    isRegistered = true;
                }
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
        }

        // Handle Response
        if (isRegistered) {
            // Registration successful
            request.setAttribute("successMessage", "Registration Successful! Please login.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration Failed. Please try again.");
            request.getRequestDispatcher("CompanyRegister.jsp").forward(request, response);
        }
    }
}

