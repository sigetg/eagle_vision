class CourseOfferingsController < ApplicationController
  before_action :set_course_offering, only: %i[ show edit update destroy ]
  # GET /course_offerings or /course_offerings.json
  def index
    @course_offerings = CourseOffering.all
  end

  # GET /course_offerings/1 or /course_offerings/1.json
  def show
    @activity_offerings = ActivityOffering.find(:all, :from => "/course_offerings/#{@course_offering.id}/activity_offerings" )
    puts @activity_offerings
    puts "Course: #{@course_offering.id}"
  end

  # GET /course_offerings/new
  def new
    @course_offering = CourseOffering.new
  end

  # GET /course_offerings/1/edit
  def edit
  end

  # POST /course_offerings or /course_offerings.json
  def create
    @course_offering = CourseOffering.new(course_offering_params)

    respond_to do |format|
      if @course_offering.save
        format.html { redirect_to course_offering_url(@course_offering), notice: "Course offering was successfully created." }
        format.json { render :show, status: :created, location: @course_offering }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_offerings/1 or /course_offerings/1.json
  def update
    respond_to do |format|
      if @course_offering.update(course_offering_params)
        format.html { redirect_to course_offering_url(@course_offering), notice: "Course offering was successfully updated." }
        format.json { render :show, status: :ok, location: @course_offering }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_offerings/1 or /course_offerings/1.json
  def destroy
    @course_offering.destroy

    respond_to do |format|
      format.html { redirect_to course_offerings_url, notice: "Course offering was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_offering
      @course_offering = CourseOffering.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_offering_params
      params.require(:course_offering).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :courseId, :term_id, :courseCode, :courseOfferingCode, :subjectAreaId, :courseNumberSuffix, :courseOfferingTitle, :isHonorsOffering, :maximumEnrollment, :minimumEnrollment, :gradingOptionId, :studentRegistrationGradingOptionIds, :creditOptionId, :instructors, :unitsDeploymentOrgIds, :requisiteIds, :coRequisiteIds, :restrictionIds, :campusLocations, :isEvaluated, :courseOfferingUrl, :gradeRosterDefinitionId, :gradingOptionIds, :creditOptionIds, :meta)
    end
end
