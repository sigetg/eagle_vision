require "rails_helper"

# When BC's waitlist API is down or doesn't know an id, people see a page that
# says so, not a Rails crash. ApplicationController's rescue_from does this.
RSpec.describe "When the waitlist API fails", type: :request do
  it "shows the 'not responding' page with status 503 when the API is down" do
    user = create_waitlist_user(:student)
    sign_in user
    # Replace the person stub with one that fails the way a stopped container does.
    stub_request(:get, waitlist_api_url(:person, id: "90000001")).to_raise(Errno::ECONNREFUSED)

    get root_path

    expect(response).to have_http_status(:service_unavailable)
    expect(response.body).to include("The course system isn't responding")
  end

  it "shows the same page when the API is too slow" do
    sign_in create_waitlist_user(:student)
    stub_request(:get, waitlist_api_url(:person, id: "90000001")).to_timeout

    get root_path

    expect(response).to have_http_status(:service_unavailable)
  end

  it "shows a 404 page for a request id the API doesn't know" do
    sign_in create_waitlist_user(:student)
    stub_waitlist_api(:request, id: "nope", status: 404)

    get registration_request_path("nope")

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("We couldn't find that")
  end
end
