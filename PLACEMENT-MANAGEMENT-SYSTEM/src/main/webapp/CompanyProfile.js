// ===== MODAL OPEN =====
function openModal() {
    const modal = document.getElementById('companyModal');
    modal.classList.add('active');
}


// ===== MODAL CLOSE =====
function closeModal() {
    const modal = document.getElementById('companyModal');
    modal.classList.remove('active');
}


// ===== CLOSE ON OVERLAY CLICK =====
function handleOverlayClick(e) {
    if (e.target === document.getElementById('companyModal')) {
        closeModal();
    }
}


// ===== CLOSE ON ESCAPE KEY =====
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeModal();
});


// ===== FORM VALIDATION =====
document.addEventListener('DOMContentLoaded', function () {

    const form = document.querySelector('.modal-box form');

    form.addEventListener('submit', function (e) {

        // ---- BASIC DETAILS ----
        const companyName = form.querySelector('input[name="companyName"]').value.trim();
        const industry    = form.querySelector('input[name="industry"]').value.trim();
        const companyType = form.querySelector('input[name="companyType"]').value.trim();
        const password    = form.querySelector('input[name="password"]').value.trim();

        // ---- CONTACT DETAILS ----
        const phone    = form.querySelector('input[name="companyPhone"]').value.trim();
        const email    = form.querySelector('input[name="companyEmail"]').value.trim();
        const website  = form.querySelector('input[name="companyWebsite"]').value.trim();

        // ---- ADDRESS DETAILS ----
        const address  = form.querySelector('input[name="companyAddress"]').value.trim();
        const city     = form.querySelector('input[name="city"]').value.trim();
        const state    = form.querySelector('input[name="state"]').value.trim();
        const country  = form.querySelector('input[name="country"]').value.trim();
        const pincode  = form.querySelector('input[name="pincode"]').value.trim();

        // ---- LEGAL DETAILS ----
        const cin             = form.querySelector('input[name="cin"]').value.trim();
        const registrationNum = form.querySelector('input[name="registrationNum"]').value.trim();
        const licenseNum      = form.querySelector('input[name="licenseNum"]').value.trim();
        const gstNum          = form.querySelector('input[name="gstNum"]').value.trim();

        // ---- PATTERNS ----
        const emailPattern   = /^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i;
        const phonePattern   = /^[6-9]\d{9}$/;
        const websitePattern = /^(https?:\/\/)?(www\.)?[\w.-]+\.[a-z]{2,}(\/.*)?$/i;
        const pincodePattern = /^\d{6}$/;
        const gstPattern     = /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/;

        // ---- REQUIRED FIELDS CHECK ----
        if (!companyName || !industry || !companyType || !password ||
            !phone || !email || !website ||
            !address || !city || !state || !country || !pincode ||
            !cin || !registrationNum || !licenseNum || !gstNum) {
            alert('Please fill all required fields.');
            e.preventDefault();
            return;
        }

        // ---- EMAIL ----
        if (!emailPattern.test(email)) {
            alert('Enter a valid company email address.');
            e.preventDefault();
            return;
        }

        // ---- PHONE (10-digit Indian number) ----
        if (!phonePattern.test(phone)) {
            alert('Enter a valid 10-digit phone number.');
            e.preventDefault();
            return;
        }

        // ---- WEBSITE ----
        if (!websitePattern.test(website)) {
            alert('Enter a valid website URL (e.g. https://www.example.com).');
            e.preventDefault();
            return;
        }

        // ---- PINCODE (6-digit) ----
        if (!pincodePattern.test(pincode)) {
            alert('Enter a valid 6-digit pincode.');
            e.preventDefault();
            return;
        }

        // ---- GST NUMBER ----
        if (!gstPattern.test(gstNum)) {
            alert('Enter a valid GST number (e.g. 22AAAAA0000A1Z5).');
            e.preventDefault();
            return;
        }

        // ---- PASSWORD LENGTH ----
        if (password.length < 4) {
            alert('Password must be at least 4 characters.');
            e.preventDefault();
            return;
        }

    });

});


// ===== BACK TO TOP =====
window.addEventListener('scroll', function () {
    const btn = document.getElementById('backToTop');
    btn.style.display = window.scrollY > 300 ? 'flex' : 'none';
});

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('backToTop').addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
});
