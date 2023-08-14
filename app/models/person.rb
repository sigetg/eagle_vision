class Person < ActiveResource::Base
  self.site = "http://127.0.0.1:3000"
  has_many :registration_request_items
  has_many :registration_requests
  belongs_to :user
end
