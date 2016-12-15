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

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
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
    click_link 'Добавить карточку'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.to_s.reverse
    click_button 'Create Card'

    click_link @logined_user
    expect(page).to have_content('Мои карточки')
    expect(page).to have_content(@testword)
  end

  scenario "adding cards from dictionary" do

    login
    click_link 'Все карточки'

    #Selecting random word at the table
    within :xpath, "(//tr[@id='wordline'])[#{rand(900)}]" do
      click_button 'Добавить карточку'

      #Copying word to compare
      @added_word = find(:id, 'origtext').text
    end
    expect(page).to have_content('Card added successfully')

    #Comparing it in My Cards
    click_link @logined_user
    expect(page).to have_content(@added_word)
  end
end
