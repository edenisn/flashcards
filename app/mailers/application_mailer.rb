class ApplicationMailer < ActionMailer::Base
  default from: ENV['DELIVERY_FROM_EMAIL']
  layout 'mailer'
end
