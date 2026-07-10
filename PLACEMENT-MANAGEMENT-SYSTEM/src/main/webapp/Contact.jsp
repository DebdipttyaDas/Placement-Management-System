<%@ page language="java" contentType="text/html; charset=UTF-8" %>

  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
    <link rel="stylesheet" href="Contact.css">
  </head>

  <body>
    <!-- HEADER -->
    <header>
      <h1>Contact us - CampusConnect</h1>
       <center>
                <a href="Login.jsp" style="color: white; text-decoration: none;">Back to Home</a>
            </center>
    </header>

    <p style="text-align:center;">We are here to help you, feel free to reach out !</p>

    <hr>

    <!-- SUCCESS/ERROR MESSAGE -->
    <%
      String msg = (String) request.getAttribute("message");
      if (msg != null) {
          String color = msg.contains("successfully") ? "green" : "red";
    %>
      <p style="color: <%= color %>; text-align: center; font-weight: bold; margin-top: 10px;"><%= msg %></p>
    <%
      }
    %>

    <!-- CONTACT INFO -->
    <h2>Contact Information</h2>

    <p><strong>Email:</strong> support@campusconnect.com</p>
    <p><strong>Phone:</strong> +91 98765 43210</p>
    <p><strong>Location:</strong> Kolkata, West Bengal, India</p>

    <hr>

    <!-- COMPANY INFO -->
    <h3>Company Info</h3>
    <p style="text-align:center;">
      We connect students, companies, and administrators for better opportunities.
    </p>

    <br>

    <!-- FOOTER -->
    <footer>
      Developed by Team CampusConnect <br>
      © 2026 All Rights Reserved
    </footer>
    <script src="Contact.js"></script>



  </body>

  </html>