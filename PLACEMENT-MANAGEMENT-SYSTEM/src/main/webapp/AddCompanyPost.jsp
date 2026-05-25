<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Company Post</title>

    <link rel="stylesheet" href="AddCompanyPost.css">
</head>

<body>

    <div class="form-container">

        <form action="AddCompanyPostServlet" method="post" class="job-form">

            <h1>Add Company Post</h1>

            <div class="form-grid">

                <!-- Job Title -->
                <div class="input-group">
                    <label>Job Title *</label>
                    <input type="text"
                           name="jobTitle"
                           placeholder="e.g. Senior Software Engineer"
                           required>
                </div>

                <!-- Employment Type -->
                <div class="input-group">
                    <label>Employment Type</label>
                    <input type="text"
                           name="employmentType"
                           placeholder="e.g. Full-time">
                </div>

                <!-- Department -->
                <div class="input-group">
                    <label>Department</label>
                    <input type="text"
                           name="department"
                           placeholder="e.g. BCA">
                </div>

                <!-- Salary -->
                <div class="input-group">
                    <label>Salary</label>
                    <input type="text"
                           name="salary"
                           placeholder="e.g. INR 30k-50k">
                </div>

                <!-- Location Type -->
                <div class="input-group">
                    <label>Location Type</label>
                    <input type="text"
                           name="locationType"
                           placeholder="e.g. Remote">
                </div>

                <!-- Location -->
                <div class="input-group">
                    <label>Location</label>
                    <input type="text"
                           name="location"
                           placeholder="e.g. Bangalore, Pune">
                </div>

            </div>

            <!-- Description -->
            <div class="input-group full-width">
                <label>Job Description</label>

                <textarea name="description"
                          placeholder="Enter job description here..."></textarea>
            </div>

            <!-- Submit -->
            <button type="submit" class="submit-btn">
                Submit Job Post
            </button>

        </form>

    </div>

</body>
</html>