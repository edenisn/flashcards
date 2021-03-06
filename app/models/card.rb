class Card < ActiveRecord::Base
  belongs_to :pack

  scope :for_review, -> { where("review_date <= ?", DateTime.now).order("RANDOM()") }

  has_attached_file :image,
    styles: { thumb: "100x100>", large: "360x360#" },
    default_url: "/images/:style/missing.png"

  before_create :set_default_review_date

  validates :pack_id, presence: true
  validates :original_text, :translated_text, :review_date, presence: true

  validate :original_text_cannot_be_equal_translated_text

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { in: 0..5.megabytes }

  def self.create_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    if pack_name.present?
      new_pack = user.packs.find_or_create_by(name: pack_name)
      card = new_pack.cards.new(card_params.merge(pack_id: new_pack.id))
    else
      pack = user.packs.find_by(id: card_params[:pack_id])
      card = pack.cards.new(card_params)
    end
    card
  end

  def update_from_pack(user, card_params)
    pack_name = card_params.delete(:new_pack_name)
    if pack_name.present?
      new_pack = user.packs.find_or_create_by(name: pack_name)
      update(card_params.merge(pack_id: new_pack.id))
    else
      update(card_params)
    end
  end

  def verify_translation(user_translation, translation_time)
    time = translation_time.to_i

    result = transform_string(original_text) == transform_string(user_translation)

    quantity_of_response = result ? SM2CardsReviewer.translating_card_time(time) : 0

    sm2 = SM2CardsReviewer.new(self.easiness_factor, self.number_repetitions,
                               self.repetition_interval, self.review_date)

    sm2.processing_count_result(quantity_of_response)

    update(easiness_factor: sm2.easiness_factor,
           number_repetitions: sm2.number_repetitions,
           repetition_interval: sm2.repetition_interval,
           review_date: sm2.review_date)
    result
  end

  private
    def original_text_cannot_be_equal_translated_text
      if original_text.mb_chars.downcase == translated_text.mb_chars.downcase
        errors.add(:translated_text, I18n.t('views.cards.flash_messages.original_text_not_equal_translated_text'))
      end
    end

    def set_default_review_date
      self.review_date = DateTime.now
    end

    def transform_string(str)
      str.squish.mb_chars.downcase # remove spaces and downcase string (mb_chars - for UTF-8 encoding)
    end
end
