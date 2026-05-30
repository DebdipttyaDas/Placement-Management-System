import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MockInterviewDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/placement_management";
    private static boolean tablesInitialized = false;

    public MockInterviewDAO() {
        if (!tablesInitialized) {
            initializeDatabaseTables();
        }
    }

    // Direct connection method requested to be included inside suitable file
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try {
            return DriverManager.getConnection(DB_URL, "root", "root");
        } catch (SQLException e) {
            // Fallback password
            try {
                return DriverManager.getConnection(DB_URL, "root", "password");
            } catch (SQLException ex) {
                // Secondary fallback if both fail
                return DriverManager.getConnection(DB_URL, "root", "");
            }
        }
    }

    private synchronized void initializeDatabaseTables() {
        if (tablesInitialized) return;
        try (Connection conn = getConnection()) {
            DatabaseMetaData dbm = conn.getMetaData();
            
            // Check if mock_interviews table exists
            try (ResultSet rs = dbm.getTables(null, null, "mock_interviews", null)) {
                if (!rs.next()) {
                    // Create mock_interviews
                    try (Statement stmt = conn.createStatement()) {
                        String sql = "CREATE TABLE mock_interviews (" +
                                "id INT AUTO_INCREMENT PRIMARY KEY," +
                                "student_email VARCHAR(100) NOT NULL," +
                                "job_role VARCHAR(100) NOT NULL," +
                                "difficulty VARCHAR(50) NOT NULL," +
                                "num_questions INT NOT NULL," +
                                "score INT DEFAULT 0," +
                                "feedback TEXT," +
                                "status VARCHAR(50) NOT NULL," +
                                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                                ")";
                        stmt.executeUpdate(sql);
                        System.out.println("mock_interviews table created successfully.");
                    }
                }
            }

            // Check if mock_interview_questions table exists
            try (ResultSet rs = dbm.getTables(null, null, "mock_interview_questions", null)) {
                if (!rs.next()) {
                    // Create mock_interview_questions
                    try (Statement stmt = conn.createStatement()) {
                        String sql = "CREATE TABLE mock_interview_questions (" +
                                "id INT AUTO_INCREMENT PRIMARY KEY," +
                                "mock_interview_id INT NOT NULL," +
                                "question_text TEXT NOT NULL," +
                                "student_answer TEXT," +
                                "feedback TEXT," +
                                "score INT DEFAULT 0," +
                                "FOREIGN KEY (mock_interview_id) REFERENCES mock_interviews(id) ON DELETE CASCADE" +
                                ")";
                        stmt.executeUpdate(sql);
                        System.out.println("mock_interview_questions table created successfully.");
                    }
                }
            }
            tablesInitialized = true;
        } catch (Exception e) {
            System.err.println("Error initializing database tables: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int createMockInterview(MockInterview interview) {
        String sql = "INSERT INTO mock_interviews (student_email, job_role, difficulty, num_questions, score, feedback, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, interview.getStudentEmail());
            ps.setString(2, interview.getJobRole());
            ps.setString(3, interview.getDifficulty());
            ps.setInt(4, interview.getNumQuestions());
            ps.setInt(5, interview.getScore());
            ps.setString(6, interview.getFeedback());
            ps.setString(7, interview.getStatus());
            
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    interview.setId(id);
                    return id;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateMockInterview(MockInterview interview) {
        String sql = "UPDATE mock_interviews SET score = ?, feedback = ?, status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, interview.getScore());
            ps.setString(2, interview.getFeedback());
            ps.setString(3, interview.getStatus());
            ps.setInt(4, interview.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public MockInterview getMockInterviewById(int id) {
        String sql = "SELECT * FROM mock_interviews WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new MockInterview(
                        rs.getInt("id"),
                        rs.getString("student_email"),
                        rs.getString("job_role"),
                        rs.getString("difficulty"),
                        rs.getInt("num_questions"),
                        rs.getInt("score"),
                        rs.getString("feedback"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<MockInterview> getMockInterviewsByStudent(String studentEmail) {
        List<MockInterview> list = new ArrayList<>();
        String sql = "SELECT * FROM mock_interviews WHERE student_email = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentEmail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new MockInterview(
                        rs.getInt("id"),
                        rs.getString("student_email"),
                        rs.getString("job_role"),
                        rs.getString("difficulty"),
                        rs.getInt("num_questions"),
                        rs.getInt("score"),
                        rs.getString("feedback"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createMockQuestions(int mockInterviewId, List<String> questions) {
        String sql = "INSERT INTO mock_interview_questions (mock_interview_id, question_text) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            for (String q : questions) {
                ps.setInt(1, mockInterviewId);
                ps.setString(2, q);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            conn.commit();
            return results.length == questions.size();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateMockQuestionAnswer(int questionId, String answer, String feedback, int score) {
        String sql = "UPDATE mock_interview_questions SET student_answer = ?, feedback = ?, score = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, answer);
            ps.setString(2, feedback);
            ps.setInt(3, score);
            ps.setInt(4, questionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<MockQuestion> getQuestionsForInterview(int mockInterviewId) {
        List<MockQuestion> list = new ArrayList<>();
        String sql = "SELECT * FROM mock_interview_questions WHERE mock_interview_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mockInterviewId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new MockQuestion(
                        rs.getInt("id"),
                        rs.getInt("mock_interview_id"),
                        rs.getString("question_text"),
                        rs.getString("student_answer"),
                        rs.getString("feedback"),
                        rs.getInt("score")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
