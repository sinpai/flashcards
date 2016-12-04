# coding: utf-8
class CardsController < ApplicationController

  helper_method :undone_left

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

    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path,
                      notice: 'Card successfully created' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      redirect_to cards_path, notice: "Карточка обновлена успешно"
    else
      render action: 'edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    redirect_to cards_path, notice: "Карточка удалена успешно"
  end

  def undone_left
    Card.on_review(Date.today + 7).count
  end

  def check_card
    if Card.find(params[:id]).original_text == params[:answer]
      Card.find(params[:id]).save
      redirect_to check_card_path, notice: 'Правильно!'
    else
      redirect_to check_card_path, notice: 'Неправильно!'
    end
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :checktext)
  end
end
