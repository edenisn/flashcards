FactoryGirl.define do

  factory :pack do
    sequence(:name) { |n| "pack#{n}" }
    current true
    association :user
  end

end