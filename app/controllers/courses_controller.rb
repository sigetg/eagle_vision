# Find courses (P1, S1, Q4) and the course page (P2, S2, Q3), for students
# and staff. Staff see only their departments' courses, a waiting count on
# each card, and the course's requests on its page.
class CoursesController < ApplicationController
  include ViewPagination
  include WaitlistRequestLoading

  def index
    authorize :course, :index?
    @catalog = CourseCatalog.new(api: set_api_service, term_id: current_term["id"])
    @filters = CourseCatalog::Filters.new(
      q: params[:q].to_s.strip, department: params[:department].presence, level: params[:level].presence,
      days: Array(params[:days]).compact_blank & CourseCatalog::DAYS, time: params[:time].presence_in(CourseCatalog::TIMES.keys),
      professor: params[:professor].to_s.strip.presence, open: params[:open] == "1", waiting: params[:waiting] == "1"
    )
    rows = @catalog.search(@filters, within: visible_courses)
    if current_user.staff?
      @waiting_counts = waiting_counts
      rows = rows.select { |course| @waiting_counts[course.courseOfferingCode].to_i.positive? } if @filters.waiting
    end
    @page, @courses = paginate_array(rows, per_page: CourseCatalog::PER_PAGE)
    @catalog.prefetch_groups(@courses)
  end

  def show
    authorize :course, :show?
    @catalog = CourseCatalog.new(api: set_api_service, term_id: current_term["id"])
    @course = @catalog.find(params[:id])
    @options = SectionOption.from_groups(@catalog.groups(@course.id))
    return unless current_user.staff?

    @requests = fill_in_requests(
      set_api_service.get_waitlist_requests_by_course_offering(@course.id).map { |data| WaitlistRequest.from_api(data) },
      with_student: true
    ).select(&:status).sort_by { |waitlist_request| waitlist_request.sent_at || Time.current }
  end

  private

  def visible_courses
    return @catalog.courses unless current_user.staff?

    department_ids = current_viewer.department_ids
    @catalog.courses.select { |course| Array(course.unitsDeploymentOrgIds).map(&:to_s).intersect?(department_ids) }
  end

  # Waiting requests per course code, from the staff member's queue.
  def waiting_counts
    Rails.cache.fetch([ "waiting-by-course", current_user.id, current_term["id"] ], expires_in: 1.minute) do
      RequestQueue.new(api: set_api_service, viewer: current_viewer, term_id: current_term["id"])
                  .filter(status: :waiting).each_with_object(Hash.new(0)) do |waitlist_request, counts|
        counts[waitlist_request.request.name.to_s.split.last] += 1
      end
    end
  end
end
