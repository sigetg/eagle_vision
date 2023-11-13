class RegistrationRequestsController < ApplicationController
  before_action :set_api_service
  before_action :set_person_and_terms, only: %i[ new ]

  # GET /registration_requests or /registration_requests.json
  def index
    # @registration_requests = @api_service.get_waitlist_request_by_student(current_user.email.split("@")[0])
    @registration_requests = @api_service.get_waitlist_request_by_student("90000001")      # TODO: Figure out how to fetch the current user's ID!!!!
    # @registration_requests = @api_service.get_waitlist_request("60f3bb1c-e6d5-4dc3-8636-5a5be4213dd5")

  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
  end

  # GET /registration_requests/new
  def new #@person is set in app cntroller atm. change that
    #This creates a reauest on every reload. Must change so it only creates on submit.
    @registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    @RegistrationRequest = @registration_request_data[:registrationRequest]
    @RegistrationRequestItem = @registration_request_data[:registrationRequestItem]
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request = @api_service.get_waitlist_request(params[:id])
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
