class Pack < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  scope :current_and_true, -> { where(current: true) }

  validates :name, uniqueness: { message: 'Колода с таким именем уже существует' },
                   presence: { message: 'Поле не может быть пустым' }
end
