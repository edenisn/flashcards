FactoryGirl.define do

  factory :user do
    email 'person1@example.com'
    password 'password'
    password_confirmation { password }
    locale 'ru'
  end

end