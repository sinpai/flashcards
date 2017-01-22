class Home::OauthsController < Home::ApplicationController

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(auth_params[:provider])
  end

  # this is where all of the magic happens
  def callback
    # this will be set to 'github' when user is logging in via Github
    provider = auth_params[:provider]

    if @user = login_from(provider)
      # user has already linked their account with github

      flash[:notice] = I18n.t('controllers.home.oauths.log_success').concat(provider.titleize)
      redirect_to root_path
    else
      # User has not linked their account with Github yet. If they are logged in,
      # authorize the account to be linked. If they are not logged in, require them
      # to sign in. NOTE: If you wanted to allow the user to register using oauth,
      # this section will need to be changed to be more like the wiki page that was
      # linked earlier.

      if logged_in?
        link_account(provider)
        redirect_to root_path
      else
        begin
          @user = create_from(provider)
          # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule

          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to root_path, :notice => I18n.t('controllers.home.oauths.log_from').concat(provider.titleize)
        rescue
          redirect_to root_path, :alert => I18n.t('controllers.home.oauths.log_fail').concat(provider.titleize)
        end
      end
    end
  end

  # This is used to allow users to unlink their account from the oauth provider.
  #
  # In order to use this action you will need to include this route in your routes file:
  # delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth
  #
  # You will need to provide a 'provider' parameter to the action, create a link like this:
  # link_to 'unlink', delete_oauth_path('github'), method: :delete
  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = I18n.t('controllers.home.oauths.unlink_success').concat(provider.titleize)
    else
      flash[:alert] = I18n.t('controllers.home.oauths.unlink_fail').concat(provider.titleize)
    end

    redirect_to root_path
  end

  private

  def link_account(provider)
    if @user = add_provider_to_user(provider)
      # If you want to store the user's Github login, which is required in order to interact with their Github account, uncomment the next line.
      # You will also need to add a 'github_login' string column to the users table.
      #
      # @user.update_attribute(:github_login, @user_hash[:user_info]['login'])
      flash[:notice] = I18n.t('controllers.oauths.link_success').concat(provider.titleize)
    else
      flash[:alert] = I18n.t('controllers.oauths.link_fail').concat(provider.titleize)
    end
  end

  def auth_params
    params.permit(:code, :provider, :oauth_token, :oauth_verifier)
  end
end
