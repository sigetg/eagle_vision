# A student's waitlist requests: the request form (P3, S3, S4) and
# My requests (P4, S5, S6), with Edit and Withdraw while a request waits.
class RequestsController < ApplicationController
  include WaitlistRequestLoading

  before_action :load_course_and_option, only: %i[ new create ]

  def index
    authorize :waitlist_request, :index?
    requests = set_api_service.get_waitlist_requests_by_student(current_viewer.person_id)
                              .map { |data| WaitlistRequest.from_api(data) }
                              .select { |waitlist_request| waitlist_request.status && waitlist_request.term_id == current_term["id"] }
    fill_in_requests(requests)
    @groups = RequestStatus::ALL.index_with do |status|
      requests.select { |waitlist_request| waitlist_request.status == status }.sort_by { |r| r.sent_at || Time.current }.reverse
    end
  end

  def new
    authorize :waitlist_request, :create?
    @answers = RequestAnswers.new(grading: @option.gradings.first)
    @accepted_group_ids = [ @option.group_id ]
  end

  def create
    authorize :waitlist_request, :create?
    @answers = RequestAnswers.new(answer_params)
    @accepted_group_ids = Array(params[:group_ids]).compact_blank
    @accepted_group_ids = [ @option.group_id ] if @accepted_group_ids.empty?
    return render(:new, status: 422) unless @answers.valid?

    send_request
    redirect_to requests_path, notice: "Request sent"
  end

  def edit
    @waitlist_request = load_waitlist_request(params[:id])
    authorize @waitlist_request, :update?
    @answers = @waitlist_request.answers
  end

  def update
    @waitlist_request = load_waitlist_request(params[:id])
    authorize @waitlist_request, :update?
    @answers = RequestAnswers.new(answer_params.merge(grading: @waitlist_request.answers.grading))
    return render(:edit, status: 422) unless @answers.valid?

    @waitlist_request.answers = @answers
    set_api_service.update_waitlist_request(@waitlist_request.id, @waitlist_request.to_api)
    redirect_to requests_path, notice: "Request updated"
  end

  # Withdrawing deletes the request from the API (S6).
  def destroy
    waitlist_request = load_waitlist_request(params[:id])
    authorize waitlist_request, :destroy?
    set_api_service.delete_waitlist_request(waitlist_request.id)
    redirect_to requests_path, notice: "Request withdrawn"
  end

  private

  def answer_params
    params.fetch(:answers, {}).permit(:class_year, :major, :reason, :grading)
  end

  def load_course_and_option
    catalog = CourseCatalog.new(api: set_api_service, term_id: current_term["id"])
    @course = catalog.find(params[:course_id])
    @options = SectionOption.from_groups(catalog.groups(@course.id))
    group = params[:group].presence || Array(params[:group_ids]).first
    @option = @options.find { |option| option.group_ids.include?(group) } || raise(ApiService::NotFound.new(group))
  end

  # Three API calls, as the 2024 app made them: create the request for the
  # chosen sign-up option, save the answers on it, then submit it.
  def send_request
    group_id = @option.groups.find { |group| group.name.to_s.split(" - ")[1] == @answers.grading }&.id || @option.group_id
    waitlist_request = WaitlistRequest.from_api(set_api_service.create_waitlist_request(current_viewer.person_id, group_id))
    waitlist_request.answers = @answers
    waitlist_request.decision = StaffDecision.new
    waitlist_request.item.preferredActivityOfferingIds = [ @option.sections.map(&:id).join(" ") ]
    waitlist_request.item.preferredRegistrationGroupIds = ([ group_id ] + @accepted_group_ids).uniq
    set_api_service.update_waitlist_request(waitlist_request.id, waitlist_request.to_api)
    set_api_service.change_waitlist_request_state(waitlist_request.id, RequestStatus.key_for(:waiting))
  end
end
