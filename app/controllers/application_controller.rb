class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # rescue_from catches an error raised anywhere in an action (or its
  # before_actions) and calls the named method instead of showing a crash.
  rescue_from ApiService::Unavailable, with: :render_api_unavailable
  rescue_from ApiService::NotFound, with: :render_not_found

  def set_api_service
    @api_service = ApiService.new
  end

  def set_person_and_terms
    set_api_service
    @person, @terms = @api_service.fetch_and_map_waitlistperson_and_term(current_user.email.split("@")[0])
    if session[:term].nil?
      session[:term] = @terms[0]
    end
  end

  private

  def render_api_unavailable
    render "errors/unavailable", status: :service_unavailable
  end

  def render_not_found
    render "errors/not_found", status: :not_found
  end
end
