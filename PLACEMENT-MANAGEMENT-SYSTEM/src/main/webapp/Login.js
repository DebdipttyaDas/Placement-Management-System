// ================= STUDENT =================
function showStudent() {

  // Show student input
  document.getElementById("userInput").style.display = "block";
  document.getElementById("userLabel").style.display = "block";

  // Hide company section
  document.getElementById("companyForm").style.display = "none";

  // Labels + placeholders
  document.getElementById("userLabel").innerText = "USERNAME OR EMAIL";
  document.getElementById("userInput").placeholder = "Enter your username or email";

  // ✅ Reset password placeholder
  document.querySelector('input[name="password"]').placeholder = "Enter your password";

  // Footer
  document.getElementById("footerText").innerText = "New student?";
  document.getElementById("footerLink").style.display = "inline";
  document.getElementById("footerLink").href = "StudentRegister.jsp";
  document.getElementById("footerLink").innerText = "Create new Account";

  // Role
  document.getElementById("role").value = "student";
}


// ================= COMPANY =================
function showCompany() {

  // Hide student email input
  document.getElementById("userInput").style.display = "none";
  document.getElementById("userLabel").style.display = "none";

  // Show company section
  document.getElementById("companyForm").style.display = "block";

  // ✅ Use same password field (no duplicate)
  document.querySelector('input[name="password"]').placeholder = "Enter company password";

  // Footer
  document.getElementById("footerText").innerText = "New company?";
  document.getElementById("footerLink").style.display = "inline";
  document.getElementById("footerLink").href = "CompanyRegister.jsp";
  document.getElementById("footerLink").innerText = "Create new Account";

  // Role
  document.getElementById("role").value = "company";
}


// ================= ADMIN =================
function showAdmin() {

  // Show username input
  document.getElementById("userInput").style.display = "block";
  document.getElementById("userLabel").style.display = "block";

  // Hide company section
  document.getElementById("companyForm").style.display = "none";

  // Labels + placeholders
  document.getElementById("userLabel").innerText = "ADMIN USERNAME";
  document.getElementById("userInput").placeholder = "Enter admin username";

  // ✅ Reset password placeholder
  document.querySelector('input[name="password"]').placeholder = "Enter admin password";

  // Hide footer
  document.getElementById("footerText").innerText = "";
  document.getElementById("footerLink").style.display = "none";

  // Role
  document.getElementById("role").value = "admin";
}


// ================= FORM VALIDATION =================
document.addEventListener("DOMContentLoaded", function () {

  const form = document.querySelector("form");

  form.addEventListener("submit", function (e) {

    const role = document.getElementById("role").value;
    const userInput = document.getElementById("userInput").value.trim();
    const password = document.querySelector('input[name="password"]').value.trim();
    const companyCode = document.querySelector('input[name="companyCode"]');

    // ===== STUDENT & ADMIN =====
    if (role === "student" || role === "admin") {
      if (userInput === "" || password === "") {
        alert("Please fill all fields");
        e.preventDefault();
        return;
      }

      // Email validation for student
      if (role === "student") {
        const emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
        if (!emailPattern.test(userInput)) {
          alert("Enter valid email");
          e.preventDefault();
          return;
        }
      }
    }

    // ===== COMPANY =====
    if (role === "company") {
      const code = companyCode.value.trim();

      if (code === "" || password === "") {
        alert("Enter company code and password");
        e.preventDefault();
        return;
      }
    }

    // ===== PASSWORD LENGTH =====
    if (password.length < 4) {
      alert("Password must be at least 4 characters");
      e.preventDefault();
    }

  });

});
