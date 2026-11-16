require "rails_helper"

# ApiService is the only code that talks to BC's waitlist API. Each example
# stubs one endpoint with made-up JSON and checks two things: the request
# ApiService sends, and the Ruby objects it builds from the answer.
RSpec.describe ApiService do
  subject(:api) { described_class.new }

  let(:term_id) { "kuali.atp.FA2023-2024" }
  let(:submitted) { "kuali.courseregistration.request.state.submitted" }

  describe "#fetch_and_map_waitlistperson_and_term" do
    it "returns the person and their active terms" do
      stub_waitlist_api(:person, id: "90000001", fixture: "person_student")

      person, terms = api.fetch_and_map_waitlistperson_and_term("90000001")

      expect(person).to be_a(Person)
      expect(person.id).to eq("90000001")
      expect(person.name).to eq("Testperson, Avery")
      # The 2024 code returns the raw term hashes, not the Term objects it
      # builds. Controllers rely on that (session[:term]["id"]), so the test
      # records it as it is.
      expect(terms.first["id"]).to eq(term_id)
    end

    it "raises NotFound when the API has no such person" do
      # The real API answers 500, not 404, for an unknown person id.
      stub_waitlist_api(:person, id: "123", status: 500)

      expect { api.fetch_and_map_waitlistperson_and_term("123") }
        .to raise_error(ApiService::NotFound, /123/)
    end
  end

  describe "#fetch_and_map_waitlistperson_affiliations_and_authorized_departments" do
    it "returns affiliations and departments" do
      stub_waitlist_api(:person, id: "90000000", fixture: "person_staff")

      affiliations, departments =
        api.fetch_and_map_waitlistperson_affiliations_and_authorized_departments("90000000")

      expect(affiliations.map { |a| a.type["name"] }).to eq(%w[Affilate Staff])
      expect(departments.map(&:longName)).to eq([ "Computer Science" ])
      expect(departments.first).to be_a(Department)
    end
  end

  describe "#fetch_and_map_waitlistcourseofferings" do
    it "searches one term by code and maps each course" do
      stub = stub_waitlist_api(:course_offerings,
                               query: { termId: term_id, code: "TEST" },
                               fixture: "course_offerings")

      courses = api.fetch_and_map_waitlistcourseofferings(term_id, "TEST")

      expect(stub).to have_been_requested
      expect(courses.map(&:courseOfferingCode)).to eq(%w[TEST1101 TEST2201])
      expect(courses.first).to be_a(CourseOffering)
    end
  end

  describe "#fetch_and_map_waitlistactivityofferings" do
    it "maps one section, keeping the first schedule name" do
      stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering")

      section = api.fetch_and_map_waitlistactivityofferings("ao-lec-01")

      expect(section).to be_a(ActivityOffering)
      expect(section.activityCode).to eq("01")
      expect(section.scheduleNames).to eq("Test Hall 101 TuTh 09:00AM-10:15AM")
    end
  end

  describe "#fetch_and_map_waitlistregistrationgroups" do
    it "returns each group with its sections" do
      stub_waitlist_api(:registration_groups, query: { courseOfferingId: "co-1" },
                                              fixture: "registration_groups")

      groups = api.fetch_and_map_waitlistregistrationgroups("co-1")

      expect(groups.size).to eq(1)
      expect(groups.first[:registration_group].name).to eq("01, 02 - Letter - TEST1101")
      expect(groups.first[:activity_offerings].map(&:activityCode)).to eq(%w[01 02])
    end
  end

  describe "#create_waitlist_request" do
    it "posts the student and group, and maps the new request" do
      stub = stub_waitlist_api(:create_request,
                               query: { studentId: "90000001", registrationGroupId: "rg-1" },
                               fixture: "new_request")

      created = api.create_waitlist_request("90000001", "rg-1")

      expect(stub).to have_been_requested
      expect(created[:registrationRequest].id).to eq("req-new")
      expect(created[:registrationRequestItem].studentId).to eq("90000001")
    end
  end

  describe "#get_waitlist_request" do
    it "maps the request and its item" do
      stub_waitlist_api(:request, id: "req-1", fixture: "request")

      found = api.get_waitlist_request("req-1")

      expect(found[:registrationRequest]).to be_a(RegistrationRequest)
      expect(found[:registrationRequest].stateKey).to eq(submitted)
      expect(found[:registrationRequestItem].preferredActivityOfferingIds).to eq([ "ao-lec-01" ])
    end

    it "raises NotFound for an unknown id" do
      stub_waitlist_api(:request, id: "nope", status: 404)

      expect { api.get_waitlist_request("nope") }.to raise_error(ApiService::NotFound)
    end
  end

  describe "#update_waitlist_request" do
    it "puts the request as JSON" do
      stub = stub_waitlist_api(:update_request, id: "req-1", fixture: "updated_request")
      data = api.class.map_to_registration_request(JSON.parse(waitlist_fixture("request")))

      api.update_waitlist_request("req-1", data)

      expect(stub.with(headers: { "Content-Type" => "application/json" }) { |req|
        JSON.parse(req.body).dig("registrationRequest", "id") == "req-1"
      }).to have_been_requested
    end

    it "raises NotFound when the API refuses the update" do
      stub_waitlist_api(:update_request, id: "req-1", status: 404)

      expect { api.update_waitlist_request("req-1", {}) }.to raise_error(ApiService::NotFound)
    end
  end

  describe "request lists" do
    it "#get_waitlist_requests_by_student lists one student's requests" do
      stub_waitlist_api(:requests, query: { studentId: "90000001" }, fixture: "requests")

      expect(api.get_waitlist_requests_by_student("90000001").map { |r| r[:registrationRequest].id })
        .to eq([ "req-1" ])
    end

    it "#get_waitlist_requests_by_course_offering lists a course's requests" do
      stub_waitlist_api(:requests, query: { courseOfferingId: "co-1" }, fixture: "requests")

      expect(api.get_waitlist_requests_by_course_offering("co-1").size).to eq(1)
    end

    it "#get_waitlist_requests_by_term_and_deptId lists a department's requests" do
      stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "requests")

      expect(api.get_waitlist_requests_by_term_and_deptId(term_id, "dept-cs").size).to eq(1)
    end

    it "#get_waitlist_requests_by_term_deptId_and_stateKey filters by status too" do
      stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs", stateKey: submitted },
                                   fixture: "requests")

      expect(api.get_waitlist_requests_by_term_deptId_and_stateKey(term_id, "dept-cs", submitted).size).to eq(1)
    end

    it "#get_waitlist_requests_by_stateKey lists every request in a status" do
      stub_waitlist_api(:requests, query: { stateKey: submitted }, fixture: "requests")

      expect(api.get_waitlist_requests_by_stateKey(submitted).size).to eq(1)
    end

    it "returns an empty list when the API answers with an error" do
      stub_waitlist_api(:requests, query: { studentId: "90000001" }, status: 400)

      expect(api.get_waitlist_requests_by_student("90000001")).to eq([])
    end
  end

  describe "#change_waitlist_request_state" do
    it "puts to the changestate path" do
      stub = stub_waitlist_api(:change_state, id: "req-1", state: submitted)

      api.change_waitlist_request_state("req-1", submitted)

      expect(stub).to have_been_requested
    end

    it "raises NotFound when the API refuses" do
      stub_waitlist_api(:change_state, id: "req-1", state: submitted, status: 404)

      expect { api.change_waitlist_request_state("req-1", submitted) }.to raise_error(ApiService::NotFound)
    end
  end

  describe "#delete_waitlist_request" do
    it "sends a DELETE" do
      stub = stub_waitlist_api(:delete_request, id: "req-1")

      api.delete_waitlist_request("req-1")

      expect(stub).to have_been_requested
    end
  end

  describe "when the API does not answer" do
    it "raises Unavailable when the connection is refused" do
      stub_request(:get, waitlist_api_url(:person, id: "90000001")).to_raise(Errno::ECONNREFUSED)

      expect { api.fetch_and_map_waitlistperson_and_term("90000001") }
        .to raise_error(ApiService::Unavailable)
    end

    it "raises Unavailable when a call times out" do
      stub_request(:put, waitlist_api_url(:change_state, id: "req-1", state: submitted)).to_timeout

      expect { api.change_waitlist_request_state("req-1", submitted) }
        .to raise_error(ApiService::Unavailable)
    end

    it "gives up after 5 seconds" do
      expect(described_class.default_options[:timeout]).to eq(5)
    end
  end

  it "keeps DoesNotExistException as another name for NotFound" do
    expect(ApiService::DoesNotExistException).to be(ApiService::NotFound)
  end
end
