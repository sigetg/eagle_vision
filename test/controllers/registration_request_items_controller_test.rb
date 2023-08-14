require "test_helper"

class RegistrationRequestItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_request_item = registration_request_items(:one)
  end

  test "should get index" do
    get registration_request_items_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_request_item_url
    assert_response :success
  end

  test "should create registration_request_item" do
    assert_difference("RegistrationRequestItem.count") do
      post registration_request_items_url, params: { registration_request_item: { courseWaitlistEntryId: @registration_request_item.courseWaitlistEntryId, descr: @registration_request_item.descr, effectiveDate: @registration_request_item.effectiveDate, existingActivityOfferingId: @registration_request_item.existingActivityOfferingId, existingRegistrationId: @registration_request_item.existingRegistrationId, expirationDate: @registration_request_item.expirationDate, lastAttendanceDate: @registration_request_item.lastAttendanceDate, meta: @registration_request_item.meta, name: @registration_request_item.name, notificationDate: @registration_request_item.notificationDate, person_id: @registration_request_item.person_id, preferredActivityOfferingIds: @registration_request_item.preferredActivityOfferingIds, preferredCredits: @registration_request_item.preferredCredits, preferredFormatOfferingIds: @registration_request_item.preferredFormatOfferingIds, preferredGradingOptionIds: @registration_request_item.preferredGradingOptionIds, preferredRegistrationGroupIds: @registration_request_item.preferredRegistrationGroupIds, processResults: @registration_request_item.processResults, processingPriority: @registration_request_item.processingPriority, registration_request_id: @registration_request_item.registration_request_id, requestedEffectiveDate: @registration_request_item.requestedEffectiveDate, resultingRegistrationId: @registration_request_item.resultingRegistrationId, stateKey: @registration_request_item.stateKey, typeKey: @registration_request_item.typeKey } }
    end

    assert_redirected_to registration_request_item_url(RegistrationRequestItem.last)
  end

  test "should show registration_request_item" do
    get registration_request_item_url(@registration_request_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_registration_request_item_url(@registration_request_item)
    assert_response :success
  end

  test "should update registration_request_item" do
    patch registration_request_item_url(@registration_request_item), params: { registration_request_item: { courseWaitlistEntryId: @registration_request_item.courseWaitlistEntryId, descr: @registration_request_item.descr, effectiveDate: @registration_request_item.effectiveDate, existingActivityOfferingId: @registration_request_item.existingActivityOfferingId, existingRegistrationId: @registration_request_item.existingRegistrationId, expirationDate: @registration_request_item.expirationDate, lastAttendanceDate: @registration_request_item.lastAttendanceDate, meta: @registration_request_item.meta, name: @registration_request_item.name, notificationDate: @registration_request_item.notificationDate, person_id: @registration_request_item.person_id, preferredActivityOfferingIds: @registration_request_item.preferredActivityOfferingIds, preferredCredits: @registration_request_item.preferredCredits, preferredFormatOfferingIds: @registration_request_item.preferredFormatOfferingIds, preferredGradingOptionIds: @registration_request_item.preferredGradingOptionIds, preferredRegistrationGroupIds: @registration_request_item.preferredRegistrationGroupIds, processResults: @registration_request_item.processResults, processingPriority: @registration_request_item.processingPriority, registration_request_id: @registration_request_item.registration_request_id, requestedEffectiveDate: @registration_request_item.requestedEffectiveDate, resultingRegistrationId: @registration_request_item.resultingRegistrationId, stateKey: @registration_request_item.stateKey, typeKey: @registration_request_item.typeKey } }
    assert_redirected_to registration_request_item_url(@registration_request_item)
  end

  test "should destroy registration_request_item" do
    assert_difference("RegistrationRequestItem.count", -1) do
      delete registration_request_item_url(@registration_request_item)
    end

    assert_redirected_to registration_request_items_url
  end
end
