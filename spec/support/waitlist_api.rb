# Test helpers that stand in for BC's waitlist API.
#
# webmock/rspec (required in rails_helper.rb) blocks every real HTTP call, so a
# spec that forgets to stub a call fails loudly instead of reaching the network.
# These helpers stub the calls with the made-up JSON in
# spec/fixtures/waitlist_api/.
module WaitlistApiHelpers
  BASE_URL = "http://127.0.0.1:8080/waitlist".freeze

  # Each endpoint the app calls, by name: [HTTP verb, path template].
  ROUTES = {
    person: [ :get, "/waitlistpersons/%{id}" ],
    course_offerings: [ :get, "/waitlistcourseofferings" ],
    registration_groups: [ :get, "/waitlistregistrationgroups" ],
    activity_offering: [ :get, "/waitlistactivityofferings/%{id}" ],
    create_request: [ :post, "/waitlistrequests" ],
    request: [ :get, "/waitlistrequests/%{id}" ],
    requests: [ :get, "/waitlistrequests" ],
    update_request: [ :put, "/waitlistrequests/%{id}" ],
    change_state: [ :put, "/waitlistrequests/%{id}/changestate/%{state}" ],
    delete_request: [ :delete, "/waitlistrequests/%{id}" ]
  }.freeze

  # The URL for a named endpoint, for example
  #   waitlist_api_url(:person, id: "90000001")
  #   # => "http://127.0.0.1:8080/waitlist/waitlistpersons/90000001"
  def waitlist_api_url(name, **path_params)
    _verb, template = ROUTES.fetch(name)
    BASE_URL + format(template, **path_params)
  end

  # Stubs one endpoint. Returns the WebMock stub, so a spec can later check
  # it was called: expect(stub).to have_been_requested
  #
  #   stub_waitlist_api(:person, id: "90000001", fixture: "person_student")
  #   stub_waitlist_api(:requests, query: { studentId: "90000001" }, fixture: "requests")
  #   stub_waitlist_api(:request, id: "nope", status: 404)
  def stub_waitlist_api(name, fixture: nil, status: 200, query: nil, **path_params)
    verb, _template = ROUTES.fetch(name)
    stub = stub_request(verb, waitlist_api_url(name, **path_params))
    stub = stub.with(query: query) if query
    stub.to_return(
      status: status,
      body: fixture ? waitlist_fixture(fixture) : "",
      headers: { "Content-Type" => "application/json" }
    )
  end

  # The raw JSON text of a fixture file.
  def waitlist_fixture(name)
    Rails.root.join("spec/fixtures/waitlist_api/#{name}.json").read
  end

  # Stubs the person lookup, then creates a user for them. Creating a user
  # calls the API (User#assign_default_role), so the stub must come first.
  def create_waitlist_user(kind)
    person_id, fixture = {
      student: [ "90000001", "person_student" ],
      other_student: [ "90000002", "person_other_student" ],
      staff: [ "90000000", "person_staff" ]
    }.fetch(kind)
    stub_waitlist_api(:person, id: person_id, fixture: fixture)
    create(:user, email: "#{person_id}@bc.edu", person_id: person_id)
  end
end
