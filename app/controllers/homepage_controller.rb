# coding: utf-8
# Controller for Homepage
class HomepageController < ApplicationController

  before_action :check_auth

  def index
    @card = if current_user.default_pack
              current_user.current_pack.cards.random_card
            else
              current_user.cards.on_review(Date.today + 7).random_card
            end
  end

  private

  def check_auth
    redirect_to login_path, notice: "Вы должны быть залогинены" unless current_user
  end
end
