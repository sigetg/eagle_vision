class RegistrationRequestMailer < ApplicationMailer

  def registration_request_changed(user, registration_request)
    @user = user
    @registration_request = registration_request
    mail(to: @user.email, subject: 'Your Registration Request Update')
  end

end
