class RegistrationRequestsController < ApplicationController
  before_action :set_api_service
  before_action :set_person_and_terms, only: %i[ create ]

  # GET /registration_requests or /registration_requests.json
  def index
    if current_user.has_role?("admin") #if admin, query all requests associated with their department
      set_person_and_terms
      affiliations, departments = @api_service.fetch_and_map_waitlistperson_affiliations_and_authorized_departments(current_user.person_id.to_s)
      @registration_requests = []
      @avalible_seats = []
      @activity_offerings = {}
      departments.each do |department|
        if params[:stateKey]
          dept_reg_requests = @api_service.get_waitlist_requests_by_term_deptId_and_stateKey("kuali.atp.FA2023-2024", department.id, params[:stateKey]) #need to change term to 
        else
          dept_reg_requests = @api_service.get_waitlist_requests_by_term_and_deptId("kuali.atp.FA2023-2024", department.id)
        end
        @registration_requests += dept_reg_requests
        dept_reg_requests.each do |reg_request|
          request_offerings = []
          if reg_request[:registrationRequestItem].preferredActivityOfferingIds[0]
            preferred_activity_offering_ids = reg_request[:registrationRequestItem].preferredActivityOfferingIds[0].split
            preferred_activity_offering_ids.each do |activity_offering_id|
              request_offerings.push(@api_service.fetch_and_map_waitlistactivityofferings(activity_offering_id))
            end
          end
          @activity_offerings[reg_request[:registrationRequest].id] = request_offerings
        end
      end

    else #otherwise just get the student's requests
      @registration_requests = @api_service.get_waitlist_requests_by_student(current_user.person_id.to_s)
      @activity_offerings = {}
      @registration_requests.each do |reg_request|
        request_offerings = []
        if reg_request[:registrationRequestItem].preferredActivityOfferingIds[0]
          preferred_activity_offering_ids = reg_request[:registrationRequestItem].preferredActivityOfferingIds[0].split
          preferred_activity_offering_ids.each do |activity_offering_id|
            request_offerings.push(@api_service.fetch_and_map_waitlistactivityofferings(activity_offering_id))
          end
        end
        @activity_offerings[reg_request[:registrationRequest].id] = request_offerings
      end
    end

  end

  def course_offering_requests
    course_offering_id = params[:course_offering_id]
    @registration_requests = @api_service.get_waitlist_requests_by_course_offering(course_offering_id)
    @activity_offerings = {}
    @registration_requests.each do |reg_request|
      request_offerings = []
      if reg_request[:registrationRequestItem].preferredActivityOfferingIds[0]
        preferred_activity_offering_ids = reg_request[:registrationRequestItem].preferredActivityOfferingIds[0].split
        preferred_activity_offering_ids.each do |activity_offering_id|
          request_offerings.push(@api_service.fetch_and_map_waitlistactivityofferings(activity_offering_id))
        end
      end
      @activity_offerings[reg_request[:registrationRequest].id] = request_offerings
    end

    render :index

  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
  end

  # GET /registration_requests/new
  def new
    @registration_group_id = params[:registration_group_id]
    @activity_offering_ids = params[:activity_offering_ids]
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    @RegistrationRequest = @registration_request_data[:registrationRequest]
    @registration_request = @api_service.get_waitlist_request(@RegistrationRequest.id)
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request[:registrationRequest].descr = params['descr']
    @registration_request[:registrationRequestItem].preferredActivityOfferingIds = params['activity_offering_ids']
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request[:registrationRequest].id, @registration_request)
        @api_service.change_waitlist_request_state(@registration_request[:registrationRequest].id, "kuali.courseregistration.request.state.submitted")
        format.html { redirect_to registration_requests_url, notice: "Registration request was successfully created." }
        format.json { render :show, status: :created, location: @registration_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /registration_requests/1/edit
  def edit
    @registration_request_data = @api_service.get_waitlist_request(params[:id])
    @registration_request = @registration_request_data[:registrationRequest]
  end

  # PATCH/PUT /registration_requests/1 or /registration_requests/1.json
  def update
    @registration_request = @api_service.get_waitlist_request(params[:id])
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request[:registrationRequest].descr = params['descr']
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request[:registrationRequest].id, @registration_request)
        @api_service.change_waitlist_request_state(@registration_request[:registrationRequest].id, params["stateKey"])
        format.html { redirect_to registration_requests_url, notice: "Registration request was successfully edited." }
        format.json { render :show, status: :created, location: @registration_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_requests/1 or /registration_requests/1.json
  def destroy
    # @registration_request = @api_service.get_waitlist_request(params[:id])
    @api_service.delete_waitlist_request(params[:id])
    flash[:notice] = "Registration request was successfully destroyed."
    redirect_to registration_requests_url
  end

  private

    # Only allow a list of trusted parameters through.
    # def registration_request_params
    #   params.require(:registration_request).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :requestorId, :termId, :submittedDate, :processResults, :itemStudentIds, :itemStudentPopulationId, :meta)
    # end

    # Only allow a list of trusted parameters through.
    def registration_request_item_params
      params.require(:registration_request).require(:registration_request_item).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :registrationRequestId, :studentId, :requestedEffectiveDate, :existingRegistrationId, :existingActivityOfferingId, :preferredActivityOfferingIds, :preferredFormatOfferingIds, :preferredRegistrationGroupIds, :preferredCredits, :preferredGradingOptionIds, :processResults, :resultingRegistrationId, :courseWaitlistEntryId, :processingPriority, :lastAttendanceDate, :notificationDate, :meta)
    end
end
