require 'rails_helper'

describe "User sign up" do

  let!(:user) { FactoryGirl.create(:user) }

  it "with valid email and password" do
    login('person1@example.com', 'password')
    expect(page).to have_content('Выйти')
  end

  it "with invalid email and password" do
    login("person1@example.com", "password1")
    expect(page).to have_content('Войти')
  end

  it "with blank password" do
    login("person1@example.com", "")
    expect(page).to have_content('Войти')
  end

end