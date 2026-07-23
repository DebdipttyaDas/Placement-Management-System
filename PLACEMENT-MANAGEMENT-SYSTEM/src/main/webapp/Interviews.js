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

    function escapeHtml(text) {
        if (!text) return "";
        return String(text)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
    }

    /* =========================================================
       LOAD INTERVIEWS
    ========================================================= */

    function loadAdminInterviews() {

        var container = document.getElementById("adminScheduleContainer");

        if (!container) {
            return;
        }

        fetch("FetchInterviewsServlet")

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

                // Populate Dynamic Scheduled Students List
                var studentsContainer = document.getElementById("dynamicStudentsList");
                if (studentsContainer) {
                    if (!Array.isArray(interviews) || interviews.length === 0) {
                        studentsContainer.innerHTML = '<div style="color:#64748b;font-size:14px;margin-top:10px;">No scheduled students yet.</div>';
                    } else {
                        var studentHtml = "";
                        var seenStudents = {};
                        interviews.forEach(function(inv) {
                            var sName = inv.student_name || "Unknown";
                            if (!seenStudents[sName]) {
                                seenStudents[sName] = true;
                                studentHtml += '<div style="padding: 8px 0; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">' +
                                    '<div><strong style="color: #1e293b; font-size: 14px;">' + escapeHtml(sName) + '</strong><br><small style="color: #64748b;">' + escapeHtml(inv.interview_round || "Interview") + '</small></div>' +
                                    '<span style="background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;">Scheduled</span>' +
                                '</div>';
                            }
                        });
                        studentsContainer.innerHTML = studentHtml;
                    }
                }

                // Populate Dynamic Panelist Load List
                var panelistContainer = document.getElementById("dynamicPanelistList");
                if (panelistContainer) {
                    if (!Array.isArray(interviews) || interviews.length === 0) {
                        panelistContainer.innerHTML = '<div style="color:#64748b;font-size:14px;margin-top:10px;">No panelists assigned yet.</div>';
                    } else {
                        var panelistCounts = {};
                        interviews.forEach(function(inv) {
                            var pName = inv.interviewer_name || "Unassigned";
                            panelistCounts[pName] = (panelistCounts[pName] || 0) + 1;
                        });

                        var panelistHtml = "";
                        for (var pName in panelistCounts) {
                            panelistHtml += '<div style="padding: 8px 0; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">' +
                                '<span style="color: #1e293b; font-size: 14px; font-weight: 500;">' + escapeHtml(pName) + '</span>' +
                                '<span style="background: #f1f5f9; color: #475569; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600;">' + panelistCounts[pName] + ' Round(s)</span>' +
                            '</div>';
                        }
                        panelistContainer.innerHTML = panelistHtml;
                    }
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

    // Auto-refresh interviews every 5 seconds
    setInterval(loadAdminInterviews, 5000);

    // Listen for new interview scheduled from other tabs/panels
    if ("BroadcastChannel" in window) {
        new BroadcastChannel("interview-schedule-channel").onmessage = function(e) {
            if (e.data && e.data.event === "interviewScheduled") {
                loadAdminInterviews();
            }
        };
    }

    /* =========================================================
       REAL-TIME STUDENT APPLICATION CHECK
    ========================================================= */

    var companyInput = document.getElementById("companyName");
    var studentInput = document.getElementById("studentName");
    var appStatusMsg = document.getElementById("studentAppStatusMsg");

    function checkCandidateApplication() {
        if (!companyInput || !studentInput || !appStatusMsg) return;
        var compVal = companyInput.value.trim();
        var studVal = studentInput.value.trim();

        if (!compVal || !studVal) {
            appStatusMsg.style.display = "none";
            return;
        }

        fetch("ScheduleInterviewServlet?action=checkApplication&companyName=" + encodeURIComponent(compVal) + "&studentName=" + encodeURIComponent(studVal))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                appStatusMsg.style.display = "block";
                if (data.applied) {
                    appStatusMsg.style.color = "#16a34a";
                    appStatusMsg.innerText = "✓ Student has applied to this company";
                } else {
                    appStatusMsg.style.color = "#dc2626";
                    appStatusMsg.innerText = "✕ Student has not applied to this company";
                }
            })
            .catch(function(err) {
                console.error("Check application error:", err);
            });
    }

    if (studentInput) {
        studentInput.addEventListener("blur", checkCandidateApplication);
        studentInput.addEventListener("change", checkCandidateApplication);
    }
    if (companyInput) {
        companyInput.addEventListener("blur", checkCandidateApplication);
    }

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
                    (error && error.message) ? error.message : "Failed to schedule interview",
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