# coding: utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :set_default_pack]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to @user, notice: I18n.t('controllers.users.create')
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: I18n.t('controllers.users.update')
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_url, notice: I18n.t('controllers.users.destroy')
  end

  def set_default_pack
    @user.default_pack = params[:id]
    if @user.save
      redirect_to @user, notice: I18n.t('controllers.users.main_pack')
    else
      redirect_to @user, notice: I18n.t('controllers.users.main_pack_fail')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :locale)
    end
end
