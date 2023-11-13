class RegistrationGroupsController < ApplicationController
  before_action :set_api_service
  # GET /registration_groups or /registration_groups.json
  def index
    course_offering_id = params[:course_offering_id]
    # registration_groups_data contains hashes that have a registration_group key and an activity_offerings key
    unsorted_registration_groups_data = @api_service.fetch_and_map_waitlistregistrationgroups(course_offering_id)
    @registration_groups_data = unsorted_registration_groups_data.sort_by { |registration_group_data| registration_group_data[:registration_group].name }
  end

end
