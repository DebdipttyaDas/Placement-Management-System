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
import jakarta.servlet.http.HttpSession;

@WebServlet("/FetchInterviewsServlet")
public class FetchInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String se = (String) session.getAttribute("studentEmail");
        // Fallback to example if not logged in for testing
        String studentEmail = se != null ? se : "student@example.com";

        String fetchAllParam = request.getParameter("all");
        boolean fetchAll = "true".equals(fetchAllParam);

        StringBuilder json = new StringBuilder();
        json.append("[");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/placement_management";
            Connection conn = DriverManager.getConnection(url, "root", "password");

            String sql;
            PreparedStatement ps;

            if (fetchAll) {
                sql = "SELECT * FROM interview_slots ORDER BY interview_date ASC, interview_time ASC";
                ps = conn.prepareStatement(sql);
            } else {
                sql = "SELECT * FROM interview_slots WHERE student_email=? ORDER BY interview_date ASC, interview_time ASC LIMIT 3";
                ps = conn.prepareStatement(sql);
                ps.setString(1, studentEmail);
            }

            ResultSet rs = ps.executeQuery();

            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                String cName = rs.getString("company_name").replace("\"", "\\\"");
                String iDate = rs.getString("interview_date");
                String iTime = rs.getString("interview_time");
                String round = rs.getString("interview_round").replace("\"", "\\\"");
                String meetLink = rs.getString("meet_link") != null ? rs.getString("meet_link").replace("\"", "\\\"")
                        : "#";
                String interviewer = rs.getString("interviewer_name").replace("\"", "\\\"");
                String sName = rs.getString("student_name").replace("\"", "\\\"");

                json.append("{")
                        .append("\"company_name\":\"").append(cName).append("\",")
                        .append("\"interview_date\":\"").append(iDate).append("\",")
                        .append("\"interview_time\":\"").append(iTime).append("\",")
                        .append("\"interview_round\":\"").append(round).append("\",")
                        .append("\"meet_link\":\"").append(meetLink).append("\",")
                        .append("\"student_name\":\"").append(sName).append("\",")
                        .append("\"interviewer_name\":\"").append(interviewer).append("\"")
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
}
