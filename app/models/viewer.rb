# The signed-in user plus what the waitlist API says about them: their name,
# active terms and (for staff) authorized departments. Pundit policies get a
# Viewer as their `user`. The API is asked once per page, and only if needed.
class Viewer
  attr_reader :user

  delegate :student?, :staff?, :email, :id, to: :user

  def initialize(user, api)
    @user = user
    @api = api
  end

  def person_id = user.person_id.to_s

  def profile
    @profile ||= @api.fetch_person_profile(person_id)
  end

  def name = profile.person.name
  def terms = profile.terms
  def departments = profile.departments

  def department_ids
    staff? ? departments.map { |department| department.id.to_s } : []
  end
end
