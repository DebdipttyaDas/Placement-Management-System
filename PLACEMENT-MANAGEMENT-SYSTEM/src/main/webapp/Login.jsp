<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Login</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="Login.css">

<!-- JS -->
<script src="Login.js"></script>

</head>

<body class="h-screen flex flex-col relative">

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

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      const hamburger = document.getElementById('hamburger-btn');
      const navMenu = document.getElementById('nav-menu');
      if (hamburger && navMenu) {
        hamburger.addEventListener('click', function(e) {
          e.stopPropagation();
          if (navMenu.classList.contains('hidden')) {
            navMenu.classList.remove('hidden');
            navMenu.classList.add('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
          } else {
            navMenu.classList.add('hidden');
            navMenu.classList.remove('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
          }
        });
        document.addEventListener('click', function(e) {
          if (!navMenu.classList.contains('hidden') && !navMenu.contains(e.target) && !hamburger.contains(e.target)) {
            navMenu.classList.add('hidden');
            navMenu.classList.remove('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
          }
        });
      }
    });
  </script>

</header>


<!-- Main -->
<main class="flex-1 flex justify-center items-center px-4 py-6">
<div class="text-center">

<h1 class="text-3xl font-bold text-[#000208] mb-2">Welcome Back !</h1>

<p class="text-[#000208] text-sm mb-6">
<b>Unlock Your Potential, Where Dreams Meet Their Destination.</b>
</p>

<!-- Card -->
<div class="glass-card w-full max-w-[420px] p-6 rounded-2xl mx-auto">
<!-- FORM START -->
<form action="LoginServlet" method="post">

<!-- Hidden Role -->
<input type="hidden" id="role" name="role" value="student">

<!-- Tabs -->
<div class="flex justify-around border-b border-white/20 mb-4 text-sm">
  <button type="button" id="tabStudent" onclick="showStudent()"
    class="tab-btn tab-active font-bold transition-all duration-200">
    Student
  </button>
  <button type="button" id="tabCompany" onclick="showCompany()"
    class="tab-btn tab-inactive font-bold transition-all duration-200">
    Company
  </button>
</div>

<!-- Username -->
<div class="text-left mb-3">
  <label id="userLabel" class="text-xs text-white">EMAIL</label>

  <input id="userInput" name="email" type="text" style="color: white;"
    placeholder="Enter your email"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
</div>


<!-- Company Form -->
<div id="companyForm" style="display:none;">

  <div class="text-left mb-3">
    <label class="text-xs text-white">COMPANY CODE</label>
    <input type="text"  style="color: white;" name="companyCode"
      placeholder="Enter company code"
      class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
  </div>

</div>

<!-- Password -->
<div class="text-left mb-3">
  <div class="flex justify-between text-xs text-white">
    <label>PASSWORD</label>
    <a href="#" class="text-white hover:underline">Forgot?</a>
  </div>

  <input type="password" name="password"
    placeholder="Enter your password" style="color: white;"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">

</div>

<!-- Button -->
<button type="submit"
  class="w-full mt-3 py-2 rounded-lg bg-white text-[#063831] font-bold hover:scale-105 hover:bg-[#e0fce2] transition duration-200">
  Access Portal
</button>

</form>
<!-- FORM END -->

<!-- Footer -->
<div class="mt-3 text-xs text-white">
  <span id="footerText">New student?</span>
  <a id="footerLink" href="StudentRegister.jsp" class="text-white hover:underline">
    Create new Account
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

<script>
window.onload = function() {
    var roleParam = new URLSearchParams(window.location.search).get("role");
    if (roleParam === 'admin') {
        showAdmin();
    } else if (roleParam === 'company') {
        showCompany();
    } else {
        showStudent();
    }
}
</script>
</div>
</div>
</div>
</div>
</body>
</html>
