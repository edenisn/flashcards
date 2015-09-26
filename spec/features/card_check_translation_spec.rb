require 'rails_helper'

describe 'Check user translation' do

  @user = FactoryGirl.create(:user)
  @card1 = @user.cards.create(original_text: "test", translated_text: "тест", review_date: Date.today)

  before(:each) do
    login("person1@example.com", "password")
    click_link "Все карточки"
    click_link "Редактировать"
    select "2010", :from => "card_review_date_1i"
    click_button "Создать/Обновить"
  end

  it "is correct translation shows for user" do
    visit root_path
    click_link "Перейти на страницу тренировки"
    fill_in :review_user_translation, with: "test"
    click_button "Проверить"
    expect(page).to have_content "Правильно"
  end

  it "is incorrect translation shows for user" do
    visit root_path
    click_link "Перейти на страницу тренировки"
    fill_in :review_user_translation, with: "qwerty"
    click_button "Проверить"
    expect(page).to have_content "Не правильно!"
  end

end