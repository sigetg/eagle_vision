require "rails_helper"

RSpec.describe "Staff request page and decisions", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }
  let(:accepted) { RequestStatus.key_for(:accepted) }
  let(:declined) { RequestStatus.key_for(:declined) }
  let(:waiting) { RequestStatus.key_for(:waiting) }

  before do
    sign_in create_waitlist_user(:staff)
    stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "department_requests")
    stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering")
    stub_waitlist_api(:person, id: "90000001", fixture: "person_student")
    stub_waitlist_api(:request, id: "req-1", fixture: "request")
    stub_waitlist_api(:request, id: "req-3", fixture: "accepted_request")
    stub_waitlist_api(:registration_groups, query: { courseOfferingId: "co-1" }, fixture: "registration_groups")
    stub_waitlist_api(:requests, query: { courseOfferingId: "co-1" }, fixture: "department_requests")
    stub_waitlist_api(:person, id: "90000002", fixture: "person_other_student")
  end

  it "shows the student's answers, the sections with live seats and the decision panel" do
    get staff_request_path("req-1")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Testperson, Avery", "Sophomore", "Economics", "declare the minor",
                                      "30 / 30", "Accept", "Decline", "3 other requests for TEST1101")
  end

  it "accepts with an optional message, saving who decided" do
    save = stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")
    change = stub_waitlist_api(:change_state, id: "req-1", state: accepted)

    post staff_request_decision_path("req-1"), params: { decision: "accept", message: "" }

    expect(response).to have_http_status(:ok)
    expect(change).to have_been_requested
    expect(save.with { |req|
      JSON.parse(JSON.parse(req.body).dig("registrationRequest", "descr", "formatted"))["decided_by"] == "Example, Pat"
    }).to have_been_requested
    expect(response.body).to include("Accepted", "Reopen", "decision_panel")
  end

  it "emails the student after a decision" do
    stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")
    stub_waitlist_api(:change_state, id: "req-1", state: declined)

    expect {
      post staff_request_decision_path("req-1"), params: { decision: "decline", message: "Sorry." }
    }.to have_enqueued_mail(DecisionMailer, :decided)
  end

  it "refuses to decline without a message" do
    change = stub_waitlist_api(:change_state, id: "req-1", state: declined)

    post staff_request_decision_path("req-1"), params: { decision: "decline", message: " " }

    expect(response).to have_http_status(422)
    expect(response.body).to include("Write a message to the student to decline")
    expect(change).not_to have_been_requested
  end

  it "declines with a message" do
    save = stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")
    stub_waitlist_api(:change_state, id: "req-1", state: declined)

    post staff_request_decision_path("req-1"), params: { decision: "decline", message: "The section is full for good." }

    expect(save.with { |req| req.body.include?("The section is full for good.") }).to have_been_requested
    expect(response.body).to include("Declined", "The section is full for good.")
  end

  it "reopens a decided request" do
    stub_waitlist_api(:update_request, id: "req-3", fixture: "updated_request")
    reopen = stub_waitlist_api(:change_state, id: "req-3", state: waiting)

    post staff_request_decision_path("req-3"), params: { decision: "reopen" }

    expect(reopen).to have_been_requested
    expect(response.body).to include("Waiting", "Accept")
  end

  it "won't accept a request that is already accepted" do
    change = stub_waitlist_api(:change_state, id: "req-3", state: accepted)

    post staff_request_decision_path("req-3"), params: { decision: "accept" }

    expect(response).to have_http_status(422)
    expect(change).not_to have_been_requested
  end

  it "refuses a request outside the staff member's departments" do
    other_dept = JSON.parse(waitlist_fixture("activity_offering"))
    other_dept["activityOffering"]["unitsDeploymentOrgIds"] = [ "dept-math" ]
    stub_request(:get, waitlist_api_url(:activity_offering, id: "ao-lec-01")).to_return(body: other_dept.to_json)

    get staff_request_path("req-1")

    expect(response).to have_http_status(:forbidden)
  end
end
