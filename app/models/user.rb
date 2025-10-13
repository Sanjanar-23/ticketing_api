class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :companies, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :name, presence: true
end
