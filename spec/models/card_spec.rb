require 'rails_helper'

describe Card do

  let!(:card) { FactoryGirl.create(:card) }

  before(:each) do
    Timecop.freeze(DateTime.now.utc)
  end

  context "aliased attributes" do
    it "is the correct original_text card" do
      expect(card.original_text).to eq "Fruit"
    end

    it "is the correct translated_text card" do
      expect(card.translated_text).to eq "Фрукт"
    end

    it "is not the correct translated_text card" do
      expect(card.translated_text).to_not eq "Кран"
    end

    it "is the correct review_date card" do
      expect(card.review_date).to eq DateTime.now.utc
    end
  end

  context "not valid object" do
    before(:each) do
      @card1 = Card.create(original_text: 'house', translated_text: 'house', review_date: DateTime.now.utc + 10.day)
      @card2 = Card.create(original_text: 'house', translated_text: 'HOuSe')
    end

    it "is not return valid object if original_text equal translated_text" do
      expect(@card1).to_not be_valid
    end

    it "is not return valid object if original_text equal translated_text
         even with small and lower-case letters" do
      expect(@card2).to_not be_valid
    end
  end

  context "scopes" do
    it "is not include card that have review_date >= DateTime.now.utc" do
      expect(Card.for_review).to_not include(@card1)
    end

    it "is include card that have review_date <= DateTime.now.utc" do
      card.update(review_date: DateTime.now.utc)
      expect(Card.for_review).to include(card)
    end
  end

  context "check translation for review card" do
    it "is false if translation is not correct" do
      expect(card.verify_translation("Banana", "3.21")).to eq false
    end

    it "is true if translation is correct" do
      expect(card.verify_translation("Fruit", "3.21")).to eq true
    end

    it "is true if translation is correct even with small and lower-case letters" do
      expect(card.verify_translation("fRUiT", "3.21")).to eq true
    end
  end

end