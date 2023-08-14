class RegistrationRequestsController < ApplicationController
  before_action :set_registration_request, only: %i[ show edit update destroy ]

  # GET /registration_requests or /registration_requests.json
  def index
    @registration_requests = RegistrationRequest.all
  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
  end

  # GET /registration_requests/new
  def new
    @registration_request = RegistrationRequest.new
  end

  # GET /registration_requests/1/edit
  def edit
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request = RegistrationRequest.new(registration_request_params)

    respond_to do |format|
      if @registration_request.save
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
      if @registration_request.update(registration_request_params)
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

    # Only allow a list of trusted parameters through.
    def registration_request_params
      params.require(:registration_request).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :person_id, :term_id, :submittedDate, :processResults, :itemStudentIds, :itemStudentPopulationId, :meta)
    end
end
