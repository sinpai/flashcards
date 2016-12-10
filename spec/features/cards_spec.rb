# coding: utf-8
require 'rails_helper'

def testword
  'test' + rand(10000).to_s
end

feature 'Cards functionality' do
  scenario "adds new card" do
    visit root_path
    find('//a[@id="add_card"]').click
    fill_in 'card_original_text', with: (@test1 = testword)
    fill_in 'card_translated_text', with: testword
    find('//*[@name="commit"]').click
    expect(current_path).to eq cards_path
    expect(page).to have_content(/card successfully created/i)
    sleep 2
    expect(page).to have_content(@test1)
  end

  scenario "checking card translation" do
    visit 'http://localhost:3000/'
    @trnslt = find('//span[@id="cardid"]').text
    @ortext = Card.find(@trnslt).original_text
    fill_in 'answer', with: @ortext
    find('//input[@name="commit"]').click
    expect(page).to have_xpath('//div[@id="alert-loc"]', text: 'Правильно!')
  end
end
