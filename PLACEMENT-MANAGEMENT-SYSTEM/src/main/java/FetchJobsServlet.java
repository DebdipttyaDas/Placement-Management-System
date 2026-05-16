import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/FetchJobsServlet")
public class FetchJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        StringBuilder json = new StringBuilder();
        json.append("[");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM jobs"; // No order by id just in case id is missing
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                String title = escapeJson(rs.getString("job_title"));
                String department = escapeJson(rs.getString("department"));
                String employmentType = escapeJson(rs.getString("employment_type"));
                String locationType = escapeJson(rs.getString("location_type"));
                String salary = escapeJson(rs.getString("salary_range"));
                
                // job_description could contain html tags since it is formatted by contenteditable in JobPost.jsp
                String description = escapeJson(rs.getString("job_description"));

                json.append("{")
                        .append("\"job_title\":\"").append(title).append("\",")
                        .append("\"department\":\"").append(department).append("\",")
                        .append("\"employment_type\":\"").append(employmentType).append("\",")
                        .append("\"location_type\":\"").append(locationType).append("\",")
                        .append("\"salary_range\":\"").append(salary).append("\",")
                        .append("\"job_description\":\"").append(description).append("\"")
                        .append("}");
            }
            conn.close();
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
