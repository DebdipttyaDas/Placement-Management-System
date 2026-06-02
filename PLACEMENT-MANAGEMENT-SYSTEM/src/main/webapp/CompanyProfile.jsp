<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile | ${not empty companyName ? companyName : 'Google'}</title>
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
                    <h1>${not empty companyName ? companyName : 'Google'}</h1>
                </div>
            </div>
            <div class="header-actions">
                <button class="back-btn" onclick="window.location.href='CompanyDashboard.jsp'">
                    Back to Dashboard
                </button>
                <button class="add-company-btn" onclick="openModal()">
                    <i class="fa-solid fa-plus"></i> Update Profile
                </button>
            </div>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <main class="content-wrapper">

        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-error" style="color: #ef4444; background-color: #fef2f2; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fee2e2; font-family: 'Poppins', sans-serif; font-weight: 500; display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= errorMessage %>
            </div>
        <% } %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success" style="color: #10b981; background-color: #ecfdf5; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #d1fae5; font-family: 'Poppins', sans-serif; font-weight: 500; display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-circle-check"></i> <%= successMessage %>
            </div>
        <% } %>

        <!-- OVERVIEW -->
        <section class="overview-section">
            <div class="section-header">
                <h2>Company Overview</h2>
                <div class="underline"></div>
            </div>
            <p class="description">
                <% if (request.getAttribute("companyName") != null && !request.getAttribute("companyName").equals("Google")) { %>
                    Welcome to <%= request.getAttribute("companyName") %>! We are a leading enterprise operating in the <%= request.getAttribute("industry") != null ? request.getAttribute("industry") : "industry" %> sector as a <%= request.getAttribute("companyType") != null ? request.getAttribute("companyType") : "company" %>. Our teams work continuously at the intersection of quality and innovation to deliver exceptional products and services.
                <% } else { %>
                    Google's mission is to organize the world's information and make it universally accessible and useful.
                    Since our founding in 1998, we've grown to offer products and services that help billions of people
                    around the world live better lives. From Search to YouTube, Android to Cloud, our teams work at the
                    intersection of technology and creativity to build for everyone.
                <% } %>
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
            <form action="CompanyProfileServlet" method="post">
                <div class="modal-header">
                    <h2><i class="fa-solid fa-building"></i> Add Company Details</h2>
                    <button type="button" class="modal-close-btn" onclick="closeModal()" title="Close">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>

                <div class="modal-body">

                    <!-- Basic Details -->
                    <div class="modal-section-title">Basic Details</div>
                    <div class="modal-grid">
                        <div class="input-box">
                            <label>Company Name <span class="required">*</span></label>
                            <input type="text" name="companyName" value="${companyName}" placeholder="Enter company name">
                        </div>
                        <div class="input-box">
                            <label>Industry <span class="required">*</span></label>
                            <input type="text" name="industry" value="${industry}" placeholder="Enter industry">
                        </div>
                        <div class="input-box">
                            <label>Company Type <span class="required">*</span></label>
                            <input type="text" name="companyType" value="${companyType}" placeholder="e.g. IT, Startup, MNC">
                        </div>
                        <div class="input-box">
                            <label>Company Code</label>
                            <input type="text" name="companyCode" value="${companyCode}" placeholder="Enter company code" readonly>
                        </div>
                        <div class="input-box">
                            <label>Password <span class="required">*</span></label>
                            <input type="password" name="password" placeholder="Enter password to update">
                        </div>
                    </div>

                    <!-- Contact Details -->
                    <div class="modal-section-title">Contact Details</div>
                    <div class="modal-grid">
                        <div class="input-box">
                            <label>Phone Number <span class="required">*</span></label>
                            <input type="text" name="companyPhone" value="${companyPhone}" placeholder="Enter phone number">
                        </div>
                        <div class="input-box">
                            <label>Company Email <span class="required">*</span></label>
                            <input type="email" name="companyEmail" value="${companyEmail}" placeholder="Enter company email" required>
                        </div>
                        <div class="input-box">
                            <label>Website Link <span class="required">*</span></label>
                            <input type="text" name="companyWebsite" value="${companyWebsite}" placeholder="https://www.example.com">
                        </div>
                        <div class="input-box">
                            <label>LinkedIn URL <span class="optional">(Optional)</span></label>
                            <input type="text" name="companyLinkedin" value="${companyLinkedin}" placeholder="https://linkedin.com/company/...">
                        </div>
                    </div>

                    <!-- Address Details -->
                    <div class="modal-section-title">Address Details</div>
                    <div class="modal-grid">
                        <div class="input-box">
                            <label>Company Address <span class="required">*</span></label>
                            <input type="text" name="companyAddress" value="${companyAddress}" placeholder="Enter company address">
                        </div>
                        <div class="input-box">
                            <label>City <span class="required">*</span></label>
                            <input type="text" name="city" value="${city}" placeholder="Enter city">
                        </div>
                        <div class="input-box">
                            <label>State <span class="required">*</span></label>
                            <input type="text" name="state" value="${state}" placeholder="Enter state">
                        </div>
                        <div class="input-box">
                            <label>Country <span class="required">*</span></label>
                            <input type="text" name="country" value="${country}" placeholder="Enter country">
                        </div>
                        <div class="input-box">
                            <label>Pincode <span class="required">*</span></label>
                            <input type="text" name="pincode" value="${pincode}" placeholder="Enter pincode">
                        </div>
                    </div>

                    <!-- Legal Information -->
                    <div class="modal-section-title">Legal Information</div>
                    <div class="modal-grid">
                        <div class="input-box">
                            <label>CIN <span class="required">*</span></label>
                            <input type="text" name="cin" value="${cin}" placeholder="Enter CIN">
                        </div>
                        <div class="input-box">
                            <label>Registration Number <span class="required">*</span></label>
                            <input type="text" name="registrationNum" value="${registrationNum}" placeholder="Enter registration number">
                        </div>
                        <div class="input-box">
                            <label>License Number <span class="required">*</span></label>
                            <input type="text" name="licenseNum" value="${licenseNum}" placeholder="Enter license number">
                        </div>
                        <div class="input-box">
                            <label>GST Number <span class="required">*</span></label>
                            <input type="text" name="gstNum" value="${gstNum}" placeholder="Enter GST number">
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="modal-cancel-btn" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="modal-submit-btn">Submit</button>
                </div>
            </form>

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
