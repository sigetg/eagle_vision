# Who may do what with a waitlist request. A student sees, edits and
# withdraws only their own requests, and edits only while waiting. Staff see
# and decide only on requests for courses in their authorized departments.
class WaitlistRequestPolicy < ApplicationPolicy
  def index? = user.student?
  def show? = owner? || staff_for_department?
  def create? = user.student?
  def update? = owner? && record.waiting?
  def destroy? = owner? && record.waiting?
  def decide? = staff_for_department?
  def queue? = user.staff?

  private

  def owner?
    user.student? && record.student_id == user.person_id
  end

  def staff_for_department?
    user.staff? && record.department_ids.intersect?(user.department_ids)
  end
end
