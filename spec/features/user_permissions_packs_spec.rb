require 'rails_helper'

describe Pack do

  let!(:user) { create(:user) }

  context "authorized user" do
    before(:each) do
      pack = FactoryGirl.create(:pack, user: user)

      login("person1@example.com", "password")
      visit root_path
    end

    it "can update pack" do
      click_link "Все колоды"
      click_link "Редактировать"
      fill_in :pack_name, with: "222"
      click_button "Создать/Обновить"
      expect(page).to have_content "Колода успешно обновлена"
    end

    it "can create pack" do
      click_link "Новая колода"
      fill_in :pack_name, with: "333"
      click_button "Создать/Обновить"
      expect(page).to have_content "Колода успешно создана"
    end
  end

  context "not authorized user" do
    before(:each) do
      login("person1@example.com", "")
      visit root_path
    end

    it "can't show all packs" do
      click_link "Новая колода"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end

    it "can't create pack" do
      click_link "Новая колода"
      expect(page).to have_content "Необходимо зарегистрироваться на сайте"
    end
  end

end