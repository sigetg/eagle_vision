require "rails_helper"

RSpec.describe "Course search", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }

  before { sign_in create_waitlist_user(:student) }

  it "lists the term's courses on the home page" do
    stub_waitlist_api(:course_offerings, query: { termId: term_id, code: "" }, fixture: "course_offerings")

    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Introduction to Testing", "Advanced Fixtures")
  end

  it "searches by course code" do
    search = stub_waitlist_api(:course_offerings, query: { termId: term_id, code: "TEST1101" },
                                                  fixture: "course_offerings")

    get search_path, params: { key: "TEST1101" }

    expect(response).to have_http_status(:ok)
    expect(search).to have_been_requested
  end
end
