<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Job Post</title>

    <!-- CSS -->
    <link rel="stylesheet" href="JobPost.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

        <div class="profile-icons">

            <i class="fa-solid fa-user-circle"></i>

            <i class="fa-solid fa-bell"></i>

        </div>

    </div>

    <!-- FORM CONTAINER -->
    <div class="form-container">

        <h3>
            Create New Job Posting
        </h3>

        <p>
            Fill out the details below to publish a new opportunity for students.
        </p>

        <!-- BASIC INFORMATION -->
        <div class="section">

            <div class="section-title">

                <i class="fa-solid fa-circle-info"></i>

                Basic Information

            </div>

            <!-- JOB TITLE -->
            <div class="form-group">

                <label>
                    Job Title *
                </label>

                <input type="text"
                class="form-control"
                placeholder="e.g. Senior Software Engineer">

            </div>

            <!-- ROW -->
            <div class="form-row">

                <!-- DEPARTMENT -->
                <div class="form-group">

                    <label>
                        Department
                    </label>

                    <select class="form-control">

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

                <!-- EMPLOYMENT TYPE -->
                <div class="form-group">

                    <label>
                        Employment Type
                    </label>

                    <select class="form-control">

                        <option>Full-time</option>

                        <option>Part-time</option>

                        <option>Internship</option>

                    </select>

                </div>

            </div>

            <!-- ROW -->
            <div class="form-row">

                <!-- LOCATION -->
                <div class="form-group">

                    <label>
                        Location Type
                    </label>

                    <select class="form-control">

                        <option>Remote</option>

                        <option>On-site</option>

                        <option>Hybrid</option>

                    </select>

                </div>

                <!-- SALARY -->
                <div class="form-group">

                    <label>
                        Salary Range
                    </label>

                    <input type="text"
                    class="form-control"
                    placeholder="e.g. INR 50K-100K">

                </div>

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
                    Job Description *
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

            </div>

        </div>

        <!-- BUTTON -->
        <button class="submit-btn">

            Publish Job

        </button>

    </div>

</div>

<!-- SCRIPT -->
<script>

function formatText(command){

    document.execCommand(command, false, null);

}

function addLink(){

    let url = prompt("Enter URL:");

    if(url){

        document.execCommand("createLink", false, url);

    }
}

</script>

</body>
</html>