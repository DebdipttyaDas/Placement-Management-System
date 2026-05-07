document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    form.addEventListener("submit", function (event) {
        // Get field values
        const name = document.querySelector('input[name="name"]').value.trim();
        const email = document.querySelector('input[name="email"]').value.trim();
        const subject = document.querySelector('input[name="subject"]').value.trim();
        const message = document.querySelector('textarea[name="message"]').value.trim();

        // 1. Check for empty fields
        if (name === "" || email === "" || subject === "" || message === "") {
            alert("Please fill in all fields before sending.");
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

        // 3. Validate Message Length
        if (message.length < 10) {
            alert("Your message must be at least 10 characters long.");
            event.preventDefault(); // Stop form submission
            return;
        }

        // If all validations pass, the form will submit normally to ContactServlet.
    });
});