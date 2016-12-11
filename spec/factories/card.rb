require 'ffaker'
# coding: utf-8
FactoryGirl.define do
  factory :card do
    original_text { FFaker::Food.ingredient }
    translated_text { FFaker::Food.fruit }
    review_date Date.today
    user_id { rand(100).to_s }
  end
end
