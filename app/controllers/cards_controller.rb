# coding: utf-8
class CardsController < ApplicationController

  helper_method :show_random_card, :check_card

  def index
    @cards = Card.order(:id)
  end

  def new
    @card = Card.new
  end

  def show
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

  def train
    @card = Card.on_review(Date.today + 7).first
    byebug
  end

  def check_card
    if Card.find(params[:id]).original_text == params[:checktext]
      Card.find(params[:id]).save
      redirect_to cards_train_path, notice: 'Правильно!'
    else
      redirect_to cards_train_path, notice: 'Неправильно!'
    end
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :checktext)
  end
end
