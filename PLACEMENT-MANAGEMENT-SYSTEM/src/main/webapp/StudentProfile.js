document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("profileForm");
    const photoInput = document.querySelector('input[name="photo"]');
    const avatarBox = document.querySelector('.avatar-box');

    // ==========================================
    // 1. INSTANT IMAGE PREVIEW
    // ==========================================
    if (photoInput && avatarBox) {
        photoInput.addEventListener("change", function () {
            const file = this.files[0];
            if (file) {
                // Validate file type
                const allowedTypes = ["image/jpeg", "image/jpg", "image/png"];
                if (!allowedTypes.includes(file.type)) {
                    alert("Please upload a valid image (JPG, JPEG, PNG).");
                    this.value = ""; // Clear the input so invalid file isn't uploaded
                    return;
                }

                // Check file size (max 2MB)
                if (file.size > 6 * 1024) {
                    alert("Uploaded image must be smaller than 500KB.");
                    this.value = "";
                    return;
                }

                // Render the image directly onto the page
                const reader = new FileReader();
                reader.onload = function (e) {
                    avatarBox.innerHTML = `<img src="${e.target.result}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
                };
                reader.readAsDataURL(file);
            }
        });
    }

    // ==========================================
    // 2. FORM VALIDATION
    // ==========================================
    if (form) {
        form.addEventListener("submit", function (event) {
            const password = document.querySelector('input[name="password"]').value.trim();
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value.trim();
            const cgpa = document.querySelector('input[name="cgpa"]').value.trim();

            // Password Validation (only if user tries to update their password)
            if (password !== "" || confirmPassword !== "") {
                if (password.length < 6) {
                    alert("New password must be at least 6 characters long.");
                    event.preventDefault();
                    return;
                }
                if (password !== confirmPassword) {
                    alert("Passwords do not match! Please make sure both password fields are identical.");
                    event.preventDefault();
                    return;
                }
            }

            // CGPA Validation (if user fills it out)
            if (cgpa !== "") {
                if (isNaN(cgpa) || Number(cgpa) < 0 || Number(cgpa) > 100) {
                    alert("Please enter a valid CGPA or Percentage (0 - 100).");
                    event.preventDefault();
                    return;
                }
            }
            
            // If the script reaches here, all custom checks passed!
            // Form will submit naturally to the server.
        });
    }
});