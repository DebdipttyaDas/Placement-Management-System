document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form");

    if (form) {
        form.addEventListener("submit", function(event) {
            // 1. Phone Number Validation
            const phoneInput = document.querySelector("input[name='phone']");
            const phoneRegex = /^[0-9]{10}$/;
            if (phoneInput && !phoneRegex.test(phoneInput.value)) {
                alert("Please enter a valid 10-digit phone number.");
                event.preventDefault();
                return;
            }

            // 2. Password Validation
            const passwordInput = document.querySelector("input[name='password']");
            if (passwordInput && passwordInput.value.length < 6) {
                alert("Password must be at least 6 characters long.");
                event.preventDefault();
                return;
            }

            // 3. Auto-generate Company Code
            // The CompanyRegisterServlet expects a 'companyCode' parameter, but the form doesn't have it.
            // We generate it here dynamically before submission.
            let companyCodeInput = document.querySelector("input[name='companyCode']");
            if (!companyCodeInput) {
                companyCodeInput = document.createElement("input");
                companyCodeInput.type = "hidden";
                companyCodeInput.name = "companyCode";
                form.appendChild(companyCodeInput);
            }

            const companyName = document.querySelector("input[name='companyName']").value;
            let prefix = companyName.replace(/[^a-zA-Z]/g, '').substring(0, 3).toUpperCase();
            if (prefix.length < 3) {
                prefix = "CMP"; // Default fallback
            }
            
            // Format: PREFIX-1234
            const randomNum = Math.floor(1000 + Math.random() * 9000);
            const generatedCode = prefix + "-" + randomNum;
            companyCodeInput.value = generatedCode;
            
            // Optionally, we could show an alert or confirm box so the company knows their code
            // alert("Your Company Code is: " + generatedCode + "\nPlease save this for login!");
        });
    }
});