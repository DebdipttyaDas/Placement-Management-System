// ===== TOGGLE CARD =====
function toggleCard(button) {

    const card = button.closest(".job-card");
    const viewBtn = card.querySelector(".view-btn");

    card.classList.toggle("active");

    if (card.classList.contains("active")) {
        viewBtn.style.display = "none";
    } else {
        viewBtn.style.display = "block";
    }
}


// ===== SEARCH COMPANY =====
function searchCompany() {

    const query =
        document.getElementById("companySearch")
        .value
        .toLowerCase();

    const cards = document.querySelectorAll(".job-card");

    cards.forEach(function (card) {

        const company = card.querySelector(".company-name");

        if (company) {
            card.style.display =
                company.textContent
                .toLowerCase()
                .includes(query)
                ? "block"
                : "none";
        }
    });
}
