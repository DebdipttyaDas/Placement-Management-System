import java.sql.Timestamp;

public class MockInterview {
    private int id;
    private String studentEmail;
    private String jobRole;
    private String difficulty;
    private int numQuestions;
    private int score;
    private String feedback;
    private String status;
    private Timestamp createdAt;

    public MockInterview() {}

    public MockInterview(int id, String studentEmail, String jobRole, String difficulty, int numQuestions, int score, String feedback, String status, Timestamp createdAt) {
        this.id = id;
        this.studentEmail = studentEmail;
        this.jobRole = jobRole;
        this.difficulty = difficulty;
        this.numQuestions = numQuestions;
        this.score = score;
        this.feedback = feedback;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public String getJobRole() {
        return jobRole;
    }

    public void setJobRole(String jobRole) {
        this.jobRole = jobRole;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public int getNumQuestions() {
        return numQuestions;
    }

    public void setNumQuestions(int numQuestions) {
        this.numQuestions = numQuestions;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
