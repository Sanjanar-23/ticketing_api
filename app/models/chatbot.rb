class Chatbot < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :ticket, optional: true

  validates :message, presence: true
  validates :session_id, presence: true
  validates :message_type, inclusion: { in: %w[user bot] }

  scope :for_session, ->(session_id) { where(session_id: session_id).order(:created_at) }
  scope :user_messages, -> { where(message_type: 'user') }
  scope :bot_messages, -> { where(message_type: 'bot') }

  def self.generate_session_id
    SecureRandom.hex(16)
  end

  def self.get_chat_history(session_id, limit = 10)
    for_session(session_id).limit(limit)
  end

  def bot_response?
    message_type == 'bot'
  end

  def user_message?
    message_type == 'user'
  end
end
