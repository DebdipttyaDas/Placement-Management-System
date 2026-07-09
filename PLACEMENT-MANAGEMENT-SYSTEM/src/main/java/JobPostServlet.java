import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/JobPostServlet")
public class JobPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String companyName = request.getParameter("companyName");
        String jobTitle = request.getParameter("jobTitle");
        String department = request.getParameter("department");
        String employmentType = request.getParameter("employmentType");
        String locationType = request.getParameter("locationType");
        String location = request.getParameter("location");
        // Read "salary" since the input in JobPost.jsp is name="salary"
        String salaryRange = request.getParameter("salary");
        if (salaryRange == null || salaryRange.trim().isEmpty()) {
            salaryRange = request.getParameter("salaryRange");
        }
        String applicationDeadline = request.getParameter("applicationDeadline");
        String jobDescription = normalizeEditorHtml(request.getParameter("jobDescription"));

        boolean isSuccess = false;

        jakarta.servlet.http.HttpSession session = request.getSession();
        String companyCode = (String) session.getAttribute("companyCode");

        try (Connection conn = getConnection()) {
            if (conn != null) {
                Integer companyId = fetchCompanyId(conn, companyCode);

                if (companyId != null) {
                    String insertQuery = "INSERT INTO JOB_DETAILS (COMPANY_ID, companyName, jobTitle, department, employmentType, LocationType, Location, salary, applicationDeadline, jobDescription) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                        ps.setInt(1, companyId);
                        ps.setString(2, companyName != null && !companyName.trim().isEmpty() ? companyName : "Demo Company");
                        ps.setString(3, jobTitle);
                        ps.setString(4, department);
                        ps.setString(5, employmentType);
                        ps.setString(6, locationType);
                        ps.setString(7, location);
                        ps.setString(8, salaryRange);
                        ps.setString(9, applicationDeadline);
                        ps.setString(10, jobDescription);

                        int rowsAffected = ps.executeUpdate();
                        if (rowsAffected > 0) {
                            isSuccess = true;
                        }
                    }
                } else {
                    System.err.println("JobPostServlet: No company found in BASIC_DETAILS for companyCode: " + companyCode);
                }
            }
        } catch (Exception e) {
            System.err.println("JobPostServlet: Database error: " + e.getMessage());
            e.printStackTrace();
        }

        if (isSuccess) {
            response.sendRedirect("CompanyDashboard.jsp?success=JobPosted");
        } else {
            response.sendRedirect("JobPost.jsp?error=Failed");
        }
    }

    private Connection getConnection() throws Exception {
        return DBUtil.getConnection();
    }

    private Integer fetchCompanyId(Connection conn, String companyCode) {
        if (companyCode == null) return null;
        String sql = "SELECT COMPANY_ID FROM BASIC_DETAILS WHERE companyCode = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("COMPANY_ID");
                }
            }
        } catch (Exception e) {
            System.err.println("JobPostServlet: Error fetching COMPANY_ID: " + e.getMessage());
        }
        return null;
    }

    private String normalizeEditorHtml(String jobDescription) {
        if (jobDescription == null) {
            return "";
        }
        return jobDescription.trim();
    }
}
