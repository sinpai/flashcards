# coding: utf-8
class Dashboard::CardsController < Dashboard::ApplicationController
  include ApplicationHelper
  respond_to :html, :js

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
      redirect_to edit_dashboard_card_path(@card), notice: I18n.t('controllers.dashboard.cards.created')
    else
      render action: 'new'
    end
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      redirect_to edit_dashboard_card_path(@card), notice: I18n.t('controllers.dashboard.cards.updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    redirect_to dashboard_user_path(current_user), notice: I18n.t('controllers.dashboard.cards.deleted')
  end

  def check_card
    @card = Card.find(params[:id])
    @on_study = LearnInterval.new(@card, params[:answer], params[:answertime])
    # Update card no matter if it fully correct
    @on_study.update_card
    # Check translation to show user correct info about check
    if @on_study.check_translation
      redirect_to dashboard_check_card_path, notice: I18n.t('controllers.dashboard.cards.right')
    else
      if @on_study.get_distance >= 3
        render partial: "dashboard/cards/train_failed.js.erb"
      else
        redirect_to(dashboard_check_card_path, notice: I18n.t('controllers.dashboard.cards.wrong'))
      end
    end
  end

  private

  def card_params
    params.require(:card).permit(:id, :original_text, :translated_text, :review_date, :checktext, :picture, :remote_picture_url, :user_id, :pack_id, :answertime)
  end
end
