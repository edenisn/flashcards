FactoryGirl.define do

  factory :card do
    original_text 'Fruit'
    translated_text 'Фрукт'
    association :user

    before(:create) do |card|
      card.update_attributes(review_date: Date.today + 3.days)
    end
  end

end