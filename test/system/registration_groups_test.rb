require "application_system_test_case"

class RegistrationGroupsTest < ApplicationSystemTestCase
  setup do
    @registration_group = registration_groups(:one)
  end

  test "visiting the index" do
    visit registration_groups_url
    assert_selector "h1", text: "Registration groups"
  end

  test "should create registration group" do
    visit registration_groups_url
    click_on "New registration group"

    fill_in "Activityofferingids", with: @registration_group.activityOfferingIds
    fill_in "Attributes", with: @registration_group.attributes
    fill_in "Bundledofferingid", with: @registration_group.bundledOfferingId
    fill_in "Corequisiteids", with: @registration_group.coRequisiteIds
    fill_in "Coursecode", with: @registration_group.courseCode
    fill_in "Courseofferingid", with: @registration_group.courseOfferingId
    fill_in "Creditoptionid", with: @registration_group.creditOptionId
    fill_in "Descr", with: @registration_group.descr
    fill_in "Formatofferingid", with: @registration_group.formatOfferingId
    fill_in "Gradingoptionid", with: @registration_group.gradingOptionId
    fill_in "Id", with: @registration_group.id
    check "Isgenerated" if @registration_group.isGenerated
    fill_in "Meta", with: @registration_group.meta
    fill_in "Multiofferingid", with: @registration_group.multiOfferingId
    fill_in "Name", with: @registration_group.name
    fill_in "Registrationcode", with: @registration_group.registrationCode
    fill_in "Requisiteids", with: @registration_group.requisiteIds
    fill_in "Restrictionids", with: @registration_group.restrictionIds
    fill_in "State", with: @registration_group.state
    fill_in "Statekey", with: @registration_group.stateKey
    fill_in "Studentregistrationgradingoptionids", with: @registration_group.studentRegistrationGradingOptionIds
    fill_in "Termid", with: @registration_group.termId
    fill_in "Type", with: @registration_group.type
    fill_in "Typekey", with: @registration_group.typeKey
    click_on "Create Registration group"

    assert_text "Registration group was successfully created"
    click_on "Back"
  end

  test "should update Registration group" do
    visit registration_group_url(@registration_group)
    click_on "Edit this registration group", match: :first

    fill_in "Activityofferingids", with: @registration_group.activityOfferingIds
    fill_in "Attributes", with: @registration_group.attributes
    fill_in "Bundledofferingid", with: @registration_group.bundledOfferingId
    fill_in "Corequisiteids", with: @registration_group.coRequisiteIds
    fill_in "Coursecode", with: @registration_group.courseCode
    fill_in "Courseofferingid", with: @registration_group.courseOfferingId
    fill_in "Creditoptionid", with: @registration_group.creditOptionId
    fill_in "Descr", with: @registration_group.descr
    fill_in "Formatofferingid", with: @registration_group.formatOfferingId
    fill_in "Gradingoptionid", with: @registration_group.gradingOptionId
    fill_in "Id", with: @registration_group.id
    check "Isgenerated" if @registration_group.isGenerated
    fill_in "Meta", with: @registration_group.meta
    fill_in "Multiofferingid", with: @registration_group.multiOfferingId
    fill_in "Name", with: @registration_group.name
    fill_in "Registrationcode", with: @registration_group.registrationCode
    fill_in "Requisiteids", with: @registration_group.requisiteIds
    fill_in "Restrictionids", with: @registration_group.restrictionIds
    fill_in "State", with: @registration_group.state
    fill_in "Statekey", with: @registration_group.stateKey
    fill_in "Studentregistrationgradingoptionids", with: @registration_group.studentRegistrationGradingOptionIds
    fill_in "Termid", with: @registration_group.termId
    fill_in "Type", with: @registration_group.type
    fill_in "Typekey", with: @registration_group.typeKey
    click_on "Update Registration group"

    assert_text "Registration group was successfully updated"
    click_on "Back"
  end

  test "should destroy Registration group" do
    visit registration_group_url(@registration_group)
    click_on "Destroy this registration group", match: :first

    assert_text "Registration group was successfully destroyed"
  end
end
