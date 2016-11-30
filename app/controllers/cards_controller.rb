# coding: utf-8
class CardsController < ApplicationController

  def index
    @cards = Card.order('id').all
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
    respond_to do |format|
      if @card.update_attributes(card_params)
        format.html do
          redirect_to cards_path, notice: "Карточка обновлена успешно"
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to cards_path, notice: "Карточка удалена успешно" }
    end
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
