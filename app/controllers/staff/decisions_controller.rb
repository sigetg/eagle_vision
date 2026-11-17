module Staff
  # Accept, Decline and Reopen from the request page's decision panel. The
  # panel sits in a Turbo Frame, so the answer replaces just the panel.
  class DecisionsController < BaseController
    include WaitlistRequestLoading

    def create
      @waitlist_request = load_waitlist_request(params[:request_id])
      authorize @waitlist_request, :decide?
      result = RequestDecider.new(api: set_api_service, waitlist_request: @waitlist_request, decided_by: current_viewer.name)
                             .call(action: params[:decision], message: params[:message])

      if result.ok?
        after_decision(result.status)
        render partial: "staff/requests/decision_panel", locals: { waitlist_request: @waitlist_request, error: nil }
      else
        render partial: "staff/requests/decision_panel", locals: { waitlist_request: @waitlist_request, error: result.error },
               status: 422
      end
    end

    private

    # PR 7 emails the student here.
    def after_decision(_status); end
  end
end
