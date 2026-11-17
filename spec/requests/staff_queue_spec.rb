require "rails_helper"

RSpec.describe "Staff request queue", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }

  before do
    stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "department_requests")
    stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering")
    stub_waitlist_api(:person, id: "90000001", fixture: "person_student")
    stub_waitlist_api(:person, id: "90000002", fixture: "person_other_student")
  end

  context "as staff" do
    before { sign_in create_waitlist_user(:staff) }

    it "lists waiting requests oldest first, with a count for each status" do
      get staff_requests_path

      expect(response).to have_http_status(:ok)
      body = response.body
      expect(body).to include("TEST1101", "Waiting", "Accepted", "Declined")
      expect(body.index(student_name("90000002"))).to be < body.index("Testperson, Avery")
      expect(body).not_to include("kuali.courseregistration")
      tiles = Nokogiri::HTML(body).css(".tile strong").map(&:text)
      expect(tiles).to eq(%w[ 2 1 1 ])
    end

    it "filters by status with the count tiles" do
      get staff_requests_path(status: "accepted")

      rows = Nokogiri::HTML(response.body).css("tbody tr")
      expect(rows.size).to eq(1)
      expect(rows.text).to include(student_name("90000002"), "Accepted")
    end

    it "searches by student name" do
      get staff_requests_path(student: "avery")

      rows = Nokogiri::HTML(response.body).css("tbody tr")
      expect(rows.size).to eq(1)
      expect(rows.text).to include("Testperson, Avery")
    end

    it "sorts newest first when asked" do
      get staff_requests_path(sort: "newest")

      expect(response.body.index("Testperson, Avery")).to be < response.body.index(student_name("90000002"))
    end
  end

  it "is closed to students" do
    sign_in create_waitlist_user(:student)

    get staff_requests_path

    expect(response).to have_http_status(:forbidden)
  end

  def student_name(person_id)
    JSON.parse(waitlist_fixture(person_id == "90000001" ? "person_student" : "person_other_student")).dig("person", "name")
  end
end
