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
    if original_text == answer
      if status.blank?
        self.status = 1
      elsif status < 5
        self.status += 1
      end
      update_review_date(self.status)
      true
    else
      unless self.status.blank? || self.status.eql?(0)
        self.status -= 1 if status > 0
        update_review_date(self.status)
      end
      false
    end
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
      "#{diff[:weeks]}нед #{diff[:days]}д #{diff[:hours]}ч #{diff[:minutes]}мин"
    end
  end
end
