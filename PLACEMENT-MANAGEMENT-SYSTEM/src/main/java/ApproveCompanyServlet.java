import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApproveCompanyServlet")
public class ApproveCompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String companyIdStr = request.getParameter("companyId");

        if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
            response.sendRedirect("AdminDashboard.jsp?error=Invalid Company ID");
            return;
        }

        int companyId = Integer.parseInt(companyIdStr);
        String companyCode = CodeGenerator.generateCompanyCode();

        boolean isUpdated = false;
        String companyEmail = "";
        String companyName = "";

        try (Connection conn = DBUtil.getConnection()) {

            // Get company details
            String selectQuery = "SELECT email, company_name FROM companies WHERE id = ?";

            try (PreparedStatement psSelect = conn.prepareStatement(selectQuery)) {

                psSelect.setInt(1, companyId);

                try (ResultSet rs = psSelect.executeQuery()) {

                    if (rs.next()) {
                        companyEmail = rs.getString("email");
                        companyName = rs.getString("company_name");
                    }
                }
            }

            if (!companyEmail.isEmpty()) {

                // Update status and company code
                String updateQuery =
                        "UPDATE companies SET status = 'APPROVED', company_code = ? WHERE id = ?";

                try (PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {

                    psUpdate.setString(1, companyCode);
                    psUpdate.setInt(2, companyId);

                    int rows = psUpdate.executeUpdate();

                    if (rows > 0) {
                        isUpdated = true;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {

            // Trigger webhook
            boolean webhookSuccess =
                    WebhookUtil.triggerWorkflow(companyEmail, companyName, companyCode);

            if (webhookSuccess) {
                response.sendRedirect("AdminDashboard.jsp?success=Company Approved and Email Sent");
            } else {
                response.sendRedirect("AdminDashboard.jsp?success=Company Approved but Email failed");
            }

        } else {

            response.sendRedirect("AdminDashboard.jsp?error=Approval Failed");
        }
    }
}