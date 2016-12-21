# coding: utf-8
class PacksController < ApplicationController

  def show
    @pack = Pack.find(params[:id])
  end

  def new
    @pack = Pack.new
  end

  def create
    @pack = current_user.packs.build(pack_params)
    if @pack.save
      redirect_to user_path(current_user), notice: 'Pack successfully created'
    else
      render action: 'new'
    end
  end

  def destroy
    Pack.find(params[:id]).destroy
    redirect_to user_path(current_user), notice: "Колода удалена успешно"
  end

  def pack_params
    params.require(:pack).permit(:id, :title, :user_id, :card_id)
  end
end
