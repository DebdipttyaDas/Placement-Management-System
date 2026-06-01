<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile | Google</title>
    <link rel="stylesheet" href="CompanyProfile.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

    <!-- HERO SECTION -->
    <div class="hero-container">
        <div class="hero-split">
            <img src="https://img.freepik.com/premium-photo/teamwork-group-colleagues-using-laptop-together-collaboration-new-project-modern-office-diversity-idea-businesspeople-meeting-having-conversation-work_590464-206570.jpg"
                 alt="Team Conversation" class="hero-img">
            <img src="https://cms.k2space.co.uk/app/uploads/2023/06/K2-Criteo-Office-Curator-LARGE-102-scaled.jpg"
                 alt="Modern Workspace" class="hero-img">
        </div>
        <div class="overlay"></div>
        <div class="company-info-bar">
            <div class="left-info">
                <div class="logo-box">
                    <img src="https://cdn-icons-png.flaticon.com/512/300/300221.png" alt="Google Logo">
                </div>
                <div class="company-text">
                    <h1>Google</h1>
                </div>
            </div>
            <div class="header-actions">
                <button class="back-btn" onclick="window.location.href='CompanyDashboard.jsp'">
                    Back to Dashboard
                </button>
                <button class="add-company-btn" onclick="openModal()">
                    <i class="fa-solid fa-plus"></i> Add Company
                </button>
            </div>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <main class="content-wrapper">

        <!-- OVERVIEW -->
        <section class="overview-section">
            <div class="section-header">
                <h2>Company Overview</h2>
                <div class="underline"></div>
            </div>
            <p class="description">
                Google's mission is to organize the world's information and make it universally accessible and useful.
                Since our founding in 1998, we've grown to offer products and services that help billions of people
                around the world live better lives. From Search to YouTube, Android to Cloud, our teams work at the
                intersection of technology and creativity to build for everyone.
            </p>
        </section>

        <!-- BENEFITS -->
        <section class="benefits-section">
            <div class="section-header">
                <h2>Benefits & Perks</h2>
                <div class="underline"></div>
            </div>
            <div class="benefits-grid">
                <div class="benefit-card">
                    <div class="icon-circle blue"><i class="fa-solid fa-heart-pulse"></i></div>
                    <h3>Health & Wellness</h3>
                    <p>Comprehensive medical, dental, and vision insurance for you and your family.</p>
                </div>
                <div class="benefit-card">
                    <div class="icon-circle red"><i class="fa-solid fa-utensils"></i></div>
                    <h3>Gourmet Meals</h3>
                    <p>Fuel your day with free, healthy, and delicious meals prepared by onsite chefs.</p>
                </div>
                <div class="benefit-card">
                    <div class="icon-circle yellow"><i class="fa-solid fa-graduation-cap"></i></div>
                    <h3>Learning & Growth</h3>
                    <p>Tuition reimbursement and internal programs to help you master new skills.</p>
                </div>
                <div class="benefit-card">
                    <div class="icon-circle green"><i class="fa-solid fa-couch"></i></div>
                    <h3>Flexible Work</h3>
                    <p>Hybrid work models and generous time off to ensure a healthy work-life balance.</p>
                </div>
            </div>
            <br><br>
        </section>

        <!-- BACK TO TOP -->
        <button id="backToTop" title="Go to top">
            <i class="fa-solid fa-arrow-up"></i>
        </button>

    </main>


    <!-- ====================================================
         MODAL OVERLAY — Company Details Form
    ===================================================== -->
    <div class="modal-overlay" id="companyModal" onclick="handleOverlayClick(event)">
        <div class="modal-box">

            <div class="modal-header">
                <h2><i class="fa-solid fa-building"></i> Add Company Details</h2>
                <button class="modal-close-btn" onclick="closeModal()" title="Close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <div class="modal-body">

                <!-- Basic Details -->
                <div class="modal-section-title">Basic Details</div>
                <div class="modal-grid">
                    <div class="input-box">
                        <label>Company Name <span class="required">*</span></label>
                        <input type="text" placeholder="Enter company name">
                    </div>
                    <div class="input-box">
                        <label>Industry <span class="required">*</span></label>
                        <input type="text" placeholder="Enter industry">
                    </div>
                    <div class="input-box">
                        <label>Company Type <span class="required">*</span></label>
                        <input type="text" placeholder="e.g. IT, Startup, MNC">
                    </div>
                    <div class="input-box">
                        <label>Company Code</label>
                        <input type="text" placeholder="Enter company code">
                    </div>
                    <div class="input-box">
                        <label>Password <span class="required">*</span></label>
                        <input type="password" placeholder="Enter password">
                    </div>
                </div>

                <!-- Contact Details -->
                <div class="modal-section-title">Contact Details</div>
                <div class="modal-grid">
                    <div class="input-box">
                        <label>Phone Number <span class="required">*</span></label>
                        <input type="text" placeholder="Enter phone number">
                    </div>
                    <div class="input-box">
                        <label>Company Email</label>
                        <input type="email" placeholder="Enter company email">
                    </div>
                    <div class="input-box">
                        <label>Website Link <span class="required">*</span></label>
                        <input type="text" placeholder="https://www.example.com">
                    </div>
                    <div class="input-box">
                        <label>LinkedIn URL <span class="optional">(Optional)</span></label>
                        <input type="text" placeholder="https://linkedin.com/company/...">
                    </div>
                    <div class="input-box">
                        <label>Alternate Phone <span class="optional">(Optional)</span></label>
                        <input type="text" placeholder="Enter alternate phone number">
                    </div>
                </div>

                <!-- Address Details -->
                <div class="modal-section-title">Address Details</div>
                <div class="modal-grid">
                    <div class="input-box">
                        <label>Company Address <span class="required">*</span></label>
                        <input type="text" placeholder="Enter company address">
                    </div>
                    <div class="input-box">
                        <label>City <span class="required">*</span></label>
                        <input type="text" placeholder="Enter city">
                    </div>
                    <div class="input-box">
                        <label>State <span class="required">*</span></label>
                        <input type="text" placeholder="Enter state">
                    </div>
                    <div class="input-box">
                        <label>Country <span class="required">*</span></label>
                        <input type="text" placeholder="Enter country">
                    </div>
                    <div class="input-box">
                        <label>Pincode <span class="required">*</span></label>
                        <input type="text" placeholder="Enter pincode">
                    </div>
                </div>

                <!-- Legal Information -->
                <div class="modal-section-title">Legal Information</div>
                <div class="modal-grid">
                    <div class="input-box">
                        <label>CIN <span class="required">*</span></label>
                        <input type="text" placeholder="Enter CIN">
                    </div>
                    <div class="input-box">
                        <label>Registration Number <span class="required">*</span></label>
                        <input type="text" placeholder="Enter registration number">
                    </div>
                    <div class="input-box">
                        <label>License Number <span class="required">*</span></label>
                        <input type="text" placeholder="Enter license number">
                    </div>
                    <div class="input-box">
                        <label>GST Number <span class="required">*</span></label>
                        <input type="text" placeholder="Enter GST number">
                    </div>
                    <div class="input-box">
                        <label>PAN Number <span class="required">*</span></label>
                        <input type="text" placeholder="Enter PAN number">
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button class="modal-cancel-btn" onclick="closeModal()">Cancel</button>
                <button class="modal-submit-btn">Submit</button>
            </div>

        </div>
    </div>


</body>
</html>

<script>
    function openModal() {
        const modal = document.getElementById('companyModal');
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        const modal = document.getElementById('companyModal');
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }

    function handleOverlayClick(e) {
        if (e.target === document.getElementById('companyModal')) {
            closeModal();
        }
    }

    // Close on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });

    // Back to top button
    window.addEventListener('scroll', function() {
        const btn = document.getElementById('backToTop');
        btn.style.display = window.scrollY > 300 ? 'flex' : 'none';
    });
    document.getElementById('backToTop').addEventListener('click', function() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
</script>
</body>
</html>
