# coding: utf-8
# Model for Cards functionality
class Card < ApplicationRecord
  validates :original_text, :translated_text, presence: true
  validates :original_text, uniqueness: true
  validate :original_text_should_not_be_eq_translated_text
  before_save { self.review_date = Date.today + 3 }

  def original_text_should_not_be_eq_translated_text
    if self.original_text.downcase.encode(Encoding::UTF_8).to_s ==
       self.translated_text.downcase.encode(Encoding::UTF_8).to_s
      errors.add(:original_text,
                 "перевод не должен быть таким же как изначальный текст")
    end
  end
end
