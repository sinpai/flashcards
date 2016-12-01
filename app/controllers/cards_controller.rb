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
    if Card.find(params[:id]).destroy
      redirect_to cards_path, notice: "Карточка удалена успешно"
    end
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
