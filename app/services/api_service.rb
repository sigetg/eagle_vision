class ApiService
  include HTTParty
  base_uri 'http://127.0.0.1:8080/waitlist'

  def fetch_and_map_waitlistcourseofferings(term, code)
    response = self.class.get("/waitlistcourseofferings?termId=#{term}&code=#{code}")
    api_data = JSON.parse(response.body)

    api_data.map { |api_item| self.class.map_to_course_offering(api_item) }
  end

  def fetch_and_map_waitlistactivityofferings(course_offering_id)
    response = self.class.get("/waitlistactivityofferings?courseOfferingId=#{course_offering_id}")
    api_data = JSON.parse(response.body)

    api_data.map { |api_item| self.class.map_to_activity_offering(api_item) }
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

  def self.map_to_activity_offering(api_item)
    activity_offering = api_item['activityOffering']
    ActivityOffering.new(
      id: activity_offering['id'],
      typeKey: activity_offering['typeKey'],
      stateKey: activity_offering['stateKey'],
      effectiveDate: activity_offering['effectiveDate'],
      expirationDate: activity_offering['expirationDate'],
      name: activity_offering['name'],
      activityCode: activity_offering['activityCode'],
      scheduleIds: activity_offering['scheduleIds'],
      instructors: activity_offering['instructors'],
      maximumEnrollment: activity_offering['maximumEnrollment'],
      minimumEnrollment: activity_offering['minimumEnrollment'],
      isEvaluated: activity_offering['isEvaluated'],
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
end