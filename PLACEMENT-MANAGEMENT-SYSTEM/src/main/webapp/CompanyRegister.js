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
        var websiteField = document.querySelector('input[name="website"]');
        var registrationNumberField = document.querySelector('input[name="registrationNumber"]');
        var licenseNumberField = document.querySelector('input[name="cin"]');
        var emailField = document.querySelector('input[name="email"]');
        var passwordField = document.querySelector('input[name="password"]');
        var addressField = document.querySelector('textarea[name="address"]');

        var companyName = companyNameField ? companyNameField.value.trim() : "";
        var industry = industryField ? industryField.value.trim() : "";
        var companyType = companyTypeField ? companyTypeField.value.trim() : "";
        var website = websiteField ? websiteField.value.trim() : "";
        var registrationNumber = registrationNumberField ? registrationNumberField.value.trim() : "";
        var licenseNumber = licenseNumberField ? licenseNumberField.value.trim() : "";
        var email = emailField ? emailField.value.trim() : "";
        var password = passwordField ? passwordField.value.trim() : "";
        var address = addressField ? addressField.value.trim() : "";

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

        // 4. Validate Website URL
        if (!website) {
            alert("Please enter the company website URL.");
            event.preventDefault();
            return;
        }
        const urlRegex = /^(https?:\/\/)([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/.*)?$/;
        if (!urlRegex.test(website)) {
            alert("Please enter a valid website URL (e.g. https://www.example.com).");
            event.preventDefault();
            return;
        }

        // 5. Validate Registration Number
        if (!registrationNumber) {
            alert("Please enter the company registration number.");
            event.preventDefault();
            return;
        }

        // 6. Validate License Number
        if (!cin) {
            alert("Please enter the company CIN number.");
            event.preventDefault();
            return;
        }

        // 7. Validate Email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert("Please enter a valid email address.");
            event.preventDefault();
            return;
        }

        // 8. Validate Password strength
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

        // 9. Validate Address
        if (!address) {
            alert("Please enter the company address.");
            event.preventDefault();
            return;
        }

    });
});
