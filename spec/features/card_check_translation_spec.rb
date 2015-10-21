require 'rails_helper'

describe 'Check user translation' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:pack) { FactoryGirl.create(:pack, user: user) }
  let!(:card) { pack.cards.create(original_text: "test", translated_text: "тест", review_date: DateTime.now.utc) }

  before(:each) do
    login("person1@example.com", "password")
  end

  it "is correct translation shows for user" do
    visit root_path
    click_link "Перейти на страницу тренировки"
    fill_in :review_user_translation, with: "test"
    click_button "Проверить"
    expect(page).to have_content "Открывайте тренировщик потом"
  end

  it "is incorrect translation shows for user" do
    visit root_path
    click_link "Перейти на страницу тренировки"
    fill_in :review_user_translation, with: "qwerty"
    click_button "Проверить"
    expect(page).to have_content "Неправильно!"
  end

end