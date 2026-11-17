require "rails_helper"

RSpec.describe "The request form", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }
  let(:submitted) { RequestStatus.key_for(:waiting) }
  let(:answers) { { class_year: "Sophomore", major: "Economics", reason: "I need this course." } }

  before do
    sign_in create_waitlist_user(:student)
    stub_waitlist_api(:course_offerings, query: { termId: term_id, code: "" }, fixture: "course_offerings")
    stub_waitlist_api(:registration_groups, query: { courseOfferingId: "co-1" }, fixture: "registration_groups")
  end

  it "shows the chosen sections and warns when a section has open seats" do
    get new_course_request_path("co-1", group: "rg-1")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Request a spot in TEST1101", "Lecture 01", "Discussion 02",
                                      "Seats are open in this section", "Class year", "Graduate")
  end

  it "sends the request in three API calls and stores the answers as JSON" do
    stub_waitlist_api(:create_request, query: { studentId: "90000001", registrationGroupId: "rg-1" }, fixture: "new_request")
    save = stub_waitlist_api(:update_request, id: "req-new", fixture: "updated_request")
    submit = stub_waitlist_api(:change_state, id: "req-new", state: submitted)

    post course_requests_path("co-1"), params: { group: "rg-1", group_ids: [ "rg-1" ], answers: answers }

    expect(response).to redirect_to(requests_path)
    expect(flash[:notice]).to eq("Request sent")
    expect(submit).to have_been_requested
    expect(save.with { |req|
      body = JSON.parse(req.body)
      JSON.parse(body.dig("registrationRequest", "descr", "plain")) == answers.stringify_keys &&
        body.dig("registrationRequestItem", "preferredActivityOfferingIds") == [ "ao-lec-01 ao-dis-02" ]
    }).to have_been_requested
  end

  it "asks again when the reason is missing" do
    post course_requests_path("co-1"), params: { group: "rg-1", answers: answers.merge(reason: "") }

    expect(response).to have_http_status(422)
    expect(response.body).to include("Reason can&#39;t be blank")
  end

  it "is closed to staff" do
    sign_in create_waitlist_user(:staff)
    stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "requests")

    get new_course_request_path("co-1", group: "rg-1")

    expect(response).to have_http_status(:forbidden)
  end
end
