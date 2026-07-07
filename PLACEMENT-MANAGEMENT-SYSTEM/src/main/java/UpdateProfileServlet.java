import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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

        try {
            // Update the record based on email, which should be unique to the user
            String updateQuery = "UPDATE students SET full_name = ?, password = ?, department = ?, cgpa = ?, languages = ?, skills = ? WHERE email = ?";
            
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                
                ps.setString(1, name);
                ps.setString(2, password);
                ps.setString(3, department);
                ps.setString(4, cgpa);
                ps.setString(5, languages);
                ps.setString(6, skills);
                ps.setString(7, email);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    isUpdated = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Update session profile complete percentage
        // Update session profile complete percentage
        request.getSession().setAttribute("profileComplete", 100);

        request.setAttribute("message", "Profile updated successfully!");
        request.getRequestDispatcher("StudentProfile.jsp").forward(request, response);
    }
}
