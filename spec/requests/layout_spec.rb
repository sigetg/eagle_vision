require "rails_helper"

RSpec.describe "The frame: sign-in, home pages and top bar", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }

  it "shows one sign-in card, with no Google button unless it is configured" do
    get new_user_session_path

    expect(response.body.scan("<form").size).to eq(1)
    expect(response.body).to include("Sign in with your BC email", "Create an account")
    expect(response.body).not_to include("Sign in with Google")
  end

  it "sends a student to Find courses" do
    sign_in create_waitlist_user(:student)

    get root_path

    expect(response).to redirect_to(controller.send(:student_home_path))
  end

  it "sends staff to their request queue" do
    sign_in create_waitlist_user(:staff)

    get root_path

    expect(response).to redirect_to(controller.send(:staff_home_path))
  end

  it "switches the term and goes back to the same page" do
    sign_in create_waitlist_user(:student)

    patch term_path, params: { term_id: term_id, return_to: "/requests" }

    expect(response).to redirect_to("/requests")
    expect(session[:term]["id"]).to eq(term_id)
  end

  it "ignores a return address on another site" do
    sign_in create_waitlist_user(:student)

    patch term_path, params: { term_id: term_id, return_to: "//evil.example" }

    expect(response).to redirect_to(root_path)
  end
end
