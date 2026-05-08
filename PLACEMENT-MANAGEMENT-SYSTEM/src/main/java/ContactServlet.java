import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Database configuration
        String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
        String DB_USER = "root";
        String DB_PASSWORD = "root";
        
        boolean isInserted = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String insertQuery = "INSERT INTO contacts (name, email, subject, message) VALUES (?, ?, ?, ?)";
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, subject);
                ps.setString(4, message);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    isInserted = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isInserted) {
            request.setAttribute("message", "Message sent successfully!");
        } else {
            request.setAttribute("message", "Failed to send message. Please try again later.");
        }
        
        request.getRequestDispatcher("Contact.jsp").forward(request, response);
    }
}
