# coding: utf-8
# Model for Cards functionality
class Card < ApplicationRecord
  validates :original_text, :translated_text, presence: true
  validates :original_text, uniqueness: true
  validate :original_text_should_not_be_eq_translated_text
  before_save { self.review_date = Date.today + 3 }
  scope :on_review, ->(time) { where("review_date < ?", time) }
  scope :random_card, -> { order("RANDOM()").first }

  def original_text_should_not_be_eq_translated_text
    begin
      if original_text.mb_chars.downcase.to_s.chars ==
         translated_text.mb_chars.downcase.to_s.chars
        errors.add(:original_text,
                   "перевод не должен быть таким же как изначальный текст")
      end
    rescue NoMethodError
      'original_text or translated_text are not defined'
    end
  end

  def check_translation?(answer)
    self.original_text == answer
  end

  def update_review_date
    self.update_attributes(review_date: Date.today + 3)
  end
end
