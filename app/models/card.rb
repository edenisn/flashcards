class Card < ActiveRecord::Base
  scope :for_review, -> { where("review_date <= ?", DateTime.now).order("RANDOM()") }

  before_update :set_default_review_date

  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  def verify_translating(original)
    if remove_spaces_from_str(self.original_text) == remove_spaces_from_str(original)
      self.update(review_date: self.review_date)
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
      self.review_date += 3.days
    end

    def remove_spaces_from_str(str)
      str.squish.mb_chars.downcase
    end
end
