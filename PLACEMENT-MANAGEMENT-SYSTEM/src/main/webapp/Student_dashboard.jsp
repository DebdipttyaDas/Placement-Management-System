<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"
  import="java.sql.*" %>

  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>

    <!-- External CSS -->
    <link rel="stylesheet" href="Student_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  </head>

  <body>

    <!-- DASHBOARD CONTAINER -->
    <div class="dashboard-container">

      <!-- LEFT SIDEBAR -->
      <div class="sidebar" id="sidebar">
        <button class="close-sidebar-btn" id="closeSidebarBtn" aria-label="Close Sidebar">
          <i class="fa-solid fa-xmark"></i>
        </button>
        <h2>Student Dashboard</h2>

        <ul>
          <li><a href="Student_dashboard.jsp" style="text-decoration: none; color:white;">Dashboard</a></li>
          <li><a href="Placement.jsp" style="text-decoration: none; color:white;">Placements</a></li>
          <li><a href="MyApplication.jsp" style="text-decoration: none; color:white;">My Applications</a></li>
        </ul>
      </div>

      <!-- MAIN AREA -->
      <div class="main-area">

        <!-- TOP BAR -->
        <div class="topbar">
          <button class="sidebar-toggle" id="sidebarToggleBtn" aria-label="Toggle Sidebar">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div class="top-icons">
            <a href="StudentProfile.jsp">
              <i class="fa fa-user-circle" style="font-size:25px; color:white;"></i>
            </a>

            <i class="fa fa-bell" style="font-size:25px;"></i>
          </div>
        </div>


        <!-- BODY CONTENT -->
        <div class="content">

          <!-- WELCOME BOX -->
          <div class="welcome-box">
            <div class="welcome-text-section">
              <span class="career-journey">CAREER JOURNEY</span>
              <h1>Hello, <%= session.getAttribute("studentName") !=null ? session.getAttribute("studentName")
                  : "Student" %>!</h1>
              <p>You're in the top 15% of candidates this week. Keep the momentum going for the upcoming Google
                interview.</p>

              <div class="welcome-actions">
                <div class="btn-apply-wrapper">
                  <a href="Placement.jsp" class="btn-apply"><i class="fa fa-briefcase"></i> Apply to Jobs</a>
                </div>
                <a href="#" class="btn-resume"><i class="fa fa-file-alt"></i> My Resume</a>
              </div>
            </div>

            <% Object profileObj=session.getAttribute("profileComplete"); String profileComplete="0" ; if(profileObj
              !=null){ profileComplete=profileObj.toString(); } int progressValue=Integer.parseInt(profileComplete); %>

              <div class="readiness-box">

                <div class="readiness-header">
                  <span class="readiness-title">Profile Completion</span>
                  <span class="pro-badge">Pro Level</span>
                </div>

                <div class="progress-bar-container">

                  <div class="progress-track">

                    <div class="progress-fill" id="profileProgressBar" data-width="<%= profileComplete %>">
                    </div>
                    <script>
                      // Apply width dynamically to satisfy strict IDE CSS validation
                      const pBar = document.getElementById('profileProgressBar');
                      pBar.style.width = pBar.getAttribute('data-width') + '%';
                    </script>

                  </div>

                </div>

                <div class="readiness-footer">

                  <span>
                    <%= profileComplete %>% Complete
                  </span>

                  <span>
                    <%= (progressValue==100) ? "All Set!" : "Action: Update Profile" %>
                  </span>

                </div>

              </div>
          </div>

          <!-- STATS -->
          <div class="stats">
            <div class="card"><b>Applied Jobs:</b> 5</div>
            <div class="card"><b>Shortlisted:</b> 2</div>
            <div class="card"><b>Open Jobs:</b> 12</div>
          </div>

          <!-- DASHBOARD WIDGETS -->
          <div class="dashboard-widgets">

            <!-- LEFT COLUMN -->
            <div class="widget-col-left">

              <!-- Upcoming Deadlines -->
              <div class="widget-box deadlines-box">
                <div class="widget-header">
                  <h3><i class="fa-regular fa-clock"></i> Upcoming Deadlines</h3>
                  <a href="#" class="view-all">View All</a>
                </div>

                <div class="deadline-item">
                  <div class="dl-icon stripe-icon"><i class="fa-brands fa-stripe-s"></i></div>
                  <div class="dl-info">
                    <h4>Stripe</h4>
                    <p>Software Engineer Intern</p>
                  </div>
                  <div class="dl-action">
                    <span class="time-left">2 hours left</span>
                    <a href="#" class="btn-text">APPLY NOW</a>
                  </div>
                </div>

                <div class="deadline-item">
                  <div class="dl-icon meta-icon"><i class="fa-brands fa-meta"></i></div>
                  <div class="dl-info">
                    <h4>Meta</h4>
                    <p>Product Design Associate</p>
                  </div>
                  <div class="dl-action">
                    <span class="time-normal">Tomorrow</span>
                    <span class="status-draft">IN DRAFT</span>
                  </div>
                </div>
              </div>

              <!-- Career Tip -->
              <div class="widget-box career-tip-box">
                <span class="tip-badge">CAREER TIP</span>
                <h3>Master the 'System Design' interview</h3>
                <p>Learn how to build scalable architectures for real-world scenarios.</p>
                <a href="#" class="read-guide">Read Full Guide &rarr;</a>
                <i class="fa-solid fa-book-open tip-bg-icon"></i>
              </div>

            </div>

            <!-- RIGHT COLUMN -->
            <div class="widget-col-right">

              <!-- Scheduled Interviews -->
              <div class="widget-box interviews-box">
                <div class="widget-header">
                  <h3><i class="fa-regular fa-calendar-check"></i> Scheduled Interviews</h3>
                  <div class="carousel-nav">
                    <button>&lt;</button>
                    <button>&gt;</button>
                  </div>
                </div>

                <div id="interviewsContainer">
                  <div style="padding: 20px; text-align: center; color: #666; font-size: 14px;">
                    Loading scheduled interviews...
                  </div>
                </div>
              </div>

            </div>

          </div>

          <!-- Advertisement -->
          <div class="slideshow">
            <div class="slide active"><img src="images/img1.png" alt="Slide 1" /></div>
            <div class="slide"><img src="images/img2.png" alt="Slide 2" /></div>
            <div class="slide"><img src="images/img3.png" alt="Slide 3" /></div>
            <div class="slide"><img src="images/img4.png" alt="Slide 4" /></div>
            <div class="dots">
              <div class="dot on"></div>
              <div class="dot"></div>
              <div class="dot"></div>
              <div class="dot"></div>
            </div>
          </div>
          <script>
            const slides = document.querySelectorAll('.slide');
            const dots = document.querySelectorAll('.dot');
            let current = 0;
            function goTo(n) {
              slides[current].classList.remove('active');
              dots[current].classList.remove('on');
              current = n % slides.length;
              slides[current].classList.add('active');
              dots[current].classList.add('on');
            }
            dots.forEach((d, i) => d.onclick = () => goTo(i));
            setInterval(() => goTo(current + 1), 3000);
          </script>


        </div>

      </div>

    </div>
    <%
  String dashboardStudentEmail = "";
  String dashboardStudentFullName = "";
  Object sessionUser = session.getAttribute("user");
  if (sessionUser != null) {
    dashboardStudentEmail = sessionUser.toString();
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      try (Connection conn = DriverManager.getConnection(
              "jdbc:mysql://localhost:3306/placement_management", "root", "password");
           PreparedStatement ps = conn.prepareStatement(
              "SELECT full_name FROM students WHERE email = ?")) {
        ps.setString(1, dashboardStudentEmail);
        try (ResultSet rs = ps.executeQuery()) {
          if (rs.next() && rs.getString("full_name") != null) {
            dashboardStudentFullName = rs.getString("full_name").trim();
          }
        }
      }
    } catch (Exception e) { }
  }
  String jsStudentEmail = dashboardStudentEmail.replace("\\", "\\\\").replace("\"", "\\\"");
  String jsStudentFullName = dashboardStudentFullName.replace("\\", "\\\\").replace("\"", "\\\"");
%>

    <script>
      // Fetch interviews via AJAX
      async function loadInterviews() {
        const container = document.getElementById('interviewsContainer');
        try {
          const response = await fetch('FetchInterviewsServlet');
          if (!response.ok) throw new Error("Failed to fetch");
          const interviews = await response.json();

          if (interviews.length === 0) {
            container.innerHTML = `<div style="padding: 20px; text-align: center; color: #666; font-size: 14px;">No scheduled interviews at this time.</div>`;
            return;
          }

          container.innerHTML = ""; // clear loading text
          interviews.forEach((inv, index) => {
            const dateTimeStr = inv.interview_date + "T" + inv.interview_time;
            const cardClass = index === 0 ? 'active-card' : 'upcoming-card'; // Highlight the first one

            const isVirtual = inv.meet_link.startsWith("http");
            const detailsHtml = isVirtual 
              ? `<span><i class="fa-solid fa-video"></i> Google Meet</span>`
              : `<span><i class="fa-solid fa-location-dot"></i> ${inv.meet_link}</span>`;
            const buttonHtml = isVirtual
              ? `<button class="btn-join" data-time="${dateTimeStr}" onclick="window.open('${inv.meet_link}', '_blank')">Join Call</button>`
              : `<button class="btn-join" style="background: #64748b; cursor: default;" onclick="alert('This interview is in-person or via phone at: ${inv.meet_link}')">Details</button>`;

            const cardHtml = `
                    <div class="interview-card ${cardClass}">
                      <div class="ic-header">
                        <span class="ic-time">${inv.interview_date} @ ${inv.interview_time}</span>
                        <span class="ic-badge">${inv.interview_round}</span>
                      </div>
                      <h2 class="ic-company">${inv.company_name}</h2>
                      <div class="ic-details">
                        ${detailsHtml}
                        <span><i class="fa-regular fa-user"></i> ${inv.interviewer_name}</span>
                      </div>
                      <div class="ic-actions">
                        ${buttonHtml}
                        <button class="btn-more">...</button>
                      </div>
                    </div>
                  `;
            container.innerHTML += cardHtml;
          });

          // Re-check expiry after rendering
          checkMeetingExpiry();
        } catch (err) {
          console.error(err);
          container.innerHTML = `<div style="padding: 20px; text-align: center; color: red; font-size: 14px;">Unable to load interviews</div>`;
        }
      }

      // Call it on load and set auto-refresh interval for simultaneous updates
      loadInterviews();

      if ("BroadcastChannel" in window) {
        const bc = new BroadcastChannel("interview-schedule-channel");
        bc.onmessage = (event) => {
          if (event.data && event.data.event === "interviewScheduled") {
            loadInterviews();
          }
        };
      }

      window.addEventListener("storage", (event) => {
        if (event.key === "interviewScheduledAt") {
          loadInterviews();
        }
      });

      setInterval(loadInterviews, 5000);

      // Example auto-disable logic for join buttons based on time
      function checkMeetingExpiry() {
        const joinButtons = document.querySelectorAll('.btn-join');
        const now = new Date();
        joinButtons.forEach(btn => {
          const timeStr = btn.getAttribute('data-time');
          if (timeStr) {
            const meetingTime = new Date(timeStr);
            const diffHours = (now - meetingTime) / (1000 * 60 * 60);
            if (diffHours > 1) { // expired after 1 hour
              btn.disabled = true;
              btn.style.background = '#888';
              btn.innerText = 'Expired';
              btn.onclick = null;
            }
          }
        });
      }
      setInterval(checkMeetingExpiry, 60000);
      checkMeetingExpiry();

      // Responsive Sidebar Toggle
      document.addEventListener("DOMContentLoaded", function () {
        var sidebar = document.getElementById("sidebar");
        var sidebarToggle = document.getElementById("sidebarToggleBtn");
        var closeSidebar = document.getElementById("closeSidebarBtn");

        if (sidebarToggle && sidebar) {
          sidebarToggle.addEventListener("click", function (e) {
            e.stopPropagation();
            sidebar.classList.add("show");
          });
        }

        if (closeSidebar && sidebar) {
          closeSidebar.addEventListener("click", function () {
            sidebar.classList.remove("show");
          });
        }

        document.addEventListener("click", function (e) {
          if (sidebar && sidebar.classList.contains("show")) {
            if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
              sidebar.classList.remove("show");
            }
          }
        });
      });
    </script>

    <!-- Chatbot -->
    <link rel="stylesheet" href="chatbot.css">

    <div id="chatbot-toggle">
        <i class="fas fa-robot"></i>
    </div>

    <div id="chatbot-container">
        <div class="chatbot-header">
            <h3>AI Assistant</h3>
            <button class="chatbot-close">&times;</button>
        </div>
        <div class="chatbot-messages">
            <!-- Messages will be added here -->
        </div>
        <div class="chatbot-input-area">
            <input type="text" class="chatbot-input" placeholder="Type your message...">
            <button class="chatbot-send">
                <i class="fas fa-paper-plane"></i>
            </button>
        </div>
    </div>

    <script src="chatbot.js"></script>

  </body>

  </html>