import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/FetchFormMetadataServlet")
public class FetchFormMetadataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        String url = "jdbc:mysql://localhost:3306/placement_management";
        try {
            return DriverManager.getConnection(url, "root", "root");
        } catch (SQLException e) {
            return DriverManager.getConnection(url, "root", "password");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        StringBuilder json = new StringBuilder();
        json.append("{");

        Connection conn = null;
        PreparedStatement psComp = null;
        PreparedStatement psStud = null;
        ResultSet rsComp = null;
        ResultSet rsStud = null;

        try {
            conn = getConnection();

            // 1. Fetch approved companies
            String compSql = "SELECT company_name FROM companies WHERE status = 'APPROVED'";
            psComp = conn.prepareStatement(compSql);
            rsComp = psComp.executeQuery();

            json.append("\"companies\":[");
            boolean firstComp = true;
            while (rsComp.next()) {
                if (!firstComp) {
                    json.append(",");
                }
                firstComp = false;
                String cName = rsComp.getString("company_name").replace("\"", "\\\"");
                json.append("\"").append(cName).append("\"");
            }
            json.append("],");

            // 2. Fetch registered students
            String studSql = "SELECT full_name, email FROM students";
            psStud = conn.prepareStatement(studSql);
            rsStud = psStud.executeQuery();

            json.append("\"students\":[");
            boolean firstStud = true;
            while (rsStud.next()) {
                if (!firstStud) {
                    json.append(",");
                }
                firstStud = false;
                String sName = rsStud.getString("full_name").replace("\"", "\\\"");
                String sEmail = rsStud.getString("email").replace("\"", "\\\"");
                json.append("{")
                    .append("\"name\":\"").append(sName).append("\",")
                    .append("\"email\":\"").append(sEmail).append("\"")
                    .append("}");
            }
            json.append("]");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            json.setLength(0); // clear
            json.append("{\"error\":\"").append(e.getMessage().replace("\"", "\\\"")).append("\"}");
        } finally {
            try { if (rsComp != null) rsComp.close(); } catch (Exception e) {}
            try { if (psComp != null) psComp.close(); } catch (Exception e) {}
            try { if (rsStud != null) rsStud.close(); } catch (Exception e) {}
            try { if (psStud != null) psStud.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        json.append("}");
        out.print(json.toString());
    }
}
