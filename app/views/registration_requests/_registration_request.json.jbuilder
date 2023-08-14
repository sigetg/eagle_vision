json.extract! registration_request, :id, :typeKey, :stateKey, :effectiveDate, :expirationDate, :name, :descr, :person_id, :term_id, :submittedDate, :processResults, :itemStudentIds, :itemStudentPopulationId, :meta, :created_at, :updated_at
json.url registration_request_url(registration_request, format: :json)
