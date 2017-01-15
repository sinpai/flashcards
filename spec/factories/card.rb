require 'ffaker'
# coding: utf-8
FactoryGirl.define do
  factory :card do
    original_text { FFaker::Food.ingredient }
    translated_text { FFaker::Food.fruit }
    review_date Date.today
    interval 1.0
    iteration 0
    user
    pack
  end
end
