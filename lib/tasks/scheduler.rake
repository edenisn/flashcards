desc "This task is called  by the Heroku scheduler add-on"
task card_pending: :environment do
  User.notify_review_cards
end