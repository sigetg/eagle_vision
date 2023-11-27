class RegistrationRequestsController < ApplicationController
  before_action :set_api_service
  before_action :set_person_and_terms, only: %i[ create ]

  # GET /registration_requests or /registration_requests.json
  def index
    if current_user.has_role?("admin")
      set_person_and_terms
      affiliations, departments = @api_service.fetch_and_map_waitlistperson_affiliations_and_authorized_departments(current_user.person_id.to_s)
      @registration_requests = []
      departments.each do |department|
        @registration_requests += @api_service.get_waitlist_requests_by_term_and_deptId(session[:term]["id"], department.id)
        puts "REGREQS: " + @registration_requests.inspect
      end
      puts "REGREQS: " + @registration_requests.inspect
    else
      @registration_requests = @api_service.get_waitlist_requests_by_student(current_user.person_id.to_s)
    end
  end

  def course_offering_requests
    course_offering_id = params[:course_offering_id]
    @registration_requests = @api_service.get_waitlist_requests_by_course_offering(course_offering_id)
    render :index
  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
  end

  # GET /registration_requests/new
  def new #@person is set in app cntroller atm. change that
    @registration_group_id = params[:registration_group_id]
    #This creates a reauest on every reload. Must change so it only creates on submit.
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    @RegistrationRequest = @registration_request_data[:registrationRequest]
    @registration_request = @api_service.get_waitlist_request(@RegistrationRequest.id)
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request[:registrationRequest].descr = params['descr']
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
    puts params.inspect
    @registration_request_data = @api_service.get_waitlist_request(params[:id])
    @RegistrationRequest = @registration_request_data[:registrationRequest]
    @RegistrationRequestItem = @registration_request_data[:registrationRequestItem]
  end

  # PATCH/PUT /registration_requests/1 or /registration_requests/1.json
  def update
    @registration_request = @api_service.get_waitlist_request(params[:id])
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request[:registrationRequest].descr = params['descr']
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request[:registrationRequest].id, @registration_request)
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
