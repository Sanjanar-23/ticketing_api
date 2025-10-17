class Chatbot {
  constructor() {
    this.sessionId = this.generateSessionId();
    this.isOpen = false;
    this.isTyping = false;

    this.initializeElements();
    this.bindEvents();
    this.loadChatHistory();
  }

  initializeElements() {
    this.widget = document.getElementById('chatbot-widget');
    this.toggle = document.getElementById('chatbot-toggle');
    this.panel = document.getElementById('chatbot-panel');
    this.closeBtn = document.getElementById('chatbot-close');
    this.messagesContainer = document.getElementById('chatbot-messages');
    this.inputField = document.getElementById('chatbot-input-field');
    this.sendBtn = document.getElementById('chatbot-send');
  }

  bindEvents() {
    this.toggle.addEventListener('click', () => this.togglePanel());
    this.closeBtn.addEventListener('click', () => this.closePanel());
    this.sendBtn.addEventListener('click', () => this.sendMessage());
    this.inputField.addEventListener('keypress', (e) => {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        this.sendMessage();
      }
    });

    // Close panel when clicking outside
    document.addEventListener('click', (e) => {
      if (this.isOpen && !this.widget.contains(e.target)) {
        this.closePanel();
      }
    });
  }

  generateSessionId() {
    return 'chatbot_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }

  togglePanel() {
    if (this.isOpen) {
      this.closePanel();
    } else {
      this.openPanel();
    }
  }

  openPanel() {
    this.panel.classList.add('active');
    this.isOpen = true;
    this.inputField.focus();
    this.scrollToBottom();
  }

  closePanel() {
    this.panel.classList.remove('active');
    this.isOpen = false;
  }

  async sendMessage() {
    const message = this.inputField.value.trim();
    if (!message || this.isTyping) return;

    // Add user message to UI
    this.addMessage(message, 'user');
    this.inputField.value = '';

    // Show typing indicator
    this.showTypingIndicator();

    try {
      const response = await fetch('/chatbots', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
          chatbot: {
            message: message,
            session_id: this.sessionId
          }
        })
      });

      const data = await response.json();

      if (data.success) {
        // Remove typing indicator
        this.hideTypingIndicator();

        // Add bot response to UI
        this.addMessage(data.bot_response.message, 'bot', data.bot_response.id);
      } else {
        this.hideTypingIndicator();
        this.addMessage('Sorry, I encountered an error. Please try again.', 'bot');
      }
    } catch (error) {
      console.error('Chatbot error:', error);
      this.hideTypingIndicator();
      this.addMessage('Sorry, I\'m having trouble connecting. Please try again later.', 'bot');
    }
  }

  addMessage(message, type, messageId = null) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `chatbot-message ${type}-message`;

    const contentDiv = document.createElement('div');
    contentDiv.className = 'message-content';

    if (type === 'bot') {
      contentDiv.innerHTML = `<i class="fas fa-robot me-2"></i>${this.formatMessage(message)}`;
    } else {
      contentDiv.textContent = message;
    }

    const timeDiv = document.createElement('div');
    timeDiv.className = 'message-time';
    timeDiv.textContent = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    messageDiv.appendChild(contentDiv);
    messageDiv.appendChild(timeDiv);

    // Add feedback buttons for bot messages
    if (type === 'bot' && messageId) {
      const feedbackDiv = document.createElement('div');
      feedbackDiv.className = 'message-feedback';
      feedbackDiv.innerHTML = `
        <button class="feedback-btn" onclick="chatbot.giveFeedback(${messageId}, true)">
          <i class="fas fa-thumbs-up"></i> Helpful
        </button>
        <button class="feedback-btn" onclick="chatbot.giveFeedback(${messageId}, false)">
          <i class="fas fa-thumbs-down"></i> Not helpful
        </button>
      `;
      messageDiv.appendChild(feedbackDiv);
    }

    this.messagesContainer.appendChild(messageDiv);
    this.scrollToBottom();
  }

  formatMessage(message) {
    // Convert line breaks to HTML
    return message.replace(/\n/g, '<br>');
  }

  showTypingIndicator() {
    this.isTyping = true;
    const typingDiv = document.createElement('div');
    typingDiv.className = 'chatbot-message bot-message typing-indicator';
    typingDiv.id = 'typing-indicator';
    typingDiv.innerHTML = `
      <div class="typing-indicator">
        <span></span>
        <span></span>
        <span></span>
      </div>
    `;
    this.messagesContainer.appendChild(typingDiv);
    this.scrollToBottom();
  }

  hideTypingIndicator() {
    this.isTyping = false;
    const typingIndicator = document.getElementById('typing-indicator');
    if (typingIndicator) {
      typingIndicator.remove();
    }
  }

  async giveFeedback(messageId, isHelpful) {
    try {
      await fetch(`/chatbots/${messageId}/feedback`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
          is_helpful: isHelpful
        })
      });

      // Update feedback button appearance
      const feedbackBtns = document.querySelectorAll(`[onclick*="${messageId}"]`);
      feedbackBtns.forEach(btn => {
        btn.classList.remove('helpful', 'not-helpful');
        if (btn.textContent.includes('Helpful') && isHelpful) {
          btn.classList.add('helpful');
        } else if (btn.textContent.includes('Not helpful') && !isHelpful) {
          btn.classList.add('not-helpful');
        }
      });
    } catch (error) {
      console.error('Feedback error:', error);
    }
  }

  async loadChatHistory() {
    try {
      const response = await fetch(`/chatbots/chat_history?session_id=${this.sessionId}`);
      const data = await response.json();

      if (data.success && data.messages.length > 0) {
        // Clear the default welcome message
        this.messagesContainer.innerHTML = '';

        // Load chat history
        data.messages.forEach(msg => {
          this.addMessage(msg.message, msg.message_type, msg.id);
        });
      }
    } catch (error) {
      console.error('Load chat history error:', error);
    }
  }

  scrollToBottom() {
    setTimeout(() => {
      this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
    }, 100);
  }
}

// Initialize chatbot when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  window.chatbot = new Chatbot();
});
