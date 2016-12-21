# coding: utf-8
require 'rails_helper'

feature 'Users functionality' do

  useremail ||= FFaker::Internet.email

  def login
    click_link 'Login'
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
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

  scenario "registration" do

    click_link 'Register'
    within '//form[@id="new_user"]' do
      fill_in 'user_email', with: useremail
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Create User'
    end

    expect(page).to have_content('User was successfully created.')
    expect(page).to have_content(useremail)
  end

  scenario 'log in' do

    click_link 'Login'
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button 'Login'
    end

    expect(page).to have_content('Login successful')
    expect(page).to have_content(@logined_user)
  end

  scenario "adding new cards to user" do

    login
    add_pack
    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.to_s.reverse
    select @testpack, from: 'card_pack_id'
    click_button 'Create Card'

    click_link @logined_user
    expect(page).to have_content('Мои карточки')
    expect(page).to have_content(@testword)
  end
end
