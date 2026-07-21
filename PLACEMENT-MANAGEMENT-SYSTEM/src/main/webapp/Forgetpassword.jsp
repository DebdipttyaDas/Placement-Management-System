<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="Login.css">
<link rel="stylesheet" href="Forgetpassword.css">

<!-- JS -->
<script src="Forgetpassword.js" defer></script>

</head>

<%
HttpSession sess = request.getSession(false);
String loggedInUser = (sess != null) ? (String) sess.getAttribute("user") : null;
String loggedInRole = (sess != null) ? (String) sess.getAttribute("role") : null;
String registeredEmail = null;
if (loggedInUser != null && loggedInRole != null) {
    String query = "";
    if ("student".equals(loggedInRole)) {
        query = "SELECT email FROM STUDENT WHERE email = ?";
    } else if ("company".equals(loggedInRole)) {
        query = "SELECT c.companyEmail AS email FROM COMPANY_CONTACT_DETAILS c JOIN BASIC_DETAILS b ON c.COMPANY_ID = b.COMPANY_ID WHERE b.companyCode = ?";
    } else if ("admin".equals(loggedInRole)) {
        query = "SELECT email FROM ADMIN_PROFILE WHERE userName = ?";
    }
    
    if (!query.isEmpty()) {
        try {
            Class<?> dbUtilClass = Class.forName("DBUtil");
            try (Connection conn = (Connection) dbUtilClass.getMethod("getConnection").invoke(null);
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, loggedInUser);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        registeredEmail = rs.getString("email");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("JSP database error: " + e.getMessage());
        }
    }
}
%>
<body class="h-screen flex flex-col relative"
      data-logged-in="<%= (registeredEmail != null) ? "true" : "false" %>"
      data-registered-email="<%= (registeredEmail != null) ? registeredEmail : "" %>">

<div class="min-h-screen bg-[#cefad0]">
<div class="relative z-10 flex flex-col h-full">

<!-- Navbar -->
<header class="flex justify-between items-center px-10 py-4 bg-[#06473e] relative">

  <h1 class="text-3xl font-bold text-[#ffffff] tracking-wide transition duration-300 hover:scale-105 hover:text-[#ffffff]">
    CampusConnect
  </h1>

  <!-- Hamburger Button -->
  <button id="hamburger-btn" class="block md:hidden text-white focus:outline-none text-2xl" aria-label="Toggle Menu">
    &#9776;
  </button>

  <!-- Nav Links -->
  <nav id="nav-menu" class="hidden md:flex space-x-5 text-sm items-center">
    <a href="About.jsp" class="text-[#ffffff] hover:text-[#ffffff]">About</a>
    <a href="Contact.jsp" class="text-[#ffffff] hover:text-[#ffffff]">Contact</a>
    <a href="AdminLogin.jsp" class="bg-[#688783] text-white px-3 py-1 rounded-md hover:bg-[#5a7571]">
      Admin
    </a>
  </nav>

</header>


<!-- Main -->
<main class="flex-1 flex justify-center items-center px-4 py-6">
<div class="text-center">

<h1 class="text-3xl font-bold text-[#000208] mb-2">Forgot Password?</h1>

<p class="text-[#000208] text-sm mb-6">
<b>No worries, we'll help you get back in.</b>
</p>

<!-- Card -->
<div class="glass-card w-full max-w-[420px] p-4 rounded-2xl mx-auto">

<!-- FORM START -->
<form action="Forgetpasswordservlet" method="post" id="forgotForm">
<br>
<p class="text-white text-xs text-left mb-3 opacity-80">
 Enter the email address associated with your account and we'll send you a verification code to reset your password.
 </p>
<!-- Email -->
<div class="text-left mb-3">
  <label class="text-xs text-white">EMAIL</label>

  <input id="emailInput" name="email" type="text" style="color: white;"
    placeholder="Enter your email"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
</div>

<!-- Button -->
<button type="submit"
  class="w-full mt-3 py-2 rounded-lg bg-white text-[#063831] font-bold hover:scale-105 hover:bg-[#e0fce2] transition duration-200">
  Send Reset code
</button>

</form>
<!-- FORM END -->

<!-- Footer -->
<div class="mt-3 text-xs text-white">
  <span>Remembered your password?</span>
  <a href="Login.jsp" class="text-white hover:underline">
    Back to Login
  </a>
</div>

<!-- ERROR MESSAGE -->
<%
String error = (String) request.getAttribute("error");
if(error != null){
%>
<p class="text-red-300 mt-2"><%= error %></p>
<%
}
%>

<!-- SUCCESS MESSAGE -->
<%
String successMessage = (String) request.getAttribute("successMessage");
if(successMessage != null){
%>
<p class="text-green-300 mt-2"><%= successMessage %></p>
<%
}
%>

</div>
</div>
</main>

</div>
</div>

</body>
</html>
