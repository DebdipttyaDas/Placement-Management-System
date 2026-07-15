// ======================
// Common Elements
// ======================

const emailSection = () => document.getElementById("emailSection");
const companySection = () => document.getElementById("companySection");

// ======================
// Tab Active
// ======================

function setActiveTab(activeId) {

    document.getElementById("tabStudent").className =
        "tab-btn tab-inactive font-bold transition-all duration-200";

    document.getElementById("tabCompany").className =
        "tab-btn tab-inactive font-bold transition-all duration-200";

    document.getElementById(activeId).className =
        "tab-btn tab-active font-bold transition-all duration-200";
}

// ======================
// Show / Hide Sections
// ======================

function showEmailSection() {

    emailSection().classList.remove("hidden-section");
    emailSection().classList.add("visible-section");
}

function hideEmailSection() {

    emailSection().classList.remove("visible-section");
    emailSection().classList.add("hidden-section");
}

function showCompanySection() {

    companySection().classList.remove("hidden-section");
    companySection().classList.add("visible-section");
}

function hideCompanySection() {

    companySection().classList.remove("visible-section");
    companySection().classList.add("hidden-section");
}

// ======================
// STUDENT
// ======================

function showStudent() {

    setActiveTab("tabStudent");

    showEmailSection();
    hideCompanySection();

    document.getElementById("userLabel").innerText = "EMAIL";

    document.getElementById("userInput").placeholder =
        "Enter your email";

    document.querySelector('input[name="password"]').placeholder =
        "Enter your password";

    document.getElementById("footerText").innerText =
        "New student?";

    document.getElementById("footerLink").style.display = "inline";

    document.getElementById("footerLink").href =
        "StudentRegister.jsp";

    document.getElementById("footerLink").innerText =
        "Create new Account";

    document.getElementById("role").value = "student";
}

// ======================
// COMPANY
// ======================

function showCompany() {

    setActiveTab("tabCompany");

    hideEmailSection();
    showCompanySection();

    document.querySelector('input[name="password"]').placeholder =
        "Enter company password";

    document.getElementById("footerText").innerText =
        "New company?";

    document.getElementById("footerLink").style.display = "inline";

    document.getElementById("footerLink").href =
        "CompanyRegister.jsp";

    document.getElementById("footerLink").innerText =
        "Create new Account";

    document.getElementById("role").value = "company";
}

// ======================
// ADMIN
// ======================

function showAdmin() {

    showEmailSection();
    hideCompanySection();

    document.getElementById("userLabel").innerText =
        "ADMIN USERNAME";

    document.getElementById("userInput").placeholder =
        "Enter admin username";

    document.querySelector('input[name="password"]').placeholder =
        "Enter admin password";

    document.getElementById("footerText").innerText = "";

    document.getElementById("footerLink").style.display = "none";

    document.getElementById("role").value = "admin";
}

// ======================
// Initial Page
// ======================

window.onload = function () {

    const role =
        new URLSearchParams(window.location.search).get("role");

    if (role === "company") {

        showCompany();

    } else if (role === "admin") {

        showAdmin();

    } else {

        showStudent();
    }
};

// ======================
// Validation
// ======================

document.addEventListener("DOMContentLoaded", function () {

    const form = document.querySelector("form");

    form.addEventListener("submit", function (e) {

        const role =
            document.getElementById("role").value;

        const email =
            document.getElementById("userInput").value.trim();

        const password =
            document.querySelector('input[name="password"]').value.trim();

        const companyCode =
            document.querySelector('input[name="companyCode"]').value.trim();

        if (role === "student") {

            if (email === "" || password === "") {

                alert("Please fill all fields.");
                e.preventDefault();
                return;
            }

            const pattern =
                /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!pattern.test(email)) {

                alert("Enter a valid email.");
                e.preventDefault();
                return;
            }
        }

        if (role === "company") {

            if (companyCode === "" || password === "") {

                alert("Please enter company code and password.");
                e.preventDefault();
                return;
            }
        }

        if (role === "admin") {

            if (email === "" || password === "") {

                alert("Please fill all fields.");
                e.preventDefault();
                return;
            }
        }

        if (password.length < 4) {

            alert("Password must contain at least 4 characters.");
            e.preventDefault();
        }

    });

});