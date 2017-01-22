# coding: utf-8
require 'rails_helper'

feature 'Users functionality' do

  useremail ||= FFaker::Internet.email

  def login
    click_button I18n.t('layouts.navbar.login')
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button I18n.t('home.user_sessions.form.login')
    end
  end

  def add_pack
    visit new_pack_path
    fill_in 'pack_title', with: @testpack
    click_button I18n.t('helpers.submit.pack.create')
  end

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
    @testpack = 'test2' + rand(10000).to_s
  end

  scenario "registration" do

    click_link I18n.t('layouts.navbar.register')
    pastloc = I18n.locale
    within '//form[@id="new_user"]' do
      fill_in 'user_email', with: useremail
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      select 'en', from: 'user_locale'
      click_button I18n.t('helpers.submit.user.create')
    end

    expect(page).to have_content(I18n.t 'controllers.dashboard.users.create', locale: pastloc)
    expect(page).to have_content(useremail)
  end

  scenario 'log in' do

    click_button I18n.t('layouts.navbar.login')
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button I18n.t('home.user_sessions.form.login')
    end

    expect(page).to have_content(I18n.t 'controllers.home.user_sessions.log_success')
    expect(page).to have_content(@logined_user)
  end

  scenario "adding new cards to user" do

    login
    add_pack
    click_link 'Add card'

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.to_s.reverse
    select @testpack, from: 'card_pack_id'
    click_button I18n.t('helpers.submit.card.create')

    click_link @logined_user
    expect(page).to have_content(I18n.t 'dashboard.users.show.title_cards')
    expect(page).to have_content(@testword)
  end
end
