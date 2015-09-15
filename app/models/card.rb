class Card < ActiveRecord::Base
  validates :original_text, :translated_text, :review_date, presence: true

  validate :original_text_cannot_be_equal_translated_text

  def original_text_cannot_be_equal_translated_text
    errors.add(:translated_text, "Переведенный текст не должен совпадать с оригиналом!") if original_text.casecmp(translated_text) == 0
  end
end
