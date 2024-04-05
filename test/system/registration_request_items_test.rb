require "application_system_test_case"

class RegistrationRequestItemsTest < ApplicationSystemTestCase
  setup do
    @registration_request_item = registration_request_items(:one)
  end

  test "visiting the index" do
    visit registration_request_items_url
    assert_selector "h1", text: "Registration request items"
  end

  test "should create registration request item" do
    visit registration_request_items_url
    click_on "New registration request item"

    fill_in "Coursewaitlistentryid", with: @registration_request_item.courseWaitlistEntryId
    fill_in "Descr", with: @registration_request_item.descr
    fill_in "Effectivedate", with: @registration_request_item.effectiveDate
    fill_in "Existingactivityofferingid", with: @registration_request_item.existingActivityOfferingId
    fill_in "Existingregistrationid", with: @registration_request_item.existingRegistrationId
    fill_in "Expirationdate", with: @registration_request_item.expirationDate
    fill_in "Lastattendancedate", with: @registration_request_item.lastAttendanceDate
    fill_in "Meta", with: @registration_request_item.meta
    fill_in "Name", with: @registration_request_item.name
    fill_in "Notificationdate", with: @registration_request_item.notificationDate
    fill_in "Person", with: @registration_request_item.person_id
    fill_in "Preferredactivityofferingids", with: @registration_request_item.preferredActivityOfferingIds
    fill_in "Preferredcredits", with: @registration_request_item.preferredCredits
    fill_in "Preferredformatofferingids", with: @registration_request_item.preferredFormatOfferingIds
    fill_in "Preferredgradingoptionids", with: @registration_request_item.preferredGradingOptionIds
    fill_in "Preferredregistrationgroupids", with: @registration_request_item.preferredRegistrationGroupIds
    fill_in "Processresults", with: @registration_request_item.processResults
    fill_in "Processingpriority", with: @registration_request_item.processingPriority
    fill_in "Registration request", with: @registration_request_item.registration_request_id
    fill_in "Requestedeffectivedate", with: @registration_request_item.requestedEffectiveDate
    fill_in "Resultingregistrationid", with: @registration_request_item.resultingRegistrationId
    fill_in "Statekey", with: @registration_request_item.stateKey
    fill_in "Typekey", with: @registration_request_item.typeKey
    click_on "Create Registration request item"

    assert_text "Registration request item was successfully created"
    click_on "Back"
  end

  test "should update Registration request item" do
    visit registration_request_item_url(@registration_request_item)
    click_on "Edit this registration request item", match: :first

    fill_in "Coursewaitlistentryid", with: @registration_request_item.courseWaitlistEntryId
    fill_in "Descr", with: @registration_request_item.descr
    fill_in "Effectivedate", with: @registration_request_item.effectiveDate
    fill_in "Existingactivityofferingid", with: @registration_request_item.existingActivityOfferingId
    fill_in "Existingregistrationid", with: @registration_request_item.existingRegistrationId
    fill_in "Expirationdate", with: @registration_request_item.expirationDate
    fill_in "Lastattendancedate", with: @registration_request_item.lastAttendanceDate
    fill_in "Meta", with: @registration_request_item.meta
    fill_in "Name", with: @registration_request_item.name
    fill_in "Notificationdate", with: @registration_request_item.notificationDate
    fill_in "Person", with: @registration_request_item.person_id
    fill_in "Preferredactivityofferingids", with: @registration_request_item.preferredActivityOfferingIds
    fill_in "Preferredcredits", with: @registration_request_item.preferredCredits
    fill_in "Preferredformatofferingids", with: @registration_request_item.preferredFormatOfferingIds
    fill_in "Preferredgradingoptionids", with: @registration_request_item.preferredGradingOptionIds
    fill_in "Preferredregistrationgroupids", with: @registration_request_item.preferredRegistrationGroupIds
    fill_in "Processresults", with: @registration_request_item.processResults
    fill_in "Processingpriority", with: @registration_request_item.processingPriority
    fill_in "Registration request", with: @registration_request_item.registration_request_id
    fill_in "Requestedeffectivedate", with: @registration_request_item.requestedEffectiveDate
    fill_in "Resultingregistrationid", with: @registration_request_item.resultingRegistrationId
    fill_in "Statekey", with: @registration_request_item.stateKey
    fill_in "Typekey", with: @registration_request_item.typeKey
    click_on "Update Registration request item"

    assert_text "Registration request item was successfully updated"
    click_on "Back"
  end

  test "should destroy Registration request item" do
    visit registration_request_item_url(@registration_request_item)
    click_on "Destroy this registration request item", match: :first

    assert_text "Registration request item was successfully destroyed"
  end
end
