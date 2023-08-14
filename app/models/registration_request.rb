class RegistrationRequest < ActiveResource::Base
  self.site = "http://127.0.0.1:3000"
  belongs_to :person
  belongs_to :term
end
