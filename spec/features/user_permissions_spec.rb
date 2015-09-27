require 'rails_helper'

describe "User" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:card) { user.cards.create(original_text: "test", translated_text: "тест", review_date: Date.today) }

  context "authorized" do

    before(:each) do
      user = FactoryGirl.create(:user)
      card = create(:card, user: user, original_text: "city", translated_text: "город")

      login("person1@example.com", "password")
      visit root_path
    end

    it "can update card" do
      click_link "Все карточки"
      click_link "Редактировать"
      fill_in :card_original_text, with: "qwerty"
      select "2013", from: "card_review_date_1i"
      click_button "Создать/Обновить"
      expect(page).to have_content "Карточка успешно обновлена"
    end

    it "can show all his cards" do
      click_link "Все карточки"
      expect(page).to have_content "Оригинальное слово"
    end

    it "can add card" do
      click_link "Добавить карточку"
      fill_in :card_original_text, with: "Card"
      fill_in :card_translated_text, with: "Карточка"
      select "September", from: "card_review_date_2i"
      select "1", from: "card_review_date_3i"
      save_and_open_page
      click_button "Создать/Обновить"
      expect(page).to have_content "Карточка успешно создана"
    end

    it "can't see cards that owned by another user" do
      click_link "Все карточки"
      expect(page).not_to have_content "city"

    end

  end

  context "not authorized" do

    before(:each) do
      login("person1@example.com", "")
      visit root_path
    end

    it "can't show all cards" do
      click_link "Все карточки"
      expect(page).to have_content "Необходима регистрация"
    end

    it "can't add card" do
      click_link "Добавить карточку"
      expect(page).to have_content "Необходима регистрация"
    end

  end

end