// ================= VERIFY CODE FORM VALIDATION =================
document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("verifyForm");
  const codeInput = document.getElementById("codeInput");

  if (form && codeInput) {

    // Only allow digits to be typed, and cap at 6 characters
    codeInput.addEventListener("input", function () {
      codeInput.value = codeInput.value.replace(/[^0-9]/g, "").slice(0, 6);
    });

    form.addEventListener("submit", function (e) {
      const code = codeInput.value.trim();
      const codePattern = /^[0-9]{6}$/;

      if (code === "") {
        alert("Please enter the verification code");
        e.preventDefault();
        return;
      }

      if (!codePattern.test(code)) {
        alert("Enter the full 6-digit code");
        e.preventDefault();
      }
    });
  }
});
