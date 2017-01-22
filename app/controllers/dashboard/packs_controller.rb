# coding: utf-8
class Dashboard::PacksController < Dashboard::ApplicationController

  def show
    @pack = Pack.find(params[:id])
  end

  def new
    @pack = Pack.new
  end

  def create
    @pack = current_user.packs.build(pack_params)
    if @pack.save
      redirect_to user_path(current_user), notice: I18n.t('controllers.dashboard.packs.pack_success')
    else
      render action: 'new'
    end
  end

  def destroy
    Pack.find(params[:id]).destroy
    redirect_to user_path(current_user), notice: I18n.t('controllers.dashboard.packs.pack_delete')
  end

  def pack_params
    params.require(:pack).permit(:id, :title, :user_id, :card_id)
  end
end
