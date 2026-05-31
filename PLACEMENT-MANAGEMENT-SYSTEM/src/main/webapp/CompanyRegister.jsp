<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Company Register</title>
    <link rel="stylesheet" href="CompanyRegister.css">
</head>

<body>

    <!-- Navbar -->
    <header>
        <h2 class="logo">CampusConnect</h2>
        <nav>
            <p>Already have an account?
                <a href="Login.jsp" style="color: white;">Login</a>
            </p>
        </nav>
    </header>

    <!-- Register Section -->
    <center>

        <h1>Create Your Company Account</h1>
        <h4>Register your company to access our placement services</h4>

        <!-- FORM -->
        <form action="CompanyRegisterServlet" method="post" class="company-form">

            <div class="form-grid">

                <!-- Row 1: Company Name + Industry -->
                <div class="input-group">
                    <label>Company Name</label>
                    <input type="text" name="companyName" placeholder="Enter company name" required>
                </div>

                <div class="input-group">
                    <label>Industry</label>
                    <input type="text" name="industry" placeholder="Enter industry" required>
                </div>

                <!-- Row 2: Company Type + Company Website -->
                <div class="input-group">
                    <label>Company Type</label>
                    <input type="text" name="companyType" placeholder="e.g. IT, Startup, MNC" required>
                </div>

                <div class="input-group">
                    <label>Company Website</label>
                    <input type="url" name="website" placeholder="https://www.example.com" required>
                </div>

                <!-- Row 3: Registration Number + License Number -->
                <div class="input-group">
                    <label>Registration Number</label>
                    <input type="text" name="registrationNumber" placeholder="Enter registration number" required>
                </div>

                <div class="input-group">
                    <label>License Number</label>
                    <input type="text" name="licenseNumber" placeholder="Enter license number" required>
                </div>

                <!-- Row 4: Email + Password -->
                <div class="input-group">
                    <label>Company Email</label>
                    <input type="email" name="email" placeholder="Enter company email" required>
                </div>

                <div class="input-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Create a password" required>
                </div>

                <!-- Address: centered below spanning both columns -->
                <div class="input-group address-group">
                    <label>Company Address</label>
                    <textarea name="address" placeholder="Enter company address" rows="3" required></textarea>
                </div>

            </div>

            <button type="submit">Request for Registration</button>

            <div class="terms">
                <a href="Terms.jsp">Terms & Conditions and Privacy Policy</a>
            </div>

            <!-- ERROR MESSAGE -->
            <% String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { %>
                <p style="color:red; margin-top:10px;">
                    <%= errorMessage %>
                </p>
            <% } %>

        </form>

    </center>

    <script src="CompanyRegister.js"></script>
</body>

</html>
