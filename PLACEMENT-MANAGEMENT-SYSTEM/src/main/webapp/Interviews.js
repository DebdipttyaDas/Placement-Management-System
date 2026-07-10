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

    if (openBtn) {
        openBtn.addEventListener("click", function () {
            modal.classList.add("active");
        });
    }



    /* =========================================================
       CLOSE MODAL
    ========================================================= */

    function closeModal() {

        if (modal) {
            modal.classList.remove("active");
        }

        if (form) {
            form.reset();
        }

        selectedType = "Virtual";

        document.querySelectorAll(".type-btn").forEach(function (btn) {
            btn.classList.remove("active");
        });

        var virtualBtn = document.querySelector("[data-type='Virtual']");

        if (virtualBtn) {
            virtualBtn.classList.add("active");
        }
    }

    if (closeBtn) {
        closeBtn.addEventListener("click", closeModal);
    }

    if (cancelBtn) {
        cancelBtn.addEventListener("click", closeModal);
    }

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

        if (!toast) {
            alert(message);
            return;
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
       BUILD CARD HTML
    ========================================================= */

    function buildInterviewCard(inv, color) {

        var meetingButton = "";

        if (inv.meet_link && inv.meet_link.trim() !== "") {

            meetingButton =
                '<a href="' + inv.meet_link + '" target="_blank">' +
                    '<button class="assign-btn">Join Meeting</button>' +
                '</a>';

        } else {

            meetingButton =
                '<button class="assign-btn disabled" disabled>No Link</button>';
        }

        return (
            '<div class="slot">' +

                '<span class="time">' +
                    (inv.interview_time || "N/A") +
                '</span>' +

                '<div class="card ' + color + '">' +

                    '<h4>' +
                        (inv.interview_round || "Interview") +
                    '</h4>' +

                    '<p><b>' +
                        (inv.company_name || "Unknown Company") +
                    '</b></p>' +

                    '<p>Student: ' +
                        (inv.student_name || "N/A") +
                    '</p>' +

                    '<p>Panelist: ' +
                        (inv.interviewer_name || "N/A") +
                    '</p>' +

                    '<br>' +

                    meetingButton +

                '</div>' +

            '</div>'
        );
    }

    /* =========================================================
       LOAD INTERVIEWS
    ========================================================= */

    function loadAdminInterviews() {

        var container = document.getElementById("adminScheduleContainer");

        if (!container) {
            return;
        }

        fetch("FetchInterviewsServlet?all=true")

            .then(function (response) {

                if (!response.ok) {
                    throw new Error("Failed to fetch interviews");
                }

                return response.json();
            })

            .then(function (interviews) {

                var totalRoundsCount =
                    document.getElementById("totalRoundsCount");

                if (totalRoundsCount) {
                    totalRoundsCount.innerText = interviews.length;
                }

                if (!Array.isArray(interviews) || interviews.length === 0) {

                    container.innerHTML =
                        '<div class="loading-text">' +
                            'No interview slots scheduled yet.' +
                        '</div>';

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
                    '<div class="loading-text">' +
                        'Failed to load interviews.' +
                    '</div>';
            });
    }

    loadAdminInterviews();

    /* =========================================================
       FORM SUBMIT
    ========================================================= */

    if (form) {

        form.addEventListener("submit", function (e) {

            e.preventDefault();

            if (btnText) {
                btnText.style.display = "none";
            }

            if (loader) {
                loader.style.display = "block";
            }

            var payload = {

                interview_round:
                    document.getElementById("interviewRound").value,

                company_name:
                    document.getElementById("companyName").value,

                student_name:
                    document.getElementById("studentName").value,

                interview_date:
                    document.getElementById("interviewDate").value,

                interview_time:
                    document.getElementById("interviewTime").value,

                interviewer_name:
                    document.getElementById("interviewerName").value,

                interview_type: selectedType,

                duration: 60,

                meet_link:
                    document.getElementById("meetLink").value || ""
            };

            fetch("ScheduleInterviewServlet", {

                method: "POST",

                headers: {
                    "Content-Type": "application/json"
                },

                body: JSON.stringify(payload)
            })

            .then(function (response) {

                if (!response.ok) {
                    throw new Error("Server response error");
                }

                return response.json();
            })

            .then(function (data) {

                if (data.success) {

                    showToast(
                        "Interview slot scheduled successfully!"
                    );

                    closeModal();

                    loadAdminInterviews();

                } else {

                    showToast(
                        data.message ||
                        "Failed to schedule interview",
                        true
                    );
                }
            })

            .catch(function (error) {

                console.error(error);

                showToast(
                    "Server error occurred",
                    true
                );
            })

            .finally(function () {

                if (btnText) {
                    btnText.style.display = "inline";
                }

                if (loader) {
                    loader.style.display = "none";
                }
            });
        });
    }

    /* =========================================================
       RESPONSIVE SIDEBAR TOGGLE
    ========================================================= */
    var sidebar = document.getElementById("sidebar");
    var sidebarToggle = document.getElementById("sidebarToggleBtn");
    var closeSidebar = document.getElementById("closeSidebarBtn");

    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener("click", function () {
            sidebar.classList.add("show");
        });
    }

    if (closeSidebar && sidebar) {
        closeSidebar.addEventListener("click", function () {
            sidebar.classList.remove("show");
        });
    }

    document.addEventListener("click", function (e) {
        if (sidebar && sidebar.classList.contains("show")) {
            if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove("show");
            }
        }
    });

});