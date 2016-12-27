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

  def card_info
    Card.find(@cardid)
  end

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
    @testpack = 'test2' + rand(10000).to_s
    @date3ago = (Date.today - 6).strftime("%-d")
  end

  scenario "adds new card and checking card translation" do

    login
    add_pack
    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.reverse!
    select @date3ago, from: 'card_review_date_3i'
    select @testpack, from: 'card_pack_id'
    click_button 'Create Card'

    expect(page).to have_content(@testword)

    visit root_path
    # Find correct translation for displayed word
    @cardid = find('//span[@id="cardid"]').text
    ortext = card_info.original_text

    fill_in 'answer', with: ortext
    click_button 'Проверить'

    expect(page).to have_content('Правильно!')
    expect(card_info.interval).to eq(1)
    expect(card_info.review_date).to be > DateTime.current
  end
end
