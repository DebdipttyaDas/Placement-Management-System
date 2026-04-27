import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/StudentRegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    
    // Upload directory path
    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String collegeName = request.getParameter("collegeName");
        String department = request.getParameter("department");
        String year = request.getParameter("year");
        String cgpa = request.getParameter("cgpa");
        String dob = request.getParameter("dob");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Handle skills (multiple checkboxes)
        String[] skillsArray = request.getParameterValues("skills");
        String otherSkill = request.getParameter("other_skill");
        
        List<String> skillsList = new ArrayList<>();
        if (skillsArray != null) {
            skillsList.addAll(Arrays.asList(skillsArray));
        }
        if (otherSkill != null && !otherSkill.trim().isEmpty()) {
            skillsList.add(otherSkill.trim());
        }
        String combinedSkills = String.join(", ", skillsList);

        // Handle file uploads
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String resumeFileName = extractFileName(request.getPart("resume"));
        String photoFileName = extractFileName(request.getPart("photo"));
        
        // Save files to server directory (uncomment to enable physical saving)
        /*
        if (resumeFileName != null && !resumeFileName.isEmpty()) {
            request.getPart("resume").write(uploadFilePath + File.separator + resumeFileName);
        }
        if (photoFileName != null && !photoFileName.isEmpty()) {
            request.getPart("photo").write(uploadFilePath + File.separator + photoFileName);
        }
        */

        boolean isRegistered = false;

        // Perform Database Insertion
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            String insertQuery = "INSERT INTO students (full_name, college_name, department, year, cgpa, dob, email, password, skills, resume_path, photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                
                ps.setString(1, fullName);
                ps.setString(2, collegeName);
                ps.setString(3, department);
                ps.setString(4, year);
                ps.setString(5, cgpa);
                ps.setString(6, dob);
                ps.setString(7, email);
                ps.setString(8, password);
                ps.setString(9, combinedSkills);
                ps.setString(10, resumeFileName);
                ps.setString(11, photoFileName);
                
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
            request.getRequestDispatcher("StudentRegister.html").forward(request, response);
        }
    }

    // Helper method to extract file name from HTTP header content-disposition
    private String extractFileName(Part part) {
        if (part == null) return null;
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }
}
