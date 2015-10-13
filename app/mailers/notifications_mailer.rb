class NotificationsMailer < ApplicationMailer
  default from: ENV['DELIVERY_FROM_EMAIL']

  def pending_cards(user)
    @user = user
    mail(to: @user.email, subject: "Flashcards: непросмотренные карточки")
  end
end
