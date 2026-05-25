// Chatbot JavaScript
document.addEventListener('DOMContentLoaded', function() {
    const toggleBtn = document.getElementById('chatbot-toggle');
    const container = document.getElementById('chatbot-container');
    const closeBtn = document.querySelector('.chatbot-close');
    const messagesDiv = document.querySelector('.chatbot-messages');
    const input = document.querySelector('.chatbot-input');
    const sendBtn = document.querySelector('.chatbot-send');

    // Inject SVG icons dynamically to match requested design and eliminate FontAwesome dependency
    if (toggleBtn) {
        toggleBtn.innerHTML = `
            <svg class="chatbot-toggle-svg" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <defs>
                <linearGradient id="bubbleGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#0d6e60" />
                  <stop offset="100%" stop-color="#85ffd5" />
                </linearGradient>
                <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
                  <feGaussianBlur stdDeviation="2.5" result="blur" />
                  <feComposite in="SourceGraphic" in2="blur" operator="over" />
                </filter>
              </defs>
              <!-- Speech Bubble Outline with Glow -->
              <path d="M50 12 C25 12 8 28 8 50 C8 63 15 75 26 82 L22 94 L37 87 C41 88 45 88 50 88 C75 88 92 72 92 50 C92 28 75 12 50 12 Z" 
                    fill="none" stroke="url(#bubbleGrad)" stroke-width="5.5" filter="url(#glow)" />
              
              <!-- Antenna -->
              <line x1="50" y1="32" x2="50" y2="20" stroke="#ffffff" stroke-width="3" stroke-linecap="round" />
              <circle cx="50" cy="18" r="4.5" fill="#85ffd5" filter="url(#glow)" />
              
              <!-- Robot Head (white helmet) -->
              <rect x="27" y="32" width="46" height="34" rx="17" fill="#ffffff" />
              
              <!-- Visor (dark screen) -->
              <rect x="32" y="37" width="36" height="24" rx="12" fill="#06473e" />
              
              <!-- Eyes -->
              <circle cx="43" cy="47" r="3.5" fill="#85ffd5" filter="url(#glow)" />
              <circle cx="57" cy="47" r="3.5" fill="#85ffd5" filter="url(#glow)" />
              
              <!-- Smile -->
              <path d="M 46 53 Q 50 57 54 53" fill="none" stroke="#85ffd5" stroke-width="1.8" stroke-linecap="round" />
              
              <!-- Body/Shoulders (white) -->
              <path d="M 31 70 C 31 70 33 83 50 83 C 67 83 69 70 69 70 Z" fill="#ffffff" />
              
              <!-- Tie (dark green) -->
              <polygon points="47,68 53,68 54,78 50,83 46,78" fill="#06473e" />
              
              <!-- Collar / Shirt Neck Cutout -->
              <polygon points="44,65 50,71 56,65" fill="#06473e" />
              <polygon points="44,65 50,71 56,65" fill="none" stroke="#ffffff" stroke-width="1" />
            </svg>
        `;
    }

    if (sendBtn) {
        sendBtn.innerHTML = `
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <line x1="22" y1="2" x2="11" y2="13"></line>
              <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
            </svg>
        `;
    }

    // Toggle chatbot
    toggleBtn.addEventListener('click', () => {
        container.classList.toggle('active');
    });

    closeBtn.addEventListener('click', () => {
        container.classList.remove('active');
    });

    // Send message
    function sendMessage() {
        const message = input.value.trim();
        if (!message) return;

        // Add user message
        addMessage(message, 'user');
        input.value = '';

        // Show typing indicator
        showTypingIndicator();

        // Send to server
        fetch('ChatbotServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                query: message,
                message: message,
                userType: getUserType(),
                userId: getUserId(),
                pageName: getPageName(),
                pageUrl: window.location.href,
                pageTitle: document.title || getPageName(),
                timestamp: new Date().toISOString()
            })
        })
        .then(response => response.json())
        .then(data => {
            hideTypingIndicator();
            if (data.success !== false) {
                addMessage(data.response || data.message || 'Sorry, I couldn\'t process that.', 'bot');
            } else {
                addMessage(data.message || 'Error occurred.', 'bot');
            }
        })
        .catch(error => {
            hideTypingIndicator();
            addMessage('Sorry, there was an error. Please try again.', 'bot');
            console.error('Chatbot error:', error);
        });
    }

    sendBtn.addEventListener('click', sendMessage);
    input.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    function addMessage(text, type) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}`;
        messageDiv.textContent = text;
        messagesDiv.appendChild(messageDiv);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    function showTypingIndicator() {
        const indicator = document.createElement('div');
        indicator.className = 'typing-indicator';
        indicator.innerHTML = `
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
        `;
        messagesDiv.appendChild(indicator);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    function hideTypingIndicator() {
        const indicator = document.querySelector('.typing-indicator');
        if (indicator) {
            indicator.remove();
        }
    }

    function getUserType() {
        const path = window.location.pathname.toLowerCase();
        if (path.includes('admindashboard') || path.includes('adminprofile')) return 'admin';
        if (path.includes('companydashboard') || path.includes('companyprofile')) return 'company';
        if (path.includes('student_dashboard') || path.includes('studentprofile') || path.includes('myapplication')) return 'student';
        return 'guest';
    }

    // Set page title / name for backend context
    function getPageName() {
        const path = window.location.pathname.toLowerCase();
        if (path.includes('admindashboard')) return 'Admin Dashboard';
        if (path.includes('adminprofile')) return 'Admin Profile';
        if (path.includes('companydashboard')) return 'Company Dashboard';
        if (path.includes('companyprofile')) return 'Company Profile';
        if (path.includes('interviews')) return 'Interviews';
        if (path.includes('jobpost')) return 'Job Post';
        if (path.includes('placementanalysis')) return 'Placement Analysis';
        if (path.includes('student_dashboard')) return 'Student Dashboard';
        if (path.includes('studentprofile')) return 'Student Profile';
        if (path.includes('myapplication')) return 'My Application';
        if (path.includes('contact')) return 'Contact';
        if (path.includes('about')) return 'About';
        if (path.includes('terms')) return 'Terms';
        return document.title || path.substring(path.lastIndexOf('/') + 1) || 'Unknown Page';
    }

    function getUserId() {
        // Try to read user email or ID from the session if injected into window object
        if (window.studentEmail) return window.studentEmail;
        if (window.companyEmail) return window.companyEmail;
        if (window.adminEmail) return window.adminEmail;
        return 'user123';
    }

    // Welcome message
    setTimeout(() => {
        addMessage('Hello! I\'m your AI assistant. How can I help you today? I can analyze resumes, conduct mock interviews, or answer questions about placements.', 'bot');
    }, 1000);
});