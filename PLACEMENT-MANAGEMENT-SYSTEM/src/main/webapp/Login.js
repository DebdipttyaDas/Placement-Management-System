function showStudent() {

  // Show student input
  document.getElementById("userInput").style.display = "block";

  // Hide company section
  document.getElementById("companyForm").style.display = "none";

  // Update text
  document.getElementById("userLabel").innerText = "USERNAME OR EMAIL";
  document.getElementById("userInput").placeholder = "Enter your username or email";

  document.getElementById("footerText").innerText = "New student?";
  document.getElementById("footerLink").href = "StudentRegister.jsp";

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
  document.getElementById("footerLink").href = "CompanyRegister.jsp";

  // Set role
  document.getElementById("role").value = "company";
}