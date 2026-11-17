# Loads waitlist requests from the API as WaitlistRequest objects, with their
# sections (and, when asked, the student's name) filled in.
module WaitlistRequestLoading
  extend ActiveSupport::Concern

  private

  def load_waitlist_request(id, with_student: false)
    waitlist_request = WaitlistRequest.from_api(set_api_service.get_waitlist_request(id))
    fill_in_requests([ waitlist_request ], with_student: with_student)
    assign_staff_department(waitlist_request) if current_user.staff?
    waitlist_request
  end

  def fill_in_requests(waitlist_requests, with_student: false)
    waitlist_requests.each do |waitlist_request|
      waitlist_request.sections = sections_for(waitlist_request)
      if with_student
        waitlist_request.student_name = set_api_service.fetch_person_profile(waitlist_request.student_id).person.name
      end
    end
  end

  # The API can't look up every section by id (some answer 404), so fall
  # back to the sections of the course named in the request.
  def sections_for(waitlist_request)
    found = waitlist_request.section_ids.filter_map do |section_id|
      set_api_service.fetch_and_map_waitlistactivityofferings(section_id)
    rescue ApiService::NotFound
      nil
    end
    return found if found.size == waitlist_request.section_ids.size

    by_id = course_sections_by_id(waitlist_request)
    waitlist_request.section_ids.filter_map { |section_id| by_id[section_id] }
  end

  def course_sections_by_id(waitlist_request)
    term_id = waitlist_request.term_id.presence || current_term&.dig("id")
    catalog = CourseCatalog.new(api: set_api_service, term_id: term_id)
    code = waitlist_request.request.name.to_s.split.last
    course = catalog.courses.find { |candidate| candidate.courseOfferingCode == code }
    return {} unless course

    catalog.sections(course).index_by(&:id)
  end

  # The API files each request under a department; staff may act on it when
  # it appears in one of their departments' lists.
  def assign_staff_department(waitlist_request)
    return if waitlist_request.department_ids.intersect?(current_viewer.department_ids)

    queue = RequestQueue.new(api: set_api_service, viewer: current_viewer, term_id: waitlist_request.term_id)
    match = queue.load.find { |candidate| candidate.id == waitlist_request.id }
    waitlist_request.department_id = match&.department_id
  end
end
