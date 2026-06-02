<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Job Post</title>

    <!-- CSS -->
    <!-- JobPost -->
    <link rel="stylesheet" href="JobPost.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <!-- Chatbot -->
    
    <link rel="stylesheet" href="chatbot.css">
   
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">

    <div class="logo">
        Company Portal
    </div>

    <ul class="menu">

        <li>
            <a href="CompanyDashboard.jsp">
                Dashboard
            </a>
        </li>

        <li>
            <a href="JobPost.jsp" class="active">
                Job Post
            </a>
        </li>

        <li>
            <a href="Interviews.jsp">
                Interviews
            </a>
        </li>

        <li>
            <a href="PlacementAnalysis.jsp">
                Placement Analysis
            </a>
        </li>

    </ul>

    <!-- LOGOUT -->
    <div class="logout">

        <button>
            Logout
        </button>

    </div>

</div>

<!-- MAIN CONTENT -->
<div class="main-content">

    <!-- TOPBAR -->
    <div class="topbar">

        <h2>
            Post, Hire and Grow !
        </h2>
        
    </div>

    <!-- FORM CONTAINER -->
    <div class="form-container">

        <h3>
            Create New Job Posting
        </h3>

        <p>
            Fill out the details below to publish a new opportunity for students.
        </p>

        <form action="JobPostServlet" method="post" onsubmit="prepareSubmit()">

        <!-- BASIC INFORMATION -->
        <div class="section">

            <div class="section-title">
                Company Name 
                <input type="text"
                id="companyName"
                name="companyName"
                class="form-control"
                placeholder="Enter Company name ">
            </div>

<div class="form-row">

    <div class="form-group">
        <label>Job Title *</label>

        <input type="text"
        id="jobTitle"
        name="jobTitle"
        class="form-control"
        placeholder="e.g. Senior Software Engineer"
        required>
    </div>

    <div class="form-group">

                    <label>Employment Type</label>

                    <select id="employmentType" name="employmentType" class="form-control">
                        <option>Full-time</option>
                        <option>Part-time</option>
                        <option>Internship</option>
                    </select>

                </div>

</div>

            <div class="form-row">

                <div class="form-group">

                    <label>Department</label>

                    <select id="department" name="department" class="form-control">
                        <option>Select Department</option>
                        <option>CSE</option>
                        <option>ECE</option>
                        <option>EEE</option>
                        <option>IT</option>
                        <option>BCA</option>
                        <option>MCA</option>
                        <option>BBA</option>
                        <option>MBA</option>
                    </select>

                </div>

                <div class="form-group">
			        <label>Salary</label>
			
			        <input type="text"
			        class="form-control"
			        placeholder="e.g. INR 30k-50k">
               </div>
            </div>

            <div class="form-row">

                <div class="form-group">

                    <label>Location Type</label>

                    <select id="locationType" name="locationType" class="form-control">
                        <option>Remote</option>
                        <option>On-site</option>
                        <option>Hybrid</option>
                    </select>

                </div>

                <div class="form-group">

                    <label>Location</label>

                    <input type="text"
                    id="location"
                    name="location"
                    class="form-control"
                    placeholder="e.g. Bangalore,Pune">

                </div>
            </div>
            
				<div class="form-group apply-before-group">
                    <label>Application Deadline *</label>
                    <input type="date" 
                    id="applicationDeadline" 
                    name="applicationDeadline" 
                    class="form-control"
                    onchange="validateDeadline()"
                    required>
                    <small id="deadlineMessage" style="color: red; display: none; margin-top: 5px;"></small>
                </div>
        </div>

        <!-- JOB DETAILS -->
        <div class="section">

            <div class="section-title">

                <i class="fa-solid fa-file-lines"></i>

                Job Details

            </div>

            <div class="form-group">

                <label>
                    Job Description
                </label>

                <!-- TOOLBAR -->
                <div class="toolbar">

                    <button type="button"
                    onclick="formatText('bold')">

                        <i class="fa-solid fa-bold"></i>

                    </button>

                    <button type="button"
                    onclick="formatText('italic')">

                        <i class="fa-solid fa-italic"></i>

                    </button>

                    <button type="button"
                    onclick="formatText('underline')">

                        <i class="fa-solid fa-underline"></i>

                    </button>

                    <button type="button"
                    onclick="formatText('insertUnorderedList')">

                        <i class="fa-solid fa-list"></i>

                    </button>

                    <button type="button"
                    onclick="addLink()">

                        <i class="fa-solid fa-link"></i>

                    </button>

                </div>

                <!-- EDITOR -->
                <div class="editor form-control"
                contenteditable="true">
                </div>
                
                <input type="hidden" name="jobDescription" id="hiddenJobDesc">

            </div>

        </div>

        <!-- BUTTON -->
        <button type="submit" id="publishBtn" class="submit-btn" onclick="return validateForm()">

            Publish Job

        </button>
        <small id="buttonMessage" style="color: red; display: none; margin-top: 10px; display: block;"></small>

        </form>

    </div>

</div>

<!-- SCRIPT -->
<script src="Jobpost.js"></script>

<!-- Chatbot -->
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