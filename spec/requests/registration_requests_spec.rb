require "rails_helper"

# How waitlist requests work today, before the rebuild changes any of it.
# Two examples are marked pending: they describe behaviour we want but don't
# have yet. RSpec runs them and expects them to fail; when a later fix makes
# one pass, RSpec reports it, and that PR removes the pending line.
RSpec.describe "Waitlist requests", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }
  let(:submitted) { "kuali.courseregistration.request.state.submitted" }
  let(:accepted) { "kuali.courseregistration.request.state.processed.success" }

  # Pages that list requests also look up each request's sections.
  before { stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering") }

  describe "as a student" do
    before { sign_in create_waitlist_user(:student) }

    it "creates a request in three API calls: create, save the answers, submit" do
      calls = []
      WebMock.after_request { |req, _response| calls << "#{req.method.upcase} #{req.uri.path}" }
      stub_waitlist_api(:create_request, query: { studentId: "90000001", registrationGroupId: "rg-1" },
                                         fixture: "new_request")
      save = stub_waitlist_api(:update_request, id: "req-new", fixture: "updated_request")
      stub_waitlist_api(:change_state, id: "req-new", state: submitted)

      post registration_requests_path, params: {
        registration_group_id: "rg-1", activity_offering_ids: "ao-lec-01",
        year: "Sophomore", major: "Economics", descr: "I need this course."
      }

      expect(response).to redirect_to(registration_requests_url)
      expect(calls.grep_v(%r{/waitlistpersons/})).to eq([
        "POST /waitlist/waitlistrequests",
        "PUT /waitlist/waitlistrequests/req-new",
        "PUT /waitlist/waitlistrequests/req-new/changestate/#{submitted}"
      ])
      # The answers are joined with a literal backslash-n ('\n' in single
      # quotes is two characters, not a newline). PR 9 replaces this with JSON.
      expect(save.with { |req|
        JSON.parse(req.body).dig("registrationRequest", "descr", "plain") == 'Sophomore\nEconomics\nI need this course.'
      }).to have_been_requested
    ensure
      WebMock.reset_callbacks
    end

    it "lists only their own requests" do
      stub_waitlist_api(:requests, query: { studentId: "90000001" }, fixture: "requests")

      get registration_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Waitlist request for 01, 02 - Letter - TEST1101", "Testperson, Avery")
    end

    it "withdraws a request by deleting it" do
      stub_waitlist_api(:request, id: "req-1", fixture: "request")
      delete_call = stub_waitlist_api(:delete_request, id: "req-1")

      delete registration_request_path("req-1")

      expect(delete_call).to have_been_requested
      expect(response).to redirect_to(registration_requests_url)
    end

    it "cannot open another student's request" do
      stub_waitlist_api(:request, id: "req-2", fixture: "other_students_request")

      get registration_request_path("req-2")

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "as staff" do
    before { sign_in create_waitlist_user(:staff) }

    it "lists requests from each authorized department" do
      stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "requests")
      stub_waitlist_api(:person, id: "90000001", fixture: "person_student")

      get registration_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Testperson, Avery")
    end

    it "accepts a request with a message to the student" do
      stub_waitlist_api(:request, id: "req-1", fixture: "request")
      save = stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")
      accept = stub_waitlist_api(:change_state, id: "req-1", state: accepted)

      put registration_request_path("req-1"), params: { stateKey: "Accepted", response: "You're in." }

      expect(save.with { |req|
        JSON.parse(req.body).dig("registrationRequest", "descr", "formatted") == "You're in."
      }).to have_been_requested
      expect(accept).to have_been_requested
      expect(response).to redirect_to(registration_requests_url)
    end

    it "opens a course's requests page" do
      stub_waitlist_api(:requests, query: { courseOfferingId: "co-1" }, fixture: "requests")
      stub_waitlist_api(:person, id: "90000001", fixture: "person_student")

      get "/course_offering_requests/co-1"

      expect(response).to have_http_status(:ok)
    end
  end
end
