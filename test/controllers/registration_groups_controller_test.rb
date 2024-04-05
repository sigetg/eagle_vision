require "test_helper"

class RegistrationGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_group = registration_groups(:one)
  end

  test "should get index" do
    get registration_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_group_url
    assert_response :success
  end

  test "should create registration_group" do
    assert_difference("RegistrationGroup.count") do
      post registration_groups_url, params: { registration_group: { activityOfferingIds: @registration_group.activityOfferingIds, attributes: @registration_group.attributes, bundledOfferingId: @registration_group.bundledOfferingId, coRequisiteIds: @registration_group.coRequisiteIds, courseCode: @registration_group.courseCode, courseOfferingId: @registration_group.courseOfferingId, creditOptionId: @registration_group.creditOptionId, descr: @registration_group.descr, formatOfferingId: @registration_group.formatOfferingId, gradingOptionId: @registration_group.gradingOptionId, id: @registration_group.id, isGenerated: @registration_group.isGenerated, meta: @registration_group.meta, multiOfferingId: @registration_group.multiOfferingId, name: @registration_group.name, registrationCode: @registration_group.registrationCode, requisiteIds: @registration_group.requisiteIds, restrictionIds: @registration_group.restrictionIds, state: @registration_group.state, stateKey: @registration_group.stateKey, studentRegistrationGradingOptionIds: @registration_group.studentRegistrationGradingOptionIds, termId: @registration_group.termId, type: @registration_group.type, typeKey: @registration_group.typeKey } }
    end

    assert_redirected_to registration_group_url(RegistrationGroup.last)
  end

  test "should show registration_group" do
    get registration_group_url(@registration_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_registration_group_url(@registration_group)
    assert_response :success
  end

  test "should update registration_group" do
    patch registration_group_url(@registration_group), params: { registration_group: { activityOfferingIds: @registration_group.activityOfferingIds, attributes: @registration_group.attributes, bundledOfferingId: @registration_group.bundledOfferingId, coRequisiteIds: @registration_group.coRequisiteIds, courseCode: @registration_group.courseCode, courseOfferingId: @registration_group.courseOfferingId, creditOptionId: @registration_group.creditOptionId, descr: @registration_group.descr, formatOfferingId: @registration_group.formatOfferingId, gradingOptionId: @registration_group.gradingOptionId, id: @registration_group.id, isGenerated: @registration_group.isGenerated, meta: @registration_group.meta, multiOfferingId: @registration_group.multiOfferingId, name: @registration_group.name, registrationCode: @registration_group.registrationCode, requisiteIds: @registration_group.requisiteIds, restrictionIds: @registration_group.restrictionIds, state: @registration_group.state, stateKey: @registration_group.stateKey, studentRegistrationGradingOptionIds: @registration_group.studentRegistrationGradingOptionIds, termId: @registration_group.termId, type: @registration_group.type, typeKey: @registration_group.typeKey } }
    assert_redirected_to registration_group_url(@registration_group)
  end

  test "should destroy registration_group" do
    assert_difference("RegistrationGroup.count", -1) do
      delete registration_group_url(@registration_group)
    end

    assert_redirected_to registration_groups_url
  end
end
