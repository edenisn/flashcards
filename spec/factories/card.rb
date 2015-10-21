FactoryGirl.define do

  factory :card do
    original_text 'Fruit'
    translated_text 'Фрукт'
    review_date DateTime.now
    easiness_factor 2.5
    number_repetitions 0
    repetition_interval 0
    association :pack
  end

end