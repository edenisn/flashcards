class Card < ActiveRecord::Base
  scope :for_review, -> { where("review_date <= ?", DateTime.now).order("RANDOM()") }

  before_create :set_default_review_date

  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  def verify_translation(user_translation)
    if transform_string(original_text) == transform_string(user_translation)
      update(review_date: Date.today + 3.days)
      true
    else
      false
    end
  end

  private
    def original_text_cannot_be_equal_translated_text
      if original_text.mb_chars.downcase == translated_text.mb_chars.downcase
        errors.add(:translated_text, 'Переведенный текст не должен совпадать с оригиналом!')
      end
    end

    def set_default_review_date
      self.review_date = Date.today + 3.days
    end

    def transform_string(str)
      str.squish.mb_chars.downcase # remove spaces and downcase string (mb_chars - for UTF-8 encoding)
    end
end
