class AuthenticationsController < ApplicationController

  private

  def authentications_params
    params.require(:authentication).permit(:user_id, :provider, :uid)
  end
end
