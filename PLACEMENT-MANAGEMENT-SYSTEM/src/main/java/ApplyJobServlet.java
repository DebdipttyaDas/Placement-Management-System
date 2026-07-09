import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ApplyJobServlet")
public class ApplyJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String studentEmail = session != null ? (String) session.getAttribute("studentEmail") : null;
        if (studentEmail == null && session != null) {
            studentEmail = (String) session.getAttribute("user");
        }

        if (studentEmail == null) {
            response.sendRedirect("Login.jsp?role=student");
            return;
        }

        String companyName = request.getParameter("companyName");
        String jobTitle = request.getParameter("jobTitle");
        String department = request.getParameter("department");
        String employmentType = request.getParameter("employmentType");
        String locationType = request.getParameter("locationType");
        String location = request.getParameter("location");
        String salary = request.getParameter("salary");

        boolean isSuccess = false;

        try (Connection conn = DBUtil.getConnection()) {
            Integer studentId = null;
            try (PreparedStatement ps = conn.prepareStatement("SELECT STUDENT_ID FROM STUDENT WHERE email = ?")) {
                ps.setString(1, studentEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentId = rs.getInt("STUDENT_ID");
                    }
                }
            }

            if (studentId != null) {
                String sql = "INSERT INTO APPLICATION (STUDENT_ID, companyName, jobTitle, department, employmentType, LocationType, Location, salary) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, studentId);
                    ps.setString(2, companyName != null ? companyName : "Unknown");
                    ps.setString(3, jobTitle != null ? jobTitle : "Unknown");
                    ps.setString(4, department != null ? department : "Unknown");
                    ps.setString(5, employmentType != null ? employmentType : "Full-time");
                    ps.setString(6, locationType != null ? locationType : "On-site");
                    ps.setString(7, location != null ? location : "Unknown");
                    ps.setString(8, salary != null ? salary : "Not specified");

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        isSuccess = true;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("ApplyJobServlet Error: " + e.getMessage());
            e.printStackTrace();
        }

        if (isSuccess) {
            response.sendRedirect("MyApplication.jsp?success=Applied");
        } else {
            response.sendRedirect("Placement.jsp?error=ApplicationFailed");
        }
    }
}
