class CourseOfferingsController < ApplicationController
  before_action :set_person_and_terms
  # GET /course_offerings or /course_offerings.json
  def index
    puts params.inspect
    if params[:term_id]
      term_id = params[:term_id]
      @term_name = params[:term_name]
    else
      term_id = session.dig(:term, "id")
      @term_name = session.dig(:term, "name") #delete user version of this stuff
    end
    code = ""
    @course_offerings = @api_service.fetch_and_map_waitlistcourseofferings(term_id, code)
  end

  def search
    puts params.inspect
    if params[:term_id]
      term_id = params[:term_id]
      @term_name = params[:term_name]
    else
      term_id = session.dig(:term, "id")
      @term_name = session.dig(:term, "name")
    end
    code = "#{params[:key]}"
    @course_offerings = @api_service.fetch_and_map_waitlistcourseofferings(term_id, code)
  end

  private

  def set_term
    session
  end
end
