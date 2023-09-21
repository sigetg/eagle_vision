class ApiService
  include HTTParty
  include HashToStruct
  class DoesNotExistException < StandardError
    def initialize(resource_id)
      @resource_id = resource_id
      super("The resource with ID #{@resource_id} does not exist.")
    end
  end

  base_uri 'http://127.0.0.1:8080/waitlist'

  def fetch_and_map_waitlistperson(person_id)
    response = self.class.get("/waitlistpersons/#{person_id}")
    if response.code == 200
      api_data = JSON.parse(response.body)
      self.class.map_to_person(api_data)
    else
      raise DoesNotExistException.new(person_id)
    end
  end

  def self.map_to_person(api_item)
    person = api_item['person']
    active_terms = api_item['activeTerms']
    return_terms = []
    return_person = Person.new(
      attributes: person['attributes'],
      meta: person['meta'],
      typeKey: person['typeKey'],
      stateKey: person['stateKey'],
      name: person['name'],
      descr: person['descr'],
      id: person['id'],
      pictureDocumentId: person['pictureDocumentId'],
      type: person['type'],
      state: person['state']
    )
    active_terms.each do |term|
      term = Term.new(
        attributes: term['attributes'],
        meta: term['meta'],
        typeKey: term['typeKey'],
        stateKey: term['stateKey'],
        name: term['name'],
        descr: term['descr'],
        id: term['id'],
        code: term['code'],
        startDate: term['startDate'],
        endDate: term['endDate'],
        adminOrgId: term['adminOrgId'],
        type: term['type'],
        state: term['state']
      )
      return_terms.append(term)
    end
    [ return_person, active_terms ]
  end

  def fetch_and_map_waitlistcourseofferings(term, code)
    response = self.class.get("/waitlistcourseofferings?termId=#{term}&code=#{code}")
    api_data = JSON.parse(response.body)

    api_data.map { |api_item| self.class.map_to_course_offering(api_item) }
  end

  def self.map_to_course_offering(api_item)
    course_offering = api_item['courseOffering']
    CourseOffering.new(
      attributes: course_offering['attributes'],
      meta: course_offering['meta'],
      id: course_offering['id'],
      typeKey: course_offering['typeKey'],
      stateKey: course_offering['stateKey'],
      effectiveDate: course_offering['effectiveDate'],
      expirationDate: course_offering['expirationDate'],
      name: course_offering['name'],
      descr:  course_offering['descr'],
      courseId: course_offering['courseId'],
      termId: course_offering['termId'],
      courseOfferingTitle: course_offering['courseOfferingTitle'],
      courseCode: course_offering['courseCode'],
      courseOfferingCode: course_offering['courseOfferingCode'],
      courseNumberSuffix: course_offering['courseNumberSuffix'],
      subjectAreaId: course_offering['subjectAreaId'],
      isHonorsOffering: course_offering['isHonorsOffering'],
      campusLocations: course_offering['campusLocations'],
      instructors: course_offering['instructors'],
      unitsDeploymentOrgIds: course_offering['unitsDeploymentOrgIds'],
      requisiteIds: course_offering['requisiteIds'],
      gradingOptionId: course_offering['gradingOptionId'],
      gradingOptionIds: course_offering['gradingOptionIds'],
      studentRegistrationGradingOptionIds: course_offering['studentRegistrationGradingOptionIds'],
      creditOptionId: course_offering['creditOptionId'],
      coRequisiteIds: course_offering['coRequisiteIds'],
      restrictionIds: course_offering['restrictionIds'],
      maximumEnrollment: course_offering['maximumEnrollment'],
      minimumEnrollment: course_offering['minimumEnrollment'],
      isEvaluated: course_offering['isEvaluated'],
      courseOfferingUrl: course_offering['courseOfferingUrl'],
      gradeRosterDefinitionId: course_offering['gradeRosterDefinitionId'],
      creditOptionIds: course_offering['creditOptionIds'],
      type: course_offering['type'],
      state: course_offering['state']
    )
  end

  def fetch_and_map_waitlistactivityofferings(course_offering_id)
    response = self.class.get("/waitlistactivityofferings?courseOfferingId=#{course_offering_id}")
    api_data = JSON.parse(response.body)

    api_data.map { |api_item| self.class.map_to_activity_offering(api_item) }
  end

  def self.map_to_activity_offering(api_item)
    activity_offering = api_item['activityOffering']
    ActivityOffering.new(
      attributes: activity_offering['attributes'],
      meta: activity_offering['meta'],
      id: activity_offering['id'],
      typeKey: activity_offering['typeKey'],
      stateKey: activity_offering['stateKey'],
      effectiveDate: activity_offering['effectiveDate'],
      expirationDate: activity_offering['expirationDate'],
      name: activity_offering['name'],
      descr: activity_offering['descr'],
      formatOfferingId: activity_offering['formatOfferingId'],
      formatOfferingName: activity_offering['formatOfferingName'],
      activityId: activity_offering['activityId'],
      termId: activity_offering['termId'],
      termCode: activity_offering['termCode'],
      activityCode: activity_offering['activityCode'],
      scheduleIds: activity_offering['scheduleIds'],
      isHonorsOffering: activity_offering['isHonorsOffering'],
      instructors: activity_offering['instructors'],
      weeklyInclassContactHours: activity_offering['weeklyInclassContactHours'],
      weeklyTotalContactHours: activity_offering['weeklyTotalContactHours'],
      maximumEnrollment: activity_offering['maximumEnrollment'],
      minimumEnrollment: activity_offering['minimumEnrollment'],
      isEvaluated: activity_offering['isEvaluated'],
      activityOfferingUrl: activity_offering['activityOfferingUrl'],
      courseOfferingId: activity_offering['courseOfferingId'],
      courseOfferingTitle: activity_offering['courseOfferingTitle'],
      courseOfferingCode: activity_offering['courseOfferingCode'],
      weeklyOutofClassHours: activity_offering['weeklyOutofClassHours'],
      unitsDeploymentOrgIds: activity_offering['unitsDeploymentOrgIds'],
      requisiteIds: activity_offering['requisiteIds'],
      coRequisiteIds: activity_offering['coRequisiteIds'],
      restrictionIds: activity_offering['restrictionIds'],
      type: activity_offering['type'],
      state: activity_offering['state']
    )
  end

  def fetch_and_map_waitlistactivityofferings(course_offering_id)
    response = self.class.get("/waitlistactivityofferings?courseOfferingId=#{course_offering_id}")
    api_data = JSON.parse(response.body)

    #returns an array of activity offerings
    api_data.map { |api_item| self.class.map_to_activity_offering(api_item) }
  end

  def self.map_to_activity_offering(api_item)
    activity_offering = api_item['activityOffering']
    activity = ActivityOffering.new(
      attributes: activity_offering['attributes'],
      meta: activity_offering['meta'],
      id: activity_offering['id'],
      typeKey: activity_offering['typeKey'],
      stateKey: activity_offering['stateKey'],
      effectiveDate: activity_offering['effectiveDate'],
      expirationDate: activity_offering['expirationDate'],
      name: activity_offering['name'],
      descr: activity_offering['descr'],
      formatOfferingId: activity_offering['formatOfferingId'],
      formatOfferingName: activity_offering['formatOfferingName'],
      activityId: activity_offering['activityId'],
      termId: activity_offering['termId'],
      termCode: activity_offering['termCode'],
      activityCode: activity_offering['activityCode'],
      scheduleIds: activity_offering['scheduleIds'],
      isHonorsOffering: activity_offering['isHonorsOffering'],
      instructors: activity_offering['instructors'],
      weeklyInclassContactHours: activity_offering['weeklyInclassContactHours'],
      weeklyTotalContactHours: activity_offering['weeklyTotalContactHours'],
      maximumEnrollment: activity_offering['maximumEnrollment'],
      minimumEnrollment: activity_offering['minimumEnrollment'],
      isEvaluated: activity_offering['isEvaluated'],
      activityOfferingUrl: activity_offering['activityOfferingUrl'],
      courseOfferingId: activity_offering['courseOfferingId'],
      courseOfferingTitle: activity_offering['courseOfferingTitle'],
      courseOfferingCode: activity_offering['courseOfferingCode'],
      weeklyOutofClassHours: activity_offering['weeklyOutofClassHours'],
      unitsDeploymentOrgIds: activity_offering['unitsDeploymentOrgIds'],
      requisiteIds: activity_offering['requisiteIds'],
      coRequisiteIds: activity_offering['coRequisiteIds'],
      restrictionIds: activity_offering['restrictionIds'],
      type: activity_offering['type'],
      state: activity_offering['state']
    )
    if api_item['scheduleNames']
      schedule_names = api_item['scheduleNames']
      activity.scheduleNames = schedule_names[0]
    end
    activity
  end

  def fetch_and_map_waitlistregistrationgroups(course_offering_id)
    response = self.class.get("/waitlistregistrationgroups?courseOfferingId=#{course_offering_id}")
    api_data = JSON.parse(response.body)

    # returns an array of registration groups each with associated activity offerings
    api_data.map { |api_item| self.class.map_to_registration_group(api_item) }
  end

  def self.map_to_registration_group(api_item)
    registration_group = api_item['registrationGroup']
    activity_offerings = api_item['activityOfferings']
    group = RegistrationGroup.new(
      attributes: registration_group['attributes'],
      meta: registration_group['meta'],
      id: registration_group['id'],
      typeKey: registration_group['typeKey'],
      stateKey: registration_group['stateKey'],
      name: registration_group['name'],
      descr: registration_group['descr'],
      formatOfferingId: registration_group['formatOfferingId'],
      courseOfferingId: registration_group['courseOfferingId'],
      termId: registration_group['termId'],
      registrationCode: registration_group['registrationCode'],
      courseCode: registration_group['courseCode'],
      activityOfferingIds: registration_group['activityOfferingIds'],
      multiOfferingId: registration_group['multiOfferingId'],
      bundledOfferingId: registration_group['bundledOfferingId'],
      isGenerated: registration_group['isGenerated'],
      gradingOptionId: registration_group['gradingOptionId'],
      studentRegistrationGradingOptionIds: registration_group['studentRegistrationGradingOptionIds'],
      creditOptionId: registration_group['creditOptionId'],
      requisiteIds: registration_group['requisiteIds'],
      coRequisiteIds: registration_group['coRequisiteIds'],
      restrictionIds: registration_group['restrictionIds'],
      type: registration_group['type'],
      state: registration_group['state']
    )

    activities = activity_offerings.map { |activity_offering| self.map_to_activity_offering(activity_offering) }

    { registration_group: group, activity_offerings: activities }
  end


  def create_waitlist_request(studentId, registrationGroupId)
    response = self.class.post("/waitlistrequests?studentId=#{studentId}&registrationGroupId=#{registrationGroupId}")
    if response.code == 200
      api_data = JSON.parse(response.body)
      self.class.map_to_registration_request(api_data)
    end
  end

  def self.map_to_registration_request(api_item)
    registration_request = api_item['registrationRequest']
    registration_request_item = api_item['registrationRequestItem']
    request = RegistrationRequest.new(
      id: registration_request['id'],
      attributes: registration_request['attributes'],
      meta: registration_request['meta'],
      typeKey: registration_request['typeKey'],
      stateKey: registration_request['stateKey'],
      effectiveDate: registration_request['effectiveDate'],
      expirationDate: registration_request['expirationDate'],
      name: registration_request['name'],
      descr: registration_request['descr'],
      requestorId: registration_request['requestorId'],
      termId: registration_request['termId'],
      submittedDate: registration_request['submittedDate'],
      processResults: registration_request['processResults'],
      itemStudentIds: registration_request['itemStudentIds'],
      itemStudentPopulationId: registration_request['itemStudentPopulationId'],
      type: registration_request['type'],
      state: registration_request['state']
    )

    request_item = RegistrationRequestItem.new(
      id: registration_request_item['id'],
      typeKey: registration_request_item['typeKey'],
      stateKey: registration_request_item['stateKey'],
      effectiveDate: registration_request_item['effectiveDate'],
      expirationDate: registration_request_item['expirationDate'],
      name: registration_request_item['name'],
      descr: registration_request_item['descr'],
      registrationRequestId: registration_request_item['registrationRequestId'],
      studentId: registration_request_item['studentId'],
      requestedEffectiveDate: registration_request_item['requestedEffectiveDate'],
      existingRegistrationId: registration_request_item['existingRegistrationId'],
      existingActivityOfferingId: registration_request_item['existingActivityOfferingId'],
      preferredActivityOfferingIds: registration_request_item['preferredActivityOfferingIds'],
      preferredFormatOfferingIds: registration_request_item['preferredFormatOfferingIds'],
      preferredRegistrationGroupIds: registration_request_item['preferredRegistrationGroupIds'],
      preferredCredits: registration_request_item['preferredCredits'],
      preferredGradingOptionIds: registration_request_item['preferredGradingOptionIds'],
      processResults: registration_request_item['processResults'],
      resultingRegistrationId: registration_request_item['resultingRegistrationId'],
      courseWaitlistEntryId: registration_request_item['courseWaitlistEntryId'],
      processingPriority: registration_request_item['processingPriority'],
      lastAttendanceDate: registration_request_item['lastAttendanceDate'],
      notificationDate: registration_request_item['notificationDate'],
      meta: registration_request_item['meta'],
      attributes: registration_request_item['attributes'],
      type: registration_request_item['type'],
      state: registration_request_item['state']
    )

    { registration_request: request, registration_request_item: request_item }
  end

  def update_waitlist_request(waitlistRequestId, waitlistRequest)
    headers = { 'Content-Type' => 'application/json' }
    json_body = waitlistRequest.to_h.to_json
    # puts "json_body="+ json_body
    response = self.class.put("/waitlistrequests/#{waitlistRequestId}", body: json_body, headers: headers)
    if response.code == 200
      # puts "response.body="+ response.body
      h = JSON.parse(response.body)
      return HashToStruct.struct(h)
    end
    raise DoesNotExistException.new waitlistRequestId
  end

  def get_waitlist_request(waitlistRequestId)
    url = @hostUrl + @servicesUrlFragment + @servicePath + "/waitlistrequests/" + waitlistRequestId
    response = self.class.get("/waitlistrequests/#{waitlistRequestId}")
    if response.status == 200
      h = JSON.parse(response.body)
      r=HashToStruct.struct(h)
      return r
    end
    raise DoesNotExistException.new waitlistRequestId
  end


  def change_waitlist_request_state(waitlistRequestId, stateKey)
    headers = { 'Content-Type' => 'application/json' }
    # puts "json_body="+ json_body
    response = self.class.put("/waitlistrequests/#{waitlistRequestId}/changestate/#{stateKey}", headers: headers)
    if response.code == 200
      return
    end
    raise DoesNotExistException.new waitlistRequestId
  end

end