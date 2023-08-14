class CourseOffering < ActiveResource::Base
  self.site = "http://127.0.0.1:3000"
  belongs_to :term
  has_many :activity_offerings
end
