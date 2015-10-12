class NotificationsMailer < ApplicationMailer
  default from: "from@example.com"

  def pending_cards(user)
    @user = user
    mail(to: @user.email, subject: "Flashcards: непросмотренные карточки")
  end
end
