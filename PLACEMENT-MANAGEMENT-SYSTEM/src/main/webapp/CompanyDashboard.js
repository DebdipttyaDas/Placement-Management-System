// =========================================================
// DRIVE CARDS - Show / Hide
// =========================================================

function showDrives() {
    document.querySelectorAll(".extra-drive").forEach(function(card) {
        card.style.display = "block";
    });
}

function hideDrives() {
    document.querySelectorAll(".extra-drive").forEach(function(card) {
        card.style.display = "none";
    });
}

// =========================================================
// INTERVIEWS - Show / Hide
// =========================================================

function showInterviews() {
    document.querySelectorAll(".extra-interview").forEach(function(item) {
        item.style.display = "flex";
    });
}

function hideInterviews() {
    document.querySelectorAll(".extra-interview").forEach(function(item) {
        item.style.display = "none";
    });
}

// =========================================================
// INTERVIEWS PANEL - Load from Servlet
// =========================================================

var companyAvatarClasses = ["av-as", "av-bj", "av-rk", "av-sn", "av-ap", "av-ms", "av-dp"];

function getInitials(name) {
    var parts = (name || "").trim().split(/\s+/);
    if (parts.length >= 2) {
        return (parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
    }
    return (name || "NA").substring(0, 2).toUpperCase();
}

function escapeHtml(text) {
    if (!text) return "";
    return String(text)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}

function buildCompanyInterviewItem(inv, index) {
    var extraClass = index > 0 ? " extra-interview" : "";
    var avatarClass = companyAvatarClasses[index % companyAvatarClasses.length];
    var meetLink = inv.meet_link || "";
    var hasMeet = meetLink.indexOf("http") === 0;
    var videoClick = hasMeet
        ? "window.open('" + meetLink.replace(/'/g, "\\'") + "','_blank')"
        : "alert('Meeting link: " + meetLink.replace(/'/g, "\\'") + "')";

    return '<div class="interview-item' + extraClass + '">' +
        '<div class="avatar ' + avatarClass + '">' + escapeHtml(getInitials(inv.student_name)) + '</div>' +
        '<div class="interview-info">' +
            '<div class="interview-name">' + escapeHtml(inv.student_name) + '</div>' +
            '<div class="interview-role">' + escapeHtml(inv.interview_round) + ' &bull; ' + escapeHtml(inv.company_name) + '</div>' +
            '<div class="interview-time">' + escapeHtml(inv.interview_date) + ' &bull; ' + escapeHtml(inv.interview_time) + '</div>' +
        '</div>' +
        '<button type="button" class="video-btn" onclick="' + videoClick + '"><i class="fa fa-video"></i></button>' +
    '</div>';
}

function loadCompanyInterviews() {
    var panel = document.getElementById("companyInterviewsPanel");
    if (!panel) return;

    fetch("FetchInterviewsServlet")
        .then(function(r) {
            if (!r.ok) throw new Error("Failed");
            return r.json();
        })
        .then(function(interviews) {
            if (!interviews.length) {
                panel.innerHTML = '<div style="padding:12px 0;color:#64748b;">No interviews scheduled yet.</div>';
                return;
            }
            panel.innerHTML = "";
            interviews.forEach(function(inv, i) {
                panel.innerHTML += buildCompanyInterviewItem(inv, i);
            });
        })
        .catch(function(err) {
            console.error(err);
            panel.innerHTML = '<div style="padding:12px 0;color:#dc2626;">Unable to load interviews.</div>';
        });
}

function loadActiveDrives() {
    var container = document.getElementById("activeDrivesContainer");
    if (!container) return;

    fetch("FetchJobsServlet")
        .then(function(r) {
            if (!r.ok) throw new Error("Failed to load jobs");
            return r.json();
        })
        .then(function(jobs) {
            if (!jobs.length) {
                container.innerHTML = '<div style="padding: 20px; text-align: center; color: #64748b;">No active job drives posted yet.</div>';
                return;
            }

            var html = "";
            jobs.forEach(function(job, index) {
                var extraClass = index > 0 ? " extra-drive" : "";
                var totalApplicants = job.total_applicants || 0;
                
                // Pipeline progress logic representation
                var appliedPct = 40;
                var techPct = 30;
                var hrPct = 20;
                var offersPct = 10;
                
                html += '<div class="drive-card' + extraClass + '">' +
                    '<div class="drive-top">' +
                        '<div class="drive-title">' + escapeHtml(job.job_title) + '</div>' +
                        '<span class="badge badge-active">Active</span>' +
                    '</div>' +
                    '<div class="drive-meta">' + escapeHtml(job.location) + ' • ' + escapeHtml(job.location_type) + ' • ' + escapeHtml(job.employment_type) + '</div>' +
                    '<div class="pipeline-header">' +
                        '<span class="pipeline-label">Selection Pipeline</span>' +
                        '<span class="pipeline-total">' + totalApplicants + ' Total Applicants</span>' +
                    '</div>' +
                    '<div class="pipeline-bar">' +
                        '<div class="seg-applied" style="width:' + appliedPct + '%" title="Applied"></div>' +
                        '<div class="seg-tech" style="width:' + techPct + '%" title="Tech Round"></div>' +
                        '<div class="seg-hr" style="width:' + hrPct + '%" title="HR Round"></div>' +
                        '<div class="seg-offers" style="width:' + offersPct + '%" title="Offers"></div>' +
                    '</div>' +
                '</div>';
            });
            container.innerHTML = html;
        })
        .catch(function(err) {
            console.error(err);
            container.innerHTML = '<div style="padding: 20px; text-align: center; color: #dc2626;">Failed to load active drives.</div>';
        });
}

// =========================================================
// INIT
// =========================================================

// Load interviews on page load
loadCompanyInterviews();
loadActiveDrives();

// Auto-refresh every 5 seconds
setInterval(function() {
    loadCompanyInterviews();
    loadActiveDrives();
}, 5000);


// Listen for new interview scheduled from other tabs
if ("BroadcastChannel" in window) {
    new BroadcastChannel("interview-schedule-channel").onmessage = function(e) {
        if (e.data && e.data.event === "interviewScheduled") {
            loadCompanyInterviews();
        }
    };
}

// =========================================================
// REVIEW APPLICATIONS MODAL & AJAX FORM
// =========================================================

function initReviewApplications() {
    var reviewBtn = document.getElementById("reviewApplicationsBtn");
    var modal = document.getElementById("reviewApplicationsModal");
    var closeBtn = document.getElementById("closeReviewModalBtn");
    var container = document.getElementById("applicationsContainer");
    var loader = document.getElementById("applicationsLoader");

    if (reviewBtn && modal && closeBtn) {
        reviewBtn.addEventListener("click", function() {
            modal.classList.add("active");
            loadApplications();
        });

        closeBtn.addEventListener("click", function() {
            modal.classList.remove("active");
        });

        modal.addEventListener("click", function(e) {
            if (e.target === modal) {
                modal.classList.remove("active");
            }
        });
    }

    function loadApplications() {
        if (!container || !loader) return;
        loader.style.display = "block";
        container.innerHTML = "";

        fetch("ReviewApplicationsServlet?action=list")
            .then(function(r) {
                if (!r.ok) throw new Error("Failed to load applications");
                return r.json();
            })
            .then(function(apps) {
                loader.style.display = "none";
                if (!apps.length) {
                    container.innerHTML = '<div class="no-apps-message">No pending applications found for your company.</div>';
                    return;
                }

                var html = "";

                apps.forEach(function(app) {
                    html += '<div class="application-form-card">' +
                        '<h3>Application Review</h3>' +
                        '<div class="form-grid">' +
                            '<div class="form-field">' +
                                '<label>Student Name</label>' +
                                '<span>' + escapeHtml(app.fullName) + '</span>' +
                            '</div>' +
                            '<div class="form-field">' +
                                '<label>Contact Info</label>' +
                                '<span>' + escapeHtml(app.email) + ' &bull; ' + escapeHtml(app.phone) + '</span>' +
                            '</div>' +
                            '<div class="form-field">' +
                                '<label>Job Title</label>' +
                                '<span>' + escapeHtml(app.jobTitle) + '</span>' +
                            '</div>' +
                            '<div class="form-field">' +
                                '<label>Department & Salary</label>' +
                                '<span>' + escapeHtml(app.department) + ' &bull; ' + escapeHtml(app.salary) + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<div class="form-actions">' +
                            '<button type="button" class="btn-approve" onclick="approveApplication(' + app.applicationId + ')"><i class="fa fa-check-circle"></i> Accept</button>' +
                            '<button type="button" class="btn-reject" onclick="rejectApplication(' + app.applicationId + ')"><i class="fa fa-times-circle"></i> Reject</button>' +
                        '</div>' +
                    '</div>';
                });

                container.innerHTML = html;
            })
            .catch(function(err) {
                loader.style.display = "none";
                container.innerHTML = '<div class="no-apps-message" style="color:#dc2626;">Error: ' + escapeHtml(err.message) + '</div>';
            });
    }

    window.approveApplication = function(id) {
        if (!confirm("Are you sure you want to approve this application?")) return;
        
        fetch("ReviewApplicationsServlet?action=approve&applicationId=" + id, { method: "POST" })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.success) {
                    alert("Application approved successfully!");
                    loadApplications();
                } else {
                    alert("Failed to approve: " + data.message);
                }
            })
            .catch(function(err) {
                alert("Error approving application: " + err.message);
            });
    };

    window.rejectApplication = function(id) {
        if (!confirm("Are you sure you want to reject this application?")) return;

        fetch("ReviewApplicationsServlet?action=reject&applicationId=" + id, { method: "POST" })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.success) {
                    alert("Application rejected and student notified via email!");
                    loadApplications();
                } else {
                    alert("Failed to reject: " + data.message);
                }
            })
            .catch(function(err) {
                alert("Error rejecting application: " + err.message);
            });
    };
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initReviewApplications);
} else {
    initReviewApplications();
}

