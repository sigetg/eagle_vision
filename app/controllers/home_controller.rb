# "/" sends each role to its own home page: students to Find courses, staff
# to their request queue.
class HomeController < ApplicationController
  def show
    skip_authorization
    redirect_to current_user.staff? ? staff_home_path : student_home_path
  end
end
