class Term
  include ActiveModel::Model

  attr_accessor \
    :attributes,
    :meta,
    :typeKey,
    :stateKey,
    :name,
    :descr,
    :id,
    :code,
    :startDate,
    :endDate,
    :adminOrgId,
    :type,
    :state

end
