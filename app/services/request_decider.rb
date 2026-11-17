# Applies a staff decision to a waitlist request: Accept, Decline (a message
# is required) or Reopen. The state rules decide which moves are allowed.
# Saves the message and who decided in the request, then changes its state.
class RequestDecider
  Result = Struct.new(:ok, :error, :status) do
    def ok? = ok
  end

  def initialize(api:, waitlist_request:, decided_by:)
    @api = api
    @waitlist_request = waitlist_request
    @decided_by = decided_by
  end

  def call(action:, message:)
    to = RequestStateRules::ACTIONS[action.to_s]
    from = @waitlist_request.status
    return Result.new(false, "That action isn't available.", from) unless RequestStateRules.allowed?(from, to)
    return Result.new(false, "Write a message to the student to decline.", from) if to == :declined && message.blank?

    @waitlist_request.decision =
      if to == :waiting
        StaffDecision.new
      else
        StaffDecision.new(message: message.presence, decided_by: @decided_by, decided_at: Time.current.iso8601)
      end
    @api.update_waitlist_request(@waitlist_request.id, @waitlist_request.to_api)
    @api.change_waitlist_request_state(@waitlist_request.id, RequestStatus.key_for(to))
    @waitlist_request.request.stateKey = RequestStatus.key_for(to)
    Result.new(true, nil, to)
  end
end
