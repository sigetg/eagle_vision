class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_person_and_terms, if: :user_signed_in?

  def set_term
    if params[:term_index]
      session[:term] = @terms[params[:term_index].to_i]
    end
    puts "TERMINACION: #{session[:term].inspect}"
  end

  private

  def set_person_and_terms
    @api_service = ApiService.new
    current_user.person_id = "38849231"
    @person, @terms = @api_service.fetch_and_map_waitlistperson(current_user.person_id)
    if session[:term].nil?
      session[:term] = @terms[0]
    end
  end
end
