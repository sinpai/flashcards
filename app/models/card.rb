# coding: utf-8
# Model for Cards functionality
class Card < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :pack

  mount_uploader :picture, PictureUploader

  validates :original_text, :translated_text, :pack_id, :review_date, presence: true
  validates :original_text, uniqueness: true
  validate :original_text_should_not_be_eq_translated_text
  scope :on_review, -> { where("review_date < ?", DateTime.current) }
  scope :random_card, -> { order("RANDOM()").first }

  DAYS = [0, 0.5, 3, 7, 14, 30].freeze

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
    original_text == answer
  end

  def check_success
    interval.blank? ? self.interval = 1 : (self.interval += 1 if interval < 5)
    update_review_date(self.interval)
  end

  def check_failed
    self.interval -= 1 unless interval.blank? || interval <= 0
    update_review_date(self.interval)
  end

  def update_review_date(interval)
    update_attributes(review_date: DAYS[interval].days.from_now)
  end
end
