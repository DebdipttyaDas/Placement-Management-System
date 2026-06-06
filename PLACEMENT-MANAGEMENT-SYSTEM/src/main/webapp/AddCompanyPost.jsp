<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Add Company Post</title>

    <link rel="stylesheet" href="AddCompanyPost.css">
    
    <script>
	       function toggleCard(button){
	
		    const card = button.closest(".job-card");
		    const viewBtn = card.querySelector(".view-btn");
		
		    card.classList.toggle("active");
		
		    if(card.classList.contains("active")){
		        viewBtn.style.display = "none";
		    }else{
		        viewBtn.style.display = "block";
		    }
		}
   </script>
    
</head>

<body>
<div class="cards-container">
       <div class="job-card">

    <h3>Software Engineering Intern</h3>
    <p>TechCorp Solutions</p>

    <div class="tags">
        <span>San Francisco, CA</span>
        <span>6 Months</span>
    </div>

    <button class="view-btn" onclick="toggleCard(this)">
        View Details
    </button>

    <div class="extra-details">

        <p><strong>Skills:</strong> Java, JSP, MySQL</p>
        <p><strong>Stipend:</strong> ₹15,000/month</p>
        <p><strong>Eligibility:</strong> B.Tech CSE</p>
        <p><strong>Last Date:</strong> 30 June 2026</p>

        <button class="apply-btn">Apply Now</button>

        <button class="close-btn" onclick="toggleCard(this)">
            Close Details
        </button>

    </div>
</div>
</div>
</body>
</html>