<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String role = request.getParameter("role");
if(role == null){
    role = "admin";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Executive Ledger Login</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="style.css">

</head>

<body class="h-screen flex flex-col relative">

<!-- Background -->
<div class="bg-image"></div>

<div class="content z-10 flex flex-col h-full">

<!-- Navbar -->
<header class="flex justify-between items-center px-10 py-4 text-white">
<h1 class="text-3xl font-bold text-white tracking-wide transition duration-300 hover:scale-105 hover:text-sky-300">
  CampusConnect
</h1>

<nav class="space-x-5 text-sm">
  <a href="#" class="text-blue-200 hover:text-sky-400">About</a>
  <a href="#" class="text-blue-200 hover:text-sky-400">Contact</a>
  <a href="#" class="text-blue-200 hover:text-sky-400">Login</a>
  <a href="#" class="bg-blue-600 px-3 py-1 rounded-md hover:bg-blue-700">Sign Up</a>
</nav>
</header>

<!-- Main -->
<main class="flex-1 flex justify-center items-center">
  <div class="text-center">

    <h1 class="text-3xl font-bold text-white mb-2">Welcome Back !</h1>

<p class="text-gray-300 text-sm mb-6">
    <b> Unlock Your Potential,Where Dreams Meet Their Destination.</b>
    </p>

    <!-- Card -->
    <div class="w-90 bg-slate-900/80 backdrop-blur-md text-white p-6 rounded-2xl shadow-2xl border border-white/10">

      <!-- Tabs (JSP Dynamic) -->
      <div class="flex justify-around border-b border-white/20 mb-4 text-sm">

        <a href="login.jsp?role=admin"
        class="<%= role.equals("admin") ? "text-sky-400 border-b-2 border-sky-400 pb-2" : "text-gray-400 hover:text-white pb-2" %>">
        Admin</a>

        <a href="login.jsp?role=student"
        class="<%= role.equals("student") ? "text-sky-400 border-b-2 border-sky-400 pb-2" : "text-gray-400 hover:text-white pb-2" %>">
        Student</a>

        <a href="login.jsp?role=company"
        class="<%= role.equals("company") ? "text-sky-400 border-b-2 border-sky-400 pb-2" : "text-gray-400 hover:text-white pb-2" %>">
        Company</a>

      </div>

      <!-- FORM START -->
      <form action="LoginServlet" method="post">

        <!-- Hidden Role -->
        <input type="hidden" name="role" value="<%= role %>">

        <!-- Username -->
        <div class="text-left mb-3">
          <label class="text-xs text-gray-300">USERNAME OR EMAIL</label>
          <input type="text" name="email"
          placeholder="Enter your username or email"
          
            value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
            class="w-full mt-1 p-2 rounded-md bg-white/10 border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-400">
        </div>

        <!-- Password -->
        <div class="text-left mb-3">
          <div class="flex justify-between text-xs text-gray-300">
            <label>PASSWORD</label>
            <a href="#" class="text-sky-400 hover:underline">Forgot?</a>
          </div>

          <input type="password" name="password"
          placeholder="Enter your password"
            class="w-full mt-1 p-2 rounded-md bg-white/10 border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-400">
            
        </div>

        <!-- Button -->
        <button type="submit"
        class="w-full mt-3 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-sky-400 hover:scale-105 transition">
          Access Portal →
        </button>

      </form>
      <!-- FORM END -->

      <!-- Footer -->
      <div class="mt-3 text-xs text-gray-400">
        New user? <a href="#" class="text-sky-400">Create an Account</a>
      </div>

      <!-- Error Message -->
      <%
      String error = (String) request.getAttribute("error");
      if(error != null){
      %>
        <p class="text-red-400 mt-2"><%= error %></p>
      <%
      }
      %>

    </div>

  </div>
</main>

</div>

</body>
</html>