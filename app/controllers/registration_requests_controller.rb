class RegistrationRequestsController < ApplicationController
  before_action :set_registration_request, only: %i[ show edit update destroy ]
  before_action :set_registration_request_items, only: %i[ show edit update destroy ]

  # GET /registration_requests or /registration_requests.json
  def index
    @registration_requests = []
  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
  end

  # GET /registration_requests/new
  def new
    registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    @registration_request = registration_request_data[:registration_request]
    @registration_request_item = registration_request_data[:registration_request_item]
    @registration_group = params[:registration_group]
  end

  # GET /registration_requests/1/edit
  def edit
    @activity_offering = ActivityOffering.find(@registration_request_items[0].activity_offering_id)
    @term_id = @registration_request.term_id
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request = RegistrationRequest.new(registration_request_params)
    @registration_request_item = RegistrationRequestItem.new(registration_request_item_params)


    respond_to do |format|
      if @registration_request.save
        @registration_request_item.registration_request_id = @registration_request.id
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
      if @registration_request_item.save
        format.html { redirect_to registration_request_url(@registration_request), notice: "Registration request was successfully created." }
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
        format.html { redirect_to registration_request_url(@registration_request), notice: "Registration request was successfully updated." }
        format.json { render :show, status: :ok, location: @registration_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_requests/1 or /registration_requests/1.json
  def destroy
    @registration_request.destroy

    respond_to do |format|
      format.html { redirect_to registration_requests_url, notice: "Registration request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_request
      @registration_request = RegistrationRequest.find(params[:id])
    end

    def set_registration_request_items
      @registration_request_items = RegistrationRequestItem.find(:all, :from => "/registration_requests/#{params[:id]}/registration_request_items" )
    end

    # Only allow a list of trusted parameters through.
    def registration_request_params
      params.require(:registration_request).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :person_id, :term_id, :submittedDate, :processResults, :itemStudentIds, :itemStudentPopulationId, :meta, :registration_request_item)
    end

    # Only allow a list of trusted parameters through.
    def registration_request_item_params
      params.require(:registration_request).require(:registration_request_item).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :registration_request_id, :person_id, :requestedEffectiveDate, :existingRegistrationId, :existingActivityOfferingId, :preferredActivityOfferingIds, :preferredFormatOfferingIds, :preferredRegistrationGroupIds, :preferredCredits, :preferredGradingOptionIds, :processResults, :resultingRegistrationId, :courseWaitlistEntryId, :processingPriority, :lastAttendanceDate, :notificationDate, :meta, :activity_offering_id)
    end
end
