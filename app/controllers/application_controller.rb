class ApplicationController < ActionController::Base
  before_action :authenticate_user!


  def set_api_service
    @api_service = ApiService.new
  end

  def set_person_and_terms
    set_api_service
    @person, @terms = @api_service.fetch_and_map_waitlistperson_and_term(current_user.email.split("@")[0])
    if session[:term].nil?
      session[:term] = @terms[0]
    end
    puts "PERSON: #{current_user.person_id}"
  end
end
