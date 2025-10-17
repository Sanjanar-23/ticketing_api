class Ticket < ApplicationRecord
  belongs_to :contact
  belongs_to :user
  has_many :ticket_emails, dependent: :destroy
  has_many :chatbots, dependent: :destroy

  STATUSES = %w[new open pending resolved closed].freeze
  PRIORITIES = %w[low normal high].freeze

  validates :subject, presence: true
  validates :contact, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, inclusion: { in: PRIORITIES }

  before_validation :copy_contact_and_company_details

  private

  def copy_contact_and_company_details
    return unless contact

    self.customer_name ||= contact.customer_name
    self.email ||= contact.email

    company = contact.company
    if company
      self.company_code ||= company.company_code
      self.company_name ||= company.name
    end

    self.status ||= 'new'
    self.priority ||= 'normal'
  end
end
