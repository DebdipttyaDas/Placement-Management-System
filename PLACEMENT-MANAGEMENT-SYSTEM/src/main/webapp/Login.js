function showStudent() {
  document.getElementById("userLabel").innerText = "USERNAME OR EMAIL";
  document.getElementById("userInput").placeholder = "Enter your username or email";

  document.getElementById("footerText").innerText = "New student?";
  document.getElementById("footerLink").href = "StudentRegister.jsp";

  document.getElementById("role").value = "student"; // IMPORTANT
}

function showCompany() {
  document.getElementById("userLabel").innerText = "COMPANY CODE";
  document.getElementById("userInput").placeholder = "Enter company code";

  document.getElementById("footerText").innerText = "New company?";
  document.getElementById("footerLink").href = "CompanyRegister.jsp";

  document.getElementById("role").value = "company"; // IMPORTANT
}