import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/FetchJobsServlet")
public class FetchJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        String companyName = null;
        if (session != null && "company".equals(session.getAttribute("role"))) {
            companyName = (String) session.getAttribute("companyName");
        }

        StringBuilder json = new StringBuilder();
        json.append("[");
        
        String sql;
        if (companyName != null) {
            sql = "SELECT j.*, "
                + "(SELECT COUNT(*) FROM APPLICATION a WHERE a.companyName = j.companyName AND a.jobTitle = j.jobTitle) AS total_applicants "
                + "FROM JOB_DETAILS j WHERE j.companyName = ?";
        } else {
            sql = "SELECT j.*, "
                + "(SELECT COUNT(*) FROM APPLICATION a WHERE a.companyName = j.companyName AND a.jobTitle = j.jobTitle) AS total_applicants "
                + "FROM JOB_DETAILS j";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (companyName != null) {
                ps.setString(1, companyName);
            }

            try (ResultSet rs = ps.executeQuery()) {
                boolean first = true;
                
                while (rs.next()) {
                    if (!first) {
                        json.append(",");
                    }
                    first = false;

                    String title = escapeJson(rs.getString("jobTitle"));
                    String department = escapeJson(rs.getString("department"));
                    String employmentType = escapeJson(rs.getString("employmentType"));
                    String locationType = escapeJson(rs.getString("LocationType"));
                    String location = escapeJson(rs.getString("Location"));
                    String salary = escapeJson(rs.getString("salary"));
                    String deadline = escapeJson(rs.getString("applicationDeadline"));
                    String description = escapeJson(rs.getString("jobDescription"));
                    String compName = escapeJson(rs.getString("companyName"));
                    int totalApplicants = rs.getInt("total_applicants");

                    json.append("{")
                        .append("\"job_title\":\"").append(title).append("\",")
                        .append("\"department\":\"").append(department).append("\",")
                        .append("\"employment_type\":\"").append(employmentType).append("\",")
                        .append("\"location_type\":\"").append(locationType).append("\",")
                        .append("\"location\":\"").append(location).append("\",")
                        .append("\"salary_range\":\"").append(salary).append("\",")
                        .append("\"application_deadline\":\"").append(deadline).append("\",")
                        .append("\"job_description\":\"").append(description).append("\",")
                        .append("\"company_name\":\"").append(compName).append("\",")
                        .append("\"total_applicants\":").append(totalApplicants)
                        .append("}");
                }
            }
            
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("[]");
        }
    }
    
    private String escapeJson(String data) {
        if (data == null) {
            return "";
        }
        return data.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
