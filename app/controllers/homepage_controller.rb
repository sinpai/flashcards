# Controller for Homepage
class HomepageController < ApplicationController
  def index
    if current_user && current_user.default_pack.nil?
      @card = current_user.cards.on_review(Date.today + 7).random_card
    elsif current_user && !current_user.default_pack.nil?
      @card = Card.where("pack_id = '#{current_user.default_pack}'").random_card
    else
      @card = Card.on_review(Date.today + 7).random_card
    end
  end
end
