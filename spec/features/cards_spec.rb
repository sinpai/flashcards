# coding: utf-8
require 'rails_helper'

feature 'Cards functionality' do

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
  end

  scenario "adds new card" do

    #Register
    click_link 'Register'
    within '//form[@id="new_user"]' do
      fill_in 'user_email', with: 'test' + rand(10000).to_s + '@qoq.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Create User'
    end

    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.reverse!
    click_button 'Create Card'

    expect(page).to have_content(@testword)
  end

  scenario "checking card translation" do

    # Find correct translation for displayed word
    ortext = Card.find(find('//span[@id="cardid"]').text).original_text

    fill_in 'answer', with: ortext
    click_button 'Проверить'

    expect(page).to have_content('Правильно!')
  end
end
