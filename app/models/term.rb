class Term < ActiveResource::Base
  self.site = "http://127.0.0.1:3000"
  has_many :registration_requests
  has_many :activity_offerings
  has_many :course_offerings
end
