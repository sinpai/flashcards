# coding: utf-8
require 'rails_helper'

describe Card do
  it "is valid with original text, translated text and review date" do
    card = build(:card)
    expect(card).to be_valid
  end
  it "is invalid without original text" do
    card = build(:card, original_text: nil)
    card.valid?
    expect(card.errors[:original_text]).to include("can't be blank")
  end
  it "is invalid without translated text" do
    card = build(:card, translated_text: nil)
    card.valid?
    expect(card.errors[:translated_text]).to include("can't be blank")
  end
  it "is invalid with dublicated original text" do
    card = build(:card, original_text: 'test', translated_text: 'test')
    card.valid?
    expect(card.errors[:original_text]).to include("перевод не должен быть таким же как изначальный текст")
  end
  it "prevents from saving card with the same original text" do
    create(:card,
      original_text: 'monkey',
      translated_text: 'обязьяна'
    )
    card = build(:card,
      original_text: 'monkey',
      translated_text: 'манки'
    )
    card.save
    expect(card.errors[:original_text]).to include('has already been taken')
  end
  it "should randomly give cards that are on review" do
    card1 = Card.on_review(Date.today).random_card
    card2 = Card.on_review(Date.today).random_card
    expect(card1).not_to equal(card2)
  end
  it "should correctly check translation" do
    card = create(:card, original_text: "house", translated_text: "Дом")
    expect(card.check_translation?("building")).to be false
  end
  it "should correctly update review date" do
    card = create(:card)
    card.review_date = Date.today
    card.valid?
    card.update_review_date(2)
    expect(card.review_date.to_date).to eq(Date.today + 3)
  end
end
