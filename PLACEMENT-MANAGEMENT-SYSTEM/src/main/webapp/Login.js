function showStudent() {

  // Show student input
  document.getElementById("userInput").style.display = "block";

  // Hide company section
  document.getElementById("companyForm").style.display = "none";

  // Update text
  document.getElementById("userLabel").innerText = "USERNAME OR EMAIL";
  document.getElementById("userInput").placeholder = "Enter your username or email";

  document.getElementById("footerText").innerText = "New student?";
  document.getElementById("footerLink").style.display = "inline";
  document.getElementById("footerLink").href = "StudentRegister.jsp";
  document.getElementById("footerLink").innerText = "Create new Account";

  // Set role
  document.getElementById("role").value = "student";
}


function showCompany() {

  // Hide student input
  document.getElementById("userInput").style.display = "none";

  // Show company section
  document.getElementById("companyForm").style.display = "block";

  // Update footer
  document.getElementById("footerText").innerText = "New company?";
  document.getElementById("footerLink").style.display = "inline";
  document.getElementById("footerLink").href = "CompanyRegister.jsp";
  document.getElementById("footerLink").innerText = "Create new Account";

  // Set role
  document.getElementById("role").value = "company";
}

function showAdmin() {
  // Show student input (used for username here)
  document.getElementById("userInput").style.display = "block";

  // Hide company section
  document.getElementById("companyForm").style.display = "none";

  // Update text
  document.getElementById("userLabel").innerText = "ADMIN USERNAME";
  document.getElementById("userInput").placeholder = "Enter admin username";

  document.getElementById("footerText").innerText = "";
  document.getElementById("footerLink").style.display = "none";

  // Set role
  document.getElementById("role").value = "admin";
}