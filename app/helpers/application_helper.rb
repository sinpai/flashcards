# coding: utf-8
module ApplicationHelper
  def review_diff(card)
    if card.review_date < Time.zone.now
      t('.on_review')
    else
      diff = TimeDifference.between(card.review_date, Time.zone.now).in_general
      "#{diff[:weeks]}#{t('.week')} #{diff[:days]}#{t('.day')} #{diff[:hours]}#{t('.hour')} #{diff[:minutes]}#{t('.minute')}"
    end
  end
end
