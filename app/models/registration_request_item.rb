class RegistrationRequestItem
  include ActiveModel::Model

  attr_accessor \
  :id,
  :typeKey,
  :stateKey,
  :effectiveDate,
  :expirationDate,
  :name,
  :descr,
  :registrationRequestId,
  :studentId,
  :requestedEffectiveDate,
  :existingRegistrationId,
  :existingActivityOfferingId,
  :preferredActivityOfferingIds,
  :preferredFormatOfferingIds,
  :preferredRegistrationGroupIds,
  :preferredCredits,
  :preferredGradingOptionIds,
  :processResults,
  :resultingRegistrationId,
  :courseWaitlistEntryId,
  :processingPriority,
  :lastAttendanceDate,
  :notificationDate,
  :meta,
  :attributes,
  :type,
  :state
end

end
