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
       
        <button class="create-btn"> Create New Slot </button> 
        </div>
         </div> 
         
         <!-- CONTENT GRID --> 
         <div class="content">
         
          <!-- LEFT SIDE -->
           <div class="schedule">
           
            <!-- SLOT 1 -->
             <div class="slot"> 
             <span class="time">09:00 AM</span>
              <div class="card blue">
               <h4>TECH ROUND 1</h4>
                <p><b>Google Inc</b></p> 
                
                <p>Student: Arjun Sarkar</p> 
                </div> 
                </div>
                
          <!-- SLOT 2 -->
           <div class="slot"> 
           <span class="time">10:30 AM</span> 
           <div class="card purple">
            <h4>HR INTERVIEW</h4>
             <p><b>Adobe Systems</b></p>
              <p>Student: Priya Dey</p>
               </div>
                </div>
                
        <!-- SLOT 3 --> 
        <div class="slot">
         <span class="time">--</span>
          <div class="card red">
           <h4>URGENT: RESCHEDULE</h4>
            <p><b>Microsoft</b></p> 
            <p>Student: Unassigned</p> 
            <button class="assign-btn"> Assign Candidate </button>
             </div>
              </div>
              
    <!-- ADD SLOT -->
     <div class="add-slot"> + Add availability slot </div>
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
               
               </body>
               </html>