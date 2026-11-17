class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "Eagle Vision <no-reply@eaglevision.example>")
  layout "mailer"
end
