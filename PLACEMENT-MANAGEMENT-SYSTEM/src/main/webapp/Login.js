function showStudent() {
  document.getElementById("userLabel").innerText = "USERNAME OR EMAIL";
  document.getElementById("userInput").placeholder = "Enter your username or email";

  document.getElementById("footerText").innerText = "New student?";
  document.getElementById("footerLink").innerText = "Create new Account";
  document.getElementById("footerLink").href = "StudentRegister.html";
}

function showCompany() {
  document.getElementById("userLabel").innerText = "COMPANY CODE";
  document.getElementById("userInput").placeholder = "Enter company code";

  document.getElementById("footerText").innerText = "New company?";
  document.getElementById("footerLink").innerText = "Create new Account";
  document.getElementById("footerLink").href = "CompanyRegister.html";
}
