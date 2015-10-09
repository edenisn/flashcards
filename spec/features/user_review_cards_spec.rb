require 'rails_helper'

describe 'User' do

  let!(:user) { FactoryGirl.create(:user) }

  context "have current pack and cards for review from this pack" do
    before(:each) do
      pack = FactoryGirl.create(:pack, user: user)
      card = create(:card, pack: pack, original_text: "test", translated_text: "тест", review_date: DateTime.now)

      login("person1@example.com", "password")
      set_current_pack("person1@example.com", "password", "password")

      click_link "Все карточки"
      click_link "Редактировать"
      select "2010", from: "card_review_date_1i"
      select "1", from: "card_pack_id"
      click_button "Создать/Обновить"
    end

    it "can review cards" do
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

  context "have no current pack and have cards for review" do
    before(:each) do
      pack = FactoryGirl.create(:pack, user: user)
      card = create(:card, pack: pack, original_text: "test", translated_text: "тест", review_date: DateTime.now)

      login("person1@example.com", "password")

      click_link "Все карточки"
      click_link "Редактировать"
      select "2010", from: "card_review_date_1i"
      select "1", from: "card_pack_id"
      click_button "Создать/Обновить"
    end

    it "can review cards" do
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
    it "can't review cards" do
      visit root_path
      click_link "Перейти на страницу тренировки"
      expect(page).to_not have_content "Открывайте тренировщик потом"
    end
  end

end
