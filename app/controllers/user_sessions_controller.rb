class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(user_path(@user), notice: I18n.t('controllers.user_sessions.log_success'))
    else
      flash.now[:alert] = I18n.t('controllers.user_sessions.log_fail')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: I18n.t('controllers.user_sessions.logout'))
  end
end
