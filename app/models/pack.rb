class Pack < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :name, uniqueness: { message: 'Колода с таким именем уже существует' },
                   presence: { message: 'Поле не может быть пустым' }
end
