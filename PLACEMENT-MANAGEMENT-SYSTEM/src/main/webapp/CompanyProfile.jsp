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
                    <p>Technology & Innovation • Mountain View, CA</p>

                </div>

            </div>

            <div class="header-actions">

                <button class="back-btn"
                        onclick="window.location.href='CompanyDashboard.jsp'">
                    Back to Dashboard
                </button>

                <button class="follow-btn">
                    + Follow Company
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

            <div class="info-cards">

                <div class="card">

                    <i class="fa-solid fa-location-dot"></i>

                    <h4>HEADQUARTERS</h4>

                    <p>Mountain View, CA, USA</p>

                </div>

                <div class="card">

                    <i class="fa-solid fa-building"></i>

                    <h4>INDUSTRY</h4>

                    <p>Technology & Innovation</p>
                    <p>AI, Cloud Computing, IT Services</p>

                </div>

                <div class="card">

                    <i class="fa-solid fa-users"></i>

                    <h4>OUR COMPANY</h4>

                    <p>10,000+ Employees</p>

                </div>

            </div>

        </section>

        <!-- CULTURE -->
        <section class="culture-section">

            <div class="section-header">

                <h2>Culture & Life</h2>
                <div class="underline"></div>

            </div>

            <div class="culture-grid">

                <img src="https://images.unsplash.com/photo-1497366754035-f200968a6e72?q=80&w=1200&auto=format&fit=crop"
                     alt="Office Culture">

                <img src="https://images.unsplash.com/photo-1524758631624-e2822e304c36?q=80&w=1200&auto=format&fit=crop"
                     alt="Workspace Design">

            </div>

            <div class="culture-text">

                <p>
                    We believe that being at our best starts with being ourselves.
                    Our culture is built on <strong>“Googleness”</strong>—a combination of humility,
                    curiosity, and a drive to do big things.We foster a work-hard, 
                    play-hard environment where innovation happens in micro-kitchens and high-tech labs alike.
                </p>

                <p>
                    Our employees are encouraged to spend 20% of their time on passion
                    projects, leading to breakthroughs that change the world.
                </p>

            </div>

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
            
            <p>Investing in our people is the most important investment we make. We offer a holistic suite of benefits designed to support your physical, emotional, and financial wellbeing. From top-tier healthcare and mental health support to onsite wellness centers and gourmet micro-kitchens, we ensure you have everything you need to perform at your peak. Beyond the office, our generous leave policies and family-support programs mean that your life outside of work is just as prioritized as your life within it.</p>

        </section>

        <!-- NEWS SECTION -->
        <section class="news-section">

            <div class="section-title">

                <h2>Latest News & Events</h2>

                <p>
                    Stay updated with our newest innovations,company events,
                    internship programs, and technology breakthroughs.
                </p>

            </div>

            <div class="news-container">

                <!-- CARD 1 -->
                <div class="news-card">

                    <div class="news-image">

                        <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1200&auto=format&fit=crop"
                             alt="AI Event">

                    </div>

                    <div class="news-content">

                        <span class="news-date">May 2026</span>

                        <h3>AI Innovation Summit 2026</h3>

                        <p>
                        Our annual AI summit brought together engineers,
                    <br>
                    researchers, and innovators to discuss the future
                    <br>
                    of artificial intelligence.
                </p>

                        <a href="#">Apply Now</a>

                    </div>

                </div>

                <!-- CARD 2 -->
                <div class="news-card">

                    <div class="news-image">

                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=1200&auto=format&fit=crop"
                             alt="Internship Program">

                    </div>

                    <div class="news-content">

                        <span class="news-date">April 2026</span>

                        <h3>Summer Internship Program Open</h3>

                        <p>
                            Applications are now open for students passionate
                            <br>
                            about software engineering and AI,cloud computing.
                            <br>
                            and UI/UX design.
                        </p>

                        <a href="#">Apply Now</a>

                    </div>

                </div>
<!-- CARD 3 -->
<div class="news-card">

    <div class="news-image">
        <img src="https://images.unsplash.com/photo-1511578314322-379afb476865?q=80&w=1200&auto=format&fit=crop" alt="Tech Conference">
    </div>

    <div class="news-content">

        <span class="news-date">February 2026</span>

        <h3>
            Global Tech Conference & Hackathon
        </h3>

        <p>
            Developers, designers, and innovators from around the world
            joined our 48-hour hackathon to create impactful solutions
            powered by AI and cloud technologies.
        </p>

        <a href="#">
            View Highlights
        </a>

    </div>

</div>

<!-- CARD 4 -->
        <div class="news-card">

            <div class="news-image">
                <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=1200&auto=format&fit=crop" alt="Cloud Computing">
            </div>

            <div class="news-content">

                <span class="news-date">March 2026</span>

                <h3>
                    Next-Gen Cloud Infrastructure
                </h3>

                <p>
                    We are excited to announce the launch of our sustainable 
                    data centers, reducing carbon footprints while increasing 
                    processing speeds for global enterprises.
                </p>

                <a href="#">
                    Explore Tech
                </a>

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