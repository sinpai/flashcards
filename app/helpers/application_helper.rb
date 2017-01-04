# coding: utf-8
module ApplicationHelper
  def review_diff(card)
    if card.review_date < Time.zone.now
      "на проверке"
    else
      diff = TimeDifference.between(card.review_date, Time.zone.now).in_general
      "#{diff[:weeks]}нед #{diff[:days]}д #{diff[:hours]}ч #{diff[:minutes]}мин"
    end
  end
end
