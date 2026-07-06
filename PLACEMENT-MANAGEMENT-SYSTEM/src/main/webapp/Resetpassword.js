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
});
