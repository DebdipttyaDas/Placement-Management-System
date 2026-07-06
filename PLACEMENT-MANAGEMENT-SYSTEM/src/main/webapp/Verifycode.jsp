<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Verify Code</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="Login.css">
<link rel="stylesheet" href="Forgetpassword.css">
<link rel="stylesheet" href="Verifycode.css">

<!-- JS -->
<script src="Verifycode.js" defer></script>

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

<h1 class="text-3xl font-bold text-[#000208] mb-2">Enter Verification Code</h1>

<p class="text-[#000208] text-sm mb-6">
<b>We sent a 6-digit code to your email.</b>
</p>

<!-- Card -->
<div class="glass-card w-full max-w-[420px] p-6 rounded-2xl mx-auto">

<form action="VerifyCodeServlet" method="post" id="verifyForm">

<p class="text-white text-xs text-left mb-4 opacity-80">
  Enter the 6-digit verification code we emailed you. It expires in 10 minutes.
</p>

<!-- Code -->
<div class="text-left mb-3">
  <label class="text-xs text-white">VERIFICATION CODE</label>
  <input id="codeInput" name="code" type="text" maxlength="6" inputmode="numeric" style="color: white;"
    placeholder="Enter 6-digit code"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-white placeholder-white-400 focus:outline-none focus:ring-2 focus:ring-white-400">
</div>

<!-- Button -->
<button type="submit"
  class="w-full mt-3 py-2 rounded-lg bg-white text-[#063831] font-bold hover:scale-105 hover:bg-[#e0fce2] transition duration-200">
  Verify Code
</button>

</form>

<!-- Footer -->
<div class="mt-4 text-xs text-white">
  <span>Didn't get a code?</span>
  <a href="Forgetpassword.jsp" class="text-white hover:underline">
    Try again
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
