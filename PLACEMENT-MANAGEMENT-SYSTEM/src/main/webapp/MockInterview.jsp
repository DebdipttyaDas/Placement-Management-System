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
    <style>
        /* Modern Premium Style Sheet */
        :root {
            --bg-dark: #090d1a;
            --panel-dark: #121829;
            --accent-cyan: #38bdf8;
            --accent-purple: #a78bfa;
            --accent-green: #34d399;
            --accent-red: #f87171;
            --text-light: #f1f5f9;
            --text-muted: #94a3b8;
            --border-color: #1e293b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', 'Inter', -apple-system, sans-serif;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-light);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar Layout */
        .sidebar {
            width: 250px;
            background-color: var(--panel-dark);
            border-right: 1px solid var(--border-color);
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 10;
        }

        .sidebar h2 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--accent-cyan);
        }

        .sidebar h2 i {
            font-size: 24px;
            text-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
        }

        .menu-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .menu-item a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .menu-item a:hover, .menu-item.active a {
            color: #ffffff;
            background-color: rgba(56, 189, 248, 0.08);
            border-left: 3px solid var(--accent-cyan);
        }

        /* Main Content */
        .main-container {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 40px;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 20px;
        }

        .header-title h1 {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff 30%, var(--accent-cyan));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-title p {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 5px;
        }

        .user-pill {
            background-color: var(--panel-dark);
            border: 1px solid var(--border-color);
            padding: 10px 18px;
            border-radius: 30px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .user-pill i {
            color: var(--accent-cyan);
        }

        /* Glassmorphism Cards */
        .glass-card {
            background: rgba(18, 24, 41, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .setup-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 10px;
        }

        .form-control {
            width: 100%;
            height: 54px;
            background-color: rgba(9, 13, 26, 0.6);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 0 16px;
            color: #ffffff;
            font-size: 15px;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 10px rgba(56, 189, 248, 0.2);
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2394a3b8'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 18px;
            padding-right: 40px;
        }

        /* Buttons */
        .btn-premium {
            background: linear-gradient(135deg, var(--accent-cyan), #0284c7);
            color: #ffffff;
            border: none;
            border-radius: 12px;
            height: 54px;
            padding: 0 30px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(56, 189, 248, 0.3);
            width: 100%;
        }

        .btn-premium:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(56, 189, 248, 0.4);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--text-light);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            height: 54px;
            padding: 0 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        /* History Table List */
        .history-panel h3 {
            font-size: 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .history-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-height: 400px;
            overflow-y: auto;
            padding-right: 5px;
        }

        .history-item {
            background-color: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .history-item:hover {
            background-color: rgba(56, 189, 248, 0.05);
            border-color: rgba(56, 189, 248, 0.3);
        }

        .history-info h4 {
            font-size: 15px;
            font-weight: 600;
        }

        .history-info p {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .history-score {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .score-badge {
            background-color: rgba(52, 211, 153, 0.15);
            color: var(--accent-green);
            padding: 6px 12px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
        }

        .score-badge.fail {
            background-color: rgba(248, 113, 113, 0.15);
            color: var(--accent-red);
        }

        /* Interview Window */
        .interview-window {
            display: none;
            max-width: 800px;
            margin: 0 auto;
        }

        .question-box {
            margin-bottom: 30px;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .question-number {
            font-size: 14px;
            color: var(--accent-cyan);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .timer {
            font-size: 15px;
            font-weight: 600;
            color: var(--accent-purple);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .question-text {
            font-size: 20px;
            line-height: 1.5;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .answer-area {
            width: 100%;
            height: 250px;
            background-color: rgba(9, 13, 26, 0.6);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            color: #ffffff;
            font-size: 16px;
            line-height: 1.6;
            outline: none;
            resize: none;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .answer-area:focus {
            border-color: var(--accent-purple);
            box-shadow: 0 0 15px rgba(167, 139, 250, 0.15);
        }

        .window-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Loader Page */
        .loader-window {
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            text-align: center;
        }

        .spinner-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin-bottom: 30px;
        }

        .spinner-outer {
            width: 100%;
            height: 100%;
            border: 4px solid transparent;
            border-top-color: var(--accent-cyan);
            border-bottom-color: var(--accent-cyan);
            border-radius: 50%;
            animation: spin 2s linear infinite;
        }

        .spinner-inner {
            position: absolute;
            top: 15px;
            left: 15px;
            right: 15px;
            bottom: 15px;
            border: 4px solid transparent;
            border-left-color: var(--accent-purple);
            border-right-color: var(--accent-purple);
            border-radius: 50%;
            animation: spin-reverse 1.5s linear infinite;
        }

        .spinner-center {
            position: absolute;
            top: 40px;
            left: 40px;
            right: 40px;
            bottom: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent-cyan);
            animation: pulse 1.5s ease infinite;
        }

        /* Results / Report Page */
        .results-window {
            display: none;
            max-width: 900px;
            margin: 0 auto;
        }

        .results-header {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 40px;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 35px;
            margin-bottom: 45px;
        }

        .score-gauge {
            width: 180px;
            height: 180px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .score-gauge svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .score-gauge circle {
            fill: transparent;
            stroke-width: 12px;
        }

        .score-gauge .gauge-bg {
            stroke: var(--border-color);
        }

        .score-gauge .gauge-val {
            stroke: var(--accent-cyan);
            stroke-linecap: round;
            transition: stroke-dasharray 1s ease;
        }

        .score-text {
            position: absolute;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .score-num {
            font-size: 42px;
            font-weight: 800;
            color: #ffffff;
        }

        .score-lbl {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        .feedback-summary h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .feedback-summary p {
            color: var(--text-muted);
            line-height: 1.6;
            font-size: 15px;
        }

        .report-section h3 {
            font-size: 18px;
            margin-bottom: 25px;
            border-left: 4px solid var(--accent-cyan);
            padding-left: 12px;
        }

        .qa-feedback-card {
            background-color: rgba(255, 255, 255, 0.01);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 20px;
        }

        .qa-feedback-q {
            font-size: 16px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 12px;
        }

        .qa-feedback-a {
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            padding: 14px;
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 18px;
            border-left: 3px solid var(--border-color);
        }

        .qa-feedback-eval {
            display: grid;
            grid-template-columns: 60px 1fr;
            gap: 15px;
            align-items: start;
        }

        .qa-score-badge {
            background-color: rgba(56, 189, 248, 0.1);
            color: var(--accent-cyan);
            border-radius: 8px;
            height: 48px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
        }

        .qa-score-badge.low {
            background-color: rgba(248, 113, 113, 0.1);
            color: var(--accent-red);
        }

        .qa-score-badge.high {
            background-color: rgba(52, 211, 153, 0.1);
            color: var(--accent-green);
        }

        .qa-score-badge span {
            font-size: 9px;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .qa-feedback-text {
            font-size: 14px;
            color: var(--text-light);
            line-height: 1.6;
        }

        /* Animations */
        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @keyframes spin-reverse {
            to { transform: rotate(-360deg); }
        }

        @keyframes pulse {
            0% { transform: scale(0.95); opacity: 0.7; }
            50% { transform: scale(1.05); opacity: 1; }
            100% { transform: scale(0.95); opacity: 0.7; }
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: var(--bg-dark);
        }
        ::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: 10px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #2e3d56;
        }

        .toast-notify {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: var(--accent-red);
            color: white;
            padding: 16px 24px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            z-index: 100;
            font-weight: 600;
            display: none;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
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

    <script>
        // Global State Variables
        let currentInterviewId = -1;
        let questions = [];
        let answers = [];
        let currentQuestionIdx = 0;
        let timerInterval = null;
        let timeLeft = 180; // 3 minutes per question

        // Load History on Page Start
        document.addEventListener("DOMContentLoaded", function() {
            loadPastAttempts();
        });

        // 1. Fetch History via AJAX
        function loadPastAttempts() {
            const container = document.getElementById("historyContainer");
            fetch("FetchMockInterviewsServlet")
                .then(res => res.json())
                .then(data => {
                    if (!data || data.length === 0) {
                        container.innerHTML = `<p style="color: var(--text-muted); font-size: 14px; text-align: center; margin-top: 30px;">No interview sessions recorded yet. Start your first attempt now!</p>`;
                        return;
                    }
                    container.innerHTML = "";
                    data.forEach(item => {
                        const date = new Date(item.createdAt).toLocaleDateString(undefined, {
                            month: 'short',
                            day: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                        });
                        const isFail = item.score < 50;
                        const scoreClass = isFail ? "score-badge fail" : "score-badge";
                        const displayScore = item.status === "STARTED" ? "Incomplete" : item.score + "%";

                        const div = document.createElement("div");
                        div.className = "history-item";
                        div.onclick = () => viewPastReport(item.id);
                        div.innerHTML = `
                            <div class="history-info">
                                <h4>${item.jobRole} (${item.difficulty})</h4>
                                <p>${date} &bull; ${item.numQuestions} Qs</p>
                            </div>
                            <div class="history-score">
                                <span class="${scoreClass}">${displayScore}</span>
                                <i class="fa-solid fa-chevron-right" style="color: var(--text-muted)"></i>
                            </div>
                        `;
                        container.appendChild(div);
                    });
                })
                .catch(err => {
                    console.error("Error loading attempts:", err);
                    container.innerHTML = `<p style="color: var(--accent-red); font-size: 14px; text-align: center; margin-top: 30px;">Error loading historical data.</p>`;
                });
        }

        // 2. Start Interview Session
        function startInterview(e) {
            e.preventDefault();
            const jobRole = document.getElementById("jobRole").value;
            const difficulty = document.getElementById("difficulty").value;
            const numQuestions = document.getElementById("numQuestions").value;

            // Show Loader
            showWindow("loaderWindow");
            document.getElementById("loaderTitle").innerText = "Generating Interview Questions...";
            document.getElementById("loaderMessage").innerText = "Our workflow engine is crafting custom questions based on: Role - " + jobRole + ", Difficulty - " + difficulty + ".";

            // Submit AJAX request
            fetch("StartMockInterviewServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `jobRole=${encodeURIComponent(jobRole)}&difficulty=${encodeURIComponent(difficulty)}&numQuestions=${numQuestions}`
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    currentInterviewId = data.interviewId;
                    questions = data.questions;
                    answers = new Array(questions.length).fill("");
                    currentQuestionIdx = 0;
                    
                    if (data.warning) {
                        showErrorToast(data.warning);
                    }
                    
                    // Render First Question
                    renderQuestion();
                    showWindow("interviewWindow");
                } else {
                    showSetup();
                    showErrorToast(data.message || "Failed to initialize interview.");
                }
            })
            .catch(err => {
                console.error("Initialization error:", err);
                showSetup();
                showErrorToast("Connection error: Unable to contact server.");
            });
        }

        // 3. Question Render & Timer Logic
        function renderQuestion() {
            const question = questions[currentQuestionIdx];
            document.getElementById("questionCounter").innerText = `Question ${currentQuestionIdx + 1} of ${questions.length}`;
            document.getElementById("questionText").innerText = question.questionText;
            document.getElementById("answerInput").value = answers[currentQuestionIdx];
            document.getElementById("answerInput").focus();

            // Handle Buttons disabled/enabled states
            document.getElementById("prevBtn").disabled = currentQuestionIdx === 0;
            
            const nextBtn = document.getElementById("nextBtn");
            if (currentQuestionIdx === questions.length - 1) {
                nextBtn.innerHTML = `Finish & Submit <i class="fa-solid fa-square-check"></i>`;
                nextBtn.style.background = "linear-gradient(135deg, var(--accent-purple), #7c3aed)";
            } else {
                nextBtn.innerHTML = `Save & Next <i class="fa-solid fa-chevron-right"></i>`;
                nextBtn.style.background = "";
            }

            // Start Timer
            resetTimer();
        }

        function resetTimer() {
            clearInterval(timerInterval);
            timeLeft = 180; // 3 minutes per question
            updateTimerDisplay();
            timerInterval = setInterval(() => {
                timeLeft--;
                updateTimerDisplay();
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    // Autosave answer and go to next
                    saveCurrentAnswer();
                    if (currentQuestionIdx < questions.length - 1) {
                        currentQuestionIdx++;
                        renderQuestion();
                    } else {
                        submitInterview();
                    }
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            const mins = Math.floor(timeLeft / 60).toString().padStart(2, '0');
            const secs = (timeLeft % 60).toString().padStart(2, '0');
            const timerEl = document.getElementById("questionTimer");
            timerEl.innerText = `${mins}:${secs}`;
            if (timeLeft <= 30) {
                timerEl.style.color = "var(--accent-red)";
            } else {
                timerEl.style.color = "var(--accent-purple)";
            }
        }

        // 4. Save and Navigation Logic
        function saveCurrentAnswer() {
            answers[currentQuestionIdx] = document.getElementById("answerInput").value;
        }

        function prevQuestion() {
            saveCurrentAnswer();
            if (currentQuestionIdx > 0) {
                currentQuestionIdx--;
                renderQuestion();
            }
        }

        function nextQuestion() {
            saveCurrentAnswer();
            if (currentQuestionIdx < questions.length - 1) {
                currentQuestionIdx++;
                renderQuestion();
            } else {
                submitInterview();
            }
        }

        // 5. Submit Interview for Grading
        function submitInterview() {
            clearInterval(timerInterval);
            saveCurrentAnswer();

            // Show Loader
            showWindow("loaderWindow");
            document.getElementById("loaderTitle").innerText = "Analyzing Answers...";
            document.getElementById("loaderMessage").innerText = "Please wait. Our n8n workflow and OpenAI/Gemini systems are reviewing your structural vocabulary, engineering accuracy, and grading individual questions.";

            // Format JSON payload
            const payload = {
                interviewId: currentInterviewId,
                answers: questions.map((q, idx) => {
                    return {
                        id: q.id,
                        answerText: answers[idx] || ""
                    };
                })
            };

            fetch("EvaluateMockInterviewServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(payload)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    renderReport(data);
                    showWindow("resultsWindow");
                    loadPastAttempts(); // Refresh history panel
                } else {
                    showWindow("interviewWindow");
                    showErrorToast(data.message || "Failed to submit answers.");
                }
            })
            .catch(err => {
                console.error("Evaluation error:", err);
                showWindow("interviewWindow");
                showErrorToast("Submission error: Unable to contact server for grading.");
            });
        }

        // 6. Report Rendering & Gauge Animations
        function renderReport(data) {
            document.getElementById("reportScore").innerText = data.score;
            document.getElementById("reportSummary").innerText = data.feedback;

            // Animate Circle Gauge
            const circle = document.getElementById("gaugeCircle");
            const r = circle.r.baseVal.value;
            const circumference = 2 * Math.PI * r; // 471.2
            const strokeDashOffset = circumference - (data.score / 100) * circumference;
            circle.style.strokeDasharray = `${circumference} ${circumference}`;
            circle.style.strokeDashoffset = circumference;
            
            // Trigger layout reflow for CSS transition
            setTimeout(() => {
                circle.style.transition = "stroke-dashoffset 1s ease-out";
                circle.style.strokeDashoffset = strokeDashOffset;
            }, 100);

            // Style Badge
            const badge = document.getElementById("reportScoreBadge");
            badge.innerText = getScoreLabel(data.score);
            if (data.score >= 80) {
                badge.style.backgroundColor = "rgba(52, 211, 153, 0.15)";
                badge.style.color = "var(--accent-green)";
            } else if (data.score >= 50) {
                badge.style.backgroundColor = "rgba(56, 189, 248, 0.15)";
                badge.style.color = "var(--accent-cyan)";
            } else {
                badge.style.backgroundColor = "rgba(248, 113, 113, 0.15)";
                badge.style.color = "var(--accent-red)";
            }

            // Render QAs list
            const container = document.getElementById("reportQaContainer");
            container.innerHTML = "";
            data.evaluations.forEach((evalItem, index) => {
                const isHigh = evalItem.score >= 8;
                const isLow = evalItem.score <= 4;
                const scoreClass = isHigh ? "qa-score-badge high" : (isLow ? "qa-score-badge low" : "qa-score-badge");
                
                const card = document.createElement("div");
                card.className = "qa-feedback-card";
                card.innerHTML = `
                    <div class="qa-feedback-q">Q${index + 1}: ${evalItem.questionText}</div>
                    <div class="qa-feedback-a"><strong>Your Answer:</strong> ${escapeHtml(evalItem.studentAnswer || "No answer provided.")}</div>
                    <div class="qa-feedback-eval">
                        <div class="${scoreClass}">
                            ${evalItem.score}
                            <span>Rating</span>
                        </div>
                        <div class="qa-feedback-text">
                            <strong>AI Feedback & Recommendations:</strong><br>
                            ${evalItem.feedback}
                        </div>
                    </div>
                `;
                container.appendChild(card);
            });
        }

        // View Report for Past Attempt
        function viewPastReport(id) {
            showWindow("loaderWindow");
            document.getElementById("loaderTitle").innerText = "Loading Report...";
            document.getElementById("loaderMessage").innerText = "Retrieving evaluation report from local database storage...";

            fetch("EvaluateMockInterviewServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                // Sending just interviewId evaluates it or pulls saved state
                body: JSON.stringify({ interviewId: id, answers: [] })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    renderReport(data);
                    showWindow("resultsWindow");
                } else {
                    showSetup();
                    showErrorToast("Failed to load historical report.");
                }
            })
            .catch(err => {
                console.error("History fetch error:", err);
                showSetup();
                showErrorToast("Connection error: Unable to fetch past report.");
            });
        }

        // Helpers
        function getScoreLabel(score) {
            if (score >= 85) return "OUTSTANDING";
            if (score >= 70) return "EXCELLENT";
            if (score >= 50) return "SATISFACTORY";
            return "NEEDS WORK";
        }

        function showSetup() {
            showWindow("setupWindow");
            loadPastAttempts();
        }

        function showWindow(winId) {
            document.getElementById("setupWindow").style.display = winId === "setupWindow" ? "grid" : "none";
            document.getElementById("interviewWindow").style.display = winId === "interviewWindow" ? "block" : "none";
            document.getElementById("loaderWindow").style.display = winId === "loaderWindow" ? "flex" : "none";
            document.getElementById("resultsWindow").style.display = winId === "resultsWindow" ? "block" : "none";
        }

        function showErrorToast(msg) {
            const toast = document.getElementById("errorToast");
            toast.innerText = msg;
            toast.style.display = "block";
            setTimeout(() => {
                toast.style.display = "none";
            }, 5000);
        }

        function escapeHtml(text) {
            if (!text) return "";
            return text.replace(/&/g, "&amp;")
                       .replace(/</g, "&lt;")
                       .replace(/>/g, "&gt;")
                       .replace(/"/g, "&quot;")
                       .replace(/'/g, "&#039;");
        }
    </script>
</body>
</html>
