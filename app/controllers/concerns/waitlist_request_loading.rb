# Loads waitlist requests from the API as WaitlistRequest objects, with their
# sections (and, when asked, the student's name) filled in.
module WaitlistRequestLoading
  extend ActiveSupport::Concern

  private

  def load_waitlist_request(id, with_student: false)
    waitlist_request = WaitlistRequest.from_api(set_api_service.get_waitlist_request(id))
    fill_in_requests([ waitlist_request ], with_student: with_student).first
  end

  def fill_in_requests(waitlist_requests, with_student: false)
    waitlist_requests.each do |waitlist_request|
      waitlist_request.sections = waitlist_request.section_ids.filter_map do |section_id|
        set_api_service.fetch_and_map_waitlistactivityofferings(section_id)
      rescue ApiService::NotFound
        nil
      end
      if with_student
        waitlist_request.student_name = set_api_service.fetch_person_profile(waitlist_request.student_id).person.name
      end
    end
  end
end
