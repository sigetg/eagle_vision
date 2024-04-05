require "application_system_test_case"

class RegistrationRequestsTest < ApplicationSystemTestCase
  setup do
    @registration_request = registration_requests(:one)
  end

  test "visiting the index" do
    visit registration_requests_url
    assert_selector "h1", text: "Registration requests"
  end

  test "should create registration request" do
    visit registration_requests_url
    click_on "New registration request"

    fill_in "Descr", with: @registration_request.descr
    fill_in "Effectivedate", with: @registration_request.effectiveDate
    fill_in "Expirationdate", with: @registration_request.expirationDate
    fill_in "Itemstudentids", with: @registration_request.itemStudentIds
    fill_in "Itemstudentpopulationid", with: @registration_request.itemStudentPopulationId
    fill_in "Meta", with: @registration_request.meta
    fill_in "Name", with: @registration_request.name
    fill_in "Person", with: @registration_request.person_id
    fill_in "Processresults", with: @registration_request.processResults
    fill_in "Statekey", with: @registration_request.stateKey
    fill_in "Submitteddate", with: @registration_request.submittedDate
    fill_in "Term", with: @registration_request.term_id
    fill_in "Typekey", with: @registration_request.typeKey
    click_on "Create Registration request"

    assert_text "Registration request was successfully created"
    click_on "Back"
  end

  test "should update Registration request" do
    visit registration_request_url(@registration_request)
    click_on "Edit this registration request", match: :first

    fill_in "Descr", with: @registration_request.descr
    fill_in "Effectivedate", with: @registration_request.effectiveDate
    fill_in "Expirationdate", with: @registration_request.expirationDate
    fill_in "Itemstudentids", with: @registration_request.itemStudentIds
    fill_in "Itemstudentpopulationid", with: @registration_request.itemStudentPopulationId
    fill_in "Meta", with: @registration_request.meta
    fill_in "Name", with: @registration_request.name
    fill_in "Person", with: @registration_request.person_id
    fill_in "Processresults", with: @registration_request.processResults
    fill_in "Statekey", with: @registration_request.stateKey
    fill_in "Submitteddate", with: @registration_request.submittedDate
    fill_in "Term", with: @registration_request.term_id
    fill_in "Typekey", with: @registration_request.typeKey
    click_on "Update Registration request"

    assert_text "Registration request was successfully updated"
    click_on "Back"
  end

  test "should destroy Registration request" do
    visit registration_request_url(@registration_request)
    click_on "Destroy this registration request", match: :first

    assert_text "Registration request was successfully destroyed"
  end
end
