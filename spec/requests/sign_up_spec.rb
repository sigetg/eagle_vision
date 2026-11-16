require "rails_helper"

# Sign-up looks the person up in BC's waitlist API by the part of their email
# before the @, then gives them a role from their affiliations.
RSpec.describe "Sign up", type: :request do
  def sign_up(email)
    post user_registration_path, params: {
      user: { email: email, password: "test-password-1", password_confirmation: "test-password-1" }
    }
  end

  it "saves a student with their person id and the user role" do
    stub_waitlist_api(:person, id: "90000001", fixture: "person_student")

    expect { sign_up("90000001@bc.edu") }.to change(User, :count).by(1)

    user = User.last
    expect(user.person_id).to eq(90000001)
    expect(user.has_role?(:user)).to be(true)
    expect(user.has_role?(:admin)).to be(false)
  end

  it "makes someone with a Staff affiliation an admin" do
    stub_waitlist_api(:person, id: "90000000", fixture: "person_staff")

    sign_up("90000000@bc.edu")

    expect(User.last.has_role?(:admin)).to be(true)
  end

  it "shows the not-found page for an email the API doesn't know" do
    stub_waitlist_api(:person, id: "12345", status: 500)

    expect { sign_up("12345@bc.edu") }.not_to change(User, :count)
    expect(response).to have_http_status(:not_found)
  end
end
