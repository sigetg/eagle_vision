require "test_helper"

class CourseOfferingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_offering = course_offerings(:one)
  end

  test "should get index" do
    get course_offerings_url
    assert_response :success
  end

  test "should get new" do
    get new_course_offering_url
    assert_response :success
  end

  test "should create course_offering" do
    assert_difference("CourseOffering.count") do
      post course_offerings_url, params: { course_offering: { campusLocations: @course_offering.campusLocations, coRequisiteIds: @course_offering.coRequisiteIds, courseCode: @course_offering.courseCode, courseId: @course_offering.courseId, courseNumberSuffix: @course_offering.courseNumberSuffix, courseOfferingCode: @course_offering.courseOfferingCode, courseOfferingTitle: @course_offering.courseOfferingTitle, courseOfferingUrl: @course_offering.courseOfferingUrl, creditOptionId: @course_offering.creditOptionId, creditOptionIds: @course_offering.creditOptionIds, descr: @course_offering.descr, effectiveDate: @course_offering.effectiveDate, expirationDate: @course_offering.expirationDate, gradeRosterDefinitionId: @course_offering.gradeRosterDefinitionId, gradingOptionId: @course_offering.gradingOptionId, gradingOptionIds: @course_offering.gradingOptionIds, instructors: @course_offering.instructors, isEvaluated: @course_offering.isEvaluated, isHonorsOffering: @course_offering.isHonorsOffering, maximumEnrollment: @course_offering.maximumEnrollment, meta: @course_offering.meta, minimumEnrollment: @course_offering.minimumEnrollment, name: @course_offering.name, requisiteIds: @course_offering.requisiteIds, restrictionIds: @course_offering.restrictionIds, stateKey: @course_offering.stateKey, studentRegistrationGradingOptionIds: @course_offering.studentRegistrationGradingOptionIds, subjectAreaId: @course_offering.subjectAreaId, term_id: @course_offering.term_id, typeKey: @course_offering.typeKey, unitsDeploymentOrgIds: @course_offering.unitsDeploymentOrgIds } }
    end

    assert_redirected_to course_offering_url(CourseOffering.last)
  end

  test "should show course_offering" do
    get course_offering_url(@course_offering)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_offering_url(@course_offering)
    assert_response :success
  end

  test "should update course_offering" do
    patch course_offering_url(@course_offering), params: { course_offering: { campusLocations: @course_offering.campusLocations, coRequisiteIds: @course_offering.coRequisiteIds, courseCode: @course_offering.courseCode, courseId: @course_offering.courseId, courseNumberSuffix: @course_offering.courseNumberSuffix, courseOfferingCode: @course_offering.courseOfferingCode, courseOfferingTitle: @course_offering.courseOfferingTitle, courseOfferingUrl: @course_offering.courseOfferingUrl, creditOptionId: @course_offering.creditOptionId, creditOptionIds: @course_offering.creditOptionIds, descr: @course_offering.descr, effectiveDate: @course_offering.effectiveDate, expirationDate: @course_offering.expirationDate, gradeRosterDefinitionId: @course_offering.gradeRosterDefinitionId, gradingOptionId: @course_offering.gradingOptionId, gradingOptionIds: @course_offering.gradingOptionIds, instructors: @course_offering.instructors, isEvaluated: @course_offering.isEvaluated, isHonorsOffering: @course_offering.isHonorsOffering, maximumEnrollment: @course_offering.maximumEnrollment, meta: @course_offering.meta, minimumEnrollment: @course_offering.minimumEnrollment, name: @course_offering.name, requisiteIds: @course_offering.requisiteIds, restrictionIds: @course_offering.restrictionIds, stateKey: @course_offering.stateKey, studentRegistrationGradingOptionIds: @course_offering.studentRegistrationGradingOptionIds, subjectAreaId: @course_offering.subjectAreaId, term_id: @course_offering.term_id, typeKey: @course_offering.typeKey, unitsDeploymentOrgIds: @course_offering.unitsDeploymentOrgIds } }
    assert_redirected_to course_offering_url(@course_offering)
  end

  test "should destroy course_offering" do
    assert_difference("CourseOffering.count", -1) do
      delete course_offering_url(@course_offering)
    end

    assert_redirected_to course_offerings_url
  end
end
