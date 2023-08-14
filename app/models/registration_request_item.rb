class RegistrationRequestItem < ActiveResource::Base
  self.site = "http://127.0.0.1:3000"
  belongs_to :registration_request
  belongs_to :person
end
