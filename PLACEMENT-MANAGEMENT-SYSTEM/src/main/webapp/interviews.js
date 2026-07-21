// interviews.js
console.log("interviews.js: Script file has been loaded.");

function initInterviews() {
    console.log("interviews.js: Initializing script elements...");

    // --- DOM Elements ---
    const slotModal = document.getElementById('slotModal');
    const openSlotModalBtn = document.getElementById('openSlotModalBtn');
    const closeSlotModalBtn = document.getElementById('closeSlotModalBtn');
    const cancelModalBtn = document.getElementById('cancelModalBtn');
    const scheduleForm = document.getElementById('scheduleInterviewForm');
    const slotLoader = document.getElementById('slotLoader');
    const btnText = document.getElementById('btnText');
    const toast = document.getElementById('toast');

    const companySelect = document.getElementById('companyName');
    const studentInput = document.getElementById('studentName');
    const studentDatalist = document.getElementById('studentList');

    const typeButtons = document.querySelectorAll('.type-btn');
    const meetLinkInput = document.getElementById('meetLink');

    console.log("interviews.js: DOM elements resolved:", {
        slotModal: !!slotModal,
        openSlotModalBtn: !!openSlotModalBtn,
        closeSlotModalBtn: !!closeSlotModalBtn,
        cancelModalBtn: !!cancelModalBtn,
        scheduleForm: !!scheduleForm,
        companySelect: !!companySelect,
        studentInput: !!studentInput,
        studentDatalist: !!studentDatalist,
        meetLinkInput: !!meetLinkInput
    });

    // --- State variables ---
    let students = [];
    let selectedStudentEmail = '';
    let selectedType = 'Virtual';

    // Colors for slot card borders
    const borderColors = ['#2563eb', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899', '#3b82f6'];

    // --- Toast Helper ---
    function showToast(message, isError = false) {
        if (!toast) return;
        toast.innerText = message;
        toast.className = 'toast show';
        if (isError) {
            toast.classList.add('error');
        }
        setTimeout(() => {
            toast.classList.remove('show');
            toast.classList.remove('error');
        }, 4000);
    }

    // --- Modal Open / Close ---
    function openModal() {
        console.log("interviews.js: Opening modal...");
        if (!slotModal) {
            console.error("interviews.js: Cannot open modal, slotModal element is missing!");
            return;
        }
        slotModal.classList.add('active');
        console.log("interviews.js: Modal class 'active' added.");
        // Auto-generate meet link if Virtual is selected
        if (selectedType === 'Virtual') {
            generateMeetLink();
        }
    }

    function closeModal() {
        console.log("interviews.js: Closing modal...");
        if (!slotModal) return;
        slotModal.classList.remove('active');
        if (scheduleForm) scheduleForm.reset();
        selectedStudentEmail = '';
        // Reset type to Virtual
        setActiveType('Virtual');
    }

    if (openSlotModalBtn) {
        console.log("interviews.js: Attaching click event listener to openSlotModalBtn.");
        openSlotModalBtn.addEventListener('click', (e) => {
            e.preventDefault();
            openModal();
        });
    } else {
        console.warn("interviews.js: openSlotModalBtn not found!");
    }

    if (closeSlotModalBtn) closeSlotModalBtn.addEventListener('click', closeModal);
    if (cancelModalBtn) cancelModalBtn.addEventListener('click', closeModal);

    // Close modal when clicking outside content box
    if (slotModal) {
        slotModal.addEventListener('click', (e) => {
            if (e.target === slotModal) {
                closeModal();
            }
        });
    }

    // --- Select Interview Type ---
    function setActiveType(type) {
        selectedType = type;
        typeButtons.forEach(btn => {
            if (btn.getAttribute('data-type') === type) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        if (type === 'Virtual') {
            generateMeetLink();
        } else {
            if (meetLinkInput) {
                meetLinkInput.value = '';
                meetLinkInput.placeholder = type === 'In-person' ? 'Conference Room A, Main Block' : '+1 (555) 123-4567';
            }
        }
    }

    typeButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            setActiveType(btn.getAttribute('data-type'));
        });
    });

    function generateMeetLink() {
        if (!meetLinkInput) return;
        const chars = 'abcdefghijklmnopqrstuvwxyz';
        const p1 = Array.from({length: 3}, () => chars[Math.floor(Math.random() * chars.length)]).join('');
        const p2 = Array.from({length: 4}, () => chars[Math.floor(Math.random() * chars.length)]).join('');
        const p3 = Array.from({length: 3}, () => chars[Math.floor(Math.random() * chars.length)]).join('');
        meetLinkInput.value = `https://meet.google.com/${p1}-${p2}-${p3}`;
    }

    // --- Fetch Metadata (Companies and Students) ---
    async function loadMetadata() {
        try {
            console.log("interviews.js: Fetching metadata...");
            const response = await fetch('FetchFormMetadataServlet');
            if (!response.ok) throw new Error('Failed to load metadata');
            const data = await response.json();

            // Populate Company Select
            if (companySelect) {
                companySelect.innerHTML = '<option value="">Choose Company</option>';
                data.companies.forEach(company => {
                    const opt = document.createElement('option');
                    opt.value = company;
                    opt.textContent = company;
                    companySelect.appendChild(opt);
                });
            }

            // Store Students & Populate datalist
            students = data.students || [];
            if (studentDatalist) {
                studentDatalist.innerHTML = '';
                students.forEach(student => {
                    const opt = document.createElement('option');
                    opt.value = student.name;
                    studentDatalist.appendChild(opt);
                });
            }
            console.log("interviews.js: Metadata successfully loaded and populated.");
        } catch (error) {
            console.error('interviews.js: Metadata loading error:', error);
        }
    }

    // Track student selection and match email
    if (studentInput) {
        studentInput.addEventListener('input', () => {
            const val = studentInput.value.trim();
            const matched = students.find(s => s.name.toLowerCase() === val.toLowerCase());
            if (matched) {
                selectedStudentEmail = matched.email;
            } else {
                selectedStudentEmail = '';
            }
        });
    }

    // --- Fetch and Render Interviews ---
    async function loadAdminInterviews() {
        const container = document.getElementById('adminScheduleContainer');
        if (!container) return;

        try {
            console.log("interviews.js: Loading admin interviews list...");
            const response = await fetch('FetchInterviewsServlet?all=true');
            if (!response.ok) throw new Error('Failed to fetch interviews');
            const interviews = await response.json();

            if (interviews.length === 0) {
                container.innerHTML = `<div class="loading-text">No upcoming interviews scheduled yet. Click "Create New Slot" to begin!</div>`;
                const tr = document.getElementById('totalRoundsCount');
                if (tr) tr.textContent = '0';
                const ds = document.getElementById('dynamicStudentsList');
                if (ds) ds.innerHTML = `<div style="color: #64748b; font-size: 14px; margin-top: 10px;">None</div>`;
                const dp = document.getElementById('dynamicPanelistList');
                if (dp) dp.innerHTML = `<div style="color: #64748b; font-size: 14px; margin-top: 10px;">None</div>`;
                return;
            }

            container.innerHTML = '';

            // Map and count rounds, students, panelists
            let studentSet = new Set();
            let panelistLoad = {};

            interviews.forEach((inv, index) => {
                studentSet.add(JSON.stringify({ name: inv.student_name, email: inv.student_email || (inv.student_name.toLowerCase().replace(/\s+/g, '') + '@example.com') }));
                
                const panel = inv.interviewer_name;
                panelistLoad[panel] = (panelistLoad[panel] || 0) + 1;

                const borderColor = borderColors[index % borderColors.length];

                const slotHtml = `
                    <div class="slot">
                        <div class="time">${inv.interview_time.substring(0, 5)}</div>
                        <div class="card" style="border-left-color: ${borderColor};">
                            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                                <div>
                                    <h4 style="margin:0 0 5px; color:#1e293b; font-size:16px;">${inv.company_name}</h4>
                                    <p style="margin:0 0 10px; font-weight:600; color:#0b3d36; font-size:14px;">${inv.interview_round}</p>
                                </div>
                                <span style="font-size:12px; color:#64748b; background:#f1f5f9; padding:4px 8px; border-radius:6px; font-weight:600;">
                                    ${inv.interview_date}
                                </span>
                            </div>
                            <div style="font-size:13px; color:#475569; display:grid; gap:6px; margin-bottom:12px;">
                                <div><i class="fa-regular fa-user" style="width:18px;"></i> <b>Candidate:</b> ${inv.student_name}</div>
                                <div><i class="fa-regular fa-envelope" style="width:18px;"></i> <b>Email:</b> ${inv.student_email || 'N/A'}</div>
                                <div><i class="fa-solid fa-user-tie" style="width:18px;"></i> <b>Interviewer:</b> ${inv.interviewer_name}</div>
                                <div><i class="fa-solid fa-link" style="width:18px;"></i> <b>Meeting Link/Location:</b> <a href="${inv.meet_link}" target="_blank" style="color:#2563eb; text-decoration:none;">${inv.meet_link}</a></div>
                            </div>
                        </div>
                    </div>
                `;
                container.innerHTML += slotHtml;
            });

            // Update Total Rounds
            const tr = document.getElementById('totalRoundsCount');
            if (tr) tr.textContent = interviews.length;

            // Update Scheduled Students List
            const studentContainer = document.getElementById('dynamicStudentsList');
            if (studentContainer) {
                studentContainer.innerHTML = '';
                studentSet.forEach(sStr => {
                    const sObj = JSON.parse(sStr);
                    studentContainer.innerHTML += `
                        <div class="person">
                            <div style="font-weight:600; color:#1e293b;">${sObj.name}</div>
                            <div style="font-size:12px; color:#64748b;">${sObj.email}</div>
                        </div>
                    `;
                });
            }

            // Update Panelist Loads
            const panelistContainer = document.getElementById('dynamicPanelistList');
            if (panelistContainer) {
                panelistContainer.innerHTML = '';
                Object.keys(panelistLoad).forEach(panel => {
                    const count = panelistLoad[panel];
                    panelistContainer.innerHTML += `
                        <div class="person">
                            <div style="display:flex; justify-content:space-between; font-weight:600; color:#1e293b; margin-bottom:5px;">
                                <span>${panel}</span>
                                <span>${count} Round(s)</span>
                            </div>
                            <div class="bar" style="background:#e2e8f0; height:8px; border-radius:4px; overflow:hidden;">
                                <div style="width: ${Math.min(100, count * 20)}%; background:#0b3d36; height:100%; border-radius:4px;"></div>
                            </div>
                        </div>
                    `;
                });
            }
            console.log("interviews.js: Admin interviews loaded and rendered.");

        } catch (error) {
            console.error('interviews.js: Failed to render interviews:', error);
            container.innerHTML = `<div class="loading-text" style="color: red;">Error loading interviews. Please try again later.</div>`;
        }
    }

    // --- Form Submit via AJAX ---
    if (scheduleForm) {
        scheduleForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            console.log("interviews.js: Form submitted, preparing payload...");

            // Show Loader
            if (slotLoader) slotLoader.style.display = 'inline-block';
            if (btnText) btnText.style.display = 'none';
            const submitBtn = scheduleForm.querySelector('.create-slot-btn');
            if (submitBtn) submitBtn.disabled = true;

            const company = companySelect ? companySelect.value : '';
            const student = studentInput ? studentInput.value : '';
            const date = document.getElementById('interviewDate').value;
            const time = document.getElementById('interviewTime').value;
            const round = document.getElementById('interviewRound').value;
            const interviewer = document.getElementById('interviewerName').value;
            const link = meetLinkInput ? meetLinkInput.value : '#';

            // Find or derive email
            let studentEmail = selectedStudentEmail;
            if (!studentEmail) {
                const matched = students.find(s => s.name.toLowerCase() === student.toLowerCase());
                if (matched) {
                    studentEmail = matched.email;
                } else {
                    studentEmail = student.toLowerCase().replace(/\s+/g, '') + '@example.com';
                }
            }

            const payload = {
                company_name: company,
                interview_date: date,
                interview_time: time,
                interview_round: round,
                meet_link: link,
                student_name: student,
                student_email: studentEmail,
                interviewer_name: interviewer
            };

            try {
                const response = await fetch('ScheduleInterviewServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    const errText = await response.text();
                    throw new Error(errText || 'Failed to schedule slot');
                }

                showToast('Interview Slot Created Successfully!');
                closeModal();
                loadAdminInterviews();
            } catch (error) {
                console.error('interviews.js: Form submission error:', error);
                showToast(error.message || 'Error occurred while scheduling interview', true);
            } finally {
                if (slotLoader) slotLoader.style.display = 'none';
                if (btnText) btnText.style.display = 'inline';
                if (submitBtn) submitBtn.disabled = false;
            }
        });
    }

    // --- Initialization ---
    loadMetadata();
    loadAdminInterviews();
}

// Robust execution trigger
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        console.log("interviews.js: DOMContentLoaded event triggered.");
        initInterviews();
    });
} else {
    console.log("interviews.js: Document is already ready, initializing directly.");
    initInterviews();
}
