class User < ApplicationRecord
  has_many :cards
  has_many :packs
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
  validates :locale, presence: true

  def has_linked_twitter?
    authentications.where(provider: 'twitter').present?
  end

  def has_linked_facebook?
    authentications.where(provider: 'facebook').present?
  end

  def current_pack
    packs.find(default_pack)
  end

  def self.notify_pending_cards
    self.joins(:cards).where('review_date < ?', Date.today).distinct.each do |user|
      NotificationsMailer.pending_cards(user).deliver_now
    end
  end
end

