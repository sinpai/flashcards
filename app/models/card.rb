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
                   I18n.t('models.card.equal_translation'))
      end
    rescue NoMethodError
      I18n.t('models.card.text_not_defined')
    end
  end
end
