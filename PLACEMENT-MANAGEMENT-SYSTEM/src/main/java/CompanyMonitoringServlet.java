import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CompanyMonitoringServlet")
public class CompanyMonitoringServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> jobsList = new ArrayList<>();
        boolean dbSuccess = false;

        try (Connection conn = getConnection()) {
            if (conn != null) {
                // Auto-update or verify table schema
                checkAndPrepareDatabaseSchema(conn);

                // Fetch jobs from database
                String sql = "SELECT * FROM jobs ORDER BY id DESC";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> job = new HashMap<>();
                        // Map database fields. Support both snake_case and camelCase column naming
                        // fallback
                        job.put("id", String.valueOf(rs.getObject("id")));
                        job.put("companyName", getColumnValue(rs, "company_name", "companyName", "Unknown Company"));
                        job.put("jobTitle", getColumnValue(rs, "job_title", "jobTitle", "Untitled Role"));
                        job.put("employmentType", getColumnValue(rs, "employment_type", "employmentType", "Full-time"));
                        job.put("department", getColumnValue(rs, "department", "department", "All"));
                        job.put("locationType", getColumnValue(rs, "location_type", "locationType", "On-site"));
                        job.put("location", getColumnValue(rs, "location", "location", "India"));
                        job.put("salary", getColumnValue(rs, "salary_range", "salary", "Not specified"));
                        job.put("applicationDeadline",
                                getColumnValue(rs, "application_deadline", "applicationDeadline", "N/A"));
                        job.put("jobDescription",
                                getColumnValue(rs, "job_description", "jobDescription", "No description provided."));
                        jobsList.add(job);
                    }
                    dbSuccess = true;
                }
            }
        } catch (Exception e) {
            System.err.println("CompanyMonitoringServlet: Database connection/query error: " + e.getMessage());
            // Fail silently and use fallback
        }

        // If database query failed or returned no data, use the demo database fallback
        if (!dbSuccess || jobsList.isEmpty()) {
            System.out.println("CompanyMonitoringServlet: Using demo database fallback data.");
            jobsList = getDemoJobs();
        }

        request.setAttribute("jobsList", jobsList);
        request.getRequestDispatcher("CompanyMonitoring.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private Connection getConnection() {
        // 1. Try loading from db.properties
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);
                String url = prop.getProperty("url");
                String user = prop.getProperty("username");
                String pass = prop.getProperty("password");
                if (url != null && user != null && pass != null) {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    return DriverManager.getConnection(url, user, pass);
                }
            }
        } catch (Exception e) {
            // Ignore and fall back
        }

        // 2. Fall back to local database with typical credentials
        String dbUrl = "jdbc:mysql://localhost:3306/placement_management";
        String[] passes = { "root", "password", "" };
        for (String pass : passes) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                return DriverManager.getConnection(dbUrl, "root", pass);
            } catch (Exception e) {
                // Try next password
            }
        }
        return null;
    }

    private String getColumnValue(ResultSet rs, String snakeName, String camelName, String defaultValue) {
        try {
            // Try snake_case first
            String val = rs.getString(snakeName);
            if (val != null)
                return val;
        } catch (SQLException e1) {
            // Ignore and try camelCase
        }
        try {
            // Try camelCase second
            String val = rs.getString(camelName);
            if (val != null)
                return val;
        } catch (SQLException e2) {
            // Ignore and return default
        }
        return defaultValue;
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
                        System.out.println("CompanyMonitoringServlet: jobs table created successfully.");
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
                        if (!currentCols.contains("application_deadline")
                                && !currentCols.contains("applicationdeadline")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN application_deadline VARCHAR(100)");
                        }
                        if (!currentCols.contains("job_description") && !currentCols.contains("jobdescription")) {
                            stmt.executeUpdate("ALTER TABLE jobs ADD COLUMN job_description TEXT");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("CompanyMonitoringServlet: Error verifying/updating database schema: " + e.getMessage());
        }
    }

    private List<Map<String, String>> getDemoJobs() {
        List<Map<String, String>> demoList = new ArrayList<>();

        Map<String, String> job1 = new HashMap<>();
        job1.put("id", "1");
        job1.put("companyName", "TechCorp Solutions");
        job1.put("jobTitle", "Software Engineering Intern");
        job1.put("employmentType", "Internship");
        job1.put("department", "CSE");
        job1.put("locationType", "Hybrid");
        job1.put("location", "San Francisco, CA");
        job1.put("salary", "₹15,000/month");
        job1.put("applicationDeadline", "2026-06-30");
        job1.put("jobDescription",
                "<p>We are looking for a Software Engineering Intern to join our team. You will work on Java, JSP, and MySQL projects.</p>");
        demoList.add(job1);

        Map<String, String> job2 = new HashMap<>();
        job2.put("id", "2");
        job2.put("companyName", "Innovate Labs");
        job2.put("jobTitle", "Associate Front-End Developer");
        job2.put("employmentType", "Full-time");
        job2.put("department", "IT");
        job2.put("locationType", "Remote");
        job2.put("location", "Bangalore, India");
        job2.put("salary", "₹45,000/month");
        job2.put("applicationDeadline", "2026-07-15");
        job2.put("jobDescription",
                "<p>Join us as a Front-End Developer. Experience with HTML, CSS, JavaScript, and React is preferred.</p>");
        demoList.add(job2);

        Map<String, String> job3 = new HashMap<>();
        job3.put("id", "3");
        job3.put("companyName", "Quantum Finance");
        job3.put("jobTitle", "Data Analyst");
        job3.put("employmentType", "Full-time");
        job3.put("department", "MBA");
        job3.put("locationType", "On-site");
        job3.put("location", "Mumbai, India");
        job3.put("salary", "₹60,000/month");
        job3.put("applicationDeadline", "2026-06-25");
        job3.put("jobDescription",
                "<p>Looking for a Data Analyst to process financial information. Experience with Python, SQL, and Excel required.</p>");
        demoList.add(job3);

        return demoList;
    }
}
