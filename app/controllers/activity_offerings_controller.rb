class ActivityOfferingsController < ApplicationController
  before_action :set_activity_offering, only: %i[ show edit update destroy ]
  before_action :set_api_service, only: %i[ index ]

  # GET /activity_offerings or /activity_offerings.json
  def index
    course_offering_id = params[:course_offering_id]
    puts "COURSE OFFERING ID: #{course_offering_id}"
    @activity_offerings = @api_service.fetch_and_map_waitlistactivityofferings(course_offering_id)
  end

  # GET /activity_offerings/1 or /activity_offerings/1.json
  def show
    @registration_request_items = RegistrationRequestItem.find(:all, :params => { :activity_offering_id => @activity_offering.id })
    puts @registration_request_items
    @registration_request_items.each do |item|
      item.registration_request = RegistrationRequest.find(:one, :from => "/registration_requests/#{item.registration_request_id}")
      # @registration_requests.push(registration_request)
    end
  end

  # GET /activity_offerings/new
  def new
    @activity_offering = ActivityOffering.new
  end

  # GET /activity_offerings/1/edit
  def edit
  end

  # POST /activity_offerings or /activity_offerings.json
  def create
    @activity_offering = ActivityOffering.new(activity_offering_params)

    respond_to do |format|
      if @activity_offering.save
        format.html { redirect_to activity_offering_url(@activity_offering), notice: "Activity offering was successfully created." }
        format.json { render :show, status: :created, location: @activity_offering }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity_offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_offerings/1 or /activity_offerings/1.json
  def update
    respond_to do |format|
      if @activity_offering.update(activity_offering_params)
        format.html { redirect_to activity_offering_url(@activity_offering), notice: "Activity offering was successfully updated." }
        format.json { render :show, status: :ok, location: @activity_offering }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity_offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_offerings/1 or /activity_offerings/1.json
  def destroy
    @activity_offering.destroy

    respond_to do |format|
      format.html { redirect_to activity_offerings_url, notice: "Activity offering was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_offering
      @activity_offering = ActivityOffering.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_offering_params
      params.require(:activity_offering).permit(:typeKey, :stateKey, :name, :descr, :effectiveDate, :expirationDate, :formatOfferingId, :formatOfferingName, :activityId, :term_id, :termCode, :activityCode, :scheduleIds, :isHonorsOffering, :instructors, :weeklyInclassContactHours, :weeklyOutofClassHours, :weeklyTotalContactHours, :maximumEnrollment, :minimumEnrollment, :isEvaluated, :activityOfferingUrl, :course_offering_id, :courseOfferingTitle, :courseOfferingCode, :unitsDeploymentOrgIds, :requisiteIds, :coRequisiteIds, :restrictionIds, :meta)
    end

    def set_api_service
      @api_service = ApiService.new
    end
end
