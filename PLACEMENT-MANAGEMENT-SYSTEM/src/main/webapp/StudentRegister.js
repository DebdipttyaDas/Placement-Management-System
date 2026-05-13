document.addEventListener("DOMContentLoaded", function () {

    const form = document.querySelector("form");

    form.addEventListener("submit", function (event) {

        // Get field values
        const cgpa = document.querySelector('input[name="cgpa"]').value.trim();
        const email = document.querySelector('input[name="email"]').value.trim();
        const password = document.querySelector('input[name="password"]').value.trim();

        const resume = document.querySelector('input[name="resume"]').files[0];
        const photo = document.querySelector('input[name="photo"]').files[0];

        // 1. Validate CGPA/Percentage
        if (isNaN(cgpa) || Number(cgpa) < 0 || Number(cgpa) > 100) {

            alert("Please enter a valid CGPA or Percentage (0 - 100).");
            event.preventDefault();
            return;

        }

        // 2. Validate Email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailRegex.test(email)) {

            alert("Please enter a valid email address.");
            event.preventDefault();
            return;

        }

        // 3. Validate Password
        if (password.length < 6) {

            alert("Password must be at least 6 characters long.");
            event.preventDefault();
            return;

        }

        // 4. Validate Resume File
        if (resume) {

            const allowedResumeExtensions = ["pdf"];
            const fileExtension = resume.name.split('.').pop().toLowerCase();

            // File Type Check
            if (!allowedResumeExtensions.includes(fileExtension)) {

                alert("Resume must be a PDF file.");
                event.preventDefault();
                return;

            }

            // File Size Check (800KB)
            if (resume.size > 800 * 1024) {

                alert("Resume size must be less than 800KB.");
                event.preventDefault();
                return;

            }

        }

        // 5. Validate Photo File
        if (photo) {

            const allowedPhotoExtensions = ["jpg"];
            const fileExtension = photo.name.split('.').pop().toLowerCase();

            // File Type Check
            if (!allowedPhotoExtensions.includes(fileExtension)) {

                alert("Photo must be a JPG file.");
                event.preventDefault();
                return;

            }

            // File Size Check (500KB)
            if (photo.size > 500 * 1024) {

                alert("Photo size must be less than 500KB.");
                event.preventDefault();
                return;

            }

        }

        // If all validations pass, form submits normally

    });

});