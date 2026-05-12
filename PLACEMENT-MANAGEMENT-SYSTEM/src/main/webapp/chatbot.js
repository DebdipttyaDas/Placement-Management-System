// Chatbot JavaScript
document.addEventListener('DOMContentLoaded', function() {
    const toggleBtn = document.getElementById('chatbot-toggle');
    const container = document.getElementById('chatbot-container');
    const closeBtn = document.querySelector('.chatbot-close');
    const messagesDiv = document.querySelector('.chatbot-messages');
    const input = document.querySelector('.chatbot-input');
    const sendBtn = document.querySelector('.chatbot-send');

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
        // Get user ID from session or local storage if available
        // For now, return a placeholder until DB/session data is connected
        return 'user123';
    }

    // Welcome message
    setTimeout(() => {
        addMessage('Hello! I\'m your AI assistant. How can I help you today? I can analyze resumes, conduct mock interviews, or answer questions about placements.', 'bot');
    }, 1000);
});