class Card < ActiveRecord::Base

  before_update do
    self.review_date += 3.days
  end

  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  def original_text_cannot_be_equal_translated_text
    if original_text.casecmp(translated_text) == 0
      errors.add(:translated_text, 'Переведенный текст не должен совпадать с оригиналом!')
    end
  end
end
