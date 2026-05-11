<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="UTF-8">

        <title>Interview Scheduling</title>

        <link rel="stylesheet" href="Interviews.css">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    </head>

    <body>

        <div class="container">

            <!-- SIDEBAR -->
            <aside class="sidebar">

                <br><br><br>

                <ul class="menu">

                    <li>
                        <a href="CompanyDashboard.jsp" style="text-decoration:none;color:white;">
                            Dashboard
                        </a>
                    </li>

                    <li>
                        <a href="JobPost.jsp" style="text-decoration:none;color:white;">
                            Job Posted
                        </a>
                    </li>

                    <li class="active">
                        Interviews
                    </li>

                    <li>
                        <a href="PlacementAnalysis.jsp" style="text-decoration:none;color:white;">
                            Placement Analysis
                        </a>
                    </li>

                </ul>

            </aside>

            <!-- MAIN CONTENT -->
            <main class="main-content">

                <!-- TOPBAR -->
                <div class="topbar">

                    <h2>Interviews</h2>

                    <div class="top-links">

                        <a href="AdminProfile.jsp">

                            <i class="fa fa-user-circle" style="font-size:25px;color:white;"></i>

                        </a>

                    </div>

                </div>

                <!-- PAGE HEADER -->
                <div class="page-header">

                    <h1>Interview Scheduling</h1>

                    <p>
                        Coordinate upcoming placement rounds by mapping panel
                        availability to shortlisted candidates.
                    </p>

                </div>

                <!-- TOOLBAR -->
                <div class="toolbar">

                    <div class="left-group">

                        <span class="arrow">&#10094;</span>

                        <span class="date-text">May 06, 2026</span>

                        <span class="arrow">&#10095;</span>

                        <div class="view-toggle">

                            <button class="active">Day</button>
                            <button>Week</button>
                            <button>Month</button>

                        </div>

                    </div>

                    <div class="right-actions">

                        <button class="filter-btn">
                            Filter View
                        </button>

                        <button class="create-btn" id="openSlotModalBtn">

                            Create New Slot

                        </button>

                    </div>

                </div>

                <!-- CONTENT -->
                <div class="content">

                    <!-- LEFT -->
                    <div class="schedule" id="adminScheduleContainer">

                        <div class="loading-text">
                            Loading scheduled interviews...
                        </div>

                    </div>

                    <!-- RIGHT -->
                    <div class="sidebar-right">

                        <!-- STATS -->
                        <div class="stats">

                            <div class="box">
                                <p>Total Rounds</p>
                                <h2>24</h2>
                            </div>

                            <div class="box">
                                <p>Conflicts</p>
                                <h2 class="red-text">02</h2>
                            </div>

                        </div>

                        <!-- PENDING -->
                        <div class="pending">

                            <h3>Pending Assignment</h3>

                            <div class="person">
                                Rahul Chowdhary
                            </div>

                            <div class="person">
                                Sudipta Roy
                            </div>

                            <div class="person">
                                Prantik Bose
                            </div>

                            <button class="view-btn">
                                View All Shortlisted
                            </button>

                        </div>

                        <!-- PANEL -->
                        <div class="panel-load">

                            <h3>Panelist Load</h3>

                            <p>Suresh Kumar (Tech)</p>

                            <div class="bar blue-bar"></div>

                            <p>Anita Banerjee (HR)</p>

                            <div class="bar red-bar"></div>

                        </div>

                    </div>

                </div>

            </main>

        </div>

        <!-- =========================================================
     MODAL
========================================================= -->

        <div class="interview-modal-overlay" id="slotModal">

            <div class="interview-modal">

                <!-- HEADER -->
                <div class="interview-modal-header">

                    <div>

                        <h2>Schedule Interview</h2>

                        <p>
                            Set up a new interaction between company and candidate.
                        </p>

                    </div>

                    <button class="close-modal-btn" id="closeSlotModalBtn">

                        <i class="fa-solid fa-xmark"></i>

                    </button>

                </div>

                <!-- FORM -->
                <form id="scheduleInterviewForm">

                    <!-- TITLE -->
                    <div class="modern-form-group">

                        <label>Interview Title</label>

                        <input type="text" id="interviewRound" placeholder="e.g. Technical Round 1" required>

                    </div>

                    <!-- COMPANY + STUDENT -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Select Company</label>

                            <select id="companyName" required>

                                <option value="">
                                    Choose Company
                                </option>

                                <option value="CloudScale Solutions">
                                    CloudScale Solutions
                                </option>

                                <option value="Infosys">
                                    Infosys
                                </option>

                                <option value="TCS">
                                    TCS
                                </option>

                                <option value="Wipro">
                                    Wipro
                                </option>

                            </select>

                        </div>

                        <div class="modern-form-group">

                            <label>Select Student</label>

                            <input type="text" id="studentName" placeholder="Search by name or ID" required>

                        </div>

                    </div>

                    <!-- DATE + TIME -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Date</label>

                            <input type="date" id="interviewDate" required>

                        </div>

                        <div class="modern-form-group">

                            <label>Time</label>

                            <input type="time" id="interviewTime" required>

                        </div>

                    </div>

                    <!-- PANEL + TYPE -->
                    <div class="modern-grid-2">

                        <div class="modern-form-group">

                            <label>Interviewer / Panelist</label>

                            <input type="text" id="interviewerName" placeholder="Full Name" required>

                        </div>

                        <div class="modern-form-group">

                            <label>Interview Type</label>

                            <div class="interview-type-selector">

                                <button type="button" class="type-btn active" data-type="Virtual">

                                    Virtual

                                </button>

                                <button type="button" class="type-btn" data-type="In-person">

                                    In-person

                                </button>

                                <button type="button" class="type-btn" data-type="Phone">

                                    Phone

                                </button>

                            </div>

                        </div>

                    </div>

                    <!-- LINK -->
                    <div class="modern-form-group">

                        <label>Meeting Link / Location</label>

                        <input type="text" id="meetLink" placeholder="https://meet.google.com/abc-defg-hij">

                    </div>

                    <small class="virtual-note">
                        AUTO-GENERATED FOR VIRTUAL INTERVIEWS
                    </small>

                    <!-- FOOTER -->
                    <div class="modal-footer">

                        <button type="button" class="cancel-btn" id="cancelModalBtn">

                            Cancel

                        </button>

                        <button type="submit" class="create-slot-btn">

                            <span id="btnText">
                                Create Slot
                            </span>

                            <div class="loader" id="slotLoader"></div>

                        </button>

                    </div>

                </form>

            </div>

        </div>

        <!-- TOAST -->
        <div class="toast" id="toast"></div>

        <!-- =========================================================
     JAVASCRIPT
========================================================= -->

        <script>

            const modal = document.getElementById("slotModal");

            const openBtn =
                document.getElementById("openSlotModalBtn");

            const closeBtn =
                document.getElementById("closeSlotModalBtn");

            const cancelBtn =
                document.getElementById("cancelModalBtn");

            const form =
                document.getElementById("scheduleInterviewForm");

            const loader =
                document.getElementById("slotLoader");

            const btnText =
                document.getElementById("btnText");

            const toast =
                document.getElementById("toast");

            /* OPEN MODAL */

            openBtn.onclick = () => {

                modal.classList.add("active");
            };

            /* CLOSE MODAL */

            function closeModal() {

                modal.classList.remove("active");
            }

            closeBtn.onclick = closeModal;

            cancelBtn.onclick = closeModal;

            /* CLOSE ON OUTSIDE CLICK */

            window.onclick = function (e) {

                if (e.target === modal) {

                    closeModal();
                }
            };

            /* TYPE BUTTON */

            let selectedType = "Virtual";

            document.querySelectorAll(".type-btn")
                .forEach(btn => {

                    btn.addEventListener("click", () => {

                        document.querySelectorAll(".type-btn")
                            .forEach(b => b.classList.remove("active"));

                        btn.classList.add("active");

                        selectedType = btn.dataset.type;
                    });
                });

            /* TOAST */

            function showToast(message, isError = false) {

                toast.innerText = message;

                toast.className =
                    isError
                        ? "toast show error"
                        : "toast show";

                setTimeout(() => {

                    toast.classList.remove("show");

                }, 3000);
            }

            /* SUBMIT */

            form.addEventListener("submit", async function (e) {

                e.preventDefault();

                loader.style.display = "block";

                btnText.innerText = "Creating...";

                const payload = {

                    company_name:
                        document.getElementById("companyName").value,

                    student_name:
                        document.getElementById("studentName").value,

                    interview_date:
                        document.getElementById("interviewDate").value,

                    interview_time:
                        document.getElementById("interviewTime").value,

                    interview_round:
                        document.getElementById("interviewRound").value,

                    interviewer_name:
                        document.getElementById("interviewerName").value,

                    interview_type:
                        selectedType,

                    meet_link:
                        document.getElementById("meetLink").value
                };

                try {

                    const response =
                        await fetch("ScheduleInterviewServlet", {

                            method: "POST",

                            headers: {
                                "Content-Type": "application/json"
                            },

                            body: JSON.stringify(payload)
                        });

                    const result = await response.json();

                    if (response.ok) {

                        showToast(
                            "Interview slot created successfully!"
                        );

                        form.reset();

                        closeModal();

                        fetchInterviews();

                    } else {

                        showToast(
                            result.message || "Failed to create slot",
                            true
                        );
                    }

                } catch (error) {

                    console.error(error);

                    showToast(
                        "Server error occurred",
                        true
                    );

                } finally {

                    loader.style.display = "none";

                    btnText.innerText = "Create Slot";
                }
            });

            /* FETCH INTERVIEWS */

            async function fetchInterviews() {

                try {

                    const response =
                        await fetch(
                            "FetchInterviewsServlet?all=true"
                        );

                    const data = await response.json();

                    const container =
                        document.getElementById(
                            "adminScheduleContainer"
                        );

                    if (data.length === 0) {

                        container.innerHTML =
                            `<div class="add-slot">
                No interviews scheduled yet
            </div>`;

                        return;
                    }

                    let html = "";

                    data.forEach(interview => {

                        html += `

            <div class="slot">

                <div class="time">
                    ${interview.interview_time}
                </div>

                <div class="card blue">

                    <h4>
                        ${interview.interview_round}
                    </h4>

                    <p>
                        <strong>
                            ${interview.company_name}
                        </strong>
                    </p>

                    <p>
                        Student:
                        ${interview.student_name}
                    </p>

                    <p>
                        Interviewer:
                        ${interview.interviewer_name}
                    </p>

                    <small>
                        ${interview.interview_date}
                    </small>

                    <br><br>

                    <a href="${interview.meet_link}"
                       target="_blank">

                        <button class="assign-btn">
                            Join Meeting
                        </button>

                    </a>

                </div>

            </div>
            `;
                    });

                    container.innerHTML = html;

                } catch (error) {

                    console.error(error);
                }
            }

            /* INITIAL LOAD */

            fetchInterviews();

        </script>

    </body>

    </html>