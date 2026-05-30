public class MockQuestion {
    private int id;
    private int mockInterviewId;
    private String questionText;
    private String studentAnswer;
    private String feedback;
    private int score;

    public MockQuestion() {}

    public MockQuestion(int id, int mockInterviewId, String questionText, String studentAnswer, String feedback, int score) {
        this.id = id;
        this.mockInterviewId = mockInterviewId;
        this.questionText = questionText;
        this.studentAnswer = studentAnswer;
        this.feedback = feedback;
        this.score = score;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMockInterviewId() {
        return mockInterviewId;
    }

    public void setMockInterviewId(int mockInterviewId) {
        this.mockInterviewId = mockInterviewId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getStudentAnswer() {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer) {
        this.studentAnswer = studentAnswer;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }
}
