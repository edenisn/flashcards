FactoryGirl.define do

  factory :card do
    original_text 'Fruit'
    translated_text 'Фрукт'
    review_date DateTime.now
    wrong_counter 0
    correct_counter 0
    association :pack
  end

end