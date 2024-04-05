require "application_system_test_case"

class CourseOfferingsTest < ApplicationSystemTestCase
  setup do
    @course_offering = course_offerings(:one)
  end

  test "visiting the index" do
    visit course_offerings_url
    assert_selector "h1", text: "Course offerings"
  end

  test "should create course offering" do
    visit course_offerings_url
    click_on "New course offering"

    fill_in "Campuslocations", with: @course_offering.campusLocations
    fill_in "Corequisiteids", with: @course_offering.coRequisiteIds
    fill_in "Coursecode", with: @course_offering.courseCode
    fill_in "Courseid", with: @course_offering.courseId
    fill_in "Coursenumbersuffix", with: @course_offering.courseNumberSuffix
    fill_in "Courseofferingcode", with: @course_offering.courseOfferingCode
    fill_in "Courseofferingtitle", with: @course_offering.courseOfferingTitle
    fill_in "Courseofferingurl", with: @course_offering.courseOfferingUrl
    fill_in "Creditoptionid", with: @course_offering.creditOptionId
    fill_in "Creditoptionids", with: @course_offering.creditOptionIds
    fill_in "Descr", with: @course_offering.descr
    fill_in "Effectivedate", with: @course_offering.effectiveDate
    fill_in "Expirationdate", with: @course_offering.expirationDate
    fill_in "Graderosterdefinitionid", with: @course_offering.gradeRosterDefinitionId
    fill_in "Gradingoptionid", with: @course_offering.gradingOptionId
    fill_in "Gradingoptionids", with: @course_offering.gradingOptionIds
    fill_in "Instructors", with: @course_offering.instructors
    check "Isevaluated" if @course_offering.isEvaluated
    check "Ishonorsoffering" if @course_offering.isHonorsOffering
    fill_in "Maximumenrollment", with: @course_offering.maximumEnrollment
    fill_in "Meta", with: @course_offering.meta
    fill_in "Minimumenrollment", with: @course_offering.minimumEnrollment
    fill_in "Name", with: @course_offering.name
    fill_in "Requisiteids", with: @course_offering.requisiteIds
    fill_in "Restrictionids", with: @course_offering.restrictionIds
    fill_in "Statekey", with: @course_offering.stateKey
    fill_in "Studentregistrationgradingoptionids", with: @course_offering.studentRegistrationGradingOptionIds
    fill_in "Subjectareaid", with: @course_offering.subjectAreaId
    fill_in "Term", with: @course_offering.term_id
    fill_in "Typekey", with: @course_offering.typeKey
    fill_in "Unitsdeploymentorgids", with: @course_offering.unitsDeploymentOrgIds
    click_on "Create Course offering"

    assert_text "Course offering was successfully created"
    click_on "Back"
  end

  test "should update Course offering" do
    visit course_offering_url(@course_offering)
    click_on "Edit this course offering", match: :first

    fill_in "Campuslocations", with: @course_offering.campusLocations
    fill_in "Corequisiteids", with: @course_offering.coRequisiteIds
    fill_in "Coursecode", with: @course_offering.courseCode
    fill_in "Courseid", with: @course_offering.courseId
    fill_in "Coursenumbersuffix", with: @course_offering.courseNumberSuffix
    fill_in "Courseofferingcode", with: @course_offering.courseOfferingCode
    fill_in "Courseofferingtitle", with: @course_offering.courseOfferingTitle
    fill_in "Courseofferingurl", with: @course_offering.courseOfferingUrl
    fill_in "Creditoptionid", with: @course_offering.creditOptionId
    fill_in "Creditoptionids", with: @course_offering.creditOptionIds
    fill_in "Descr", with: @course_offering.descr
    fill_in "Effectivedate", with: @course_offering.effectiveDate
    fill_in "Expirationdate", with: @course_offering.expirationDate
    fill_in "Graderosterdefinitionid", with: @course_offering.gradeRosterDefinitionId
    fill_in "Gradingoptionid", with: @course_offering.gradingOptionId
    fill_in "Gradingoptionids", with: @course_offering.gradingOptionIds
    fill_in "Instructors", with: @course_offering.instructors
    check "Isevaluated" if @course_offering.isEvaluated
    check "Ishonorsoffering" if @course_offering.isHonorsOffering
    fill_in "Maximumenrollment", with: @course_offering.maximumEnrollment
    fill_in "Meta", with: @course_offering.meta
    fill_in "Minimumenrollment", with: @course_offering.minimumEnrollment
    fill_in "Name", with: @course_offering.name
    fill_in "Requisiteids", with: @course_offering.requisiteIds
    fill_in "Restrictionids", with: @course_offering.restrictionIds
    fill_in "Statekey", with: @course_offering.stateKey
    fill_in "Studentregistrationgradingoptionids", with: @course_offering.studentRegistrationGradingOptionIds
    fill_in "Subjectareaid", with: @course_offering.subjectAreaId
    fill_in "Term", with: @course_offering.term_id
    fill_in "Typekey", with: @course_offering.typeKey
    fill_in "Unitsdeploymentorgids", with: @course_offering.unitsDeploymentOrgIds
    click_on "Update Course offering"

    assert_text "Course offering was successfully updated"
    click_on "Back"
  end

  test "should destroy Course offering" do
    visit course_offering_url(@course_offering)
    click_on "Destroy this course offering", match: :first

    assert_text "Course offering was successfully destroyed"
  end
end
