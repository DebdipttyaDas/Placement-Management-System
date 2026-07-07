// ================= NAVBAR HAMBURGER =================
document.addEventListener("DOMContentLoaded", function () {
  const hamburger = document.getElementById('hamburger-btn');
  const navMenu = document.getElementById('nav-menu');

  if (hamburger && navMenu) {
    hamburger.addEventListener('click', function (e) {
      e.stopPropagation();
      if (navMenu.classList.contains('hidden')) {
        navMenu.classList.remove('hidden');
        navMenu.classList.add('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
      } else {
        navMenu.classList.add('hidden');
        navMenu.classList.remove('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
      }
    });

    document.addEventListener('click', function (e) {
      if (!navMenu.classList.contains('hidden') && !navMenu.contains(e.target) && !hamburger.contains(e.target)) {
        navMenu.classList.add('hidden');
        navMenu.classList.remove('flex', 'flex-col', 'absolute', 'top-full', 'left-0', 'right-0', 'bg-[#06473e]', 'p-5', 'z-50', 'space-y-4', 'space-x-0', 'items-start', 'border-t', 'border-[#0a5e53]');
      }
    });
  }

  // ================= FORM VALIDATION =================
  const form = document.getElementById("forgotForm");
  const emailInput = document.getElementById("emailInput");

  if (form && emailInput) {
    form.addEventListener("submit", function (e) {
      const email = emailInput.value.trim();
      const emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;

      if (email === "") {
        alert("Please enter your email address");
        e.preventDefault();
        return;
      }

      if (!emailPattern.test(email)) {
        alert("Enter a valid email address");
        e.preventDefault();
        return;
      }

      // Check if logged in and if entered email matches registered email
      const isLoggedIn = document.body.dataset.loggedIn === "true";
      if (isLoggedIn) {
        const registeredEmail = document.body.dataset.registeredEmail;
        if (email.toLowerCase() !== registeredEmail.toLowerCase()) {
          alert("The entered email does not match your registered email.");
          e.preventDefault();
        }
      }
    });
  }
});
