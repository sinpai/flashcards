# coding: utf-8
class CardsController < ApplicationController
  include ApplicationHelper

  helper_method :review_diff

  def index
    @cards = Card.order(:id)
  end

  def new
    @card = Card.new
  end

  def edit
    @card = Card.find(params[:id])
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      redirect_to edit_card_path(@card), notice: 'Card successfully created'
    else
      render action: 'new'
    end
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      redirect_to edit_card_path(@card), notice: "Карточка обновлена успешно"
    else
      render action: 'edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    redirect_to user_path(current_user), notice: "Карточка удалена успешно"
  end

  def check_card
    @card = Card.find(params[:id])
    if @card.check_translation?(params[:answer])
      @card.check_success
      redirect_to check_card_path, notice: 'Правильно!'
    else
      @card.check_failed
      redirect_to check_card_path, notice: 'Неправильно!'
    end
  end

  private

  def card_params
    params.require(:card).permit(:id, :original_text, :translated_text, :review_date, :checktext, :picture, :remote_picture_url, :user_id, :pack_id)
  end
end
