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

@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String adminId = request.getParameter("adminId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // Database configuration
        String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
        String DB_USER = "root";
        String DB_PASSWORD = "root";
        
        boolean isUpdated = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String updateQuery = "UPDATE admin SET username = ?, email = ?, password = ?, phone = ? WHERE admin_id = ? OR username = ?";
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, phone);
                ps.setString(5, adminId);
                ps.setString(6, adminId); // Fallback if adminId is actually username
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    isUpdated = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("message", "Failed to update profile. Please check Admin ID.");
        }
        
        request.getRequestDispatcher("AdminProfile.jsp").forward(request, response);
    }
}
