class ChatbotsController < WebControllerBase
  before_action :authenticate_user!

  def index
    @chatbots = current_user.chatbots.includes(:ticket).order(created_at: :desc).limit(50)
  end

  def create
    @chatbot = current_user.chatbots.build(chatbot_params)

    if @chatbot.save
      # Generate bot response
      bot_response = generate_bot_response(@chatbot.message, @chatbot.session_id)

      # Save bot response
      bot_message = current_user.chatbots.create!(
        message: bot_response,
        message_type: 'bot',
        session_id: @chatbot.session_id,
        ticket_id: @chatbot.ticket_id
      )

      render json: {
        success: true,
        user_message: @chatbot,
        bot_response: bot_message
      }
    else
      render json: { success: false, errors: @chatbot.errors.full_messages }
    end
  end

  def chat_history
    session_id = params[:session_id]
    @chat_history = Chatbot.get_chat_history(session_id)

    render json: {
      success: true,
      messages: @chat_history.map do |msg|
        {
          id: msg.id,
          message: msg.message,
          message_type: msg.message_type,
          created_at: msg.created_at.strftime('%H:%M'),
          is_helpful: msg.is_helpful
        }
      end
    }
  end

  def feedback
    @chatbot = Chatbot.find(params[:id])
    @chatbot.update(is_helpful: params[:is_helpful])

    render json: { success: true }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Message not found' }, status: 404
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:message, :session_id, :ticket_id)
  end

  def generate_bot_response(user_message, session_id)
    # Get chat history for context
    chat_history = Chatbot.get_chat_history(session_id, 5)

    # Simple rule-based responses (you can enhance this with AI/ML)
    message_lower = user_message.downcase

    # Greeting responses
    if message_lower.match?(/\b(hi|hello|hey|good morning|good afternoon|good evening)\b/)
      return "Hello! I'm your ticketing assistant. How can I help you today? I can help you with:\n• Creating tickets\n• Checking ticket status\n• Finding information about your account\n• General support questions"
    end

    # Ticket-related responses
    if message_lower.match?(/\b(create|new|open)\b.*\b(ticket|issue|problem|support)\b/)
      return "I can help you create a new ticket! Please provide:\n• A brief description of your issue\n• The priority level (low, normal, high)\n• Any additional details you think might be helpful\n\nOr you can click the 'Create Ticket' button in the navigation menu."
    end

    if message_lower.match?(/\b(status|check|view)\b.*\b(ticket|issue)\b/)
      return "To check your ticket status, you can:\n• Go to the 'Tickets' section in the navigation\n• Look for your ticket in the list\n• Click on it to view full details\n\nIf you have a specific ticket number, I can help you find it."
    end

    # Account-related responses
    if message_lower.match?(/\b(account|profile|information|details)\b/)
      return "For account information, you can:\n• View your profile in the user menu\n• Check your company details\n• Update your contact information\n\nIs there something specific about your account you'd like to know?"
    end

    # Help responses
    if message_lower.match?(/\b(help|support|assistance|how to|what can)\b/)
      return "I'm here to help! I can assist you with:\n\n🎫 **Tickets**: Create, view, and manage support tickets\n👥 **Contacts**: Manage your contacts and companies\n📊 **Dashboard**: View your account overview\n📧 **Email**: Send emails related to tickets\n\nWhat would you like to do?"
    end

    # Thank you responses
    if message_lower.match?(/\b(thank|thanks|appreciate)\b/)
      return "You're welcome! I'm happy to help. Is there anything else you need assistance with?"
    end

    # Goodbye responses
    if message_lower.match?(/\b(bye|goodbye|see you|farewell)\b/)
      return "Goodbye! Feel free to reach out anytime if you need help. Have a great day!"
    end

    # Default response
    return "I understand you're asking about '#{user_message}'. I'm here to help with your ticketing system needs. You can ask me about:\n\n• Creating or checking tickets\n• Managing your contacts and companies\n• Getting help with the system\n• Account-related questions\n\nCould you be more specific about what you need help with?"
  end
end
