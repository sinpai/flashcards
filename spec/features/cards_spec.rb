# coding: utf-8
require 'rails_helper'

feature 'Cards functionality' do

  def login
    click_link 'Login'
    within '/html/body/form' do
      fill_in 'email', with: User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button 'Login'
    end
  end

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
  end

  scenario "adds new card" do

    login
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
