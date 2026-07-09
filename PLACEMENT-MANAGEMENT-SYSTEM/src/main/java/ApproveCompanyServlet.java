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

        boolean isUpdated = false;

        try (Connection conn = DBUtil.getConnection()) {

            // Update status only
            String updateQuery =
                    "UPDATE BASIC_DETAILS SET STATUS = 'APPROVED' WHERE COMPANY_ID = ?";

            try (PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {

                psUpdate.setInt(1, companyId);

                int rows = psUpdate.executeUpdate();

                if (rows > 0) {
                    isUpdated = true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
            response.sendRedirect("AdminDashboard.jsp?success=Company Approved");
        } else {
            response.sendRedirect("AdminDashboard.jsp?error=Approval Failed");
        }
    }
}