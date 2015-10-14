desc "This task is called by the Heroku scheduler add-on"
task pending_cards: :environment do
  puts "Sending email..."
  User.notify_review_cards
  puts "done"
end