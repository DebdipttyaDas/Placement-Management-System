<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Executive Ledger Login</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- External CSS -->
<link rel="stylesheet" href="B.css">


</head>

<body class="h-screen flex flex-col relative">

<div class="min-h-screen bg-[#546eac]">
  <div class="relative z-10 flex flex-col h-full">

<!-- Navbar -->
<header class="flex justify-between items-center px-10 py-4 bg-white">
  <h1 class="text-3xl font-bold text-[#0b1f3a] tracking-wide transition duration-300 hover:scale-105 hover:text-[#173a5e]">
    CampusConnect
  </h1>
</header>

  <header class="flex items-center px-10 py-4 bg-[#0b1f3a] text-white">

  <nav class="flex space-x-5 text-sm">
    <a href="#" class="text-blue-200 hover:text-white">About</a>
    <a href="#" class="text-blue-200 hover:text-white">Contact</a>
    <a href="#" class="bg-[#1e40af] px-3 py-1 rounded-md hover:bg-[#1d4ed8]">Admin</a>
  </nav>

</header>

<!-- Main -->
<main class="flex-1 flex justify-center items-center">
  <div class="text-center">

    <h1 class="text-3xl font-bold text-[#ffffff] mb-2">Welcome Back !</h1>
<p class="text-[#ffffff] text-sm mb-6">
  <b>Unlock Your Potential, Where Dreams Meet Their Destination.</b>
</p>


    <!-- Card -->
<div class="w-90 bg-white p-6 rounded-2xl border border-gray-200 shadow-sm">

      <!-- Tabs -->
      <div class="flex justify-around border-b border-gray-200 mb-4 text-sm">
        <button class="text-black-400 hover:text-black-700 pb-2"><b>Student</b></button>
        <button class="text-black-400 hover:text-black-700 pb-2"><b>Company</b></button>
      </div>

      <!-- Username -->
      <div class="text-left mb-3">
        <label class="text-xs text-black-300">USERNAME OR EMAIL</label>
        <input type="text" placeholder="Enter your username or email"
          class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-black placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-400">
      </div>

     
	<!-- Password -->
	<div class="text-left mb-3">
	<div class="flex justify-between text-xs text-black-300">
    	<label>PASSWORD</label>
    	<a href="#" class="text-black-400 hover:underline">Forgot?</a>
  	</div>

  <input 
    type="password"
    placeholder="Enter your password"
    class="w-full mt-1 p-2 rounded-md bg-white/10 border border-black-200 text-black placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-400"
  >

</div>

      <!-- Button -->
<button class="w-full mt-3 py-2 rounded-lg bg-blue-900 text-white hover:scale-105 transition">
  ACCESS PORTAL &#8594;
  †’
</button>

      <!-- Footer -->
      <div class="mt-3 text-xs text-black-400">
        New student? <a href="#" class="text-black-400">Create new Account</a>
      </div>

    </div>
  </div>
</main>

</div>

</body>
</html>
