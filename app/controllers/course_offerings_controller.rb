class CourseOfferingsController < ApplicationController
  before_action :set_person_and_terms

  include Pagination
  POSTS_PER_PAGE = 6


  # GET /course_offerings or /course_offerings.json
  def index
    term_id = session.dig(:term, "id")
    @term_name = session.dig(:term, "name") #delete user version of this stuff
    code = ""
    @course_offerings = @api_service.fetch_and_map_waitlistcourseofferings(term_id, code)
    @pagination, @course_offerings = paginate(collection: @course_offerings, params: params)
  end

  def search
    term_id = session.dig(:term, "id")
    @term_name = session.dig(:term, "name")
    @code = "#{params[:key]}"
    @course_offerings = @api_service.fetch_and_map_waitlistcourseofferings(term_id, @code)
    @pagination, @course_offerings = paginate(collection: @course_offerings, params: params)
  end

  private

end
