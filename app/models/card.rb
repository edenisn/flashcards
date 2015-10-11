class Card < ActiveRecord::Base

  belongs_to :pack

  scope :for_review, -> { where("review_date <= ?", DateTime.now).order("RANDOM()") }

  has_attached_file :image, styles: { thumb: "100x100>", large: "360x360#" }

  before_create :set_default_review_date

  validates :pack_id, presence: { message: "Необходимо выбрать колоду" }
  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { in: 0..5.megabytes }

  # time intervals for review cards in Leitner system
  TIME_INTERVALS = [12.hour, 3.day, 7.day, 14.day, 1.month]
  MAX_TIME_INTERVAL = 5

  def self.create_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    new_pack = user.packs.find_or_create_by(name: pack_name)
    card = new_pack.cards.create(card_params.merge(pack_id: new_pack.id))
    card
  end

  def update_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    new_pack = user.packs.find_or_create_by(name: pack_name)
    update(card_params.merge(pack_id: new_pack.id))
  end

  def verify_translation(user_translation)
    result = Text::Levenshtein.distance(transform_string(original_text), transform_string(user_translation))
    if result < 3
      if self.correct_counter == MAX_TIME_INTERVAL
        update(review_date: DateTime.now + TIME_INTERVALS[MAX_TIME_INTERVAL - 1])
      else
        update(review_date: DateTime.now + TIME_INTERVALS[correct_counter])
        self.increment!(:correct_counter)
      end
      update(wrong_counter: 0) if self.wrong_counter != 0
      result
    else
      self.increment!(:wrong_counter)
      if self.wrong_counter == 3 # wrong translation card
        update(review_date: DateTime.now + 12.hour, wrong_counter: 0, correct_counter: 0)
      end
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
      self.review_date = DateTime.now
    end

    def transform_string(str)
      str.squish.mb_chars.downcase # remove spaces and downcase string (mb_chars - for UTF-8 encoding)
    end
end
