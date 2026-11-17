# The requests a staff member may see in one term: every request for every
# one of their authorized departments, with sections and student names
# filled in. Filtering, sorting and counting happen here so the controller
# stays small.
class RequestQueue
  PER_PAGE = 25

  attr_reader :requests

  def initialize(api:, viewer:, term_id:)
    @api = api
    @viewer = viewer
    @term_id = term_id
  end

  # Every request in the staff member's departments, oldest first.
  def load
    @requests ||= begin
      by_id = {}
      @viewer.departments.each do |department|
        @api.get_waitlist_requests_by_term_and_deptId(@term_id.to_s, department.id.to_s).each do |data|
          waitlist_request = WaitlistRequest.from_api(data)
          waitlist_request.department_id = department.id.to_s
          by_id[waitlist_request.id] ||= waitlist_request
        end
      end
      by_id.values.select(&:status).sort_by { |waitlist_request| waitlist_request.sent_at || Time.current }
    end
  end

  def counts
    RequestStatus::ALL.index_with { |status| load.count { |waitlist_request| waitlist_request.status == status } }
  end

  # The departments that have at least one request, for the filter chips.
  def departments
    ids = load.map(&:department_id).uniq
    @viewer.departments.select { |department| ids.include?(department.id.to_s) }
  end

  def course_codes
    load.map(&:course_code).compact.uniq.sort
  end

  # Filters (status, department, course, student name), then sorts.
  # Sections and names are looked up only for the rows that need them.
  def filter(status: :waiting, department_id: nil, course_code: nil, student: nil, sort: "oldest")
    rows = load.select { |waitlist_request| status.blank? || waitlist_request.status == status.to_sym }
    rows = rows.select { |waitlist_request| waitlist_request.department_id == department_id } if department_id.present?
    rows = rows.select { |waitlist_request| waitlist_request.course_code == course_code } if course_code.present?
    if student.present?
      fill_in_names(rows)
      rows = rows.select { |waitlist_request| waitlist_request.student_name.to_s.downcase.include?(student.downcase) }
    end
    sort == "newest" ? rows.reverse : rows
  end

  # Names and sections for the rows on screen. sections_for is the
  # controller's (WaitlistRequestLoading), passed in as a block.
  def fill_in(rows, &sections_for)
    fill_in_names(rows)
    rows.each { |waitlist_request| waitlist_request.sections = sections_for.call(waitlist_request) }
  end

  private

  def fill_in_names(rows)
    rows.each do |waitlist_request|
      waitlist_request.student_name ||= @api.fetch_person_profile(waitlist_request.student_id).person.name
    rescue ApiService::NotFound
      waitlist_request.student_name = "Student #{waitlist_request.student_id}"
    end
  end
end
