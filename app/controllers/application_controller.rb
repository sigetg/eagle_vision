class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_person_and_terms, if: :user_signed_in?


  private

  def set_person_and_terms
    @api_service = ApiService.new
    current_user.person_id = "38849231"
    @person, @terms = @api_service.fetch_and_map_waitlistperson(current_user.person_id)
  end
end
