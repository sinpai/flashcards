# coding: utf-8
require 'rails_helper'

feature 'Packs functionality' do

  def login
    click_button I18n.t('layouts.navbar.login')
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_button I18n.t('user_sessions.form.login')
    end
  end

  def add_pack
    visit new_pack_path
    fill_in 'pack_title', with: @testword
    click_button I18n.t('helpers.submit.pack.create')
  end

  before(:each) do
    @testcard = 'testcard' + rand(10000).to_s
    @testword = 'testword' + rand(10000).to_s
    visit root_path
    login
    click_link "#{@logined_user}"
  end

  scenario 'adding new pack' do

    click_button I18n.t('users.show.new_pack')
    fill_in 'pack_title', with: @testword
    click_button I18n.t('helpers.submit.pack.create')

    expect(page).to have_content(@testword)
  end

  scenario 'deleting pack' do

    add_pack
    click_link "#{@testword}"
    click_link I18n.t('packs.show.delete')

    expect(page).to have_content(I18n.t 'controllers.packs.pack_delete')
  end
end
