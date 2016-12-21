# coding: utf-8
require 'rails_helper'

feature 'Cards functionality' do

  def login
    click_link 'Login'
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button 'Login'
    end
  end

  def adding_cards
    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testcard
    fill_in 'card_translated_text', with: @testcard.reverse
    select @testword, from: 'card_pack_id'
    click_button 'Create Card'
  end

  def add_pack
    visit new_pack_path
    fill_in 'pack_title', with: @testword
    click_button 'Create Pack'
  end

  before(:each) do
    @testcard = 'testcard' + rand(10000).to_s
    @testword = 'testword' + rand(10000).to_s
    visit root_path
    login
    click_link "#{@logined_user}"
  end

  scenario 'adding new pack' do

    click_button 'Создать новую колоду'
    fill_in 'pack_title', with: @testword
    click_button 'Create Pack'

    expect(page).to have_content(@testword)
  end

  scenario 'deleting pack' do

    add_pack
    click_link "#{@testword}"
    click_link 'Удалить колоду'

    expect(page).to have_content('Колода удалена успешно')
  end
end
