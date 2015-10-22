require 'rails_helper'

describe "User" do

  let!(:user) { FactoryGirl.create(:user) }

  context "authorized" do
    before(:each) do
      pack = FactoryGirl.create(:pack, user: user)
      card = create(:card, pack: pack, original_text: "city", translated_text: "город", review_date: DateTime.now.utc)

      login("person1@example.com", "password")
      visit root_path
    end

    it "can update card" do
      click_link "Все карточки"
      click_link "Редактировать"
      fill_in :card_original_text, with: "qwerty"
      select "2013", from: "card_review_date_1i"
      select "1", from: "card_pack_id"
      fill_in :card_new_pack_name, with: "test_qwerty"
      click_button "Создать/Обновить"
      expect(page).to have_content "Карточка успешно обновлена"
    end

    it "can show all his cards" do
      click_link "Все карточки"
      expect(page).to have_content "Оригинальный текст"
    end

    it "can add card" do
      click_link "Новая карточка"
      fill_in :card_original_text, with: "Card"
      fill_in :card_translated_text, with: "Карточка"
      select "Сентябрь", from: "card_review_date_2i"
      select "1", from: "card_review_date_3i"
      select "1", from: "card_pack_id"
      fill_in :card_new_pack_name, with: "test_pack"
      click_button "Создать/Обновить"
      expect(page).to have_content "Карточка успешно создана"
    end
  end

  context "authorized another user" do
    before(:each) do
      @user2 = User.create(email: "person2@example.com", password: "qwerty", password_confirmation: "qwerty")
      @card2 = @user2.cards.create(original_text: "test", translated_text: "тест", review_date: DateTime.now.utc)

      login("person2@example.com", "qwerty")
      visit root_path
    end

    it "can't see cards that owned by other users" do
      click_link "All Cards"
      expect(page).not_to have_content "city"
    end
  end

  context "not authorized" do
    before(:each) do
      login("person1@example.com", "")
      visit root_path
    end

    it "can't show all packs" do
      click_link "Все колоды"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end

    it "can't add pack" do
      click_link "Новая колода"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end

    it "can't show all cards" do
      click_link "Все карточки"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end

    it "can't add card" do
      click_link "Новая карточка"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end
  end

end