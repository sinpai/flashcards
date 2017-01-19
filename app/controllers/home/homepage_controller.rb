# coding: utf-8
# Controller for Homepage
class Home::HomepageController < Home::ApplicationController

  before_action :check_auth

  def index
    @card = if current_user.default_pack
              current_user.current_pack.cards.on_review.random_card
            else
              current_user.cards.on_review.random_card
            end
  end

  private

  def check_auth
    redirect_to login_path, notice: I18n.t('controllers.home.homepage.login_required') unless current_user
  end
end
