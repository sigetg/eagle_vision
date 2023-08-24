class Person
  include ActiveModel::Model

  attr_accessor \
    :attributes,
    :meta,
    :typeKey,
    :stateKey,
    :name,
    :descr,
    :id,
    :pictureDocumentId,
    :type,
    :state

end
