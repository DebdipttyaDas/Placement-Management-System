document.addEventListener("DOMContentLoaded", function () {

    var form = document.querySelector('form[action="StudentRegisterServlet"]');
    if (!form) {
        return;
    }

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
    }

    form.querySelectorAll("input, select").forEach(function (field) {
        field.addEventListener("input", function () {
            field.classList.remove(INVALID_CLASS);
        });
        field.addEventListener("change", function () {
            field.classList.remove(INVALID_CLASS);
        });
    });

    form.addEventListener("submit", function (event) {
        clearFieldErrors();

        var isValid = true;
        var cgpaInput = getCgpaInput();
        var emailInput = form.querySelector('input[name="email"]');
        var passwordInput = form.querySelector('input[name="password"]');
        var fullNameInput = form.querySelector('input[name="fullName"]');
        var collegeInput = form.querySelector('input[name="collegeName"]');
        var departmentInput = form.querySelector('select[name="department"]');
        var dobInput = form.querySelector('input[name="dob"]');
        var resumeInput = form.querySelector('input[name="resume"]');
        var photoInput = form.querySelector('input[name="photo"]');

        var cgpa = cgpaInput ? cgpaInput.value.trim() : "";
        var email = emailInput ? emailInput.value.trim() : "";
        var password = passwordInput ? passwordInput.value.trim() : "";

        ensureCgpaHiddenField();

        if (!fullNameInput || fullNameInput.value.trim() === "") {
            alert("Please enter your full name.");
            markInvalid(fullNameInput);
            isValid = false;
        }

        if (!collegeInput || collegeInput.value.trim() === "") {
            alert("Please enter your college name.");
            markInvalid(collegeInput);
            isValid = false;
        }

        if (!departmentInput || departmentInput.value === "") {
            alert("Please select your department.");
            markInvalid(departmentInput);
            isValid = false;
        }

        if (!dobInput || dobInput.value === "") {
            alert("Please enter your date of birth.");
            markInvalid(dobInput);
            isValid = false;
        }

        if (cgpa === "" || isNaN(cgpa) || Number(cgpa) < 0 || Number(cgpa) > 100) {
            alert("Please enter a valid CGPA or Percentage (0 - 100).");
            markInvalid(cgpaInput);
            isValid = false;
        }

        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert("Please enter a valid email address.");
            markInvalid(emailInput);
            isValid = false;
        }

        if (password.length < 6) {
            alert("Password must be at least 6 characters long.");
            markInvalid(passwordInput);
            isValid = false;
        }

        var resume = resumeInput && resumeInput.files[0] ? resumeInput.files[0] : null;
        if (resume) {
            var resumeExt = resume.name.split(".").pop().toLowerCase();
            if (resumeExt !== "pdf") {
                alert("Resume must be a PDF file.");
                markInvalid(resumeInput);
                isValid = false;
            } else if (resume.size > 65 * 1024) {
                alert("Resume size must be less than 500KB.");
                markInvalid(resumeInput);
                isValid = false;
            }
        }

        var photo = photoInput && photoInput.files[0] ? photoInput.files[0] : null;
        if (photo) {
            var photoExt = photo.name.split(".").pop().toLowerCase();
            if (photoExt !== "jpg") {
                alert("Photo must be a JPG file.");
                markInvalid(photoInput);
                isValid = false;
            } else if (photo.size > 65 * 1024) {
                alert("Photo size must be less than 100KB.");
                markInvalid(photoInput);
                isValid = false;
            }
        }

        if (!isValid) {
            event.preventDefault();
        }
    });

});