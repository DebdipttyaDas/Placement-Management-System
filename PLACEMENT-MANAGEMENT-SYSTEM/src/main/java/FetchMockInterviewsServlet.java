import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/FetchMockInterviewsServlet")
public class FetchMockInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final MockInterviewDAO dao = new MockInterviewDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("[]");
            return;
        }

        String studentEmail = (String) session.getAttribute("studentEmail");
        if (studentEmail == null || studentEmail.isEmpty()) {
            studentEmail = (String) session.getAttribute("user");
        }

        List<MockInterview> list = dao.getMockInterviewsByStudent(studentEmail);

        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < list.size(); i++) {
            MockInterview interview = list.get(i);
            if (i > 0) json.append(",");
            
            json.append("{")
                .append("\"id\":").append(interview.getId()).append(",")
                .append("\"jobRole\":\"").append(escapeJsonString(interview.getJobRole())).append("\",")
                .append("\"difficulty\":\"").append(escapeJsonString(interview.getDifficulty())).append("\",")
                .append("\"numQuestions\":").append(interview.getNumQuestions()).append(",")
                .append("\"score\":").append(interview.getScore()).append(",")
                .append("\"feedback\":\"").append(escapeJsonString(interview.getFeedback())).append("\",")
                .append("\"status\":\"").append(escapeJsonString(interview.getStatus())).append("\",")
                .append("\"createdAt\":\"").append(escapeJsonString(interview.getCreatedAt() != null ? interview.getCreatedAt().toString() : "")).append("\"")
                .append("}");
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    private String escapeJsonString(String data) {
        if (data == null) return "";
        return data.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
