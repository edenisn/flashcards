class Pack < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :name, uniqueness: true, presence: true
end
