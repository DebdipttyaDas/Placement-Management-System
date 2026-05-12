document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    form.addEventListener("submit", function (event) {
        // Get field values
        const cgpa = document.querySelector('input[name="cgpa"]').value.trim();
        const email = document.querySelector('input[name="email"]').value.trim();
        const password = document.querySelector('input[name="password"]').value.trim();
        const resume = document.querySelector('input[name="resume"]').files[0];
        const photo = document.querySelector('input[name="photo"]').files[0];

        // 1. Validate CGPA/Percentage (Must be a valid number)
        if (isNaN(cgpa) || Number(cgpa) < 0 || Number(cgpa) > 100) {
            alert("Please enter a valid CGPA or Percentage (0 - 100).");
            event.preventDefault(); // Stop form submission
            return;
        }

        // 2. Validate Email Format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert("Please enter a valid email address.");
            event.preventDefault(); // Stop form submission
            return;
        }

        // 3. Validate Password Length (minimum 6 characters)
        if (password.length < 6) {
            alert("Password must be at least 6 characters long.");
            event.preventDefault(); // Stop form submission
            return;
        }

        // 4. Validate File Upload Types (Optional but good practice)
        if (resume) {
            const allowedResumeExtensions = ["pdf", "doc", "docx"];
            const fileExtension = resume.name.split('.').pop().toLowerCase();
            if (!allowedResumeExtensions.includes(fileExtension)) {
                alert("Resume must be a PDF, DOC, or DOCX file.");
                event.preventDefault();
                return;
            }
        }

        if (photo) {
            const allowedPhotoExtensions = ["jpg"];
            const fileExtension = photo.name.split('.').pop().toLowerCase();
            if (!allowedPhotoExtensions.includes(fileExtension)) {
                alert("Photo must be a JPG file.");
                event.preventDefault();
                return;
            }
        }

        // Note: HTML5 'required' attributes on other fields ensure they are not empty.
        // If all custom validations pass, the form will submit normally to the Servlet.
    });
});
