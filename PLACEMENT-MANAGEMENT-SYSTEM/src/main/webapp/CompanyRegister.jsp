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
            <h2>CampusConnect</h2>
            <nav>
                <p>Already have an account?
                    <a href="Login.jsp" style="color: white;">Login</a>
                </p>
            </nav>
        </header>

        <!-- Register Section -->
        <center>

            <h1>Create Your Company Account</h1>
            <h4>Register your company to access placement services</h4>

            <!-- FORM -->
            <form action="CompanyRegisterServlet" method="post">

                <!-- Company Name -->
                <label>Company Name</label><br>
                <input type="text" name="companyName" placeholder="Enter company name" required><br><br>

                <!-- Company Code -->
                <label>Company Code (for login)</label><br>
                <input type="text" name="companyCode" placeholder="Enter a unique company code" required><br><br>

                <!-- Industry -->
                <label>Industry</label><br>
                <input type="text" name="industry" placeholder="Enter industry" required><br><br>

                <!-- Company Type -->
                <label>Company Type</label><br>
                <input type="text" name="companyType" placeholder="e.g. IT, Startup, MNC" required><br><br>

                <!-- Company Email -->
                <label>Company Email</label><br>
                <input type="email" name="email" placeholder="Enter company email" required><br><br>

                <!-- Phone Number -->
                <label>Phone Number</label><br>
                <input type="text" name="phone" placeholder="Enter phone number" required><br><br>

                <!-- Password -->
                <label>Password</label><br>
                <input type="password" name="password" placeholder="Create a password" required><br><br>

                <!-- Button -->
                <button type="submit">Register</button>

                <!-- Terms -->
                <div class="terms">
                    <a href="CompanyTerms.jsp">Terms & Conditions and Privacy Policy</a>
                </div>

            </form>

            <!-- JS -->
            <script>
                // Validation logic can go here if needed. Removed preventDefault.
            </script>

        </center>

    </body>

    </html>