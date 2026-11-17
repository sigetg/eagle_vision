class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  # Every action must call `authorize` (or skip_authorization). If one forgets,
  # verify_authorized raises, so the spec for that page fails.
  after_action :verify_authorized, unless: :devise_controller?

  # rescue_from catches an error raised anywhere in an action (or its
  # before_actions) and calls the named method instead of showing a crash.
  rescue_from ApiService::Unavailable, with: :render_api_unavailable
  rescue_from ApiService::NotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  helper_method :current_viewer, :current_term, :student_home_path, :staff_home_path,
                :staff_courses_home_path, :my_requests_home_path

  def set_api_service
    @api_service ||= ApiService.new
  end

  def set_person_and_terms
    set_api_service
    @person = current_viewer.profile.person
    @terms = current_viewer.terms
    session[:term] = @terms[0] if session[:term].nil? || @terms.none? { |term| term["id"] == session[:term]["id"] }
  end

  # The signed-in user with what the API knows about them. Pundit passes it to
  # every policy as `user`.
  def current_viewer
    @current_viewer ||= Viewer.new(current_user, set_api_service) if current_user
  end

  def pundit_user = current_viewer

  def current_term
    session[:term] ||= current_viewer.terms.first
  end

  # Each role's pages. These move to the rebuilt screens PR by PR.
  def student_home_path = courses_path
  def my_requests_home_path = registration_requests_path
  def staff_home_path = staff_requests_path
  def staff_courses_home_path = courses_path

  private

  # The number on the top bar's Requests link: waiting requests in this
  # term. Cached for a minute so it doesn't cost a page its speed.
  def waiting_count_for_badge
    return unless current_user&.staff? && current_term

    Rails.cache.fetch([ "waiting-count", current_user.id, current_term["id"] ], expires_in: 1.minute) do
      RequestQueue.new(api: set_api_service, viewer: current_viewer, term_id: current_term["id"]).counts[:waiting]
    end
  end

  def render_api_unavailable
    skip_authorization
    render "errors/unavailable", status: :service_unavailable
  end

  def render_not_found
    skip_authorization
    render "errors/not_found", status: :not_found
  end

  def render_forbidden
    render "errors/forbidden", status: :forbidden
  end
end
