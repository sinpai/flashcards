# coding: utf-8
require 'rails_helper'

feature 'Cards functionality' do

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
    fill_in 'pack_title', with: @testpack
    click_button I18n.t('helpers.submit.pack.create')
  end

  def card_info
    Card.find(@cardid)
  end

  before (:each) do
    visit root_path
    @testword = 'test' + rand(10000).to_s
    @testpack = 'test2' + rand(10000).to_s
    @date3ago = 6.days.ago.strftime("%-d")
    @yearago = 1.year.ago.strftime("%Y")
  end

  scenario "adds new card and checking card translation" do

    login
    add_pack
    click_link I18n.t('layouts.navbar.add_card')

    fill_in 'card_original_text', with: @testword
    fill_in 'card_translated_text', with: @testword.reverse!
    select @date3ago, from: 'card_review_date_3i'
    select @yearago, from: 'card_review_date_1i'
    select @testpack, from: 'card_pack_id'
    click_button I18n.t('helpers.submit.card.create')

    expect(page).to have_content(@testword)

    visit root_path
    # Find correct translation for displayed word
    @cardid = find('//span[@id="cardid"]').text
    ortext = card_info.original_text

    fill_in 'answer', with: ortext
    click_button I18n.t('cards.trainform.check')

    expect(page).to have_content(I18n.t 'controllers.cards.right')
    expect(card_info.interval).to eq(1)
    expect(card_info.review_date).to be > DateTime.current
  end
end
