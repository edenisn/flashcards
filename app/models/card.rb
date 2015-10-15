class Card < ActiveRecord::Base
  belongs_to :pack

  scope :for_review, -> { where("review_date <= ?", DateTime.now).order("RANDOM()") }

  has_attached_file :image, styles: { thumb: "100x100>", large: "360x360#" }

  before_create :set_default_review_date

  validates :pack_id, presence: true
  validates :original_text, :translated_text, :review_date, presence: true

  validate :original_text_cannot_be_equal_translated_text

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { in: 0..5.megabytes }

  # time intervals for review cards in Leitner system
  TIME_INTERVALS = [12.hour, 3.day, 7.day, 14.day, 1.month]
  MAX_TIME_INTERVAL = 5

  def self.create_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    if pack_name.present?
      new_pack = user.packs.find_or_create_by(name: pack_name)
      card = new_pack.cards.create(card_params.merge(pack_id: new_pack.id))
    else
      pack = user.packs.find_by(id: card_params[:pack_id])
      card = pack.cards.create(card_params)
    end
    card
  end

  def update_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    new_pack = user.packs.find_or_create_by(name: pack_name)
    update(card_params.merge(pack_id: new_pack.id))
  end

  def verify_translation(user_translation)
    typos = Text::Levenshtein.distance(transform_string(original_text), transform_string(user_translation))
    if typos < 3
      processing_success_translation_update
      { result: true, typos: typos }
    else
      processing_failure_translation_update
      { result: false, typos: typos }
    end
  end

  def processing_success_translation_update
    if self.correct_counter == MAX_TIME_INTERVAL
      update(review_date: DateTime.now + TIME_INTERVALS[MAX_TIME_INTERVAL - 1], wrong_counter: 0)
    else
      update(review_date: DateTime.now + TIME_INTERVALS[correct_counter],
             correct_counter: correct_counter + 1, wrong_counter: 0)
    end
  end

  def processing_failure_translation_update
    self.increment!(:wrong_counter)
    if self.wrong_counter == 3 # wrong translation card
      update(review_date: DateTime.now + 12.hour, wrong_counter: 0, correct_counter: 0)
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
