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
      redirect_to edit_card_path(@card), notice: I18n.t('controllers.cards.created')
    else
      render action: 'new'
    end
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      redirect_to edit_card_path(@card), notice: I18n.t('controllers.cards.updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    redirect_to user_path(current_user), notice: I18n.t('controllers.cards.deleted')
  end

  def check_card
    @card = Card.find(params[:id])
    @on_study = LearnInterval.new(@card, params[:answer], params[:answertime])
    @on_study.update_card
    if @on_study.check_translation
      redirect_to check_card_path, notice: I18n.t('controllers.cards.right')
    else
      if @on_study.levenshtein_distance >= 3
        render('cards/train_failed')
      else
        redirect_to(check_card_path, notice: I18n.t('controllers.cards.wrong'))
      end
    end
  end

  private

  def card_params
    params.require(:card).permit(:id, :original_text, :translated_text, :review_date, :checktext, :picture, :remote_picture_url, :user_id, :pack_id, :answertime)
  end
end
