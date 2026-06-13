import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
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

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";

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

        try (Connection conn = getConnection()) {
            if (conn != null) {
                // Ensure table and columns exist
                checkAndPrepareDatabaseSchema(conn);

                String insertQuery = "INSERT INTO jobs (job_title, department, employment_type, location_type, salary_range, job_description, company_name, location, application_deadline) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                    ps.setString(1, jobTitle);
                    ps.setString(2, department);
                    ps.setString(3, employmentType);
                    ps.setString(4, locationType);
                    ps.setString(5, salaryRange);
                    ps.setString(6, jobDescription);
                    ps.setString(7, companyName);
                    ps.setString(8, location);
                    ps.setString(9, applicationDeadline);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        isSuccess = true;
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("JobPostServlet: Database error: " + e.getMessage());
        }

        if (isSuccess) {
            response.sendRedirect("CompanyDashboard.jsp?success=JobPosted");
        } else {
            response.sendRedirect("JobPost.jsp?error=Failed");
        }
    }

    private Connection getConnection() throws ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String[] passes = {"root", "password", ""};
        for (String pass : passes) {
            try {
                return DriverManager.getConnection(DB_URL, DB_USER, pass);
            } catch (SQLException e) {
                // Try next password fallback
            }
        }
        return null;
    }

    private void checkAndPrepareDatabaseSchema(Connection conn) {
        try {
            DatabaseMetaData dbm = conn.getMetaData();
            
            // Check if jobs table exists
            try (ResultSet rs = dbm.getTables(null, null, "jobs", null)) {
                if (!rs.next()) {
                    // Create jobs table
                    try (Statement stmt = conn.createStatement()) {
                        String sql = "CREATE TABLE jobs (" +
                                "id INT AUTO_INCREMENT PRIMARY KEY," +
                                "company_name VARCHAR(255)," +
                                "job_title VARCHAR(255) NOT NULL," +
                                "employment_type VARCHAR(100)," +
                                "department VARCHAR(100)," +
                                "location_type VARCHAR(100)," +
                                "location VARCHAR(255)," +
                                "salary_range VARCHAR(100)," +
                                "application_deadline VARCHAR(100)," +
                                "job_description TEXT" +
                                ")";
                        stmt.executeUpdate(sql);
                        System.out.println("JobPostServlet: jobs table created successfully.");
                    }
                } else {
                    // Table exists, check and add missing columns
                    try (Statement stmt = conn.createStatement()) {
                        List<String> currentCols = new ArrayList<>();
                        try (ResultSet cols = dbm.getColumns(null, null, "jobs", null)) {
                            while (cols.next()) {
                                currentCols.add(cols.getString("COLUMN_NAME").toLowerCase());
                            }
                        }
                        
                        if (!currentCols.contains("company_name") && !currentCols.contains("companyname")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN company_name VARCHAR(255)");
                        }
                        if (!currentCols.contains("location")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN location VARCHAR(255)");
                        }
                        if (!currentCols.contains("application_deadline") && !currentCols.contains("applicationdeadline")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN application_deadline VARCHAR(100)");
                        }
                        if (!currentCols.contains("job_description") && !currentCols.contains("jobdescription")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN job_description TEXT");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("JobPostServlet: Error verifying/updating database schema: " + e.getMessage());
        }
    }

    private String normalizeEditorHtml(String jobDescription) {
        if (jobDescription == null) {
            return "";
        }
        return jobDescription.trim();
    }
}
