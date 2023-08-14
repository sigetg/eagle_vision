class RegistrationRequestItemsController < ApplicationController
  before_action :set_registration_request_item, only: %i[ show edit update destroy ]

  # GET /registration_request_items or /registration_request_items.json
  def index
    @registration_request_items = RegistrationRequestItem.all
  end

  # GET /registration_request_items/1 or /registration_request_items/1.json
  def show
  end

  # GET /registration_request_items/new
  def new
    @registration_request_item = RegistrationRequestItem.new
  end

  # GET /registration_request_items/1/edit
  def edit
  end

  # POST /registration_request_items or /registration_request_items.json
  def create
    @registration_request_item = RegistrationRequestItem.new(registration_request_item_params)

    respond_to do |format|
      if @registration_request_item.save
        format.html { redirect_to registration_request_item_url(@registration_request_item), notice: "Registration request item was successfully created." }
        format.json { render :show, status: :created, location: @registration_request_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_request_items/1 or /registration_request_items/1.json
  def update
    respond_to do |format|
      if @registration_request_item.update(registration_request_item_params)
        format.html { redirect_to registration_request_item_url(@registration_request_item), notice: "Registration request item was successfully updated." }
        format.json { render :show, status: :ok, location: @registration_request_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @registration_request_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_request_items/1 or /registration_request_items/1.json
  def destroy
    @registration_request_item.destroy

    respond_to do |format|
      format.html { redirect_to registration_request_items_url, notice: "Registration request item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_request_item
      @registration_request_item = RegistrationRequestItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def registration_request_item_params
      params.require(:registration_request_item).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :registration_request_id, :person_id, :requestedEffectiveDate, :existingRegistrationId, :existingActivityOfferingId, :preferredActivityOfferingIds, :preferredFormatOfferingIds, :preferredRegistrationGroupIds, :preferredCredits, :preferredGradingOptionIds, :processResults, :resultingRegistrationId, :courseWaitlistEntryId, :processingPriority, :lastAttendanceDate, :notificationDate, :meta)
    end
end
