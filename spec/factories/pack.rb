FactoryGirl.define do

  factory :pack do
    sequence(:name) { |n| "pack#{n}" }
    association :user
  end

end