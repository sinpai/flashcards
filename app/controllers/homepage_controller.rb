# Controller for Homepage
class HomepageController < ApplicationController
  def index
    @card = Card.on_review(Date.today + 7).random_card
  end
end
