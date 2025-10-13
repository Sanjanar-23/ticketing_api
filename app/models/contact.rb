class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :company

  has_many :tickets, dependent: :destroy

  validates :customer_name, presence: true
  validates :email, presence: true

  before_validation :copy_company_details

  private

  def copy_company_details
    return unless company

    self.company_code ||= company.company_code
    self.company_name ||= company.name
    self.website ||= company.website
  end
end
