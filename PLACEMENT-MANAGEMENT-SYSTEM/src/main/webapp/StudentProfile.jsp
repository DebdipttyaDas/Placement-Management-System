<%@ page language="java" contentType="text/html; charset=UTF-8" %>

  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <title>Profile Settings</title>
    <link rel="stylesheet" href="StudentProfile.css">
  </head>

  <body>

    <div class="container">

      <!-- Sidebar -->
      <div class="sidebar-card">
        <h2>Student Profile</h2>

        <ul>
          <li><a href="Student_dashboard.jsp" style="color: white;text-decoration: none;">Dashboard</a></li>
          <li><a href="Placement.jsp" style="color: white;text-decoration: none;">Placement</a></li>
          <li><a href="MyApplication.jsp" style="color: white;text-decoration: none;">My Applications</a></li>
        </ul>

        <!-- Logout -->
        <form action="LogoutServlet" method="post">
          <button class="logout-btn">Logout</button>
        </form>
      </div>

      <!-- Main Content -->
      <div class="main-content">

        <!-- HEADER CARD -->
        <div class="header-card" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
          <div class="header-left" style="display:flex; align-items:center; gap:15px;">
            <button class="sidebar-toggle-btn" id="sidebar-toggle" style="background:none; border:none; color:black; font-size:24px; cursor:pointer;" aria-label="Toggle Sidebar">
                &#9776;
            </button>
            <h1>Profile Settings</h1>
          </div>

          <div class="btn-group">
            <!-- FIXED BUTTON -->
            <a href="Student_dashboard.jsp" class="nav-btn">Back to Dashboard</a>

            <!-- Save Button connected to form -->
            <button type="submit" form="profileForm">Save Profile</button>
          </div>
        </div>

        <!-- FORM START -->
        <form id="profileForm" action="UpdateStudentProfileServlet" method="post" enctype="multipart/form-data">

          <!-- AVATAR CARD -->
          <div class="card avatar-card">
            <h2>Profile Picture</h2>
            <p>Only JPG . Max size 500KB</p>

            <div class="avatar-box">
              <img id="profilePreview"
                src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ccc'><path d='M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z'/></svg>"
                alt="Profile Preview">
            </div>

            <input type="file" name="photo" id="photoInput" class="upload-btn" accept="image/png, image/jpeg">
          </div>

          <!-- PERSONAL INFO -->
          <div class="card">
            <h2>Personal Information</h2>
            <div class="form-grid">
              <input type="text" name="name" placeholder="Your name">
              <input type="email" name="email" placeholder="Your email">
              <input type="password" name="password" placeholder="Your password">
              <input type="tel" name="phone" placeholder="Phone number">
              <input class="full-width" type="date" name="dob" placeholder="Date of birth">
            </div>
          </div>

          <!-- ACADEMIC -->
          <div class="card">
            <h2>Academic Details</h2>
            <div class="form-grid">
              <input type="text" name="college" placeholder="College name">
              <input type="text" name="department" placeholder="Department">
              <input type="text" name="dgpa" placeholder="DGPA">
            </div>
          </div>

          <!-- LANGUAGES -->
          <div class="card">
            <h2>Languages Known</h2>

            <input type="text" name="languages" placeholder="English, Bengali, Hindi">
          </div>

          <!-- SKILLS -->
          <div class="card glass-skills-card">
            <div class="skills-header">
              <h2>Professional Skills</h2>
              <button type="button" class="btn-add-skill" onclick="openSkillModal()">+ Add Skill</button>
            </div>
            <div class="skills-container" id="skillsContainer">
              <!-- Skill chips injected via JS -->
            </div>
            <input type="hidden" name="skills" id="skillsInput" value="">
          </div>

        </form>
        <!-- FORM END -->

      </div>
    </div>

    <!-- SKILL MODAL -->
    <div id="skillModal" class="modal-overlay">
      <div class="modal-glass">
        <div class="modal-header">
          <h3>Add Professional Skill</h3>
          <button type="button" class="close-btn" onclick="closeSkillModal()">&times;</button>
        </div>
        <div class="modal-body">
          <div class="search-box">
            <input type="text" id="skillSearch" placeholder="Search skills (e.g. Java, HTML)">
          </div>
          <div class="suggested-skills">
            <span class="suggested-chip" onclick="selectSuggested('Java')">Java</span>
            <span class="suggested-chip" onclick="selectSuggested('JSP')">JSP</span>
            <span class="suggested-chip" onclick="selectSuggested('Servlet')">Servlet</span>
            <span class="suggested-chip" onclick="selectSuggested('JDBC')">JDBC</span>
            <span class="suggested-chip" onclick="selectSuggested('MySQL')">MySQL</span>
            <span class="suggested-chip" onclick="selectSuggested('HTML')">HTML</span>
            <span class="suggested-chip" onclick="selectSuggested('CSS')">CSS</span>
            <span class="suggested-chip" onclick="selectSuggested('JavaScript')">JavaScript</span>
            <span class="suggested-chip" onclick="selectSuggested('Git')">Git</span>
            <span class="suggested-chip" onclick="selectSuggested('REST API')">REST API</span>
          </div>
          <div class="level-box">
            <select id="skillLevel">
              <option value="Beginner">Beginner</option>
              <option value="Intermediate">Intermediate</option>
              <option value="Advanced">Advanced</option>
              <option value="Expert">Expert</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn-save-skill" onclick="saveSkill()">Save Skill</button>
        </div>
      </div>
    </div>

    <script>
      let skillsArray = [];

      function openSkillModal() {
        document.getElementById('skillModal').classList.add('show');
        document.getElementById('skillSearch').value = '';
        document.getElementById('skillLevel').value = 'Beginner';
      }

      function closeSkillModal() {
        document.getElementById('skillModal').classList.remove('show');
      }

      function selectSuggested(skill) {
        document.getElementById('skillSearch').value = skill;
      }

      function saveSkill() {
        const name = document.getElementById('skillSearch').value.trim();
        const level = document.getElementById('skillLevel').value;

        if (!name) {
          alert("Please enter or select a skill.");
          return;
        }

        const exists = skillsArray.some(s => s.name.toLowerCase() === name.toLowerCase());
        if (exists) {
          alert("Skill already added!");
          return;
        }

        skillsArray.push({ name, level });
        updateSkillsUI();
        closeSkillModal();
      }

      function removeSkill(index) {
        skillsArray.splice(index, 1);
        updateSkillsUI();
      }

      function updateSkillsUI() {
        const container = document.getElementById('skillsContainer');
        const hiddenInput = document.getElementById('skillsInput');

        container.innerHTML = '';
        let stringData = [];

        skillsArray.forEach((skill, index) => {
          const chip = document.createElement('div');
          chip.className = 'skill-chip';
          chip.innerHTML =
            '<span class="skill-name">' + skill.name + '</span>' +
            '<span class="skill-level">' + skill.level + '</span>' +
            '<span class="skill-remove" onclick="removeSkill(' + index + ')">&times;</span>';
          container.appendChild(chip);
          stringData.push(skill.name + ':' + skill.level);
        });

        hiddenInput.value = stringData.join(',');
      }
    </script>
    <script src="StudentProfile.js"></script>

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

    <script>
      (function() {
        const toggleBtn = document.getElementById('sidebar-toggle');
        const sidebar = document.querySelector('.sidebar-card');
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