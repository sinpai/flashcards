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
    expect(card.errors[:original_text]).to include(I18n.t 'models.card.equal_translation')
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
    card1 = Card.on_review.random_card
    card2 = Card.on_review.random_card
    expect(card1).not_to equal(card2)
  end
  it "should correctly check translation" do
    card = create(:card, original_text: "house", translated_text: "Дом")
    expect(LearnInterval.new(card,"building").check_translation).to be false
  end
  it "should correctly calculate new efactor" do
    card = build(:card, interval: 8.0, efactor: 1.7, iteration: 36, original_text: 'test')
    LearnInterval.new(card, "test").update_card
    expect(card.efactor.round(1)).to eq(1.8)
  end
  it "should correctly calculate new interval" do
    card = build(:card, interval: 8.0, efactor: 1.7, iteration: 36, original_text: 'test')
    LearnInterval.new(card, "test").update_card
    expect(card.interval).to eq(16.0)
  end
  it "should correctly update iteration" do
    card = build(:card, original_text: 'test')
    LearnInterval.new(card, "test").update_card
    expect(card.iteration).to eq(1)
  end
  it "should correctly calculate time value" do
    card = build(:card, original_text: 'test')
    study_unit = LearnInterval.new(card, "test", 80000)
    expect(study_unit.get_quality).to eq(3)
  end
end
