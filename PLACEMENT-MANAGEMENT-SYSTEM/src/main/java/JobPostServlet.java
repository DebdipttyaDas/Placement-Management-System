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

@WebServlet("/JobPostServlet")
public class JobPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String jobTitle = request.getParameter("jobTitle");
        String department = request.getParameter("department");
        String employmentType = request.getParameter("employmentType");
        String locationType = request.getParameter("locationType");
        String salaryRange = request.getParameter("salaryRange");
        String jobDescription = normalizeEditorHtml(request.getParameter("jobDescription"));

        boolean isSuccess = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String insertQuery = "INSERT INTO jobs (job_title, department, employment_type, location_type, salary_range, job_description) VALUES (?, ?, ?, ?, ?, ?)";

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(insertQuery)) {

                ps.setString(1, jobTitle);
                ps.setString(2, department);
                ps.setString(3, employmentType);
                ps.setString(4, locationType);
                ps.setString(5, salaryRange);
                ps.setString(6, jobDescription);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    isSuccess = true;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }

        if (isSuccess) {
            response.sendRedirect("CompanyDashboard.jsp?success=JobPosted");
        } else {
            response.sendRedirect("JobPost.jsp?error=Failed");
        }
    }

    private String normalizeEditorHtml(String jobDescription) {
        if (jobDescription == null) {
            return "";
        }
        return jobDescription.trim();
    }
}
