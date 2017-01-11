# coding: utf-8
require 'rails_helper'

feature 'Cards functionality' do

  def login
    find(:css, '#login').click
    within '/html/body/form' do
      fill_in 'email', with: @logined_user = User.find(10).email
      fill_in 'password', with: 'qweasd'
      click_on 'submit'
    end
  end

  def add_pack
    visit new_pack_path
    fill_in 'pack_title', with: @testword
    click_button 'Add pack'
  end

  before(:each) do
    @testcard = 'testcard' + rand(10000).to_s
    @testword = 'testword' + rand(10000).to_s
    visit root_path
    login
    click_link "#{@logined_user}"
  end

  scenario 'adding new pack' do

    click_button 'Create new pack'
    fill_in 'pack_title', with: @testword
    click_button 'Add pack'

    expect(page).to have_content(@testword)
  end

  scenario 'deleting pack' do

    add_pack
    click_link "#{@testword}"
    click_link 'Delete pack'

    expect(page).to have_content('Pack successfully deleted')
  end
end
