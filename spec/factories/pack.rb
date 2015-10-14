FactoryGirl.define do

  factory :pack do
    name 'pack1'
    association :user
  end

end