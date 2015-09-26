class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentication_class = Authentication
  end

  has_many :cards, dependent: :destroy
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 6, message: "Длина пароля должна быть не меньше 6 символов" },
            if: -> { new_record? || changes["password"] }
  validates :password, confirmation: { message: "Пароли не совпадают" },
            if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: { message: "Поле не может быть пустым" },
            if: -> { new_record? || changes["password"] }

  validates :email, uniqueness: { message: 'Такой email уже существует' }, presence: { message: "Поле не может быть пустым" },
            :format => { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: 'Введите правильный формат email: username@host.com' }

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def has_linked_twitter?
    authentications.where(provider: 'twitter').present?
  end
end
