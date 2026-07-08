import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 2) // 2MB max file size
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        String department = request.getParameter("department");
        String cgpa = request.getParameter("cgpa");
        String languages = request.getParameter("languages");
        
        String skills = request.getParameter("skills");

        Part photoPart = request.getPart("photo");
        if (photoPart != null && photoPart.getSize() > 0) {
            String fileName = java.nio.file.Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + "uploads";
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            photoPart.write(uploadPath + java.io.File.separator + fileName);
        }
        
        boolean isUpdated = false;

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            
            int studentId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT STUDENT_ID FROM STUDENT WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentId = rs.getInt("STUDENT_ID");
                    }
                }
            }
            
            if (studentId != -1) {
                // Update STUDENT
                try (PreparedStatement ps = conn.prepareStatement("UPDATE STUDENT SET fullName = ?, password = ? WHERE STUDENT_ID = ?")) {
                    ps.setString(1, name);
                    ps.setString(2, password);
                    ps.setInt(3, studentId);
                    ps.executeUpdate();
                }
                
                // Check if Academic Details exist
                boolean academicExists = false;
                try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM ACCADEMIC_DETAILS WHERE STUDENT_ID = ?")) {
                    ps.setInt(1, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        academicExists = rs.next();
                    }
                }
                
                double dgpaVal = 0.0;
                try {
                    dgpaVal = Double.parseDouble(cgpa);
                } catch (Exception e) {
                    // Ignore
                }
                
                if (academicExists) {
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE ACCADEMIC_DETAILS SET department = ?, dgpa = ? WHERE STUDENT_ID = ?")) {
                        ps.setString(1, department);
                        ps.setDouble(2, dgpaVal);
                        ps.setInt(3, studentId);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement("INSERT INTO ACCADEMIC_DETAILS (STUDENT_ID, collegeName, department, dgpa) VALUES (?, ?, ?, ?)")) {
                        ps.setInt(1, studentId);
                        ps.setString(2, "Unknown College");
                        ps.setString(3, department);
                        ps.setDouble(4, dgpaVal);
                        ps.executeUpdate();
                    }
                }
                
                // Check if Skills exist
                boolean skillsExists = false;
                try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM STUDENT_SKILLS WHERE STUDENT_ID = ?")) {
                    ps.setInt(1, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        skillsExists = rs.next();
                    }
                }
                
                // Parse comma-separated skills into JSON array
                StringBuilder jsonSkills = new StringBuilder("[");
                if (skills != null && !skills.trim().isEmpty()) {
                    String[] arr = skills.split(",");
                    for (int i = 0; i < arr.length; i++) {
                        if (i > 0) jsonSkills.append(",");
                        jsonSkills.append("\"").append(arr[i].trim().replace("\"", "\\\"")).append("\"");
                    }
                }
                jsonSkills.append("]");
                
                if (skillsExists) {
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE STUDENT_SKILLS SET languages = ?, skills = ? WHERE STUDENT_ID = ?")) {
                        ps.setString(1, languages != null ? languages : "English");
                        ps.setString(2, jsonSkills.toString());
                        ps.setInt(3, studentId);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement("INSERT INTO STUDENT_SKILLS (STUDENT_ID, languages, skills) VALUES (?, ?, ?)")) {
                        ps.setInt(1, studentId);
                        ps.setString(2, languages != null ? languages : "English");
                        ps.setString(3, jsonSkills.toString());
                        ps.executeUpdate();
                    }
                }
                
                conn.commit();
                isUpdated = true;
            } else {
                conn.rollback();
            }
        } catch (Exception e) {
            System.err.println("UpdateProfileServlet: Error during update: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Update session profile complete percentage
        // Update session profile complete percentage
        request.getSession().setAttribute("profileComplete", 100);

        request.setAttribute("message", "Profile updated successfully!");
        request.getRequestDispatcher("StudentProfile.jsp").forward(request, response);
    }
}
