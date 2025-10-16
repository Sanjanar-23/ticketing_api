class TicketEmail < ApplicationRecord
  belongs_to :ticket

  validates :from, presence: true
  validates :to, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  scope :recent, -> { order(sent_at: :desc) }

  def tag_list
    tags.present? ? tags.split(',').map(&:strip) : []
  end

  def tag_list=(tag_array)
    self.tags = tag_array.reject(&:blank?).join(', ')
  end
end
