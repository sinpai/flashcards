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

  def add_pack
    visit new_pack_path
    fill_in 'pack_title', with: @testpack
    click_button 'Create Pack'
  end

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
    @testpack = 'test2' + rand(10000).to_s
  end

  scenario "adds new card" do

    login
    add_pack
    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.reverse!
    select @testpack, from: 'card_pack_id'
    click_button 'Create Card'

    expect(page).to have_content(@testword)
  end

  scenario "checking card translation" do

    login
    visit root_path
    # Find correct translation for displayed word
    ortext = Card.find(find('//span[@id="cardid"]').text).original_text

    fill_in 'answer', with: ortext
    click_button 'Проверить'

    expect(page).to have_content('Правильно!')
  end


end
