require 'rails_helper'

describe 'Check user translation' do

  let!(:card) { create(:card) }

  before(:each) do
    card.update(review_date: Date.today)
  end

  it "is correct translation shows for user" do
    visit new_review_path
    fill_in :review_user_translation, with: "Fruit"
    click_button "Проверить"
    expect(card.verify_translation("Fruit")).to be true
    expect(page).to have_content "Правильно"
  end

  it "is incorrect translation shows for user" do
    visit new_review_path
    fill_in :review_user_translation, with: "Кран"
    click_button "Проверить"
    expect(card.verify_translation("Кран")).to be false
    expect(page).to have_content "Не правильно!"
  end

end