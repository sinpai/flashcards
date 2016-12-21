# coding: utf-8
class Pack < ApplicationRecord
  has_many :cards
  belongs_to :user

  validates :title, uniqueness: true
  validates :title, length: { minimum: 5 }
end
