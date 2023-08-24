class RegistrationGroupsController < ApplicationController
  before_action :set_registration_group, only: %i[ show edit update destroy ]

  # GET /registration_groups or /registration_groups.json
  def index
    course_offering_id = params[:course_offering_id]
    # registration_groups_data contains hashes that have a registration_group key and an activity_offerings key
    unsorted_registration_groups_data = @api_service.fetch_and_map_waitlistregistrationgroups(course_offering_id)
    @registration_groups_data = unsorted_registration_groups_data.sort_by { |registration_group_data| registration_group_data[:registration_group].name }
  end

  # GET /registration_groups/1 or /registration_groups/1.json
  def show
  end

  # GET /registration_groups/new
  def new
    @registration_group = RegistrationGroup.new
  end

  # GET /registration_groups/1/edit
  def edit
  end

  # POST /registration_groups or /registration_groups.json
  def create
    @registration_group = RegistrationGroup.new(registration_group_params)

    respond_to do |format|
      if @registration_group.save
        format.html { redirect_to registration_group_url(@registration_group), notice: "Registration group was successfully created." }
        format.json { render :show, status: :created, location: @registration_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_groups/1 or /registration_groups/1.json
  def update
    respond_to do |format|
      if @registration_group.update(registration_group_params)
        format.html { redirect_to registration_group_url(@registration_group), notice: "Registration group was successfully updated." }
        format.json { render :show, status: :ok, location: @registration_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @registration_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_groups/1 or /registration_groups/1.json
  def destroy
    @registration_group.destroy

    respond_to do |format|
      format.html { redirect_to registration_groups_url, notice: "Registration group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_group
      @registration_group = RegistrationGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def registration_group_params
      params.require(:registration_group).permit(:attributes, :meta, :typeKey, :stateKey, :name, :descr, :id, :formatOfferingId, :courseOfferingId, :termId, :registrationCode, :courseCode, :activityOfferingIds, :multiOfferingId, :bundledOfferingId, :isGenerated, :gradingOptionId, :studentRegistrationGradingOptionIds, :creditOptionId, :requisiteIds, :coRequisiteIds, :restrictionIds, :type, :state)
    end
end
