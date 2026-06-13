<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Ensure student email or generic email is resolved
    String studentEmail = (String) session.getAttribute("studentEmail");
    if (studentEmail == null || studentEmail.isEmpty()) {
        studentEmail = (String) session.getAttribute("user");
    }
    if (studentEmail == null || studentEmail.isEmpty()) {
        studentEmail = "guest_student@placement.com";
    }
    String studentName = (String) session.getAttribute("studentName");
    if (studentName == null || studentName.isEmpty()) {
        studentName = "Guest Student";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Mock Interview Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="MockInterview.css">
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h2><i class="fa-solid fa-robot"></i> Placement AI</h2>
        <ul class="menu-list">
            <li class="menu-item active">
                <a href="#"><i class="fa-solid fa-graduation-cap"></i> Mock Interview</a>
            </li>
            <li class="menu-item">
                <a href="Interviews.jsp"><i class="fa-solid fa-calendar-days"></i> Back to Schedule</a>
            </li>
            <li class="menu-item">
                <a href="CompanyDashboard.jsp"><i class="fa-solid fa-house"></i> Dashboard</a>
            </li>
        </ul>
    </div>

    <!-- MAIN CONTAINER -->
    <div class="main-container">
        
        <header>
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <div class="header-title">
                <h1>AI Mock Interview Portal</h1>
                <p>Sharpen your skills with structured questions generated and evaluated by Gemini & OpenAI models.</p>
            </div>
            <div class="user-pill">
                <i class="fa-solid fa-circle-user"></i>
                <span id="userNameDisplay"><%= studentName %></span>
            </div>
        </header>

        <!-- ================= PHASE 1: SETUP WINDOW ================= -->
        <div id="setupWindow" class="setup-grid">
            
            <div class="glass-card">
                <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 25px; display:flex; align-items:center; gap:8px;">
                    <i class="fa-solid fa-sliders" style="color:var(--accent-cyan)"></i> Setup Your Session
                </h2>
                
                <form id="setupForm" onsubmit="startInterview(event)">
                    
                    <div class="form-group">
                        <label>Select Target Job Role</label>
                        <select class="form-control" id="jobRole" required>
                            <option value="Software Engineer">Software Engineer</option>
                            <option value="Frontend Developer">Frontend Developer</option>
                            <option value="Backend Developer">Backend Developer</option>
                            <option value="Full Stack Developer">Full Stack Developer</option>
                            <option value="Data Analyst">Data Analyst</option>
                            <option value="Data Scientist">Data Scientist / ML Engineer</option>
                            <option value="UI/UX Designer">UI/UX Designer</option>
                            <option value="Product Manager">Product Manager</option>
                            <option value="QA Tester">QA / Testing Engineer</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Select Difficulty Level</label>
                        <select class="form-control" id="difficulty" required>
                            <option value="Easy">Easy (Conceptual & Behavioral)</option>
                            <option value="Medium" selected>Medium (Standard Technical)</option>
                            <option value="Hard">Hard (Architectural & Dynamic Problem Solving)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Number of Questions</label>
                        <select class="form-control" id="numQuestions" required>
                            <option value="3">3 Questions</option>
                            <option value="5" selected>5 Questions</option>
                            <option value="8">8 Questions</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-premium" style="margin-top: 15px;">
                        <i class="fa-solid fa-play"></i> Initialize Mock Interview
                    </button>

                </form>
            </div>

            <div class="glass-card history-panel">
                <h3><i class="fa-solid fa-clock-rotate-left" style="color:var(--accent-purple)"></i> Past Attempts</h3>
                <div class="history-list" id="historyContainer">
                    <p style="color: var(--text-muted); font-size: 14px; text-align: center; margin-top: 30px;">Loading historical data...</p>
                </div>
            </div>

        </div>

        <!-- ================= PHASE 2: INTERVIEW WINDOW ================= -->
        <div id="interviewWindow" class="glass-card interview-window">
            
            <div class="question-box">
                <div class="question-header">
                    <span class="question-number" id="questionCounter">Question 1 of 5</span>
                    <span class="timer" id="questionTimer"><i class="fa-solid fa-stopwatch"></i> 03:00</span>
                </div>
                <div class="question-text" id="questionText">
                    Loading your interview question...
                </div>
            </div>

            <textarea class="answer-area" id="answerInput" placeholder="Type your detailed, structured technical response here... Try to include architecture keywords, steps, or sample logic."></textarea>

            <div class="window-footer">
                <button class="btn-secondary" id="prevBtn" onclick="prevQuestion()" disabled>
                    <i class="fa-solid fa-chevron-left"></i> Previous Question
                </button>
                
                <button class="btn-premium" id="nextBtn" onclick="nextQuestion()" style="width: auto; min-width: 180px;">
                    Save & Next <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>

        </div>

        <!-- ================= PHASE 3: EVALUATING WINDOW ================= -->
        <div id="loaderWindow" class="glass-card loader-window">
            <div class="spinner-container">
                <div class="spinner-outer"></div>
                <div class="spinner-inner"></div>
                <div class="spinner-center">
                    <i class="fa-solid fa-brain fa-2xl"></i>
                </div>
            </div>
            <h2 id="loaderTitle" style="font-size: 22px; font-weight: 700; margin-bottom: 10px;">Generating Questions...</h2>
            <p id="loaderMessage" style="color: var(--text-muted); max-width: 480px; font-size: 14px; line-height: 1.6;">
                Gemini & OpenAI instances are composing a personalized, challenging interview based on your preferences.
            </p>
        </div>

        <!-- ================= PHASE 4: REPORT WINDOW ================= -->
        <div id="resultsWindow" class="results-window">
            
            <div class="glass-card" style="margin-bottom: 40px;">
                <div class="results-header">
                    <div class="score-gauge">
                        <svg>
                            <circle class="gauge-bg" cx="90" cy="90" r="75"></circle>
                            <circle class="gauge-val" cx="90" cy="90" r="75" id="gaugeCircle" stroke-dasharray="0 471"></circle>
                        </svg>
                        <div class="score-text">
                            <span class="score-num" id="reportScore">82</span>
                            <span class="score-lbl">Score</span>
                        </div>
                    </div>
                    <div class="feedback-summary">
                        <span class="score-badge" id="reportScoreBadge" style="margin-bottom: 10px; display: inline-block;">EXCELLENT</span>
                        <h2>AI Evaluation Report</h2>
                        <p id="reportSummary">
                            Overall feedback text goes here. The AI assesses grammar, accuracy, completeness, and practical engineering skills.
                        </p>
                    </div>
                </div>
                
                <button class="btn-premium" onclick="showSetup()" style="width: auto; margin: 0 auto; display: flex;">
                    Take Another Interview
                </button>
            </div>

            <div class="report-section">
                <h3>Detailed Question-by-Question Breakdown</h3>
                <div id="reportQaContainer">
                    <!-- Cards will be populated here -->
                </div>
            </div>

        </div>

    </div>

    <!-- TOAST ALERT -->
    <div class="toast-notify" id="errorToast">An error occurred during submission.</div>

    <script src="MockInterview.js"></script>

    <script>
      (function() {
        const toggleBtn = document.getElementById('sidebar-toggle');
        const sidebar = document.querySelector('.sidebar');
        if (toggleBtn && sidebar) {
          toggleBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            sidebar.classList.toggle('active');
          });
          document.addEventListener('click', function(e) {
            if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
              sidebar.classList.remove('active');
            }
          });
        }
      })();
    </script>
</body>
</html>
