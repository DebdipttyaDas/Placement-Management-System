<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-80.8>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms & Conditions</title>

    <!-- CSS -->
    <link rel="stylesheet" href="Terms.css">
    
</head>

<body>

<h1>Terms & Conditions</h1>

<p>
    Welcome to CampusConnect. By accessing and using this platform,
    you agree to comply with the following terms and conditions.
</p>

<!-- ================= STUDENT TERMS ================= -->

<h2>For Students</h2>

<h3>1. Use of Platform</h3>

<p>
    Students may use this platform only for placement activities,
    internship applications, and career opportunities.
</p>

<h3>2. Student Responsibility</h3>

<p>
    Students are responsible for maintaining the confidentiality
    of their account credentials and ensuring professional conduct.
</p>

<h3>3. Accuracy of Information</h3>

<p>
    Students must provide accurate academic records, resumes,
    and personal information. Any false information may lead
    to suspension from placement activities.
</p>

<h3>4. Prohibited Activities</h3>

<p>
    Students must not upload fraudulent documents,
    impersonate others, or misuse the platform.
</p>

<!-- ================= COMPANY TERMS ================= -->

<h2>For Companies</h2>

<h3>1. Recruitment Purpose</h3>

<p>
    Companies may use this platform only for legitimate
    recruitment, internship hiring, and placement activities.
</p>

<h3>2. Company Responsibility</h3>

<p>
    Companies are responsible for maintaining accurate job postings,
    interview schedules, and recruiter information.
</p>

<h3>3. Fair Hiring Practices</h3>

<p>
    Companies must ensure fair and non-discriminatory
    recruitment practices while interacting with students.
</p>

<h3>4. Misuse Restriction</h3>

<p>
    Companies must not misuse student data or use the platform
    for unauthorized marketing  purposes.
</p>

<!-- ================= PRIVACY POLICY ================= -->

<h1>Privacy Policy</h1>

<p>
    Your privacy is important to us. This policy explains how
    CampusConnect collects and uses your data.
</p>

<h3>1. Information We Collect</h3>

<p>
    We collect personal details such as name, email,
    phone number, academic details, resumes,
    and recruitment information.
</p>

<h3>2. How We Use Information</h3>

<p>
    Information is used to connect students with companies,
    manage applications, schedule interviews,
    and improve platform services.
</p>

<h3>3. Data Protection</h3>

<p>
    We implement security measures to protect user data
    from unauthorized access.
</p>

<h3>4. Sharing of Information</h3>

<p>
    Student information may be shared with registered companies
    strictly for recruitment purposes.
</p>

<h3>5. Cookies</h3>

<p>
    Cookies may be used to improve user experience
    and analyze platform usage.
</p>

<h3>6. User Rights</h3>

<p>
    Users may update or request deletion
    of their personal information.
</p>

<h3>7. Contact</h3>

<p>
    For any terms or privacy-related queries,
    please contact us through the platform.
</p>

<!-- BACK LINKS -->

<p>
    <a href="StudentRegister.jsp">
        Back to Student Register
    </a>
</p>

<p>
    <a href="CompanyRegister.jsp">
        Back to Company Register
    </a>
</p>

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