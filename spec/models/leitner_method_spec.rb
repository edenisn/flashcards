require 'rails_helper'

describe Card do

  let!(:card) { FactoryGirl.create(:card) }

  before(:each) do
    Timecop.freeze(DateTime.now)
  end

  describe "check correct answer" do
    before(:each) do
      card.verify_translation("Fruit")
    end

    context "field correct_counter is equal 1" do
      let(:card) { FactoryGirl.create :card, correct_counter: 0, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 1 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 12.hour }
    end

    context "field correct_counter is equal 2" do
      let(:card) { FactoryGirl.create :card, correct_counter: 1, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 2 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 3.day }
    end

    context "field correct_counter is equal 3" do
      let(:card) { FactoryGirl.create :card, correct_counter: 2, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 3 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 7.day }
    end

    context "field correct_counter is equal 4" do
      let(:card) { FactoryGirl.create :card, correct_counter: 3, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 4 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 14.day }
    end

    context "field correct_counter is equal 5" do
      let(:card) { FactoryGirl.create :card, correct_counter: 4, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 5 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 1.month }
    end

    context "field correct_counter is not equal 6" do
      let(:card) { FactoryGirl.create :card, correct_counter: 5, review_date: DateTime.now }
      it { expect(card.correct_counter).to_not eq 6 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 1.month }
    end
  end

  describe "check wrong answer" do
    before(:each) do
      card.verify_translation("qwerty")
    end

    context "field wrong_counter is equal 1" do
      let(:card) { FactoryGirl.create :card, wrong_counter: 0, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 0 }
      it { expect(card.wrong_counter).to eq 1 }
      it { expect(card.review_date).to eq DateTime.now }
    end

    context "field wrong_counter is equal 2" do
      let(:card) { FactoryGirl.create :card, wrong_counter: 1, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 0 }
      it { expect(card.wrong_counter).to eq 2 }
      it { expect(card.review_date).to eq DateTime.now }
    end

    context "field wrong_counter > 3" do
      let(:card) { FactoryGirl.create :card, wrong_counter: 2, review_date: DateTime.now }
      it { expect(card.correct_counter).to eq 0 }
      it { expect(card.wrong_counter).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now + 12.hour }
    end
  end

end