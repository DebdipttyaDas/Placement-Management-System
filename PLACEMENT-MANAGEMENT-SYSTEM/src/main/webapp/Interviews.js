document.addEventListener("DOMContentLoaded", function () {

    /* =========================================================
       ELEMENTS
    ========================================================= */

    var modal = document.getElementById("slotModal");
    var openBtn = document.getElementById("openSlotModalBtn");
    var closeBtn = document.getElementById("closeSlotModalBtn");
    var cancelBtn = document.getElementById("cancelModalBtn");
    var form = document.getElementById("scheduleInterviewForm");
    var loader = document.getElementById("slotLoader");
    var btnText = document.getElementById("btnText");
    var toast = document.getElementById("toast");

    var selectedType = "Virtual";

    /* =========================================================
       OPEN MODAL
    ========================================================= */

    openBtn.addEventListener("click", function () {
        modal.classList.add("active");
    });

    /* =========================================================
       CLOSE MODAL
    ========================================================= */

    function closeModal() {
        modal.classList.remove("active");
        form.reset();
        selectedType = "Virtual";

        document.querySelectorAll(".type-btn").forEach(function (btn) {
            btn.classList.remove("active");
        });

        var virtualBtn = document.querySelector("[data-type='Virtual']");
        if (virtualBtn) {
            virtualBtn.classList.add("active");
        }
    }

    closeBtn.addEventListener("click", closeModal);
    cancelBtn.addEventListener("click", closeModal);

    window.addEventListener("click", function (e) {
        if (e.target === modal) {
            closeModal();
        }
    });

    /* =========================================================
       TYPE BUTTONS
    ========================================================= */

    var typeButtons = document.querySelectorAll(".type-btn");

    typeButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            typeButtons.forEach(function (b) {
                b.classList.remove("active");
            });
            btn.classList.add("active");
            selectedType = btn.getAttribute("data-type");
        });
    });

    /* =========================================================
       TOAST
    ========================================================= */

    function showToast(message, isError) {
        if (isError === undefined) {
            isError = false;
        }
        toast.innerText = message;
        if (isError) {
            toast.className = "toast show error";
        } else {
            toast.className = "toast show";
        }
        setTimeout(function () {
            toast.classList.remove("show");
        }, 4000);
    }

    /* =========================================================
       BUILD CARD HTML (no template literals)
    ========================================================= */

    function buildInterviewCard(inv, color) {
        return (
            '<motion.div class="slot">' +
                '<span class="time">' + inv.interview_time + '</span>' +
                '<motion.div class="card ' + color + '">' +
                    '<h4>' + inv.interview_round + '</h4>' +
                    '<p><b>' + inv.company_name + '</b></p>' +
                    '<p>Student: ' + inv.student_name + '</p>' +
                    '<p>Panelist: ' + inv.interviewer_name + '</p>' +
                    '<br>' +
                    '<a href="' + inv.meet_link + '" target="_blank">' +
                        '<button class="assign-btn">Join Meeting</button>' +
                    '</a>' +
                '</motion.div>' +
            '</motion.div>'
        );
    }

    /* =========================================================
       LOAD INTERVIEWS
    ========================================================= */

    function loadAdminInterviews() {
        var container = document.getElementById("adminScheduleContainer");

        fetch("FetchInterviewsServlet?all=true")
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Failed to fetch interviews");
                }
                return response.json();
            })
            .then(function (interviews) {
                document.getElementById("totalRoundsCount").innerText = interviews.length;

                if (interviews.length === 0) {
                    container.innerHTML =
                        '<motion.div class="loading-text">' +
                            'No interview slots scheduled yet.' +
                        '</motion.div>';
                    return;
                }

                container.innerHTML = "";

                interviews.forEach(function (inv, index) {
                    var color = "blue";
                    if (index % 3 === 1) {
                        color = "purple";
                    }
                    if (index % 3 === 2) {
                        color = "red";
                    }
                    container.innerHTML += buildInterviewCard(inv, color);
                });
            })
            .catch(function (error) {
                console.error(error);
                container.innerHTML =
                    '<motion.div class="loading-text">' +
                        'Failed to load interviews.' +
                    '</motion.div>';
            });
    }

    loadAdminInterviews();

    /* =========================================================
       FORM SUBMIT
    ========================================================= */

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        btnText.style.display = "none";
        loader.style.display = "block";

        var payload = {
            interview_round: document.getElementById("interviewRound").value,
            company_name: document.getElementById("companyName").value,
            student_name: document.getElementById("studentName").value,
            interview_date: document.getElementById("interviewDate").value,
            interview_time: document.getElementById("interviewTime").value,
            interviewer_name: document.getElementById("interviewerName").value,
            interview_type: selectedType,
            duration: 60,
            meet_link: document.getElementById("meetLink").value || ""
        };

        fetch("ScheduleInterviewServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                if (data.success) {
                    showToast("Interview slot scheduled successfully!");
                    closeModal();
                    loadAdminInterviews();
                } else {
                    showToast(
                        data.message || "Failed to schedule interview",
                        true
                    );
                }
            })
            .catch(function (error) {
                console.error(error);
                showToast("Server error occurred", true);
            })
            .finally(function () {
                btnText.style.display = "inline";
                loader.style.display = "none";
            });
    });

});