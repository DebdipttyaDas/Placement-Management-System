<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"
  import="java.sql.*" %>
<%!
    private Connection getJspConnection() throws Exception {
        Class<?> dbUtilClass = Class.forName("DBUtil");
        return (Connection) dbUtilClass.getMethod("getConnection").invoke(null);
    }
%>
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
      <div class="sidebar" style="display:flex; flex-direction:column; justify-content:space-between; height:100vh; box-sizing:border-box; padding-bottom:20px;">
        <div>
          <h2>Student Dashboard</h2>
          <ul>
            <li><a href="Student_dashboard.jsp" style="text-decoration: none; color:white;">Dashboard</a></li>
            <li><a href="Placement.jsp" style="text-decoration: none; color:white;">Placements</a></li>
            <li><a href="MyApplication.jsp" style="text-decoration: none; color:white;">My Applications</a></li>
          </ul>
        </div>
        <!-- Logout -->
        <form action="LogoutServlet" method="post" style="width:100%;">
          <button type="submit" style="width:100%; padding:10px; background:#1d6b61; color:white; border:none; border-radius:6px; font-weight:bold; cursor:pointer; font-size:16px; transition: 0.3s ease;">Logout</button>
        </form>
      </div>

      <!-- MAIN AREA -->
      <div class="main-area">

        <!-- TOP BAR -->
        <div style="display:flex; justify-content:space-between; align-items:center; padding:15px; background:#03352f; color:white; position:sticky; top:0; z-index:100;">
          <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:white; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
            &#9776;
          </button>
          <div style="display:flex; align-items:center; gap:30px; margin-left: auto;">
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
                <button class="mock-ai-btn" id="openMockInterviewBtn">
                  <i class="fa-solid fa-robot"></i> Mock Interview AI
                </button>
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

          <!-- DASHBOARD WIDGETS -->
          <div class="dashboard-widgets">

            <!-- LEFT COLUMN -->
            <div class="widget-col-left">

              <!-- Upcoming Deadlines -->
              <div class="widget-box deadlines-box">
                <div class="widget-header">
                  <h3><i class="fa-regular fa-clock"></i> Upcoming Deadlines</h3>
                  <a href="Placement.jsp" class="view-all">View All</a>
                </div>

                <%
                  boolean hasDeadlines = false;
                  try (Connection conn = getJspConnection()) {
                      String dlSql = "SELECT companyName, jobTitle, applicationDeadline "
                                   + "FROM JOB_DETAILS "
                                   + "WHERE STR_TO_DATE(applicationDeadline, '%Y-%m-%d') >= CURDATE() "
                                   + "ORDER BY STR_TO_DATE(applicationDeadline, '%Y-%m-%d') ASC "
                                   + "LIMIT 3";
                      try (PreparedStatement psDl = conn.prepareStatement(dlSql);
                           ResultSet rsDl = psDl.executeQuery()) {
                          while (rsDl.next()) {
                              hasDeadlines = true;
                              String compName = rsDl.getString("companyName");
                              String title = rsDl.getString("jobTitle");
                              String deadlineStr = rsDl.getString("applicationDeadline");
                              
                              String timeLeft = deadlineStr;
                              try {
                                  java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                  java.util.Date deadlineDate = sdf.parse(deadlineStr);
                                  
                                  // Clear time parts for date-only comparison
                                  java.util.Calendar calToday = java.util.Calendar.getInstance();
                                  calToday.set(java.util.Calendar.HOUR_OF_DAY, 0);
                                  calToday.set(java.util.Calendar.MINUTE, 0);
                                  calToday.set(java.util.Calendar.SECOND, 0);
                                  calToday.set(java.util.Calendar.MILLISECOND, 0);
                                  java.util.Date todayDate = calToday.getTime();
                                  
                                  long diffMs = deadlineDate.getTime() - todayDate.getTime();
                                  long diffDays = diffMs / (1000 * 60 * 60 * 24);
                                  
                                  if (diffDays == 0) {
                                      timeLeft = "Today";
                                  } else if (diffDays == 1) {
                                      timeLeft = "Tomorrow";
                                  } else {
                                      timeLeft = diffDays + " days left";
                                  }
                              } catch (Exception e) {
                                  // fallback if parsing fails
                              }
                              
                              String initials = compName != null && compName.length() >= 2 ? compName.substring(0, 2).toUpperCase() : "CO";
                %>
                <div class="deadline-item">
                  <div class="dl-icon" style="background:#e0f2fe; color:#0369a1; display:grid; place-items:center; font-weight:bold; font-size:14px; border-radius:8px; width:40px; height:40px; flex-shrink:0;">
                    <%= initials %>
                  </div>
                  <div class="dl-info" style="margin-left: 12px; flex: 1;">
                    <h4><%= compName %></h4>
                    <p><%= title %></p>
                  </div>
                  <div class="dl-action" style="text-align: right;">
                    <span class="time-left" style="display:block; font-size:12px; color:#ef4444; font-weight:600; margin-bottom:4px;"><%= timeLeft %></span>
                    <a href="Placement.jsp" class="btn-text" style="font-size:11px; font-weight:700; color:#0d6e60; text-decoration:none;">APPLY NOW</a>
                  </div>
                </div>
                <%
                          }
                      }
                  } catch (Exception e) {
                      e.printStackTrace();
                  }
                  if (!hasDeadlines) {
                %>
                <div style="padding: 20px; text-align: center; color: #64748b; font-size: 14px;">
                  No upcoming deadlines at this time.
                </div>
                <%
                  }
                %>
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
      try (Connection conn = getJspConnection();
           PreparedStatement ps = conn.prepareStatement(
              "SELECT fullName FROM STUDENT WHERE email = ?")) {
        ps.setString(1, dashboardStudentEmail);
        try (ResultSet rs = ps.executeQuery()) {
          if (rs.next() && rs.getString("fullName") != null) {
            dashboardStudentFullName = rs.getString("fullName").trim();
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
      // Auto-refresh interviews every 5 seconds for real-time synchronization
      setInterval(loadInterviews, 5000);

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
    </script>



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

    <script>
      (function() {
        const mockBtn = document.getElementById("openMockInterviewBtn");
        if (mockBtn) {
          mockBtn.addEventListener("click", function () {
            window.location.href = "MockInterview.jsp";
          });
        }
      })();
    </script>

  </body>

  </html>