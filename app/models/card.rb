# coding: utf-8
# Model for Cards functionality
class Card < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :pack

  mount_uploader :picture, PictureUploader

  validates :original_text, :translated_text, :pack_id, :review_date, presence: true
  validates :original_text, uniqueness: true
  validate :original_text_should_not_be_eq_translated_text
  before_save { self.review_date = self.review_date.to_datetime.utc }
  scope :on_review, ->(time) { where("review_date < ?", time) }
  scope :random_card, -> { order("RANDOM()").first }

  DAYS = [0.5, 3, 7, 14, 30].freeze

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

  def new_date(status)
    DateTime.current.next_day(DAYS[status - 1])
  end

  def update_review_date(status)
    self.update_attributes(review_date: new_date(status))
  end

  def review_diff
    if self.review_date < Time.zone.now
      "на проверке"
    else
      diff = TimeDifference.between(self.review_date, Time.zone.now).in_general
      "#{diff[:days]}д #{diff[:hours]}ч #{diff[:minutes]}мин"
    end
  end
end
