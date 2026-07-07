import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CompanyRegisterServlet")
public class CompanyRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String companyName = request.getParameter("companyName");
        String industry = request.getParameter("industry");
        String companyType = request.getParameter("companyType");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        boolean isRegistered = false;

        String insertQuery = "INSERT INTO companies "
                + "(company_name, company_code, industry, company_type, email, phone, password, status) "
                + "VALUES (?, NULL, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertQuery)) {

            ps.setString(1, companyName);
            ps.setString(2, industry);
            ps.setString(3, companyType);
            ps.setString(4, email);
            ps.setString(5, phone);
            ps.setString(6, password);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                isRegistered = true;
            }

        } catch (Exception e) {
            System.err.println("Database connection error: " + e.getMessage());
        }

        // Handle Response
        if (isRegistered) {

            request.setAttribute("successMessage",
                    "Company Registration Successful! Please wait for Admin approval.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);

        } else {

            request.setAttribute("errorMessage",
                    "Registration Failed. Please try again.");
            request.getRequestDispatcher("CompanyRegister.jsp").forward(request, response);
        }
    }
}