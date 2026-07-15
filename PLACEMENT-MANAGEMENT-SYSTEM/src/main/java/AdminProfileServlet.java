import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String sessionUser = session != null ? (String) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect("Login.jsp?role=admin");
            return;
        }

        String adminName = request.getParameter("adminName");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        if (password != null && !password.trim().isEmpty() && password.trim().length() > 10) {
            request.setAttribute("message", "Password must be at most 10 characters.");
            request.getRequestDispatcher("AdminProfile.jsp").forward(request, response);
            return;
        }

        boolean isUpdated = false;

        String updateQuery;
        boolean hasPassword = (password != null && !password.trim().isEmpty());
        if (hasPassword) {
            updateQuery = "UPDATE ADMIN_PROFILE SET adminName = ?, userName = ?, email = ?, password = ?, phone = ? WHERE userName = ?";
        } else {
            updateQuery = "UPDATE ADMIN_PROFILE SET adminName = ?, userName = ?, email = ?, phone = ? WHERE userName = ?";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateQuery)) {

            ps.setString(1, adminName);
            ps.setString(2, userName);
            ps.setString(3, email);
            if (hasPassword) {
                ps.setString(4, password.trim());
                ps.setString(5, phone);
                ps.setString(6, sessionUser);
            } else {
                ps.setString(4, phone);
                ps.setString(5, sessionUser);
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {
                isUpdated = true;
                session.setAttribute("user", userName);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("message", "Failed to update profile.");
        }

        request.getRequestDispatcher("AdminProfile.jsp").forward(request, response);
    }
}