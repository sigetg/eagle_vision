class Department
  include ActiveModel::Model

  attr_accessor \
    :attributes,
    :meta,
    :typeKey,
    :stateKey,
    :id,
    :shortName,
    :longName,
    :sortName,
    :longDescr,
    :shortDescr,
    :effectiveDate,
    :expirationDate,
    :orgCodes,
    :type,
    :state

end