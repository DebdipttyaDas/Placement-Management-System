// ================= RESET PASSWORD FORM VALIDATION =================
document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("resetForm");
  const newPassword = document.getElementById("newPassword");
  const confirmPassword = document.getElementById("confirmPassword");

  if (form && newPassword && confirmPassword) {
    form.addEventListener("submit", function (e) {
      const pw = newPassword.value;
      const confirm = confirmPassword.value;

      if (pw.length < 6) {
        alert("Password must be at least 6 characters.");
        e.preventDefault();
        return;
      }

      if (pw !== confirm) {
        alert("Passwords do not match.");
        e.preventDefault();
      }
    });
  }

  // Server-side failure (e.g. DB update failed) is signaled via a data
  // attribute on <body>, set by ResetPassword.jsp based on the servlet's
  // "showAlert" request attribute.
  if (document.body.dataset.showErrorAlert === "true") {
    alert("Failed to update password. Please try again.");
  }

  // Server-side success is signaled the same way. Show the popup, then
  // send the user to the login page.
  if (document.body.dataset.showSuccessAlert === "true") {
    alert("Password updated successfully! Please log in.");
    window.location.href = "Login.jsp";
  }
});
