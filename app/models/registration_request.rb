class RegistrationRequest
  include ActiveModel::Model

  attr_accessor \
    :id,
    :attributes,
    :meta,
    :typeKey,
    :stateKey,
    :effectiveDate,
    :expirationDate,
    :name,
    :descr,
    :requestorId,
    :termId,
    :submittedDate,
    :processResults,
    :itemStudentIds,
    :itemStudentPopulationId,
    :type,
    :state

end
