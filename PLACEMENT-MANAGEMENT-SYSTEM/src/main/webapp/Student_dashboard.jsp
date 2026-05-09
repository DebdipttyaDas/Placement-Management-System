<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isELIgnored="false"%>

  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>

    <!-- External CSS -->
    <link rel="stylesheet" href="Student_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  </head>

  <body>

    <!-- DASHBOARD CONTAINER -->
    <div class="dashboard-container">

      <!-- LEFT SIDEBAR -->
      <div class="sidebar">
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
        <div style="display:flex; justify-content:flex-end; padding:15px; background:#03352f; color:white;">
          <div style="display:flex; align-items:center; gap:30px;">
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
                  : "Student" %>! 👋</h1>
              <p>You're in the top 15% of candidates this week. Keep the momentum going for the upcoming Google
                interview.</p>

              <div class="welcome-actions">
                <div class="btn-apply-wrapper">
                  <a href="#" class="btn-apply"><i class="fa fa-briefcase"></i> Apply to Jobs</a>
                </div>
                <a href="#" class="btn-resume"><i class="fa fa-file-alt"></i> My Resume</a>
              </div>
            </div>

            <%
    Object profileObj = session.getAttribute("profileComplete");

    String profileComplete = "0";

    if(profileObj != null){
        profileComplete = profileObj.toString();
    }

    int progressValue = Integer.parseInt(profileComplete);
%>

<div class="readiness-box">

    <div class="readiness-header">
        <span class="readiness-title">Profile Completion</span>
        <span class="pro-badge">Pro Level</span>
    </div>

    <div class="progress-bar-container">

        <div class="progress-track">

            <div class="progress-fill"
                 id="profileProgressBar"
                 style="width:<%= profileComplete %>%;">
            </div>

        </div>

    </div>

    <div class="readiness-footer">

        <span>
            <%= profileComplete %>% Complete
        </span>

        <span>
            <%= (progressValue == 100)
                ? "All Set!"
                : "Action: Update Profile" %>
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

                <!-- Active Interview Card -->
                <div class="interview-card active-card">
                  <div class="ic-header">
                    <span class="ic-time">TODAY @ 14:30</span>
                    <span class="ic-badge">Technical Round 1</span>
                  </div>
                  <h2 class="ic-company">Google</h2>
                  <div class="ic-details">
                    <span><i class="fa-solid fa-video"></i> Google Meet</span>
                    <span><i class="fa-regular fa-user"></i> Sarah Jenkins (Recruiter)</span>
                  </div>
                  <div class="ic-actions">
                    <button class="btn-join">Join Call</button>
                    <button class="btn-more">...</button>
                  </div>
                </div>

                <!-- Upcoming Interview Card -->
                <div class="interview-card upcoming-card">
                  <div class="ic-header">
                    <span class="ic-time">OCT 24 @ 10:00</span>
                    <img src="https://i.pravatar.cc/150?u=a042581f4e29026704d" alt="Interviewer"
                      class="interviewer-pic" />
                  </div>
                  <h2 class="ic-company">Airbnb</h2>
                  <p class="ic-type">Culture Fit Round</p>

                  <div class="ic-footer">
                    <span class="interviewer-name">Interviewer: David Chen</span>
                    <a href="#" class="btn-calendar">ADD TO CALENDAR</a>
                  </div>
                </div>

              </div>

            </div>

          </div>

          <!-- LATEST PLACEMENTS -->
<div class="job-cards">
    <div class="job-card">
        <h3>Job Title</h3>
        <p><b style="color: white;">Company Name</b></p>
        <div>
            <span>Location</span>
            <span>Part-time/Full-time</span>
        </div>
        <button>View Details</button>
    </div>

    <div class="job-card">
        <h3>Job Title</h3>
        <p><b style="color: white;">Company Name</b></p>
        <div>
            <span>Location</span>
            <span>Part-time/Full-time</span>
        </div>
        <button>View Details</button>
    </div>
    
    <div class="job-card">
        <h3>Job Title</h3>
        <p><b style="color: white;">Company Name</b></p>
        <div>
            <span>Location</span>
            <span>Part-time/Full-time</span>
        </div>
        <button>View Details</button>
    </div>
</div>

        </div>

      </div>

    </div>

  </body>

  </html>