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