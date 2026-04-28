<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Student Registration</title>
  <link rel="stylesheet" href="StudentRegister.css">
</head>

<body>

  <!-- ===== HEADER ===== -->
  <header>
    <h2>CampusConnect</h2>
    <div>
      <span>Already have an account?</span>
      <!-- changed .html → .jsp -->
      <a href="Login.jsp">
        <button type="button">Login</button>
      </a>
    </div>
  </header>

  <!-- ===== MAIN CONTAINER ===== -->
  <div>

    <!-- LEFT SIDE -->
    <div>
      <h1>Create Your Student Account</h1>
      <p>Register and start your journey towards your dream career.</p>

      <div>
        <h4>Find Best Opportunities</h4>
        <p>Explore job openings from top companies.</p>
      </div>

      <div>
        <h4>Track Your Progress</h4>
        <p>Stay updated with your application status.</p>
      </div>

      <div>
        <h4>Build Your Profile</h4>
        <p>Showcase your skills and grow your career.</p>
      </div>
    </div>

    <!-- RIGHT SIDE -->
    <div>

      <h2 style="color: #ffffff;">Student Registration</h2>
      <br>

      <!-- CONNECT TO SERVLET -->
      <form action="StudentRegisterServlet" method="post" enctype="multipart/form-data">

        <!-- Row 1 -->
        <div>
          <label style="color: #ffffff;">Full Name</label><br>
          <input type="text" name="fullName" placeholder="Enter your full name" required>
        </div>

        <div>
          <label style="color: #ffffff;">College Name</label><br>
          <input type="text" name="collegeName" placeholder="Enter your college name" required>
        </div>

        <!-- Row 2 -->
        <div>
          <label style="color: #ffffff;">Department</label><br>
          <select name="department" required>
            <option value="">Select your department</option>
            <option value="CSE">CSE</option>
            <option value="BCA">BCA</option>
            <option value="MCA">MCA</option>
            <option value="BBA">BBA</option>
            <option value="MBA">MBA</option>
            <option value="IT">IT</option>
            <option value="ECE">ECE</option>
          </select>
        </div>

        <div>
          <label style="color: #ffffff;">Year</label><br>
          <select name="year" required>
            <option value="">Select year</option>
            <option value="1st Year">1st Year</option>
            <option value="2nd Year">2nd Year</option>
            <option value="3rd Year">3rd Year</option>
            <option value="4th Year">4th Year</option>
          </select>
        </div>

        <!-- Row 3 -->
        <div>
          <label style="color: #ffffff;">CGPA / Percentage</label><br>
          <input type="text" name="cgpa" placeholder="Enter your CGPA or %" required>
        </div>

        <div>
          <label style="color: #ffffff;">Date of Birth</label><br>
          <input type="date" name="dob" required>
        </div>

        <!-- Row 4 -->
        <div>
          <label style="color: #ffffff;">Email</label><br>
          <input type="email" name="email" placeholder="Enter your email address" required>
        </div>

        <div>
          <label style="color: #ffffff;">Password</label><br>
          <input type="password" name="password" placeholder="Create a password" required>
        </div>

        <!-- Skills -->
        <div>
          <label style="color: #ffffff;"><h3>Skills (Select all that apply)</h3></label><br>

          <input type="checkbox" name="skills" value="Java"> <span style="color: #ffffff;">Java</span>
          <input type="checkbox" name="skills" value="Python"> <span style="color: #ffffff;">Python</span>
          <input type="checkbox" name="skills" value="C / C++"> <span style="color: #ffffff;">C / C++</span>
          <input type="checkbox" name="skills" value="Web Development"> <span style="color: #ffffff;">Web Development</span>
          <input type="checkbox" name="skills" value="DBMS"> <span style="color: #ffffff;">DBMS</span>
          <input type="checkbox" name="skills" value="Data Structures"> <span style="color: #ffffff;">Data Structures</span>
          <input type="checkbox" name="skills" value="Machine Learning"> <span style="color: #ffffff;">Machine Learning</span>

          <input type="text" name="other_skill" placeholder="Other skill">
        </div>

        <!-- Resume -->
        <div>
          <label style="color: #ffffff;"><h3>Upload Resume</h3></label>
          <input type="file" name="resume">
        </div>

        <!-- Photo -->
        <div>
          <label style="color: #ffffff;"><h3>Upload Photo</h3></label>
          <input type="file" name="photo">
        </div>

        <!-- Submit -->
        <div>
          <button type="submit">Register</button>
        </div>

        <!-- Terms -->
        <div class="terms">
          <!-- changed html → jsp (if you convert it) -->
          <a href="StudentTerms.jsp">Terms & Conditions and Privacy Policy</a>
        </div>

        <!-- ERROR MESSAGE -->
        <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if(errorMessage != null){
        %>
        <p style="color: red; margin-top: 10px;"><%= errorMessage %></p>
        <%
        }
        %>

      </form>

    </div>

  </div>

<!-- JavaScript part -->
  <script>
    // Optionally keep validation here if needed, but removed preventDefault for actual submission.
  </script>
  
</body>
</html>