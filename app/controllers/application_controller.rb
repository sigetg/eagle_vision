class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_person_and_terms, if: :person_and_term_nil? && :user_signed_in?

  def person_and_term_nil?
    session[:person].nil? || session[:terms].nil?
  end

  def term_nil?
    session[:term].nil?
  end

  private

  def set_person_and_terms
    @api_service = ApiService.new
    @person, @terms = @api_service.fetch_and_map_waitlistperson(current_user.email.split("@")[0])
    if session[:term].nil?
      session[:term] = @terms[0]
    end
     puts "PERSON: #{current_user.person_id}"
  end
end
