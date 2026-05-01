import java.io.IOException;
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
        
        String skill1 = request.getParameter("skill1");
        String skill2 = request.getParameter("skill2");
        String skill3 = request.getParameter("skill3");
        String skill4 = request.getParameter("skill4");
        String otherSkills = request.getParameter("otherSkills");

        Part photoPart = request.getPart("photo");

        // TODO: Add logic to update student profile and handle file upload in database/filesystem

        request.setAttribute("message", "Profile updated successfully!");
        request.getRequestDispatcher("StudentProfile.jsp").forward(request, response);
    }
}
