/* =============================================================
Placement.js
For JSP-generated Job Cards
============================================================= */

var activeFilter = "All";

document.addEventListener("DOMContentLoaded", function() {


buildModal();
initFilters();
initSearch();


});

/* =============================================================
Expand / Collapse Card
============================================================= */

function toggleCard(button){

const card = button.closest(".job-card");
const viewBtn = card.querySelector(".view-btn");

card.classList.toggle("active");

if(card.classList.contains("active")){
    viewBtn.style.display = "none";
}else{
    viewBtn.style.display = "block";
}


}

/* =============================================================
Filter Buttons
============================================================= */

function initFilters() {


var buttons = document.querySelectorAll(".job-filters button");

if (buttons.length > 0) {
    buttons[0].classList.add("active-filter");
}

buttons.forEach(function(btn) {

    btn.addEventListener("click", function() {

        buttons.forEach(function(b) {
            b.classList.remove("active-filter");
        });

        btn.classList.add("active-filter");

        activeFilter = btn.textContent.trim();

        applyFilters();

    });

});


}

/* =============================================================
Search
============================================================= */

function initSearch() {


var input = document.querySelector(".search-box input");

if (!input) return;

input.addEventListener("input", debounce(applyFilters, 200));


}

/* =============================================================
Filter + Search
============================================================= */

function applyFilters() {


var searchInput =
    document.querySelector(".search-box input");

var query =
    searchInput
        ? searchInput.value.toLowerCase().trim()
        : "";

var cards =
    document.querySelectorAll(".job-card");

cards.forEach(function(card){

    var text =
        card.textContent.toLowerCase();

    var matchesFilter =
        activeFilter === "All" ||
        text.includes(activeFilter.toLowerCase());

    var matchesSearch =
        !query ||
        text.includes(query);

    if(matchesFilter && matchesSearch){

        card.style.display = "";

    }else{

        card.style.display = "none";

    }

});


}

/* =============================================================
Modal
============================================================= */

function buildModal() {


if (document.getElementById("job-modal-overlay")) return;

var overlay = document.createElement("div");

overlay.id = "job-modal-overlay";

overlay.style.cssText =
    "display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:3000;justify-content:center;align-items:center;padding:20px;box-sizing:border-box;";

var modal = document.createElement("div");

modal.id = "job-modal";

modal.style.cssText =
    "background:#fff;border-radius:16px;padding:36px;width:100%;max-width:460px;position:relative;box-shadow:0 20px 60px rgba(0,0,0,0.25);display:flex;flex-direction:column;gap:12px;";

modal.innerHTML =
    "<button id='modal-close' style='position:absolute;top:14px;right:16px;background:none;border:none;font-size:1.6rem;cursor:pointer;color:#888;'>&times;</button>" +
    "<h2 id='modal-title' style='margin:0;color:#06473e;font-size:1.4rem;'></h2>" +
    "<p id='modal-dept' style='margin:0;font-weight:bold;color:#444;'></p>" +
    "<ul id='modal-tags' style='list-style:none;padding:0;margin:4px 0;display:flex;flex-direction:column;gap:6px;color:#555;font-size:0.9rem;'></ul>" +
    "<div style='display:flex;justify-content:flex-end;gap:10px;margin-top:8px;'>" +
    "<button id='modal-cancel' style='padding:10px 20px;background:rgba(0,0,0,0.06);border:1px solid rgba(0,0,0,0.12);border-radius:8px;color:#555;cursor:pointer;'>Cancel</button>" +
    "<button id='modal-confirm' style='padding:10px 22px;background:linear-gradient(135deg,#0df,#0056b3);color:#fff;font-weight:bold;border:none;border-radius:8px;cursor:pointer;'>Confirm Application</button>" +
    "</div>";

overlay.appendChild(modal);

document.body.appendChild(overlay);

document.getElementById("modal-close")
    .addEventListener("click", closeModal);

document.getElementById("modal-cancel")
    .addEventListener("click", closeModal);

document.getElementById("modal-confirm")
    .addEventListener("click", function() {

        var title =
            document.getElementById("modal-title").textContent;

        submitApplication(title);

    });

overlay.addEventListener("click", function(e) {

    if (e.target === overlay) {
        closeModal();
    }

});


}

function openModal(job) {

var overlay =
    document.getElementById("job-modal-overlay");

if (!overlay) return;

document.getElementById("modal-title").textContent =
    job.job_title || "";

document.getElementById("modal-dept").textContent =
    job.department || "";

document.getElementById("modal-tags").innerHTML =
    "<li><i class='fa-solid fa-location-dot'></i> " +
    (job.location_type || "") +
    "</li>" +

    "<li><i class='fa-solid fa-briefcase'></i> " +
    (job.employment_type || "") +
    "</li>" +

    "<li><i class='fa-solid fa-money-bill-wave'></i> " +
    (job.salary_range || "") +
    "</li>";

overlay.style.display = "flex";


}

function closeModal() {


var overlay =
    document.getElementById("job-modal-overlay");

if (overlay) {
    overlay.style.display = "none";
}


}

/* =============================================================
Submit Application
============================================================= */

function submitApplication(title) {

var btn =
    document.getElementById("modal-confirm");

if (!btn) return;

btn.textContent = "Applied!";
btn.style.background = "#06473e";
btn.disabled = true;

setTimeout(function() {

    closeModal();

    btn.textContent = "Confirm Application";

    btn.style.background =
        "linear-gradient(135deg,#0df,#0056b3)";

    btn.disabled = false;

}, 1800);


}

/* =============================================================
Helper
============================================================= */

function debounce(fn, delay) {

var timer;

return function() {

    var args = arguments;

    clearTimeout(timer);

    timer = setTimeout(function() {

        fn.apply(null, args);

    }, delay);

};


}
