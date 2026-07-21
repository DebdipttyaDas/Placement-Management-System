import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EvaluateMockInterviewServlet")
public class EvaluateMockInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final MockInterviewDAO dao = new MockInterviewDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Session expired. Please log in.\"}");
            return;
        }

        // Read JSON payload from request body
        String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Empty request body.\"}");
            return;
        }

        // Parse interviewId
        int interviewId = -1;
        Pattern idPattern = Pattern.compile("\"interviewId\"\\s*:\\s*(\\d+)");
        Matcher idMatcher = idPattern.matcher(requestBody);
        if (idMatcher.find()) {
            interviewId = Integer.parseInt(idMatcher.group(1));
        }

        if (interviewId == -1) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Missing or invalid interviewId.\"}");
            return;
        }

        MockInterview interview = dao.getMockInterviewById(interviewId);
        if (interview == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"success\":false,\"message\":\"Mock interview session not found.\"}");
            return;
        }

        // Parse answers list: {"id": 12, "answerText": "..."}
        List<Integer> questionIds = new ArrayList<>();
        List<String> studentAnswers = new ArrayList<>();
        
        // Match each {"id": XX, "answerText": "YY"} block
        // Use a state machine or refined regex to match JSON structure
        Pattern answerBlockPattern = Pattern.compile("\\{\\s*\"id\"\\s*:\\s*(\\d+)\\s*,\\s*\"answerText\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"\\s*\\}");
        Matcher answerBlockMatcher = answerBlockPattern.matcher(requestBody);
        while (answerBlockMatcher.find()) {
            int qId = Integer.parseInt(answerBlockMatcher.group(1));
            String text = answerBlockMatcher.group(2)
                                             .replace("\\\"", "\"")
                                             .replace("\\\\", "\\")
                                             .replace("\\n", "\n")
                                             .replace("\\r", "\r")
                                             .replace("\\t", "\t");
            questionIds.add(qId);
            studentAnswers.add(text);
        }

        if (questionIds.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"No answers provided.\"}");
            return;
        }

        // Fetch stored questions from DB to pair them up
        List<MockQuestion> dbQuestions = dao.getQuestionsForInterview(interviewId);
        Map<Integer, MockQuestion> dbQuestionsMap = new HashMap<>();
        for (MockQuestion mq : dbQuestions) {
            dbQuestionsMap.put(mq.getId(), mq);
        }

        // 1. Build the payload for n8n evaluation
        StringBuilder payloadBuilder = new StringBuilder();
        payloadBuilder.append("{\"action\":\"evaluate\",")
                      .append("\"interviewId\":").append(interviewId).append(",")
                      .append("\"jobRole\":\"").append(escapeJsonString(interview.getJobRole())).append("\",")
                      .append("\"difficulty\":\"").append(escapeJsonString(interview.getDifficulty())).append("\",")
                      .append("\"qaList\":[");
        
        for (int i = 0; i < questionIds.size(); i++) {
            int qId = questionIds.get(i);
            String ans = studentAnswers.get(i);
            MockQuestion mq = dbQuestionsMap.get(qId);
            String questionText = mq != null ? mq.getQuestionText() : "";

            if (i > 0) payloadBuilder.append(",");
            payloadBuilder.append("{\"id\":").append(qId).append(",")
                          .append("\"question\":\"").append(escapeJsonString(questionText)).append("\",")
                          .append("\"answer\":\"").append(escapeJsonString(ans)).append("\"}");
        }
        payloadBuilder.append("]}");

        int overallScore = 0;
        String overallFeedback = "";
        Map<Integer, QuestionEval> evalsMap = new HashMap<>();

        try {
            // 2. Call n8n Webhook
            WebhookService.WebhookResult result = WebhookService.sendPost("/webhook/mock-interview", payloadBuilder.toString());
            if (!result.success) {
                throw new IOException(result.errorMessage != null ? result.errorMessage : "n8n responded with error code: " + result.statusCode);
            }
            String n8nResponse = result.responseBody;

            // 3. Parse n8n response:
            // Extract overall score
            Pattern scorePattern = Pattern.compile("\"score\"\\s*:\\s*(\\d+)");
            Matcher scoreMatcher = scorePattern.matcher(n8nResponse);
            if (scoreMatcher.find()) {
                overallScore = Integer.parseInt(scoreMatcher.group(1));
            }

            // Extract overall feedback (first string matching "feedback")
            Pattern feedbackPattern = Pattern.compile("\"feedback\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"");
            Matcher feedbackMatcher = feedbackPattern.matcher(n8nResponse);
            if (feedbackMatcher.find()) {
                overallFeedback = feedbackMatcher.group(1)
                                                 .replace("\\\"", "\"")
                                                 .replace("\\\\", "\\")
                                                 .replace("\\n", "\n");
            }

            // Extract individual evaluations: {"id": 12, "score": 8, "feedback": "..."}
            Pattern subEvalPattern = Pattern.compile("\\{\\s*\"id\"\\s*:\\s*(\\d+)\\s*,\\s*\"score\"\\s*:\\s*(\\d+)\\s*,\\s*\"feedback\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"\\s*\\}");
            Matcher subEvalMatcher = subEvalPattern.matcher(n8nResponse);
            while (subEvalMatcher.find()) {
                int id = Integer.parseInt(subEvalMatcher.group(1));
                int qScore = Integer.parseInt(subEvalMatcher.group(2));
                String qFeedback = subEvalMatcher.group(3)
                                                 .replace("\\\"", "\"")
                                                 .replace("\\\\", "\\")
                                                 .replace("\\n", "\n");
                evalsMap.put(id, new QuestionEval(qScore, qFeedback));
            }

        } catch (Exception e) {
            System.err.println("n8n evaluation connection failed, using local fallback grading: " + e.getMessage());
            // Fallback grading logic
            overallScore = 0;
            int answeredCount = 0;
            for (int i = 0; i < questionIds.size(); i++) {
                int qId = questionIds.get(i);
                String ans = studentAnswers.get(i).trim();
                
                int qScore = 0;
                String qFeedback = "";
                
                if (ans.isEmpty()) {
                    qScore = 0;
                    qFeedback = "No answer was provided for this question.";
                } else if (ans.length() < 10) {
                    qScore = 2;
                    qFeedback = "The answer is too brief. Try to explain with technical definitions, details, or real-world examples.";
                } else {
                    qScore = Math.min(10, 5 + (ans.length() / 50)); // simplistic length-based scoring
                    qFeedback = "Answer received. Your explanation demonstrates basic comprehension of the topic. Recommend expanding with structured bullet points and practical implementation details.";
                    answeredCount++;
                }
                
                overallScore += qScore;
                evalsMap.put(qId, new QuestionEval(qScore, qFeedback));
            }
            
            // Normalize score to 100
            int maxPossible = questionIds.size() * 10;
            overallScore = (int) (((double) overallScore / maxPossible) * 100);
            
            overallFeedback = "Evaluation completed using local mock engine. (n8n is offline). You answered " + answeredCount + " out of " + questionIds.size() + " questions. Keep practicing to build structural answers!";
        }

        // 4. Update the DB tables
        for (int i = 0; i < questionIds.size(); i++) {
            int qId = questionIds.get(i);
            String ans = studentAnswers.get(i);
            QuestionEval eval = evalsMap.get(qId);
            int qScore = (eval != null) ? eval.score : 5;
            String qFeedback = (eval != null) ? eval.feedback : "Answer evaluated.";
            
            dao.updateMockQuestionAnswer(qId, ans, qFeedback, qScore);
        }

        interview.setScore(overallScore);
        interview.setFeedback(overallFeedback);
        interview.setStatus("COMPLETED");
        dao.updateMockInterview(interview);

        // 5. Build and return the JSON response
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{\"success\":true,")
                    .append("\"interviewId\":").append(interviewId).append(",")
                    .append("\"score\":").append(overallScore).append(",")
                    .append("\"feedback\":\"").append(escapeJsonString(overallFeedback)).append("\",")
                    .append("\"evaluations\":[");
        
        List<MockQuestion> finalQuestions = dao.getQuestionsForInterview(interviewId);
        for (int i = 0; i < finalQuestions.size(); i++) {
            MockQuestion mq = finalQuestions.get(i);
            if (i > 0) jsonResponse.append(",");
            jsonResponse.append("{\"id\":").append(mq.getId()).append(",")
                        .append("\"questionText\":\"").append(escapeJsonString(mq.getQuestionText())).append("\",")
                        .append("\"studentAnswer\":\"").append(escapeJsonString(mq.getStudentAnswer())).append("\",")
                        .append("\"feedback\":\"").append(escapeJsonString(mq.getFeedback())).append("\",")
                        .append("\"score\":").append(mq.getScore()).append("}");
        }
        jsonResponse.append("]}");

        response.getWriter().write(jsonResponse.toString());
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

    private static class QuestionEval {
        int score;
        String feedback;

        QuestionEval(int score, String feedback) {
            this.score = score;
            this.feedback = feedback;
        }
    }
}
