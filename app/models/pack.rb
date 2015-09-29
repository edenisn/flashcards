class Pack < ActiveRecord::Base
  has_many :cards, dependent: :destroy

  validates :name, presence: { message: 'Поле не может быть пустым' }
end
