class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentication_class = Authentication
  end

  has_many :packs, dependent: :destroy
  belongs_to :current_pack, class_name: "Pack"
  has_many :cards, through: :packs
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :email, uniqueness: true,
            presence: true,
            format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  def self.notify_review_cards
    User.includes(:cards)
        .where("cards.review_date <= ?", DateTime.now).references(:cards).each do |user|
      NotificationsMailer.pending_cards(user).deliver_now
    end
  end

  def review_cards
    if current_pack
      current_pack.cards.for_review
    else
      cards.for_review
    end
  end

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def has_linked_twitter?
    authentications.where(provider: 'twitter').present?
  end
end
