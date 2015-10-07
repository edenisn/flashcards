class Card < ActiveRecord::Base
  belongs_to :pack

  scope :for_review, -> { where("review_date <= ?", Date.today).order("RANDOM()") }

  has_attached_file :image, styles: { thumb: "100x100>", large: "360x360#" }

  before_create :set_default_review_date

  validates :pack_id, presence: { message: "Необходимо выбрать колоду" }
  validates :original_text, :translated_text, :review_date, presence: { message: 'Поле не может быть пустым' }

  validate :original_text_cannot_be_equal_translated_text

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { in: 0..5.megabytes }

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
