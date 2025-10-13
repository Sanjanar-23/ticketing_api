class Ticket < ApplicationRecord
  belongs_to :contact
  belongs_to :user

  STATUSES = %w[new open pending resolved closed].freeze

  validates :subject, presence: true
  validates :contact, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

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
  end
end
