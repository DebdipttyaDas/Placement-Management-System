document.addEventListener("DOMContentLoaded", function () {
    var form = document.getElementById("profileForm");
    if (!form) {
        return;
    }

    var photoInput = form.querySelector('input[name="photo"]');
    var avatarBox = document.querySelector(".avatar-box");
    var INVALID_CLASS = "field-invalid";

    function clearFieldErrors() {
        form.querySelectorAll("." + INVALID_CLASS).forEach(function (el) {
            el.classList.remove(INVALID_CLASS);
        });
    }

    function markInvalid(input) {
        if (input) {
            input.classList.add(INVALID_CLASS);
        }
    }

    function getCgpaInput() {
        return form.querySelector('input[name="cgpa"], input[name="dgpa"]');
    }

    function ensureCgpaHiddenField() {
        var dgpaInput = form.querySelector('input[name="dgpa"]');
        var cgpaHidden = form.querySelector('input[name="cgpa"]');
        if (dgpaInput && !cgpaHidden) {
            cgpaHidden = document.createElement("input");
            cgpaHidden.type = "hidden";
            cgpaHidden.name = "cgpa";
            form.appendChild(cgpaHidden);
        }
        if (dgpaInput && cgpaHidden) {
            cgpaHidden.value = dgpaInput.value.trim();
        }
        return cgpaHidden || dgpaInput;
    }

    function isValidImageFile(file) {
        var allowedTypes = ["image/jpeg", "image/jpg"];
        var ext = file.name.split(".").pop().toLowerCase();
        return allowedTypes.indexOf(file.type) !== -1 || ext === "jpg" || ext === "jpeg";
    }

    // Clear error highlight when user edits a field
    form.querySelectorAll(".form-grid input, .card > input").forEach(function (input) {
        input.addEventListener("input", function () {
            input.classList.remove(INVALID_CLASS);
        });
    });

    // ==========================================
    // 1. INSTANT IMAGE PREVIEW
    // ==========================================
    if (photoInput && avatarBox) {
        photoInput.addEventListener("change", function () {
            var file = this.files[0];
            if (!file) {
                return;
            }

            if (!isValidImageFile(file)) {
                alert("Please upload a valid image (JPG only).");
                this.value = "";
                return;
            }

            if (file.size > 65 * 1024) {
                alert("Uploaded image must be smaller than 65KB.");
                this.value = "";
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                avatarBox.innerHTML =
                    '<img src="' + e.target.result + '" alt="Profile Preview" ' +
                    'style="width:100%; height:100%; border-radius:50%; object-fit:cover;">';
            };
            reader.readAsDataURL(file);
        });
    }

    // ==========================================
    // 2. FORM VALIDATION (form-grid fields)
    // ==========================================
    form.addEventListener("submit", function (event) {
        clearFieldErrors();

        var isValid = true;
        var passwordInput = form.querySelector('input[name="password"]');
        var confirmInput = form.querySelector('input[name="confirmPassword"]');
        var cgpaInput = getCgpaInput();
        var emailInput = form.querySelector('input[name="email"]');
        var phoneInput = form.querySelector('input[name="phone"]');

        var password = passwordInput ? passwordInput.value.trim() : "";
        var confirmPassword = confirmInput ? confirmInput.value.trim() : "";
        var cgpa = cgpaInput ? cgpaInput.value.trim() : "";

        ensureCgpaHiddenField();

        if (password !== "" || confirmPassword !== "") {
            if (password.length < 6) {
                alert("New password must be at least 6 characters long.");
                markInvalid(passwordInput);
                isValid = false;
            } else if (confirmInput && password !== confirmPassword) {
                alert("Passwords do not match! Please make sure both password fields are identical.");
                markInvalid(passwordInput);
                markInvalid(confirmInput);
                isValid = false;
            }
        }

        if (emailInput && emailInput.value.trim() !== "") {
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailInput.value.trim())) {
                alert("Please enter a valid email address.");
                markInvalid(emailInput);
                isValid = false;
            }
        }

        if (phoneInput && phoneInput.value.trim() !== "") {
            var phoneRegex = /^[0-9+\-\s()]{7,15}$/;
            if (!phoneRegex.test(phoneInput.value.trim())) {
                alert("Please enter a valid phone number.");
                markInvalid(phoneInput);
                isValid = false;
            }
        }

        if (cgpa !== "") {
            if (isNaN(cgpa) || Number(cgpa) < 0 || Number(cgpa) > 100) {
                alert("Please enter a valid CGPA or Percentage (0 - 100).");
                markInvalid(cgpaInput);
                isValid = false;
            }
        }

        if (!isValid) {
            event.preventDefault();
        }
    });
});