// Chatbot functionality
let isChatbotOpen = false;

function toggleChatbot() {
  const panel = document.getElementById('chatbotPanel');
  isChatbotOpen = !isChatbotOpen;

  if (isChatbotOpen) {
    panel.classList.add('show');
    document.getElementById('chatbotInput').focus();
  } else {
    panel.classList.remove('show');
  }
}

function sendMessage() {
  const input = document.getElementById('chatbotInput');
  const message = input.value.trim();

  if (message === '') return;

  // Add user message
  addMessage(message, 'user');
  input.value = '';

  // Simulate bot response
  setTimeout(() => {
    const botResponse = getBotResponse(message);
    addMessage(botResponse, 'bot');
  }, 1000);
}

function addMessage(content, type) {
  const messagesContainer = document.getElementById('chatbotMessages');
  const messageDiv = document.createElement('div');
  messageDiv.className = `chatbot-message ${type}-message`;

  const contentDiv = document.createElement('div');
  contentDiv.className = 'message-content';

  if (type === 'bot') {
    contentDiv.innerHTML = `<i class="bi bi-bluesky me-1"></i>${content}`;
  } else {
    contentDiv.textContent = content;
  }

  messageDiv.appendChild(contentDiv);
  messagesContainer.appendChild(messageDiv);

  // Scroll to bottom
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function getBotResponse(userMessage) {
  const message = userMessage.toLowerCase();

  // Simple response logic
  if (message.includes('hello') || message.includes('hi') || message.includes('hey')) {
    return "Hello! I'm here to help you with your ticketing system. How can I assist you today?";
  } else if (message.includes('ticket') || message.includes('create')) {
    return "To create a new ticket, go to the Tickets section and click 'New Ticket'. You'll need to provide the subject, description, and select a contact.";
  } else if (message.includes('company') || message.includes('companies')) {
    return "You can manage companies in the Companies section. From there you can view, edit, or create new companies and their contacts.";
  } else if (message.includes('contact') || message.includes('contacts')) {
    return "Contacts are managed in the Contacts section. Each contact belongs to a company and can have multiple tickets.";
  } else if (message.includes('status') || message.includes('priority')) {
    return "Tickets have different statuses (New, Open, Pending, Resolved, Closed) and priorities (Low, Normal, High). You can update these in the ticket details.";
  } else if (message.includes('help') || message.includes('support')) {
    return "I can help you with: creating tickets, managing companies and contacts, understanding ticket statuses, and navigating the system. What would you like to know?";
  } else if (message.includes('dashboard') || message.includes('overview')) {
    return "The dashboard shows you an overview of all tickets, their statuses, priorities, and recent activity. It's your main control center!";
  } else if (message.includes('email') || message.includes('mail')) {
    return "You can send emails directly from ticket pages using the 'Send Mail' button. This helps you communicate with customers about their tickets.";
  } else {
    return "I'm here to help! You can ask me about tickets, companies, contacts, or how to use the system. What would you like to know?";
  }
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
  const input = document.getElementById('chatbotInput');
  const sendButton = document.querySelector('.chatbot-input button');

  if (input) {
    input.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        sendMessage();
      }
    });
  }

  if (sendButton) {
    sendButton.addEventListener('click', sendMessage);
  }

  // Close chatbot when clicking outside
  document.addEventListener('click', function(e) {
    const chatbotWidget = document.querySelector('.chatbot-widget');
    const chatbotPanel = document.getElementById('chatbotPanel');

    if (isChatbotOpen &&
        !chatbotWidget.contains(e.target) &&
        chatbotPanel.classList.contains('show')) {
      toggleChatbot();
    }
  });
});
