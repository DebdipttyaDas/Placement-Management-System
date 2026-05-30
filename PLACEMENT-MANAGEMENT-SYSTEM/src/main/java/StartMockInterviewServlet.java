import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StartMockInterviewServlet")
public class StartMockInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String N8N_WEBHOOK_URL = "http://localhost:5678/webhook/mock-interview";

    private final MockInterviewDAO dao = new MockInterviewDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Session expired or user not logged in. Please log in as a student.\"}");
            return;
        }

        String studentEmail = (String) session.getAttribute("studentEmail");
        if (studentEmail == null || studentEmail.isEmpty()) {
            studentEmail = (String) session.getAttribute("user");
        }

        // Read request parameters
        String jobRole = request.getParameter("jobRole");
        String difficulty = request.getParameter("difficulty");
        String numQuestionsStr = request.getParameter("numQuestions");

        if (jobRole == null || jobRole.trim().isEmpty() ||
            difficulty == null || difficulty.trim().isEmpty() ||
            numQuestionsStr == null || numQuestionsStr.trim().isEmpty()) {
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Missing required parameters: jobRole, difficulty, numQuestions.\"}");
            return;
        }

        int numQuestions;
        try {
            numQuestions = Integer.parseInt(numQuestionsStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid numQuestions format.\"}");
            return;
        }

        // 1. Create a mock interview record in the database
        MockInterview interview = new MockInterview();
        interview.setStudentEmail(studentEmail);
        interview.setJobRole(jobRole);
        interview.setDifficulty(difficulty);
        interview.setNumQuestions(numQuestions);
        interview.setScore(0);
        interview.setFeedback("");
        interview.setStatus("STARTED");

        int interviewId = dao.createMockInterview(interview);
        if (interviewId == -1) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to create interview session in database.\"}");
            return;
        }

        // 2. Trigger n8n Webhook to generate questions
        try {
            URL url = new URL(N8N_WEBHOOK_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            String jsonPayload = String.format(
                "{\"action\":\"generate\",\"jobRole\":\"%s\",\"difficulty\":\"%s\",\"numQuestions\":%d}",
                escapeJsonString(jobRole), escapeJsonString(difficulty), numQuestions
            );

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode < 200 || responseCode >= 300) {
                // Fallback / standard questions if n8n is offline or returns error
                throw new IOException("n8n responded with error code: " + responseCode);
            }

            String n8nResponse;
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                n8nResponse = br.lines().collect(Collectors.joining(System.lineSeparator()));
            }

            // Parse response from n8n (JSON array of strings)
            List<String> generatedQuestions = parseJsonStringArray(n8nResponse);
            
            if (generatedQuestions.isEmpty()) {
                // Fallback questions if n8n returned empty response
                generatedQuestions = getFallbackQuestions(jobRole, difficulty, numQuestions);
            }

            // Truncate to the requested size just in case
            if (generatedQuestions.size() > numQuestions) {
                generatedQuestions = generatedQuestions.subList(0, numQuestions);
            }

            // 3. Save questions to the database
            dao.createMockQuestions(interviewId, generatedQuestions);

            // Fetch the saved questions to get their database IDs
            List<MockQuestion> questionsWithIds = dao.getQuestionsForInterview(interviewId);

            // 4. Return questions and session details to the front-end
            StringBuilder jsonOut = new StringBuilder();
            jsonOut.append("{\"success\":true,\"interviewId\":").append(interviewId).append(",\"questions\":[");
            for (int i = 0; i < questionsWithIds.size(); i++) {
                MockQuestion q = questionsWithIds.get(i);
                if (i > 0) jsonOut.append(",");
                jsonOut.append("{\"id\":").append(q.getId())
                       .append(",\"questionText\":\"").append(escapeJsonString(q.getQuestionText())).append("\"}");
            }
            jsonOut.append("]}");

            response.getWriter().write(jsonOut.toString());

        } catch (Exception e) {
            System.err.println("n8n connection failed, using fallback questions: " + e.getMessage());
            
            // Fallback questions if n8n is unavailable
            List<String> fallbackQuestions = getFallbackQuestions(jobRole, difficulty, numQuestions);
            dao.createMockQuestions(interviewId, fallbackQuestions);
            List<MockQuestion> questionsWithIds = dao.getQuestionsForInterview(interviewId);

            StringBuilder jsonOut = new StringBuilder();
            jsonOut.append("{\"success\":true,\"interviewId\":").append(interviewId)
                   .append(",\"warning\":\"n8n workflow offline; using local mock database questions.\",\"questions\":[");
            for (int i = 0; i < questionsWithIds.size(); i++) {
                MockQuestion q = questionsWithIds.get(i);
                if (i > 0) jsonOut.append(",");
                jsonOut.append("{\"id\":").append(q.getId())
                       .append(",\"questionText\":\"").append(escapeJsonString(q.getQuestionText())).append("\"}");
            }
            jsonOut.append("]}");

            response.getWriter().write(jsonOut.toString());
        }
    }

    private List<String> parseJsonStringArray(String json) {
        List<String> list = new ArrayList<>();
        // Find strings within brackets or arrays
        Pattern p = Pattern.compile("\"((?:[^\"\\\\]|\\\\.)*)\"");
        Matcher m = p.matcher(json);
        while (m.find()) {
            String s = m.group(1);
            // Decode simple JSON escapes
            s = s.replace("\\\"", "\"")
                 .replace("\\\\", "\\")
                 .replace("\\n", "\n")
                 .replace("\\r", "\r")
                 .replace("\\t", "\t");
            
            // Filter out system or metadata keys that might match the pattern (e.g. key names)
            // If the JSON is a flat array of strings, all matches will be the questions themselves.
            // If n8n returned a structured object, we handle it carefully.
            if (!s.equals("questions") && !s.equals("action") && !s.equals("success")) {
                list.add(s);
            }
        }
        return list;
    }

    private List<String> getFallbackQuestions(String jobRole, String difficulty, int numQuestions) {
        List<String> list = new ArrayList<>();
        if ("Easy".equalsIgnoreCase(difficulty)) {
            list.add("Tell me about yourself and why you are interested in a " + jobRole + " role.");
            list.add("What are your greatest technical strengths and weaknesses?");
            list.add("Describe a challenging project you worked on and how you resolved any issues.");
            list.add("How do you handle working in a team with conflicting opinions?");
            list.add("Where do you see yourself in the next 3 to 5 years?");
        } else if ("Hard".equalsIgnoreCase(difficulty)) {
            list.add("Explain the system design and architecture of a scalable, high-throughput application for a " + jobRole + " system.");
            list.add("How do you optimize database performance, query latency, and resource contention under heavy load?");
            list.add("Walk me through a time you debugged a complex memory leak, concurrency bottleneck, or production crash.");
            list.add("Explain how you handle data consistency vs. system availability in a distributed global cluster.");
            list.add("How do you implement secure authorization, identity management, and rate-limiting across microservices?");
        } else { // Medium
            list.add("What is your approach to writing clean, maintainable, and testable code for a " + jobRole + " project?");
            list.add("Explain the difference between SQL and NoSQL databases, and when you would choose one over the other.");
            list.add("How do you handle API versioning, error reporting, and backward compatibility in a web application?");
            list.add("Describe a scenario where you had to learn a new technology or framework quickly to complete a task.");
            list.add("What are the key security principles you keep in mind when designing and writing web services?");
        }

        // Return up to numQuestions
        if (list.size() > numQuestions) {
            return list.subList(0, numQuestions);
        }
        while (list.size() < numQuestions) {
            list.add("What is your understanding of the core responsibilities of a " + jobRole + "?");
        }
        return list;
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
