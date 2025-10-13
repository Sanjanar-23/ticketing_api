class Company < ApplicationRecord
  belongs_to :user
  has_many :contacts, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :company_code, presence: true, uniqueness: true

  before_validation :ensure_company_code

  private

  def ensure_company_code
    return if company_code.present?

    # Generate a short unique code like CMP-XXXXXX
    loop do
      candidate = "CMP-#{SecureRandom.alphanumeric(6).upcase}"
      unless Company.exists?(company_code: candidate)
        self.company_code = candidate
        break
      end
    end
  end
end
