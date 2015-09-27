require 'rails_helper'

describe 'Authorized user' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:card) { user.cards.create(original_text: "test", translated_text: "тест", review_date: Date.today) }

  context "have cards for review" do

    before(:each) do
      login("person1@example.com", "password")
      click_link "Все карточки"
      click_link "Редактировать"
      select "2013", from: "card_review_date_1i"
      click_button "Создать/Обновить"
    end

    it "can possibility to review cards" do
      visit root_path
      click_link "Перейти на страницу тренировки"
      expect(page).to have_button "Проверить"
    end

    it "doesn't show page with no cards for review" do
      visit root_path
      click_link "Перейти на страницу тренировки"
      expect(page).to_not have_content "Открывайте тренировщик потом"
    end

  end

  context "have no cards for review" do

    it "can't possibility for review cards" do
      visit root_path
      click_link "Перейти на страницу тренировки"
      expect(page).to_not have_content "Карточка #"
    end

  end

end
