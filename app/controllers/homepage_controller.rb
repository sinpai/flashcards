# Controller for Homepage
class HomepageController < ApplicationController
  def index
    if current_user && !Card.where("user_id = #{current_user.id}").count.zero?
      @card = Card.where("user_id = #{current_user.id}").on_review(Date.today + 7).random_card
    else
      @card = Card.on_review(Date.today + 7).random_card
    end
  end
end
