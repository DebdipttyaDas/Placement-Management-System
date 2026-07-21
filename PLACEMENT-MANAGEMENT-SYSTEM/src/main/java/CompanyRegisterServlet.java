import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
        String website = request.getParameter("website");
        String registrationNumber = request.getParameter("registrationNumber");
        String cin = request.getParameter("cin");
        String address = request.getParameter("address");

        boolean isRegistered = false;
        String companyCode = "";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            companyCode = CodeGenerator.generateCompanyCode();
            String insertBasic = "INSERT INTO BASIC_DETAILS (companyName, industry, companyType, companyCode, password, STATUS) VALUES (?, ?, ?, ?, ?, 'PENDING')";
            int companyId = -1;

            try (PreparedStatement ps = conn.prepareStatement(insertBasic, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, companyName);
                ps.setString(2, industry);
                ps.setString(3, companyType);
                ps.setString(4, companyCode);
                ps.setString(5, password);

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        companyId = rs.getInt(1);
                    }
                }
            }

            if (companyId != -1) {
                // Insert Contact Details
                String insertContact = "INSERT INTO COMPANY_CONTACT_DETAILS (COMPANY_ID, companyPhone, companyEmail, companyWebsite, companyLinkedin) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertContact)) {
                    ps.setInt(1, companyId);
                    ps.setString(2, phone != null ? phone : "");
                    ps.setString(3, email != null ? email : "");
                    ps.setString(4, website != null ? website : "");
                    ps.setString(5, ""); // LinkedIn default
                    ps.executeUpdate();
                }

                // Insert Address Details
                String insertAddress = "INSERT INTO COMPANY_ADDRESS_DETAILS (COMPANY_ID, companyAddress, city, state, country, pincode) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertAddress)) {
                    ps.setInt(1, companyId);
                    ps.setString(2, address != null ? address : "Not Provided");
                    ps.setString(3, "Not Provided");
                    ps.setString(4, "Not Provided");
                    ps.setString(5, "Not Provided");
                    ps.setString(6, "Not Provided");
                    ps.executeUpdate();
                }

                // Insert Legal Info
                String insertLegal = "INSERT INTO COMPANY_LEGAL_INFO (COMPANY_ID, cin, registrationNum, licenseNum, gstNum) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertLegal)) {
                    ps.setInt(1, companyId);
                    ps.setString(2, cin != null ? cin : "Not Provided");
                    ps.setString(3, registrationNumber != null ? registrationNumber : "Not Provided");
                    ps.setString(4, "Not Provided");
                    ps.setString(5, "Not Provided");
                    ps.executeUpdate();
                }

                conn.commit();
                isRegistered = true;
            } else {
                conn.rollback();
            }

        } catch (Exception e) {
            System.err.println("CompanyRegisterServlet: Database error during registration: " + e.getMessage());
            e.printStackTrace();
        }

        // Handle Response
        if (isRegistered) {

            // Trigger registration success webhook/workflow
            WebhookUtil.triggerWorkflow(email, companyName, companyCode);

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