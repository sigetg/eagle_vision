module Staff
  # The request queue (Q1, A1) and the request page (Q2, A2, A3).
  class RequestsController < BaseController
    include ViewPagination
    include WaitlistRequestLoading

    def index
      authorize :waitlist_request, :queue?
      @queue = RequestQueue.new(api: set_api_service, viewer: current_viewer, term_id: current_term["id"])
      @status = params[:status].presence_in(RequestStatus::ALL.map(&:to_s)) || "waiting"
      @rows = @queue.filter(status: @status, department_id: params[:department], course_code: params[:course],
                            student: params[:student], sort: params[:sort])
      @page, @rows = paginate_array(@rows, per_page: RequestQueue::PER_PAGE)
      @queue.fill_in(@rows) { |waitlist_request| sections_for(waitlist_request) }
    end

    def show
      @waitlist_request = load_waitlist_request(params[:id], with_student: true)
      authorize @waitlist_request, :show?
      @student = set_api_service.fetch_person_profile(@waitlist_request.student_id).person
      @groups = course_groups
      @other_requests_count = other_requests_count
    end

    private

    # The course's sign-up options by id, to name the other combinations the
    # student would accept.
    def course_groups
      return {} unless @waitlist_request.course_offering_id

      set_api_service.fetch_and_map_waitlistregistrationgroups(@waitlist_request.course_offering_id)
                     .index_by { |group| group[:registration_group].id }
    end

    def other_requests_count
      return 0 unless @waitlist_request.course_offering_id

      set_api_service.get_waitlist_requests_by_course_offering(@waitlist_request.course_offering_id)
                     .count { |data| data[:registrationRequest].id != @waitlist_request.id }
    end
  end
end
