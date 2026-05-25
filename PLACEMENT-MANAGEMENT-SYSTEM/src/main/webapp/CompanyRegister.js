document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    if (!form) {
        console.error("Form not found");
        return;
    }

    form.addEventListener("submit", function (event) {
        var companyNameField = document.querySelector('input[name="companyName"]');
        var industryField = document.querySelector('input[name="industry"]');
        var companyTypeField = document.querySelector('input[name="companyType"]');
        var emailField = document.querySelector('input[name="email"]');
        var passwordField = document.querySelector('input[name="password"]');

        var companyName = companyNameField ? companyNameField.value.trim() : "";
        var industry = industryField ? industryField.value.trim() : "";
        var companyType = companyTypeField ? companyTypeField.value.trim() : "";
        var email = emailField ? emailField.value.trim() : "";
        var password = passwordField ? passwordField.value.trim() : "";

        // 1. Validate Company Name
        if (!companyName) {
            alert("Please enter a company name.");
            event.preventDefault();
            return;
        }

        // 2. Validate Industry
        if (!industry) {
            alert("Please enter the industry.");
            event.preventDefault();
            return;
        }

        // 3. Validate Company Type
        if (!companyType) {
            alert("Please enter the company type.");
            event.preventDefault();
            return;
        }

        // 4. Validate Email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert("Please enter a valid email address.");
            event.preventDefault();
            return;
        }

        // 5. Validate Password strength
        if (password.length < 6) {
            alert("Password must be at least 6 characters long.");
            event.preventDefault();
            return;
        }

        if (!/[A-Z]/.test(password)) {
            alert("Password must contain at least one uppercase letter.");
            event.preventDefault();
            return;
        }

        if (!/[a-z]/.test(password)) {
            alert("Password must contain at least one lowercase letter.");
            event.preventDefault();
            return;
        }

        if (!/[0-9]/.test(password)) {
            alert("Password must contain at least one number.");
            event.preventDefault();
            return;
        }

    });
});
