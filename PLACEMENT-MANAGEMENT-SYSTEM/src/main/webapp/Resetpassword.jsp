<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="Login.css">
<link rel="stylesheet" href="Forgetpassword.css">
<link rel="stylesheet" href="Resetpassword.css">

<!-- JS -->
<script src="Resetpassword.js" defer></script>

</head>

<body class="h-screen flex flex-col relative">

<div class="min-h-screen bg-[#cefad0]">
<div class="relative z-10 flex flex-col h-full">

<!-- Navbar -->
<header class="flex justify-between items-center px-10 py-4 bg-[#06473e] relative">
  <h1 class="text-3xl font-bold text-[#ffffff] tracking-wide">CampusConnect</h1>
</header>

<!-- Main -->
<main class="flex-1 flex justify-center items-center px-4 py-6">
<div class="text-center">

<h1 class="text-3xl font-bold text-[#000208] mb-2">Reset Your Password</h1>

<p class="text-[#000208] text-sm mb-6">
<b>Choose a new password for your account.</b>
</p>

<!-- Card -->
<div class="glass-card w-full max-w-[420px] p-6 rounded-2xl mx-auto">

<form action="Resetpasswordservlet" method="post" id="resetForm">

<!-- New Password -->
<div class="text-left mb-3">
  <label class="text-xs text-white">NEW PASSWORD</label>
  <input id="newPassword" name="newPassword" type="password" style="color: white;"
    placeholder="Enter new password"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
</div>

<!-- Confirm Password -->
<div class="text-left mb-3">
  <label class="text-xs text-white">CONFIRM PASSWORD</label>
  <input id="confirmPassword" name="confirmPassword" type="password" style="color: white;"
    placeholder="Confirm new password"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
</div>

<!-- Button -->
<button type="submit"
  class="w-full mt-3 py-2 rounded-lg bg-white text-[#063831] font-bold hover:scale-105 hover:bg-[#e0fce2] transition duration-200">
  Update Password
</button>

</form>

<!-- ERROR MESSAGE -->
<%
String error = (String) request.getAttribute("error");
if(error != null){
%>
<p class="text-red-300 mt-2"><%= error %></p>
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
