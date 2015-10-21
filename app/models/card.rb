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

  # after each repetition access the quality of repetition response in 0-5 grade scale
  QUALITY_OF_RESPONSE = [0, 1, 2, 3, 4, 5]

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

  def verify_translation(user_translation, translate_time)
    sm2 = SM2CardsReviewer.new(self.easiness_factor, self.number_repetitions,
                               self.repetition_interval, self.review_date)
    time = translate_time.to_i

    if (transform_string(original_text) == transform_string(user_translation)) && (time > 0 && time <=15)
      sm2.processing_count_result(translating_card_time(time))

      update(easiness_factor: sm2.easiness_factor,
             number_repetitions: sm2.number_repetitions,
             repetition_interval: sm2.repetition_interval,
             review_date: sm2.review_date)

      true
    elsif (transform_string(original_text) == transform_string(user_translation)) && time > 15
      sm2.processing_count_result(translating_card_time(time))

      update(easiness_factor: sm2.easiness_factor,
             number_repetitions: sm2.number_repetitions,
             repetition_interval: sm2.repetition_interval,
             review_date: sm2.review_date)

      true
    else
      sm2.processing_count_result(translating_card_time(0))

      update(easiness_factor: sm2.easiness_factor,
             number_repetitions: sm2.number_repetitions,
             repetition_interval: sm2.repetition_interval,
             review_date: sm2.review_date)

      false
    end
  end

  def translating_card_time(translate_time)
    if translate_time > 0 && translate_time <= 10
      QUALITY_OF_RESPONSE[5] # perfect response
    elsif translate_time > 10 && translate_time <= 15
      QUALITY_OF_RESPONSE[4] # correct response after a hesitation
    elsif translate_time > 15 && translate_time <= 20
      QUALITY_OF_RESPONSE[3] # correct response recalled with serious difficulty
    elsif translate_time > 20 && translate_time <= 25
      QUALITY_OF_RESPONSE[2] # incorrect response
    elsif translate_time > 25 && translate_time <= 30
      QUALITY_OF_RESPONSE[1] # incorrect response
    else
      QUALITY_OF_RESPONSE[0] # complete blackout
    end
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
