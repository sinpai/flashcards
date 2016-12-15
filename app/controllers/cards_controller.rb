# coding: utf-8
class CardsController < ApplicationController

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
    @card = Card.new(card_params)
    @card.user_id = current_user.id
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
    redirect_to user_path, notice: "Карточка удалена успешно"
  end

  def check_card
    @card = Card.find(params[:id])
    if @card.check_translation?(params[:answer])
      @card.update_review_date
      redirect_to check_card_path, notice: 'Правильно!'
    else
      redirect_to check_card_path, notice: 'Неправильно!'
    end
  end

  def add
    ucard = Card.find(params[:id]).dup
    if current_user.cards.exists?(original_text: ucard.original_text)
      redirect_to cards_path, notice: "Card have already been added"
    else
      ucard.user_id = current_user.id
      ucard.save(validate: false)
      redirect_to cards_path, notice: "Card added successfully"
    end
  end

  private

  def card_params
    params.require(:card).permit(:id, :original_text, :translated_text, :review_date, :checktext, :user_id)
  end
end
