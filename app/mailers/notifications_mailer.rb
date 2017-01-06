# coding: utf-8
class NotificationsMailer < ApplicationMailer

  default from: 'sinpaimonaco@yahoo.com'

  def pending_cards(user)
    @user = user
    mail(to: @user.email, subject: "Карточки ждут проверки!")
  end
end
