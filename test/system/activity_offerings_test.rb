require "application_system_test_case"

class ActivityOfferingsTest < ApplicationSystemTestCase
  setup do
    @activity_offering = activity_offerings(:one)
  end

  test "visiting the index" do
    visit activity_offerings_url
    assert_selector "h1", text: "Activity offerings"
  end

  test "should create activity offering" do
    visit activity_offerings_url
    click_on "New activity offering"

    fill_in "Activitycode", with: @activity_offering.activityCode
    fill_in "Activityid", with: @activity_offering.activityId
    fill_in "Activityofferingurl", with: @activity_offering.activityOfferingUrl
    fill_in "Corequisiteids", with: @activity_offering.coRequisiteIds
    fill_in "Courseofferingcode", with: @activity_offering.courseOfferingCode
    fill_in "Courseofferingtitle", with: @activity_offering.courseOfferingTitle
    fill_in "Course offering", with: @activity_offering.course_offering_id
    fill_in "Descr", with: @activity_offering.descr
    fill_in "Effectivedate", with: @activity_offering.effectiveDate
    fill_in "Expirationdate", with: @activity_offering.expirationDate
    fill_in "Formatofferingid", with: @activity_offering.formatOfferingId
    fill_in "Formatofferingname", with: @activity_offering.formatOfferingName
    fill_in "Instructors", with: @activity_offering.instructors
    check "Isevaluated" if @activity_offering.isEvaluated
    check "Ishonorsoffering" if @activity_offering.isHonorsOffering
    fill_in "Maximumenrollment", with: @activity_offering.maximumEnrollment
    fill_in "Meta", with: @activity_offering.meta
    fill_in "Minimumenrollment", with: @activity_offering.minimumEnrollment
    fill_in "Name", with: @activity_offering.name
    fill_in "Requisiteids", with: @activity_offering.requisiteIds
    fill_in "Restrictionids", with: @activity_offering.restrictionIds
    fill_in "Scheduleids", with: @activity_offering.scheduleIds
    fill_in "Statekey", with: @activity_offering.stateKey
    fill_in "Termcode", with: @activity_offering.termCode
    fill_in "Term", with: @activity_offering.term_id
    fill_in "Typekey", with: @activity_offering.typeKey
    fill_in "Unitsdeploymentorgids", with: @activity_offering.unitsDeploymentOrgIds
    fill_in "Weeklyinclasscontacthours", with: @activity_offering.weeklyInclassContactHours
    fill_in "Weeklyoutofclasshours", with: @activity_offering.weeklyOutofClassHours
    fill_in "Weeklytotalcontacthours", with: @activity_offering.weeklyTotalContactHours
    click_on "Create Activity offering"

    assert_text "Activity offering was successfully created"
    click_on "Back"
  end

  test "should update Activity offering" do
    visit activity_offering_url(@activity_offering)
    click_on "Edit this activity offering", match: :first

    fill_in "Activitycode", with: @activity_offering.activityCode
    fill_in "Activityid", with: @activity_offering.activityId
    fill_in "Activityofferingurl", with: @activity_offering.activityOfferingUrl
    fill_in "Corequisiteids", with: @activity_offering.coRequisiteIds
    fill_in "Courseofferingcode", with: @activity_offering.courseOfferingCode
    fill_in "Courseofferingtitle", with: @activity_offering.courseOfferingTitle
    fill_in "Course offering", with: @activity_offering.course_offering_id
    fill_in "Descr", with: @activity_offering.descr
    fill_in "Effectivedate", with: @activity_offering.effectiveDate
    fill_in "Expirationdate", with: @activity_offering.expirationDate
    fill_in "Formatofferingid", with: @activity_offering.formatOfferingId
    fill_in "Formatofferingname", with: @activity_offering.formatOfferingName
    fill_in "Instructors", with: @activity_offering.instructors
    check "Isevaluated" if @activity_offering.isEvaluated
    check "Ishonorsoffering" if @activity_offering.isHonorsOffering
    fill_in "Maximumenrollment", with: @activity_offering.maximumEnrollment
    fill_in "Meta", with: @activity_offering.meta
    fill_in "Minimumenrollment", with: @activity_offering.minimumEnrollment
    fill_in "Name", with: @activity_offering.name
    fill_in "Requisiteids", with: @activity_offering.requisiteIds
    fill_in "Restrictionids", with: @activity_offering.restrictionIds
    fill_in "Scheduleids", with: @activity_offering.scheduleIds
    fill_in "Statekey", with: @activity_offering.stateKey
    fill_in "Termcode", with: @activity_offering.termCode
    fill_in "Term", with: @activity_offering.term_id
    fill_in "Typekey", with: @activity_offering.typeKey
    fill_in "Unitsdeploymentorgids", with: @activity_offering.unitsDeploymentOrgIds
    fill_in "Weeklyinclasscontacthours", with: @activity_offering.weeklyInclassContactHours
    fill_in "Weeklyoutofclasshours", with: @activity_offering.weeklyOutofClassHours
    fill_in "Weeklytotalcontacthours", with: @activity_offering.weeklyTotalContactHours
    click_on "Update Activity offering"

    assert_text "Activity offering was successfully updated"
    click_on "Back"
  end

  test "should destroy Activity offering" do
    visit activity_offering_url(@activity_offering)
    click_on "Destroy this activity offering", match: :first

    assert_text "Activity offering was successfully destroyed"
  end
end
