require "test_helper"

class ActivityOfferingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_offering = activity_offerings(:one)
  end

  test "should get index" do
    get activity_offerings_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_offering_url
    assert_response :success
  end

  test "should create activity_offering" do
    assert_difference("ActivityOffering.count") do
      post activity_offerings_url, params: { activity_offering: { activityCode: @activity_offering.activityCode, activityId: @activity_offering.activityId, activityOfferingUrl: @activity_offering.activityOfferingUrl, coRequisiteIds: @activity_offering.coRequisiteIds, courseOfferingCode: @activity_offering.courseOfferingCode, courseOfferingTitle: @activity_offering.courseOfferingTitle, course_offering_id: @activity_offering.course_offering_id, descr: @activity_offering.descr, effectiveDate: @activity_offering.effectiveDate, expirationDate: @activity_offering.expirationDate, formatOfferingId: @activity_offering.formatOfferingId, formatOfferingName: @activity_offering.formatOfferingName, instructors: @activity_offering.instructors, isEvaluated: @activity_offering.isEvaluated, isHonorsOffering: @activity_offering.isHonorsOffering, maximumEnrollment: @activity_offering.maximumEnrollment, meta: @activity_offering.meta, minimumEnrollment: @activity_offering.minimumEnrollment, name: @activity_offering.name, requisiteIds: @activity_offering.requisiteIds, restrictionIds: @activity_offering.restrictionIds, scheduleIds: @activity_offering.scheduleIds, stateKey: @activity_offering.stateKey, termCode: @activity_offering.termCode, term_id: @activity_offering.term_id, typeKey: @activity_offering.typeKey, unitsDeploymentOrgIds: @activity_offering.unitsDeploymentOrgIds, weeklyInclassContactHours: @activity_offering.weeklyInclassContactHours, weeklyOutofClassHours: @activity_offering.weeklyOutofClassHours, weeklyTotalContactHours: @activity_offering.weeklyTotalContactHours } }
    end

    assert_redirected_to activity_offering_url(ActivityOffering.last)
  end

  test "should show activity_offering" do
    get activity_offering_url(@activity_offering)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_offering_url(@activity_offering)
    assert_response :success
  end

  test "should update activity_offering" do
    patch activity_offering_url(@activity_offering), params: { activity_offering: { activityCode: @activity_offering.activityCode, activityId: @activity_offering.activityId, activityOfferingUrl: @activity_offering.activityOfferingUrl, coRequisiteIds: @activity_offering.coRequisiteIds, courseOfferingCode: @activity_offering.courseOfferingCode, courseOfferingTitle: @activity_offering.courseOfferingTitle, course_offering_id: @activity_offering.course_offering_id, descr: @activity_offering.descr, effectiveDate: @activity_offering.effectiveDate, expirationDate: @activity_offering.expirationDate, formatOfferingId: @activity_offering.formatOfferingId, formatOfferingName: @activity_offering.formatOfferingName, instructors: @activity_offering.instructors, isEvaluated: @activity_offering.isEvaluated, isHonorsOffering: @activity_offering.isHonorsOffering, maximumEnrollment: @activity_offering.maximumEnrollment, meta: @activity_offering.meta, minimumEnrollment: @activity_offering.minimumEnrollment, name: @activity_offering.name, requisiteIds: @activity_offering.requisiteIds, restrictionIds: @activity_offering.restrictionIds, scheduleIds: @activity_offering.scheduleIds, stateKey: @activity_offering.stateKey, termCode: @activity_offering.termCode, term_id: @activity_offering.term_id, typeKey: @activity_offering.typeKey, unitsDeploymentOrgIds: @activity_offering.unitsDeploymentOrgIds, weeklyInclassContactHours: @activity_offering.weeklyInclassContactHours, weeklyOutofClassHours: @activity_offering.weeklyOutofClassHours, weeklyTotalContactHours: @activity_offering.weeklyTotalContactHours } }
    assert_redirected_to activity_offering_url(@activity_offering)
  end

  test "should destroy activity_offering" do
    assert_difference("ActivityOffering.count", -1) do
      delete activity_offering_url(@activity_offering)
    end

    assert_redirected_to activity_offerings_url
  end
end
