<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact Us</title>
  <link rel="stylesheet" href="Contact.css">
</head>

<body>

<!-- HEADER -->
<header>
  <h1>Contact us - CampusConnect</h1>
</header>

<p style="text-align:center;">We are here to help you, feel free to reach out !</p>

<hr>

<!-- FORM -->
<h2>Send a Message</h2>

<div class="container">
  <!-- 🔥 Optional: connect to servlet later -->
  <form action="#" method="post">

    <label>Name:</label><br>
    <input type="text" name="name"><br><br>

    <label>Email:</label><br>
    <input type="email" name="email"><br><br>

    <label>Subject:</label><br>
    <input type="text" name="subject"><br><br>

    <label>Message:</label><br>
    <textarea name="message" rows="5" cols="30"></textarea><br><br>

    <button type="submit">Send</button>

  </form>
</div>

<hr>

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

</body>
</html>