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

    # Emails the student (E1). deliver_later sends it from a background job,
    # so the page doesn't wait on the mail server.
    def after_decision(status)
      department = current_viewer.departments.find { |d| @waitlist_request.department_ids.include?(d.id.to_s) }
      DecisionMailer.with(
        to: student_email, status: status.to_s, course_code: @waitlist_request.course_code,
        sections: @waitlist_request.section_codes, message: @waitlist_request.decision.message,
        department: department&.longName
      ).decided.deliver_later
    end

    def student_email
      User.find_by(person_id: @waitlist_request.student_id)&.email || "#{@waitlist_request.student_id}@bc.edu"
    end
  end
end
