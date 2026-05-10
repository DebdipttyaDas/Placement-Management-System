<%@ page language="java" 
contentType="text/html;
 charset=UTF-8" 
           pageEncoding="UTF-8"%> 
<!DOCTYPE html>
 <html lang="en">
 
  <head>
   <meta charset="UTF-8"> 
   <title>Interview Scheduling</title>
    <!-- CSS -->
     <link rel="stylesheet" href="Interviews.css"> 
    <!-- Font Awesome -->
     <link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"> 
      </head>
      
       <body>
       
        <div class="container">
        
         <!-- ===== SIDEBAR ===== -->
         
          <aside class="sidebar">
           <br> 
           <br><br>
           
            <ul class="menu">
             <li>
              <a href="CompanyDashboard.jsp" 
              style="text-decoration: none; color:white;"> Dashboard </a>
               </li>
                <li>
                 <a href="JobPosted.jsp"
                  style="text-decoration: none; color: white;"> Job Posted </a> 
                  </li>
                   <li class="active">
                    
                     Interviews  
                     </li>
                      <li>
                       <a href="PlacementAnalysis.jsp"
                        style="text-decoration: none; color: white;"> Placement Analysis </a>
                         </li>
                          </ul>
                           </aside>
                           
                            
                           <!-- ===== MAIN CONTENT ===== -->
                     <main class="main-content"> 
                     
                     <!-- HEADER -->
                   
                    <div class="topbar">
                    
                     <h2>Interviews</h2>
                     
                      <div class="top-links">
                      
                       <div style="display:flex; align-items:center; gap:30px;">
                       
                        <a href="AdminProfile.jsp"> 
                        <i class="fa fa-user-circle" 
                        style="font-size:25px; color:white;"></i>
                         </a>
                          </div>
                           </div>
                            </div>
                            
            <!-- TITLE -->
            
             <div class="page-header">
             
              <h1>Interview Scheduling</h1> 
              
              <p>
               Coordinate upcoming placement rounds by mapping panel availability to shortlisted candidates. 
               </p> 
               </div>
               
                <!-- CONTROLS --> 
                
                <div class="toolbar"> 
                
                <div class="left-group">
                
                 <span class="arrow">&#10094;</span>
                 
                  <span class="date-text">May 06, 2026</span> 
                  <span class="arrow">&#10095;</span>
                  
                   <div class="view-toggle"> 
                   
                   <button class="active">Day</button>
                    <button>Week</button> 
                    <button>Month</button>
                     </div>
                      </div>
                      
                       <div class="right-actions">
                       
       <button class="filter-btn"> Filter View </button>
       
        <button class="create-btn" id="openSlotModalBtn"> Create New Slot </button> 
        </div>
         </div> 
         
         <!-- CONTENT GRID --> 
         <div class="content">
         
           <!-- LEFT SIDE -->
            <div class="schedule" id="adminScheduleContainer">
                <div style="padding: 20px; text-align: center; color: #666; font-size: 14px;">
                    Loading scheduled interviews...
                </div>
            </div>
      
       <!-- RIGHT SIDE -->
        <div class="sidebar-right"> 
        
        <!-- STATS -->
         <div class="stats">
          <div class="box"> 
          <p>Total Rounds</p> 
          <h2>24</h2> 
          </div>
          
           <div class="box">
            <p>Conflicts</p> 
            <h2 class="red-text">02</h2>
             </div>
              </div>
              
               <!-- PENDING --> 
               <div class="pending">
                <h3>Pending Assignment</h3> 
                <div class="person">Rahul Chowdhary</div> 
                <div class="person">Sudipta Roy</div>
                 <div class="person">Prantik Bose</div>
                  <button class="view-btn"> View All Shortlisted </button>
                   </div>
                   
       <!-- PANEL LOAD --> 
       <div class="panel-load">
        <h3>Panelist Load</h3> 
        <p>Suresh Kumar (Tech)</p>
         <div class="bar blue-bar"></div> 
         <p>Anita Banerjee (HR)</p> 
         <div class="bar red-bar"></div>
          </div>
           </div>
            </div>
             </main> 
             </div>
             
              <!-- JavaScript -->
               <script>
               const buttons = document.querySelectorAll(".view-toggle button"); 
               buttons.forEach(btn => { 
            	   btn.addEventListener("click", () => {
            		   buttons.forEach(b =>
            		   b.classList.remove("active"));
            		   btn.classList.add("active");
            		   
            	   });
            	   
               }); 
               
               </script> 
               
               <!-- MODAL OVERLAY -->
               <div class="modal-overlay" id="slotModalOverlay">
                   <div class="modal-content">
                       <div class="modal-header">
                           <h2><i class="fa fa-calendar-plus"></i> Schedule Interview Slot</h2>
                           <button class="close-btn" id="closeSlotModalBtn">&times;</button>
                       </div>
                       <form id="scheduleInterviewForm">
                           <div class="form-row">
                               <div class="form-group">
                                   <label>Company Name</label>
                                   <input type="text" id="company_name" name="company_name" required placeholder="e.g. Google Inc">
                               </div>
                               <div class="form-group">
                                   <label>Interview Round</label>
                                   <input type="text" id="interview_round" name="interview_round" required placeholder="e.g. Technical Round 1">
                               </div>
                           </div>
                           <div class="form-row">
                               <div class="form-group">
                                   <label>Student Name</label>
                                   <input type="text" id="student_name" name="student_name" required placeholder="e.g. Arjun Sarkar">
                               </div>
                               <div class="form-group">
                                   <label>Student Email</label>
                                   <input type="email" id="student_email" name="student_email" required placeholder="e.g. arjun@example.com">
                               </div>
                           </div>
                           <div class="form-row">
                               <div class="form-group">
                                   <label>Interviewer Name</label>
                                   <input type="text" id="interviewer_name" name="interviewer_name" required placeholder="e.g. Sarah Jenkins">
                               </div>
                               <div class="form-group">
                                   <label>Duration (mins)</label>
                                   <input type="number" id="duration" name="duration" value="60" required min="15">
                               </div>
                           </div>
                           <div class="form-row">
                               <div class="form-group">
                                   <label>Date</label>
                                   <input type="date" id="interview_date" name="interview_date" required>
                               </div>
                               <div class="form-group">
                                   <label>Time</label>
                                   <input type="time" id="interview_time" name="interview_time" required>
                               </div>
                           </div>
                           <button type="submit" class="submit-btn" id="submitBtn">
                               <span>Create Slot & Generate Meet</span>
                               <div class="loader" id="submitLoader"></div>
                           </button>
                       </form>
                   </div>
               </div>
               
               <!-- TOAST NOTIFICATION -->
               <div id="toastNotification" class="toast">Slot created successfully!</div>
               
               <script>
               // Modal Logic
               const openBtn = document.getElementById('openSlotModalBtn');
               const closeBtn = document.getElementById('closeSlotModalBtn');
               const modalOverlay = document.getElementById('slotModalOverlay');
               
               openBtn.addEventListener('click', () => {
                   modalOverlay.classList.add('active');
               });
               
               closeBtn.addEventListener('click', () => {
                   modalOverlay.classList.remove('active');
               });
               
               // Form Submission (AJAX)
               const form = document.getElementById('scheduleInterviewForm');
               const submitBtn = document.getElementById('submitBtn');
               const loader = document.getElementById('submitLoader');
               const toast = document.getElementById('toastNotification');
               
               form.addEventListener('submit', async (e) => {
                   e.preventDefault();
                   
                   // UI State
                   submitBtn.disabled = true;
                   loader.style.display = 'inline-block';
                   submitBtn.querySelector('span').style.display = 'none';
                   
                   const formData = {
                       company_name: document.getElementById('company_name').value,
                       student_name: document.getElementById('student_name').value,
                       student_email: document.getElementById('student_email').value,
                       interviewer_name: document.getElementById('interviewer_name').value,
                       interview_date: document.getElementById('interview_date').value,
                       interview_time: document.getElementById('interview_time').value,
                       duration: parseInt(document.getElementById('duration').value),
                       interview_round: document.getElementById('interview_round').value
                   };
                   
                   try {
                       const response = await fetch('ScheduleInterviewServlet', {
                           method: 'POST',
                           headers: { 'Content-Type': 'application/json' },
                           body: JSON.stringify(formData)
                       });
                       
                       const result = await response.json();
                       
                       if (result.success) {
                           showToast("Interview slot created successfully!", "success");
                           modalOverlay.classList.remove('active');
                           form.reset();
                            // Auto-update interview cards dynamically via AJAX
                            loadAdminInterviews();
                       } else {
                           showToast(result.message || "Failed to create slot", "error");
                       }
                   } catch (error) {
                       console.error("Error:", error);
                       showToast("Network error. Please try again.", "error");
                   } finally {
                       submitBtn.disabled = false;
                       loader.style.display = 'none';
                       submitBtn.querySelector('span').style.display = 'inline';
                   }
               });
               
               function showToast(message, type) {
                   toast.innerText = message;
                   toast.className = 'toast show ' + (type === 'error' ? 'error' : '');
                   setTimeout(() => { toast.classList.remove('show'); }, 3000);
               }

               // Load Interviews dynamically
               async function loadAdminInterviews() {
                   const container = document.getElementById('adminScheduleContainer');
                   try {
                       const response = await fetch('FetchInterviewsServlet?all=true');
                       if (!response.ok) throw new Error("Failed to fetch");
                       const interviews = await response.json();
                       
                       if (interviews.length === 0) {
                           container.innerHTML = `<div style="padding: 20px; text-align: center; color: #666; font-size: 14px;">No interviews scheduled yet.</div>`;
                       } else {
                           container.innerHTML = ""; // clear loading text
                           
                           // Array of colors for styling cards
                           const colors = ['blue', 'purple', 'red'];
                           
                           interviews.forEach((inv, index) => {
                               const cardColor = colors[index % colors.length];
                               
                               const slotHtml = `
                                 <div class="slot"> 
                                     <span class="time">${inv.interview_time}</span>
                                     <div class="card ${cardColor}">
                                         <h4>${inv.interview_round.toUpperCase()}</h4>
                                         <p><b>${inv.company_name}</b></p> 
                                         <p>Student: ${inv.student_name}</p> 
                                     </div> 
                                 </div>`;
                               container.innerHTML += slotHtml;
                           });
                       }
                       
                       // Append Add Slot button at the end
                       container.innerHTML += `<div class="add-slot" onclick="document.getElementById('openSlotModalBtn').click();" style="cursor:pointer;"> + Add availability slot </div>`;
                       
                   } catch (err) {
                       console.error(err);
                       container.innerHTML = `<div style="padding: 20px; text-align: center; color: red; font-size: 14px;">Unable to load interviews</div>`;
                   }
               }
               
               // Initial load
               loadAdminInterviews();
               </script>
               </body>
               </html>
