document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    form.addEventListener("submit", function (event) {
        // Get field values
        const phone = document.querySelector('input[name="phone"]').value.trim();
        const email = document.querySelector('input[name="email"]').value.trim();
        const password = document.querySelector('input[name="password"]').value.trim();

        // 1. Validate Phone Number (must be exactly 10 digits)
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(phone)) {
            alert("Please enter a valid 10-digit phone number.");
            event.preventDefault(); // Stop form submission
            return;
        }

        // 2. Validate Email format
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

    });
});