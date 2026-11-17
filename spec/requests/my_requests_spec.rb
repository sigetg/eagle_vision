require "rails_helper"

RSpec.describe "My requests", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }

  before do
    stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering")
  end

  context "as a student" do
    before { sign_in create_waitlist_user(:student) }

    it "groups the student's requests by status, with actions only while waiting" do
      stub_waitlist_api(:requests, query: { studentId: "90000001" }, fixture: "department_requests")

      get requests_path

      expect(response).to have_http_status(:ok)
      page = Nokogiri::HTML(response.body)
      expect(page.css("h2").map { |h| h.text.squish }).to eq([ "Waiting (2)", "Accepted (1)", "Declined (1)" ])
      expect(response.body).to include("The section is capped by the fire code.", "Withdraw this request? Staff will no longer see it.")
      expect(page.css("a").count { |link| link.text == "Edit" }).to eq(2)
    end

    it "edits the answers of a waiting request" do
      stub_waitlist_api(:request, id: "req-1", fixture: "request")
      save = stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")

      patch request_path("req-1"), params: { answers: { class_year: "Junior", major: "Finance", reason: "Changed my mind." } }

      expect(response).to redirect_to(requests_path)
      expect(save.with { |req| req.body.include?("Changed my mind.") }).to have_been_requested
    end

    it "withdraws a waiting request by deleting it" do
      stub_waitlist_api(:request, id: "req-1", fixture: "request")
      delete_call = stub_waitlist_api(:delete_request, id: "req-1")

      delete request_path("req-1")

      expect(delete_call).to have_been_requested
      expect(response).to redirect_to(requests_path)
      expect(flash[:notice]).to eq("Request withdrawn")
    end

    it "can't edit or withdraw a decided request" do
      stub_waitlist_api(:request, id: "req-3", fixture: "accepted_request")
      stub_waitlist_api(:person, id: "90000002", fixture: "person_other_student")

      delete request_path("req-3")

      expect(response).to have_http_status(:forbidden)
    end

    it "can't open another student's request" do
      stub_waitlist_api(:request, id: "req-2", fixture: "other_students_request")

      get edit_request_path("req-2")

      expect(response).to have_http_status(:forbidden)
    end
  end

  it "is closed to staff" do
    sign_in create_waitlist_user(:staff)
    stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "requests")

    get requests_path

    expect(response).to have_http_status(:forbidden)
  end
end
