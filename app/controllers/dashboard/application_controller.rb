class Dashboard::ApplicationController < ApplicationController
  before_action :check_auth

  private

  def check_auth
    redirect_to login_path, notice: I18n.t('controllers.dashboard.homepage.login_required') unless current_user
  end
end
