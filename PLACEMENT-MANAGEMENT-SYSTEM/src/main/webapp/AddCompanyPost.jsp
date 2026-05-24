<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Company Post</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- External CSS -->
    <link rel="stylesheet" href="PlacementMonitoring.css">
</head>

<body class="bg-gray-100">

<div class="form-container">

    <div class="form-box">

        <h1 class="form-heading">
            Add Company Job
        </h1>

        <form action="AddCompanyPostServlet" method="post">

            <!-- Job Title -->
            <div class="input-group">
                <label>Job Title</label>
                <input type="text" name="job_title" required>
            </div>

            <!-- Department -->
            <div class="input-group">
                <label>Department</label>
                <input type="text" name="department" required>
            </div>

            <!-- Location Type -->
            <div class="input-group">
                <label>Location Type</label>

                <select name="location_type" required>
                    <option value="">Select</option>
                    <option>Remote</option>
                    <option>Hybrid</option>
                    <option>Onsite</option>
                </select>
            </div>

            <!-- Employment Type -->
            <div class="input-group">
                <label>Employment Type</label>

                <select name="employment_type" required>
                    <option value="">Select</option>
                    <option>Full-Time</option>
                    <option>Part-Time</option>
                    <option>Internship</option>
                </select>
            </div>

            <!-- Salary -->
            <div class="input-group">
                <label>Salary</label>
                <input type="text" name="salary" required>
            </div>

            <!-- Location -->
            <div class="input-group">
                <label>Location</label>
                <input type="text" name="location" required>
            </div>

            <button type="submit" class="submit-btn">
                Post Job
            </button>

        </form>

    </div>

</div>

</body>
</html>