# Anyone signed in may browse courses. Only students request a spot, and only
# staff see a course's requests.
class CoursePolicy < ApplicationPolicy
  def index? = true
  def show? = true
  def request_spot? = user.student?
  def see_requests? = user.staff?
end
