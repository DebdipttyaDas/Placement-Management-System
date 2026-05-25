<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile | Google</title>

    <!-- CSS -->
    <link rel="stylesheet" href="CompanyProfile.css">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

    <!-- HERO SECTION -->
    <div class="hero-container">

        <!-- Background Animated Images -->
        <div class="hero-split">

            <img src="https://img.freepik.com/premium-photo/teamwork-group-colleagues-using-laptop-together-collaboration-new-project-modern-office-diversity-idea-businesspeople-meeting-having-conversation-work_590464-206570.jpg"
                 alt="Team Conversation"
                 class="hero-img">

            <img src="https://cms.k2space.co.uk/app/uploads/2023/06/K2-Criteo-Office-Curator-LARGE-102-scaled.jpg"
                 alt="Modern Workspace"
                 class="hero-img">

        </div>

        <div class="overlay"></div>

        <!-- COMPANY INFO BAR -->
        <div class="company-info-bar">

            <div class="left-info">

                <div class="logo-box">

                    <img src="https://cdn-icons-png.flaticon.com/512/300/300221.png"
                         alt="Google Logo">

                </div>

                <div class="company-text">

                    <h1>Google</h1>
                </div>

            </div>

            <div class="header-actions">

                <button class="back-btn"
                        onclick="window.location.href='CompanyDashboard.jsp'">
                    Back to Dashboard
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

                    <div class="icon-circle blue">
                        <i class="fa-solid fa-heart-pulse"></i>
                    </div>

                    <h3>Health & Wellness</h3>

                    <p>
                        Comprehensive medical, dental, and vision insurance for you and your family.
                    </p>

                </div>

                <div class="benefit-card">

                    <div class="icon-circle red">
                        <i class="fa-solid fa-utensils"></i>
                    </div>

                    <h3>Gourmet Meals</h3>

                    <p>
                        Fuel your day with free, healthy, and delicious meals prepared by onsite chefs.
                    </p>

                </div>

                <div class="benefit-card">

                    <div class="icon-circle yellow">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>

                    <h3>Learning & Growth</h3>

                    <p>
                        Tuition reimbursement and internal programs to help you master new skills.
                    </p>

                </div>

                <div class="benefit-card">

                    <div class="icon-circle green">
                        <i class="fa-solid fa-couch"></i>
                    </div>

                    <h3>Flexible Work</h3>

                    <p>
                        Hybrid work models and generous time off to ensure a healthy work-life balance.
                    </p>

                </div>

            </div>
            
            <br>
            <br>
            
        </section>

<!-- COMPANY DATABASE SECTION -->
<section class="company-section">

    <div class="section-title">

        <h2>Company Database System</h2>

        <p>
            Manage company registration, contact information,
            address details, and legal records efficiently.
        </p>

    </div>

    <div class="card-container">

        <!-- CARD 1 -->
        <div class="company-card">

            <div class="card-header">
                <h3>Register Table</h3>
            </div>

            <div class="card-body">

                <div class="input-box">
                    <label>Company Name</label>
                    <input type="text" placeholder="Enter company name">
                </div>

                <div class="input-box">
                    <label>Company Code</label>
                    <input type="text" placeholder="Enter company code">
                </div>

                <div class="input-box">
                    <label>Industry</label>
                    <input type="text" placeholder="Enter industry">
                </div>

                <div class="input-box">
                    <label>Company Type</label>
                    <input type="text" placeholder="Enter company type">
                </div>

                <div class="input-box">
                    <label>Company Email</label>
                    <input type="email" placeholder="Enter email">
                </div>

                <div class="input-box">
                    <label>Password</label>
                    <input type="password" placeholder="Enter password">
                </div>

            </div>

        </div>

        <!-- CARD 2 -->
        <div class="company-card">

            <div class="card-header">
                <h3>Contact Details</h3>
            </div>

            <div class="card-body">

<div class="input-box">
                    <label>Company ID</label>
                    <input type="text" placeholder="Enter company ID">
                </div>

                <div class="input-box">
                    <label>Phone Number</label>
                    <input type="text" placeholder="Enter phone number">
                </div>

                <div class="input-box">
                    <label>Website Link</label>
                    <input type="text" placeholder="Enter website link">
                </div>

            </div>

        </div>

        <!-- CARD 3 -->
        <div class="company-card">

            <div class="card-header">
                <h3>Address Details</h3>
            </div>

            <div class="card-body">

                <div class="input-box">
                    <label>Company Address</label>
                    <input type="text" placeholder="Enter address">
                </div>

                <div class="input-box">
                    <label>City</label>
                    <input type="text" placeholder="Enter city">
                </div>

                <div class="input-box">
                    <label>State</label>
                    <input type="text" placeholder="Enter state">
                </div>

                <div class="input-box">
                    <label>Country</label>
                    <input type="text" placeholder="Enter country">
                </div>

                <div class="input-box">
                    <label>Pincode</label>
                    <input type="text" placeholder="Enter pincode">
                </div>

            </div>

        </div>

        <!-- CARD 4 -->
        <div class="company-card">

            <div class="card-header">
                <h3>Legal Information</h3>
            </div>

            <div class="card-body">

                <div class="input-box">
                    <label>Registration Number</label>
                    <input type="text" placeholder="Enter registration number">
                </div>

                <div class="input-box">
                    <label>PAN Number</label>
                    <input type="text" placeholder="Enter PAN number">
                </div>

                <div class="input-box">
                    <label>License Number</label>
                    <input type="text" placeholder="Enter license number">
                </div>

            </div>

        </div>

    </div>

      <div class="action-bar-buttons">
    <button class="btn-update">Update Details</button>
    <button class="btn-save">Save Changes</button>
  </div>
</div>

</section>
      

            <!-- BACK TO TOP -->
            <button id="backToTop" title="Go to top">

                <i class="fa-solid fa-arrow-up"></i>

            </button>

    </main>

    <!-- JAVASCRIPT -->

    <script>
    const btn = document.getElementById('backToTop');
    btn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
</script>

<script>
    const backBtn = document.getElementById('backToTop');

    // Monitor scroll to show/hide button
    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 400) { // Shows button after 400px of scrolling
            backBtn.style.display = 'flex';
        } else {
            backBtn.style.display = 'none';
        }
    });

    // Smooth scroll execution
    backBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>
    
</body>
</html>