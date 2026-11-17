# The three statuses a waitlist request can have, and the Kuali state key
# each one is stored as in the API. See
# docs/adr/2026-11-16-three-request-statuses.md. Kuali keys never reach a page:
# views call RequestStatus.label (or the status_badge helper).
module RequestStatus
  KEYS = {
    waiting: "kuali.courseregistration.request.state.submitted",
    accepted: "kuali.courseregistration.request.state.processed.success",
    declined: "kuali.courseregistration.request.state.discarded"
  }.freeze

  LABELS = { waiting: "Waiting", accepted: "Accepted", declined: "Declined" }.freeze

  ALL = KEYS.keys.freeze

  # :waiting, :accepted or :declined for a Kuali key; nil for any other key
  # (a draft that was never submitted, for example).
  def self.from_key(state_key)
    KEYS.key(state_key)
  end

  def self.key_for(status)
    KEYS.fetch(status.to_sym)
  end

  def self.label(status)
    LABELS.fetch(status&.to_sym, "Draft")
  end
end
