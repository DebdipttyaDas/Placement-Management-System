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

@WebServlet("/ReviewApplicationsServlet")
public class ReviewApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        String companyName = session != null ? (String) session.getAttribute("companyName") : null;
        
        PrintWriter out = response.getWriter();
        
        if (companyName == null || companyName.trim().isEmpty()) {
            out.print("[]");
            out.flush();
            return;
        }
        
        String action = request.getParameter("action");
        if ("list".equalsIgnoreCase(action)) {
            StringBuilder json = new StringBuilder("[");
            String sql = "SELECT a.APPLICATION_ID, s.fullName, s.email, s.phone, a.jobTitle, a.department, a.salary "
                       + "FROM APPLICATION a "
                       + "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID "
                       + "WHERE a.companyName = ? AND (a.status IS NULL OR a.status = '' OR a.status = 'Applied') "
                       + "ORDER BY a.APPLICATION_ID DESC";
                       
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setString(1, companyName.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) {
                            json.append(",");
                        }
                        first = false;
                        json.append("{");
                        json.append("\"applicationId\":").append(rs.getInt("APPLICATION_ID")).append(",");
                        json.append("\"fullName\":\"").append(escapeJson(rs.getString("fullName"))).append("\",");
                        json.append("\"email\":\"").append(escapeJson(rs.getString("email"))).append("\",");
                        json.append("\"phone\":\"").append(escapeJson(rs.getString("phone"))).append("\",");
                        json.append("\"jobTitle\":\"").append(escapeJson(rs.getString("jobTitle"))).append("\",");
                        json.append("\"department\":\"").append(escapeJson(rs.getString("department"))).append("\",");
                        json.append("\"salary\":\"").append(escapeJson(rs.getString("salary"))).append("\"");
                        json.append("}");
                    }
                }
            } catch (Exception e) {
                System.err.println("ReviewApplicationsServlet GET error: " + e.getMessage());
                e.printStackTrace();
            }
            json.append("]");
            out.print(json.toString());
        } else {
            out.print("[]");
        }
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        String companyName = session != null ? (String) session.getAttribute("companyName") : null;
        
        PrintWriter out = response.getWriter();
        
        if (companyName == null || companyName.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Session invalid or company not logged in\"}");
            out.flush();
            return;
        }
        
        String action = request.getParameter("action");
        String appIdStr = request.getParameter("applicationId");
        
        if (appIdStr == null || appIdStr.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing applicationId\"}");
            out.flush();
            return;
        }
        
        int applicationId = Integer.parseInt(appIdStr.trim());
        boolean isSuccess = false;
        String errorMessage = "";
        
        if ("approve".equalsIgnoreCase(action)) {
            String sql = "UPDATE APPLICATION SET status = 'Approved' WHERE APPLICATION_ID = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, applicationId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    isSuccess = true;
                } else {
                    errorMessage = "Application not found or no changes made";
                }
            } catch (Exception e) {
                errorMessage = e.getMessage();
                e.printStackTrace();
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            String selectSql = "SELECT s.email, s.fullName, a.jobTitle, a.companyName "
                             + "FROM APPLICATION a "
                             + "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID "
                             + "WHERE a.APPLICATION_ID = ?";
            String studentEmail = null;
            String studentName = null;
            String jobTitle = null;
            String appCompanyName = null;
            
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, applicationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentEmail = rs.getString("email");
                        studentName = rs.getString("fullName");
                        jobTitle = rs.getString("jobTitle");
                        appCompanyName = rs.getString("companyName");
                    }
                }
            } catch (Exception e) {
                System.err.println("Error fetching details for rejection: " + e.getMessage());
            }
            
            String updateSql = "UPDATE APPLICATION SET status = 'Rejected' WHERE APPLICATION_ID = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, applicationId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    isSuccess = true;
                    // Trigger rejection email workflow
                    if (studentEmail != null) {
                        triggerRejectionEmailWorkflow(studentEmail, studentName, jobTitle, appCompanyName);
                    }
                } else {
                    errorMessage = "Application not found or no changes made";
                }
            } catch (Exception e) {
                errorMessage = e.getMessage();
                e.printStackTrace();
            }
        } else {
            errorMessage = "Invalid action";
        }
        
        if (isSuccess) {
            out.print("{\"success\":true}");
        } else {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(errorMessage) + "\"}");
        }
        out.flush();
    }
    
    private void triggerRejectionEmailWorkflow(String email, String fullName, String jobTitle, String companyName) {
        System.out.println("----------------------------------------");
        System.out.println("REJECTION NOTIFICATION GENERATED:");
        System.out.println("Student Email: " + email);
        System.out.println("Student Name:  " + fullName);
        System.out.println("Job Title:     " + jobTitle);
        System.out.println("Company:       " + companyName);
        System.out.println("----------------------------------------");
        
        String jsonPayload = String.format(
            "{\"email\":\"%s\",\"fullName\":\"%s\",\"jobTitle\":\"%s\",\"companyName\":\"%s\"}",
            escapeJson(email), escapeJson(fullName), escapeJson(jobTitle), escapeJson(companyName)
        );
        try {
            // Trigger the rejection webhook
            WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/reject-student", jsonPayload);
            if (!result.success) {
                System.err.println("Failed to send student rejection email webhook: " + result.errorMessage);
            } else {
                System.out.println("Student rejection email webhook successfully triggered.");
            }
        } catch (Exception e) {
            System.err.println("Error triggering student rejection email webhook: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private String escapeJson(String val) {
        if (val == null) return "";
        return val.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
