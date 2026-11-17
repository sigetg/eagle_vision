module Staff
  # The request queue (Q1, A1): waiting requests in the staff member's
  # departments, oldest first, with count tiles, filters and student search.
  class RequestsController < BaseController
    include ViewPagination

    def index
      authorize :waitlist_request, :queue?
      @queue = RequestQueue.new(api: set_api_service, viewer: current_viewer, term_id: current_term["id"])
      @status = params[:status].presence_in(RequestStatus::ALL.map(&:to_s)) || "waiting"
      @rows = @queue.filter(status: @status, department_id: params[:department], course_code: params[:course],
                            student: params[:student], sort: params[:sort])
      @page, @rows = paginate_array(@rows, per_page: RequestQueue::PER_PAGE)
      @queue.fill_in(@rows)
    end
  end
end
