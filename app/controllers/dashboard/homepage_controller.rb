# coding: utf-8
# Controller for Homepage
class Dashboard::HomepageController < Dashboard::ApplicationController

  def index
    @card = if current_user.default_pack
              current_user.current_pack.cards.on_review.random_card
            else
              current_user.cards.on_review.random_card
            end
  end
end
