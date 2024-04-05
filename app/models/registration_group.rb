class RegistrationGroup
  include ActiveModel::Model

  attr_accessor \
    :attributes,
    :meta,
    :typeKey,
    :stateKey,
    :name,
    :descr,
    :id,
    :formatOfferingId,
    :courseOfferingId,
    :termId,
    :registrationCode,
    :courseCode,
    :activityOfferingIds,
    :multiOfferingId,
    :bundledOfferingId,
    :isGenerated,
    :gradingOptionId,
    :studentRegistrationGradingOptionIds,
    :creditOptionId,
    :requisiteIds,
    :coRequisiteIds,
    :restrictionIds,
    :type,
    :state

end
