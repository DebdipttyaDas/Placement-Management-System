// Validate deadline on page load and when changed
window.addEventListener('load', function() {
    validateDeadline();
    // Check deadline every minute to update button status
    setInterval(validateDeadline, 60000);
});

// Validate deadline and disable button if passed
function validateDeadline() {
    const deadlineInput = document.getElementById("applicationDeadline");
    const publishBtn = document.getElementById("publishBtn");
    const deadlineMessage = document.getElementById("deadlineMessage");
    const buttonMessage = document.getElementById("buttonMessage");
    
    if (!deadlineInput.value) {
        publishBtn.disabled = false;
        deadlineMessage.style.display = "none";
        buttonMessage.style.display = "none";
        return true;
    }
    
    // Parse the selected date
    const selectedDate = new Date(deadlineInput.value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    // Check if deadline has passed
    if (selectedDate < today) {
        publishBtn.disabled = true;
        deadlineMessage.textContent = "⚠️ Deadline has passed. Please select a future date.";
        deadlineMessage.style.display = "block";
        buttonMessage.textContent = "Cannot publish: Application deadline has already ended.";
        buttonMessage.style.display = "block";
        publishBtn.style.opacity = "0.5";
        publishBtn.style.cursor = "not-allowed";
        return false;
    } else {
        publishBtn.disabled = false;
        deadlineMessage.style.display = "none";
        buttonMessage.style.display = "none";
        publishBtn.style.opacity = "1";
        publishBtn.style.cursor = "pointer";
        return true;
    }
}

// Validate entire form before submission
function validateForm() {
    const jobTitle = document.getElementById("jobTitle").value.trim();
    const deadline = document.getElementById("applicationDeadline").value;
    const publishBtn = document.getElementById("publishBtn");
    
    // Check if button is disabled
    if (publishBtn.disabled) {
        alert("❌ Cannot publish job: Application deadline has passed. Please select a future date.");
        return false;
    }
    
    // Validate required fields
    if (!jobTitle) {
        alert("⚠️ Job Title is required!");
        document.getElementById("jobTitle").focus();
        return false;
    }
    
    if (!deadline) {
        alert("⚠️ Application Deadline is required!");
        document.getElementById("applicationDeadline").focus();
        return false;
    }
    
    const jobDesc = document.querySelector(".editor").innerHTML.trim();
    if (!jobDesc) {
        alert("⚠️ Job Description is required!");
        return false;
    }
    
    return true;
}

function prepareSubmit() {
    // Validate before preparing
    if (!validateForm()) {
        return false;
    }
    document.getElementById("hiddenJobDesc").value = document.querySelector(".editor").innerHTML;
    return true;
}

function formatText(command){
    document.execCommand(command, false, null);
}

function addLink(){
    let url = prompt("Enter URL:");
    if(url){
        document.execCommand("createLink", false, url);
    }
}
/**
 * 
 */