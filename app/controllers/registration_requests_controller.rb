class RegistrationRequestsController < ApplicationController
  before_action :set_api_service
  before_action :set_person_and_terms, only: %i[ create index]

  # GET /registration_requests or /registration_requests.json
  def index
    @activity_offerings = {} # dictionary associating registration request ids to lists of associated activity offerings
    @creator_names = {}
    if current_user.has_role?("admin") #if admin, query all requests associated with their department
      set_person_and_terms
      affiliations, departments = @api_service.fetch_and_map_waitlistperson_affiliations_and_authorized_departments(current_user.person_id.to_s)
      @registration_requests = []
      @avalible_seats = []

      # If the requests are being filtered by a stateKey, make human readable stateKey interpretable by API
      case params[:stateKey]
      when 'Submitted'
        stateKey = 'kuali.courseregistration.request.state.submitted'
      when 'Accepted'
        stateKey = 'kuali.courseregistration.request.state.processed.success'
      when 'Rejected'
        stateKey = 'kuali.courseregistration.request.state.discarded'
      end

      departments.each do |department|
        if params[:stateKey]
          dept_reg_requests = @api_service.get_waitlist_requests_by_term_deptId_and_stateKey(session[:term]["id"], department.id, stateKey) #need to change term to
        else
          dept_reg_requests = @api_service.get_waitlist_requests_by_term_and_deptId(session[:term]["id"], department.id)
        end
        @registration_requests += dept_reg_requests

        # for each request found under the administrated department, add dictionary entries mapping reg_request_id to an array of associated activity offerings

        get_associated_activity_offerings(dept_reg_requests, @activity_offerings)

        get_associated_requestor_names(dept_reg_requests, @creator_names)

      end

    else #otherwise just get the student's requests
      @registration_requests = @api_service.get_waitlist_requests_by_student(current_user.person_id.to_s)
      get_associated_activity_offerings(@registration_requests, @activity_offerings)
      get_associated_requestor_names(@registration_requests, @creator_names)
    end

    #This sorts the requests so they show up with the oldest on top, newest on the bottom
    @registration_requests = @registration_requests.sort_by { |request| DateTime.parse(request[:registrationRequest].effectiveDate) }

  end

  def course_offering_requests
    course_offering_id = params[:course_offering_id]
    @registration_requests = @api_service.get_waitlist_requests_by_course_offering(course_offering_id)
    @activity_offerings = {}
    @creator_names = {}
    get_associated_activity_offerings(@registration_requests, @activity_offerings)
    get_associated_requestor_names(@registration_requests, @creator_names)

    #This sorts the requests so they show up with the oldest on top, newest on the bottom
    @registration_requests = @registration_requests.sort_by { |request| DateTime.parse(request[:registrationRequest].effectiveDate) }

    render :index

  end

  # GET /registration_requests/1 or /registration_requests/1.json
  def show
    @registration_request = @api_service.get_waitlist_request(params[:id])
    @creator = params[:creator]
    @activity_offerings = []
    if @registration_request[:registrationRequestItem].preferredActivityOfferingIds[0]
      preferred_activity_offering_ids = @registration_request[:registrationRequestItem].preferredActivityOfferingIds[0].split
      preferred_activity_offering_ids.each do |activity_offering_id|
        @activity_offerings.push(@api_service.fetch_and_map_waitlistactivityofferings(activity_offering_id))
      end
    end
  end

  # GET /registration_requests/new
  def new
    @registration_group_id = params[:registration_group_id]
    @activity_offering_ids = params[:activity_offering_ids]
  end

  # POST /registration_requests or /registration_requests.json
  def create
    @registration_request_data = @api_service.create_waitlist_request(@person.id, params[:registration_group_id])
    # @registration_request_data[:registrationRequest].attributes[0]["creator"] = @person.name NORM CAN I DO THIS PLZ
    # @api_service.update_waitlist_request(registration_request_data[:registrationRequest].id, registration_request_data)
    # redirect_to registration_requests_path, notice: "Registration request was successfully created."
    @registration_request_data[:registrationRequest].descr["plain"] = params[ 'year'] +'\n' + params[ 'major'] + '\n' + params['descr']
    @registration_request_data[:registrationRequest].descr["formatted"] = "Pending"
    @registration_request_data[:registrationRequestItem].preferredActivityOfferingIds = params['activity_offering_ids']
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request_data[:registrationRequest].id, @registration_request_data)
        @api_service.change_waitlist_request_state(@registration_request_data[:registrationRequest].id, "kuali.courseregistration.request.state.submitted")
        format.html { redirect_to registration_requests_url, notice: "Registration request was successfully created." }
        format.json { render :show, status: :created, location: @registration_request_data }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @registration_request_data.errors, status: :unprocessable_entity }
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
    case params[:stateKey]
    when 'Submitted'
      stateKey = 'kuali.courseregistration.request.state.submitted'
    when 'Accepted'
      stateKey = 'kuali.courseregistration.request.state.processed.success'
    when 'Rejected'
      stateKey = 'kuali.courseregistration.request.state.discarded'
    end

    if params['descr']
      @registration_request[:registrationRequest].descr["plain"] = params['descr']
    end
    if params['response']
      @registration_request[:registrationRequest].descr["formatted"] = params['response']
    end
  
    respond_to do |format|
      if @api_service.update_waitlist_request(@registration_request[:registrationRequest].id, @registration_request)
        if stateKey
          @api_service.change_waitlist_request_state(@registration_request[:registrationRequest].id, stateKey)
        end
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

  def get_associated_activity_offerings(registration_requests, activity_offerings)
    registration_requests.each do |reg_request|
      request_offerings = []
      if reg_request[:registrationRequestItem].preferredActivityOfferingIds[0]
        preferred_activity_offering_ids = reg_request[:registrationRequestItem].preferredActivityOfferingIds[0].split
        preferred_activity_offering_ids.each do |activity_offering_id|
          request_offerings.push(@api_service.fetch_and_map_waitlistactivityofferings(activity_offering_id))
        end
      end
      activity_offerings[reg_request[:registrationRequest].id] = request_offerings
    end
    activity_offerings
  end


  def get_associated_requestor_names(registration_requests, creator_names)
    registration_requests.each do |reg_request|
      person, terms = @api_service.fetch_and_map_waitlistperson_and_term(reg_request[:registrationRequest].requestorId)
      creator_names[reg_request[:registrationRequest].id] = person.name
    end
    creator_names
  end
    # Only allow a list of trusted parameters through.
    # def registration_request_params
    #   params.require(:registration_request).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :requestorId, :termId, :submittedDate, :processResults, :itemStudentIds, :itemStudentPopulationId, :meta)
    # end

    # Only allow a list of trusted parameters through.
    def registration_request_item_params
      params.require(:registration_request).require(:registration_request_item).permit(:typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :registrationRequestId, :studentId, :requestedEffectiveDate, :existingRegistrationId, :existingActivityOfferingId, :preferredActivityOfferingIds, :preferredFormatOfferingIds, :preferredRegistrationGroupIds, :preferredCredits, :preferredGradingOptionIds, :processResults, :resultingRegistrationId, :courseWaitlistEntryId, :processingPriority, :lastAttendanceDate, :notificationDate, :meta)
    end
end
