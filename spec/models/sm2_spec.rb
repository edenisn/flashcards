require 'rails_helper'

describe SM2CardsReviewer do

  let!(:card) { FactoryGirl.create(:card) }

  before(:each) do
    Timecop.freeze(DateTime.now.utc)
  end

  describe "check correct answer and 0 < time answer < =10 seconds" do
    before(:each) do
      card.verify_translation("Fruit", "7.318")
    end

    context "fields are equals: easiness_factor = 2.6, number_repetitions = 1 and repetition_interval = 1" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.6 }
      it { expect(card.number_repetitions).to eq 1 }
      it { expect(card.repetition_interval).to eq 1 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 1.day }
    end

    context "fields are equals: easiness_factor = 2.7, number_repetitions = 2 and repetition_interval = 6" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.6, number_repetitions: 1,
                                      repetition_interval: 1, review_date: DateTime.now.utc  + 12.hour + 1.day }
      it { expect(card.easiness_factor).to eq 2.7 }
      it { expect(card.number_repetitions).to eq 2 }
      it { expect(card.repetition_interval).to eq 6 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 6.day }
    end

    context "fields are equals: easiness_factor = 2.8, number_repetitions = 3 and repetition_interval = 16" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.7, number_repetitions: 2,
                                      repetition_interval: 6, review_date: DateTime.now.utc  + 12.hour + 6.day }
      it { expect(card.easiness_factor).to eq 2.8 }
      it { expect(card.number_repetitions).to eq 3 }
      it { expect(card.repetition_interval).to eq 16 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 16.day }
    end

    context "fields are equals: easiness_factor = 2.9, number_repetitions = 4 and repetition_interval = 46" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.8, number_repetitions: 3,
                                      repetition_interval: 16, review_date: DateTime.now.utc  + 12.hour + 16.day }
      it { expect(card.easiness_factor).to eq 2.9 }
      it { expect(card.number_repetitions).to eq 4 }
      it { expect(card.repetition_interval).to eq 46 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 46.day }
    end
  end

  describe "check correct answer and 10 < time answer <= 15 seconds" do
    before(:each) do
      card.verify_translation("Fruit", "12.391")
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 1 and repetition_interval = 1" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 1 }
      it { expect(card.repetition_interval).to eq 1 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 1.day }
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 2 and repetition_interval = 6" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 1,
                                      repetition_interval: 1, review_date: DateTime.now.utc + 12.hour + 1.day }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 2 }
      it { expect(card.repetition_interval).to eq 6 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 6.day }
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 3 and repetition_interval = 15" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 2,
                                      repetition_interval: 6, review_date: DateTime.now.utc  + 12.hour + 6.day }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 3 }
      it { expect(card.repetition_interval).to eq 15 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 15.day }
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 4 and repetition_interval = 37" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 3,
                                      repetition_interval: 15, review_date: DateTime.now.utc  + 12.hour + 15.day }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 4 }
      it { expect(card.repetition_interval).to eq 37 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour + 37.day }
    end
  end

  describe "check correct answer and 15 < time answer <= 20 seconds" do
    before(:each) do
      card.verify_translation("Fruit", "18.127")
    end

    context "fields are equals: easiness_factor = 2.4, number_repetitions = 0 and repetition_interval = 0" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.4 }
      it { expect(card.number_repetitions).to eq 0 }
      it { expect(card.repetition_interval).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour }
    end

    context "fields are equals: easiness_factor = 2.4, number_repetitions = 0 and repetition_interval = 0" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.4, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.3 }
      it { expect(card.number_repetitions).to eq 0 }
      it { expect(card.repetition_interval).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour }
    end
  end

  describe "check correct answer and time answer > 20 seconds" do
    before(:each) do
      card.verify_translation("Fruit", "23.562")
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 0 and repetition_interval = 0" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 0 }
      it { expect(card.repetition_interval).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour }
    end
  end

  describe "check wrong answer and 0 < time answer < =10 seconds" do
    before(:each) do
      card.verify_translation("Apple", "3.452")
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 0 and repetition_interval = 0" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 0 }
      it { expect(card.repetition_interval).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour }
    end
  end

  describe "check wrong answer and time answer > 10 seconds" do
    before(:each) do
      card.verify_translation("Apple", "17.281")
    end

    context "fields are equals: easiness_factor = 2.5, number_repetitions = 0 and repetition_interval = 0" do
      let(:card) { FactoryGirl.create :card, easiness_factor: 2.5, number_repetitions: 0,
                                      repetition_interval: 0, review_date: DateTime.now.utc }
      it { expect(card.easiness_factor).to eq 2.5 }
      it { expect(card.number_repetitions).to eq 0 }
      it { expect(card.repetition_interval).to eq 0 }
      it { expect(card.review_date).to eq DateTime.now.utc + 12.hour }
    end
  end
end