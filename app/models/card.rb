require 'active_support/all'

class Card < ActiveRecord::Base
  scope :created_before, -> time { where("review_date <= ?", time) }
  scope :random, -> { order("RANDOM()") }

  before_update :add_3_days_to_review_date_after_update

  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  def self.created_before(time)
    where("review_date <= ?", time)
  end

  def self.random
    order("RANDOM()") # get random row from postgresql
  end

  def verify_translate(original, translated)
    if original.mb_chars == translated.mb_chars
      add_3_days_to_review_date_after_update
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

    def add_3_days_to_review_date_after_update
      self.review_date += 3.days
    end
end
