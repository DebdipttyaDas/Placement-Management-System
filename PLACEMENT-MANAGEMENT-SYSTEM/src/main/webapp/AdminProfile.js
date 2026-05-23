document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("adminProfileForm");

    form.addEventListener("submit", function (event) {

        // Get Values
        const adminName = document.querySelector('input[name="adminName"]').value.trim();

        const username = document.querySelector('input[name="username"]').value.trim();

        const email = document.querySelector('input[name="email"]').value.trim();

        const password = document.querySelector('input[name="password"]').value.trim();

        const phone = document.querySelector('input[name="phone"]').value.trim();


        // ===== Empty Validation =====
        if( adminName === "" || username === "" || email === "" || password === ""){

            alert("Please fill all required fields");

            event.preventDefault();

            return;
        }


        // ===== Email Validation =====
        if(!email.includes("@") || !email.includes(".")){

            alert("Enter valid email address");

            event.preventDefault();

            return;
        }


        // ===== Password Validation =====
        if(password !== "" && password.length < 6){

            alert("Password must be at least 6 characters");

            event.preventDefault();

            return;
        }


        // ===== Phone Validation =====
        if(phone !== ""){

            if(phone.length !== 10){

                alert("Phone number must be 10 digits");

                event.preventDefault();

                return;
            }
        }


        // ===== Success =====
        alert("Profile Saved Successfully");

    });



    // =========================
    // Input Focus Effect
    // =========================
    const inputs = document.querySelectorAll(".profile-card input");

    inputs.forEach(input => {

        input.addEventListener("focus", function () {

            input.style.boxShadow = "0 0 5px #14b8a6";

        });

        input.addEventListener("blur", function () {

            input.style.boxShadow = "none";

        });

    });

});