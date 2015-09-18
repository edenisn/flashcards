class Card < ActiveRecord::Base
  scope :get_random_card, -> time { where("review_date <= ?", time).order("RANDOM()") }

  before_update :set_default_review_date

  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  def self.get_random_card(time)
    where("review_date <= ?", time).order("RANDOM()") # get random row from postgresql with date <= DateTime.now
  end

  def verify_translate(original, translated)
    remove_spaces_from_str(original) == remove_spaces_from_str(translated) ? true : false
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
      str.gsub(/\s+/, "").mb_chars.downcase
    end
end
