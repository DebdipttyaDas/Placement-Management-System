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

    fetch("FetchInterviewsServlet?all=true")
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

// =========================================================
// INIT
// =========================================================

// Load interviews on page load
loadCompanyInterviews();

// Auto-refresh every 5 seconds
setInterval(loadCompanyInterviews, 5000);

// Listen for new interview scheduled from other tabs
if ("BroadcastChannel" in window) {
    new BroadcastChannel("interview-schedule-channel").onmessage = function(e) {
        if (e.data && e.data.event === "interviewScheduled") {
            loadCompanyInterviews();
        }
    };
}
