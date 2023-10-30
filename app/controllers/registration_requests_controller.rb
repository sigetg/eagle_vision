class RegistrationRequestsController < ApplicationController

  # GET /registration_requests or /registration_requests.json
  def index
    # TODO: Figure out how to fetch the current user's ID!!!!
    # @registration_requests = @api_service.get_waitlist_request_by_student(current_user.email.split("@")[0])
    @registration_requests = @api_service.get_waitlist_request_by_student("90000001")
    # @registration_requests = @api_service.get_waitlist_request("60f3bb1c-e6d5-4dc3-8636-5a5be4213dd5")

  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
  end

  # GET /registration_requests/new
  def new
    @registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    puts "PERSOMN: " + @person.inspect
    @RegistrationRequest = @registration_request_data[:registrationRequest]
    @RegistrationRequestItem = @registration_request_data[:registrationRequestItem]
  end

  # GET /registration_requests/1/edit
  def edit
    @activity_offering = ActivityOffering.find(@registration_request_items[0].activity_offering_id)
    @term_id = @registration_request.term_id
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request = @api_service.create_waitlist_request(@person.id, params[:@RegistrationRequestItem]["preferredRegistrationGroupIds"])
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request[:registrationRequest].descr = params['descr']

    puts "REGREQUSES: " + @registration_request.inspect
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request[:registrationRequest].id, @registration_request)
        format.html { redirect_to registration_requests_url, notice: "Registration request was successfully created." }
        format.json { render :show, status: :created, location: @registration_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_requests/1 or /registration_requests/1.json
  def update
    respond_to do |format|
      if @registration_request.update_attributes(registration_request_params) && @registration_request_items[0].update_attributes(registration_request_item_params)
        RegistrationRequestMailer.registration_request_changed(current_user, @registration_request).deliver_later
        format.html { redirect_to registration_requests_url, notice: "Registration request was successfully updated." }
        format.json { render :show, status: :ok, location: @registration_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_requests/1 or /registration_requests/1.json
  def destroy
    @registration_request = @api_service.get_waitlist_request(params[:id])
    @api_service.delete_waitlist_request(@registration_request[:registrationRequest].id)
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
