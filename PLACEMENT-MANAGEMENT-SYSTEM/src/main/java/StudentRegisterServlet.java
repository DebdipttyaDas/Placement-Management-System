import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            
            String insertStudent = "INSERT INTO STUDENT (fullName, dob, email, password, phone, photo, resume) VALUES (?, ?, ?, ?, ?, ?, ?)";
            int studentId = -1;
            
            Part photoPart = request.getPart("photo");
            Part resumePart = request.getPart("resume");
            byte[] photoBytes = (photoPart != null && photoPart.getSize() > 0) ? photoPart.getInputStream().readAllBytes() : new byte[0];
            byte[] resumeBytes = (resumePart != null && resumePart.getSize() > 0) ? resumePart.getInputStream().readAllBytes() : new byte[0];
            
            String phone = request.getParameter("phone");
            if (phone == null || phone.trim().isEmpty()) {
                phone = "0000000000";
            }
            
            try (PreparedStatement ps = conn.prepareStatement(insertStudent, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, fullName);
                ps.setString(2, dob != null ? dob : "2000-01-01");
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setString(5, phone);
                ps.setBytes(6, photoBytes);
                ps.setBytes(7, resumeBytes);
                
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        studentId = rs.getInt(1);
                    }
                }
            }
            
            if (studentId != -1) {
                // Insert Academic Details
                String insertAcademic = "INSERT INTO ACCADEMIC_DETAILS (STUDENT_ID, collegeName, department, dgpa) VALUES (?, ?, ?, ?)";
                double dgpaVal = 0.0;
                try {
                    dgpaVal = Double.parseDouble(cgpa);
                } catch (Exception e) {
                    // Ignore
                }
                
                try (PreparedStatement ps = conn.prepareStatement(insertAcademic)) {
                    ps.setInt(1, studentId);
                    ps.setString(2, collegeName != null ? collegeName : "Unknown College");
                    ps.setString(3, department != null ? department : "CSE");
                    ps.setDouble(4, dgpaVal);
                    ps.executeUpdate();
                }
                
                // Insert Student Skills
                String insertSkills = "INSERT INTO STUDENT_SKILLS (STUDENT_ID, languages, skills) VALUES (?, ?, ?)";
                StringBuilder jsonSkills = new StringBuilder("[");
                for (int i = 0; i < skillsList.size(); i++) {
                    if (i > 0) jsonSkills.append(",");
                    jsonSkills.append("\"").append(skillsList.get(i).replace("\"", "\\\"")).append("\"");
                }
                jsonSkills.append("]");
                
                try (PreparedStatement ps = conn.prepareStatement(insertSkills)) {
                    ps.setInt(1, studentId);
                    ps.setString(2, "English"); // default language
                    ps.setString(3, jsonSkills.toString());
                    ps.executeUpdate();
                }
                
                conn.commit();
                isRegistered = true;
            } else {
                conn.rollback();
            }
        } catch (Exception e) {
            System.err.println("StudentRegisterServlet: Error during registration: " + e.getMessage());
            e.printStackTrace();
        }

        // Handle Response
        if (isRegistered) {
            // Registration successful
            request.setAttribute("successMessage", "Registration Successful! Please login.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration Failed. Please try again.");
            request.getRequestDispatcher("StudentRegister.jsp").forward(request, response);
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
