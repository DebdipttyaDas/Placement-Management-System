// ===== FILTER BY STATUS =====
function filterStatus(status) {

    const rows = document.querySelectorAll(".table-container tbody tr");

    rows.forEach(function (row) {
        if (status === "all") {
            row.style.display = "table-row";
        } else {
            row.style.display =
                row.classList.contains(status) ? "table-row" : "none";
        }
    });
}


// ===== SEARCH BY COMPANY OR ROLE =====
document.addEventListener("DOMContentLoaded", function () {

    const searchInput = document.querySelector('.controls input');

    searchInput.addEventListener("keyup", function () {

        const query = searchInput.value.toLowerCase().trim();
        const rows  = document.querySelectorAll(".table-container tbody tr");

        rows.forEach(function (row) {

            const companyEl = row.querySelector(".company");
            const roleEl    = row.querySelectorAll("td")[1];

            const company = companyEl ? companyEl.innerText.toLowerCase() : "";
            const role    = roleEl    ? roleEl.innerText.toLowerCase()    : "";

            row.style.display =
                company.includes(query) || role.includes(query)
                ? "table-row"
                : "none";
        });
    });

});
