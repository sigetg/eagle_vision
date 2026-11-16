# The Kuali state keys a waitlist request can have, from BC's waitlist API.
# Rails expects this file to define TempConstants (Zeitwerk maps file names
# to constants), so the keys live inside that module. Nothing reads them
# yet; PR 6's state rules will.
module TempConstants
  REGISTRATION_REQUEST_STATE_KEY_DISCARDED = "kuali.courseregistration.request.state.discarded"
  REGISTRATION_REQUEST_STATE_KEY_UNSUBMITTED = "kuali.courseregistration.request.state.unsubmitted"
  REGISTRATION_REQUEST_STATE_KEY_SUBMITTED = "kuali.courseregistration.request.state.submitted"
  REGISTRATION_REQUEST_STATE_KEY_PROCESSING = "kuali.courseregistration.request.state.processing"
  REGISTRATION_REQUEST_STATE_KEY_PROCESSED_SUCCESS = "kuali.courseregistration.request.state.processed.success"
  REGISTRATION_REQUEST_STATE_KEY_PROCESSED_FAILURE_FULL = "kuali.courseregistration.request.state.processed.failure.full"
  REGISTRATION_REQUEST_STATE_KEY_PROCESSED_FAILURE_PARTIAL = "kuali.courseregistration.request.state.processed.failure.partial"
end
