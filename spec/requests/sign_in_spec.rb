require "rails_helper"

RSpec.describe "Sign in", type: :request do
  it "re-checks the role against the API at every sign-in" do
    user = create_waitlist_user(:student)
    stub_waitlist_api(:person, id: "90000001", fixture: "person_staff")

    post user_session_path, params: { user: { email: user.email, password: "test-password-1" } }

    expect(user.reload).to be_staff
  end
end
