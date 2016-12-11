class User < ApplicationRecord
  has_many :card

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }
end
