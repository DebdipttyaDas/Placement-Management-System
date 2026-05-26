<%@ page language="java" contentType="text/html; charset=UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Placements</title>
        <link rel="stylesheet" href="Placement.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body>

        <div class="dashboard-container">

            <!-- LEFT SIDEBAR -->
            <div class="sidebar">
                <h2>Placements</h2>

                <ul>
                    <li><a href="Student_dashboard.jsp" style="text-decoration:none; color:white">Dashboard</a></li>
                    <li><a href="Placement.jsp" style="text-decoration:none; color:white">Placements</a></li>
                    <li><a href="MyApplication.jsp" style="text-decoration:none; color:white">My Applications</a></li>
                </ul>
            </div>

            <!-- TOP BAR -->
           <div class="topbar">
                
                <div style="display:flex; align-items:center; gap:30px;">
                    <i class="fa fa-user-circle" style="font-size:25px;"></i>
                    <i class="fa fa-bell" style="font-size:25px;"></i>
                </div>
            </div>

            <!-- MAIN CONTENT -->
            <div class="main">

                <!-- SEARCH BAR -->
                <div class="search-box">
                    <input type="text" placeholder="Search for job titles or companies...">
                </div>

                <!-- FILTER BUTTONS -->
                <div class="job-filters">
                    <button>All</button>
                    <button>IT</button>
                    <button>Engineering</button>
                    <button>Marketing</button>
                    <button>Medical</button>
                    <button>HR</button>
                </div>

                <!-- JOB CARDS -->
                <div class="job-cards" id="job-cards-container">
                    <!-- Jobs will be loaded here dynamically -->
                    <div style="color: #333; text-align: center; width: 100%;">Loading jobs...</div>
                </div>

            </div>

        </div>

        <!-- Chatbot -->
        <link rel="stylesheet" href="chatbot.css">

        <div id="chatbot-toggle">
            <i class="fas fa-robot"></i>
        </div>

        <div id="chatbot-container">
            <div class="chatbot-header">
                <h3>AI Assistant</h3>
                <button class="chatbot-close">&times;</button>
            </div>
            <div class="chatbot-messages">
                <!-- Messages will be added here -->
            </div>
            <div class="chatbot-input-area">
                <input type="text" class="chatbot-input" placeholder="Type your message...">
                <button class="chatbot-send">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>

        <script src="chatbot.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                fetchJobs();
            });

            function fetchJobs() {
                fetch('FetchJobsServlet')
                    .then(response => response.json())
                    .then(data => {
                        const container = document.getElementById('job-cards-container');
                        container.innerHTML = ''; // Clear loading text

                        if (data.length === 0) {
                            container.innerHTML = '<div style="color: #333; text-align: center; width: 100%;">No jobs posted yet.</div>';
                            return;
                        }

                        data.forEach(job => {
                            const card = document.createElement('div');
                            card.className = 'job-card';

                            // Using safe rendering for fields
                            card.innerHTML = `
                        <h3>${job.job_title}</h3>
                        <p class="department">${job.department}</p>
                        <div class="tags">
                            <span><i class="fa-solid fa-location-dot"></i> ${job.location_type}</span>
                            <span><i class="fa-solid fa-briefcase"></i> ${job.employment_type}</span>
                            <span><i class="fa-solid fa-money-bill-wave"></i> ${job.salary_range}</span>
                        </div>
                        <button onclick="viewJobDetails('${job.job_title}')">Apply Now</button>
                    `;
                            container.appendChild(card);
                        });
                    })
                    .catch(error => {
                        console.error('Error fetching jobs:', error);
                        document.getElementById('job-cards-container').innerHTML = '<div style="color: red; text-align: center; width: 100%;">Error loading jobs. Please try again later.</div>';
                    });
            }

            function viewJobDetails(title) {
                alert("Applying for: " + title + "\n\nIn a real scenario, this would open a modal or navigate to a details page.");
            }
        </script>

    </body>

    </html>