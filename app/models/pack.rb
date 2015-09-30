class Pack < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  scope :current_and_true, -> { where(current: true).first }

  validates :name, presence: { message: 'Поле не может быть пустым' }
end
